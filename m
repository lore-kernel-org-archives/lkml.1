Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372AbYA3Nhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbYA3Nhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYA3NhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:37:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:33222 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbYA3NhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:37:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Ck0KMKQCZE5huMLmO9lGINPkgQ3XeTPqZ59Gv01kDILSY4mGXWcJ+TU2knxFxyPl9YE6oR+KiWK1ddNIN6fjRfjVnNoW3Ys/4bGTi26AS8uV5DsJN0kFKrPCxgflh0OH2DHwhZcbGL2RWe/j8yrRf5RC9QC4hZGIJyiSuqs6yX8=
Message-ID: <47A07D76.6010605@gmail.com>
Date: Wed, 30 Jan 2008 16:36:54 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Joel Schopp <jschopp@austin.ibm.com>,
       Dmitri Vorobiev <dmitri.vorobiev@gmail.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>, trivial@kernel.org,
       linux-fsdevel@vger.kernel.org, apw@shadowen.org, rdunlap@xenotime.net,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 8/9] bfs: remove multiple assignments
References: <1201296027-6900-1-git-send-email-dmitri.vorobiev@gmail.com> <1201296027-6900-9-git-send-email-dmitri.vorobiev@gmail.com> <Pine.LNX.4.61.0801261833270.1966@ginsburg.homenet> <479BC6E5.5000409@gmail.com> <479D7DEB.7070806@austin.ibm.com> <20080130130656.GI27894@ZenIV.linux.org.uk>
In-Reply-To: <20080130130656.GI27894@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Mon, Jan 28, 2008 at 01:02:03AM -0600, Joel Schopp wrote:
>>>>> -    inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
>>>>> +    inode->i_mtime = CURRENT_TIME_SEC;
>>>>> +    inode->i_atime = CURRENT_TIME_SEC;
>>>>> +    inode->i_ctime = CURRENT_TIME_SEC;
>>>> multiple assignments like "x = y = z = value;" can potentially
>>>> (depending on the compiler and arch) be faster than "x = value; y =
>>>> value; z=value;"
>>>>
>>>> I am surprized that this script complains about them as it is a
>>>> perfectly valid thing to do in C.
>>> I think it seems wise to ask the maintainers of checkpatch.pl to
>>> comment on that. I'm Cc:ing them now.
>>>
>> There are plenty of things that are valid to do in C that don't make for 
>> maintainable code.  These scripts are designed to make your code easier for 
>> real people to review and maintain.
> 
> Except that in this case the new variant is not equivalent to the old one...

Yes, you're right. In fact, I felt like sending yet another version
of these patches, but this gets preempted all the time by "the other things".

Dmitri
