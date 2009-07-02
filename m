Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbZGBPS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbZGBPS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZGBPSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:18:20 -0400
Received: from ey-out-1920.google.com ([74.125.78.148]:14294 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbZGBPST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:18:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QagfQsN1/I8QfpyrRM/Cm8Hsa13QIB3lzhoncHBSXC8Wyv2ujRIPpnx39FxnL0PwDF
         JQBQe5zzR/H4MvY/X3qFDps45TGqA59VJLIkFO7dMfgznUybBZt4ubsUR+C3R6Lf46Eu
         FO9Bxb1DWArWDBCZCNVukkpGP8CnhNjjZnqwg=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       ralf@linux-mips.org, Jason Wessel <jason.wessel@windriver.com>
Cc: Wu Zhangjin <wuzj@lemote.com>, Yan Hua <yanh@lemote.com>,
       Philippe Vachon <philippe@cowpig.ca>, Zhang Le <r0bertz@gentoo.org>,
       Zhang Fuxin <zhangfx@lemote.com>,
       loongson-dev <loongson-dev@googlegroups.com>,
       Liu Junliang <liujl@lemote.com>, Erwan Lerale <erwan@thiscow.com>,
       Arnaud Patard <apatard@mandriva.com>
Subject: [PATCH v4 01/16] [loongson] eary_printk: Remove existing implementation
Date: Thu,  2 Jul 2009 23:18:09 +0800
Message-Id: <5ba055de70110a166fdffb2871d3207c9abb4d48.1246546684.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1246546684.git.wuzhangjin@gmail.com>
References: <cover.1246546684.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzj@lemote.com>

This patch will remove the existing implementation of early_printk in
fulong. for this old implementation is based on the board-specific
source code(dbg_io.c), but dbg_io.c is out-of-date:

as the commit: 8d60a903d986ffa26c41f0092320a3b9da20bfaf shows, dbg_io.c
is not needed. it will be removed in the next patch, and the new
implementation of early_printk will be added later.

Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
---
 arch/mips/lemote/lm2e/prom.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/mips/lemote/lm2e/prom.c b/arch/mips/lemote/lm2e/prom.c
index 7edc15d..d78cedf 100644
--- a/arch/mips/lemote/lm2e/prom.c
+++ b/arch/mips/lemote/lm2e/prom.c
@@ -21,7 +21,6 @@
 extern unsigned long bus_clock;
 extern unsigned long cpu_clock_freq;
 extern unsigned int memsize, highmemsize;
-extern int putDebugChar(unsigned char byte);
 
 static int argc;
 /* pmon passes arguments in 32bit pointers */
@@ -90,8 +89,3 @@ do {									\
 void __init prom_free_prom_memory(void)
 {
 }
-
-void prom_putchar(char c)
-{
-	putDebugChar(c);
-}
-- 
1.6.2.1

