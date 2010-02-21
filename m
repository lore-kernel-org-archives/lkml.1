Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab0BUOXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:23:52 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:63691 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab0BUOXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:23:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=UGhrP+ANDWl9CVtZmK7+3ErGfw2VNgC3Q5L6yKtizmriSwPvm5IkDc9ptW0P19sVXQ
         htzxZuK5BmStdvQZm0UCU7ta9AFlfgIHrHEGqjcOvBdfZuRxZ7yp3wr7CpDBPyAi8o4C
         bvscOLRx1wrZL9gelOJ6WjxCYQ11bCk439k/8=
Date: Sun, 21 Feb 2010 22:23:39 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: "David S. Miller" <davem@davemloft.net>, Gerd Hoffmann <kraxel@redhat.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 06/17] sysctl extern cleanup - compat
Message-ID: <20100221142339.GA3007@darkstar>
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
 include/linux/compat.h |    1 +
 kernel/sysctl.c        |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.32.orig/include/linux/compat.h	2010-02-21 09:35:58.263191188 +0800
+++ linux-2.6.32/include/linux/compat.h	2010-02-21 09:55:28.093075111 +0800
@@ -17,6 +17,7 @@
 #include <asm/siginfo.h>
 #include <asm/signal.h>
 
+extern int compat_log; /* for sysctl */
 #define compat_jiffies_to_clock_t(x)	\
 		(((unsigned long)(x) * COMPAT_USER_HZ) / HZ)
 
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-21 09:52:58.139756932 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-21 09:55:08.013076578 +0800
@@ -57,6 +57,7 @@
 #include <linux/signal.h>
 #include <linux/binfmts.h>
 #include <linux/pid.h>
+#include <linux/compat.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -72,7 +73,6 @@
 
 /* External variables not in a header file. */
 extern int max_threads;
-extern int compat_log;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
 #ifdef CONFIG_RCU_TORTURE_TEST
