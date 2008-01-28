Return-Path: <linux-kernel-owner+w=401wt.eu-S1761045AbYA1M2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761045AbYA1M2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 07:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755512AbYA1M2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 07:28:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38645 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755493AbYA1M2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 07:28:08 -0500
Date: Mon, 28 Jan 2008 13:27:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Guillaume Chazarain <guichaz@yahoo.fr>,
       LKML <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com
Subject: Re: High wake up latencies with FAIR_USER_SCHED
Message-ID: <20080128122752.GB24757@elte.hu>
References: <3d8471ca0801271201o5a41955cg552ef06a2f821285@mail.gmail.com> <20080128023129.GD1044@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128023129.GD1044@linux.vnet.ibm.com>
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


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> NEW_FAIR_SLEEPERS feature gives credit for sleeping only to tasks and 
> not group-level entities. With the patch attached, I could see that 
> wakeup latencies with FAIR_USER_SCHED are restored to the same level 
> as !FAIR_USER_SCHED.
> 
> However I am not sure whether that is the way to go. We want to let 
> one group of tasks running as much as possible until the 
> fairness/wakeup-latency threshold is exceeded. If someone does want 
> better wakeup latencies between groups too, they can always tune 
> sysctl_sched_wakeup_granularity.

the patch does look like the right thing to do. There's nothing special 
about 'groups' versus 'tasks' in terms of scheduling. And most 
importantly, this solves the behavioral assymetry observed by Guillaume 
as well - which makes it an obvious-to-add regression fix. I've added 
your patch to the scheduler queue.

	Ingo
