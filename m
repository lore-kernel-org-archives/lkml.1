Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab0BTO3w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:29:52 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:42597 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab0BTO3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:29:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=rPM5w1RmN2aZwfOj2CeTVlu0xhzjn2Iz7qFYlbrax/8kv5EsLzkgpdN96WEC/F/eut
         7NGo6t84RSwZQhfOo6dWpyo7i4mWzHqm1NUDiDWnSuqDak3nGKUTTjZZApl6o1SN5pDi
         zBJ2P5GukKb8r0hiI/tWTINBo8HfBSlFMLdqY=
Date: Sat, 20 Feb 2010 22:23:12 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
       Eric Paris <eparis@parisplace.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 18/18] sysctl extern cleanup - inotify
Message-ID: <20100220142312.GQ3195@darkstar>
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
 include/linux/inotify.h |    6 ++++++
 kernel/sysctl.c         |    4 +---
 2 files changed, 7 insertions(+), 3 deletions(-)

--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-20 14:43:20.458847237 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-20 14:44:20.745507688 +0800
@@ -45,6 +45,7 @@
 #include <linux/limits.h>
 #include <linux/dcache.h>
 #include <linux/dnotify.h>
+#include <linux/inotify.h>
 #include <linux/syscalls.h>
 #include <linux/vmstat.h>
 #include <linux/nfs_fs.h>
@@ -160,9 +161,6 @@ static struct ctl_table fs_table[];
 static struct ctl_table debug_table[];
 static struct ctl_table dev_table[];
 extern struct ctl_table random_table[];
-#ifdef CONFIG_INOTIFY_USER
-extern struct ctl_table inotify_table[];
-#endif
 
 /* The default sysctl tables: */
 
--- linux-2.6.32.orig/include/linux/inotify.h	2010-02-20 14:02:15.074926187 +0800
+++ linux-2.6.32/include/linux/inotify.h	2010-02-20 14:44:20.745507688 +0800
@@ -69,4 +69,10 @@ struct inotify_event {
 #define IN_CLOEXEC O_CLOEXEC
 #define IN_NONBLOCK O_NONBLOCK
 
+#ifdef __KERNEL__
+#if defined(CONFIG_INOTIFY_USER) && defined(CONFIG_SYSCTL)
+extern struct ctl_table inotify_table[];
+#endif
+#endif
+
 #endif	/* _LINUX_INOTIFY_H */
