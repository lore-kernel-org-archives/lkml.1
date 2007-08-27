Return-Path: <linux-kernel-owner+w=401wt.eu-S1764930AbXH0Vvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764930AbXH0Vvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932575AbXH0Vit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:38:49 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:38135 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933429AbXH0Vir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:38:47 -0400
Date: Mon, 27 Aug 2007 17:38:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070827213845.GB9748@Krystal>
References: <20070821173849.GA8360@Krystal> <Pine.LNX.4.64.0708211612580.6062@schroedinger.engr.sgi.com> <1188197539.6114.426.camel@twins> <Pine.LNX.4.64.0708271237580.5056@schroedinger.engr.sgi.com> <20070827202203.GB5653@Krystal> <Pine.LNX.4.64.0708271324001.5884@schroedinger.engr.sgi.com> <20070827203913.GA7416@Krystal> <Pine.LNX.4.64.0708271401070.6435@schroedinger.engr.sgi.com> <20070827211003.GA10627@Krystal> <Pine.LNX.4.64.0708271421130.6566@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708271421130.6566@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:35:19 up 28 days, 21:54,  7 users,  load average: 0.18, 0.24, 0.43
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> On Mon, 27 Aug 2007, Mathieu Desnoyers wrote:
> 
> > > a clean solution source code wise. It also minimizes the interrupt holdoff 
> > > for the non-cmpxchg_local arches. However, it means that we will have to 
> > > disable interrupts twice for the slow path. If that is too expensive then 
> > > we need a different solution.
> > > 
> > 
> > cmpxchg_local is not used on the slow path... ?
> 
> Right.
> 
> > Did you meant:
> > 
> > it means that we will have to disable preemption _and_ interrupts on the
> > fast path for non-cmpxchg_local arches ?
> 
> We would have to disable preemption and interrupts once on the fast path. 
> The interrupt holdoff would just be a couple of instructions.
> 

Right.

> The slow path would require disable preemption and two interrupt disables.
> 

If the slow path have to call new_slab, then yes. But it seems that not
every slow path must call it, so for the other slow paths, only one
interrupt disable would be required.

> Question is if this makes sense performance wise. If not then we may have 
> to look at more complicated schemes.
> 

Yep, such as the arch_have_cmpxchg() macro that I proposed, but it
really hurts my eyes... :(

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
