Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbYDWJrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbYDWJrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbYDWJrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:47:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44378 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbYDWJrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:47:02 -0400
Date: Wed, 23 Apr 2008 11:46:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>, Richard Jonsson <richie@coderworld.net>
Subject: Re: [git pull] scheduler changes for v2.6.26
Message-ID: <20080423094644.GB23293@elte.hu>
References: <20080419181304.GB21353@elte.hu> <200804211831.29976.elendil@planet.nl> <20080421194359.GD8770@elte.hu> <200804231136.50639.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804231136.50639.elendil@planet.nl>
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


* Frans Pop <elendil@planet.nl> wrote:

> If I enable tracing with these settings, I get data in both trace 
> *and* in latency_trace. Is the last correct? From 
> http://lkml.org/lkml/2008/2/10/43 I got the impression that file 
> should only be used if the "wakeup" tracer is active.

yeah, that's the intended behavior. 'trace' and 'latency_trace' are two 
kinds of 'views' on the same set of tracer data (with a different output 
format). They are both non-destructive - i.e. they dont deplete the 
trace buffers.

there's even a third view: 'trace_pipe' - which depletes the trace 
buffers and can be used to pipe trace data into a larger file:

    cat trace_pipe > /tmp/large-trace.txt

i guess it would be less confusing if 'trace' and 'latency_trace' was 
just a single 'view' and its behavior depended on iter_ctl settings. (In 
fact, we could probably just get rid of latency_trace - it is a leftover 
from -rt.)

> From the last run I've got three traces with 50000 entries (about a 
> minute worth each). Traces 1 and 2 should each have two skips and 
> trace 3 should have four. I've saved both the trace and latency_trace 
> (ltrace) files.
> 
> They are available at: 
> http://people.debian.org/~fjp/tmp/kernel/sched/.

thanks, we'll have a look.

> BTW, did either of you actually look at the traces I sent for .24? I 
> never got any feedback on those.

hm, i looked at them - i thought i mailed you about that but indeed i 
didnt (sorry about that) - the traces were too short in scope - they 
just covered a few dozen milliseconds in scope, while your description 
said that the problem occured seconds into the trace.

> P.S. I've got group scheduling active in this config as my tests with 
> .24 showed that did not make any difference. Can rerun without if 
> needed.

no need to rerun - but if you do the next test it might make sense to 
disable it, just to reduce the number of variables.

another thing - Peter observed skipping on NOHZ. Does your skipping go 
away if you boot with 'nohz' and/or with CONFIG_NOHZ=y disabled in the 
.config?

	Ingo
