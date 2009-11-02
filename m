Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbZKBHu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbZKBHu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 02:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754003AbZKBHu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 02:50:56 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49966 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154AbZKBHuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 02:50:55 -0500
Date: Mon, 2 Nov 2009 08:50:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Huang Ying <ying.huang@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
       Daniel Walker <dwalker@fifo99.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -v4] crypto: Add PCLMULQDQ accelerated GHASH
	implementation
Message-ID: <20091102075039.GA15942@elte.hu>
References: <1253064946.15717.372.camel@yhuang-dev.sh.intel.com> <20091019025332.GA26624@gondor.apana.org.au> <20091031173015.69e8e9f8.akpm@linux-foundation.org> <20091101175043.GA25257@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091101175043.GA25257@gondor.apana.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> -	pshufb BSWAP, DATA
> +	# pshufb BSWAP, DATA
> +	.byte 0x66, 0x0f, 0x38, 0x00, 0xc5

A cleanup request: mind creating two macros for this PSHUFB MMX/SSE 
instruction in arch/x86/include/asm/i387.h, instead of open-coding the 
.byte sequences in ~6 places?

( After the .33 merge window we'll collect such instruction format 
  knowledge in arch/x86/include/asm/inst.h. That file is not upstream 
  yet so i387.h will do for now for FPU/SSE instructions. )

Thanks,

	Ingo
