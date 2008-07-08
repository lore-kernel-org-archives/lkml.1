Return-Path: <linux-kernel-owner+w=401wt.eu-S1758918AbYGHRFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918AbYGHRFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 13:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbYGHRFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 13:05:43 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:49720 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334AbYGHRFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 13:05:43 -0400
Message-Id: <20080708170042.521890000@sipsolutions.net>
References: <20080708170015.470877000@sipsolutions.net>
User-Agent: quilt/0.46-1
Date: Tue, 08 Jul 2008 19:00:17 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>
Subject: [RFC 02/11] remove CONFIG_KMOD from core kernel code
Content-Disposition: inline; filename=config-kmod-remove-core.patch
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
 kernel/kmod.c        |    2 +-
 kernel/sysctl.c      |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

--- everything.orig/include/linux/kmod.h	2008-07-08 17:32:06.000000000 +0200
+++ everything/include/linux/kmod.h	2008-07-08 17:34:37.000000000 +0200
@@ -25,7 +25,7 @@
 
 #define KMOD_PATH_LEN 256
 
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 /* modprobe exit status on success, -ve on error.  Return value
  * usually useless though. */
 extern int request_module(const char * name, ...) __attribute__ ((format (printf, 1, 2)));
--- everything.orig/kernel/exec_domain.c	2008-07-08 17:32:06.000000000 +0200
+++ everything/kernel/exec_domain.c	2008-07-08 17:34:37.000000000 +0200
@@ -65,7 +65,7 @@ lookup_exec_domain(u_long personality)
 				goto out;
 	}
 
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 	read_unlock(&exec_domains_lock);
 	request_module("personality-%ld", pers);
 	read_lock(&exec_domains_lock);
--- everything.orig/kernel/kmod.c	2008-07-08 17:32:06.000000000 +0200
+++ everything/kernel/kmod.c	2008-07-08 17:34:37.000000000 +0200
@@ -42,7 +42,7 @@ extern int max_threads;
 
 static struct workqueue_struct *khelper_wq;
 
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 
 /*
 	modprobe_path is set via /proc/sys.
--- everything.orig/kernel/sysctl.c	2008-07-08 17:32:06.000000000 +0200
+++ everything/kernel/sysctl.c	2008-07-08 17:34:37.000000000 +0200
@@ -106,7 +106,7 @@ static int min_percpu_pagelist_fract = 8
 
 static int ngroups_max = NGROUPS_MAX;
 
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 extern char modprobe_path[];
 #endif
 #ifdef CONFIG_CHR_DEV_SG
@@ -455,7 +455,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
-#ifdef CONFIG_KMOD
+#ifdef CONFIG_MODULES
 	{
 		.ctl_name	= KERN_MODPROBE,
 		.procname	= "modprobe",

-- 

