Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbZCGFfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbZCGFfS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 00:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbZCGFes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 00:34:48 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55045 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbZCGFer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 00:34:47 -0500
Date: Fri, 6 Mar 2009 21:34:44 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       Manfred Spraul <manfred@colorfullife.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 3/6] slub: introduce __kfree_rcu
Message-ID: <20090307053444.GB10625@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <49AD343E.6010903@cn.fujitsu.com> <alpine.DEB.1.10.0903041003200.3850@qirst.com> <49AF28C4.1000300@cn.fujitsu.com> <alpine.DEB.1.10.0903050938300.22053@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0903050938300.22053@qirst.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 09:39:03AM -0500, Christoph Lameter wrote:
> On Thu, 5 Mar 2009, Lai Jiangshan wrote:
> 
> > The first parameter of __kfree_rcu() is unused in slab,slub,slqb.
> > (I used it before, for CONFIG_SLUB_DEBUG=y ...etc. But I found
> > these debugging code is needless)
> >
> > Object sizes of the memory objects in slob's kmalloc-slab are various.
> > We hardly calculate the start address of the object from the rcu address.
> 
> But you can start with the descriptor at the beginning of the page and
> scan until you find the object.

Another approach would be to keep a per-page bitmap of the objects
that are awaiting a grace period.

Not sure whether or not it is worthwhile, but it does reduce the
per-object overhead to two bits (one for the objects awaiting the
current grace period, the other for objects that will await the next
grace period).

							Thanx, Paul
