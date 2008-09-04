Return-Path: <linux-kernel-owner+w=401wt.eu-S1753927AbYIDQhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927AbYIDQhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 12:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751855AbYIDQhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 12:37:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59762 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbYIDQhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 12:37:02 -0400
Date: Thu, 4 Sep 2008 18:36:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Alok Kataria <akataria@vmware.com>,
       Arjan van de Veen <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC patch 0/4] TSC calibration improvements
Message-ID: <20080904163644.GA28340@elte.hu>
References: <20080904150339.896115280@linutronix.de> <20080904153620.GC7120@elte.hu> <alpine.LFD.1.10.0809040840330.3381@nehalem.linux-foundation.org> <20080904160036.GA18382@elte.hu> <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809040920000.3381@nehalem.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 4 Sep 2008, Ingo Molnar wrote:
> > 
> > ah - perhaps a dynamic statistical approach with an estimation of 
> > worst-case calibration error (~= standard deviation) and a quality 
> > threshold to reach? That could dramatically increase the number of 
> > samples while also making it much faster in practice. Nifty!
> 
> Oh, no, I'm _much_ more nifty than that!
> 
> Instead of being very clever, I have a very _stupid_ algorithm, one 
> that has very hardcoded expectations of exactly what it will see. And 
> if it doesn't see exactly that, it just fails early.
>
> I'd post the patch, but I really need to actually _test_ it first, and 
> I haven't rebooted yet.

ok, will wait with patience :)

i've been using adaptive calibration with great success in user-space, 
to run benchmarks on multiple boxes with a variable number of lmbench 
iterations. Once the observable statistical properties of the series of 
measurements looks valid it stops the test iterations and emits a 
result. This both makes things faster (more predictable hw/kernel 
executes certain lmbench tests much faster) and it makes the results 
more reliable (less noise, better cross-hardware, cross-kernel and 
cross-test comparisons). I've got a quality threshold (and a max 
iterations threshold) hardcoded as well.

	Ingo
