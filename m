Return-Path: <linux-kernel-owner+w=401wt.eu-S2992875AbXDDLuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992875AbXDDLuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 07:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992876AbXDDLuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 07:50:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51471 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992875AbXDDLuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 07:50:00 -0400
Date: Wed, 4 Apr 2007 13:49:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFC] Cpu-hotplug: Using the Process Freezer (try2)
Message-ID: <20070404114901.GA8261@elte.hu>
References: <20070402061612.GA7072@elte.hu> <20070402092818.GE2456@in.ibm.com> <20070402111828.GA14771@elte.hu> <20070402124200.GA9566@in.ibm.com> <20070402185607.GA2081@elte.hu> <20070403125619.GA32444@in.ibm.com> <20070403141516.GB14900@in.ibm.com> <20070404031502.GA23591@in.ibm.com> <20070404100431.GB19120@elte.hu> <20070404104123.GA14825@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404104123.GA14825@in.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Gautham R Shenoy <ego@in.ibm.com> wrote:

> On Wed, Apr 04, 2007 at 12:04:31PM +0200, Ingo Molnar wrote:
> > 
> > yeah, i think you are right - and the TASK_UNINTERRUPTIBLE thing is 
> > not only quite complex, it also breaks the symmetry of freezer use 
> > (sw-suspend obviously cannot freeze uninterruptible tasks). We 
> > should watch whether the current latency of freezing is good enough 
> > in practice.
> 
> Ok. Do you have any specific tests in mind which I can run and post 
> the numbers?
> 
> As of now, I've been stressing the system with (kernbench + ondemand 
> governor) and timing the hotplug operation.

i suspect a fork-intensive application like kernbench should be close to 
the worst-case already. A more IO-intensive workload would maximize the 
uninterruptible-sleep latencies perhaps?

	Ingo
