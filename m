Return-Path: <linux-kernel-owner+w=401wt.eu-S1762748AbYDVI76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762748AbYDVI76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 04:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762586AbYDVI7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 04:59:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36422 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762548AbYDVI7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 04:59:32 -0400
Date: Tue, 22 Apr 2008 10:59:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Frans Pop <elendil@planet.nl>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Richard Jonsson <richie@coderworld.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [git pull] scheduler changes for v2.6.26
Message-ID: <20080422085905.GA9939@elte.hu>
References: <20080419181304.GB21353@elte.hu> <200804192147.43719.elendil@planet.nl> <20080421123903.GE9554@elte.hu> <200804211831.29976.elendil@planet.nl> <20080421194359.GD8770@elte.hu> <1208854300.4695.7.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208854300.4695.7.camel@marge.simson.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Mike Galbraith <efault@gmx.de> wrote:

> > the 700-800 msecs of delays you see are very "brutal" so there must 
> > be something fundamentally wrong going on here.
> 
> I'm seeing latency hits with 26.git, whereas 25 is hit free.

ok. I think what happens is that your broken sched-clock hid the real 
breakage. Lets try fix the real breakage now.

I've uploaded a new sched-devel.git that is against very latest -git, 
could you try ftrace (with a sufficiently large 
/debug/tracing/tracing_max_entries value) - perhaps the 
worst-case-wakeup-latency tracer shows large latencies? If not, then 
maybe the sched_switch tracer gives a better insight into what's 
happening?

> Erm, should my Q6600 emit such?

on nohz it could happen - and fixed in -git. Patch looked too dangerous 
for late-2.6.25 to merge.

> On 26.git, I get numbers like yours, but with occasional dips down to 
> ~700, though the latency hits don't _seem_ to be synchronous with 
> watch-rq-clock.sh glitchies.

hm, the dips shouldnt be happening normally.

	Ingo
