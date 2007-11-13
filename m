Return-Path: <linux-kernel-owner+w=401wt.eu-S1758112AbXKMMEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbXKMMEN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 07:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757380AbXKMMDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 07:03:53 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:1569 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757073AbXKMMDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 07:03:51 -0500
Date: Tue, 13 Nov 2007 20:03:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: kaber@trash.net, joonwpark81@gmail.com, w@1wt.eu, cfriesen@nortel.com,
       auke-jan.h.kok@intel.com, netdev@vger.kernel.org,
       djohnson+linux-kernel@sw.starentnetworks.com,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when promiscuous mode
Message-ID: <20071113120328.GB1086@gondor.apana.org.au>
References: <47397AB3.90705@trash.net> <E1Irtdz-0000DX-00@gondolin.me.apana.org.au> <20071113.033611.73195922.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113.033611.73195922.davem@davemloft.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 03:36:11AM -0800, David Miller wrote:
>
> The performance implications can be pretty severe however.
> I wish we could address this somehow.

Or perhaps we should just teach everyone to always run tcpdump
with -p, like me :)

Of course this would still have a negative impact on those who
have to be in promiscuous mode all the time (heh) due to multiple
unicast MAC addresses and such.  However, we should able to
communicate that fact to the driver and the driver can then elect
to not disable VLAN acceleration unless we really want to be in
promiscuous mode.

In other words we can make it so that nobody is in promiscuous
mode and therefore have to disable VLAN acceleration *unless*
they really want to be in that state.  In which case it would
imply that they wish to see everything and therefore we should
disable VLAN acceleration.

So that means I'd like to see our current core/driver interface
enhanced so that whether the user has requested us to be in
promiscuous mode can be differentiated from whether the network
stack wants us to be.

Once we have that then I would think that such a patch would be
less controversial.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
