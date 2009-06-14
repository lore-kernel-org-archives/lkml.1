Return-Path: <linux-kernel-owner+w=401wt.eu-S1763931AbZFNUou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763931AbZFNUou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758460AbZFNUon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:44:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:58070 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757868AbZFNUom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:44:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: [PATCH] asm-generic: drop HARDIRQ_BITS definition from hardirq.h
Date: Sun, 14 Jun 2009 22:43:31 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>
References: <1244903447-23579-1-git-send-email-vapier@gentoo.org> <200906132318.19208.arnd@arndb.de> <8bd0f97a0906131725l214007fcpfa90e72b03cad2ac@mail.gmail.com>
In-Reply-To: <8bd0f97a0906131725l214007fcpfa90e72b03cad2ac@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200906142243.32409.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX194vZdGIuvqUFmOrrutobEsRYchoZrSSIiuCrY
 dxOmpNGg2eM36KWAew6B43VzCT4PRpQu+6l/nt3V2PA0tSmJlB
 ki8v0YVHZpDwugsRev/SQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/hardirq.h contains a fallback for HARDIRQ_BITS to 10
if it's not defined, so it is pointless to define a default
of 8 in asm/hardirq.h. There does not seem to be a good
reason why an architecture would want to limit the number
of hardirqs this way.

Reported-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/hardirq.h |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)
On Sunday 14 June 2009, Mike Frysinger wrote:

Mike Frysinger wrote:
> is there any downsides to using a "too large" value ?  i.e. if my
> system has less than 256, does it make any difference at all if it's
> set to 10 ?
> -mike

None that I know of. I'm queuing this patch in my asm-generic tree now,
unless Steven or someone else has a better idea.

	Arnd <><

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

