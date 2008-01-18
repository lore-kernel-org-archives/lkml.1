Return-Path: <linux-kernel-owner+w=401wt.eu-S1764129AbYARR3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764129AbYARR3X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762876AbYARR1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:27:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:35701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762717AbYARR1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:27:23 -0500
From: Andi Kleen <ak@suse.de>
References: <20080118627.198787000@suse.de>
In-Reply-To: <20080118627.198787000@suse.de>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [6/7] Add noclflush option
Message-Id: <20080118172722.A7D4914AAE@wotan.suse.de>
Date: Fri, 18 Jan 2008 18:27:22 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


To disable CLFLUSH usage, especially in change_page_attr().

Ingo asked for this.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 Documentation/kernel-parameters.txt |    2 ++
 arch/x86/kernel/cpu/common.c        |    7 +++++++
 arch/x86/kernel/setup_64.c          |    7 +++++++
 3 files changed, 16 insertions(+)

Index: linux/arch/x86/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/common.c
+++ linux/arch/x86/kernel/cpu/common.c
@@ -542,6 +542,13 @@ void __cpuinit detect_ht(struct cpuinfo_
 }
 #endif
 
+static __init int setup_noclflush(char *arg)
+{
+	setup_clear_cpu_cap(X86_FEATURE_CLFLSH);
+	return 1;
+}
+__setup("noclflush", setup_noclflush);
+
 void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 {
 	char *vendor = NULL;
Index: linux/arch/x86/kernel/setup_64.c
===================================================================
--- linux.orig/arch/x86/kernel/setup_64.c
+++ linux/arch/x86/kernel/setup_64.c
@@ -1042,6 +1042,13 @@ void __cpuinit identify_cpu(struct cpuin
 	}
 }
 
+static __init int setup_noclflush(char *arg)
+{
+	setup_clear_cpu_cap(X86_FEATURE_CLFLSH);
+	return 1;
+}
+__setup("noclflush", setup_noclflush);
+
 void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 {
 	if (c->x86_model_id[0])
Index: linux/Documentation/kernel-parameters.txt
===================================================================
--- linux.orig/Documentation/kernel-parameters.txt
+++ linux/Documentation/kernel-parameters.txt
@@ -1173,6 +1173,8 @@ and is between 256 and 4096 characters. 
 			register save and restore. The kernel will only save
 			legacy floating-point registers on task switch.
 
+	noclflush	[BUGS=X86] Don't use the CLFLUSH instruction
+
 	nohlt		[BUGS=ARM]
 
 	no-hlt		[BUGS=X86-32] Tells the kernel that the hlt
