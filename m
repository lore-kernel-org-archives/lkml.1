Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbYE1QF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbYE1QF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 12:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbYE1QFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 12:05:48 -0400
Received: from gw.goop.org ([64.81.55.164]:33870 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbYE1QFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 12:05:47 -0400
Message-ID: <483D82BB.8040005@goop.org>
Date: Wed, 28 May 2008 17:05:15 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] arch/sh: use __page_aligned_bss
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch "make page-aligned data and bss less fragile" introduces
__page_aligned_data and __page_aligned_bss to make sure that page
aligned things remain so, even if there are non-page-sized
page-aligned things.

This paragraph converts the two C instances of page-aligned bss
variables to use them.  It's a purely decorative patch.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/kernel/irq.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

===================================================================
--- a/arch/sh/kernel/irq.c
+++ b/arch/sh/kernel/irq.c
@@ -9,6 +9,7 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/linkage.h>
 #include <linux/kernel_stat.h>
 #include <linux/seq_file.h>
 #include <asm/processor.h>
@@ -157,11 +158,8 @@
 }
 
 #ifdef CONFIG_IRQSTACKS
-static char softirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
-
-static char hardirq_stack[NR_CPUS * THREAD_SIZE]
-		__attribute__((__section__(".bss.page_aligned")));
+static char softirq_stack[NR_CPUS * THREAD_SIZE] __page_aligned_bss;
+static char hardirq_stack[NR_CPUS * THREAD_SIZE] __page_aligned_bss;
 
 /*
  * allocate per-cpu stacks for hardirq and for softirq processing


