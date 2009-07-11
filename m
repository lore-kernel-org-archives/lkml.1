Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbZGKHog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbZGKHog (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 03:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbZGKHoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 03:44:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56726 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbZGKHoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 03:44:14 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090711944.448667020@firstfloor.org>
In-Reply-To: <20090711944.448667020@firstfloor.org>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [2/3] x86: mce: Improve comments in CMCI code
Message-Id: <20090711074410.958AB1D0261@basil.firstfloor.org>
Date: Sat, 11 Jul 2009 09:44:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Improve the comments in the CMCI code in mce_intel.c. This documents
some of the design decisions and adds references to the appropiate
manuals. 

No code changes.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_intel.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_intel.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -19,8 +19,16 @@
  * the CPU to raise an interrupt when a corrected machine check happened.
  * Normally we pick those up using a regular polling timer.
  * Also supports reliable discovery of shared banks.
+ *
+ * For reference see the Intel 64 Software Developer's Manual, Volume 3a,
+ * 15.5.2. This code is a relatively faithful implementation of the
+ * recommendations there.
  */
 
+/*
+ * Ownership of MCE banks per CPU. To avoid duplicated events
+ * for shared banks we assign ownership to specific CPUs.
+ */
 static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
 
 /*
@@ -29,6 +37,10 @@ static DEFINE_PER_CPU(mce_banks_t, mce_b
  */
 static DEFINE_SPINLOCK(cmci_discover_lock);
 
+/*
+ * CMCI threshold in hardware has some drawbacks. We chose to log every event
+ * and hardcode 1
+ */
 #define CMCI_THRESHOLD 1
 
 static int cmci_supported(int *banks)
@@ -163,7 +175,7 @@ void cmci_clear(void)
 
 /*
  * After a CPU went down cycle through all the others and rediscover
- * Must run in process context.
+ * bank ownership.  Must run in process context.
  */
 void cmci_rediscover(int dying)
 {
