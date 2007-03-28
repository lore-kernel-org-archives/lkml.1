Return-Path: <linux-kernel-owner+w=401wt.eu-S934174AbXC1Kwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934174AbXC1Kwy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 06:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934047AbXC1Kwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 06:52:54 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:44783 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934174AbXC1Kwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 06:52:53 -0400
Date: Wed, 28 Mar 2007 19:49:41 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh fixes
Message-ID: <20070328104941.GA24102@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Kristoffer Ericson (1):
      sh: Trivial fix for hp6xx build.

Paul Mundt (2):
      sh: Kill bogus GCC4 symbol exports.
      sh: Fixup __cmpxchg() compile breakage with gcc4.

 arch/sh/kernel/sh_ksyms.c |    3 ---
 include/asm-sh/hp6xx.h    |    6 +++---
 include/asm-sh/system.h   |    1 +
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/sh/kernel/sh_ksyms.c b/arch/sh/kernel/sh_ksyms.c
index fe1b276..6e0d10f 100644
--- a/arch/sh/kernel/sh_ksyms.c
+++ b/arch/sh/kernel/sh_ksyms.c
@@ -82,9 +82,6 @@ DECLARE_EXPORT(__movstr);
 DECLARE_EXPORT(__movmem_i4_even);
 DECLARE_EXPORT(__movmem_i4_odd);
 DECLARE_EXPORT(__movmemSI12_i4);
-DECLARE_EXPORT(__sdivsi3_i4i);
-DECLARE_EXPORT(__udiv_qrnnd_16);
-DECLARE_EXPORT(__udivsi3_i4i);
 #else /* GCC 3.x */
 DECLARE_EXPORT(__movstr_i4_even);
 DECLARE_EXPORT(__movstr_i4_odd);
diff --git a/include/asm-sh/hp6xx.h b/include/asm-sh/hp6xx.h
index f35134c..53ca564 100644
--- a/include/asm-sh/hp6xx.h
+++ b/include/asm-sh/hp6xx.h
@@ -10,9 +10,9 @@
  *
  */
 
-#define HP680_BTN_IRQ		IRQ0_IRQ
-#define HP680_TS_IRQ		IRQ3_IRQ
-#define HP680_HD64461_IRQ	IRQ4_IRQ
+#define HP680_BTN_IRQ		32            /* IRQ0_IRQ */
+#define HP680_TS_IRQ		35            /* IRQ3_IRQ */
+#define HP680_HD64461_IRQ	36            /* IRQ4_IRQ */
 
 #define DAC_LCD_BRIGHTNESS	0
 #define DAC_SPEAKER_VOLUME	1
diff --git a/include/asm-sh/system.h b/include/asm-sh/system.h
index b1e42e7..4a6a19f 100644
--- a/include/asm-sh/system.h
+++ b/include/asm-sh/system.h
@@ -7,6 +7,7 @@
  */
 
 #include <linux/irqflags.h>
+#include <linux/compiler.h>
 #include <asm/types.h>
 
 /*
