Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbXJHGdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbXJHGdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 02:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbXJHGdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 02:33:09 -0400
Received: from swsoft-mipt-nat.sw.ru ([195.214.233.10]:60701 "EHLO iris"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752452AbXJHGdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 02:33:08 -0400
Message-ID: <4709CF6F.60102@sw.ru>
Date: Mon, 08 Oct 2007 10:34:23 +0400
From: "Denis V. Lunev" <den@sw.ru>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: herbert@gondor.apana.org.au, jeff@garzik.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, den@openvz.org
Subject: Re: [NET] IPv6 oops bisected
References: <4708F387.1060602@garzik.org>	<20071007.231608.104667710.davem@davemloft.net>	<20071008061942.GA842@gondor.apana.org.au> <20071007.232302.78733656.davem@davemloft.net>
In-Reply-To: <20071007.232302.78733656.davem@davemloft.net>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Date: Mon, 8 Oct 2007 14:19:42 +0800
> 
>> On Sun, Oct 07, 2007 at 11:16:08PM -0700, David Miller wrote:
>>> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
>>> index a7db84c..7109ad6 100644
>>> --- a/net/ipv6/route.c
>>> +++ b/net/ipv6/route.c
>>> @@ -1188,7 +1188,7 @@ int ip6_route_add(struct fib6_config *cfg)
>>>  	if ((cfg->fc_flags & RTF_REJECT) ||
>>>  	    (dev && (dev->flags&IFF_LOOPBACK) && !(addr_type&IPV6_ADDR_LOOPBACK))) {
>>>  		/* hold loopback dev/idev if we haven't done so. */
>>> -		if (dev != dev->nd_net->loopback_dev) {
>>> +		if (!dev || (dev != dev->nd_net->loopback_dev)) {
>>>  			if (dev) {
>>>  				dev_put(dev);
>>>  				in6_dev_put(idev);
>> Unfortunately this'll still oops a few lines down when it tries
>> to assign dev->nd_net->loopabck_dev to dev.  The issue here is
>> which namespace are we in if dev is NULL.
> 
> Good catch.
> 
> I'm just going to revert my bogus fix and the original change
> for now.  Denis can resubmit the original patch once this
> is resolved.

OK. I am installing Fedora 7 right now...
