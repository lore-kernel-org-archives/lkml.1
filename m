Return-Path: <linux-kernel-owner+w=401wt.eu-S1764734AbXH0V0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764734AbXH0V0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764512AbXH0VXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:23:47 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42296 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764499AbXH0VXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:23:46 -0400
Date: Mon, 27 Aug 2007 14:23:45 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <20070827211003.GA10627@Krystal>
Message-ID: <Pine.LNX.4.64.0708271421130.6566@schroedinger.engr.sgi.com>
References: <20070820215413.GA28452@Krystal>
 <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
 <20070821173849.GA8360@Krystal> <Pine.LNX.4.64.0708211612580.6062@schroedinger.engr.sgi.com>
 <1188197539.6114.426.camel@twins> <Pine.LNX.4.64.0708271237580.5056@schroedinger.engr.sgi.com>
 <20070827202203.GB5653@Krystal> <Pine.LNX.4.64.0708271324001.5884@schroedinger.engr.sgi.com>
 <20070827203913.GA7416@Krystal> <Pine.LNX.4.64.0708271401070.6435@schroedinger.engr.sgi.com>
 <20070827211003.GA10627@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007, Mathieu Desnoyers wrote:

> > a clean solution source code wise. It also minimizes the interrupt holdoff 
> > for the non-cmpxchg_local arches. However, it means that we will have to 
> > disable interrupts twice for the slow path. If that is too expensive then 
> > we need a different solution.
> > 
> 
> cmpxchg_local is not used on the slow path... ?

Right.

> Did you meant:
> 
> it means that we will have to disable preemption _and_ interrupts on the
> fast path for non-cmpxchg_local arches ?

We would have to disable preemption and interrupts once on the fast path. 
The interrupt holdoff would just be a couple of instructions.

The slow path would require disable preemption and two interrupt disables.

Question is if this makes sense performance wise. If not then we may have 
to look at more complicated schemes.


