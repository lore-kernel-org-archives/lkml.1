Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbYEYSGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbYEYSGB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbYEYSFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:05:53 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:52649 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbYEYSFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:05:53 -0400
Date: Sun, 25 May 2008 21:03:16 +0300
From: Adrian Bunk <adrian.bunk@movial.fi>
To: Chris Dearman <chris@mips.com>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] MIPS SEAD compile fix
Message-ID: <20080525180316.GF1791@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error caused by
commit 39b8d5254246ac56342b72f812255c8f7a74dca9
([MIPS] Add support for MIPS CMP platform.):

<--  snip  -->

...
  CC      arch/mips/mips-boards/generic/time.o
cc1: warnings being treated as errors
/home/bunk/linux/kernel-2.6/git/linux-2.6/arch/mips/mips-boards/generic/time.c:63: error: 'ledbitmask' defined but not used
make[2]: *** [arch/mips/mips-boards/generic/time.o] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>

---
a6622e47dd128da338d6dbae457ec1b043604814 diff --git a/arch/mips/mips-boards/generic/time.c b/arch/mips/mips-boards/generic/time.c
index 008fd82..df23558 100644
--- a/arch/mips/mips-boards/generic/time.c
+++ b/arch/mips/mips-boards/generic/time.c
@@ -58,10 +58,14 @@ static int mips_cpu_timer_irq;
 static int mips_cpu_perf_irq;
 extern int cp0_perfcount_irq;
 
+#if defined(CONFIG_MIPS_MALTA) || defined(CONFIG_MIPS_ATLAS)
+
 DEFINE_PER_CPU(unsigned int, tickcount);
 #define tickcount_this_cpu __get_cpu_var(tickcount)
 static unsigned long ledbitmask;
 
+#endif
+
 static void mips_timer_dispatch(void)
 {
 #if defined(CONFIG_MIPS_MALTA) || defined(CONFIG_MIPS_ATLAS)

