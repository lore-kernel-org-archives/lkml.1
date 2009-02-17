Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbZBQMlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbZBQMlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 07:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbZBQMlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 07:41:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:45303 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbZBQMlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 07:41:31 -0500
Subject: Re: Q: smp.c && barriers (Was: [PATCH 1/4] generic-smp: remove
 single ipi fallback for smp_call_function_many())
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1234862974.4744.31.camel@laptop>
References: <20090216163847.431174825@chello.nl>
	 <20090216164114.433430761@chello.nl> <20090216204902.GA6924@redhat.com>
	 <1234818201.30178.386.camel@laptop> <20090216213205.GA9098@redhat.com>
	 <1234820704.30178.396.camel@laptop> <20090216220214.GA10093@redhat.com>
	 <1234823097.30178.406.camel@laptop>  <20090216231946.GA12009@redhat.com>
	 <1234862974.4744.31.camel@laptop>
Content-Type: text/plain
Date: Tue, 17 Feb 2009 13:40:55 +0100
Message-Id: <1234874455.4744.96.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-17 at 10:29 +0100, Peter Zijlstra wrote:
> > It would be nice to have a comment which explains how can we miss the
> > first addition without read_barrier_depends(). And why only on alpha.
> 
> Paul, care to once again enlighten us? The best I can remember is that
> alpha has split caches, and the rmb is needed for them to become
> coherent -- no other arch is crazy in exactly that way.
> 
> But note that read_barrier_depends() is not quite a NOP for !alpha, it
> does that ACCESS_ONCE() thing, which very much makes a difference, even
> on x86.

I've been saying crazy stuff, read_barrier_depends() is a NOP, I got
confused with rcu_dereference(). My bad.

