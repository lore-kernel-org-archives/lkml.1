Return-Path: <linux-kernel-owner+w=401wt.eu-S1031518AbXEDUAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031518AbXEDUAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 16:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423133AbXEDUAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 16:00:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53471 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031505AbXEDT7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:59:45 -0400
Date: Fri, 4 May 2007 12:59:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>
Subject: Re: [PATCH 08/40] mm: kmem_cache_objsize
In-Reply-To: <463B815E.8010806@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0705041258390.25267@schroedinger.engr.sgi.com>
References: <20070504102651.923946304@chello.nl>  <20070504103157.215424767@chello.nl>
  <Pine.LNX.4.64.0705040932200.22033@schroedinger.engr.sgi.com> 
 <1178301545.24217.56.camel@twins>  <Pine.LNX.4.64.0705041104110.23539@schroedinger.engr.sgi.com>
  <1178302904.2767.6.camel@lappy>  <Pine.LNX.4.64.0705041128270.24283@schroedinger.engr.sgi.com>
 <1178303538.2767.9.camel@lappy> <463B7F63.8070508@cs.helsinki.fi>
 <Pine.LNX.4.64.0705041147000.24625@schroedinger.engr.sgi.com>
 <463B815E.8010806@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007, Pekka Enberg wrote:

> Christoph Lameter wrote:
> > On Fri, 4 May 2007, Pekka Enberg wrote:
> > 
> > > Again, slab has no way of actually estimating how many pages you need for
> > > a
> > > given number of objects. So we end up calculating some upper bound which
> > > doesn't belong in mm/slab.c. I am perfectly okay with:
> > 
> > It can give a worst case number and that is what he wants.
> 
> Sure. But he can calculate that elsewhere instead of bringing it in mm/slab.c
> where it's no use for anyone else...

He is not able to calculate it just using the object size since he does 
not know where the slab put the slab management structure. And in case of 
SLUB there is no slab management structure... Which means he would have to 
special case based on the slab allocator selected.

