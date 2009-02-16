Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbZBPVk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbZBPVk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 16:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZBPVkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 16:40:11 -0500
Received: from rv-out-0506.google.com ([209.85.198.231]:59722 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbZBPVkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 16:40:09 -0500
Message-ID: <4999DD31.4010504@gawab.com>
Date: Mon, 16 Feb 2009 13:40:01 -0800
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090213)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux IDE <linux-ide@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Hugh Dickins <hugh@veritas.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #12263] Sata soft reset filling log
References: <sTyoMUwdm9B.A.QCH.U40lJB@chimera> <200902152221.43834.rjw@sisk.pl> <20090215223045.GC29300@elte.hu> <200902160012.57584.rjw@sisk.pl> <499983DF.5050503@ru.mvista.com> <49998480.3090408@ru.mvista.com> <499986D0.3000205@ru.mvista.com> <4999BD1A.1060101@gawab.com> <4999C195.5050905@ru.mvista.com>
In-Reply-To: <4999C195.5050905@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov wrote:

> Hello.
>> Justin Madru wrote:
>>> After referring to the SCSI command codes "cdb 0x1e" means ALLOW 
>>> MEDIUM REMOVAL command -- which
>>> could hardly be addressed to an usual hard disk. So, it looks like 
>>> we had a case of the confused bug report which
>>> has a lot of info on the hard disk while errors were most probably 
>>> happening with a CD/DVD drive.
>>
>> Yes, I originally thought it was my hard disk because the kernel logs 
>> showed ata2.
>> But, Tejun Heo figured out it was my DVD drive (ATAPI) that was on 
>> the ata2 link.
>> (see http://marc.info/?l=linux-kernel&m=122993014109646&w=2)
>> I tried to bisect it, but around .28-rc1 I began to get numerous 
>> compile errors, so couldn't continue.
>> I also tried patches that Tejun sent me, but non of them worked, it 
>> just slightly change the error message.
>> So, yes this is a regression that was introduced in the .28 merge 
>> window, and I still think that bug #12609 is a duplicate of my bug.
>
> If 12609 is truly a post-2.6.28 regression and 12263 is post-2.6.27 
> regresssion, this just cannot be.

Maybe the reporter of #12609 didn't notice/test kernels 28-rc1 to 28. Or 
maybe the difference in hardware is
the issue, but the bug is still the same. Don't know.


>> I don't see this bug on tip/master and this is the diff of origin and 
>> tip at the time I tested.
>> $ git diff origin/master..tip/master drivers/ata/
>
> What tree is that?

This is what I have in .git/config and I get the same diff if I run:
git diff master..tip drivers/ata/  or  git diff master...tip drivers/ata/

[core]
    repositoryformatversion = 0
    filemode = true
    bare = false
    logallrefupdates = true
[remote "origin"]
    url = 
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    fetch = +refs/heads/*:refs/remotes/origin/*
[branch "master"]
    remote = origin
    merge = refs/heads/master
[remote "tip"]
    url = 
git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
    fetch = +refs/heads/*:refs/remotes/tip/*
[branch "tip"]
    remote = tip
    merge = refs/heads/master

Justin Madru
