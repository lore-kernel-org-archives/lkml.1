Return-Path: <linux-kernel-owner+w=401wt.eu-S933115AbXH0Ubl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933115AbXH0Ubl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762955AbXH0U0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:26:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38450 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763102AbXH0U0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:26:11 -0400
Date: Mon, 27 Aug 2007 13:26:11 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <20070827202203.GB5653@Krystal>
Message-ID: <Pine.LNX.4.64.0708271324001.5884@schroedinger.engr.sgi.com>
References: <20070820204126.GA22507@Krystal>
 <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com>
 <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com>
 <20070820215413.GA28452@Krystal> <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
 <20070821173849.GA8360@Krystal> <Pine.LNX.4.64.0708211612580.6062@schroedinger.engr.sgi.com>
 <1188197539.6114.426.camel@twins> <Pine.LNX.4.64.0708271237580.5056@schroedinger.engr.sgi.com>
 <20070827202203.GB5653@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007, Mathieu Desnoyers wrote:

> * Christoph Lameter (clameter@sgi.com) wrote:
> > On Mon, 27 Aug 2007, Peter Zijlstra wrote:
> > 
> > > So, if the fast path can be done with a preempt off, it might be doable
> > > to suffer the slow path with a per cpu lock like that.
> > 
> > Sadly the cmpxchg_local requires local per cpu data access. Isnt there 
> > some way to make this less expensive on RT? Acessing cpu local memory is 
> > really good for performance on NUMA since the data is optimally placed and 
> > one can avoid/reduce locking if the process stays tied to the processor.
> > 
> 
> On the slow path, in slab_new, we already have to reenable interrupts
> because we can sleep. If we make sure that whenever we return to an irq
> disable code path we take the current per-cpu data structure again, can
> we make the preempt-disable/irq-disabled code paths O(1) ?

Not sure exactly what you are getting at?
This would mean running __alloc_pages tied to one processor even though 
waiting is possible?


