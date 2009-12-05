Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbZLEOul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbZLEOul (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 09:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbZLEOuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 09:50:39 -0500
Received: from 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com ([207.172.69.77]:44205
	"EHLO thaum.luto.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755346AbZLEOui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 09:50:38 -0500
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Dec 2009 09:50:38 EST
Message-ID: <4B1A7159.3070101@mit.edu>
Date: Sat, 05 Dec 2009 09:42:33 -0500
From: Andy Lutomirski <luto@mit.edu>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vfs: new O_NODE open flag
References: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu>	<20091202191549.1dbffa2e@lxorguk.ukuu.org.uk>	<E1NFva6-0001AI-0J@pomaz-ex.szeredi.hu> <20091202204828.4fa0c108@lxorguk.ukuu.org.uk> <E1NG4WJ-00026r-GE@pomaz-ex.szeredi.hu>
In-Reply-To: <E1NG4WJ-00026r-GE@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> On Wed, 2 Dec 2009, Alan Cox wrote:
>>> You're still missing the point.  O_NODE is like a hard link, except
>>> the reference doesn't come from the filesystem but from a file
>>> descriptor.  From udev's perspective there's no difference.
>> I don't think I am missing the point here. You have a reference to an
>> object in the fs but you don't have a reference to the driver underneath
>> s the driver can change on you *while* you have the O_NODE open and fd
>> live. That cannot happen with a hard link and open.
>>
>> It isn't the same thing as far as I can see. You don't have the barrier
>> between the operations that occurs in the real open/close case because
>> they lock the driver.
> 
> The file descriptor opened with O_NODE allows exaclactly the same
> operations that a hard link to the device would, nothing more.  It's
> just a link to the *node*, except it doesn't increment the link count,
> the driver is irrelevant.
> 

I don't know what that means.  Do you mean that if:

root creates /dev/foo with 0666 perms
eviluser opens /dev/foo with O_NODE
root chmods /dev/foo to 0000
root unlinks /dev/foo

then eviluser can't open /proc/self/fd/whatever for O_RDRW

Because if eviluser could still open /proc/self/fd/whatever for O_RDRW 
(or anything else for that matter if O_NODE isn't set) then you have a 
security problem.

--Andy
