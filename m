Return-Path: <linux-kernel-owner+w=401wt.eu-S1759524AbYDPHbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbYDPHbv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 03:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbYDPHbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 03:31:39 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:37997 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755997AbYDPHb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 03:31:28 -0400
Date: Wed, 16 Apr 2008 09:31:08 +0200
From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "Adam J. Richter" <adam@yggdrasil.com>,
       Alexander Kjeldaas <astor@fast.no>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
Message-ID: <20080416073108.GA13494@Chamillionaire.breakpoint.cc>
References: <1207723262.18313.37.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1207723262.18313.37.camel@caritas-dev.intel.com>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Huang, Ying | 2008-04-09 14:41:02 [+0800]:

>This patch increases the performance of AES x86-64 implementation. The
>average increment is more than 6.3% and the max increment is
>more than 10.2% on Intel CORE 2 CPU. The performance increment is
>gained via the following methods:
>
>- Two additional temporary registers are used to hold the subset of
>  the state, so that the dependency between instructions is reduced.
>
>- The expanded key is loaded via 2 64bit load instead of 4 32-bit load.
>

>From your description I would assume that the performance can only
increase. However, on my
|model name      : AMD Athlon(tm) 64 Processor 3200+
the opposite is the case [1], [2]. I dunno why and I didn't mixup
patched & unpached :). I checked this patch on
|model name      : Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz
and the performance really increases [3], [4].

[1] http://download.breakpoint.cc/aes_patch/patched.txt
[2] http://download.breakpoint.cc/aes_patch/unpatched.txt
[3] http://download.breakpoint.cc/aes_patch/perf_patched.txt
[4] http://download.breakpoint.cc/aes_patch/perf_originall.txt

>---
> arch/x86/crypto/aes-x86_64-asm_64.S |  101 ++++++++++++++++++++----------------
> include/crypto/aes.h                |    1 
> 2 files changed, 58 insertions(+), 44 deletions(-)
>
>--- a/include/crypto/aes.h
>+++ b/include/crypto/aes.h
>@@ -19,6 +19,7 @@
> 
> struct crypto_aes_ctx {
> 	u32 key_length;
>+	u32 _pad1;

Why is this pad required? Do you want special alignment of the keys?

> 	u32 key_enc[AES_MAX_KEYLENGTH_U32];
> 	u32 key_dec[AES_MAX_KEYLENGTH_U32];
> };
>

Sebastian
