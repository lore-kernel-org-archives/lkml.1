Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbYFSTOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbYFSTOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 15:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbYFSTOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 15:14:21 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:61830 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbYFSTOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 15:14:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=rrZrFAWEdxqjtgGHT7My3AjhDQXAwpXiFR7ZRY5wNMs4tIAr5rAfuTaoh1j/4uSBT7
         J1oiWnevImyVj3qR/YfPOXO321dRAPEfd/XuZy4VWnWUwKzCg1FeeISn2Mq4glP8P/Fq
         Ry0MlPQVqxsPjxmxUahvHnrZyuK3OSakkr/wc=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: fix compiling when CONFIG_X86_MPPARSE is not set
Date: Thu, 19 Jun 2008 12:15:01 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200805041823.57198.yhlu.kernel@gmail.com> <200806190018.45944.yhlu.kernel@gmail.com> <200806191213.10312.yhlu.kernel@gmail.com>
In-Reply-To: <200806191213.10312.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806191215.01538.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/Kconfig            |    2 +-
 arch/x86/mm/k8topology_64.c |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -289,7 +289,7 @@ if X86_GENERICARCH
 
 config X86_NUMAQ
 	bool "NUMAQ (IBM/Sequent)"
-	depends on SMP && X86_32 && PCI
+	depends on SMP && X86_32 && PCI && X86_MPPARSE
 	select NUMA
 	help
 	  This option is used for getting Linux to run on a NUMAQ (IBM/Sequent)
Index: linux-2.6/arch/x86/mm/k8topology_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/k8topology_64.c
+++ linux-2.6/arch/x86/mm/k8topology_64.c
@@ -57,18 +57,22 @@ static __init void early_get_boot_cpu_id
 	/*
 	 * Find possible boot-time SMP configuration:
 	 */
+#ifdef CONFIG_X86_MPPARSE
 	early_find_smp_config();
+#endif
 #ifdef CONFIG_ACPI
 	/*
 	 * Read APIC information from ACPI tables.
 	 */
 	early_acpi_boot_init();
 #endif
+#ifdef CONFIG_X86_MPPARSE
 	/*
 	 * get boot-time SMP configuration:
 	 */
 	if (smp_found_config)
 		early_get_smp_config();
+#endif
 	early_init_lapic_mapping();
 }
 
