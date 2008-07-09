Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbYGIMxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbYGIMxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 08:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755642AbYGIMxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 08:53:38 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:42128 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbYGIMxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 08:53:37 -0400
Message-Id: <20080709082902.986792000@sipsolutions.net>
References: <20080709082834.942992000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 10:28:36 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: [PATCH -next 02/11] remove CONFIG_KMOD from core kernel code
Content-Disposition: inline; filename=004-config-kmod-remove-core.patch
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always compile request_module when the kernel allows modules.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/kmod.h |    2 +-
 kernel/exec_domain.c |    2 +-
 kernel/kmod.c        |    4 ++--
 kernel/sysctl.c      |    4 ++--
 4 files changed, 6 insertions(+), 6 deletions(-)

--- linux-next.orig/include/linux/kmod.h	2008-07-08 23:57:41.000000000 +0200
+++ linux-next/include/linux/kmod.h	2008-07-08 23:57:43.000000000 +0200
@@ -25,7 +25,7 @@
 
 #define KMOD_PATH_LEN 256
 
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 /* modprobe exit status on success, -ve on error.  Return value
  * usually useless though. */
 extern int request_module(const char * name, ...) __attribute__ ((format (printf, 1, 2)));
--- linux-next.orig/kernel/exec_domain.c	2008-07-08 23:57:41.000000000 +0200
+++ linux-next/kernel/exec_domain.c	2008-07-08 23:57:43.000000000 +0200
@@ -65,7 +65,7 @@ lookup_exec_domain(u_long personality)
 				goto out;
 	}
 
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 	read_unlock(&exec_domains_lock);
 	request_module("personality-%ld", pers);
 	read_lock(&exec_domains_lock);
--- linux-next.orig/kernel/kmod.c	2008-07-08 23:57:41.000000000 +0200
+++ linux-next/kernel/kmod.c	2008-07-08 23:57:59.000000000 +0200
@@ -42,7 +42,7 @@ extern int max_threads;
 
 static struct workqueue_struct *khelper_wq;
 
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 
 /*
 	modprobe_path is set via /proc/sys.
@@ -113,7 +113,7 @@ int request_module(const char *fmt, ...)
 	return ret;
 }
 EXPORT_SYMBOL(request_module);
-#endif /* CONFIG_KMOD */
+#endif /* CONFIG_MODULES */
 
 struct subprocess_info {
 	struct work_struct work;
--- linux-next.orig/kernel/sysctl.c	2008-07-08 23:57:41.000000000 +0200
+++ linux-next/kernel/sysctl.c	2008-07-08 23:57:43.000000000 +0200
@@ -112,7 +112,7 @@ static int min_percpu_pagelist_fract = 8
 
 static int ngroups_max = NGROUPS_MAX;
 
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 extern char modprobe_path[];
 #endif
 #ifdef CONFIG_CHR_DEV_SG
@@ -477,7 +477,7 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &ftrace_enable_sysctl,
 	},
 #endif
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 	{
 		.ctl_name	= KERN_MODPROBE,
 		.procname	= "modprobe",

-- 
