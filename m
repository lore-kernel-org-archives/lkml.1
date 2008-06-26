Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbYFZBGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbYFZBGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 21:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757007AbYFZBBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 21:01:53 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:3760 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756683AbYFZBBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 21:01:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=rddSthfBogKGwcl0KSHtSMX+Tm+1BD2Zv2yPelNoxP9LIBoObqu8uadLBWkIV0O84U
         n21Qtk/ofk/yBptpJZlA7nkwX4UUoCDScKEw5woG39dIV1XvBi1mdZ9CAVhgBQeXU54/
         pKYxqSNoJbYsfVI/znX7RjlKI8k/O8HASoBnU=
From: Yinghai Lu <yhlu.kernel@gmail.com>
Reply-To: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 15/16] x86: change some functions in setup.c to static
Date: Wed, 25 Jun 2008 18:00:22 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <200806251748.06743.yhlu.kernel@gmail.com>
In-Reply-To: <200806251748.06743.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806251800.22230.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/setup.c     |    8 ++++----
 include/asm-x86/bootparam.h |    1 -
 include/asm-x86/setup.h     |    5 -----
 3 files changed, 4 insertions(+), 10 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -371,7 +371,7 @@ static void __init reserve_initrd(void)
 }
 #endif /* CONFIG_BLK_DEV_INITRD */
 
-void __init parse_setup_data(void)
+static void __init parse_setup_data(void)
 {
 	struct setup_data *data;
 	u64 pa_data;
@@ -413,7 +413,7 @@ static inline unsigned long long get_tot
 	return total << PAGE_SHIFT;
 }
 
-void __init reserve_crashkernel(void)
+static void __init reserve_crashkernel(void)
 {
 	unsigned long long total_mem;
 	unsigned long long crash_size, crash_base;
@@ -449,7 +449,7 @@ void __init reserve_crashkernel(void)
 	}
 }
 #else
-void __init reserve_crashkernel(void)
+static void __init reserve_crashkernel(void)
 {
 }
 #endif
@@ -477,7 +477,7 @@ static struct resource standard_io_resou
 		.flags = IORESOURCE_BUSY | IORESOURCE_IO }
 };
 
-void __init reserve_standard_io_resources(void)
+static void __init reserve_standard_io_resources(void)
 {
 	int i;
 
Index: linux-2.6/include/asm-x86/bootparam.h
===================================================================
--- linux-2.6.orig/include/asm-x86/bootparam.h
+++ linux-2.6/include/asm-x86/bootparam.h
@@ -109,6 +109,5 @@ struct boot_params {
 } __attribute__((packed));
 
 void reserve_setup_data(void);
-void parse_setup_data(void);
 
 #endif /* _ASM_BOOTPARAM_H */
Index: linux-2.6/include/asm-x86/setup.h
===================================================================
--- linux-2.6.orig/include/asm-x86/setup.h
+++ linux-2.6/include/asm-x86/setup.h
@@ -8,9 +8,6 @@
 /* Interrupt control for vSMPowered x86_64 systems */
 void vsmp_init(void);
 
-/* Crashkernel reservation */
-void reserve_crashkernel(void);
-
 #ifndef CONFIG_PARAVIRT
 #define paravirt_post_allocator_init()	do {} while (0)
 #endif
@@ -38,8 +35,6 @@ void reserve_crashkernel(void);
 #ifndef __ASSEMBLY__
 #include <asm/bootparam.h>
 
-void reserve_standard_io_resources(void);
-
 #ifndef _SETUP
 
 /*
