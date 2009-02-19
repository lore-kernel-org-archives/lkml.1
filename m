Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZBSISS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZBSISS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 03:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbZBSISG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 03:18:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55418 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbZBSISD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 03:18:03 -0500
Date: Thu, 19 Feb 2009 09:17:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [PATCH 0/6] [git pull] updates for tip/tracing/ftrace
Message-ID: <20090219081728.GA15452@elte.hu>
References: <20090217182048.233060814@goodmis.org> <20090218000952.GD12714@elte.hu> <20090218084041.GA27540@elte.hu> <20090218163524.GA5858@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218163524.GA5858@nowhere>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > the function-graph-tracer started locking up since the last 
> > batch of changes:
> > 
> >  Testing tracer sysprof: .. no entries found ..FAILED!
> >  initcall 0xffffffff812e91d1 returned -1 after 101562 usecs
> >  initcall 0xffffffff812e91d1 returned with error code -1 
> >  calling  0xffffffff812e91e3 @ 1
> >  Testing tracer function: PASSED
> >  Testing dynamic ftrace: 
> >  [hard lockup]
> 
> I've successfully reproduced it with your config.
> Note that I didn't built the function graph tracer.
> 
> I also tried to set ftrace=nop as a parameter to avoid the selftests and then
> enabled the function tracer after the boot. And then I had no problem.
> 
> Looks like it happens during dynamic ftrace initialization.
> Perhaps a problem with the recent mutex conversion and kstopmachine, which
> could result in a hardlockup in case of a deadlock.
> 
> But lockdep didn't say anything.
> I'm reverting some of the last patches and will see.

Frederic, Steve, any progress on this bug? It's blocking all new 
tracing patches.

	Ingo
