Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbYGYFOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbYGYFOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 01:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYGYFOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 01:14:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:60679 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbYGYFOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 01:14:44 -0400
Subject: Re: [PATCH 2/2][RT] powerpc - Make the irq reverse mapping radix
	tree lockless
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Sebastien Dugue <sebastien.dugue@bull.net>,
       Linux-rt <linux-rt-users@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Tim Chavez <tinytim@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@ext.bull.net>
In-Reply-To: <200807242111.35338.nickpiggin@yahoo.com.au>
References: <20080724122352.3bc76bda@bull.net>
	 <20080724125044.53b604cb@bull.net>
	 <200807242111.35338.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Fri, 25 Jul 2008 15:13:39 +1000
Message-Id: <1216962819.11188.82.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >   Concurrency between readers and writers are handled by the intrinsic
> > properties of the concurrent radix tree. Concurrency between the tree
> > initialization which is done asynchronously with readers and writers access
> > is handled via an atomic variable (revmap_trees_allocated) set when the
> > tree has been initialized and checked before any reader or writer access
> > just like we used to check for tree.gfp_mask != 0 before.
> 
> Hmm, RCU radix tree is in mainline too for quite a while. I thought
> Ben had already converted this code over ages ago...
> 
> Nothing against the -rt patch, but mainline should probably be updated
> to use RCU as well?

No, I haven't updated that code yet, and yes, we should do it :-)

Cheers,
Ben.


