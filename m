Return-Path: <linux-kernel-owner+w=401wt.eu-S1753405AbYGXM4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbYGXM4b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYGXM4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:56:20 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:46939 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751223AbYGXM4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:56:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YmH1gDHr4X4XmYhVXOLTAmn5QYApAqZMOLRPj3YZvbIcMIAipfeXAe/+Dz1iGj8cQfbUldQyY/HeHtlzNvAm8kktPTGRLPNao2Yr4Kg5wZRsZI+oDw3pnqJ+B+52eOLmtt4FqZilJXXK3djm+0Zxd/Oy9WyQ9oOwKM1jYxOY3kk=  ;
X-YMail-OSG: pa.hQcQVM1lKJdxB8wRVoe5bZidmgWmx5iQubgxGPoSFpBs2pHwgHGRwjEDGY_65FCAuWrDmF3lJML8e10dUES.wv39Z7hc.IMUMoJwvYv5Tfks_JY.bTL63T3Tzb9imhLI-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [regression] nf_iterate(), BUG: unable to handle kernel NULL pointer dereference
Date: Thu, 24 Jul 2008 22:56:08 +1000
User-Agent: KMail/1.9.5
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Patrick McHardy <kaber@trash.net>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       w@1wt.eu, davidn@davidnewall.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, stefanr@s5r6.in-berlin.de, rjw@sisk.pl,
       ilpo.jarvinen@helsinki.fi, Dave Jones <davej@redhat.com>,
       Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>
References: <20080724060448.GA10203@elte.hu> <84144f020807240540vbe7ef50uee2cacabe8016546@mail.gmail.com> <20080724125004.GA7426@gondor.apana.org.au>
In-Reply-To: <20080724125004.GA7426@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807242256.09107.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008 22:50, Herbert Xu wrote:
> On Thu, Jul 24, 2008 at 03:40:40PM +0300, Pekka Enberg wrote:
> > Using ksize() for skbs will crash your kernel for some configurations
> > because calling that function for memory allocated with
> > kmem_cache_alloc() is not supported by all the allocators (well,
> > SLOB).
>
> So how about fixing the interface so that it can return an error
> to indicate that the allocator doesn't support it? You're taking
> away an entire interface just because an underlying implementation
> that's used by a very small proportion of users doesn't do the
> right thing.

You could easily add some function which returns a constant error for
SLOB and ksize for others, because slob typically contains very little
slack space (unless explicit alignment is asked for).

OTOH, skb allocation uses kmalloc don't they? So you could still use
SLOB ksize for that I guess.
