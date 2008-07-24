Return-Path: <linux-kernel-owner+w=401wt.eu-S1752175AbYGXMvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbYGXMvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbYGXMuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:50:52 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:51076 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754429AbYGXMuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:50:51 -0400
Date: Thu, 24 Jul 2008 20:50:04 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Patrick McHardy <kaber@trash.net>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>, w@1wt.eu, davidn@davidnewall.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stefanr@s5r6.in-berlin.de, rjw@sisk.pl, ilpo.jarvinen@helsinki.fi,
       Dave Jones <davej@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [regression] nf_iterate(), BUG: unable to handle kernel NULL pointer dereference
Message-ID: <20080724125004.GA7426@gondor.apana.org.au>
References: <20080724060448.GA10203@elte.hu> <E1KLwlD-0001Ub-00@gondolin.me.apana.org.au> <20080724.022259.113079007.davem@davemloft.net> <20080724093411.GA12001@elte.hu> <20080724115625.GA23994@elte.hu> <20080724115957.GA25701@elte.hu> <48886FA6.6050908@trash.net> <20080724122203.GA7187@gondor.apana.org.au> <84144f020807240540vbe7ef50uee2cacabe8016546@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020807240540vbe7ef50uee2cacabe8016546@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 03:40:40PM +0300, Pekka Enberg wrote:
>
> Using ksize() for skbs will crash your kernel for some configurations
> because calling that function for memory allocated with
> kmem_cache_alloc() is not supported by all the allocators (well,
> SLOB).

So how about fixing the interface so that it can return an error
to indicate that the allocator doesn't support it? You're taking
away an entire interface just because an underlying implementation
that's used by a very small proportion of users doesn't do the
right thing.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
