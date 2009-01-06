Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbZAFViA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbZAFViA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbZAFVcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:31 -0500
Received: from mail-gx0-f13.google.com ([209.85.217.13]:42839 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbZAFVc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:32:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=gw9IIwW8uAw3aCzgrrCqB5K08Kf9xLBRdAZr3wcDpKPYK9nF0O0y2T3CpRVO56cVB1
         CG2/wJgsUvnVQsRHIbvTa9pGIzZGV6KPfrHYS6ErwTZQK8ZMaeYdNaRkr9qDK8X48v7g
         ud8jlEbQeHceK7T0qRJDlS+8XoPCL0lL/rFec=
Subject: [PATCH 16/23] h8300: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:53 -0800
Message-Id: <1231277453.964.273.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the new-style arch overrides as well.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/h8300/include/asm/Kbuild      |    1 +
 arch/h8300/include/asm/byteorder.h |    8 +-------
 arch/h8300/include/asm/swab.h      |   10 ++++++++++
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/h8300/include/asm/Kbuild b/arch/h8300/include/asm/Kbuild
index c68e168..27b108a 100644
--- a/arch/h8300/include/asm/Kbuild
+++ b/arch/h8300/include/asm/Kbuild
@@ -1 +1,2 @@
 include include/asm-generic/Kbuild.asm
+unifdef-y += swab.h
diff --git a/arch/h8300/include/asm/byteorder.h b/arch/h8300/include/asm/byteorder.h
index 36e597d..c36b80a 100644
--- a/arch/h8300/include/asm/byteorder.h
+++ b/arch/h8300/include/asm/byteorder.h
@@ -1,13 +1,7 @@
 #ifndef _H8300_BYTEORDER_H
 #define _H8300_BYTEORDER_H
 
-#include <asm/types.h>
-
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
+#include <asm/swab.h>
 #include <linux/byteorder/big_endian.h>
 
 #endif /* _H8300_BYTEORDER_H */
diff --git a/arch/h8300/include/asm/swab.h b/arch/h8300/include/asm/swab.h
new file mode 100644
index 0000000..c108f39
--- /dev/null
+++ b/arch/h8300/include/asm/swab.h
@@ -0,0 +1,10 @@
+#ifndef _H8300_SWAB_H
+#define _H8300_SWAB_H
+
+#include <asm/types.h>
+
+#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
+#  define __SWAB_64_THRU_32__
+#endif
+
+#endif /* _H8300_SWAB_H */
-- 
1.6.1.94.g9388


