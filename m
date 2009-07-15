Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbZGOHpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbZGOHpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 03:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZGOHpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 03:45:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:27469 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbZGOHpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 03:45:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,403,1243839600"; 
   d="scan'208";a="165151333"
Date: Wed, 15 Jul 2009 15:45:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: David Miller <davem@davemloft.net>
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: sk_lock: inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W}
	usage
Message-ID: <20090715074503.GC6145@localhost>
References: <20090709.171355.09466097.davem@davemloft.net> <20090710080017.GA24168@localhost> <20090710080247.GA2693@gondor.apana.org.au> <20090714.090432.13343695.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090714.090432.13343695.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 12:04:32AM +0800, David Miller wrote:
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Date: Fri, 10 Jul 2009 16:02:47 +0800
> 
> > On Fri, Jul 10, 2009 at 04:00:17PM +0800, Wu Fengguang wrote:
> >> 
> >> The (sk_allocation & ~__GFP_WAIT) cases should be rare, but I guess
> >> the networking code shall do it anyway, because sk_allocation defaults
> >> to GFP_KERNEL. It seems that currently the networking code simply uses
> >> a lot of GFP_ATOMIC, do they really mean "I cannot sleep"?
> > 
> > Yep because they're done from softirq context.
> 
> Yes, this is the core issue.

Yes, that's general true. But..

> All of Wu's talk about how "GFP_ATOMIC will wake up kswapd and
> therefore can succeed just as well as GFP_KERNEL" is not relevant,
> because GFP_ATOMIC means sleeping is not allowed.

We are talking about tcp_send_fin() here, which can sleep.

Thanks,
Fengguang
