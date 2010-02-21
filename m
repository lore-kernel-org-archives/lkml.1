Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab0BUOZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:25:58 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:58923 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab0BUOZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:25:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qp/oMKOl1QO5qDV/SdDNLnbA8baAwANArrClYKThbwcbjaLlQ6EuHXTRf/9CXBXxeI
         3h1DZnXM3S3TiQD/XJtX1et90uhT+vwhlw9LXt8lOA+aiD4F8ejvnIKVRyU3tssuzOgf
         hM/QkStWxAKGRNyNzfDJcUMwsIbq7VsP4fwM8=
Date: Sun, 21 Feb 2010 22:25:46 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
       Eric Paris <eparis@parisplace.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 17/17] sysctl extern cleanup - inotify
Message-ID: <20100221142546.GA3031@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

Move inotify_table extern declaration to linux/inotify.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/inotify.h |    5 +++++
 kernel/sysctl.c         |    6 +++---
 2 files changed, 8 insertions(+), 3 deletions(-)

--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-21 11:25:35.455865983 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-21 11:27:43.782519869 +0800
@@ -75,6 +75,9 @@
 #ifdef CONFIG_EPOLL
 #include <linux/poll.h>
 #endif
+#ifdef CONFIG_INOTIFY_USER
+#include <linux/inotify.h>
+#endif
 #ifdef CONFIG_CHR_DEV_SG
 #include <scsi/sg.h>
 #endif
@@ -174,9 +177,6 @@ static struct ctl_table fs_table[];
 static struct ctl_table debug_table[];
 static struct ctl_table dev_table[];
 extern struct ctl_table random_table[];
-#ifdef CONFIG_INOTIFY_USER
-extern struct ctl_table inotify_table[];
-#endif
 
 /* The default sysctl tables: */
 
--- linux-2.6.32.orig/include/linux/inotify.h	2010-02-21 11:25:35.465866403 +0800
+++ linux-2.6.32/include/linux/inotify.h	2010-02-21 11:28:20.686684371 +0800
@@ -69,4 +69,9 @@ struct inotify_event {
 #define IN_CLOEXEC O_CLOEXEC
 #define IN_NONBLOCK O_NONBLOCK
 
+#ifdef __KERNEL__
+#include <linux/sysctl.h>
+extern struct ctl_table inotify_table[]; /* for sysctl */
+#endif
+
 #endif	/* _LINUX_INOTIFY_H */
