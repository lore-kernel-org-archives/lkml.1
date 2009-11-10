Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbZKJDKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbZKJDKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 22:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbZKJDKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 22:10:20 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:37253 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750944AbZKJDKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 22:10:19 -0500
Date: Mon, 9 Nov 2009 22:10:22 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [BUGFIX -v2 for .32] crypto, gcm, fix another complete call in
	complete fuction
Message-ID: <20091110031022.GA13710@gondor.apana.org.au>
References: <1257751454.22519.2287.camel@yhuang-dev.sh.intel.com> <20091109190250.GC9588@gondor.apana.org.au> <1257821399.22519.2410.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257821399.22519.2410.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 10:49:59AM +0800, Huang Ying wrote:
>
> Yes. This is for performance only. Because crypto_gcm_reqctx(req) is not
> so trivial (it needs access tfm), and used by every xxx_done function,
> so I think it is better to just call crypto_gcm_reqctx once and pass it
> down. Do you think so?

Since we only support blocksize == 16, that means the alignment
cannot exceed 16 bytes.  So just always align to 16 bytes and that
should make crypto_gcm_reqctx trivial once optimised by the
compiler.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
