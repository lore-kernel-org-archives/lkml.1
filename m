Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbZAFVin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbZAFVin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:38:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754357AbZAFVce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:32:34 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:9512 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311AbZAFVcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:32:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=b6iwoJIAVPXuKipbh1GMWYL24jOXGUYWZzcBm3z9m4wtEQzsCgRbzEzwvX3xv9NRxT
         OGt1YCiKuhN2W9318rsorSRCeibgJqN99CA69DE2xWDD0yZZ4Xfye0UKgk81BlnFHi29
         cnxRVuyAAP3c663Oym1YfAOWnl8DOWEbtDtC8=
Subject: [PATCH 19/23] frv: introduce asm/swab.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 13:30:55 -0800
Message-Id: <1231277455.964.276.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the new-style arch overrides as well.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-frv/Kbuild      |    1 +
 include/asm-frv/byteorder.h |    8 +-------
 include/asm-frv/swab.h      |   10 ++++++++++
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/asm-frv/Kbuild b/include/asm-frv/Kbuild
index 0f8956d..1f44e7c 100644
--- a/include/asm-frv/Kbuild
+++ b/include/asm-frv/Kbuild
@@ -3,3 +3,4 @@ include include/asm-generic/Kbuild.asm
 header-y += registers.h
 
 unifdef-y += termios.h
+unifdef-y += swab.h
diff --git a/include/asm-frv/byteorder.h b/include/asm-frv/byteorder.h
index 411bec3..1187e51 100644
--- a/include/asm-frv/byteorder.h
+++ b/include/asm-frv/byteorder.h
@@ -1,13 +1,7 @@
 #ifndef _ASM_BYTEORDER_H
 #define _ASM_BYTEORDER_H
 
-#include <asm/types.h>
-
-#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
-#  define __BYTEORDER_HAS_U64__
-#  define __SWAB_64_THRU_32__
-#endif
-
+#include <asm/swab.h>
 #include <linux/byteorder/big_endian.h>
 
 #endif /* _ASM_BYTEORDER_H */
diff --git a/include/asm-frv/swab.h b/include/asm-frv/swab.h
new file mode 100644
index 0000000..afb3396
--- /dev/null
+++ b/include/asm-frv/swab.h
@@ -0,0 +1,10 @@
+#ifndef _ASM_SWAB_H
+#define _ASM_SWAB_H
+
+#include <asm/types.h>
+
+#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
+#  define __SWAB_64_THRU_32__
+#endif
+
+#endif /* _ASM_SWAB_H */
-- 
1.6.1.94.g9388


