Return-Path: <linux-kernel-owner+w=401wt.eu-S934712AbZFOVRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934712AbZFOVRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:17:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934947AbZFOVQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:16:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36186 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934719AbZFOVQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:16:40 -0400
Date: Mon, 15 Jun 2009 23:16:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615211605.GC27100@elte.hu>
References: <4A369508.2090707@zytor.com> <20090615184858.GD6520@Krystal> <1245091917.6741.185.camel@laptop> <20090615185907.GF6520@Krystal> <1245092561.6741.205.camel@laptop> <4A369CD8.3090505@zytor.com> <20090615192720.GA9056@Krystal> <4A36A1C7.6080005@zytor.com> <20090615210119.GD24554@elte.hu> <20090615211207.GB12919@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615211207.GB12919@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Just for the sake of making NMI handlers less tricky, supporting 
> page faults caused by faulting kernel instructions (rather than 
> only supporting explicit faulting from get_user_pages_inatomic) 
> would be rather nice design-wise if it only costs 2-3 cycles.
> 
> And I would not want to touch the page fault handler itself to 
> write the saved cr2 value before the handler exits, because this 
> would add a branch on a very hot path.

_That_ path is not hot at all - it's the 'we are in atomic section 
and faulted' rare path (laced with an exception table search - which 
is extremely slow compared to other bits of the pagefault path).

But ... it's not an issue: a check can be made in the NMI code too, 
as we always know about pagefaults there, by virtue of getting 
-EFAULT back from the attempted-user-copy.

	Ingo
