Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbYAUU6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbYAUU6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 15:58:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYAUU6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 15:58:46 -0500
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:41653 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbYAUU6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@VGER.KERNEL.ORG>);
	Mon, 21 Jan 2008 15:58:45 -0500
Subject: 2.6.24 regression: pan hanging unkilleable and un-straceable
From: Frederik Himpe <fhimpe@telenet.be>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Mon, 21 Jan 2008 21:58:06 +0100
Message-Id: <1200949086.6648.19.camel@Anastacia>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5-1mdv2008.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With Linux 2.6.24-rc8 I often have the problem that the pan usenet
reader starts using 100% of CPU time after some time. When this happens,
kill -9 does not work, and strace just hangs when trying to attach to
the process. The same with gdb. ﻿ps shows the process as being in the R
state.

I pressed Ctrl-Alt-SysRq-T, and this was shown for pan:
Jan 21 21:45:01 Anastacia kernel: pan           R  running task        0  8063      1
Jan 21 21:45:01 Anastacia kernel: ssh           S 0000000000000000     0  8323   6809
Jan 21 21:45:01 Anastacia kernel:  ffff81000a51f9c8 0000000000000082 ffff81000ed6dc00 ffffffff8045ad6f
Jan 21 21:45:01 Anastacia kernel:  ffffffff805875b8 ffffffff80623980 ffffffff80623980 ffffffff80623980
Jan 21 21:45:01 Anastacia kernel:  ffffffff8061fe80 ffffffff80623980 ffff81003941b8a8 ffffffff8043142b
Jan 21 21:45:01 Anastacia kernel: Call Trace:
Jan 21 21:45:01 Anastacia kernel:  [arp_bind_neighbour+143/208] arp_bind_neighbour+0x8f/0xd0
Jan 21 21:45:01 Anastacia kernel:  [rt_intern_hash+955/1056] rt_intern_hash+0x3bb/0x420
Jan 21 21:45:01 Anastacia kernel:  [nommu_map_single+56/96] nommu_map_single+0x38/0x60
Jan 21 21:45:01 Anastacia kernel:  [schedule_timeout+149/208] schedule_timeout+0x95/0xd0
Jan 21 21:45:01 Anastacia kernel:  [tty_ldisc_deref+82/128] tty_ldisc_deref+0x52/0x80
Jan 21 21:45:01 Anastacia kernel:  [tty_poll+145/160] tty_poll+0x91/0xa0
Jan 21 21:45:01 Anastacia kernel:  [do_select+1128/1376] do_select+0x468/0x560
Jan 21 21:45:01 Anastacia kernel:  [__pollwait+0/304] __pollwait+0x0/0x130
Jan 21 21:45:01 Anastacia kernel:  [default_wake_function+0/16] default_wake_function+0x0/0x10
Jan 21 21:45:01 Anastacia kernel:last message repeated 2 times
Jan 21 21:45:01 Anastacia kernel:  [enqueue_task+19/48] enqueue_task+0x13/0x30
Jan 21 21:45:01 Anastacia kernel:  [try_to_wake_up+98/720] try_to_wake_up+0x62/0x2d0
Jan 21 21:45:01 Anastacia kernel:  [default_wake_function+0/16] default_wake_function+0x0/0x10
Jan 21 21:45:01 Anastacia kernel:  [tcp_recvmsg+1463/3360] tcp_recvmsg+0x5b7/0xd20
Jan 21 21:45:01 Anastacia kernel:  [__wake_up_common+90/144] __wake_up_common+0x5a/0x90
Jan 21 21:45:01 Anastacia kernel:  [__wake_up+67/112] __wake_up+0x43/0x70
Jan 21 21:45:01 Anastacia kernel:  [n_tty_receive_buf+821/3888] n_tty_receive_buf+0x335/0xf30
Jan 21 21:45:01 Anastacia kernel:  [sock_aio_read+349/368] sock_aio_read+0x15d/0x170
Jan 21 21:45:01 Anastacia kernel:  [core_sys_select+521/768] core_sys_select+0x209/0x300
Jan 21 21:45:01 Anastacia kernel:  [remove_wait_queue+25/96] remove_wait_queue+0x19/0x60
Jan 21 21:45:01 Anastacia kernel:  [__wake_up+67/112] __wake_up+0x43/0x70
Jan 21 21:45:01 Anastacia kernel:  [tty_ldisc_deref+82/128] tty_ldisc_deref+0x52/0x80
Jan 21 21:45:01 Anastacia kernel:  [tty_write+569/592] tty_write+0x239/0x250
Jan 21 21:45:01 Anastacia kernel:  [sys_select+68/448] sys_select+0x44/0x1c0
Jan 21 21:45:01 Anastacia kernel:  [sys_write+83/144] sys_write+0x53/0x90
Jan 21 21:45:01 Anastacia kernel:  [system_call+126/131] system_call+0x7e/0x83

What could be causing this problem?

-- 
Frederik Himpe <fhimpe@telenet.be>

