Return-Path: <linux-kernel-owner+w=401wt.eu-S1758436AbYA0MiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436AbYA0MiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 07:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbYA0MfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 07:35:16 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:60772 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbYA0MfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 07:35:00 -0500
Message-Id: <20080127123359.028281205@mail.of.borg>
References: <20080127123216.897698766@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 27 Jan 2008 13:32:26 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Adrian Bunk <bunk@kernel.org>
Subject: [patch 10/14] m68k: kill arch/m68k/mvme16x/mvme16x_ksyms.c
Content-Disposition: inline; filename=m68k-kill-arch-m68k-mvme16x-mvme16x_ksyms-c.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

m68k: kill arch/m68k/mvme16x/mvme16x_ksyms.c

EXPORT_SYMBOL's belong to the actual code.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/mvme16x/Makefile        |    2 +-
 arch/m68k/mvme16x/config.c        |    2 ++
 arch/m68k/mvme16x/mvme16x_ksyms.c |    6 ------
 3 files changed, 3 insertions(+), 7 deletions(-)

--- a/arch/m68k/mvme16x/Makefile
+++ b/arch/m68k/mvme16x/Makefile
@@ -2,4 +2,4 @@
 # Makefile for Linux arch/m68k/mvme16x source directory
 #
 
-obj-y		:= config.o rtc.o mvme16x_ksyms.o
+obj-y		:= config.o rtc.o
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
--- a/arch/m68k/mvme16x/mvme16x_ksyms.c
+++ /dev/null
@@ -1,6 +0,0 @@
-#include <linux/module.h>
-#include <linux/types.h>
-#include <asm/ptrace.h>
-#include <asm/mvme16xhw.h>
-
-EXPORT_SYMBOL(mvme16x_config);

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

