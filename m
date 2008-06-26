Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYFZBEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYFZBEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756104AbYFZBBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:01:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:3760 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbYFZBBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:01:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ev5ZDwXdDRk6AxubRfIAv4FjfWmpid1NKwMtd/WUUrQWz/o/sK/rHu2aPoec0ylcHY
         2QpPprP1suELEI/INeKE1EEfyNF8n9XsEIwXGnp2WE2CFFcW3x5qM4iiqo/JaJwLz44f
         6qS1jbwgx1ED1TZBYW59zc1w3bFqJN6nwpzUA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 09/16] x86: move boot_params back to setup.c
Date: Wed, 25 Jun 2008 17:55:20 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com>
In-Reply-To: <200806251748.06743.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251755.20283.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup.c        |    6 ++++++
 arch/x86/kernel/setup_percpu.c |    6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -114,6 +114,12 @@
 #include <asm/highmem.h>
 #endif
 
+#ifndef CONFIG_DEBUG_BOOT_PARAMS
+struct boot_params __initdata boot_params;
+#else
+struct boot_params boot_params;
+#endif
+
 /* This value is set up by the early boot code to point to the value
    immediately after the boot time page tables.  It contains a *physical*
    address, and must not be in the .bss segment! */
Index: linux-2.6/arch/x86/kernel/setup_percpu.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6/arch/x86/kernel/setup_percpu.c
@@ -15,12 +15,6 @@
 #include <asm/apicdef.h>
 #include <asm/highmem.h>
 
-#ifndef CONFIG_DEBUG_BOOT_PARAMS
-struct boot_params __initdata boot_params;
-#else
-struct boot_params boot_params;
-#endif
-
 #ifdef CONFIG_X86_LOCAL_APIC
 unsigned int num_processors;
 unsigned disabled_cpus __cpuinitdata;


