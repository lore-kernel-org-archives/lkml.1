Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbZJ2Veo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbZJ2Veo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 17:34:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbZJ2Ven
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 17:34:43 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:58339 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945AbZJ2Ven (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 17:34:43 -0400
Date: Fri, 30 Oct 2009 03:04:40 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC Patch 2/4] Allow breakpoints to be enabled/disabled
	without yielding the breakpoint request through new APIs -
	<enable><disable>_hw_breakpoint()
Message-ID: <20091029213440.GA4596@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20091026211225.214925175@xyz> <20091026211915.GC15529@in.ibm.com> <1256761909.26028.1794.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256761909.26028.1794.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 04:31:49PM -0400, Steven Rostedt wrote:
> On Tue, 2009-10-27 at 02:49 +0530, K.Prasad wrote:
> 
> > Index: linux-2.6-tip.perf_hbkpt/include/asm-generic/hw_breakpoint.h
> > ===================================================================
> > --- linux-2.6-tip.perf_hbkpt.orig/include/asm-generic/hw_breakpoint.h
> > +++ linux-2.6-tip.perf_hbkpt/include/asm-generic/hw_breakpoint.h
> > @@ -102,11 +102,22 @@
> >   * ----------------------------------------------------------------------
> >   */
> >  struct hw_breakpoint {
> > +	/*
> > +	 * Denotes if a breakpoint is currently enabled in physical debug
> > +	 * registers. Not to be set directly by the end-user. Must be
> > +	 * operated through <enable><disable>_hw_breakpoint() APIs only.
> > +	 */
> > +	atomic_t enabled;
> 
> Just a nit, but by looking at this structure as a whole, it's not easy
> to see that the above comment is talking just about the "enabled" part
> of the structure or the entire structure itself.
> 
> Probably want to add ...
> 
> 	/*
> 	 * The enabled item denotes if ...
> 
> 
> -- Steve
>

I will modify the comments to read as under...the role of the 'enabled'
flag has undergone changes and the comments will reflect that.


 struct hw_breakpoint {
+	/*
+	 * The 'enabled' flag denotes if a breakpoint hit would in-turn invoke
+	 * the 'triggered' function. Not to be set directly by the end-user.
+	 * Must be operated through <enable><disable>_hw_breakpoint() APIs only.
+	 */
+	atomic_t enabled;
 	void (*triggered)(struct hw_breakpoint *, struct pt_regs *);
 	const cpumask_t *cpumask;
 	struct arch_hw_breakpoint info;

Thanks,
K.Prasad

