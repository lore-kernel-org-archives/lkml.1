Return-Path: <linux-kernel-owner+w=401wt.eu-S1757175AbZD0Poe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757175AbZD0Poe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 11:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757400AbZD0PoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 11:44:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54083 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757928AbZD0PoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 11:44:17 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090427544.130860995@firstfloor.org>
In-Reply-To: <20090427544.130860995@firstfloor.org>
To: oprofile-list@lists.sf.net, robert.richter@amd.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [2/3] oprofile: remove undocumented oprofile.p4force option
Message-Id: <20090427154412.290C61D024B@basil.firstfloor.org>
Date: Mon, 27 Apr 2009 17:44:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are no new P4s and the oprofile code knows about all existing
ones, so we don't really need the p4force option anymore.

Remove it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/oprofile/nmi_int.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-2.6.28-test/arch/x86/oprofile/nmi_int.c
===================================================================
--- linux-2.6.28-test.orig/arch/x86/oprofile/nmi_int.c	2009-01-03 00:57:30.000000000 +0100
+++ linux-2.6.28-test/arch/x86/oprofile/nmi_int.c	2009-01-03 00:58:25.000000000 +0100
@@ -356,14 +356,11 @@
 #define exit_sysfs() do { } while (0)
 #endif /* CONFIG_PM */
 
-static int p4force;
-module_param(p4force, int, 0);
-
 static int __init p4_init(char **cpu_type)
 {
 	__u8 cpu_model = boot_cpu_data.x86_model;
 
-	if (!p4force && (cpu_model > 6 || cpu_model == 5))
+	if (cpu_model > 6 || cpu_model == 5)
 		return 0;
 
 #ifndef CONFIG_SMP
