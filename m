Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbZBWTLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbZBWTLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 14:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZBWTLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 14:11:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752813AbZBWTLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 14:11:13 -0500
Date: Mon, 23 Feb 2009 11:10:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: paulmck@linux.vnet.ibm.com
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       stable@kernel.org, Nick Piggin <npiggin@suse.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-Id: <20090223111009.d48ff81d.akpm@linux-foundation.org>
In-Reply-To: <20090223161726.GD6751@linux.vnet.ibm.com>
References: <20090220140157.GA12799@elte.hu>
	<20090222030030.GD6860@linux.vnet.ibm.com>
	<20090223051709.GA5990@linux.vnet.ibm.com>
	<200902240029.37815.nickpiggin@yahoo.com.au>
	<20090223161726.GD6751@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009 08:17:26 -0800 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Tue, Feb 24, 2009 at 12:29:36AM +1100, Nick Piggin wrote:
> > On Monday 23 February 2009 16:17:09 Paul E. McKenney wrote:
> > 
> > > The boot CPU runs in the context of its idle thread during boot-up.
> > > During this time, idle_cpu(0) will always return nonzero, which will
> > > fool Classic and Hierarchical RCU into deciding that a large chunk of
> > > the boot-up sequence is a big long quiescent state.  This in turn causes
> > > RCU to prematurely end grace periods during this time.
> > >
> > > This patch creates a new global variable that is set to 1 just before
> > > the boot CPU first enters the scheduler, after which the idle task
> > > really is idle.
> > 
> > Nice work all (btw. if this patch goes in rather than using system_state,
> > then please make the variable __read_mostly).
> 
> Hmmm...  I misread this and made system_state be __read_mostly.  Let
> me know if this is bad, easy to fix if needed.

Please don't use system_state.  The whole thing is just bad design. 
It's a global variable, breaks encapsulation, creates interactions etc.
CS-101 stuff.

