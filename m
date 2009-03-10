Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbZCJRGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbZCJRGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 13:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbZCJRGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 13:06:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54153 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971AbZCJRGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 13:06:38 -0400
Date: Tue, 10 Mar 2009 18:06:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: prasad@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 04/11] Introduce virtual debug register in
	thread_struct and wrapper-routines around process related functions
Message-ID: <20090310170607.GB22897@elte.hu>
References: <20090310143543.GE3850@elte.hu> <Pine.LNX.4.44L0.0903101151450.3979-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903101151450.3979-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 10 Mar 2009, Ingo Molnar wrote:
> 
> > and why is this:
> > 
> > > @@ -427,13 +427,9 @@ struct thread_struct {
> > >  	unsigned long		ip;
> > >  	unsigned long		fs;
> > >  	unsigned long		gs;
> > > -	/* Hardware debugging registers: */
> > > -	unsigned long		debugreg0;
> > > -	unsigned long		debugreg1;
> > > -	unsigned long		debugreg2;
> > > -	unsigned long		debugreg3;
> > > -	unsigned long		debugreg6;
> > > -	unsigned long		debugreg7;
> > > +	/* Hardware breakpoint info */
> > > +	unsigned long	vdr6;
> > > +	struct thread_hw_breakpoint	*hw_breakpoint_info;
> > 
> > detached from thread_struct? There's a lot of complications 
> > (alloc/free, locking, etc.) from this for no good reason - the 
> > hardware-breakpoints info structure is alway per thread and is 
> > quite small, so there's no reason not to embedd it directly 
> > inside thread_struct.
> 
> The only reason for separating it out was to avoid bogging 
> down the vast majority of threads which aren't debugged.  If 
> you think the extra overhead isn't worth worrying about then 
> the hw-breakpoint info structure can be embedded.

yeah. This new facility is barely used, and such things should 
always strive for 100% dumb simplicity. If the overhead of that 
structure is ever a problem we can allocate it dynamically. (but 
generally it's just not worth the pain)

	Ingo
