Return-Path: <linux-kernel-owner+w=401wt.eu-S1764832AbYFFIYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764832AbYFFIYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764408AbYFFIXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:23:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47476 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758583AbYFFIXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:23:44 -0400
Date: Fri, 6 Jun 2008 10:23:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: linux-next: Tree for June 5
Message-ID: <20080606082325.GA10826@elte.hu>
References: <20080605175217.cee497f3.sfr@canb.auug.org.au> <20080605195604.41623687.akpm@linux-foundation.org> <20080606071707.GB9708@elte.hu> <20080606072536.GA19334@elte.hu> <20080606003327.9ac0e91b.akpm@linux-foundation.org> <20080606074137.GA28962@elte.hu> <20080606004743.a78180c3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606004743.a78180c3.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > > > i just successfully booted your config on 4 separate 64-bit 
> > > > test-systems with latest -tip. (two dual-core boxes, a quad and a 
> > > > 16way box) Latest -tip includes sched-next and x86-next as well.
> > > 
> > > What's the point in testing a radically differenet kernel from the one 
> > > which is known to be crashing?
> > 
> > well, you Cc:-ed me, so i wanted to exclude -tip's 750+ commits in this 
> > area (scheduling, 64-bit x86) in the first step.
> 
> What's the relationship between -tip and linux-next?

most of the -tip topics (there are 75 of them currently) are present in 
linux-next - about ~70% of all -tip commits are in linux-next already. 
The stuff that is not in linux-next yet is either because it's: 
miscellany fixes (i.e. intentionally grabbed out-of-tree to make our 
tests work better), not cooked enough yet, or because we are still 
working it out - tip is less than a month old still.

in general the rule is that if there's anything we want to push 
upstream, it will show up in linux-next.

> The crash seems to be due to sched_domains startup ordering, at a guess.
> 
> My third bisect iteration has hit this:
> 
> arch/x86/mm/kmmio.c: In function 'get_kmmio_probe':
> arch/x86/mm/kmmio.c:85: error: implicit declaration of function 'list_for_each_entry_rcu'
> arch/x86/mm/kmmio.c:85: error: 'list' undeclared (first use in this function)

hm, which commit is this exactly? I've never hit it myself in bisection 
(and there are days when i bisect -tip several times). We'll respin 
tip/tracing/mmiotrace if it's bisection-hostile. You can probably nudge 
it into building via "git-bisect next".

	Ingo
