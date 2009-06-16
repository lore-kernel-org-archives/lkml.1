Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbZFPOh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbZFPOh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 10:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbZFPOhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 10:37:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:64711 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbZFPOhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 10:37:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v3] asm-generic: drop HARDIRQ_BITS definition from hardirq.h
Date: Tue, 16 Jun 2009 16:37:06 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: Mike Frysinger <vapier.adi@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>
References: <1244903447-23579-1-git-send-email-vapier@gentoo.org> <200906142243.32409.arnd@arndb.de> <20090615164415.GB14053@goodmis.org>
In-Reply-To: <20090615164415.GB14053@goodmis.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906161637.07426.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18L6Pgfew8N+4bq9qo5T1Gs7UcHMkbnTqqtgYw
 HSrE4FOJLJj54wAJTMS9nLsJySMpf89wqrTyMblFF+3omUWFv1
 LbmeIhwoVQ4LFL/N1lAZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Architechtures normally don't need to set a HARDIRQ_BITS
unless they have hardcoded a specific value in assembly.
This drops the definition from asm-generic/hardirq.h, which
results in linux/hardirq.h setting its default of 10.

Both the old default of 8 and the linux/hardirq.h default
of 10 are sufficient because they only limit the number
of nested hardirqs, and we normally run out of stack space
much earlier than exceeding 256 or even 1024 nested interrupts.

Reported-by: Mike Frysinger <vapier@gentoo.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/hardirq.h |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

---

v3: Updated the description.
v2: removed HARDIRQ_BITS definition
v1: original patch from Mike

diff --git a/include/asm-generic/hardirq.h b/include/asm-generic/hardirq.h
index 3d5d2c9..23bb4da 100644
--- a/include/asm-generic/hardirq.h
+++ b/include/asm-generic/hardirq.h
@@ -11,19 +11,6 @@ typedef struct {
 
 #include <linux/irq_cpustat.h>	/* Standard mappings for irq_cpustat_t above */
 
-#ifndef HARDIRQ_BITS
-#define HARDIRQ_BITS	8
-#endif
-
-/*
- * The hardirq mask has to be large enough to have
- * space for potentially all IRQ sources in the system
- * nesting on a single CPU:
- */
-#if (1 << HARDIRQ_BITS) < NR_IRQS
-# error HARDIRQ_BITS is too low!
-#endif
-
 #ifndef ack_bad_irq
 static inline void ack_bad_irq(unsigned int irq)
 {
-- 
1.6.3.1

