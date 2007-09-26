Return-Path: <linux-kernel-owner+w=401wt.eu-S1759408AbXIZR1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbXIZR1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 13:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbXIZR1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 13:27:30 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59750 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbXIZR13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 13:27:29 -0400
Date: Wed, 26 Sep 2007 22:57:21 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Avishay Traeger <atraeger@cs.sunysb.edu>
Cc: prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: KPROBES: Instrumenting a function's call site
Message-ID: <20070926172721.GA6598@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1190758358.30061.13.camel@rockstar.fsl.cs.sunysb.edu> <20070926043933.GA6460@in.ibm.com> <20070926090357.GA7651@in.ibm.com> <1190822975.3940.17.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190822975.3940.17.camel@localhost>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2007 at 12:09:35PM -0400, Avishay Traeger wrote:
> On Wed, 2007-09-26 at 14:33 +0530, Ananth N Mavinakayanahalli wrote:
> > What happens when the "call" is singlestepped is that the instruction
> > pointer is moved to the call target. That explains the lower latency you
> > are seeing. You'll need to do something along the lines I suggested in
> > the earlier mail.
> 
> Can you please explain what you mean by this more clearly?  I'm not a
> kprobes expert yet.  Specifically, using kprobes the way that I did,
> what will the resulting code look like?  Also, what do you mean by
> "singlestepped"?

If you single-step (regs->eflags | TF_MASK in i386) on a call instruction,
you'll end up at the call target; ie., after the post_kprobe_handler()
returns, the instruction pointer will point to the first instruction
of foo().

Try printk()ing the instruction pointer(regs) after resume_execution()
in the post_kprobe_handler() in your arch/<arch>/kernel/kprobes.c, you'll
see what I mean.

And when I say singlestepped, I mean executing one instruction under the
architecture specific single step enable flag - the "trap" flag for i386,
the MSR_SE for powerpc, etc. Evidently, this'll mean single-stepping a
single instruction.

Ananth
