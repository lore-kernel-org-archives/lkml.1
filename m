Return-Path: <linux-kernel-owner+w=401wt.eu-S1760702AbYAUQGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702AbYAUQGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 11:06:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756991AbYAUQGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 11:06:43 -0500
Received: from usermail.globalproof.net ([194.146.153.18]:57000 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834AbYAUQGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 11:06:42 -0500
From: "Denys Fedoryshchenko" <denys@visp.net.lb>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc7 to 2.6.24-rc8 possible regression
Date: Mon, 21 Jan 2008 18:06:23 +0200
Message-Id: <20080121160255.M12670@visp.net.lb>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 195.69.208.251 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After running screen found in dmesg. It was not happening before.

[625138.248257]
[625138.248260] =============================================
[625138.248542] [ INFO: possible recursive locking detected ]
[625138.248686] 2.6.24-rc8-devel #2
[625138.248821] ---------------------------------------------
[625138.248963] screen/18164 is trying to acquire lock:
[625138.249101]  (&q->lock){++..}, at: [<c01175ff>] __wake_up+0x15/0x42
[625138.249454]
[625138.249456] but task is already holding lock:
[625138.249724]  (&q->lock){++..}, at: [<c01175ff>] __wake_up+0x15/0x42
[625138.250073]
[625138.250075] other info that might help us debug this:
[625138.250343] 2 locks held by screen/18164:
[625138.250477]  #0:  (&tty->atomic_read_lock){--..}, at: [<c0231a6c>] 
read_chan+0x18f/0x50b
[625138.250960]  #1:  (&q->lock){++..}, at: [<c01175ff>] __wake_up+0x15/0x42
[625138.251356]
[625138.251357] stack backtrace:
[625138.251623] Pid: 18164, comm: screen Not tainted 2.6.24-rc8-devel #2
[625138.251764]  [<c0105e84>] show_trace_log_lvl+0x1a/0x2f
[625138.251959]  [<c010682c>] show_trace+0x12/0x14
[625138.252150]  [<c0107123>] dump_stack+0x6c/0x72
[625138.252338]  [<c01384c0>] __lock_acquire+0x172/0xb8c
[625138.252533]  [<c01392a7>] lock_acquire+0x5f/0x78
[625138.252725]  [<c032afa7>] _spin_lock_irqsave+0x34/0x44
[625138.252920]  [<c01175ff>] __wake_up+0x15/0x42
[625138.253108]  [<c0186a16>] ep_poll_safewake+0x8e/0xbf
[625138.253300]  [<c01876df>] ep_poll_callback+0x9f/0xac
[625138.253491]  [<c0115d36>] __wake_up_common+0x32/0x5c
[625138.253688]  [<c011761b>] __wake_up+0x31/0x42
[625138.253878]  [<c022c803>] tty_wakeup+0x4f/0x54
[625138.254070]  [<c0232c7c>] pty_unthrottle+0x15/0x21
[625138.254258]  [<c022ffe3>] check_unthrottle+0x2e/0x30
[625138.254445]  [<c0231cf4>] read_chan+0x417/0x50b
[625138.254633]  [<c022ec67>] tty_read+0x66/0xac
[625138.254819]  [<c01628dc>] vfs_read+0x8e/0x117
[625138.255004]  [<c0162d10>] sys_read+0x3d/0x61
[625138.255190]  [<c0104dee>] sysenter_past_esp+0x5f/0xa5
[625138.255376]  =======================



--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

