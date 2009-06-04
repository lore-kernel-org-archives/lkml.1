Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600AbZFDOPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600AbZFDOPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 10:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbZFDOPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 10:15:14 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:61807 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZFDOPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 10:15:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-uid:x-length:to
         :content-type:content-transfer-encoding:content-disposition
         :message-id;
        b=CZEY3Fqj8NnX3XG+PmZqd14DqTBOkeyWNu8oITn/DC3PVNs5oRyt9XxrgOPTDIw4YL
         OMNvGxN62W/vBrVMkStSpVxbdoyw6mptQQa7Lfkr8/jW/9v46hOtcTceBpc//VRUQH2j
         XnLRQ1RSbZN7y+d2Q7dDcwlAc4rIswx94/xik=
From: Florian Fainelli <florian@openwrt.org>
Date: Thu, 4 Jun 2009 16:15:07 +0200
Subject: [PATCH 1/8] add lib/gcd.c
MIME-Version: 1.0
X-Length: 2489
To: "Linux-MIPS" <linux-mips@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Takashi Iwai <tiwai@suse.de>, Ralf Baechle <ralf@linux-mips.org>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906041615.10467.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds lib/gcd.c which contains a greatest
common divider implementation taken from
sound/core/pcm_timer.c

Signed-off-by: Florian Fainelli <florian@openwrt.org>
---
diff --git a/include/linux/gcd.h b/include/linux/gcd.h
new file mode 100644
index 0000000..69f5e8a
--- /dev/null
+++ b/include/linux/gcd.h
@@ -0,0 +1,8 @@
+#ifndef _GCD_H
+#define _GCD_H
+
+#include <linux/compiler.h>
+
+unsigned long gcd(unsigned long a, unsigned long b) __attribute_const__;
+
+#endif /* _GCD_H */
diff --git a/lib/Kconfig b/lib/Kconfig
index 8ade0a7..70a9906 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -10,6 +10,9 @@ menu "Library routines"
 config BITREVERSE
 	tristate
 
+config GCD
+	bool
+
 config GENERIC_FIND_FIRST_BIT
 	bool
 
diff --git a/lib/Makefile b/lib/Makefile
index 33a40e4..389bdd2 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_CRC_ITU_T)	+= crc-itu-t.o
 obj-$(CONFIG_CRC32)	+= crc32.o
 obj-$(CONFIG_CRC7)	+= crc7.o
 obj-$(CONFIG_LIBCRC32C)	+= libcrc32c.o
+obj-$(CONFIG_GCD)	+= gcd.o
 obj-$(CONFIG_GENERIC_ALLOCATOR) += genalloc.o
 
 obj-$(CONFIG_ZLIB_INFLATE) += zlib_inflate/
diff --git a/lib/gcd.c b/lib/gcd.c
new file mode 100644
index 0000000..fbf81a8
--- /dev/null
+++ b/lib/gcd.c
@@ -0,0 +1,20 @@
+#include <linux/gcd.h>
+#include <linux/module.h>
+
+/* Greatest common divisor */
+unsigned long gcd(unsigned long a, unsigned long b)
+{
+	unsigned long r;
+
+	if (a < b) {
+		r = a;
+		a = b;
+	b = r;
+	}
+	while ((r = a % b) != 0) {
+		a = b;
+		b = r;
+	}
+	return b;
+}
+EXPORT_SYMBOL(gcd);
