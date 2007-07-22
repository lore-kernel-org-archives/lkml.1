Return-Path: <linux-kernel-owner+w=401wt.eu-S1758758AbXGVRdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758AbXGVRdd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 13:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757558AbXGVRdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 13:33:00 -0400
Received: from homer.mvista.com ([63.81.120.158]:50820 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757391AbXGVRc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 13:32:59 -0400
Subject: [PATCH -rt] temporary WARN_ON removal
From: Daniel Walker <dwalker@mvista.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Content-Type: text/plain
Date: Sun, 22 Jul 2007 10:22:41 -0700
Message-Id: <1185124961.2573.14.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-1.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


These two WARN_ON calls send my system into a boot hang. They trigger
over and over , some examples below.

[   58.438501] WARNING: at kernel/sched.c:3785 schedule()
[   58.443444]  [<c039b224>] schedule+0x74/0x110
[   58.447772]  [<c039a67f>] rest_init+0x4f/0x60
[   58.452092]  [<c0490a8f>] start_kernel+0x2cf/0x310
[   58.456848]  [<c0490210>] unknown_bootoption+0x0/0x250
[   58.461951]  =======================
[   58.465496] WARNING: at kernel/sched.c:3683 schedule_debug()
[   58.471118]  [<c039ae0c>] __schedule+0x4cc/0x760
[   58.475702]  [<c010511a>] print_trace_address+0x1a/0x30
[   58.480893]  [<c0129a2b>] printk+0x1b/0x20
[   58.484957]  [<c01051f8>] show_trace_log_lvl+0x28/0x30
[   58.490060]  [<c039b1de>] schedule+0x2e/0x110
[   58.494385]  [<c039a67f>] rest_init+0x4f/0x60
[   58.498709]  [<c0490a8f>] start_kernel+0x2cf/0x310
[   58.503465]  [<c0490210>] unknown_bootoption+0x0/0x250
[   58.508569]  =======================

On closer inspection I'm not sure they are correctly placed. They could
trigger or not depending on when/if certain threads run.

Here is a patch to comment them out. This should go into the
preempt-realtime-sched.patch 

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

Index: linux-2.6.22.1/kernel/sched.c
===================================================================
--- linux-2.6.22.1.orig/kernel/sched.c	2007-07-22 17:18:38.000000000 +0000
+++ linux-2.6.22.1/kernel/sched.c	2007-07-22 17:17:48.000000000 +0000
@@ -3680,7 +3680,7 @@ static noinline void __schedule_bug(stru
  */
 static inline void schedule_debug(struct task_struct *prev)
 {
-	WARN_ON(system_state == SYSTEM_BOOTING);
+	//WARN_ON(system_state == SYSTEM_BOOTING);
 
 	/*
 	 * Test if we are atomic.  Since do_exit() needs to call into
@@ -3782,7 +3782,7 @@ asmlinkage void __sched __schedule(void)
  */
 asmlinkage void __sched schedule(void)
 {
-	WARN_ON(system_state == SYSTEM_BOOTING);
+	//WARN_ON(system_state == SYSTEM_BOOTING);
 	/*
 	 * Test if we have interrupts disabled.
 	 */


