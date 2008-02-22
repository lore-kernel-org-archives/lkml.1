Return-Path: <linux-kernel-owner+w=401wt.eu-S935457AbYBVNlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935457AbYBVNlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 08:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934021AbYBVNlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 08:41:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56164 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933213AbYBVNla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 08:41:30 -0500
Subject: Re: [PATCH [RT] 05/14] rearrange rt_spin_lock sleep
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: gregory.haskins@gmail.com, Gregory Haskins <ghaskins@novell.com>,
       mingo@elte.hu, tglx@linutronix.de, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, bill.huey@gmail.com, kevin@hilman.org,
       cminyard@mvista.com, dsingleton@mvista.com, dwalker@mvista.com,
       npiggin@suse.de, dsaxena@plexity.net, ak@suse.de, gregkh@suse.de,
       sdietrich@novell.com, pmorreale@novell.com, mkohari@novell.com
In-Reply-To: <Pine.LNX.4.58.0802220832330.15391@gandalf.stny.rr.com>
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
	 <20080221152651.4804.4702.stgit@novell1.haskins.net>
	 <47BECE30.8030100@gmail.com>
	 <Pine.LNX.4.58.0802220832330.15391@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 14:40:54 +0100
Message-Id: <1203687654.6242.22.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-22 at 08:35 -0500, Steven Rostedt wrote:

> > My assumption is that the xchg() (inside update_current()) acts as an
> > effective wmb().  If xchg() does not have this property, then this code
> > is broken and patch 6/14 should also add a:
> >
> >
> > +               smp_wmb();
> 
> I believe that the wmb would be needed. I doubt that xchg on all archs
> would force any ordering of reads and writes. It only needs to guarantee the
> atomic nature of the data exchange. I don't see any reason that it would
> imply any type of memory barrier.

Documentation/memory-barriers.txt states:

Any atomic operation that modifies some state in memory and returns information
about the state (old or new) implies an SMP-conditional general memory barrier
(smp_mb()) on each side of the actual operation (with the exception of
explicit lock operations, described later).  These include:

        xchg();



