Return-Path: <linux-kernel-owner+w=401wt.eu-S1758192AbYCCOqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192AbYCCOqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbYCCOp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:45:56 -0500
Received: from styx.suse.cz ([82.119.242.94]:43190 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757930AbYCCOpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:45:55 -0500
Date: Mon, 3 Mar 2008 15:45:53 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Olsa <olsajiri@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nadia Derbey <Nadia.Derbey@bull.net>, peifferp@gmail.com
Subject: Re: [BUG] soft lockup detected with ipcs
In-Reply-To: <47CC055C.5090001@gmail.com>
Message-ID: <Pine.LNX.4.64.0803031526230.15209@jikos.suse.cz>
References: <47C7E280.4010805@gmail.com> <Pine.LNX.4.64.0802291241080.7699@twin.jikos.cz>
 <47CAE7D5.5040907@gmail.com> <20080302120236.61e0ec74.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0803022214190.15209@jikos.suse.cz>
 <Pine.LNX.4.64.0803022223360.15209@jikos.suse.cz> <47CBE871.4090309@gmail.com>
 <Pine.LNX.4.64.0803031305090.15209@jikos.suse.cz> <47CBECB8.7040605@gmail.com>
 <Pine.LNX.4.64.0803031324200.15209@jikos.suse.cz> <47CBF12C.2070506@gmail.com>
 <47CC055C.5090001@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Jiri Olsa wrote:

> your patch with LOCKDEP enabled:
> ipcs.strace.1		- strace of ipcs from the first run
> ipcs.kernel.out.1 	- kernel logs from 1st strace ipcs run

> [   49.465371] info: dee9fca4
> [   49.465397] BUG: unable to handle kernel NULL pointer dereference at virtual address 000000bf
> [   49.465411] printing eip: c0133034 *pde = 00000000
> [   49.465432] Oops: 0002 [#1]
> [   49.465445] Modules linked in: netconsole i915 drm configfs e1000 snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer snd snd_page_alloc
> [   49.465534]
> [   49.465542] Pid: 4763, comm: ipcs Not tainted (2.6.24.3test-dirty #22)
> [   49.465550] EIP: 0060:[<c0133034>] EFLAGS: 00010086 CPU: 0
> [   49.465568] EIP is at __lock_acquire+0x319/0xc20
> [   49.465575] EAX: 00000002 EBX: 00000246 ECX: dee9fcb4 EDX: 00000002
> [   49.465583] ESI: ffffffff EDI: 00000000 EBP: d8c9fe74 ESP: d8c9fe18
> [   49.465591]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [   49.465599] Process ipcs (pid: 4763, ti=d8c9e000 task=d8d181b0 task.ti=d8c9e000)
> [   49.465606] Stack: 00000012 c0456032 d8c9fea4 00000246 d8c9fe66 c03875bc 00000002 00000000
> [   49.465667]        00000000 dee9fcb4 845dad28 d8d181b0 00000031 00000000 000001e1 00000246
> [   49.465731]        00000021 845dad28 1bbd0328 373c0000 00000246 00000000 00000000 d8c9fe9c
> [   49.465792] Call Trace:
> [   49.465803]  [<c0103e9f>] show_trace_log_lvl+0x1a/0x2f
> [   49.465820]  [<c0103f51>] show_stack_log_lvl+0x9d/0xa5
> [   49.465841]  [<c0104006>] show_registers+0xad/0x17c
> [   49.465859]  [<c01041cc>] die+0xf7/0x1c8
> [   49.465872]  [<c0110e31>] do_page_fault+0x464/0x54b
> [   49.465886]  [<c030108a>] error_code+0x6a/0x70
> [   49.465904]  [<c01339b3>] lock_acquire+0x78/0x91
> [   49.465918]  [<c0300a55>] _spin_lock+0x2e/0x58
> [   49.465931]  [<c01b8e91>] sys_shmctl+0x70b/0x78a
> [   49.465947]  [<c0106d33>] sys_ipc+0x19f/0x1b5
> [   49.465964]  [<c0102fa6>] syscall_call+0x7/0xb
> [   49.465977]  =======================
> [   49.465984] Code: 00 85 c0 0f 84 1d 09 00 00 83 3d 00 bf 6f c0 00 0f 85 
> 10 09 00 00 c7 44 24 0c c8 8b 30 c0 c7 44 24 08 26 03 00 00 e9 8b 07 00 
> 00 <ff> 86 c0 00 00 00 8b 45 d0 8b 80 54 06 00 00 83 f8 1d 89 45 cc

OK, so the actual NULL pointer dereference happens inside atomic_inc(), 
during incrementing of counter->v (as %esi == 0xffffffff). So apparently 
someone corrupted spinlock_t for shmem_inode_info.lock, which is being 
obtained in shm_get_stat().

-- 
Jiri Kosina
SUSE Labs
