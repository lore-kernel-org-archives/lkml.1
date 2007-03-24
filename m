Return-Path: <linux-kernel-owner+w=401wt.eu-S932388AbXCXWOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbXCXWOb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 18:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932396AbXCXWOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 18:14:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36426 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388AbXCXWO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 18:14:29 -0400
Date: Sat, 24 Mar 2007 23:09:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] i386: Prevent early access to TSC to avoid crash on TSCless systems
Message-ID: <20070324220945.GA26168@elte.hu>
References: <1174773769.10840.450.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174773769.10840.450.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Thomas Gleixner <tglx@linutronix.de> wrote:

> commit f9690982b8c2f9a2c65acdc113e758ec356676a3 removed the check for 
> cpu_khz from sched_clock(), which prevented early access to the TSC by 
> non obvious magic.
> 
> This is harmless as long as the CPU has a TSC. On TSCless systems this 
> results in an illegal instruction trap.
> 
> Replace tsc_disabled and tsc_unstable by tsc_enabled, which is only 
> set when the tsc is available and not unstable.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

oops, indeed! I think this should also resolve one of the bugs (TSC-less 
Cyrix?) that were reported against -mm some time ago.

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
