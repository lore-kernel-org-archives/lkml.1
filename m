Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbXKERVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbXKERVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:21:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757989AbXKERJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:09:03 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59574 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757979AbXKERJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:09:00 -0500
Date: Mon, 5 Nov 2007 18:08:37 +0100
From: Adrian Bunk <bunk@kernel.org>
To: geert@linux-m68k.org, zippel@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] kill arch/m68k/mvme16x/mvme16x_ksyms.c
Message-ID: <20071105170837.GH12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL's belong to the actual code.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m68k/mvme16x/Makefile        |    2 +-
 arch/m68k/mvme16x/config.c        |    2 ++
 arch/m68k/mvme16x/mvme16x_ksyms.c |    6 ------
 3 files changed, 3 insertions(+), 7 deletions(-)

6eac2ba0976bfb4159dd7dc9f459082edeed2155 
diff --git a/arch/m68k/mvme16x/Makefile b/arch/m68k/mvme16x/Makefile
index 950e82f..edb3f6e 100644
--- a/arch/m68k/mvme16x/Makefile
+++ b/arch/m68k/mvme16x/Makefile
@@ -2,4 +2,4 @@
 # Makefile for Linux arch/m68k/mvme16x source directory
 #
 
-obj-y		:= config.o rtc.o mvme16x_ksyms.o
+obj-y		:= config.o rtc.o
diff --git a/arch/m68k/mvme16x/config.c b/arch/m68k/mvme16x/config.c
index daa7851..24cbc30 100644
--- a/arch/m68k/mvme16x/config.c
+++ b/arch/m68k/mvme16x/config.c
@@ -25,6 +25,7 @@
 #include <linux/genhd.h>
 #include <linux/rtc.h>
 #include <linux/interrupt.h>
+#include <linux/module.h>
 
 #include <asm/bootinfo.h>
 #include <asm/system.h>
@@ -58,6 +59,7 @@ static irq_handler_t tick_handler;
 
 
 unsigned short mvme16x_config;
+EXPORT_SYMBOL(mvme16x_config);
 
 
 int mvme16x_parse_bootinfo(const struct bi_record *bi)
diff --git a/arch/m68k/mvme16x/mvme16x_ksyms.c b/arch/m68k/mvme16x/mvme16x_ksyms.c
deleted file mode 100644
index 4a8a363..0000000
--- a/arch/m68k/mvme16x/mvme16x_ksyms.c
+++ /dev/null
@@ -1,6 +0,0 @@
-#include <linux/module.h>
-#include <linux/types.h>
-#include <asm/ptrace.h>
-#include <asm/mvme16xhw.h>
-
-EXPORT_SYMBOL(mvme16x_config);

