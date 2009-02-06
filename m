Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbZBFIKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbZBFIKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 03:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbZBFIKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 03:10:03 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:49767 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752462AbZBFIKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 03:10:01 -0500
Date: Fri, 6 Feb 2009 19:09:24 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: jarkao2@gmail.com, zbr@ioremap.net, w@1wt.eu, dada1@cosmosbay.com,
       ben@zeus.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090206080924.GA6062@gondor.apana.org.au>
References: <20090202084358.GB4129@ff.dom.local> <20090202.235017.253437221.davem@davemloft.net> <20090203094108.GA4639@ff.dom.local> <20090205.235258.257422341.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205.235258.257422341.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 05, 2009 at 11:52:58PM -0800, David Miller wrote:
>
> In fact we can optimize that even further in many ways, for example by
> dropping the skb->data backed memory once the skb is queued to the
> socket receive buffer.  That will make skb->data buffer lifetimes
> miniscule even under heavy receive load.

Indeed, while I was doing the tun accounting stuff and reviewing
the rx accounting users, it was apparent that we don't need to
carry most of this stuff in our receive queues.

This is almost the opposite of the skbless data idea for TSO.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
