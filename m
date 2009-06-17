Return-Path: <linux-kernel-owner+w=401wt.eu-S1758995AbZFQQqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995AbZFQQqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbZFQQqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:46:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54410 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbZFQQqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:46:33 -0400
Date: Wed, 17 Jun 2009 18:46:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       linux-crypto@vger.kernel.org
Subject: Re: [RFC 6/7] x86: Move kernel_fpu_using to asm/i387.h
Message-ID: <20090617164622.GB25357@elte.hu>
References: <1244704236.5320.129.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244704236.5320.129.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0005]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Huang Ying <ying.huang@intel.com> wrote:

> This is used by AES-NI accelerated AES implementation and PCLMULQDQ
> accelerated GHASH implementation.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
>  arch/x86/crypto/aesni-intel_glue.c |    7 -------
>  arch/x86/include/asm/i387.h        |    7 +++++++
>  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -59,13 +59,6 @@ asmlinkage void aesni_cbc_enc(struct cry
>  asmlinkage void aesni_cbc_dec(struct crypto_aes_ctx *ctx, u8 *out,
>  			      const u8 *in, unsigned int len, u8 *iv);
>  
> -static inline int kernel_fpu_using(void)
> -{
> -	if (in_interrupt() && !(read_cr0() & X86_CR0_TS))
> -		return 1;
> -	return 0;
> -}
> -
>  static inline struct crypto_aes_ctx *aes_ctx(void *raw_ctx)
>  {
>  	unsigned long addr = (unsigned long)raw_ctx;
> --- a/arch/x86/include/asm/i387.h
> +++ b/arch/x86/include/asm/i387.h
> @@ -302,6 +302,13 @@ static inline void kernel_fpu_end(void)
>  	preempt_enable();
>  }
>  
> +static inline int kernel_fpu_using(void)
> +{
> +	if (in_interrupt() && !(read_cr0() & X86_CR0_TS))
> +		return 1;
> +	return 0;
> +}
> +

Looks sane to me. Herbert, do you ack it?

	Ingo
