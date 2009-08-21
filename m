Return-Path: <linux-kernel-owner+w=401wt.eu-S933047AbZHUVeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047AbZHUVeB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933032AbZHUVeA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:34:00 -0400
Received: from www.tglx.de ([62.245.132.106]:52009 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932966AbZHUVd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:33:58 -0400
Message-Id: <20090821205603.378626007@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 21 Aug 2009 21:32:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86 team <x86@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>, Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alok N Kataria <akataria@vmware.com>,
       Pan Jacob jun <jacob.jun.pan@intel.com>
Subject: [RFC patch 32/32] x86: Move tsc_init to late_time_init
References: <20090821205008.518392436@linutronix.de>
Content-Disposition: inline; filename=x86-move-tsc-init-to-late-time-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not need the TSC before late_time_init. Move the tsc_init to the
late time init code so we can also utilize HPET for calibration (which
we claimed to do but never did except in some older kernel
version). This also helps Moorestown to calibrate the TSC with the
AHBT timer which needs to be initialized in late_time_init like HPET.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/time.c
+++ linux-2.6/arch/x86/kernel/time.c
@@ -107,6 +107,7 @@ void __init hpet_time_init(void)
 static void x86_late_time_init(void)
 {
 	platform_setup.timers.timer_init();
+	tsc_init();
 }
 
 /*
@@ -115,6 +116,5 @@ static void x86_late_time_init(void)
  */
 void __init time_init(void)
 {
-	tsc_init();
 	late_time_init = x86_late_time_init;
 }


