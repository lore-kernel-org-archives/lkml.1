Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbXLVNoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbXLVNoK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 08:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbXLVNn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 08:43:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60465 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbXLVNn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 08:43:56 -0500
Date: Sat, 22 Dec 2007 14:40:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, clameter@sgi.com, a.p.zijlstra@chello.nl
Subject: Re: [PATCH] slub: /proc/slabinfo ABI compatibility
Message-ID: <20071222134010.GA12294@elte.hu>
References: <Pine.LNX.4.64.0712221446280.24655@sbz-30.cs.Helsinki.FI> <20071222131456.GA32558@elte.hu> <84144f020712220531x238da99bi19ff06aaddfc5fc3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020712220531x238da99bi19ff06aaddfc5fc3@mail.gmail.com>
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Ingo,
> 
> On Dec 22, 2007 3:14 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > Also please apply the cleanup patch below, it fixes 34 checkpatch errors
> > and warnings in mm/slub.c.
> 
> Those are already fixed in -mm:
> 
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc5/2.6.24-rc5-mm1/broken-out/slub-fix-coding-style-violations.patch
> http://www.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc5/2.6.24-rc5-mm1/broken-out/slub-fix-coding-style-violations-checkpatch-fixes.patch

ah, didnt see that. Could you pick up bits of my patch because it seems 
to do a better job, such as proper c99 initializer:

+static struct notifier_block __cpuinitdata slab_notifier = {
+       .notifier_call = slab_cpuup_callback
+};

instead of your:

+static struct notifier_block __cpuinitdata slab_notifier = {
+       &slab_cpuup_callback, NULL, 0
+};

also, my patch fixes all the warnings as well, not just the errors. So 
please give it a second look ;-)

	Ingo
