Return-Path: <linux-kernel-owner+w=401wt.eu-S1753249AbZKPNw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbZKPNw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 08:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbZKPNw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 08:52:57 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:49971 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750788AbZKPNw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 08:52:56 -0500
Date: Mon, 16 Nov 2009 21:52:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Huang Ying <ying.huang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [BUGFIX -v3 for .32] crypto, gcm, fix another complete call in
	complete fuction
Message-ID: <20091116135258.GA4798@gondor.apana.org.au>
References: <1257838751.22519.2513.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257838751.22519.2513.camel@yhuang-dev.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 03:39:11PM +0800, Huang Ying wrote:
> The flow of the complete function (xxx_done) in gcm.c is as follow:
> 
> void complete(struct crypto_async_request *areq, int err)
> {
> 	struct aead_request *req = areq->data;
> 
> 	if (!err) {
> 		err = async_next_step();
> 		if (err == -EINPROGRESS || err == -EBUSY)
> 			return;
> 	}
> 
> 	complete_for_next_step(areq, err);
> }
> 
> But *areq may be destroyed in async_next_step(), this makes
> complete_for_next_step() can not work properly. To fix this, one of
> following methods is used for each complete function.
> 
> - Add a __complete() for each complete(), which accept struct
>   aead_request *req instead of areq, so avoid using areq after it is
>   destroyed.
> 
> - Expand complete_for_next_step().
> 
> The fixing method is based on the idea of Herbert Xu.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Applied to crypto-2.6.  Thanks a lot!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
