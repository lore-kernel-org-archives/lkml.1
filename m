Return-Path: <linux-kernel-owner+w=401wt.eu-S1759135AbXGCHP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135AbXGCHP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 03:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755308AbXGCHPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 03:15:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56711 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbXGCHPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 03:15:20 -0400
Date: Tue, 3 Jul 2007 09:15:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v18
Message-ID: <20070703071512.GA29984@elte.hu>
References: <20070622220202.GA16872@elte.hu> <19f34abd0707020444r47221944tf7f33b2a0d17c367@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0707020444r47221944tf7f33b2a0d17c367@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> I'd also like to point out that Folding@Home seems to draw more CPU 
> than it should. Or, at least, in top, it shows up as using 50% CPU 
> even though other processes are demanding as much as they can get. The 
> FAH program should be running with idle priority. I expect it to fall 
> to near 0% when other programs are running at full speed, but it keeps 
> trotting along. And I am pretty sure that this is not due to SMP/HT (I 
> made sure to utilize both CPUs).

your FAH processes are running with nice +19 - that should be enough to 
throttle them. With v18 you can also mark it SCHED_IDLE:

    schedtool -D $$  # mark the shell idle

SCHED_IDLE gets inherited by child tasks so if you mark the shell that 
starts up FEH as SCHED_IDLE, all FEH threads should be SCHED_IDLE too. 
(or you can start it up via schedtool -D -e ... )

does it still get more CPU time than you'd expect it to get? A reniced 
or SCHED_IDLE task will 'fill in' any idle time that it senses, so in 
itself it's not an anomaly if a task gets 50% and FEH fills in the 
remaining 50%. Does it still get CPU time if you start two CPU hogs:

   for (( N=0; N < 2; N++ )); do ( while :; do :; done ) & done

? If yes, that would be an anomaly.

> Otherwise, I am satisfied with the performance of CFS. Especially the 
> desktop is noticably smoother. Thanks!

great! :-)

	Ingo
