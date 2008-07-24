Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbYGXNcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbYGXNcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbYGXNc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:32:28 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43743 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104AbYGXNc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:32:26 -0400
Subject: Re: [regression] nf_iterate(), BUG: unable to handle kernel NULL
	pointer dereference
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick McHardy <kaber@trash.net>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, w@1wt.eu, davidn@davidnewall.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stefanr@s5r6.in-berlin.de, rjw@sisk.pl, ilpo.jarvinen@helsinki.fi,
       Dave Jones <davej@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <200807242313.47041.nickpiggin@yahoo.com.au>
References: <20080724060448.GA10203@elte.hu>
	 <200807242256.09107.nickpiggin@yahoo.com.au>
	 <20080724130422.GB7426@gondor.apana.org.au>
	 <200807242313.47041.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 24 Jul 2008 16:32:22 +0300
Message-Id: <1216906342.12021.0.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 10:56:08PM +1000, Nick Piggin wrote:
> > > OTOH, skb allocation uses kmalloc don't they? So you could still use
> > > SLOB ksize for that I guess.

On Thursday 24 July 2008 23:04, Herbert Xu wrote:
> > Yes I was referring to the data portion which is kmalloc'ed.
> > That is also why I'm interested in ksize because a priori we
> > don't know exactly how big it's going to be.  However, we do
> > know that statistically 1500 will dominate.
> >
> > I'm not interested in ksize for kmem_cache at all.  So in fact
> > we could have something simpler that's based on kmalloc's rounding
> > algorithm instead.

﻿On Thu, 2008-07-24 at 23:13 +1000, Nick Piggin wrote:
> Yes you could definitely have a function that returns allocated
> bytes for a given kmalloc size. Should be about as fast or faster
> than extracting the size from the kaddr...

Yup, makes sense.

