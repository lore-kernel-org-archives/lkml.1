Return-Path: <linux-kernel-owner+w=401wt.eu-S965668AbXDGIs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965668AbXDGIs5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 04:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965673AbXDGIs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 04:48:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:9247 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965662AbXDGIsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 04:48:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=rfOINxa0GCz9UIfA21+Zk2777HqyLQ8e77PxDa9nEhInNWrDrbx8URVYARbuScdOVOT5y+b2h1J9AfCgy3wpB1HdA2YQ6D4y+6NEaUjSvc9Qi1lEeeXc8dMWMtZpJE67jl8F8VznxNJfj5IOuINCAAnDMeY04APazbtYFxPmL4o=
Message-ID: <46175AE3.9000701@googlemail.com>
Date: Sat, 07 Apr 2007 10:48:35 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Linux 2.6.21-rc6
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This looks like a lockdep problem.
2.6.21-rc6
+ hrtimers_debug.patch (from Ingo)
- skge_wol_support (commit a504e64ab42bcc27074ea37405d06833ed6e0820) dropped due to
swsusp problems

[14016.726946] BUG: at /mnt/md0/devel/linux-git/kernel/lockdep.c:2427 check_flags()
[14016.734331]  [<c0105039>] show_trace_log_lvl+0x1a/0x2f
[14016.739507]  [<c0105720>] show_trace+0x12/0x14
[14016.743982]  [<c01057d2>] dump_stack+0x16/0x18
[14016.748460]  [<c013b57f>] check_flags+0x95/0x143
[14016.753106]  [<c013e334>] lock_acquire+0x29/0x82
[14016.757741]  [<c01369dc>] down_write+0x3a/0x54
[14016.762203]  [<c0163be2>] sys_munmap+0x23/0x3f
[14016.766661]  [<c0104060>] syscall_call+0x7/0xb
[14016.771134]  =======================
[14016.774712] irq event stamp: 43076
[14016.778111] hardirqs last  enabled at (43075): [<c0104189>] syscall_exit_work+0x11/0x26
[14016.786166] hardirqs last disabled at (43076): [<c0103f09>] ret_from_exception+0x9/0xc
[14016.794118] softirqs last  enabled at (42608): [<c012653b>] __do_softirq+0xe4/0xea
[14016.801706] softirqs last disabled at (42599): [<c01069b5>] do_softirq+0x64/0xd1

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc6/git-console.log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc6/git-config

BTW. I noticed some strange fio (1.15) behavior
Starting 16 processes
file:io_u.c:65, assert idx < f->num_maps failed[  1605/ 36442 kb/s] [eta 00m:32s]
fio: pid=13734, got signal=11
file:io_u.c:65, assert idx < f->num_maps failed[ 10452/     0 kb/s] [eta 00m:23s]
fio: pid=13731, got signal=11

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
