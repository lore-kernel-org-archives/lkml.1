Return-Path: <linux-kernel-owner+w=401wt.eu-S1762660AbZBYLLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762660AbZBYLLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 06:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755063AbZBYLLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 06:11:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58486 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbZBYLLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 06:11:24 -0500
Date: Wed, 25 Feb 2009 12:11:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:tracing/hw-branch-tracing] tracing/hw-branch-tracing:
	convert bts-tracer mutex to a spinlock
Message-ID: <20090225111116.GB15453@elte.hu>
References: <tip-2d542cf34264ac92e9e7ac55c0b096b066d569d2@kernel.org> <928CFBE8E7CB0040959E56B4EA41A77E4A4C1EF6@irsmsx504.ger.corp.intel.com> <20090225095814.GC12352@elte.hu> <928CFBE8E7CB0040959E56B4EA41A77E4A4C1F31@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E4A4C1F31@irsmsx504.ger.corp.intel.com>
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


* Metzger, Markus T <markus.t.metzger@intel.com> wrote:

> >-----Original Message-----
> >From: Ingo Molnar [mailto:mingo@elte.hu]
> >Sent: Wednesday, February 25, 2009 10:58 AM
> >To: Metzger, Markus T
> 
> 
> >* Metzger, Markus T <markus.t.metzger@intel.com> wrote:
> >
> >> > static void trace_bts_prepare(struct trace_iterator *iter)
> >> > {
> >> >-    mutex_lock(&bts_tracer_mutex);
> >> >+    spin_lock(&bts_tracer_lock);
> >> >
> >> >     on_each_cpu(trace_bts_cpu, iter->tr, 1);
> >> >
> >> >-    mutex_unlock(&bts_tracer_mutex);
> >> >+    spin_unlock(&bts_tracer_lock);
> >> > }
> >>
> >> Whereas start/stop are relatively fast, the above operation is
> >> rather expensive. Would it make sense to use
> >> schedule_on_each_cpu() instead of on_each_cpu()?
> >
> >it's perfectly fine to do that on_each_cpu() under the spinlock.
> >schedule_on_each_cpu() would likely be more expensive - and for
> >no good reason.
> 
> OK. 
> 
> And I assume you like the spinlock better than the
> get/put_online_cpus(), as well.

yeah - and get/put_online_cpus is sleepable too, so it doesnt 
really help unless i'm missing something ...

	Ingo
