Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbZF0Qxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbZF0Qxd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 12:53:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756598AbZF0QxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 12:53:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55651 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402AbZF0QxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 12:53:03 -0400
Date: Sat, 27 Jun 2009 18:52:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/urgent] perf stat: Add -n/--null option to
	run without counters
Message-ID: <20090627165201.GC17638@elte.hu>
References: <tip-0cfb7a13b8e4e0afd4b856156ab16a182de7505b@git.kernel.org> <1246089384.2961.5.camel@hpdv5.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246089384.2961.5.camel@hpdv5.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Sat, 2009-06-27 at 04:31 +0000, tip-bot for Ingo Molnar wrote:
> > Commit-ID:  0cfb7a13b8e4e0afd4b856156ab16a182de7505b
> > Gitweb:     http://git.kernel.org/tip/0cfb7a13b8e4e0afd4b856156ab16a182de7505b
> > Author:     Ingo Molnar <mingo@elte.hu>
> > AuthorDate: Sat, 27 Jun 2009 06:10:30 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sat, 27 Jun 2009 06:11:24 +0200
> > 
> > perf stat: Add -n/--null option to run without counters
> > 
> > Allow a no-counters run. This can be useful to measure just
> > elapsed wall-clock time - or to assess the raw overhead of perf
> > stat itself, without running any counters.
> > 
> 
> Why it better then $ time <command>

For example can 'time' do average and standard deviation 
measurements, like:

	perf stat --repeat 10 --null /bin/true

?

Also, --null can be used to validate 'perf stat'.

> Any way this patch is broken.
>
> Why you are allocating :
> memcpy(attrs, default_attrs, sizeof(attrs)); when null_run is set.

a memcpy is not 'allocating' anything. What do you mean?

The memcpy itself could be unnecessary. Is it a big problem?

What exactly is 'broken' about it? It's a straightforward feature.

> To get better picture and solution, Please check [PATCH] perf 
> stat: fix default attrs and nr_counters
> 
> which I send in "Re: [PATCH -tip] perf_counter tools: add support 
> to set of multiple events in one short" send on Fri, 26 Jun 2009 
> 18:08:40 +0530

When you send new patches you should change the subject line.

Also, that patch mixes in some other changes that look wrong. 
Anyway, please resubmit as standalone patch if you think that 
something is broken.

	Ingo
