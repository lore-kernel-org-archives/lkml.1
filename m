Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbZECH3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbZECH3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 03:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbZECH3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 03:29:23 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:46737 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbZECH3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 03:29:22 -0400
Message-ID: <49FD47D0.2070802@msgid.tls.msk.ru>
Date: Sun, 03 May 2009 11:29:20 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
CC: Kay Sievers <kay.sievers@vrfy.org>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Jan Blunck <jblunck@suse.de>, linux-arch@vger.kernel.org,
       viro@zeniv.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       adam@yggdrasil.com
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
References: <1241097822.2516.3.camel@poy> <20090502071636.GA9487@infradead.org>	 <ac3eb2510905020434k57b561f7ld3db423f3dba26f0@mail.gmail.com>	 <9b2b86520905021322l31845d2dubad98d78380aa1d5@mail.gmail.com>	 <ac3eb2510905021439r2cef54fbja601f140d76ad623@mail.gmail.com> <9b2b86520905021504r3d32045ke1c14ffff1ffc898@mail.gmail.com>
In-Reply-To: <9b2b86520905021504r3d32045ke1c14ffff1ffc898@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> On 5/2/09, Kay Sievers <kay.sievers@vrfy.org> wrote:
[]
>>> And it
>>> gives a nice clean way for new initramfs' to test for this feature -
>>> when they try to mount it, it fails.  It would seem to make for a
>>> rather smoother migration path.
>> I think that is all covered just fine.
> 
> Oh, I see.
> 
> grep "/dev" /proc/mounts > /dev/null

Oh no.  This one will match all your /dev/sda1 etc too :)
What yo want to do is either

   grep -w /dev /proc/mount

or

  awk '$2 == "/dev" { exit 0; } END { exit 1; }' /proc/mounts

or something similar.  To distinguish between the following
two cases:

/dev/sda1 / ext3 rw,noatime,data=ordered 0 0
devfs /dev tmpfs rw,nosuid,size=512k,mode=755 0 0

/mjt
