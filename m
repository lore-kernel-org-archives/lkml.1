Return-Path: <linux-kernel-owner+w=401wt.eu-S1752571AbYJTJF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbYJTJF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 05:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbYJTJFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 05:05:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51399 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYJTJFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 05:05:17 -0400
Date: Mon, 20 Oct 2008 11:05:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linux-pci@vger.kernel.org,
       yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] x86, ioremap: use %pR in printk
Message-ID: <20081020090502.GB31710@elte.hu>
References: <20081020040823.871BDDDDEC@ozlabs.org> <20081020071203.GB12131@elte.hu> <1224491682.7654.135.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224491682.7654.135.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Mon, 2008-10-20 at 09:12 +0200, Ingo Molnar wrote:
> > * Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> > 
> > > This converts things in drivers/pci to use %pR to printout the
> > > content of a struct resource instead of hand-casted %llx or
> > > other variants.
> > > 
> > > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > 
> > cool!
> > 
> >  Acked-by: Ingo Molnar <mingo@elte.hu>
> > 
> > there's also two places in arch/x86/mm/ioremap.c that could use this 
> > straight away - see the (untested) patch below.
> 
> No, you don't pass it a phys_addr_t or a resource_size_t, you pass it a
> struct resource *

oops ... i only looked at:

+       char sym[4*sizeof(resource_size_t) + 8];

and assumed that it was a resource_size_t printout format :-/

while printing out ranges is useful too, it's by far not the only source 
of ugliness all around resource_size_t.

> Now, I would have liked to have a way to print a resource_size_t (or 
> phys_addr_t) but that's harder because we need pointers for the magic 
> typechecking to work (among others).
> 
> Maybe we could create a special format for a 
> pointer-to-resource_size_t and pass &foo on callers but that's 
> fishy...

would be very nice to just have support for all the native types that 
the kernel uses. %pR is still a convenient shortcut.

	Ingo
