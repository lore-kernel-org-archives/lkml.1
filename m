Return-Path: <linux-kernel-owner+w=401wt.eu-S1762539AbXHJHly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762539AbXHJHly (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 03:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751783AbXHJHlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 03:41:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36283 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbXHJHlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 03:41:46 -0400
Date: Fri, 10 Aug 2007 09:41:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [MTD] Fix CFI build error with meaningless
	nonfunctional .config
Message-ID: <20070810074140.GB28264@elte.hu>
References: <20070806161537.GA1269@elte.hu> <1186717841.7282.104.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1186717841.7282.104.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2007-08-06 at 18:15 +0200, Ingo Molnar wrote:
> > randconfig testing on .23-rc2 triggered the following build error:
> 
> When building NOR flash support, you have compile-time options for the 
> bus width and the number of individual chips which are interleaved 
> together onto that bus. The code to deal with arbitrary geometry is a 
> bit convoluted, and people want to just configure it for the specific 
> hardware they have, to avoid the runtime overhead.
> 
> Selecting _none_ of the available options doesn't make any sense. You 
> should have at least one. This makes it build though, since people 
> persist in trying.

i didnt persist - randconfig picked it - it's a legit .config.

> +#ifndef cfi_interleave
> +#warning No CONFIG_MTD_CFI_Ix selected. No NOR chip support can work.
> +static inline int cfi_interleave(void *cfi)
> +{
> +	BUG();
> +	return 0;

looks quite quirky. Is there no Kconfig-space solution for this?

	Ingo
