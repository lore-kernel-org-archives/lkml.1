Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbYHSNMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbYHSNMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbYHSNML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:12:11 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:41821 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753577AbYHSNMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:12:09 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: jacliburn@bellsouth.net (Jay Cliburn)
Subject: Re: [PATCH] atl1: disable TSO by default
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       link@miggy.org, ian@jeffray.co.uk, csnook@redhat.com,
       jie.yang@atheros.com, m@fhloston.org, davem@davemloft.net
Organization: Core
In-Reply-To: <20080818192813.0d0dc1fd@osprey.hogchain.net>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1KVQyr-0001Ui-00@gondolin.me.apana.org.au>
Date: Tue, 19 Aug 2008 23:10:37 +1000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn <jacliburn@bellsouth.net> wrote:
> 
> diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
> index e6a7bb7..e23ce77 100644
> --- a/drivers/net/atlx/atl1.c
> +++ b/drivers/net/atlx/atl1.c
> @@ -3022,7 +3022,6 @@ static int __devinit atl1_probe(struct pci_dev *pdev,
>        netdev->features = NETIF_F_HW_CSUM;
>        netdev->features |= NETIF_F_SG;
>        netdev->features |= (NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX);
> -       netdev->features |= NETIF_F_TSO;
>        netdev->features |= NETIF_F_LLTX;

Another new driver using LLTX, this is not good when we're trying
to get rid of it.

Perhaps we could just kill it by ignoring the LLTX flag and always
grabbing the xmit lock.  That should be safe as long as none of these
drivers grab the xmit lock within their private locks.

LLTX drivers will be a tad slower, but that should encourage them
to stop using it :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
