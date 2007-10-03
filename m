Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571AbXJCKCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571AbXJCKCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 06:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbXJCKCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 06:02:10 -0400
Received: from ee.oulu.fi ([130.231.61.23]:35370 "EHLO ee.oulu.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272AbXJCKCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 06:02:08 -0400
X-Greylist: delayed 2278 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Oct 2007 06:02:08 EDT
Date: Wed, 3 Oct 2007 12:24:08 +0300
From: Pekka Pietikainen <pp@ee.oulu.fi>
To: linux-kernel@vger.kernel.org
Subject: 2.6.23-rc8-git2 possible recursive locking when running screen
Message-ID: <20071003092408.GA17356@ee.oulu.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seen this a few times lately on a machine running rawhide when running
screen (and doing "something", it's not automatic. And box works just fine).
I think I saw this a few weeks back, so it's not a new regression.

=============================================
[ INFO: possible recursive locking detected ]
2.6.23-0.211.rc8.git2.fc8 #1
---------------------------------------------
screen/32227 is trying to acquire lock:
 (&q->lock){++..}, at: [<c0426703>] __wake_up+0x15/0x42

but task is already holding lock:
 (&q->lock){++..}, at: [<c0426703>] __wake_up+0x15/0x42

other info that might help us debug this:
2 locks held by screen/32227:
 #0:  (&tty->atomic_read_lock){--..}, at: [<c0554ca2>] read_chan+0x1a1/0x5af
 #1:  (&q->lock){++..}, at: [<c0426703>] __wake_up+0x15/0x42

stack backtrace:
 [<c0406463>] show_trace_log_lvl+0x1a/0x2f
 [<c0406e4d>] show_trace+0x12/0x14
 [<c0406e65>] dump_stack+0x16/0x18
 [<c0449c3a>] __lock_acquire+0x189/0xc67
 [<c044ab92>] lock_acquire+0x7b/0x9e
 [<c06334fa>] _spin_lock_irqsave+0x4a/0x77
 [<c0426703>] __wake_up+0x15/0x42
 [<c04aece2>] ep_poll_safewake+0x86/0xa8
 [<c04af969>] ep_poll_callback+0x9f/0xaa
 [<c042483e>] __wake_up_common+0x32/0x55
 [<c042671f>] __wake_up+0x31/0x42
 [<c054f864>] tty_wakeup+0x4f/0x54
 [<c0555e9b>] pty_unthrottle+0x15/0x21
 [<c055301b>] check_unthrottle+0x2e/0x30
 [<c0554fad>] read_chan+0x4ac/0x5af
 [<c0551c99>] tty_read+0x66/0xac
 [<c0489fee>] vfs_read+0xad/0x167
 [<c048a482>] sys_read+0x3d/0x61
 [<c040522e>] syscall_call+0x7/0xb
 =======================
