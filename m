Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab0BTOTz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:19:55 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:36842 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952Ab0BTOTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:19:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=mL0cwoPNyKzKY3t4ZQmiC0NDK2m0CvoCPPKQmiwAjh8W6iKc6HMVQQMUfL3DAYpPzr
         c6Quu/GH6mZ4MQdMp/L7XIofVc2qCQ7mIHRk6ZoKtJ6QAxwdWzP5zkDDB6rLYqDnrEjH
         7EKXrjh+zq1VUJsDajtxvxWebdpHhLiCM4bOA=
Date: Sat, 20 Feb 2010 22:19:46 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 14/18] sysctl extern cleanup - acct
Message-ID: <20100220141946.GM3195@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

Move acct_parm extern declaration to linux/acct.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/acct.h |    6 ++++++
 kernel/sysctl.c      |    5 +----
 2 files changed, 7 insertions(+), 4 deletions(-)

--- linux-2.6.32.orig/include/linux/acct.h	2010-02-20 14:33:09.802240564 +0800
+++ linux-2.6.32/include/linux/acct.h	2010-02-20 14:38:16.134711703 +0800
@@ -20,6 +20,12 @@
 #include <asm/param.h>
 #include <asm/byteorder.h>
 
+#ifdef __KERNEL__
+#if defined(CONFIG_BSD_PROCESS_ACCT) && defined(CONFIG_SYSCTL)
+extern int acct_parm[];
+#endif
+#endif
+
 /* 
  *  comp_t is a 16-bit "floating" point number with a 3-bit base 8
  *  exponent and a 13-bit fraction.
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-20 14:33:09.788907860 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-20 14:35:31.031394432 +0800
@@ -62,6 +62,7 @@
 #include <linux/latencytop.h>
 #include <linux/file.h>
 #include <linux/blk-iopoll.h>
+#include <linux/acct.h>
 #include <scsi/sg.h>
 
 #include <asm/uaccess.h>
@@ -122,10 +123,6 @@ extern int sysctl_userprocess_debug;
 extern int spin_retry;
 #endif
 
-#ifdef CONFIG_BSD_PROCESS_ACCT
-extern int acct_parm[];
-#endif
-
 #ifdef CONFIG_IA64
 extern int no_unaligned_warning;
 extern int unaligned_dump_stack;
