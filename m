Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbZFKHLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbZFKHLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 03:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759278AbZFKHKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 03:10:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:28492 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758666AbZFKHKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 03:10:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,201,1243839600"; 
   d="scan'208";a="420760997"
Subject: [RFC 6/7] x86: Move kernel_fpu_using to asm/i387.h
From: Huang Ying <ying.huang@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Content-Type: text/plain
Date: Thu, 11 Jun 2009 15:10:36 +0800
Message-Id: <1244704236.5320.129.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is used by AES-NI accelerated AES implementation and PCLMULQDQ
accelerated GHASH implementation.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/crypto/aesni-intel_glue.c |    7 -------
 arch/x86/include/asm/i387.h        |    7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -59,13 +59,6 @@ asmlinkage void aesni_cbc_enc(struct cry
 asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
 			      const u8 *in, unsigned int len, u8 *iv);
 
-static inline int kernel_fpu_using(void)
-{
-	if (in_interrupt() && !(read_cr0() & X86_CR0_TS))
-		return 1;
-	return 0;
-}
-
 static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
 {
 	unsigned long addr = (unsigned long)raw_ctx;
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -302,6 +302,13 @@ static inline void kernel_fpu_end(void)
 	preempt_enable();
 }
 
+static inline int kernel_fpu_using(void)
+{
+	if (in_interrupt() && !(read_cr0() & X86_CR0_TS))
+		return 1;
+	return 0;
+}
+
 /*
  * Some instructions like VIA's padlock instructions generate a spurious
  * DNA fault but don't modify SSE registers. And these instructions


