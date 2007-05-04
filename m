Return-Path: <linux-kernel-owner+w=401wt.eu-S1030371AbXEDQaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030371AbXEDQaU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031346AbXEDQaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:30:19 -0400
Received: from amsfep19-int.chello.nl ([62.179.120.14]:53271 "EHLO
	amsfep19-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030371AbXEDQaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:30:17 -0400
Subject: Re: [PATCH 08/40] mm: kmem_cache_objsize
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@steeleye.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daniel Phillips <phillips@google.com>
In-Reply-To: <Pine.LNX.4.64.0705040919560.21436@schroedinger.engr.sgi.com>
References: <20070504102651.923946304@chello.nl>
	 <20070504103157.215424767@chello.nl>
	 <84144f020705040354r5cb74c5fj6cb8698f93ffcb83@mail.gmail.com>
	 <Pine.LNX.4.64.0705040908480.21436@schroedinger.engr.sgi.com>
	 <1178295355.24217.49.camel@twins>
	 <Pine.LNX.4.64.0705040919560.21436@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Fri, 04 May 2007 18:30:13 +0200
Message-Id: <1178296213.24217.54.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 09:23 -0700, Christoph Lameter wrote:
> On Fri, 4 May 2007, Peter Zijlstra wrote:
> 
> > On Fri, 2007-05-04 at 09:09 -0700, Christoph Lameter wrote:
> > > On Fri, 4 May 2007, Pekka Enberg wrote:
> > > 
> > > > On 5/4/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > > > Expost buffer_size in order to allow fair estimates on the actual space
> > > > > used/needed.
> > > 
> > > We already have ksize?
> > 
> > ksize gives the internal size, whereas these give the external size.
> > 
> > I need to know how much space I need to reserve, hence I need the
> > external size; whereas normally you want to know how much space you have
> > available, which is what ksize gives.
> > 
> > Didn't we have this discussion last time?
> 
> I was cced on that as far as I can tell.

Ah, that might have been, I was collecting Cc's but must've overlooked
you. My bad.

> The name objsize suggests the size of the object not the slab size.
> If you want this then maybe call it kmem_cache_slab_size. SLUB 
> distinguishes between obj_size which is the size of the struct that is 
> used and slab_size which is the size of the object after alignment, adding 
> debug information etc etc. See also slabinfo.c for a way to calculate 
> theses sizes from user space.

I'm open to renames, this is what Pekka suggested IIRC.

> If we really drop SLAB then we wont need this. SLUBs data structures are 
> not opaque.

Yeah, I know, I still have to add SLUB support, its high on my TODO list
though.

