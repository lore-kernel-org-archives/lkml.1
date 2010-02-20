Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab0BTONi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:13:38 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:63928 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab0BTONh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:13:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Cchq82BGryNw1yk9UNb95mjK8XhYSGITJ33tzxTwnpT9c70ukZUohnBgUrp6UzX3vI
         6sQvMmOn2ypqgF+Jt2lH0+6RYOSGkEQzXpVXLYOHh7mOUu9rDXq9DD5F6zMMkYitfl4V
         FkytsALlR0Cym4eeHaWrvLqb6mk7B4YS2zNaw=
Date: Sat, 20 Feb 2010 22:13:28 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: "David S. Miller" <davem@davemloft.net>, Gerd Hoffmann <kraxel@redhat.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>
Subject: [PATCH 07/18] sysctl extern cleanup - compat
Message-ID: <20100220141328.GF3195@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

Move compat_log extern declaration to linux/compat.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/compat.h |    3 +++
 kernel/sysctl.c        |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- linux-2.6.32.orig/include/linux/compat.h	2010-02-20 14:02:24.334925488 +0800
+++ linux-2.6.32/include/linux/compat.h	2010-02-20 14:24:30.405627048 +0800
@@ -17,6 +17,9 @@
 #include <asm/siginfo.h>
 #include <asm/signal.h>
 
+#ifdef CONFIG_SYSCTL
+extern int compat_log;
+#endif
 #define compat_jiffies_to_clock_t(x)	\
 		(((unsigned long)(x) * COMPAT_USER_HZ) / HZ)
 
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-20 14:13:28.511525875 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-20 14:23:58.042295739 +0800
@@ -58,6 +58,7 @@
 #include <linux/threads.h>
 #include <linux/binfmts.h>
 #include <linux/pid.h>
+#include <linux/compat.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -72,7 +73,6 @@
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
-extern int compat_log;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
 #ifdef CONFIG_RCU_TORTURE_TEST
