Return-Path: <linux-kernel-owner+w=401wt.eu-S1759656AbXKLRFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656AbXKLRFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 12:05:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbXKLRFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 12:05:43 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:35842 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbXKLRFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 12:05:42 -0500
Date: Mon, 12 Nov 2007 09:05:21 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       tony@bakeyournoodle.com, paulus@samba.org, dino@in.ibm.com,
       tytso@us.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com, antonb@us.ibm.com
Subject: Re: [PATCH, RFC] improved hacks to allow -rt to run kernbench on POWER
Message-ID: <20071112170521.GA11113@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20071109181028.GA26800@linux.vnet.ibm.com> <1194641524.21340.14.camel@pasglop> <20071109220717.GJ8826@linux.vnet.ibm.com> <1194753541.21340.26.camel@pasglop> <Pine.LNX.4.58.0711110943510.12853@gandalf.stny.rr.com> <1194814125.6510.14.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194814125.6510.14.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 07:48:45AM +1100, Benjamin Herrenschmidt wrote:
> 
> On Sun, 2007-11-11 at 09:45 -0500, Steven Rostedt wrote:
> > > Well, I suppose the patch could go in, maybe with some ifdef's
> > around
> > > the bits in _switch_to, there's little point in doing that on non-rt
> > > kernels.
> > 
> > As Nick Piggin already stated, and I'll even state it for the RT
> > kernel,
> > we do not allow preemption in switch_to. So it is safe to remove those
> > "preempt_disable" bits from the patch
> 
> Sure, I know that, I'm not talking about that, I'm talking about the
> added code that flush pending batches & save the batch state, since on
> non-rt kernel, this is not useful (the batch is only ever active within
> a spinlocked section, which cannot be preempted on non-rt).

Ah, I need a bit of conditional compilation.  Will fix.

							Thanx, Paul
