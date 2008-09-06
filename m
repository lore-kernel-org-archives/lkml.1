Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbYIFRXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbYIFRXp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 13:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbYIFRXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 13:23:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57703 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbYIFRXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 13:23:36 -0400
Date: Sat, 6 Sep 2008 19:23:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: linux-kernel@vger.kernel.org, svaidy@linux.vnet.ibm.com,
       peterz@infradead.org
Subject: Re: [PATCH] sched: arch_reinit_sched_domains() must destroy
	domains to force rebuild
Message-ID: <20080906172316.GK4856@elte.hu>
References: <1220040701-3139-1-git-send-email-maxk@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220040701-3139-1-git-send-email-maxk@qualcomm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Max Krasnyansky <maxk@qualcomm.com> wrote:

> What I realized recently is that calling rebuild_sched_domains() in
> arch_reinit_sched_domains() by itself is not enough when cpusets are enabled.
> partition_sched_domains() code is trying to avoid unnecessary domain rebuilds
> and will not actually rebuild anything if new domain masks match the old ones.
> 
> What this means is that doing
>      echo 1 > /sys/devices/system/cpu/sched_mc_power_savings
> on a system with cpusets enabled will not take affect untill something changes
> in the cpuset setup (ie new sets created or deleted).
> 
> This patch fixes restore correct behaviour where domains must be rebuilt in
> order to enable MC powersaving flags.
> 
> Test on quad-core Core2 box with both CONFIG_CPUSETS and !CONFIG_CPUSETS.
> Also tested on dual-core Core2 laptop. Lockdep is happy and things are working
> as expected.
> 
> Ingo, please apply.

applied to tip/sched/cpuset, thanks Max.

> btw We also need to push my other cpuset patch into mainline.  [...]

will push it once this has been tested some more.

	Ingo
