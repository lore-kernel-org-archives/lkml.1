Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbZBJGSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbZBJGSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 01:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbZBJGS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 01:18:27 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:58475 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751075AbZBJGS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 01:18:26 -0500
Date: Tue, 10 Feb 2009 17:18:22 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
Message-ID: <20090210061822.GA19774@gondor.apana.org.au>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090114031613.GA7429@gondor.apana.org.au> <Pine.LNX.4.64.0901141528010.31703@vixen.sonytel.be> <20090115030526.GA27726@gondor.apana.org.au> <alpine.LRH.2.00.0902051703150.4290@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0902051703150.4290@vixen.sonytel.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 05:24:51PM +0100, Geert Uytterhoeven wrote:
>
> > Well with the netlink parameters these can have variable lengths
> > depending on how many parameters the user supplies.
> 
> How can this be exported to userspace?
> How does this variable length parameter passing work? Do you have an example?

See how we use it for rtnetlink, e.g., in net/ipv4/ip_gre.c.

> Nothing in crypto/ seems to already use nla_*?

Well we don't have a user-space API yet :) But checkout the
discussions on this list.

> While the core of the crypto system supports two algorithms of the same name
> with different types, the testmgr doesn't.

I was lazy :) But really it isn't too hard to add a type field to
the array in testmgr.  We don't even have to add it for existing
entries (except for the ones that you're trying to replace, i.e.,
deflate).

> As I removed the backwards-compatility layer at your request, I'll use "zlib"
> for the name of the new module. It's more flexible than the fixed "deflate"
> one anyway.
> 
> Is this OK for you?

Hmm, I think we need to have it stay as deflate if we're to make
an easy transition for existing users (e.g., IPsec).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
