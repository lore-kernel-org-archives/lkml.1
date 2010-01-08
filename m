Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024Ab0AHTMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab0AHTMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 14:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903Ab0AHTMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 14:12:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753881Ab0AHTMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 14:12:40 -0500
Date: Fri, 8 Jan 2010 11:11:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Christoph Lameter <cl@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <alpine.DEB.2.00.1001081255100.26886@router.home>
Message-ID: <alpine.LFD.2.00.1001081102120.7821@localhost.localdomain>
References: <20100104182429.833180340@chello.nl> <28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com> <20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001042052210.3630@localhost.localdomain> <20100105143046.73938ea2.kamezawa.hiroyu@jp.fujitsu.com>
 <20100105163939.a3f146fb.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001050707520.3630@localhost.localdomain> <20100106092212.c8766aa8.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001051718100.3630@localhost.localdomain>
 <20100106115233.5621bd5e.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001051917000.3630@localhost.localdomain> <20100106125625.b02c1b3a.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001052007090.3630@localhost.localdomain> <1262969610.4244.36.camel@laptop>
 <alpine.LFD.2.00.1001080911340.7821@localhost.localdomain> <alpine.DEB.2.00.1001081138260.23727@router.home> <87my0omo3n.fsf@basil.nowhere.org> <alpine.DEB.2.00.1001081255100.26886@router.home>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Jan 2010, Christoph Lameter wrote:

> On Fri, 8 Jan 2010, Andi Kleen wrote:
> 
> > This year's standard server will be more like 24-64 "cpus"
> 
> What will it be? 2 or 4 sockets?

I think we can be pretty safe in saying that two sockets is going to be 
overwhelmingly the more common case.

It's simply physics and form factor. It's hard to put four powerful CPU's 
on one board in any normal form-factor, so when you go from 2->4 sockets, 
you almost inevitably have to go to rather fancier form-factors (or 
low-power sockets designed for socket-density rather than multi-core 
density, which is kind of against the point these days).

So often you end up with CPU daughter-cards etc, which involves a lot more 
design and cost, and no longer fit in standard desktop enclosures for 
people who want stand-alone servers etc (or even in rack setups if you 
want local disks too etc).

Think about it this way: just four sockets and associated per-socket RAM 
DIMM's (never mind anything else) take up a _lot_ of space. And you can 
only make your boards so big before they start having purely machanical 
issues due to flexing etc.

Which is why I suspect that two sockets will be the bulk of the server 
space for the forseeable future. It's been true before, and multiple 
memory channels per socket to feed all those cores are just making it even 
more so.

				Linus
