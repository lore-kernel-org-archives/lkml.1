Return-Path: <linux-kernel-owner+w=401wt.eu-S1758322AbYEIKZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322AbYEIKZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 06:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbYEIKZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 06:25:14 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:57630 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750896AbYEIKZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 06:25:13 -0400
Date: Fri, 9 May 2008 18:25:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Marco Berizzi <pupilla@hotmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.25 crash: EIP: [<c02e2f14>] xfrm_output_resume+0x64/0x100 ss:esp 0068:c03a1e5c
Message-ID: <20080509102509.GA11710@gondor.apana.org.au>
References: <E1Jrtxr-0004in-00@gondolin.me.apana.org.au> <BAY103-DAV594320AC93E33D7335927B2DA0@phx.gbl> <BAY103-DAV122A113843FE9574256A0AB2D60@phx.gbl> <BAY103-DAV6446AEC1CBB678E5D0E52B2D30@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY103-DAV6446AEC1CBB678E5D0E52B2D30@phx.gbl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2008 at 11:50:00AM +0200, Marco Berizzi wrote:
> 
> I have rebooted the two boxes with slub_debug.
> This is the output taken with network console.
> Herbert does it help you?
> 
> BUG: unable to handle kernel paging request at 6b6b6b9f

Unfortunately this just confirms that your skb has been freed
prematurely because 6b is the poison value.

However, it doesn't point us at the offender.

Although I wonder if there might be something in netfilter that's
freeing it since that's the only thing that could've run on your
machine between the previous access and the crash.  I'll take
another look.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
