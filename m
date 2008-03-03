Return-Path: <linux-kernel-owner+w=401wt.eu-S1761609AbYCCKEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761609AbYCCKEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323AbYCCKEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:04:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58264 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647AbYCCKEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:04:39 -0500
Date: Mon, 3 Mar 2008 11:04:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Christoph Hellwig <hch@lst.de>, cbe-oss-dev@ozlabs.org,
       Jeremy Kerr <jk@ozlabs.org>, linux-kernel@vger.kernel.org
Subject: Re: SCHED_IDLE documentation
Message-ID: <20080303100418.GF18281@elte.hu>
References: <1203376368.275756.252634247263.1.gpush@pokey> <cfd18e0f0803030040l667dd2b7v6298e78c5b21bfec@mail.gmail.com> <20080303092422.GA18281@elte.hu> <200803031031.52335.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803031031.52335.arnd@arndb.de>
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


* Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 03 March 2008, Ingo Molnar wrote:
> > > * What's the difference between SCHED_IDLE and SCHED_BATCH?
> > 
> > SCHED_BATCH can still have nice levels from -20 to +19, it is a modified 
> > SCHED_OTHER/SCHED_NORMAL for "throughput oriented" workloads.
> > 
> > SCHED_IDLE overrides the nice settings and it means a "super idle" 
> > workload.
> 
> Does that mean that a SCHED_IDLE task still runs some of the time if 
> you have a CPU hog running on +19, or can any other process starve the 
> SCHED_IDLE task?

yes, even SCHED_IDLE tasks get some CPU time - so complete starvation 
should not be possible. We dont really want to define the exact amount 
of time they need. (we might want to change that in the future) But it 
will always be less prio than nice +19 :-) You can think of it as if it 
was "nice +30".

> What happens if you have two SCHED_IDLE tasks on a single CPU, do they 
> get equal share, or will they just run as batch jobs?

they get equal share.

you can try it out too: if you have 2.6.23 or newer kernels then just 
pick up schedtool and use "schedtool -I" to run SCHED_IDLE tasks.

	Ingo
