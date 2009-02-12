Return-Path: <linux-kernel-owner+w=401wt.eu-S1760024AbZBLMmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024AbZBLMmn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759472AbZBLMkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:40:31 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49247 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759174AbZBLMka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:40:30 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212139.634236515@firstfloor.org>
In-Reply-To: <20090212139.634236515@firstfloor.org>
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/10] x86: MCE: Reinitialize per cpu features on resume v3
Message-Id: <20090212123926.A3C073E666E@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:39:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Bug fix

This fixes a long standing bug in the machine check code. On resume the
boot CPU wouldn't get its vendor specific state like thermal handling
reinitialized. This means the boot cpu wouldn't ever get any thermal
events reported again.

Call the respective initialization functions on resume

v2: Remove ancient init because they don't have a resume device anyways.
Pointed out by Thomas Gleixner.
v3: Now fix the Subject too to reflect v2 change

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 12:10:22.000000000 +0100
@@ -734,6 +734,7 @@
 static int mce_resume(struct sys_device *dev)
 {
 	mce_init(NULL);
+	mce_cpu_features(&current_cpu_data);
 	return 0;
 }
 
