Return-Path: <linux-kernel-owner+w=401wt.eu-S1754685AbYDHNya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbYDHNya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 09:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYDHNyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 09:54:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54890 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbYDHNyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 09:54:23 -0400
Date: Tue, 8 Apr 2008 15:54:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [rc8] Regression: key repeats and skips in music during
	compilation
Message-ID: <20080408135400.GA18493@elte.hu>
References: <200804041222.35025.elendil@planet.nl> <200804071403.59500.elendil@planet.nl> <20080407123234.GA8521@elte.hu> <200804081137.20063.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804081137.20063.elendil@planet.nl>
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

> > and a more laborous way would be to trace such skipping:
> >  http://people.redhat.com/mingo/sched-devel.git/howto-trace-latencies.txt
> 
> Tried this too, but the problem is that the skips don't happen while 
> tracing is enabled. Apparently the system overhead is so high that it 
> changes the scheduling behavior. Attached one trace that was made 
> immediately after a skip happened. Maybe it helps.

one way to reduce tracing overhead would be:

  echo nostacktrace > /sys/kernel/debug/tracing/iter_ctrl
  echo nosched-tree > /sys/kernel/debug/tracing/iter_ctrl

and making sure you only have CONFIG_CONTEXT_SWITCH_TRACER=y enabled, 
not any of the other tracers.

but ... if there's a narrow wakeup race, even lightweight tracing could 
make it go away.

	Ingo


