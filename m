Return-Path: <linux-kernel-owner+w=401wt.eu-S934311AbYEFXja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934311AbYEFXja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 19:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765015AbYEFXjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 19:39:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755156AbYEFXjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 19:39:17 -0400
Message-ID: <4820EC0E.1030603@redhat.com>
Date: Tue, 06 May 2008 16:38:54 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] fix UML on x86-64
References: <200805062304.m46N4h6d007206@devserv.devel.redhat.com> <alpine.LFD.1.10.0805061625090.32269@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805061625090.32269@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:
> It breaks things how?

A crash on startup:

Program received signal SIGTERM, Terminated.
0x00000038d6431357 in kill () from /lib64/libc.so.6
Missing separate debuginfos, use: debuginfo-install glibc.x86_64
(gdb) bt
#0  0x00000038d6431357 in kill () from /lib64/libc.so.6
#1  0x00000000600201ef in os_dump_core () at arch/um/os-Linux/util.c:92
#2  0x000000006001379f in panic_exit (self=<value optimized out>,
unused1=<value optimized out>, unused2=<value optimized out>)
    at arch/um/kernel/um_arch.c:233
#3  0x00000000600409c5 in notifier_call_chain (nl=<value optimized out>,
val=0, v=0x6022c9c0, nr_to_call=-2, nr_calls=0x0)
    at kernel/notifier.c:85
#4  0x00000000600409f6 in __atomic_notifier_call_chain (nh=0x0, val=15,
v=0x6001e4e1, nr_to_call=-1, nr_calls=0x61c1f6e0)
    at kernel/notifier.c:174
#5  0x0000000060040a07 in atomic_notifier_call_chain (nh=0x0, val=15,
v=0x6001e4e1) at kernel/notifier.c:183
#6  0x000000006002b199 in panic (fmt=0x601989a1 "Attempted to kill
init!") at kernel/panic.c:101
#7  0x000000006002e593 in do_exit (code=11) at kernel/exit.c:965
#8  0x000000006002ec24 in do_group_exit (exit_code=11) at kernel/exit.c:1143
#9  0x0000000060037647 in get_signal_to_deliver (info=0x61c1fa30,
return_ka=0x61c1fab0, regs=0x61c1ca70,
    cookie=<value optimized out>) at kernel/signal.c:1831
#10 0x0000000060011c01 in do_signal () at arch/um/kernel/signal.c:100
#11 0x00000000600135ee in fatal_sigsegv () at arch/um/kernel/trap.c:135
#12 0x0000000060021917 in wait_stub_done (pid=4384) at
arch/um/os-Linux/skas/process.c:94
#13 0x00000000600210a0 in do_syscall_stub (mm_idp=0x61f4fd28,
addr=0x61c1fd18) at arch/um/os-Linux/skas/mem.c:86
#14 0x0000000060021302 in run_syscall_stub (mm_idp=0x61f4fd28,
syscall=154, args=0x61c1fc00, expected=0, addr=0x61c1fd18, done=1)
    at arch/um/os-Linux/skas/mem.c:155
#15 0x0000000060022666 in write_ldt_entry (mm_idp=0x61f4fd28, func=1,
desc=<value optimized out>, addr=0x61c1fd18, done=1)
    at arch/um/sys-x86_64/../sys-i386/ldt.c:72
#16 0x00000000600228b4 in init_new_ldt (new_mm=0x61f4fd28,
from_mm=<value optimized out>)
    at arch/um/sys-x86_64/../sys-i386/ldt.c:425
#17 0x0000000060013b6c in init_new_context (task=<value optimized out>,
mm=<value optimized out>) at arch/um/kernel/skas/mmu.c:87
#18 0x000000006006d66e in bprm_mm_init (bprm=0x61c62dc0) at fs/exec.c:346
#19 0x000000006006e33a in do_execve (filename=0x60191c1c "/bin/sh",
argv=0x601c6440, envp=0x601c6020, regs=0x61c1ca70)
    at fs/exec.c:1287
#20 0x000000006000fe2f in execve1 (file=0x0, argv=0xf, env=0x6001e4e1)
at arch/um/kernel/exec.c:62
#21 0x000000006000fea7 in um_execve (file=0x0, argv=0xf, env=0x6001e4e1)
at arch/um/kernel/exec.c:78
#22 0x0000000060011f28 in kernel_execve (filename=0x0, argv=0xf,
envp=0x6001e4e1) at arch/um/kernel/syscall.c:129
#23 0x000000006000fbf2 in run_init_process (init_filename=0x0) at
init/main.c:789
#24 0x000000006000fcc7 in init_post () at init/main.c:831
#25 0x0000000060001546 in kernel_init (unused=<value optimized out>) at
init/main.c:884
#26 0x000000006001e5e1 in run_kernel_thread (fn=0x6000139c
<kernel_init>, arg=0x0, jmp_ptr=<value optimized out>)
    at arch/um/os-Linux/process.c:267
#27 0x0000000060011094 in new_thread_handler () at
arch/um/kernel/process.c:151
#28 0x0000000000000000 in ?? ()


- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIIOwN2ijCOnn/RHQRAqIbAJ48M4xgOGBOWaKdNcWIl7ZENJaYEQCfccJM
OS7U3mc48z4UpodpagTwt2M=
=Fv45
-----END PGP SIGNATURE-----
