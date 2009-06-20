Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbZFTUL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbZFTUL5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 16:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbZFTULt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 16:11:49 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:10076 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067AbZFTULs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 16:11:48 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgkFAKvfPErCTtAn/2dsb2JhbACBUcsxhAkF
Date: Sat, 20 Jun 2009 22:11:47 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org
Subject: [PATCH] m68k: restore lost coldfire CLOCK_TICK_RATE
Message-ID: <20090620201147.GA14095@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

The good definition of CLOCK_TICK_RATE for coldfires has been lost in the
merge of m68k and m68knommu include files.  Restore it.  Culprit :
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=ebafc17468d58bd903c886175ca84a4edc69ae1d;hp=34055b806a6334624e7e8af6eefc3aee42372a85

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

diff -r 8dcc271a81a8 arch/m68k/include/asm/timex.h
--- a/arch/m68k/include/asm/timex.h	Thu Jun 18 14:07:46 2009 -0700
+++ b/arch/m68k/include/asm/timex.h	Sat Jun 20 21:46:25 2009 +0200
@@ -3,10 +3,23 @@
  *
  * m68k architecture timex specifications
  */
-#ifndef _ASMm68k_TIMEX_H
-#define _ASMm68k_TIMEX_H
+#ifndef _ASMm68K_TIMEX_H
+#define _ASMm68K_TIMEX_H
 
+#ifdef CONFIG_COLDFIRE
+/*
+ * CLOCK_TICK_RATE should give the underlying frequency of the tick timer
+ * to make ntp work best.  For Coldfires, that's the main clock.
+ */
+#include <asm/coldfire.h>
+#define CLOCK_TICK_RATE	MCF_CLK
+#else
+/*
+ * This default CLOCK_TICK_RATE is probably wrong for many 68k boards
+ * Users of those boards will need to check and modify accordingly
+ */
 #define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
+#endif
 
 typedef unsigned long cycles_t;
 
