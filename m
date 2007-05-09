Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbXEIKY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbXEIKY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 06:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755374AbXEIKYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 06:24:13 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2099 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755618AbXEIKYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 06:24:10 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: akpm@linux-foundation.org
Subject: Re: [patch 7/9] lguest: the net driver
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au, ak@suse.de,
       jeff@garzik.org, jmorris@namei.org, netdev@vger.kernel.org
Organization: Core
In-Reply-To: <200705090951.l499pdOr020406@shell0.pdx.osdl.net>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.virtualization
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1HljA6-0001E4-00@gondolin.me.apana.org.au>
Date: Wed, 09 May 2007 20:12:46 +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
>
> +       if (desc->features & LGUEST_NET_F_NOCSUM)
> +               dev->features |= NETIF_F_NO_CSUM;

Any reason why you're using NO_CSUM here instead of HW_CSUM?
Practically there is no difference but NO_CSUM could be treated
differently in future and I'm not sure whether such changes would
be desirable in this driver (i.e., not even generating a partial
checksum).

Also, there doesn't seem to be any passing of metadata to the
backend which means that neither NO_CSUM/HW_CSUM can work if
somebody needs to look at the checksum field.  You could use
IP_CSUM if you do the same hack on the backend that Xen does.
Otherwise you'll have to make do with no checksum offload at all.

I think you'd also need a change_mtu function if the SG feature
is going to be of some use since the default Ethernet one limits
the MTU to 1500.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
