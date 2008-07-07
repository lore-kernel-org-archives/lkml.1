Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbYGGXMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbYGGXMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 19:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758060AbYGGXLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 19:11:13 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:2565 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874AbYGGXLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 19:11:11 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080708110.487722491@firstfloor.org>
In-Reply-To: <20080708110.487722491@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [6/10] MCE: Provide exit_idle dummy functions for 32bit.
Message-Id: <20080707231008.9CD9C1B4315@basil.firstfloor.org>
Date: Tue,  8 Jul 2008 01:10:08 +0200 (CEST)
X-OriginalArrivalTime: 07 Jul 2008 23:02:44.0666 (UTC) FILETIME=[90EB21A0:01C8E085]
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
