Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbZIQUJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbZIQUJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbZIQUJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:09:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34803 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbZIQUJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:09:31 -0400
Date: Thu, 17 Sep 2009 22:09:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf sched: Determine the number of
	CPUs automatically
Message-ID: <20090917200914.GA26993@elte.hu>
References: <tip-5349256ab12dcbc766495cd1cf3651f7203f8564@git.kernel.org> <20090917213409.39b8509c@infradead.org> <20090917194530.GA6773@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917194530.GA6773@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Arjan van de Ven <arjan@infradead.org> wrote:
> 
> > On Thu, 17 Sep 2009 18:07:09 GMT
> > > 
> > > perf sched: Determine the number of CPUs automatically
> > > 
> > > For 'perf sched map' output, determine max_cpu automatically,
> > > instead of the static default of 15.
> > >  
> > >  static u32 curr_pid[MAX_CPUS] = { [0 ... MAX_CPUS-1] = -1 };
> > >  
> > > @@ -1818,6 +1818,9 @@ static struct trace_sched_handler map_ops  = {
> > >  
> > >  static void __cmd_map(void)
> > >  {
> > > +	max_cpu = system("exit `grep ^processor /proc/cpuinfo  | wc
> > > -l`");
> > 
> > YUCK.
> > 
> > what is wrong with
> >    max_cpu = sysconf(_SC_NPROCESSORS_CONF); 
> > ??
> 
> That's nicer - mind sending a patch?

fixed this up myself.

	Ingo
