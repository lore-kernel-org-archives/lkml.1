Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbZDVJRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbZDVJRd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 05:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbZDVJRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 05:17:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55420 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbZDVJRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 05:17:22 -0400
Date: Wed, 22 Apr 2009 11:16:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Anders Kaseorg <andersk@MIT.EDU>, Jeffrey B Arnold <jbarnold@MIT.EDU>
Subject: Re: [PATCH 1/5] ftrace: use module notifier for function tracer
Message-ID: <20090422091645.GB18226@elte.hu>
References: <20090416021830.556671772@goodmis.org> <20090416021928.040177084@goodmis.org> <200904192055.04213.rusty@rustcorp.com.au> <alpine.DEB.1.10.0904191437250.31802@vinegar-pot.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904191437250.31802@vinegar-pot.mit.edu>
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


* Tim Abbott <tabbott@MIT.EDU> wrote:

> On Sun, 19 Apr 2009, Rusty Russell wrote:
> 
> > I think you need to do something else in general.  Share the module_mutex for
> > the ftrace code?  The ksplice guys have a similar issue, so maybe we should
> > generalize this into a "kernel_text" mutex?
> 
> Yes, a kernel_text mutex is on my list of things to propose once 
> Ksplice gets merged.

too late :-) These bits were written 1.5 months ago and are already 
upstream:

3945dab: tracing, Text Edit Lock - SMP alternatives support
4460fda: tracing, Text Edit Lock - kprobes architecture independent support
0e39ac4: tracing, Text Edit Lock - Architecture Independent Code

I suspect ksplice could make use of text_mutex?

	Ingo
