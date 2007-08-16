Return-Path: <linux-kernel-owner+w=401wt.eu-S938044AbXHPCbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938044AbXHPCbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 22:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937366AbXHPCa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 22:30:56 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:58469 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937122AbXHPCay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 22:30:54 -0400
Date: Wed, 15 Aug 2007 19:30:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: heiko.carstens@de.ibm.com, horms@verge.net.au,
       linux-kernel@vger.kernel.org, rpjday@mindspring.com, ak@suse.de,
       netdev@vger.kernel.org, cfriesen@nortel.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, jesper.juhl@gmail.com,
       linux-arch@vger.kernel.org, zlynx@acm.org, satyam@infradead.org,
       clameter@sgi.com, schwidefsky@de.ibm.com,
       Chris Snook <csnook@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
       davem@davemloft.net, wensong@linux-vs.org, wjiang@resilience.com
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Message-ID: <20070816023050.GC14613@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <E1ILCgh-00052A-00@gondolin.me.apana.org.au> <46C32618.2080108@redhat.com> <20070815234021.GA28775@gondor.apana.org.au> <20070815235125.GT9645@linux.vnet.ibm.com> <0de0c3d833b6f543bd75f74bb17a124b@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0de0c3d833b6f543bd75f74bb17a124b@kernel.crashing.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2007 at 03:30:44AM +0200, Segher Boessenkool wrote:
> >>>Part of the motivation here is to fix heisenbugs.  If I knew where 
> >>>they
> >>
> >>By the same token we should probably disable optimisations
> >>altogether since that too can create heisenbugs.
> >
> >Precisely the point -- use of volatile (whether in casts or on asms)
> >in these cases are intended to disable those optimizations likely to
> >result in heisenbugs.
> 
> The only thing volatile on an asm does is create a side effect
> on the asm statement; in effect, it tells the compiler "do not
> remove this asm even if you don't need any of its outputs".
> 
> It's not disabling optimisation likely to result in bugs,
> heisen- or otherwise; _not_ putting the volatile on an asm
> that needs it simply _is_ a bug :-)

Yep.  And the reason it is a bug is that it fails to disable
the relevant compiler optimizations.  So I suspect that we might
actually be saying the same thing here.

						Thanx, Paul
