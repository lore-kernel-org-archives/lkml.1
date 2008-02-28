Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbYB1IPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbYB1IPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 03:15:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYB1IPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 03:15:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53551 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbYB1IPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 03:15:02 -0500
Date: Thu, 28 Feb 2008 09:14:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: Linux 2.6.25-rc2
Message-ID: <20080228081412.GE28781@elte.hu>
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org> <64bb37e0802161338j306c1357m25bc224f09e6b7cd@mail.gmail.com> <20080219061107.GA23229@elte.hu> <64bb37e0802182254l49b10cbblc23f8a83d189ff8e@mail.gmail.com> <84144f020802182321x452888bai639c71ea2a5067da@mail.gmail.com> <20080219140230.GA32236@Krystal> <84144f020802190621s509dbe7gc8e5609d94aca9b4@mail.gmail.com> <20080219200852.GC11197@Krystal> <Pine.LNX.4.64.0802271532220.14380@schroedinger.engr.sgi.com> <20080227175726.ad6bda9d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080227175726.ad6bda9d.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > > incrementing the variable with a "++" when interrupts are not 
> > > disabled. It's not an atomic add and it's racy. The code within 
> > > stat() does exactly this.
> > 
> > Yes but that is only for used for statistics which can be racy. Note 
> > that the VM event statistics also can be racy.
> 
> Doing ++ on a u32 _is_ atomic wrt interrupts on x86 and probably lots 
> of other architectures, so we're OK using unsigned there. [...]

hm, why should it be atomic wrt. irqs? There's nothing that keeps gcc 
from not doing an "incl memory_address" but do something like: "load 
memory address into regx, incl regx, ... store address into memory 
address" - and that's not atomic at that point.

	Ingo
