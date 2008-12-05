Return-Path: <linux-kernel-owner+w=401wt.eu-S1757948AbYLEP6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948AbYLEP6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 10:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbYLEP60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 10:58:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:35496 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735AbYLEP6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 10:58:22 -0500
Subject: Re: [ltt-dev] trace a futex
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: prasad@linux.vnet.ibm.com, jan.kiszka@web.de,
       Gian Lorenzo Meocci <glmeocci@gmail.com>, ltt-dev@lists.casi.polymtl.ca,
       linux-kernel@vger.kernel.org, mbligh@google.com,
       tglx.de@twins.programming.kicks-ass.net
In-Reply-To: <20081205122822.GA25816@Krystal>
References: <8d94e9280812021142j2eb5ca72td730410e97ccd9a1@mail.gmail.com>
	 <20081202195015.GA25792@Krystal>
	 <8d94e9280812021215m6a63d6c2l4e64acd26274953d@mail.gmail.com>
	 <20081202215519.GA734@Krystal> <4935B25F.7010701@web.de>
	 <20081203052640.GA13701@Krystal> <20081203180131.GA2904@in.ibm.com>
	 <1228380784.5092.18.camel@twins>  <20081205122822.GA25816@Krystal>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Dec 2008 16:58:12 +0100
Message-Id: <1228492692.20520.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-05 at 07:28 -0500, Mathieu Desnoyers wrote:
> * Peter Zijlstra (peterz@infradead.org) wrote:
> > 
> > FWIW, the ftrace infrastructure has on many an occasion (even before it
> > was called ftrace and specific to -rt) helped in debugging and fixing
> > futex races.
> > 
> 
> Hrm, I'm not sure futex races is the key aspect of interest here.
> Knowing which amount of pthread mutex lock calls ends up calling the
> scheduler looks a bit more like the topic brought by this particular
> use-case. Therefore, correlating the information from the nptl with the
> kernel information would be useful.

We already have the scheduler instrucmentation, so correlating that to
known futex calls (from userspace) shouldn't be too hard. 

> Is lockdep called when a futex is taken ? 

lockdep only does kernel-internal locks - so no.

> Should we add instrumentation
> (tracepoints) to futex.c ? If yes, was there specific instrumentation
> you used with ftrace that should be added ?

Not sure we should, Thomas did the bulk of that ftrace debugging, Thomas
do you think it would be worthwhile to add some tracepoints in there?
