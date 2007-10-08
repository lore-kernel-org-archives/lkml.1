Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbXJHGXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbXJHGXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 02:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbXJHGXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 02:23:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51742
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751489AbXJHGXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 02:23:03 -0400
Date: Sun, 07 Oct 2007 23:23:02 -0700 (PDT)
Message-Id: <20071007.232302.78733656.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: jeff@garzik.org, dlunev@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, den@openvz.org
Subject: Re: [NET] IPv6 oops bisected
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071008061942.GA842@gondor.apana.org.au>
References: <4708F387.1060602@garzik.org>
	<20071007.231608.104667710.davem@davemloft.net>
	<20071008061942.GA842@gondor.apana.org.au>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Mon, 8 Oct 2007 14:19:42 +0800

> On Sun, Oct 07, 2007 at 11:16:08PM -0700, David Miller wrote:
> >
> > diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> > index a7db84c..7109ad6 100644
> > --- a/net/ipv6/route.c
> > +++ b/net/ipv6/route.c
> > @@ -1188,7 +1188,7 @@ int ip6_route_add(struct fib6_config *cfg)
> >  	if ((cfg->fc_flags & RTF_REJECT) ||
> >  	    (dev && (dev->flags&IFF_LOOPBACK) && !(addr_type&IPV6_ADDR_LOOPBACK))) {
> >  		/* hold loopback dev/idev if we haven't done so. */
> > -		if (dev != dev->nd_net->loopback_dev) {
> > +		if (!dev || (dev != dev->nd_net->loopback_dev)) {
> >  			if (dev) {
> >  				dev_put(dev);
> >  				in6_dev_put(idev);
> 
> Unfortunately this'll still oops a few lines down when it tries
> to assign dev->nd_net->loopabck_dev to dev.  The issue here is
> which namespace are we in if dev is NULL.

Good catch.

I'm just going to revert my bogus fix and the original change
for now.  Denis can resubmit the original patch once this
is resolved.
