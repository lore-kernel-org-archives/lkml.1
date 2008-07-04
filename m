Return-Path: <linux-kernel-owner+w=401wt.eu-S1756484AbYGDVWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484AbYGDVWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 17:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753828AbYGDVVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 17:21:32 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:52819 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbYGDVVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 17:21:31 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200807041120.678642023@firstfloor.org>
In-Reply-To: <200807041120.678642023@firstfloor.org>
To: masbock@linux.vnet.ibm.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/9] MCE: Provide exit_idle dummy functions for 32bit.
Message-Id: <20080704212030.C6C6D1B431F@basil.firstfloor.org>
Date: Fri,  4 Jul 2008 23:20:30 +0200 (CEST)
X-OriginalArrivalTime: 04 Jul 2008 21:13:08.0205 (UTC) FILETIME=[C1CD91D0:01C8DE1A]
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
