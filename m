Return-Path: <linux-kernel-owner+w=401wt.eu-S966342AbXEVQEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966342AbXEVQEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759623AbXEVQEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:04:13 -0400
Received: from farad.aurel32.net ([82.232.2.251]:25953 "EHLO mail.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690AbXEVQEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:04:12 -0400
X-Greylist: delayed 1544 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 May 2007 12:04:12 EDT
Date: Tue, 22 May 2007 17:38:26 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
To: linux-kernel@vger.kernel.org
Cc: parisc-linux@lists.parisc-linux.org
Subject: [PATCH] parisc: Disable LWS debugging
Message-ID: <20070522153825.GA16404@farad.aurel32.net>
Mail-Followup-To: Aurelien Jarno <aurelien@aurel32.net>,
	linux-kernel@vger.kernel.org, parisc-linux@lists.parisc-linux.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Mailer: Mutt 1.5.13 (2006-08-11)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The LWS debugging code on parisc is wrongly enabled due to a bug in the
use of the preprocessor directives. This debugging code is not thread 
safe and causes problems with a recent glibc on SMP kernels.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Cc: parisc-linux@lists.parisc-linux.org
---
 syscall.S |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net


diff -u a/arch/parisc/kernel/syscall.S b/arch/parisc/kernel/syscall.S
--- a/arch/parisc/kernel/syscall.S
+++ b/arch/parisc/kernel/syscall.S
@@ -501,7 +501,7 @@
 	shlw	%r20, 4, %r20
 	add	%r20, %r28, %r20
 
-# ifdef ENABLE_LWS_DEBUG
+# if ENABLE_LWS_DEBUG
 	/*	
 		DEBUG, check for deadlock! 
 		If the thread register values are the same
@@ -550,7 +550,7 @@
 		perspective
 	*/
 cas_action:
-#if defined CONFIG_SMP && defined ENABLE_LWS_DEBUG
+#if defined CONFIG_SMP && ENABLE_LWS_DEBUG
 	/* DEBUG */
 	mfctl	%cr27, %r1
 	stw	%r1, 4(%sr2,%r20)
@@ -562,7 +562,7 @@
 #ifdef CONFIG_SMP
 	/* Free lock */
 	stw	%r20, 0(%sr2,%r20)
-# ifdef ENABLE_LWS_DEBUG
+# if ENABLE_LWS_DEBUG
 	/* Clear thread register indicator */
 	stw	%r0, 4(%sr2,%r20)
 # endif
@@ -576,7 +576,7 @@
 #ifdef CONFIG_SMP
 	/* Free lock */
 	stw	%r20, 0(%sr2,%r20)
-# ifdef ENABLE_LWS_DEBUG
+# if ENABLE_LWS_DEBUG
 	stw	%r0, 4(%sr2,%r20)
 # endif
 #endif
