Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbYJJA0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbYJJA0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 20:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbYJJA0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 20:26:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:20892 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbYJJAZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 20:25:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,385,1220252400"; 
   d="scan'208";a="346133679"
Date: Thu, 9 Oct 2008 17:22:04 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Typo in x86 apic.c with DIVISOR setup
Message-ID: <20081010002203.GA23238@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix a typo in x86 apic.c CONFG_X86_64 -> CONFIG_X86_64.
The intention looks like was to have divisor of 1 on x86_64 kernel.

Also, for DIVISOR value of 1 to work, APIC_TDR_DIV should also change
depending on divide by 1 or divide by 16 is used.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/kernel/apic.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: tip/arch/x86/kernel/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic.c	2008-10-09 17:12:39.000000000 -0700
+++ tip/arch/x86/kernel/apic.c	2008-10-09 17:13:29.000000000 -0700
@@ -332,10 +332,12 @@ int lapic_get_maxlvt(void)
  */
 
 /* Clock divisor */
-#ifdef CONFG_X86_64
+#ifdef CONFIG_X86_64
 #define APIC_DIVISOR 1
+#define APIC_TDR_DIV APIC_TDR_DIV_1
 #else
 #define APIC_DIVISOR 16
+#define APIC_TDR_DIV APIC_TDR_DIV_16
 #endif
 
 /*
@@ -369,7 +371,7 @@ static void __setup_APIC_LVTT(unsigned i
 	tmp_value = apic_read(APIC_TDCR);
 	apic_write(APIC_TDCR,
 		(tmp_value & ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE)) |
-		APIC_TDR_DIV_16);
+		APIC_TDR_DIV);
 
 	if (!oneshot)
 		apic_write(APIC_TMICT, clocks / APIC_DIVISOR);
