Return-Path: <linux-kernel-owner+w=401wt.eu-S1762232AbXIKCSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762232AbXIKCSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 22:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761656AbXIKCS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 22:18:29 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1322 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757143AbXIKCS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 22:18:28 -0400
Date: Tue, 11 Sep 2007 10:18:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: jamal <hadi@cyberus.ca>
Cc: Christian Kujau <lists@nerdbynature.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.23-rc5: possible irq lock inversion dependency detected
Message-ID: <20070911021812.GA1544@gondor.apana.org.au>
References: <alpine.DEB.0.999.0709021455510.7103@sheep.housecafe.de> <20070910130024.GA27939@gondor.apana.org.au> <1189469081.14002.3.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189469081.14002.3.camel@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 08:04:41PM -0400, jamal wrote:
>
> disabling BH would make it more symmetric to the way we handle
> egress. I couldnt reproduce the issue, but this should hopefully resolve
> it.
> Christian, can you test with this patch?

Jamal, it's the police_lock that we need to make _bh.  The
ingress_lock is already _bh because of the spin_lock_bh that
directly precedes it.

Oh and I think the same thing applies for the other actions
too.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
