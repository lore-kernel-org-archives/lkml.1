Return-Path: <linux-kernel-owner+w=401wt.eu-S1760358AbYFPGbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760358AbYFPGbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 02:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758050AbYFPGae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 02:30:34 -0400
Received: from relay2.sgi.com ([192.48.171.30]:54233 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757483AbYFPGaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 02:30:12 -0400
From: Paul Jackson <pj@sgi.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>
Date: Sun, 15 Jun 2008 23:30:11 -0700
Message-Id: <20080616063011.14597.84163.sendpatchset@polaris-admin.engr.sgi.com>
In-Reply-To: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
References: <20080616062945.14597.78009.sendpatchset@polaris-admin.engr.sgi.com>
Subject: [PATCH 6/8] x86 boot: virtualize the efi runtime function callback addresses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

EFI runtime service calls are provided by the EFI firmware
during boot to the kernel as physical addresses.  They must
be mapped to virtual addresses when the running kernel
calls back down to these EFI service routines.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 include/asm-x86/efi.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- linux.orig/include/asm-x86/efi.h	2008-06-10 21:31:24.000000000 -0700
+++ linux/include/asm-x86/efi.h	2008-06-13 03:48:21.086399220 -0700
@@ -68,22 +68,22 @@ extern u64 efi_call6(void *fp, u64 arg1,
 		  (u64)(a4), (u64)(a5), (u64)(a6))
 
 #define efi_call_virt0(f)				\
-	efi_call0((void *)(efi.systab->runtime->f))
+	efi_call0((void *)__va(efi.systab->runtime->f))
 #define efi_call_virt1(f, a1)					\
-	efi_call1((void *)(efi.systab->runtime->f), (u64)(a1))
+	efi_call1((void *)__va(efi.systab->runtime->f), (u64)(a1))
 #define efi_call_virt2(f, a1, a2)					\
-	efi_call2((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2))
+	efi_call2((void *)__va(efi.systab->runtime->f), (u64)(a1), (u64)(a2))
 #define efi_call_virt3(f, a1, a2, a3)					\
-	efi_call3((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_call3((void *)__va(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3))
 #define efi_call_virt4(f, a1, a2, a3, a4)				\
-	efi_call4((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_call4((void *)__va(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4))
 #define efi_call_virt5(f, a1, a2, a3, a4, a5)				\
-	efi_call5((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_call5((void *)__va(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5))
 #define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)			\
-	efi_call6((void *)(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
+	efi_call6((void *)__va(efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
 		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
 extern void *efi_ioremap(unsigned long addr, unsigned long size);

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
