Return-Path: <linux-kernel-owner+w=401wt.eu-S1765685AbXJZVb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765685AbXJZVb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755253AbXJZVbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:31:20 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:43351 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbXJZVbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:31:19 -0400
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>, clameter@sgi.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	 <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
	 <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	 <20071025185506.8c373aa8.pj@sgi.com>
	 <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
	 <1193412644.5032.13.camel@localhost>
	 <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
	 <20071026120037.7b95a136.pj@sgi.com>
	 <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
	 <1193433239.5032.95.camel@localhost>
	 <alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 26 Oct 2007 17:31:17 -0400
Message-Id: <1193434278.5032.106.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 14:18 -0700, David Rientjes wrote:
> On Fri, 26 Oct 2007, Lee Schermerhorn wrote:
> 
> > You don't need to save the entire mask--just note that NODE_MASK_ALL was
> > passed--like with my internal MPOL_CONTEXT flag.  This would involve
> > special casing NODE_MASK_ALL in the error checking, as currently
> > set_mempolicy() complains loudly if you pass non-allowed nodes--see
> > "contextualize_policy()".  [mbind() on the other hand, appears to allow
> > any nodemask, even outside the cpuset.  guess we catch this during
> > allocation.]  This is pretty much the spirit of my patch w/o the API
> > change/extension [/improvement :)]
> > 
> 
> Not really, because perhaps your application doesn't want to interleave 
> over all nodes.  I suggested NODE_MASK_ALL as the way to get access to all 
> the memory you are allowed, but it's certainly plausible that an 
> application could request to interleave only over a subset.  That's the 
> entire reason set_mempolicy(MPOL_INTERLEAVE) takes a nodemask anyway right 
> now instead of just using task->mems_allowed on each allocation.

So, you pass the subset, you don't set the flag to indicate you want
interleaving over all available.  You must be thinking of some other use
for saving the subset mask that I'm not seeing here.  Maybe restoring to
the exact nodes requested if they're taken away and then re-added to the
cpuset?


Later,
Lee



