Return-Path: <linux-kernel-owner+w=401wt.eu-S1422938AbXCGRTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422938AbXCGRTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:19:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422890AbXCGRSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:18:47 -0500
Received: from ns2.suse.de ([195.135.220.15]:43735 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422905AbXCGRSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:18:09 -0500
Message-Id: <20070307171624.981519442@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:12:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       takata@linux-m32r.org
Subject: [patch 087/101] m32r: build fix for processors without ISA_DSP_LEVEL2
Content-Disposition: inline; filename=m32r-build-fix-for-processors-without-isa_dsp_level2.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Hirokazu Takata <takata@linux-m32r.org>

Additional fixes for processors without ISA_DSP_LEVEL2.  sigcontext_t does not
have dummy_acc1h, dummy_acc1l members any longer.

Signed-off-by: Hirokazu Takata <takata@linux-m32r.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/m32r/kernel/process.c |    2 +-
 arch/m32r/kernel/signal.c  |   26 ++++----------------------
 2 files changed, 5 insertions(+), 23 deletions(-)

--- linux-2.6.20.1.orig/arch/m32r/kernel/process.c
+++ linux-2.6.20.1/arch/m32r/kernel/process.c
@@ -174,7 +174,7 @@ void show_regs(struct pt_regs * regs)
 	  regs->acc1h, regs->acc1l);
 #elif defined(CONFIG_ISA_M32R2) || defined(CONFIG_ISA_M32R)
 	printk("ACCH[%08lx]:ACCL[%08lx]\n", \
-	  regs->acch, regs->accl);
+	  regs->acc0h, regs->acc0l);
 #else
 #error unknown isa configuration
 #endif
--- linux-2.6.20.1.orig/arch/m32r/kernel/signal.c
+++ linux-2.6.20.1/arch/m32r/kernel/signal.c
@@ -109,19 +109,10 @@ restore_sigcontext(struct pt_regs *regs,
 	COPY(r10);
 	COPY(r11);
 	COPY(r12);
-#if defined(CONFIG_ISA_M32R2) && defined(CONFIG_ISA_DSP_LEVEL2)
 	COPY(acc0h);
 	COPY(acc0l);
-	COPY(acc1h);
-	COPY(acc1l);
-#elif defined(CONFIG_ISA_M32R2) || defined(CONFIG_ISA_M32R)
-	COPY(acch);
-	COPY(accl);
-	COPY(dummy_acc1h);
-	COPY(dummy_acc1l);
-#else
-#error unknown isa configuration
-#endif
+	COPY(acc1h);		/* ISA_DSP_LEVEL2 only */
+	COPY(acc1l);		/* ISA_DSP_LEVEL2 only */
 	COPY(psw);
 	COPY(bpc);
 	COPY(bbpsw);
@@ -196,19 +187,10 @@ setup_sigcontext(struct sigcontext __use
 	COPY(r10);
 	COPY(r11);
 	COPY(r12);
-#if defined(CONFIG_ISA_M32R2) && defined(CONFIG_ISA_DSP_LEVEL2)
 	COPY(acc0h);
 	COPY(acc0l);
-	COPY(acc1h);
-	COPY(acc1l);
-#elif defined(CONFIG_ISA_M32R2) || defined(CONFIG_ISA_M32R)
-	COPY(acch);
-	COPY(accl);
-	COPY(dummy_acc1h);
-	COPY(dummy_acc1l);
-#else
-#error unknown isa configuration
-#endif
+	COPY(acc1h);		/* ISA_DSP_LEVEL2 only */
+	COPY(acc1l);		/* ISA_DSP_LEVEL2 only */
 	COPY(psw);
 	COPY(bpc);
 	COPY(bbpsw);

--
