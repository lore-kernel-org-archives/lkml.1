Return-Path: <linux-kernel-owner+w=401wt.eu-S1763174AbZALWxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763174AbZALWxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760198AbZALWku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:40:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48553 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761296AbZALWks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:40:48 -0500
Date: Mon, 12 Jan 2009 23:40:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Frederik Deweerdt <frederik.deweerdt@xprog.eu>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
Message-ID: <20090112224037.GA16585@elte.hu>
References: <20090112213539.GA10720@gambetta> <20090112215701.GH23848@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112215701.GH23848@one.firstfloor.org>
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

> On Mon, Jan 12, 2009 at 10:35:42PM +0100, Frederik Deweerdt wrote:
> > Hi,
> > 
> > On x86_64 flush tlb data is stored in per_cpu variables. This is
> > unnecessary because only the first NUM_INVALIDATE_TLB_VECTORS entries
> > are accessed.
> >
> > This patch aims at making the code less confusing (there's nothing 
> > really "per_cpu") by using a plain array. It also would save some 
> > memory on most distros out there (Ubuntu x86_64 has NR_CPUS=64 by 
> > default).
> 
> Nope it doesn't save memory on most systems because per cpu is only 
> allocated based on the CPUs that are actually there. And if you have 
> more than 8 cores you can likely afford a few bytes per CPU.

No distro kernel will build with less than 8 CPUs anyway so this point is 
moot.

> You would need to cache line pad each entry then, otherwise you risk 
> false sharing. [...]

They are already cache line padded.

> [...] That would make the array 1K on 128 bytes cache line system.

512 bytes.

> [...]  This means on small systems this would actually waste much more 
> memory.

Really small systems will be UP and wont do cross-CPU TLB flushes, so if 
they are a worry the flush code can be UP optimized. (Nobody bothered so 
far.)

	Ingo
