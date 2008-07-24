Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbYGXMXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbYGXMXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 08:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755164AbYGXMWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 08:22:48 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:38190 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751431AbYGXMWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 08:22:47 -0400
Date: Thu, 24 Jul 2008 20:22:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Patrick McHardy <kaber@trash.net>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>, w@1wt.eu,
       davidn@davidnewall.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, stefanr@s5r6.in-berlin.de, rjw@sisk.pl,
       ilpo.jarvinen@helsinki.fi, Dave Jones <davej@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [regression] nf_iterate(), BUG: unable to handle kernel NULL pointer dereference
Message-ID: <20080724122203.GA7187@gondor.apana.org.au>
References: <20080724060448.GA10203@elte.hu> <E1KLwlD-0001Ub-00@gondolin.me.apana.org.au> <20080724.022259.113079007.davem@davemloft.net> <20080724093411.GA12001@elte.hu> <20080724115625.GA23994@elte.hu> <20080724115957.GA25701@elte.hu> <48886FA6.6050908@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48886FA6.6050908@trash.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 02:03:50PM +0200, Patrick McHardy wrote:
>
> Does reverting 31d8519c fix this?

Regardless of whether this is the problem, banning ksize because
it can be abused is like banning cars because they can kill people.

For example, Ethernet skbs are 1500 bytes long, so using ksize
we could potentially use the left-over memory for temporary storage.
Without it all this memory goes to waste.  On a machine that's
doing a lot of networking this could save a signifcant amount
of memory.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
