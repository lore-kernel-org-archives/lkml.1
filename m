Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbZASDJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbZASDJe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 22:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757584AbZASDJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 22:09:23 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:53927 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757553AbZASDJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 22:09:22 -0500
Date: Mon, 19 Jan 2009 14:08:44 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Willy Tarreau <w@1wt.eu>
Cc: David Miller <davem@davemloft.net>, jarkao2@gmail.com, zbr@ioremap.net,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
Message-ID: <20090119030844.GA31941@gondor.apana.org.au>
References: <20090115.153449.204259387.davem@davemloft.net> <20090115234255.GE1123@1wt.eu> <20090115234408.GA1693@1wt.eu> <20090115.155434.206643894.davem@davemloft.net> <20090119004206.GA10396@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119004206.GA10396@1wt.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 01:42:06AM +0100, Willy Tarreau wrote:
>
> Just for the record, I've now re-integrated those changes in a test kernel
> that I booted on my 10gig machines. I have updated my user-space code in
> haproxy to run a new series of tests. Eventhough there is a memcpy(), the
> results are EXCELLENT (on a C2D 2.66 GHz using Myricom's Myri10GE NICs) :
> 
>   - 4.8 Gbps at 100% CPU using MTU=1500 without LRO
>     (3.2 Gbps at 100% CPU without splice)

One thing to note is that Myricom's driver probably uses page
frags which means that you're not actually triggering the copy.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
