Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456Ab0AGAwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456Ab0AGAwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 19:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756338Ab0AGAw3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 19:52:29 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:51028 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756066Ab0AGAw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 19:52:28 -0500
Date: Thu, 07 Jan 2010 00:49:54 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
To: albin.tonnerre@free-electrons.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-embedded@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH V2 6/8] lzma: Make lzma available to non initramfs/initrd
 code
Message-ID: <4b452fb2.pHrkBSPmj0OXtjq3%phillip@lougher.demon.co.uk>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix up patch resend using a nice and dumb email client.
If I'm lucky, email readers may even get the threading right :-)

Phillip

>From 1cf6d32e1427398368ff189aece68aa533092e98 Mon Sep 17 00:00:00 2001
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Wed, 6 Jan 2010 23:50:12 +0000
Subject: [PATCH] lzo: Fix-up add support for lzo compressed kernels patch

The add support for lzo compressed kernels patch relies on
INIT and error definitions which have been moved to
separate xxx_mm.h files for each decompressor.

This patch adds a unlzo_mm.h file which supplies these
definitions.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 include/linux/decompress/unlzo_mm.h |   13 +++++++++++++
 lib/decompress_unlzo.c              |    1 +
 2 files changed, 14 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/decompress/unlzo_mm.h

diff --git a/include/linux/decompress/unlzo_mm.h b/include/linux/decompress/unlzo_mm.h
new file mode 100644
index 0000000..27fe0ab
--- /dev/null
+++ b/include/linux/decompress/unlzo_mm.h
@@ -0,0 +1,13 @@
+#ifndef UNLZO_MM_H
+#define UNLZO_MM_H
+
+#ifdef STATIC
+/* Code active when included from pre-boot environment: */
+#define INIT
+#else
+/* Compile for initramfs/initrd code only */
+#define INIT __init
+static void(*error)(char *m);
+#endif
+
+#endif
diff --git a/lib/decompress_unlzo.c b/lib/decompress_unlzo.c
index db521f4..edd82c3 100644
--- a/lib/decompress_unlzo.c
+++ b/lib/decompress_unlzo.c
@@ -39,6 +39,7 @@
 
 #include <linux/types.h>
 #include <linux/lzo.h>
+#include <linux/decompress/unlzo_mm.h>
 #include <linux/decompress/mm.h>
 
 #include <linux/compiler.h>
-- 
1.6.3.3

