Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbXJ3H1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbXJ3H1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 03:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbXJ3H1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 03:27:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57065 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbXJ3H1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 03:27:11 -0400
Date: Tue, 30 Oct 2007 08:26:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: aim7 -30% regression in 2.6.24-rc1
Message-ID: <20071030072658.GB20372@elte.hu>
References: <1193391787.3019.174.camel@ymzhang> <20071026112307.GA30406@elte.hu> <1193624538.3019.189.camel@ymzhang> <1193650626.3019.198.camel@ymzhang> <1193710325.3019.203.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193710325.3019.203.camel@ymzhang>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:

> sub-bisecting captured patch 
> 38ad464d410dadceda1563f36bdb0be7fe4c8938(sched: uniform tunings) 
> caused 20% regression of aim7.
> 
> The last 10% should be also related to sched parameters, such like 
> sysctl_sched_min_granularity.

ah, interesting. Since you have CONFIG_SCHED_DEBUG enabled, could you 
please try to figure out what the best value for 
/proc/sys/kernel_sched_latency, /proc/sys/kernel_sched_nr_latency and 
/proc/sys/kernel_sched_min_granularity is?

there's a tuning constraint for kernel_sched_nr_latency: 

- kernel_sched_nr_latency should always be set to 
  kernel_sched_latency/kernel_sched_min_granularity. (it's not a free 
  tunable)

i suspect a good approach would be to double the value of 
kernel_sched_latency and kernel_sched_nr_latency in each tuning 
iteration, while keeping kernel_sched_min_granularity unchanged. That 
will excercise the tuning values of the 2.6.23 kernel as well.

	Ingo
