Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbYGBO1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbYGBO1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 10:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbYGBO1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 10:27:33 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:39277 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbYGBO1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 10:27:32 -0400
Date: Wed, 2 Jul 2008 15:27:09 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Dean Nelson <dcn@sgi.com>, ksummit-2008-discuss@lists.linux-foundation.org,
       Robin Holt <holt@sgi.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2008-discuss] Delayed interrupt work, thread pools
In-Reply-To: <1214966332.21182.2.camel@pasglop>
Message-ID: <Pine.LNX.4.64.0807021524020.2151@blonde.site>
References: <1214916335.20711.141.camel@pasglop> <20080701130240.GD10511@sgi.com>
  <20080702013927.GA2264@sgi.com> <1214966332.21182.2.camel@pasglop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008, Benjamin Herrenschmidt wrote:
> On Tue, 2008-07-01 at 20:39 -0500, Dean Nelson wrote:
> > As Robin, mentioned XPC manages a pool of kthreads that can (for performance
> > reasons) be quickly awakened by an interrupt handler and that are able to
> > block for indefinite periods of time.
> > 
> > In drivers/misc/sgi-xp/xpc_main.c you'll find a rather simplistic attempt
> > at maintaining this pool of kthreads. 
> > 
> > The kthreads are activated by calling xpc_activate_kthreads(). Either idle
> > kthreads are awakened or new kthreads are created if a sufficent number of
> > idle kthreads are not available.
> > 
> > Once finished with current 'work' a kthread waits for new work by calling
> > wait_event_interruptible_exclusive(). (The call is found in
> > xpc_kthread_waitmsgs().)
> > 
> > The number of idle kthreads is limited as is the total number of kthreads
> > allowed to exist concurrently.
> > 
> > It's certainly not optimal in the way it maintains the number of kthreads
> > in the pool over time, but I've not had the time to spare to make it better.
> > 
> > I'd love it if a general mechanism were provided so that XPC could get out
> > of maintaining its own pool.
> 
> Thanks. That makes one existing in-tree user and a one likely WIP user,
> probably enough to move forward :-)
> 
> I'll look at your implementation and discuss internally see what our
> specific needs in term of number of threads etc... look like.
> 
> I might come up with something simple first (ie, generalizing your
> current implementation for example) and then look at some smarter
> management of the thread pools.

Do the pdflush daemons (from mm/pdflush.c) provide another example?

Hugh
