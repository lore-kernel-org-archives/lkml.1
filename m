Return-Path: <linux-kernel-owner+w=401wt.eu-S1763761AbXJTDig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763761AbXJTDig (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 23:38:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746AbXJTDi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 23:38:28 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3803 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752303AbXJTDi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 23:38:27 -0400
Date: Sat, 20 Oct 2007 11:37:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: benh@kernel.crashing.org, Linus Torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] synchronize_irq needs a barrier
Message-ID: <20071020033752.GA20760@gondor.apana.org.au>
References: <1192670742.12879.5.camel@pasglop> <200710200402.43106.maximlevitsky@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710200402.43106.maximlevitsky@gmail.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2007 at 02:02:42AM +0000, Maxim Levitsky wrote:
>
> Thus I now understand that .suspend() should do:
> 
> 	saa_writel(SAA7134_IRQ1, 0);
> 	saa_writel(SAA7134_IRQ2, 0);
> 	saa_writel(SAA7134_MAIN_CTRL, 0);
> 
> 	dev->insuspend = 1;
> 	smp_wmb();

If we patch synchronize_irq() as discussed here then you can
use it in place of smp_wmb() and remove the smp_rmb from the
interrupt handler (the latter is the path that matters).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
