Return-Path: <linux-kernel-owner+w=401wt.eu-S1757548AbYEMB6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbYEMB6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 21:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756596AbYEMB6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 21:58:24 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57693 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756554AbYEMB6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 21:58:23 -0400
Subject: Re: Oops on -rc2-git1, possibly md_raid1 or xfs related. (Was: Re:
	Linux 2.6.26-rc2)
From: Kasper Sandberg <lkml@metanurb.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1210643358.1093.14.camel@localhost>
References: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org>
	 <1210643358.1093.14.camel@localhost>
Content-Type: text/plain
Date: Tue, 13 May 2008 03:55:34 +0200
Message-Id: <1210643734.1093.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-13 at 03:49 +0200, Kasper Sandberg wrote:
> Just booted -rc2-git1, and got an oops(entier dmesg):
<snip>
> max_pfn_mapped = 1245184
> x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> init_memory_mapping
<snip>
> ------------[ cut here ]------------
> WARNING: at include/linux/blkdev.h:443 blk_remove_plug+0x71/0xa0()
> Modules linked in:
> Pid: 460, comm: md1_raid1 Not tainted 2.6.26-rc2-git1 #1
> 
> Call Trace:
>  [<ffffffff80232b04>] warn_on_slowpath+0x64/0xc0
>  [<ffffffff803609a9>] __next_cpu+0x19/0x30
>  [<ffffffff8022ac8c>] find_busiest_group+0x22c/0x8d0
>  [<ffffffff803551a1>] blk_remove_plug+0x71/0xa0
>  [<ffffffff804219fb>] flush_pending_writes+0x3b/0x90
>  [<ffffffff80421b4c>] raid1d+0x4c/0xf60
>  [<ffffffff8022f2fb>] hrtick_set+0x7b/0x160
>  [<ffffffff804acb50>] thread_return+0x5e/0x57e
>  [<ffffffff804ad32d>] schedule_timeout+0xad/0xf0
>  [<ffffffff804299e7>] md_thread+0x47/0x120
>  [<ffffffff80248df0>] autoremove_wake_function+0x0/0x30
>  [<ffffffff804299a0>] md_thread+0x0/0x120
>  [<ffffffff80248a47>] kthread+0x47/0x90
>  [<ffffffff8022fe87>] schedule_tail+0x27/0x60
>  [<ffffffff8020c598>] child_rip+0xa/0x12
>  [<ffffffff80248a00>] kthread+0x0/0x90
>  [<ffffffff8020c58e>] child_rip+0x0/0x12
> 
> ---[ end trace a97097b29774f236 ]---
<snip>
> The system appeared to work, for the few minutes i had it running,
> before i went back to .25.

Just a thought, could it be the x86 PAT? the reason i dont just test it,
is because i dont want to unnessecarily risk the data on my disks, if
you may easily be able to rule that out or something, given the call
trace :)

> 
> On Mon, 2008-05-12 at 07:55 -0700, Linus Torvalds wrote:
> <snip>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

