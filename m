Return-Path: <linux-kernel-owner+w=401wt.eu-S1752499AbYJTIfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbYJTIfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 04:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYJTIfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 04:35:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:48402 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbYJTIfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 04:35:38 -0400
Subject: Re: [PATCH] x86, ioremap: use %pR in printk
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linux-pci@vger.kernel.org,
       yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <20081020071203.GB12131@elte.hu>
References: <20081020040823.871BDDDDEC@ozlabs.org>
	 <20081020071203.GB12131@elte.hu>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 19:34:42 +1100
Message-Id: <1224491682.7654.135.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-20 at 09:12 +0200, Ingo Molnar wrote:
> * Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:
> 
> > This converts things in drivers/pci to use %pR to printout the
> > content of a struct resource instead of hand-casted %llx or
> > other variants.
> > 
> > Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> cool!
> 
>  Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> there's also two places in arch/x86/mm/ioremap.c that could use this 
> straight away - see the (untested) patch below.

No, you don't pass it a phys_addr_t or a resource_size_t, you pass it a
struct resource *

Now, I would have liked to have a way to print a resource_size_t (or
phys_addr_t) but that's harder because we need pointers for the magic
typechecking to work (among others).

Maybe we could create a special format for a pointer-to-resource_size_t
and pass &foo on callers but that's fishy...

Cheers,
Ben.


