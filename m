Return-Path: <linux-kernel-owner+w=401wt.eu-S1756822AbYIDUEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822AbYIDUEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 16:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbYIDUEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 16:04:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35301 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbYIDUEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 16:04:36 -0400
Date: Thu, 4 Sep 2008 22:04:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: order functions in cpu/common.c and
	cpu/common_64.c
Message-ID: <20080904200421.GA24295@elte.hu>
References: <1220331936-15100-1-git-send-email-yhlu.kernel@gmail.com> <20080904191205.GC24990@elte.hu> <20080904193733.GA25136@elte.hu> <20080904194127.GA2542@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904194127.GA2542@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > i've pushed out the broken tree into tip/tmp.master.broken (havent 
> > updated tip/master with the breakage). I've removed the broken 
> > printk in kernel/resource.c that Andrew found, see commit 
> > 06e44f6af324 - so that's not the cause.
> 
> i've double checked that 06e44f6af324 is applied. I'll bisect this.

bisection came up with:

 # good: [8bfd9710] Merge branch 'x86/xsave'
 # bad:  [06e44f6a] IO resources: fix/remove printk
 # good: [282a5f84] Merge branch 'irq/sparseirq'
 # bad:  [a0854a46] x86: make 32bit support show_msr like 64 bit
 # good: [5031088d] x86: delay early cpu initialization until cpuid is
 # good: [9d31d35b] x86: order functions in cpu/common.c and cpu/commo
 # bad:  [10a434fc] x86: remove cpu_vendor_dev

| 10a434fcb23a57c385177a0086955fae01003f64 is first bad commit
| commit 10a434fcb23a57c385177a0086955fae01003f64
| Author: Yinghai Lu <yhlu.kernel@gmail.com>
| Date:   Thu Sep 4 21:09:45 2008 +0200
|
|     x86: remove cpu_vendor_dev

and the thing is, 10a434fc is way too big:

| 15 files changed, 106 insertions(+), 106 deletions(-)

and it's not obvious at first (neither at second) sight what the problem 
is. You really need to start doing much smaller patches for such 
critical/hard-to-debug code areas.

	Ingo
