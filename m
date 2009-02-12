Return-Path: <linux-kernel-owner+w=401wt.eu-S1759056AbZBLMiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759056AbZBLMiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:38:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757033AbZBLMi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:38:28 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35203 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100AbZBLMi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:38:27 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212137.750180365@firstfloor.org>
In-Reply-To: <20090212137.750180365@firstfloor.org>
To: akpm@linux-foundation.org, x86@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [1/10] x86: MCE: Reinitialize per cpu features on resume v3
Message-Id: <20090212123720.439983E666F@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:37:20 +0100 (CET)
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
 
