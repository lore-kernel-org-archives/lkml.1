Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbZKIHzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbZKIHzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbZKIHzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:55:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41803 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbZKIHzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:55:21 -0500
Date: Mon, 9 Nov 2009 08:55:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, tglx@linutronix.de,
       a.p.zijlstra@chello.nl, efault@gmx.de, acme@redhat.com,
       fweisbec@gmail.com
Subject: Re: [PATCH v2 3/7] Adding general performance benchmarking
 subcommand to perf.
Message-ID: <20091109075512.GG453@elte.hu>
References: <20091103172926.GC11535@elte.hu>
 <20091104.194108.635980116686317754.mitake@dcl.info.waseda.ac.jp>
 <20091108113013.GM11372@elte.hu>
 <20091109.122712.865412965745306501.mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109.122712.865412965745306501.mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Subject: Re: [PATCH v2 3/7] Adding general performance benchmarking subcommand to perf.
> Date: Sun, 8 Nov 2009 12:30:13 +0100
> 
> > > > 
> > > > Shouldnt we output the unit of measurement, i.e. '4.575 usecs'? Also, we 
> > > > should perhaps print something like:
> > > > 
> > > >   % perf bench sched pipe
> > > > 
> > > >   (executing 1000000 pipe operations between two tasks)
> > > > 
> > > >      4.575 usecs per op
> > > >     218579 ops/sec   
> > > > 
> > > > ?
> > > 
> > > I have to admit that single float value output is too simple.
> > > So I'll fix the default output.
> > > 
> > > But, I believe that simple form makes sense for
> > > processing by scripts or graph tools like gnuplot.
> > > I'll add the option (may be --simple) to switch
> > > friendliness of outputs.
> > 
> > Btw., could you make it Git-ish, i.e.:
> > 
> >  --format=short
> > 
> > or:
> > 
> >  --format=simple
> > 
> > Eventually more format options might be added.
> 
> It's good idea.
> I have to admit that reserving -s for simple output is not good idea.
> I'll do this.

I think --format=simple will be used by scripts mostly, so it doesnt 
matter that it's longer to type. We try to save the shorter options for 
humans and be conservative with them.

Another angle is coherency between different subcommands - and '-s' is 
already used as -s/--sort in other perf subcommands, which does not 
match up with the '-s/--simple' usage.

We try to match what the Git project does here - a good deal of 
infrastructure code in perf came from Git and i find Git very easy to 
use and it's managed well.

It's not a hard rule: not all option name incoherencies are fixable or 
avoidable, and there's no big problem if something slips in - i just 
wanted to mention so that you can keep an eye on it when developing new 
features for perf bench.

	Ingo
