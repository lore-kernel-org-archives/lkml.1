Return-Path: <linux-kernel-owner+w=401wt.eu-S1764343AbXH1ThI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764343AbXH1ThI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbXH1Tgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:36:50 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33606 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751145AbXH1Tgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:36:48 -0400
Date: Tue, 28 Aug 2007 12:36:47 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@redhat.com
Subject: Re: [PATCH] SLUB use cmpxchg_local
In-Reply-To: <1188285159.6112.4.camel@twins>
Message-ID: <Pine.LNX.4.64.0708281235170.16473@schroedinger.engr.sgi.com>
References: <20070820201519.512791382@polymtl.ca>  <20070820201822.597720007@polymtl.ca>
  <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com> 
 <20070820204126.GA22507@Krystal>  <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com>
  <20070820212922.GA27011@Krystal>  <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com>
  <20070820215413.GA28452@Krystal>  <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
  <20070821173849.GA8360@Krystal>  <Pine.LNX.4.64.0708211612580.6062@schroedinger.engr.sgi.com>
  <1188197539.6114.426.camel@twins>  <Pine.LNX.4.64.0708271237580.5056@schroedinger.engr.sgi.com>
  <Pine.LNX.4.64.0708271514020.8891@schroedinger.engr.sgi.com>
 <1188285159.6112.4.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007, Peter Zijlstra wrote:

> On Mon, 2007-08-27 at 15:15 -0700, Christoph Lameter wrote:
> > Hmmmm. One wild idea would be to use a priority futex for the slab lock? 
> > That would make the slow paths interrupt safe without requiring interrupt 
> > disable? Does a futex fit into the page struct?
> 
> Very much puzzled at what you propose. in-kernel we use rt_mutex (has
> PI) or mutex, futexes are user-space. (on -rt spinlock_t == mutex ==
> rt_mutex)
> 
> Neither disable interrupts since they are sleeping locks.
> 
> That said, on -rt we do not need to disable interrupts in the allocators
> because its a bug to call an allocator from raw irq context.

Right so if a prioriuty futex would have been taken from a process 
context and then an interrupt thread (or so no idea about RT) is scheduled 
then the interrupt thread could switch to the process context and complete 
the work there before doing the "interrupt" work. So disabling interrupts 
is no longer necessary.


