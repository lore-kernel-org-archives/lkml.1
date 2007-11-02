Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbXKBPZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbXKBPZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbXKBPZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:25:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47961 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115AbXKBPZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:25:42 -0400
Date: Fri, 2 Nov 2007 16:25:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: delayacct regression in 2.6.24 git
Message-ID: <20071102152529.GB20134@elte.hu>
References: <472B2908.7020507@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472B2908.7020507@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Hi, Ingo,
> 
> I missed commit 75d4ef16a6aa84f708188bada182315f80aab6fa
> "sched: fix delay accounting performance regression"
> 
> Without these changes, I find that delay accounting does
> not work as expected, I see zeros in the field for virtual,delay
> and count(s).
> 
> CPU             count     real total  virtual total    delay total
>                     0      535861848              0              0
> 
> 
> This breaks existing delay accounting behaviour.
> 
> Am I missing something?

delay accounting was causing context-switch slowdown because it called 
sched_clock() explicitly - but indeed my fix to that is wrong ...

how about reverting the change but also using rq->clock instead of 
sched_clock()?

	Ingo
