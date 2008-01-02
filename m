Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbYABOiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbYABOiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 09:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYABOhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 09:37:52 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:36251 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925AbYABOhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 09:37:51 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch] linux/{socket,stat}.h: change __GLIBC__ cruft to __KLIBC__
Date: Wed, 2 Jan 2008 09:37:50 -0500
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801020937.50770.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __GLIBC__ hacks were re-added to the headers because the klibc peeps want
to be lazy.  But rather than properly address things, they just wrongly left
it as __GLIBC__.  This patch changes the __GLIBC__ cruft to __KLIBC__ so real
libcs don't get screwed due to kilbc's laziness.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/linux/socket.h b/include/linux/socket.h
index c22ef1c..90af15b 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -16,7 +16,7 @@ struct __kernel_sockaddr_storage {
 				/* _SS_MAXSIZE value minus size of ss_family */
 } __attribute__ ((aligned(_K_SS_ALIGNSIZE)));	/* force desired alignment */
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__) || defined(__KLIBC__)
 
 #include <asm/socket.h>			/* arch-dependent defines	*/
 #include <linux/sockios.h>		/* the SIOCxxx I/O controls	*/
diff --git a/include/linux/stat.h b/include/linux/stat.h
index 611c398..e8c1943 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -7,7 +7,7 @@
 
 #endif
 
-#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
+#if defined(__KERNEL__) || defined(__KLIBC__)
 
 #define S_IFMT  00170000
 #define S_IFSOCK 0140000
