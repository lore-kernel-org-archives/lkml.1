Return-Path: <linux-kernel-owner+w=401wt.eu-S1753207AbZGZIVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbZGZIVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbZGZIVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:21:42 -0400
Received: from www.tglx.de ([62.245.132.106]:33943 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbZGZIVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:21:39 -0400
Message-Id: <20090726081557.639168910@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:20:07 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Wan ZongShun <mcuos.com@gmail.com>
Subject: [Patch RFC 33/37] arm: w90x900: convert semaphore to mutex
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline;
	filename=arm-w90x900-mfp-convert-sem-to-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semaphore is used as mutex so make it a mutex.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Wan ZongShun <mcuos.com@gmail.com>
---
 arch/arm/mach-w90x900/mfp-w90p910.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6-tip/arch/arm/mach-w90x900/mfp-w90p910.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-w90x900/mfp-w90p910.c
+++ linux-2.6-tip/arch/arm/mach-w90x900/mfp-w90p910.c
@@ -34,7 +34,7 @@
 #define GPSELEI0	(0x01 << 26)
 #define GPSELEI1	(0x01 << 27)
 
-static DECLARE_MUTEX(mfp_sem);
+static DEFINE_MUTEX(mfp_sem);
 
 void mfp_set_groupf(struct device *dev)
 {
@@ -43,7 +43,7 @@ void mfp_set_groupf(struct device *dev)
 
 	BUG_ON(!dev);
 
-	down(&mfp_sem);
+	mutex_lock(&mfp_sem);
 
 	dev_id = dev_name(dev);
 
@@ -56,7 +56,7 @@ void mfp_set_groupf(struct device *dev)
 
 	__raw_writel(mfpen, REG_MFSEL);
 
-	up(&mfp_sem);
+	mutex_unlock(&mfp_sem);
 }
 EXPORT_SYMBOL(mfp_set_groupf);
 
@@ -67,7 +67,7 @@ void mfp_set_groupc(struct device *dev)
 
 	BUG_ON(!dev);
 
-	down(&mfp_sem);
+	mutex_lock(&mfp_sem);
 
 	dev_id = dev_name(dev);
 
@@ -86,7 +86,7 @@ void mfp_set_groupc(struct device *dev)
 
 	__raw_writel(mfpen, REG_MFSEL);
 
-	up(&mfp_sem);
+	mutex_unlock(&mfp_sem);
 }
 EXPORT_SYMBOL(mfp_set_groupc);
 
@@ -97,7 +97,7 @@ void mfp_set_groupi(struct device *dev, 
 
 	BUG_ON(!dev);
 
-	down(&mfp_sem);
+	mutex_lock(&mfp_sem);
 
 	dev_id = dev_name(dev);
 
@@ -110,7 +110,7 @@ void mfp_set_groupi(struct device *dev, 
 
 	__raw_writel(mfpen, REG_MFSEL);
 
-	up(&mfp_sem);
+	mutex_unlock(&mfp_sem);
 }
 EXPORT_SYMBOL(mfp_set_groupi);
 


