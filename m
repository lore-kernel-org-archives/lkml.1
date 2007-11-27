Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbXK0Ox0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbXK0Ox0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 09:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbXK0OxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 09:53:13 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:2006 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755308AbXK0OxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 09:53:11 -0500
Date: Tue, 27 Nov 2007 22:36:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: rusty@rustcorp.com.au, rdreier@cisco.com, ak@suse.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Message-ID: <20071127143601.GA6080@gondor.apana.org.au>
References: <20071127105016.GC24223@one.firstfloor.org> <E1Ix0ws-0001Vh-00@gondolin.me.apana.org.au> <20071127141242.GA26794@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071127141242.GA26794@one.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 03:12:42PM +0100, Andi Kleen wrote:
>
> For Networking: e.g. symbols i put into inet, which are only
> used by protocols (sctp, dccp, udplite, ipv6)

Wait, that's exactly Rusty's point (I think :)

These symbols are exported because they're needed by protocols.
If they weren't available to everyone then it would be difficult
to start writing new protocols.

> I already caught someone doing something wrong with that BTW -- 
> wanrouter clearly does some things it shouldn't be doing. 

Can you be more precise?

> Or the fib namespace, where all the fib functions should be only
> used by the two fib_* modules and ipv6/decnet.

Again, if it's used by decnet then it sounds like it should be
exported because new protocol families may need them.

So based on the network code at least I'm kind of starting to
agree with Rusty now: if a symbol is needed by more than one
in-tree module chances are we want it to be exported for all.

Although I admit I haven't examined your examples elsewhere.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
