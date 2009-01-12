Return-Path: <linux-kernel-owner+w=401wt.eu-S1761586AbZALWzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761586AbZALWzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756416AbZALWuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:50:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46625 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762865AbZALWuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:50:52 -0500
Date: Mon, 12 Jan 2009 23:50:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Frederik Deweerdt <frederik.deweerdt@xprog.eu>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
Message-ID: <20090112225041.GA18220@elte.hu>
References: <20090112213539.GA10720@gambetta> <20090112215701.GH23848@one.firstfloor.org> <20090112221023.GB10720@gambetta> <20090112223220.GK23848@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112223220.GK23848@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > It is also slower (or so percpu.h says), and confusing I'd say.
> 
> Well it's something like 3 instructions versus one. [...]

That's enough - micro-optimizations are done like that, instruction by 
instruction.

> [...] You would have a hard time benchmarking it unless you run it in a 
> very tight loop. It will be lost in the noise compared to all the other 
> costs of the IPI.
> 
> Also why i don't like this patch is that on the typical small 
> single/dual core system running a 128 byte cache line distro kernel you 
> always pay the 1K cost now, while with per cpu it only needed one/two 
> entries.

4 or 8 cores is the norm these days - by the time this change hits real 
Linux computers en masse 8 cores will be quite common.

> Admittedly it could have been better commented.
> 
> Not that it matters now unfortunately it's already applied. Sometimes 
> wonder why I still bother to do patch review...

Whether patches are already applied or not has no relevance - patches can 
still be undone or reverted of course, should your review feedback be 
correct.

	Ingo
