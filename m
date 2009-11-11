Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZKKOFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZKKOFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 09:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbZKKOFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 09:05:48 -0500
Received: from www.tglx.de ([62.245.132.106]:47093 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbZKKOFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 09:05:47 -0500
Message-Id: <20091111134229.725664788@linutronix.de>
User-Agent: quilt/0.47-1
Date: Wed, 11 Nov 2009 14:05:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Ralf Baechle <ralf@linux-mips.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 1/3] clockevents: Use u32 for mult and shift factors
References: <20091111134018.393422332@linutronix.de>
Content-Disposition: inline;
	filename=clockevents-use-u32-for-mult-and-shift-factors.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mult and shift factors of clock events differ in their data type
from those of clock sources for no reason. u32 is sufficient for
both. shift is always <= 32 and mult is limited to 2^32-1 to avoid
64bit multiplication overflows in the conversion.

Preparatory patch for a generic mult/shift factor calculation
function.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 include/linux/clockchips.h |    4 ++--
 kernel/time/timer_list.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6-tip/include/linux/clockchips.h
===================================================================
--- linux-2.6-tip.orig/include/linux/clockchips.h
+++ linux-2.6-tip/include/linux/clockchips.h
@@ -79,8 +79,8 @@ struct clock_event_device {
 	unsigned int		features;
 	unsigned long		max_delta_ns;
 	unsigned long		min_delta_ns;
-	unsigned long		mult;
-	int			shift;
+	u32			mult;
+	u32			shift;
 	int			rating;
 	int			irq;
 	const struct cpumask	*cpumask;
Index: linux-2.6-tip/kernel/time/timer_list.c
===================================================================
--- linux-2.6-tip.orig/kernel/time/timer_list.c
+++ linux-2.6-tip/kernel/time/timer_list.c
@@ -206,8 +206,8 @@ print_tickdevice(struct seq_file *m, str
 	SEQ_printf(m, "%s\n", dev->name);
 	SEQ_printf(m, " max_delta_ns:   %lu\n", dev->max_delta_ns);
 	SEQ_printf(m, " min_delta_ns:   %lu\n", dev->min_delta_ns);
-	SEQ_printf(m, " mult:           %lu\n", dev->mult);
-	SEQ_printf(m, " shift:          %d\n", dev->shift);
+	SEQ_printf(m, " mult:           %u\n", dev->mult);
+	SEQ_printf(m, " shift:          %u\n", dev->shift);
 	SEQ_printf(m, " mode:           %d\n", dev->mode);
 	SEQ_printf(m, " next_event:     %Ld nsecs\n",
 		   (unsigned long long) ktime_to_ns(dev->next_event));


