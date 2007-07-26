Return-Path: <linux-kernel-owner+w=401wt.eu-S934489AbXGZVcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934489AbXGZVcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 17:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763253AbXGZVcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 17:32:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46810 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759833AbXGZVcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 17:32:06 -0400
Date: Thu, 26 Jul 2007 23:31:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tong Li <tong.n.li@intel.com>
Cc: linux-kernel@vger.kernel.org, Chris Snook <csnook@redhat.com>
Subject: Re: [RFC] scheduler: improve SMP fairness in CFS
Message-ID: <20070726213154.GA26569@elte.hu>
References: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com> <20070725110159.GA15076@elte.hu> <20070725120358.GA30755@elte.hu> <Pine.LNX.4.64.0707251014520.14515@tongli.jf.intel.com> <20070725192442.GC4463@elte.hu> <Pine.LNX.4.64.0707261123060.9352@tongli.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707261123060.9352@tongli.jf.intel.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Tong Li <tong.n.li@intel.com> wrote:

> > you need to measure it over longer periods of time. Its not worth 
> > balancing for such a thing in any high-frequency manner. (we'd trash 
> > the cache constantly migrating tasks back and forth.)
> 
> I have some data below, but before that, I'd like to say, at the same 
> load balancing rate, my proposed approach would allow us to have 
> fairness on the order of seconds. I'm less concerned about trashing 
> the cache. The important thing is to have a knob that allow users to 
> trade off fairness and performance based on their needs. [...]

such a knob already exists to a certain degree, but i havent tested its 
full effects on SMP fairness yet. If you pull my scheduler tree:

  git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

and if you enable CONFIG_SCHED_DEBUG, then all the sched-domain 
parameters become runtime tunable under /proc/sys/cpu*.

Could you try to increase the cross-CPU rebalancing frequency and see 
how it impacts the precision of your measurement? Tune 'min_interval' 
and 'max_interval' down to increase the frequency of rebalancing.

	Ingo
