Return-Path: <linux-kernel-owner+w=401wt.eu-S1759825AbZFWOwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825AbZFWOwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757183AbZFWOwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:52:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34048 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296AbZFWOwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:52:10 -0400
Date: Tue, 23 Jun 2009 16:51:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Brice Goglin <Brice.Goglin@inria.fr>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, paulus@samba.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [perf] howto switch from pfmon
Message-ID: <20090623145127.GB13415@elte.hu>
References: <4A3FEF75.2020804@inria.fr> <20090623131450.GA31519@elte.hu> <4A40E4E2.3090002@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A40E4E2.3090002@inria.fr>
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


* Brice Goglin <Brice.Goglin@inria.fr> wrote:

> Ingo Molnar wrote:
> > You can also do a profile with such events:
> >
> >   perf record -f -e r1000ffe0 ./hackbench 10
> >
> > and look at it via 'perf report'.
> >   
> 
> I am not sure what the perf.data profile file contains but 'perf 
> report' only shows percentages. Is there a way to get a 'perf 
> stat'-like output from 'perf report'? Or maybe just have a -f 
> option in 'perf stat' to send the output into a file (with the PID 
> in the name).

It's not yet possible but it's a very good feature request.

> By the way, there's a typo in the description in 
> tools/perf/Documentation/perf-report.txt, you want s/via perf 
> report/via perf record/

thanks, fixed and pushed out. You can generally find the latest 
'perf' stuff at:

  http://people.redhat.com/mingo/tip.git/README

> > [ Note, there's no need to specify any --follow-* flags as that is
> >   implicit in 'perf'. (and you'll probably also notice that perf
> >   stat is a lot faster at following fast-forking or
> >   context-switching workloads than is pfmon, because it's not ptrace
> >   based.) ]
> 
> What about threads? I didn't find any way to get per-thread 
> counters.
> 
> Ideally, I'd like to be able to see no perf-related output on 
> stdout/stderr at runtime, and later have a look at per-thread 
> counters like 'perf stat' does at runtime.

That's not possible yet either, but makes a lot of sense.

How many threads does your workload typically run, and how do you 
get their stats displayed?

Per thread info is currently available in the profile output:

   perf report --sort comm,pid,symbol

But it would be nice to either extend perf report with a --stat 
option:

   perf report --stat

or to extend perf stat to take an input file via -i:

   perf stat -i perf.data

	Ingo
