Return-Path: <linux-kernel-owner+w=401wt.eu-S1756421AbYCNXvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756421AbYCNXvx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 19:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbYCNXvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 19:51:44 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:10641 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbYCNXvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 19:51:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=n0MZa0yGLuaysc0opbLL+OZOh0ANVNfoJgfjQB4UCEZqlo82G0AloAqv3fJFN3edVdUcCO156VbA92uTLSMVQ6XnLK9mATS1Brr8NSBKxBbA2FToLcOY2Qq3D7rLCtw0kHl1YA85uvn31qxtiUpYKh1k90JlYz02Nc3bg/JA7VE=
Message-ID: <c4e36d110803141651x416768c8xbb15fece626d510b@mail.gmail.com>
Date: Sat, 15 Mar 2008 00:51:42 +0100
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Kernel development list" <linux-kernel@vger.kernel.org>
Subject: WARNING: at kernel/lockdep.c:2662 check_flags
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm getting this warning trace with current kernel git tree:

[    0.003346] ------------[ cut here ]------------
[    0.003346] WARNING: at kernel/lockdep.c:2662 check_flags+0x18d/0x1a0()
[    0.003346] Modules linked in:
[    0.003346] Pid: 0, comm: swapper Not tainted 2.6.25-rc5-replic-server #55
[    0.003346]
[    0.003346] Call Trace:
[    0.003346]  [<ffffffff8103c0ef>] warn_on_slowpath+0x5f/0x90
[    0.003346]  [<ffffffff81013858>] ? native_sched_clock+0x78/0x80
[    0.003346]  [<ffffffff81063edd>] ? __lock_acquire+0x35d/0x1160
[    0.003346]  [<ffffffff8103599a>] ? hrtick_set+0x7a/0x130
[    0.003346]  [<ffffffff812f5a65>] ? _spin_unlock_irqrestore+0x65/0x90
[    0.003346]  [<ffffffff812f5a45>] ? _spin_unlock_irqrestore+0x45/0x90
[    0.003346]  [<ffffffff8106157a>] ? get_lock_stats+0x2a/0x70
[    0.003346]  [<ffffffff812f9590>] ? __atomic_notifier_call_chain+0x0/0xd0
[    0.003346]  [<ffffffff81060add>] check_flags+0x18d/0x1a0
[    0.003346]  [<ffffffff81064d3d>] lock_acquire+0x5d/0xe0
[    0.003346]  [<ffffffff812f95eb>] __atomic_notifier_call_chain+0x5b/0xd0
[    0.003346]  [<ffffffff8100a140>] ? mwait_idle+0x0/0x60
[    0.003346]  [<ffffffff8100b520>] ? default_idle+0x0/0x80
[    0.003346]  [<ffffffff812f9671>] atomic_notifier_call_chain+0x11/0x20
[    0.003346]  [<ffffffff8100b4b3>] cpu_idle+0xe3/0x150
[    0.003346]  [<ffffffff812ef0a5>] start_secondary+0x407/0x462
[    0.003346]
[    0.003346] ---[ end trace ca143223eefdc828 ]---
[    0.003346] possible reason: unannotated irqs-on.
[    0.003346] irq event stamp: 18
[    0.003346] hardirqs last  enabled at (17): [<ffffffff8105f4e5>]
tick_nohz_stop_sched_tick+0xe5/0x390
[    0.003346] hardirqs last disabled at (18): [<ffffffff8100b435>]
cpu_idle+0x65/0x150
[    0.003346] softirqs last  enabled at (0): [<ffffffff8103a29e>]
copy_process+0x41e/0x17a0
[    0.003346] softirqs last disabled at (0): [<0000000000000000>] 0x0


Zdenek
