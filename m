Return-Path: <linux-kernel-owner+w=401wt.eu-S1755731AbZICPBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbZICPBr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 11:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbZICPBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 11:01:47 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:55595 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbZICPBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 11:01:46 -0400
Date: Thu, 3 Sep 2009 08:01:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Patrick McHardy <kaber@trash.net>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] slub: fix slab_pad_check()
Message-ID: <20090903150139.GC6761@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4A896324.3040104@trash.net> <c4e36d110909021445l5f44183es9e338437dfbbd195@mail.gmail.com> <4A9EEF07.5070800@gmail.com> <c4e36d110909021531v324a9ce2x3ff2c93b7c5a57de@mail.gmail.com> <4A9F1620.2080105@gmail.com> <84144f020909022331x2b275aa5n428f88670e0ae8bc@mail.gmail.com> <4A9F7283.1090306@gmail.com> <alpine.DEB.1.10.0909031244230.27903@V090114053VZO-1> <4A9FCDC6.3060003@gmail.com> <alpine.DEB.1.10.0909031335430.29881@V090114053VZO-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0909031335430.29881@V090114053VZO-1>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 01:38:50PM -0500, Christoph Lameter wrote:
> On Thu, 3 Sep 2009, Eric Dumazet wrote:
> 
> > Christoph Lameter a ?crit :
> > > On Thu, 3 Sep 2009, Eric Dumazet wrote:
> > >
> > >> on a SLAB_DESTROY_BY_RCU cache, there is no need to try to optimize this
> > >> rcu_barrier() call, unless we want superfast reboot/halt sequences...
> > >
> > > I stilll think that the action to quiesce rcu is something that the caller
> > > of kmem_cache_destroy must take care of.
> >
> > Do you mean :
> >
> > if (kmem_cache_shrink(s) == 0) {
> > 	rcu_barrier();
> > 	kmem_cache_destroy_no_rcu_barrier(s);
> > } else {
> > 	kmem_cache_destroy_with_rcu_barrier_because_SLAB_DESTROY_BY_RCU_cache(s);
> > }
> >
> > What would be the point ?
> 
> The above is port of slub?
> 
> I mean that (in this case) the net subsystem would have to deal with RCU quietness
> before disposing of the slab cache. There may be multiple ways of dealing
> with RCU. The RCU barrier may be unnecessary for future uses. Typically
> one would expect that all deferred handling of structures must be complete
> for correctness before disposing of the whole cache.

Which is precisely the point of the rcu_barrier(), right?

							Thanx, Paul

> > [PATCH] slub: fix slab_pad_check()
> 
> Acked-by: Christoph Lameter <cl@linux-foundation.org>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
