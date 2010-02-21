Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab0BUOXa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:23:30 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:63691 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab0BUOXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:23:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=nIaRsb6fghvfDCiTWq3oqRxz/dKeRDC7kXU4YwJd+HIMaL7GVZuRKqObvyXPx99A6r
         6FvBUKqyBndTrdOK9DnV9TRj4mP3i7XOAy8ptIp4zBGiSHYKXNgFaMnTQMW1kvcp1j5L
         ZdUahFxKtoePhom/UpgxDUeQcL0hdvZFEDsM8=
Date: Sun, 21 Feb 2010 22:23:14 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 04/17] sysctl extern cleanup - pid
Message-ID: <20100221142314.GA3005@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

Move pid/pid_max_min/pid_max_max extern declarations to linux/pid.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/pid.h |    4 ++++
 kernel/sysctl.c     |    3 +--
 2 files changed, 5 insertions(+), 2 deletions(-)

--- linux-2.6.32.orig/include/linux/pid.h	2010-02-21 09:35:58.494024120 +0800
+++ linux-2.6.32/include/linux/pid.h	2010-02-21 09:47:29.753122891 +0800
@@ -3,6 +3,10 @@
 
 #include <linux/rcupdate.h>
 
+/* for sysctl */
+extern int pid_max;
+extern int pid_max_min, pid_max_max;
+
 enum pid_type
 {
 	PIDTYPE_PID,
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-21 09:44:39.479806692 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-21 09:48:06.843951983 +0800
@@ -56,6 +56,7 @@
 #include <linux/rcustring.h>
 #include <linux/signal.h>
 #include <linux/binfmts.h>
+#include <linux/pid.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -71,9 +72,7 @@
 
 /* External variables not in a header file. */
 extern int max_threads;
-extern int pid_max;
 extern int min_free_kbytes;
-extern int pid_max_min, pid_max_max;
 extern int compat_log;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
