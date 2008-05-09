Return-Path: <linux-kernel-owner+w=401wt.eu-S1757229AbYEIGX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229AbYEIGX4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 02:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbYEIGXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 02:23:23 -0400
Received: from ozlabs.org ([203.10.76.45]:42772 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936AbYEIGXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 02:23:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] module: put modversions in vermagic
Date: Fri, 9 May 2008 16:23:17 +1000
User-Agent: KMail/1.9.9
Cc: Jon Masters <jonathan@jonmasters.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805091623.18127.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow a module built without versions altogether to be inserted
into a kernel which expects modversions.

modprobe --force will strip vermagic as well as modversions, so it
won't be effected, but this will make sure that a
non-CONFIG_MODVERSIONS module won't be accidentally inserted into a
CONFIG_MODVERSIONS kernel.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/vermagic.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -r a39eaf516de9 include/linux/vermagic.h
--- a/include/linux/vermagic.h	Thu May 08 14:20:44 2008 +1000
+++ b/include/linux/vermagic.h	Thu May 08 15:18:47 2008 +1000
@@ -17,6 +17,11 @@
 #else
 #define MODULE_VERMAGIC_MODULE_UNLOAD ""
 #endif
+#ifdef CONFIG_MODVERSIONS
+#define MODULE_VERMAGIC_MODVERSIONS "modversions "
+#else
+#define MODULE_VERMAGIC_MODVERSIONS ""
+#endif
 #ifndef MODULE_ARCH_VERMAGIC
 #define MODULE_ARCH_VERMAGIC ""
 #endif
@@ -24,5 +29,6 @@
 #define VERMAGIC_STRING 						\
 	UTS_RELEASE " "							\
 	MODULE_VERMAGIC_SMP MODULE_VERMAGIC_PREEMPT 			\
-	MODULE_VERMAGIC_MODULE_UNLOAD MODULE_ARCH_VERMAGIC
+	MODULE_VERMAGIC_MODULE_UNLOAD MODULE_VERMAGIC_MODVERSIONS	\
+	MODULE_ARCH_VERMAGIC
 
