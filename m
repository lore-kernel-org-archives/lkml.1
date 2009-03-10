Return-Path: <linux-kernel-owner+w=401wt.eu-S1752821AbZCJMLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbZCJMLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 08:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZCJMLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 08:11:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42572 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440AbZCJMLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 08:11:43 -0400
Date: Tue, 10 Mar 2009 13:11:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: Don't use tracing_record_cmdline() in
	workqueue tracer
Message-ID: <20090310121125.GC5794@elte.hu>
References: <20090309175330.CF63.A69D9226@jp.fujitsu.com> <20090309092817.GA2184@elte.hu> <20090310090828.A46F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310090828.A46F.A69D9226@jp.fujitsu.com>
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > 
> > * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> > 
> > > Currently, /sys/kernel/debug/tracing/trace_stat/workqueues can 
> > > display wrong and strang thread name.
> > > 
> > > Why?
> > > 
> > > Currently, ftrace has 
> > > tracing_record_cmdline()/trace_find_cmdline() convinience 
> > > function. they implement task->comm string cache. it can avoid 
> > > unnecessary memcpy overhead. and workqueue tracer use it.
> > > 
> > > However, in general, any trace stastics feature shouldn't use 
> > > tracing_record_cmdline(). A trace stastics can display very 
> > > old process. then comm cache can return wrong string because 
> > > recent process override the cache.
> > > 
> > > Fortunately, workqueue trace gerantee to live displayed 
> > > process. Then, we can search comm string from pid at display 
> > > time.
> > 
> > Applied, thanks!
> > 
> > We might need to improve the comm-cache - i've seen frequent 
> > artifacts due to it. Displaying <...> is _far_ better than an 
> > outright misleading string displayed.
> > 
> > I.e. the cache should be improved to be properly coherent with 
> > reality.
> > 
> > 	Ingo
> 
> Doh!
> My last mail's cc list didn't include lkml. that's unintensional silly 
> my mistake. very sorry.
> 
> and Yes, memcpy(buf, task->comm, 16) mean two movq 
> instruction. that is worthless for caching. I think we can 
> remove this cache completely.

ok, agreed - mind sending a patch for that?

> and, I find my last patch has one race window. fixing below.

Could you please send a delta patch against tip:master? Thanks,

	Ingo
