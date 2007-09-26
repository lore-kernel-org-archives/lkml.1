Return-Path: <linux-kernel-owner+w=401wt.eu-S1755654AbXIZJER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbXIZJER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 05:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752728AbXIZJED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 05:04:03 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56036 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbXIZJEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 05:04:00 -0400
Date: Wed, 26 Sep 2007 14:33:57 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Avishay Traeger <atraeger@cs.sunysb.edu>
Cc: prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: KPROBES: Instrumenting a function's call site
Message-ID: <20070926090357.GA7651@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1190758358.30061.13.camel@rockstar.fsl.cs.sunysb.edu> <20070926043933.GA6460@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070926043933.GA6460@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 10:09:33AM +0530, Ananth N Mavinakayanahalli wrote:
> On Tue, Sep 25, 2007 at 06:12:38PM -0400, Avishay Traeger wrote:
> > Hello,
> > I am trying to use kprobes to measure the latency of a function by
> > instrumenting its call site.  Basically, I find the call instruction,
> > and insert a kprobe with a pre-handler and post-handler at that point.
> > The pre-handler measures the latency (reads the TSC counter).  The
> > post-handler measures the latency again, and subtracts the value that
> > was read in the pre-handler to compute the total latency of the called
> > function.
> 
> This sounds ok...

Thinking further, its not ok :(

> > So to measure the latency of foo(), I basically want kprobes to do this:
> > pre_handler();
> > foo();
> > post_handler();
> > 
> > The problem is that the latencies that I am getting are consistently low
> > (~10,000 cycles).  When I manually instrument the functions, the latency
> > is about 20,000,000 cycles.  Clearly something is not right here.

What happens when the "call" is singlestepped is that the instruction
pointer is moved to the call target. That explains the lower latency you
are seeing. You'll need to do something along the lines I suggested in
the earlier mail.

Ananth
