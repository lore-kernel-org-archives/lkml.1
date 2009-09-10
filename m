Return-Path: <linux-kernel-owner+w=401wt.eu-S1753741AbZIJTr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbZIJTr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 15:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZIJTr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 15:47:56 -0400
Received: from smtp6.netcologne.de ([194.8.194.26]:52993 "EHLO
	smtp6.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbZIJTrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 15:47:55 -0400
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Sep 2009 15:47:55 EDT
From: Mathias Kretschmer <posting@blx4.net>
To: linux-kernel@vger.kernel.org
Subject: WARNING: at kernel/softirq.c:141 local_bh_enable+0x8b/0xc0()
Date: Thu, 10 Sep 2009 21:39:09 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9; KDE/4.3.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909102139.09735.posting@blx4.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I reported this before. I'm still seeing this on 2.6.30.6+grsec:

[  526.823652] ------------[ cut here ]------------
[  526.823671] WARNING: at kernel/softirq.c:141 local_bh_enable+0x8b/0xc0()
[  526.823676] Hardware name: empty
[  526.823680] Modules linked in: iscsi_trgt dummy bonding dvb_usb_cinergyT2 
usbtouchscreen forcedeth
[  526.823697] Pid: 904, comm: mISDN_hfc-pci.1 Not tainted 2.6.30.6-grsec #3
[  526.823702] Call Trace:
[  526.823711]  [<ffffffff81064a0b>] ? local_bh_enable+0x8b/0xc0
[  526.823718]  [<ffffffff81064a0b>] ? local_bh_enable+0x8b/0xc0
[  526.823727]  [<ffffffff8105ea39>] ? warn_slowpath_common+0x79/0xd0
[  526.823734]  [<ffffffff81064a0b>] ? local_bh_enable+0x8b/0xc0
[  526.823743]  [<ffffffff8151af41>] ? sk_filter+0x41/0xa0
[  526.823753]  [<ffffffff8150002d>] ? sock_queue_rcv_skb+0x5d/0x140
[  526.823762]  [<ffffffff8148fe9f>] ? mISDN_send+0x4f/0xa0
[  526.823769]  [<ffffffff81495250>] ? l2_got_ui+0x0/0x70
[  526.823775]  [<ffffffff81493437>] ? l2up+0x27/0x50
[  526.823782]  [<ffffffff8148eac2>] ? mISDN_FsmEvent+0x82/0x100
[  526.823788]  [<ffffffff814973ba>] ? l2_send+0x6fa/0x980
[  526.823795]  [<ffffffff814993b3>] ? mgr_bcast+0x83/0x160
[  526.823803]  [<ffffffff81492459>] ? mISDNStackd+0x439/0x680
[  526.823811]  [<ffffffff81077730>] ? autoremove_wake_function+0x0/0x30
[  526.823818]  [<ffffffff81492020>] ? mISDNStackd+0x0/0x680
[  526.823825]  [<ffffffff81492020>] ? mISDNStackd+0x0/0x680
[  526.823831]  [<ffffffff81077224>] ? kthread+0x54/0x90
[  526.823838]  [<ffffffff8105bb72>] ? schedule_tail+0x32/0x80
[  526.823845]  [<ffffffff81025baa>] ? child_rip+0xa/0x20
[  526.823851]  [<ffffffff810771d0>] ? kthread+0x0/0x90
[  526.823857]  [<ffffffff81025ba0>] ? child_rip+0x0/0x20
[  526.823862] ---[ end trace a4fad34479a16c5d ]---
