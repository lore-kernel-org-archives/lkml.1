Return-Path: <linux-kernel-owner+w=401wt.eu-S1751820AbXDFT3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbXDFT3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 15:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbXDFT3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 15:29:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42252 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbXDFT3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 15:29:42 -0400
Date: Fri, 6 Apr 2007 21:29:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tglx@linutronix.de, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Deprecate SA_xxx interrupt flags -V2
Message-ID: <20070406192937.GA19093@elte.hu>
References: <20070114081905.135797900@inhelltoy.tec.linutronix.de> <20070114081926.912658228@inhelltoy.tec.linutronix.de> <20070123120245.ec3b0772.akpm@osdl.org> <1169584278.21181.86.camel@localhost.localdomain> <1175867366.28263.454.camel@localhost.localdomain> <20070406122228.3dc06c79.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406122228.3dc06c79.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> Yeah.  I tried something like this and code broke.  For example,
> arch/mips/sni/irq.c has
> 
> struct irqaction sni_isa_irq = {
> 	.handler = sni_isa_irq_handler,
> 	.name = "ISA",
> 	.flags = SA_SHIRQ
> };
> 
> there are presumably only a few such stragglers left in the tree but 
> there are probably more instances out-of-tree.

i quick grep suggests that this seems to be the only one left with a 
similar pattern:

 dione:~/linux/ find . -name '*.[ch]' | xargs grep -E '\..*=.*\<SA_' | 
                grep -vE '\;|\(|=='

 ./arch/mips/sni/irq.c:  .flags = SA_SHIRQ

so the patch is fine to me:

 Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
