Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab0BUOYP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:24:15 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60907 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab0BUOYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:24:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=EvlO2Fl/mdj3cD5a/OdTEzwfkak8RIRGcCa7G+KIGd1jGnTL30nnaJPh2el62xbBCg
         ZxPffdoMq5vOBhhpfLeL1p5Y0qvyIbLKcVlHrcFhvBXV9VXyg8qFU1doZOOOEU8HpDgd
         QJoWT9v0zS4xj6mAQq5TA1sMhiDeRz/YFlyt0=
Date: Sun, 21 Feb 2010 22:24:01 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 08/17] sysctl extern cleanup - file nr
Message-ID: <20100221142401.GA3010@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

Move sysctl_nr_open_min, sysctl_nr_open_max extern declarations to linux/file.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/file.h |    1 +
 kernel/sysctl.c      |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.32.orig/include/linux/file.h	2010-02-21 09:35:58.126524381 +0800
+++ linux-2.6.32/include/linux/file.h	2010-02-21 09:59:23.183884433 +0800
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 #include <linux/posix_types.h>
 
+extern int sysctl_nr_open_min, sysctl_nr_open_max; /* for sysctl */
 struct file;
 
 extern void __fput(struct file *);
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-21 09:57:19.646397324 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-21 09:58:40.029722800 +0800
@@ -59,6 +59,7 @@
 #include <linux/pid.h>
 #include <linux/compat.h>
 #include <linux/latencytop.h>
+#include <linux/file.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -74,7 +75,6 @@
 
 /* External variables not in a header file. */
 extern int max_threads;
-extern int sysctl_nr_open_min, sysctl_nr_open_max;
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable;
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
