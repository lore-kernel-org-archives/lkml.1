Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab0BTOSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:18:22 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:34670 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952Ab0BTOSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:18:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=IPfYTic7m/HNtXhY+9mEcy0Hct0l5mYXoPqCyQ8kO8IQPfdaEveQYgBupqLlVHCTKv
         epM2v3AlI6lhLFW2PJ5o2+GquBlX2PJgzQxH/3PpHYoYFakvrq+4fda4zTjc2XiiZT9o
         TtCR/MzsR5xipekJT7CGHCI1U7C4/Vl44bxTc=
Date: Sat, 20 Feb 2010 22:18:09 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Patrick McHardy <kaber@trash.net>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 12/18] sysctl extern cleanup - module
Message-ID: <20100220141809.GK3195@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

Move modprobe_path extern declaration to linux/kmod.h
Move modules_disabled extern declaration to linux/module.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/kmod.h   |    3 +++
 include/linux/module.h |    6 ++++++
 kernel/sysctl.c        |    4 ----
 3 files changed, 9 insertions(+), 4 deletions(-)

--- linux-2.6.32.orig/include/linux/module.h	2010-02-20 14:02:19.704925558 +0800
+++ linux-2.6.32/include/linux/module.h	2010-02-20 14:29:59.621428095 +0800
@@ -34,6 +34,12 @@
 
 #define MODULE_NAME_LEN MAX_PARAM_PREFIX_LEN
 
+#ifdef CONFIG_SYSCTL
+#ifdef CONFIG_MODULES
+extern int modules_disabled;
+#endif
+#endif
+
 struct kernel_symbol
 {
 	unsigned long value;
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-20 14:27:44.608107474 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-20 14:27:50.691439411 +0800
@@ -100,10 +100,6 @@ static int min_percpu_pagelist_fract = 8
 
 static int ngroups_max = NGROUPS_MAX;
 
-#ifdef CONFIG_MODULES
-extern char *modprobe_path;
-extern int modules_disabled;
-#endif
 #ifdef CONFIG_CHR_DEV_SG
 extern int sg_big_buff;
 #endif
--- linux-2.6.32.orig/include/linux/kmod.h	2010-02-20 14:02:19.694925349 +0800
+++ linux-2.6.32/include/linux/kmod.h	2010-02-20 14:30:48.918089456 +0800
@@ -28,6 +28,9 @@
 #define KMOD_PATH_LEN 256
 
 #ifdef CONFIG_MODULES
+#ifdef CONFIG_SYSCTL
+extern char *modprobe_path;
+#endif
 /* modprobe exit status on success, -ve on error.  Return value
  * usually useless though. */
 extern int __request_module(bool wait, const char *name, ...) \
