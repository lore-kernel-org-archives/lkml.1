Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbZGJBAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbZGJBAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 21:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbZGJBAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 21:00:05 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:58673 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750833AbZGJBAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 21:00:04 -0400
Date: Fri, 10 Jul 2009 08:59:57 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: sk_lock: inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W}
	usage
Message-ID: <20090710005957.GA32555@gondor.apana.org.au>
References: <20090608023757.GA6244@localhost> <20090706105216.GA19124@gondor.apana.org.au> <20090709131746.GA27965@localhost> <20090709.171355.09466097.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090709.171355.09466097.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 05:13:55PM -0700, David Miller wrote:
>
> I think this specific case needs more thinking.
> 
> If the allocation fails, and it's GFP_ATOMIC, we are going to yield()
> (which sleeps) and loop endlessly waiting for the allocation to
> succeed.

Indeed.  We could do one of the following:

1) Preallocate, either universally or conditinally on sk_allocation.
2) Set a bit somewhere to indicate FIN and retry the allocation as
part of retransmit.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
