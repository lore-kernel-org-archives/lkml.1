Return-Path: <linux-kernel-owner+w=401wt.eu-S1756484AbYGGGa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbYGGGa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 02:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754292AbYGGG3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 02:29:00 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:56828 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbYGGG26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 02:28:58 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080707828.405203787@firstfloor.org>
In-Reply-To: <20080707828.405203787@firstfloor.org>
To: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/9] MCE: Provide exit_idle dummy functions for 32bit.
Message-Id: <20080707062838.ABC181B4315@basil.firstfloor.org>
Date: Mon,  7 Jul 2008 08:28:38 +0200 (CEST)
X-OriginalArrivalTime: 07 Jul 2008 06:21:14.0906 (UTC) FILETIME=[A8A167A0:01C8DFF9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At some point i386 should probably gain true idle notifiers again,
but not now.

This is required for the 64bit thermal/threshold interrupt handlers. 

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 include/asm-x86/idle.h |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux/include/asm-x86/idle.h
===================================================================
--- linux.orig/include/asm-x86/idle.h
+++ linux/include/asm-x86/idle.h
@@ -7,7 +7,12 @@
 struct notifier_block;
 void idle_notifier_register(struct notifier_block *n);
 
+#ifdef CONFIG_X86_64
 void enter_idle(void);
 void exit_idle(void);
+#else
+static inline void enter_idle(void) {}
+static inline void exit_idle(void) {}
+#endif
 
 #endif
