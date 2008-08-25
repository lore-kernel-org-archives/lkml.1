Return-Path: <linux-kernel-owner+w=401wt.eu-S1755327AbYHYMj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbYHYMj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 08:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbYHYMjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 08:39:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55925 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753573AbYHYMjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 08:39:49 -0400
Date: Mon, 25 Aug 2008 14:39:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
       davej <davej@codemonkey.org.uk>, Alok Kataria <akataria@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG] cpufreq: constant cpu_khz
Message-ID: <20080825123926.GC8663@elte.hu>
References: <1219646032.20732.10.camel@twins> <1219664106.8515.50.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219664106.8515.50.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> > I noticed that my sched_clock() was slow on a number of machine, so 
> > I started looking at cpufreq.
> 
> The below seems to fix the problem for me, but I don't have enough 
> clue to know if its the correct fix, please advise.

> -	set_cyc2ns_scale(tsc_khz_ref, freq->cpu);
> +	set_cyc2ns_scale(tsc_khz, freq->cpu);

hm, that too is due to the tsc.c unification - Alok Cc:-ed. Applied your 
fix to x86/urgent.

	Ingo
