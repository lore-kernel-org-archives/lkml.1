Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbXEXUKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbXEXUKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 16:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbXEXUKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 16:10:36 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41770 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbXEXUKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 16:10:34 -0400
Date: Thu, 24 May 2007 22:11:33 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       sparclinux@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] asm-generic: add RO_DATA which take alignment parameter
Message-ID: <20070524201133.GD1109@uranus.ravnborg.org>
References: <20070524200440.GA1109@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070524200440.GA1109@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

RODATA has a hardcoded alignment of 4096 but architectures
may which to decide their optimal alignmnet.
Introduce RO_DATA that takes an alignment parameter.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 include/asm-generic/vmlinux.lds.h |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 8307b1b..5388c41 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -14,8 +14,8 @@
 	*(.data)							\
 	*(.data.init.refok)
 
-#define RODATA								\
-	. = ALIGN(4096);						\
+#define RO_DATA(align)							\
+	. = ALIGN((align));						\
 	.rodata           : AT(ADDR(.rodata) - LOAD_OFFSET) {		\
 		VMLINUX_SYMBOL(__start_rodata) = .;			\
 		*(.rodata) *(.rodata.*)					\
@@ -135,7 +135,10 @@
 		VMLINUX_SYMBOL(__end_rodata) = .;			\
 	}								\
 									\
-	. = ALIGN(4096);
+	. = ALIGN((align));
+
+/* for backward compatibility */
+#define RODATA RO_DATA(4096)
 
 #define SECURITY_INIT							\
 	.security_initcall.init : AT(ADDR(.security_initcall.init) - LOAD_OFFSET) { \
-- 
1.5.1.rc3.20.gaa453

