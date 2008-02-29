Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbYB2CkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbYB2CkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 21:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751667AbYB2CkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 21:40:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753433AbYB2CkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 21:40:06 -0500
Date: Thu, 28 Feb 2008 21:39:09 -0500
From: Jason Baron <jbaron@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Max Krasnyanskiy <maxk@qualcomm.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 1/2] add ALL_CPUS option to stop_machine_run()
Message-ID: <20080229023909.GA3440@redhat.com>
References: <20080202210828.840735763@polymtl.ca> <20080202211204.268876860@polymtl.ca> <20080226225242.GA15926@redhat.com> <20080227190519.GA14335@Krystal> <20080228163303.GA6195@redhat.com> <47C73121.2000109@qualcomm.com> <20080228221430.GA22958@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228221430.GA22958@Krystal>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 05:14:30PM -0500, Mathieu Desnoyers wrote:
> * Max Krasnyanskiy (maxk@qualcomm.com) wrote:
> > Jason Baron wrote:
> >> -allow stop_mahcine_run() to call a function on all cpus. Calling  
> >> stop_machine_run() with a 'ALL_CPUS' invokes this new behavior.
> >>  stop_machine_run() proceeds as normal until the calling cpu has
> >>  invoked 'fn'. Then, we tell all the other cpus to call 'fn'.
> >
> > Jason, we're actually trying to reduce the usage of the stop_machine in 
> > general. It's a very big hammer that kills latencies and stuff. It'd be 
> > nice if we did not introduce any more dependencies on it. I guess in some 
> > case there is simply no other way to handle what need to do. But please 
> > think twice
> > (or more :)).
> >
> > Max
> >
> >
> 
> I have a "more complex" immediate value implementation that does not
> depend on such heavy lock. I made this simplified version because Rusty
> preferred it, although I say from the beginning that it kills interrupt
> latency. I could propose the atomic, nmi-safe version directly if enough
> people are in favor of it.
> 
> Mathieu
> 

to me the updating of the immdiate values isn't the critical path, but 
obviously i'd be in favor of a more efficient implementation.

-Jason
