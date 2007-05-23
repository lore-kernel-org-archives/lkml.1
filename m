Return-Path: <linux-kernel-owner+w=401wt.eu-S1764528AbXEWM3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764528AbXEWM3W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 08:29:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbXEWM3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 08:29:15 -0400
Received: from rwcrmhc15.comcast.net ([216.148.227.155]:34273 "EHLO
	rwcrmhc15.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbXEWM3O (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 08:29:14 -0400
Subject: [PATCH 2.6.21-rt7] rtc_fix_missing_ENDIF
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: LKML <Linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: The Big Corporation
Date: Wed, 23 May 2007 05:29:12 -0700
Message-Id: <1179923352.25500.302.camel@sx.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


A change between rt6 and rt7 dropped a #endif in rtc.c.

Compile fails on imbalanced pre-processor directives.

I think that this is correct for Sparc and MIPS, and it definitely
eliminates complaints about PCI_IRQ_NONE definitions for x86.

signed-off-by: Sven-Thorsten Dietrich <sven@thebigcorporation.com>


Index: linux-2.6.21/drivers/char/rtc.c
===================================================================
--- linux-2.6.21.orig/drivers/char/rtc.c
+++ linux-2.6.21/drivers/char/rtc.c
@@ -93,13 +93,14 @@
 #include <asm/isa.h>
 #endif
 
+static unsigned long rtc_port;
+static int rtc_irq = PCI_IRQ_NONE;
+#endif
+
 #ifdef CONFIG_MIPS
 # include <asm/time.h>
 #endif
 
-static unsigned long rtc_port;
-static int rtc_irq = PCI_IRQ_NONE;
-
 #ifdef CONFIG_RTC_HISTOGRAM
 
 static cycles_t last_interrupt_time;

