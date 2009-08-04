Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbZHDOiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbZHDOiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755488AbZHDOiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:38:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35192 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958AbZHDOiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:38:21 -0400
Date: Tue, 4 Aug 2009 16:38:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Add walltime support for ring-buffer
Message-ID: <20090804143812.GJ7746@elte.hu>
References: <20090728105931.D801.A69D9226@jp.fujitsu.com> <20090803072255.GB27581@elte.hu> <20090803182412.CC15.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090803182412.CC15.A69D9226@jp.fujitsu.com>
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > 
> > * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > > It can. but I don't think it is sufficient. On flight recorder 
> > > use-case, The tracing run more than one year. And, Administrator 
> > > only see last N sec log. (previous logs were overwritten by 
> > > ring-buffer go-around)
> > 
> > That's definitely something we want to enable ASAP.
> > 
> > I'm wondering why a single u64 timestamp is not enough to express 
> > the full, absolute range of time elapsed since bootup, in 
> > nanoseconds.
> > 
> > That would make walltime a matter of pretty-printing only - we'd 
> > have to convert the u64 nsec timestamp into a walltime format, 
> > right?
> > 
> > In fact we could change all the timestamps to be standardized along 
> > 'nanoseconds elapsed since 1970' or so - not nanoseconds since the 
> > last bootup. That still fits just fine within 64 bits - u64 
> > nanoseconds has a scope of 500+ years.
> 
> Ah, you are right. thanks correct me. but I think ntp updating 
> time storing is necessary too.

Yeah. As long as we only save a single u64 into the trace it should 
all be fine.

There could be periodic samples of <walltime, sched_clock()> saved 
on a per cpu basis, and thus converting sched_clock() values into 
walltime unit?

	Ingo
