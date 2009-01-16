Return-Path: <linux-kernel-owner+w=401wt.eu-S1761263AbZAPE2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761263AbZAPE2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 23:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbZAPE1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 23:27:55 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:44919 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754679AbZAPE1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 23:27:54 -0500
Date: Fri, 16 Jan 2009 15:27:49 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
Message-ID: <20090116042749.GA11435@gondor.apana.org.au>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090114031613.GA7429@gondor.apana.org.au> <Pine.LNX.4.64.0901141528010.31703@vixen.sonytel.be> <20090115030526.GA27726@gondor.apana.org.au> <alpine.LRH.2.00.0901151149080.16463@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0901151149080.16463@vixen.sonytel.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 11:54:53AM +0100, Geert Uytterhoeven wrote:
>
> But there are pr_debug()s ;-)

Well they must've turned invisible in the copy I received :)

> By "both alloc function", do you mean the .setup_comp() and .setup_decomp()
> functions? If yes, then I understand.

Yes.

> (Yesterday, I thought you meant to have separate alloc functions instead of the
> one crypto_alloc_pcomp())

No we want a single tfm for this.

If we ever get hardware that can handle only one of the two
operations we can always implement software fallbacks as we
do for hashing and encryption.

> I doubt whether it's a good idea to drop the compatibility soon, as the
> underlying LZO library in the kernel doesn't support partial (de)compression,
> and needs significant rework to do so.

Yes but LZO has exactly one user (ubifs) in the kernel and it can
stick to the current interface until we convert it over.  It's
just not worth the extra work to help a single user.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
