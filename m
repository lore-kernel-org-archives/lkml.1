Return-Path: <linux-kernel-owner+w=401wt.eu-S1760914AbYGRXNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914AbYGRXNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbYGRXNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:13:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:24397 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbYGRXNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:13:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,212,1215414000"; 
   d="scan'208";a="419502085"
Message-Id: <20080718231049.722020000@intel.com>
References: <20080718230812.826863000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Jul 2008 16:08:13 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [RFC patch 1/2] x86: Add a arch directory for x86 under debugfs
Content-Disposition: inline; filename=x86_debugfs_dir.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a directory for x86 arch under debugfs. Can be used to accumulate all
x86 specific debugfs files.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/kernel/kdebugfs.c |    8 ++++++++
 include/linux/debugfs.h    |    2 ++
 2 files changed, 10 insertions(+)

Index: linux-2.6/arch/x86/kernel/kdebugfs.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/kdebugfs.c	2008-05-02 09:45:23.000000000 -0700
+++ linux-2.6/arch/x86/kernel/kdebugfs.c	2008-07-18 15:20:39.000000000 -0700
@@ -12,9 +12,13 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/mm.h>
+#include <linux/module.h>
 
 #include <asm/setup.h>
 
+struct dentry *arch_debugfs_dir;
+EXPORT_SYMBOL(arch_debugfs_dir);
+
 #ifdef CONFIG_DEBUG_BOOT_PARAMS
 struct setup_data_node {
 	u64 paddr;
@@ -209,6 +213,10 @@ static int __init arch_kdebugfs_init(voi
 {
 	int error = 0;
 
+	arch_debugfs_dir = debugfs_create_dir("x86", NULL);
+	if (!arch_debugfs_dir)
+		return -ENOMEM;
+
 #ifdef CONFIG_DEBUG_BOOT_PARAMS
 	error = boot_params_kdebugfs_init();
 #endif
Index: linux-2.6/include/linux/debugfs.h
===================================================================
--- linux-2.6.orig/include/linux/debugfs.h	2008-05-01 15:31:18.000000000 -0700
+++ linux-2.6/include/linux/debugfs.h	2008-07-18 15:20:01.000000000 -0700
@@ -26,6 +26,8 @@ struct debugfs_blob_wrapper {
 	unsigned long size;
 };
 
+extern struct dentry *arch_debugfs_dir;
+
 #if defined(CONFIG_DEBUG_FS)
 
 /* declared over in file.c */

-- 

