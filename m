Return-Path: <linux-kernel-owner+w=401wt.eu-S933152AbYB2QEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbYB2QEh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759449AbYB2QE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:04:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52090 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759425AbYB2QE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:04:28 -0500
Date: Fri, 29 Feb 2008 17:04:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: ray-lk@madrabbit.org, linux-kernel@vger.kernel.org
Subject: Re: Interactivity issue in 2.6.25-rc3
Message-ID: <20080229160408.GG27248@elte.hu>
References: <20080228184407.GA7117@localhost.ift.unesp.br> <20080228191824.GA20019@elte.hu> <2c0942db0802281154y3176e847g8b9a4091df5cc8af@mail.gmail.com> <20080228210627.GA4337@localhost.ift.unesp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228210627.GA4337@localhost.ift.unesp.br>
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


(on-list)

* Carlos R. Mafra <crmafra2@gmail.com> wrote:

> Is it an scheduler anomaly if 'se.wait_max' is bigger than 40 msecs 
> for _any_ of the processes which appear in the debug script log? In 
> other words, is the scheduler mathematically build to not allow 
> latencies higher than 40 msecs?

it is definitely an anomaly if it's bigger than 40 msecs if you clear 
all stats via cfs-debug-info-clear.sh and the large latencies appear 
after that. You can force it to go above 40 msecs if you run more than 
say 40 CPU hogs in parallel, so it's not "mathematical", but you should 
never see large latencies under normal workloads - and that includes 
almost everything but "insanely high" workloads.

and obviously, even if you only 'feel' long delays that's too an anomaly 
by definition, no matter what the scripts say about it. It might even be 
a scheduler anomaly as well: for example if the scheduler clock has an 
anomaly - on which the delay statistics are based too.

generally, latencytop gives a pretty good idea about where app delays 
come from. (As a second-level mechanism, in sched-devel.git you can try 
the latency tracer.)

	Ingo
