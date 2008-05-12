Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbYELSdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbYELSdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 14:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbYELSdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 14:33:33 -0400
Received: from hu-out-0506.google.com ([72.14.214.233]:1733 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbYELSdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 14:33:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=DpiK77IWsGRXy9UGA7QP6teUdUHQ3BnO7Zn/gMDM/zwMPsC7EgRJHijUKuJ4m6MC8/Dn6u1PtCrR5UzSIBcCY5/ppO6gqyTZIy5KDEqi/LwfwYyryJwXTkrviMqbDiNIizq7x6HqscQ4P5rNtfN631ltM+kWTzoQ6X2CUAbJGhs=
Date: Mon, 12 May 2008 20:32:59 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [vfs/tty] possible circular locking dependency detected
Message-ID: <20080512183235.GB6031@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

May 11 08:52:08 [kernel] [   21.052750] Clocksource tsc unstable (delta = -109466779 ns)
May 11 09:42:27 [kernel] [ 1104.496819] rarian-sk-get-c[5630]: segfault at 0 ip 7f478556caf0 sp 7fff8e3fe338 error 4 in libc-2.6.1.so[7f47854f9000+136000]
May 11 10:59:48 [kernel] [ 2494.165792] 
May 11 10:59:48 [kernel] [ 2494.165794] =======================================================
May 11 10:59:48 [kernel] [ 2494.165801] [ INFO: possible circular locking dependency detected ]
May 11 10:59:48 [kernel] [ 2494.165805] 2.6.26-rc1-00007-g91b3a7a #217
May 11 10:59:48 [kernel] [ 2494.165807] -------------------------------------------------------
May 11 10:59:48 [kernel] [ 2494.165809] less/7053 is trying to acquire lock:
May 11 10:59:48 [kernel] [ 2494.165812]  (tasklist_lock){..??}, at: [<ffffffff80232e95>] is_current_pgrp_orphaned+0x15/0x50
May 11 10:59:48 [kernel] [ 2494.165821] 
May 11 10:59:48 [kernel] [ 2494.165822] but task is already holding lock:
May 11 10:59:48 [kernel] [ 2494.165824]  (&tty->ctrl_lock){....}, at: [<ffffffff803d5f31>] tty_check_change+0x61/0x110
May 11 10:59:48 [kernel] [ 2494.165831] 
May 11 10:59:48 [kernel] [ 2494.165832] which lock already depends on the new lock.
May 11 10:59:48 [kernel] [ 2494.165833] 
May 11 10:59:48 [kernel] [ 2494.165835] 
May 11 10:59:48 [kernel] [ 2494.165836] the existing dependency chain (in reverse order) is:
May 11 10:59:48 [kernel] [ 2494.165838] 
May 11 10:59:48 [kernel] [ 2494.165839] -> #2 (&tty->ctrl_lock){....}:
May 11 10:59:48 [kernel] [ 2494.165843]        [<ffffffff80253796>] __lock_acquire+0xf86/0x1080
May 11 10:59:48 [kernel] [ 2494.165851]        [<ffffffff80253922>] lock_acquire+0x92/0xc0
May 11 10:59:48 [kernel] [ 2494.165858]        [<ffffffff804deee0>] _spin_lock_irqsave+0x40/0x60
May 11 10:59:48 [kernel] [ 2494.165866]        [<ffffffff803d31b5>] __proc_set_tty+0x35/0xe0
May 11 10:59:48 [kernel] [ 2494.165873]        [<ffffffff803d76d4>] tty_ioctl+0xbf4/0xfe0
May 11 10:59:48 [kernel] [ 2494.165880]        [<ffffffff802a05e1>] vfs_ioctl+0x31/0x90
May 11 10:59:48 [kernel] [ 2494.165888]        [<ffffffff802a06b3>] do_vfs_ioctl+0x73/0x2d0
May 11 10:59:48 [kernel] [ 2494.165895]        [<ffffffff802a095a>] sys_ioctl+0x4a/0x80
May 11 10:59:48 [kernel] [ 2494.165902]        [<ffffffff8020b5ab>] system_call_after_swapgs+0x7b/0x80
May 11 10:59:48 [kernel] [ 2494.165910]        [<ffffffffffffffff>] 0xffffffffffffffff
May 11 10:59:48 [kernel] [ 2494.165924] 
May 11 10:59:48 [kernel] [ 2494.165925] -> #1 (&sighand->siglock){++..}:
May 11 10:59:48 [kernel] [ 2494.165929]        [<ffffffff80253796>] __lock_acquire+0xf86/0x1080
May 11 10:59:48 [kernel] [ 2494.165936]        [<ffffffff80253922>] lock_acquire+0x92/0xc0
May 11 10:59:48 [kernel] [ 2494.165943]        [<ffffffff804dec1f>] _spin_lock+0x2f/0x40
May 11 10:59:48 [kernel] [ 2494.165951]        [<ffffffff8022d5a3>] copy_process+0x973/0x1210
May 11 10:59:48 [kernel] [ 2494.165959]        [<ffffffff8022df12>] do_fork+0x82/0x2f0
May 11 10:59:48 [kernel] [ 2494.165967]        [<ffffffff8020bfe1>] kernel_thread+0x81/0xde
May 11 10:59:48 [kernel] [ 2494.165974]        [<ffffffff8020c048>] child_rip+0xa/0x12
May 11 10:59:48 [kernel] [ 2494.165981]        [<ffffffffffffffff>] 0xffffffffffffffff
May 11 10:59:48 [kernel] [ 2494.166038] 
May 11 10:59:48 [kernel] [ 2494.166039] -> #0 (tasklist_lock){..??}:
May 11 10:59:48 [kernel] [ 2494.166043]        [<ffffffff802535ab>] __lock_acquire+0xd9b/0x1080
May 11 10:59:48 [kernel] [ 2494.166050]        [<ffffffff80253922>] lock_acquire+0x92/0xc0
May 11 10:59:48 [kernel] [ 2494.166057]        [<ffffffff804dede2>] _read_lock+0x32/0x50
May 11 10:59:48 [kernel] [ 2494.166063]        [<ffffffff80232e95>] is_current_pgrp_orphaned+0x15/0x50
May 11 10:59:48 [kernel] [ 2494.166071]        [<ffffffff803d5f80>] tty_check_change+0xb0/0x110
May 11 10:59:48 [kernel] [ 2494.166078]        [<ffffffff803dac5f>] set_termios+0x1f/0x4c0
May 11 10:59:48 [kernel] [ 2494.166085]        [<ffffffff803db379>] tty_mode_ioctl+0x279/0x3e0
May 11 10:59:48 [kernel] [ 2494.166092]        [<ffffffff803db51d>] n_tty_ioctl+0x3d/0x260
May 11 10:59:48 [kernel] [ 2494.166100]        [<ffffffff803d6c34>] tty_ioctl+0x154/0xfe0
May 11 10:59:48 [kernel] [ 2494.166107]        [<ffffffff802a05e1>] vfs_ioctl+0x31/0x90
May 11 10:59:48 [kernel] [ 2494.166114]        [<ffffffff802a06b3>] do_vfs_ioctl+0x73/0x2d0
May 11 10:59:48 [kernel] [ 2494.166121]        [<ffffffff802a095a>] sys_ioctl+0x4a/0x80
May 11 10:59:48 [kernel] [ 2494.166128]        [<ffffffff8020b5ab>] system_call_after_swapgs+0x7b/0x80
May 11 10:59:48 [kernel] [ 2494.166135]        [<ffffffffffffffff>] 0xffffffffffffffff
May 11 10:59:48 [kernel] [ 2494.166142] 
May 11 10:59:48 [kernel] [ 2494.166143] other info that might help us debug this:
May 11 10:59:48 [kernel] [ 2494.166144] 
May 11 10:59:48 [kernel] [ 2494.166146] 1 lock held by less/7053:
May 11 10:59:48 [kernel] [ 2494.166148]  #0:  (&tty->ctrl_lock){....}, at: [<ffffffff803d5f31>] tty_check_change+0x61/0x110
May 11 10:59:48 [kernel] [ 2494.166155] 
May 11 10:59:48 [kernel] [ 2494.166156] stack backtrace:
May 11 10:59:48 [kernel] [ 2494.166159] Pid: 7053, comm: less Not tainted 2.6.26-rc1-00007-g91b3a7a #217
May 11 10:59:48 [kernel] [ 2494.166161] 
May 11 10:59:48 [kernel] [ 2494.166162] Call Trace:
May 11 10:59:48 [kernel] [ 2494.166168]  [<ffffffff80251223>] print_circular_bug_tail+0x83/0x90
May 11 10:59:48 [kernel] [ 2494.166172]  [<ffffffff80250889>] ? print_circular_bug_entry+0x49/0x60
May 11 10:59:48 [kernel] [ 2494.166178]  [<ffffffff802535ab>] __lock_acquire+0xd9b/0x1080
May 11 10:59:48 [kernel] [ 2494.166184]  [<ffffffff80232e95>] ? is_current_pgrp_orphaned+0x15/0x50
May 11 10:59:48 [kernel] [ 2494.166189]  [<ffffffff80253922>] lock_acquire+0x92/0xc0
May 11 10:59:48 [kernel] [ 2494.166206]  [<ffffffff803d5f80>] tty_check_change+0xb0/0x110
May 11 10:59:48 [kernel] [ 2494.166211]  [<ffffffff803dac5f>] set_termios+0x1f/0x4c0
May 11 10:59:48 [kernel] [ 2494.166216]  [<ffffffff803d3423>] ? tty_ldisc_try+0x23/0x60
May 11 10:59:48 [kernel] [ 2494.166220]  [<ffffffff803d3444>] ? tty_ldisc_try+0x44/0x60
May 11 10:59:48 [kernel] [ 2494.166224]  [<ffffffff804df2c5>] ? _spin_unlock_irqrestore+0x65/0x80
May 11 10:59:48 [kernel] [ 2494.166230]  [<ffffffff803db379>] tty_mode_ioctl+0x279/0x3e0
May 11 10:59:48 [kernel] [ 2494.166234]  [<ffffffff803d3444>] ? tty_ldisc_try+0x44/0x60
May 11 10:59:48 [kernel] [ 2494.166239]  [<ffffffff803db51d>] n_tty_ioctl+0x3d/0x260
May 11 10:59:48 [kernel] [ 2494.166244]  [<ffffffff803d6c34>] tty_ioctl+0x154/0xfe0
May 11 10:59:48 [kernel] [ 2494.166249]  [<ffffffff80252baa>] ? __lock_acquire+0x39a/0x1080
May 11 10:59:48 [kernel] [ 2494.166256]  [<ffffffff80252baa>] ? __lock_acquire+0x39a/0x1080
May 11 10:59:48 [kernel] [ 2494.166263]  [<ffffffff80252baa>] ? __lock_acquire+0x39a/0x1080
May 11 10:59:48 [kernel] [ 2494.166269]  [<ffffffff802a05e1>] vfs_ioctl+0x31/0x90
May 11 10:59:48 [kernel] [ 2494.166274]  [<ffffffff802a06b3>] do_vfs_ioctl+0x73/0x2d0
May 11 10:59:48 [kernel] [ 2494.166280]  [<ffffffff802a095a>] sys_ioctl+0x4a/0x80
May 11 10:59:48 [kernel] [ 2494.166286]  [<ffffffff8020b5ab>] system_call_after_swapgs+0x7b/0x80
May 11 10:59:48 [kernel] [ 2494.166292] 

It was on 2.6.26-rc1 + some patches (afa26be86b65a7183ceac29bdf1f51d6fc6932f0)
I think it had something to do with a hang of my yakuake (KDE terminal emulator) session.
But I'm not sure (I noticed this warning much later)
