Return-Path: <linux-kernel-owner+w=401wt.eu-S936607AbXGZWSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936607AbXGZWSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 18:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934175AbXGZWSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 18:18:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36908 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762513AbXGZWSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 18:18:48 -0400
Date: Fri, 27 Jul 2007 00:18:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: npiggin@suse.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [patch] sched: introduce SD_BALANCE_FORK for ht/mc/smp domains
Message-ID: <20070726221830.GA4113@elte.hu>
References: <20070726183225.GJ3318@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726183225.GJ3318@linux-os.sc.intel.com>
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


* Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:

> Introduce SD_BALANCE_FORK for HT/MC/SMP domains.
> 
> For HT/MC, as caches are shared, SD_BALANCE_FORK is the right thing to 
> do. Given that NUMA domain already has this flag and the scheduler 
> currently doesn't have the concept of running threads belonging to a 
> process as close as possible(i.e., forking may keep close, but 
> periodic balance later will likely take them far away), introduce 
> SD_BALANCE_FORK for SMP domain too.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

i'm not opposed to this fundamentally, but it would be nice to better 
map the effects of this change: do you have any particular workload 
under which you've tested this and under which you've seen it makes a 
difference? I'd expect this to improve fork-intense half-idle workloads 
perhaps - things like a make -j3 on a 4-core CPU.

	Ingo
