Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab0BUOYu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:24:50 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:63691 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab0BUOYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:24:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=m8+6IlKeCf0Gfrw5Hn640JQgeY67Mq1CzxSOUqCb0z2XdekjdK/E46K3aivP/1DWLh
         msqnY3Fr4P+zjYKo3PHKxg9tx5qK2MygoMw6qkX8mRHD0QBJHfk2mr2denBFomhK9OJi
         TX04Fh5Z0Jdm7hAPUxHNyycHrAnW3JVU5YGFA=
Date: Sun, 21 Feb 2010 22:24:35 +0800
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
Subject: [PATCH -mm 11/17] sysctl extern cleanup - module
Message-ID: <20100221142435.GA3019@darkstar>
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
 include/linux/kmod.h   |    1 +
 include/linux/module.h |    1 +
 kernel/sysctl.c        |    4 ----
 3 files changed, 2 insertions(+), 4 deletions(-)

--- linux-2.6.32.orig/include/linux/module.h	2010-02-21 10:07:31.213835197 +0800
+++ linux-2.6.32/include/linux/module.h	2010-02-21 10:09:08.272992941 +0800
@@ -175,6 +175,7 @@ struct notifier_block;
 
 #ifdef CONFIG_MODULES
 
+extern int modules_disabled; /* for sysctl */
 /* Get/put a kernel symbol (calls must be symmetric) */
 void *__symbol_get(const char *symbol);
 void *__symbol_get_gpl(const char *symbol);
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-21 10:07:31.193834921 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-21 10:07:46.366333504 +0800
@@ -102,10 +102,6 @@ static int min_percpu_pagelist_fract = 8
 
 static int ngroups_max = NGROUPS_MAX;
 
-#ifdef CONFIG_MODULES
-extern char *modprobe_path;
-extern int modules_disabled;
-#endif
 #ifdef CONFIG_CHR_DEV_SG
 extern int sg_big_buff;
 #endif
--- linux-2.6.32.orig/include/linux/kmod.h	2010-02-21 10:07:31.203834290 +0800
+++ linux-2.6.32/include/linux/kmod.h	2010-02-21 10:10:25.249652171 +0800
@@ -28,6 +28,7 @@
 #define KMOD_PATH_LEN 256
 
 #ifdef CONFIG_MODULES
+extern char *modprobe_path; /* for sysctl */
 /* modprobe exit status on success, -ve on error.  Return value
  * usually useless though. */
 extern int __request_module(bool wait, const char *name, ...) \
