Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992AbZAFVgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbZAFVgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbZAFVcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:25 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:9512 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbZAFVcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:32:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Ft8oST+Crc3ERqYkkCGhiQItww7po9rvTOuK2t/6ScQfwVb5L9g4KQFG+zL+3rgWdq
         jS+Wo+ENYDSUZ13zVcUPp7qt0/I5yt3Zb1X/QSvOtoS8hzw9ux7Laic5ONN2SZ0kFWXY
         KiHnMhofQaWQTj6o/CK8tOsT2l2Ff8EhSt3ek=
Subject: [PATCH 12/23] m68k: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:51 -0800
Message-Id: <1231277451.964.269.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-m68k/Kbuild      |    1 +
 include/asm-m68k/byteorder.h |   16 ++--------------
 include/asm-m68k/swab.h      |   16 ++++++++++++++++
 3 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/include/asm-m68k/Kbuild b/include/asm-m68k/Kbuild
index 1a922fa..52fd96b 100644
--- a/include/asm-m68k/Kbuild
+++ b/include/asm-m68k/Kbuild
@@ -1,2 +1,3 @@
 include include/asm-generic/Kbuild.asm
 header-y += cachectl.h
+unifdef-y += swab.h
diff --git a/include/asm-m68k/byteorder.h b/include/asm-m68k/byteorder.h
index b354acd..3008665 100644
--- a/include/asm-m68k/byteorder.h
+++ b/include/asm-m68k/byteorder.h
@@ -1,19 +1,7 @@
 #ifndef _M68K_BYTEORDER_H
 #define _M68K_BYTEORDER_H
 
-#include <asm/types.h>
-#include <linux/compiler.h>
-
-#define __BIG_ENDIAN
-#define __SWAB_64_THRU_32__
-
-static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
-{
-	__asm__("rolw #8,%0; swap %0; rolw #8,%0" : "=d" (val) : "0" (val));
-	return val;
-}
-#define __arch_swab32 __arch_swab32
-
-#include <linux/byteorder.h>
+#include <asm/swab.h>
+#include <linux/byteorder/big_endian.h>
 
 #endif /* _M68K_BYTEORDER_H */
diff --git a/include/asm-m68k/swab.h b/include/asm-m68k/swab.h
new file mode 100644
index 0000000..7221e30
--- /dev/null
+++ b/include/asm-m68k/swab.h
@@ -0,0 +1,16 @@
+#ifndef _M68K_SWAB_H
+#define _M68K_SWAB_H
+
+#include <asm/types.h>
+#include <linux/compiler.h>
+
+#define __SWAB_64_THRU_32__
+
+static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
+{
+	__asm__("rolw #8,%0; swap %0; rolw #8,%0" : "=d" (val) : "0" (val));
+	return val;
+}
+#define __arch_swab32 __arch_swab32
+
+#endif /* _M68K_SWAB_H */
-- 
1.6.1.94.g9388


