Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695AbYJTLXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbYJTLXZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 07:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbYJTLXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 07:23:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:50615 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYJTLXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 07:23:15 -0400
Subject: Re: [PATCH] x86, ioremap: use %pR in printk
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linux-pci@vger.kernel.org,
       yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <1224501352.7654.141.camel@pasglop>
References: <20081020040823.871BDDDDEC@ozlabs.org>
	 <20081020071203.GB12131@elte.hu> <1224491682.7654.135.camel@pasglop>
	 <20081020090502.GB31710@elte.hu>  <20081020110018.GA24579@elte.hu>
	 <1224501352.7654.141.camel@pasglop>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 22:22:48 +1100
Message-Id: <1224501768.7654.144.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-20 at 22:15 +1100, Benjamin Herrenschmidt wrote:
> > so how about something like the two patches below (ontop of Linus's 
> > patch): the first patch introduces a "small" resource pointer printout 
> > format: %pr - the little brother of %pR.
> > 
> > The output format is [0x00001234] - minimum width is 8.
> > 
> > The second patch takes advantage of it in ioremap.c.
> 
> Well, I did the exact same patch except I used the same function
> and just added a flag for "R" vs. "r". However, I didn't post it
> because I wasn't too happy with passing by pointer and I wasn't
> sure whether we wanted to keep the letter after p uppercase or not... In
> any case, I kept it as a thing to discuss after the first one goes in.
> 
> At this stage, I'm tempted to go for a %pP for printing a pointer to
> a phys_addr_t (and that's the same as resource_size_t, just more generic
> nowadays, since those were consolidated).
> 
> Still not too happy with the pointer thing but that's the best we can
> do I suppose without losing gcc type checking.

Oh, and I didn't like having the brackets around something that isn't
a range too but that's a minor details.

Ben.


