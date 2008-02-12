Return-Path: <linux-kernel-owner+w=401wt.eu-S1761649AbYBLGMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761649AbYBLGMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 01:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761287AbYBLGLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 01:11:17 -0500
Received: from rex.snapgear.com ([203.143.235.140]:52869 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755267AbYBLGLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 01:11:16 -0500
Date: Tue, 12 Feb 2008 16:08:32 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802120608.m1C68WRQ009916@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU]: avoid unneccessary use of xchg() in set_mb()
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid unneccessary use of xchg() in set_mb().

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---

diff -Naurp linux-2.6.25-rc1/include/asm-m68knommu/system.h linux-2.6.x/include/asm-m68knommu/system.h
--- linux-2.6.25-rc1/include/asm-m68knommu/system.h	2008-02-11 14:50:23.000000000 +1000
+++ linux-2.6.x/include/asm-m68knommu/system.h	2008-02-12 13:58:55.000000000 +1000
@@ -104,7 +104,7 @@ asmlinkage void resume(void);
 #define mb()   asm volatile (""   : : :"memory")
 #define rmb()  asm volatile (""   : : :"memory")
 #define wmb()  asm volatile (""   : : :"memory")
-#define set_mb(var, value) do { xchg(&var, value); } while (0)
+#define set_mb(var, value)	({ (var) = (value); wmb(); })
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
