Return-Path: <linux-kernel-owner+w=401wt.eu-S1759100AbYDUTof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100AbYDUTof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758073AbYDUTo0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:44:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54102 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768AbYDUToZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:44:25 -0400
Date: Mon, 21 Apr 2008 21:43:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Richard Jonsson <richie@coderworld.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [git pull] scheduler changes for v2.6.26
Message-ID: <20080421194359.GD8770@elte.hu>
References: <20080419181304.GB21353@elte.hu> <200804192147.43719.elendil@planet.nl> <20080421123903.GE9554@elte.hu> <200804211831.29976.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804211831.29976.elendil@planet.nl>
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

> > It would be nice if you could try sched-devel/latest because it has 
> > an improved ftrace "sched_switch" tracer where you can generate much 
> > longer traces of this incident. Try the new /debug/trace_entries 
> > runtime tunable.
> 
> I'll try to get the trace and will reply on the private thread we had. 
> I may need additional instructions though.

you could also reply to this thread if you dont mind, so that others can 
chime in too.

the 700-800 msecs of delays you see are very "brutal" so there must be 
something fundamentally wrong going on here.

Could you first check (under sched-devel/latest) the quality of your 
sched-clock, via running this script:

   http://people.redhat.com/mingo/cfs-scheduler/tools/watch-rq-clock.sh

if you run it, it should output ~1000 msecs periods every second:

 europe:~> watch-rq-clock.sh
 1002.115042
 1005.509851
 1004.187275
 1004.409980
 1004.430264
 1004.445508

if it's way too 'slow', say it only 100 msecs per second, then the 
scheduler clock is mis-measuring time and what the scheduler thinks to 
be a 40 msecs delay might become a 400 msecs delay.

	Ingo
