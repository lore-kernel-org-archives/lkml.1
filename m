Return-Path: <linux-kernel-owner+w=401wt.eu-S934130AbXKOWfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934130AbXKOWfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:35:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933979AbXKOWf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:35:28 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:59535 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441AbXKOWfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:35:22 -0500
Date: Thu, 15 Nov 2007 23:35:20 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, wfg@mail.ustc.edu.cn
Subject: Re: Temporary lockup on loopback block device
In-Reply-To: <E1IrZOV-0005Q0-00@dorka.pomaz.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0711152332310.11345@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0711102025440.17691@artax.karlin.mff.cuni.cz> 
 <20071110145444.a6993df1.akpm@linux-foundation.org> <1194735752.5828.1.camel@lappy>
 <Pine.LNX.4.64.0711110135450.18189@artax.karlin.mff.cuni.cz>
 <E1Ir7al-0004Tm-00@dorka.pomaz.szeredi.hu> <Pine.LNX.4.64.0711111926070.19188@artax.karlin.mff.cuni.cz>
 <E1IrZOV-0005Q0-00@dorka.pomaz.szeredi.hu>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > On 2.6.23 it could happen even without loopback
> 
> Let's focus on this point, because we already know how the lockup
> happens _with_ loopback and any other kind of bdi stacking.
> 
> Can you describe the setup?  Or better still, can you reproduce it and
> post the sysrq-t output?

Hi

The trace is this, it is perfectly reproducible. It is 128M machine, 
Pentium 2 300MHz, host filesystem ext2, loop filesystems ext2 and spadfs 
(both of them locked up). But the problem is really over in 2.6.24, I 
think there is no more need to investigate it.

Mikulas

Nov 10 19:34:45 gerlinda kernel: SysRq : HELP : loglevel0-8 reBoot tErm 
Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync 
showTasks Unmount shoW-blocked-tasks
Nov 10 19:34:53 gerlinda kernel: SysRq : Show Blocked State
Nov 10 19:34:53 gerlinda kernel:   task                PC stack   pid 
father
Nov 10 19:34:54 gerlinda kernel: dd            D 00000286     0  4603   
2985
Nov 10 19:34:55 gerlinda kernel:        c580bcdc 00000086 c0308c20 
00000286 00000286 c580bcec 002a4e87 00000000
Nov 10 19:34:55 gerlinda kernel:        c580bd10 c0284bba c580bd1c 
00000000 c03775e0 c03775e0 002a4e87 c011d050
Nov 10 19:34:55 gerlinda kernel:        c117c030 c03771a0 00000064 
c02f8eb4 c0283efe c580bd44 c0145ebc 00000000
Nov 10 19:34:55 gerlinda kernel: Call Trace:
Nov 10 19:34:55 gerlinda kernel:  [<c0284bba>] schedule_timeout+0x4a/0xc0
Nov 10 19:34:55 gerlinda kernel:  [<c011d050>] process_timeout+0x0/0x10
Nov 10 19:34:55 gerlinda kernel:  [<c0283efe>] 
io_schedule_timeout+0xe/0x20
Nov 10 19:34:55 gerlinda kernel:  [<c0145ebc>] congestion_wait+0x6c/0x90
Nov 10 19:34:55 gerlinda kernel:  [<c01274e0>] 
autoremove_wake_function+0x0/0x50Nov 10 19:34:55 gerlinda kernel:  
[<c014135f>] balance_dirty_pages_ratelimited_nr+0x11f/0x1e0
Nov 10 19:34:55 gerlinda kernel:  [<c013cb98>] 
generic_file_buffered_write+0x2f8/0x6f0
Nov 10 19:34:55 gerlinda kernel:  [<c01198b7>] irq_exit+0x47/0x70
Nov 10 19:34:55 gerlinda kernel:  [<c01049e7>] do_IRQ+0x47/0x80
Nov 10 19:34:55 gerlinda kernel:  [<c0102cbf>] common_interrupt+0x23/0x28
Nov 10 19:34:55 gerlinda kernel:  [<c013d1e3>] 
__generic_file_aio_write_nolock+0x253/0x540
Nov 10 19:34:55 gerlinda kernel:  [<c012a87b>] 
hrtimer_run_queues+0x6b/0x290
Nov 10 19:34:55 gerlinda kernel:  [<c013d526>] 
generic_file_aio_write+0x56/0xd0 Nov 10 19:34:55 gerlinda kernel:  
[<c012ed9f>] tick_handle_periodic+0xf/0x70
Nov 10 19:34:55 gerlinda kernel:  [<c015a1d6>] do_sync_write+0xc6/0x110
Nov 10 19:34:55 gerlinda kernel:  [<c01274e0>] 
autoremove_wake_function+0x0/0x50Nov 10 19:34:55 gerlinda kernel:  
[<c01c604f>] clear_user+0x2f/0x50
Nov 10 19:34:55 gerlinda kernel:  [<c0120000>] ptrace_notify+0x30/0x90
Nov 10 19:34:55 gerlinda kernel:  [<c015aa56>] vfs_write+0xa6/0x140
Nov 10 19:34:55 gerlinda kernel:  [<c8926310>] SPADFS_FILE_WRITE+0x0/0x10 
[spadfs]
Nov 10 19:34:55 gerlinda kernel:  [<c015b031>] sys_write+0x41/0x70
Nov 10 19:34:55 gerlinda kernel:  [<c0102b16>] syscall_call+0x7/0xb
Nov 10 19:34:55 gerlinda kernel:  =======================


> Thanks,
> Miklos
> 
