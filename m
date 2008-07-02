Return-Path: <linux-kernel-owner+w=401wt.eu-S1760146AbYGBCjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760146AbYGBCjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 22:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbYGBCjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 22:39:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:57351 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321AbYGBCjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 22:39:01 -0400
Subject: Re: Delayed interrupt work, thread pools
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Dean Nelson <dcn@sgi.com>
Cc: Robin Holt <holt@sgi.com>, ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20080702013927.GA2264@sgi.com>
References: <1214916335.20711.141.camel@pasglop>
	 <20080701130240.GD10511@sgi.com>  <20080702013927.GA2264@sgi.com>
Content-Type: text/plain
Date: Wed, 02 Jul 2008 12:38:52 +1000
Message-Id: <1214966332.21182.2.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-01 at 20:39 -0500, Dean Nelson wrote:
> As Robin, mentioned XPC manages a pool of kthreads that can (for performance
> reasons) be quickly awakened by an interrupt handler and that are able to
> block for indefinite periods of time.
> 
> In drivers/misc/sgi-xp/xpc_main.c you'll find a rather simplistic attempt
> at maintaining this pool of kthreads. 
> 
> The kthreads are activated by calling xpc_activate_kthreads(). Either idle
> kthreads are awakened or new kthreads are created if a sufficent number of
> idle kthreads are not available.
> 
> Once finished with current 'work' a kthread waits for new work by calling
> wait_event_interruptible_exclusive(). (The call is found in
> xpc_kthread_waitmsgs().)
> 
> The number of idle kthreads is limited as is the total number of kthreads
> allowed to exist concurrently.
> 
> It's certainly not optimal in the way it maintains the number of kthreads
> in the pool over time, but I've not had the time to spare to make it better.
> 
> I'd love it if a general mechanism were provided so that XPC could get out
> of maintaining its own pool.

Thanks. That makes one existing in-tree user and a one likely WIP user,
probably enough to move forward :-)

I'll look at your implementation and discuss internally see what our
specific needs in term of number of threads etc... look like.

I might come up with something simple first (ie, generalizing your
current implementation for example) and then look at some smarter
management of the thread pools.

Cheers,
Ben.


