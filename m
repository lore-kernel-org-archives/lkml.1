Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbZGTGgB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbZGTGgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 02:36:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbZGTGf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 02:35:59 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:35727 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbZGTGfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 02:35:53 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] PREEMPT_ACTIVE: add default defines
Date: Mon, 20 Jul 2009 02:35:49 -0400
Message-Id: <1248071749-28044-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <200906241602.38422.arnd@arndb.de>
References: <200906241602.38422.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The PREEMPT_ACTIVE setting doesn't actually need to be arch-specific, so
set up a sane default for all arches to (hopefully) migrate to.

> if we look at linux/hardirq.h, it makes this claim:
>  * - bit 28 is the PREEMPT_ACTIVE flag
> if that's true, then why are we letting any arch set this define ?  a
> quick survey shows that half the arches (11) are using 0x10000000 (bit
> 28) while the other half (10) are using 0x4000000 (bit 26).  and then
> there is the ia64 oddity which uses bit 30.  the exact value here
> shouldnt really matter across arches though should it ?

actually alpha, arm and avr32 also use bit 30 (0x40000000), there are only
five (or eight, depending on how you count) architectures (blackfin, h8300,
m68k, s390 and sparc) using bit 26.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/hardirq.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 4525747..41cfbe1 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -62,6 +62,12 @@
 #define HARDIRQ_OFFSET	(1UL << HARDIRQ_SHIFT)
 #define NMI_OFFSET	(1UL << NMI_SHIFT)
 
+#ifndef PREEMPT_ACTIVE
+#define PREEMPT_ACTIVE_BITS	1
+#define PREEMPT_ACTIVE_SHIFT	(NMI_SHIFT + NMI_BITS)
+#define PREEMPT_ACTIVE	(__IRQ_MASK(PREEMPT_ACTIVE_BITS) << PREEMPT_ACTIVE_SHIFT)
+#endif
+
 #if PREEMPT_ACTIVE < (1 << (NMI_SHIFT + NMI_BITS))
 #error PREEMPT_ACTIVE is too low!
 #endif
-- 
1.6.3.3

