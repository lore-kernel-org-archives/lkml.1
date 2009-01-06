Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbZAFVi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbZAFVi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbZAFVcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:36 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:23202 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbZAFVcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:32:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=idRet0CL1ILJGS9aZd009z2XfuVv71llMphMbaHG9xXZqlqAy6Gn6YjpxjvU8iOb7w
         6G4vFLSwyRHGOf6Yn+ZQ2/ig0fVFDdL2KaByFtvnGLCVEY9RM/ZjzZ95IzRwhxoegIqu
         /Wgt2fPst7ICt0ExLIMImOXVlF67l6jkLZ2Ys=
Subject: [PATCH 20/23] m32r: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:56 -0800
Message-Id: <1231277456.964.277.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the new-style arch overrides as well.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-m32r/Kbuild      |    1 +
 include/asm-m32r/byteorder.h |    7 +------
 include/asm-m32r/swab.h      |   10 ++++++++++
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/asm-m32r/Kbuild b/include/asm-m32r/Kbuild
index c68e168..27b108a 100644
--- a/include/asm-m32r/Kbuild
+++ b/include/asm-m32r/Kbuild
@@ -1 +1,2 @@
 include include/asm-generic/Kbuild.asm
+unifdef-y += swab.h
diff --git a/include/asm-m32r/byteorder.h b/include/asm-m32r/byteorder.h
index 10b2c1d..61ff9cf 100644
--- a/include/asm-m32r/byteorder.h
+++ b/include/asm-m32r/byteorder.h
@@ -1,12 +1,7 @@
 #ifndef _ASM_M32R_BYTEORDER_H
 #define _ASM_M32R_BYTEORDER_H
 
-#include <asm/types.h>
-
-#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
+#include <asm/swab.h>
 
 #if defined(__LITTLE_ENDIAN__)
 #  include <linux/byteorder/little_endian.h>
diff --git a/include/asm-m32r/swab.h b/include/asm-m32r/swab.h
new file mode 100644
index 0000000..97973e1
--- /dev/null
+++ b/include/asm-m32r/swab.h
@@ -0,0 +1,10 @@
+#ifndef _ASM_M32R_SWAB_H
+#define _ASM_M32R_SWAB_H
+
+#include <asm/types.h>
+
+#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
+#  define __SWAB_64_THRU_32__
+#endif
+
+#endif /* _ASM_M32R_SWAB_H */
-- 
1.6.1.94.g9388


