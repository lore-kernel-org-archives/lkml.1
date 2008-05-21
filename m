Return-Path: <linux-kernel-owner+w=401wt.eu-S935589AbYEUX7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935589AbYEUX7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 19:59:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758499AbYEUX73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:59:29 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:42872 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757202AbYEUX72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:59:28 -0400
Date: Thu, 22 May 2008 07:59:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: martin@strongswan.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.26-rc3] xfrm: Installing NULL encryption IPSec SAs fails
Message-ID: <20080521235922.GB27138@gondor.apana.org.au>
References: <1211388907.26331.10.camel@martin> <20080521.133756.240329422.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080521.133756.240329422.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 01:37:56PM -0700, David Miller wrote:
> From: Martin Willi <martin@strongswan.org>
> Date: Wed, 21 May 2008 11:55:06 -0500
> 
> > ﻿Installing NULL encryption IPSec SAs works using the .compat name
> > "cipher_null", but fails with the .name "ecp(cipher_null)" due the
> > missing check in key length verification. 
> > ﻿
> > Signed-off-by: Martin Willi <martin@strongswan.org>
> 
> Herbert does this look Ok to you?

I think we should get rid of the zero check altogether as a
zero-length key will fail on setkey of a real algorithm anyway
because of the min_keysize/max_keysize checks in the crypto API.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
