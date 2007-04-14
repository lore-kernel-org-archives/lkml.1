Return-Path: <linux-kernel-owner+w=401wt.eu-S1161010AbXDNGno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161010AbXDNGno (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 02:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161113AbXDNGno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 02:43:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46713 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161010AbXDNGno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 02:43:44 -0400
Date: Sat, 14 Apr 2007 08:43:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070414064334.GA19463@elte.hu>
References: <20070413202100.GA9957@elte.hu> <20070414020424.GB14544@wotan.suse.de> <20070414063254.GB14875@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070414063254.GB14875@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Nick noticed that upon fork we change parent->wait_runtime but we do 
> not requeue it within the rbtree.

this fix is not complete - because the child runqueue is locked here, 
not the parent's. I've fixed this properly in my tree and have uploaded 
a new sched-modular+cfs.patch. (the effects of the original bug are 
mostly harmless, the rbtree position gets corrected the first time the 
parent reschedules. The fix might improve heavy forker handling.)

	Ingo
