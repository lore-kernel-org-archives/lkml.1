Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab0BTOLp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:11:45 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:35185 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab0BTOLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:11:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Nva95LKsUTqgWWozxKSQ9tFTY6rv7zU3MwgUxkuLFjRsUYR4tedEnsU2Sdtn3PF3uM
         X+VghaFvPXSY+tnHaSUFmCjTdLk3cj6MalHHmQAYq+8Ep6F3W32U3DOaxG+E35AI1uDO
         RoQ4BrUbT1v0PHmonppeYKOd+VKgzNxLs9Vqw=
Date: Sat, 20 Feb 2010 22:11:33 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 05/18] sysctl extern cleanup - pid
Message-ID: <20100220141133.GD3195@darkstar>
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
 include/linux/pid.h |    5 +++++
 kernel/sysctl.c     |    3 +--
 2 files changed, 6 insertions(+), 2 deletions(-)

--- linux-2.6.32.orig/include/linux/pid.h	2010-02-12 13:14:44.865985182 +0800
+++ linux-2.6.32/include/linux/pid.h	2010-02-12 13:16:24.436926508 +0800
@@ -3,6 +3,11 @@
 
 #include <linux/rcupdate.h>
 
+#ifdef CONFIG_SYSCTL
+extern int pid_max;
+extern int pid_max_min, pid_max_max;
+#endif
+
 enum pid_type
 {
 	PIDTYPE_PID,
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-12 13:13:47.572658484 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-12 13:16:53.471807743 +0800
@@ -57,6 +57,7 @@
 #include <linux/signal.h>
 #include <linux/threads.h>
 #include <linux/binfmts.h>
+#include <linux/pid.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -71,9 +72,7 @@
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
-extern int pid_max;
 extern int min_free_kbytes;
-extern int pid_max_min, pid_max_max;
 extern int compat_log;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
