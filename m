Return-Path: <linux-kernel-owner+w=401wt.eu-S933935AbZKXSxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933935AbZKXSxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 13:53:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933857AbZKXSxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 13:53:51 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:57931 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933770AbZKXSxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 13:53:50 -0500
Date: Tue, 24 Nov 2009 12:53:26 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Peter Zijlstra <peterz@infradead.org>
cc: paulmck@linux.vnet.ibm.com, Matt Mackall <mpm@selenic.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
Subject: Re: lockdep complaints in slab allocator
In-Reply-To: <1259087511.4531.1775.camel@laptop>
Message-ID: <alpine.DEB.2.00.0911241245140.14045@router.home>
References: <1258714328.11284.522.camel@laptop>  <4B067816.6070304@cs.helsinki.fi> <1258729748.4104.223.camel@laptop>  <1259002800.5630.1.camel@penberg-laptop> <1259003425.17871.328.camel@calx>  <4B0ADEF5.9040001@cs.helsinki.fi> <1259080406.4531.1645.camel@laptop>
  <20091124170032.GC6831@linux.vnet.ibm.com>  <1259082756.17871.607.camel@calx> <1259086459.4531.1752.camel@laptop>  <20091124182506.GG6831@linux.vnet.ibm.com> <1259087511.4531.1775.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009, Peter Zijlstra wrote:

> On Tue, 2009-11-24 at 10:25 -0800, Paul E. McKenney wrote:
>
> > Well, I suppose I could make my scripts randomly choose the memory
> > allocator, but I would rather not.  ;-)
>
> Which is why I hope we'll soon be down to 2, SLOB for tiny systems and
> SLQB for the rest of us, having 3 in-tree and 1 pending is pure and
> simple insanity.
>
> Preferably SLQB will be small enough to also be able to get rid of SLOB,
> but I've not recently seen any data on that particular issue.

We have some issues with NUMA in SLQB. Memoryless node support needs to
get some work. The fixes of memoryless node support to SLAB by Lee
create another case where SLQB will be regressing against SLAB.

Multiple modifications of per cpu variables in allocators other than SLUB
means that interruptless fastpath is going to be difficult to realize and
may continue to cause rt issues with preemption and per cpu handling.

Memory consumption of SLQB is better??





