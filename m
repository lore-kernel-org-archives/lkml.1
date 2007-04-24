Return-Path: <linux-kernel-owner+w=401wt.eu-S1161558AbXDXDXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161558AbXDXDXI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 23:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161560AbXDXDXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 23:23:07 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:1112 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161558AbXDXDXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 23:23:05 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: jeremy@goop.org (Jeremy Fitzhardinge)
Subject: Re: [PATCH 23/25] xen: Lockdep fixes for xen-netfront
Cc: ak@suse.de, chrisw@sous-sol.org, virtualization@lists.osdl.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Organization: Core
In-Reply-To: <20070423215713.768656419@goop.org>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.virtualization
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1HgBbr-0007Ob-00@gondolin.me.apana.org.au>
Date: Tue, 24 Apr 2007 13:22:31 +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
> @@ -1212,10 +1212,10 @@ static int netif_poll(struct net_device 
>        int pages_flipped = 0;
>        int err;
> 
> -       spin_lock(&np->rx_lock);
> +       spin_lock_bh(&np->rx_lock);
> 
>        if (unlikely(!netfront_carrier_ok(np))) {
> -               spin_unlock(&np->rx_lock);
> +               spin_unlock_bh(&np->rx_lock);

You don't need to disable BH in netif_poll since it's always called
with BH disabled.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
