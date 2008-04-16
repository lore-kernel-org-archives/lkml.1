Return-Path: <linux-kernel-owner+w=401wt.eu-S1757799AbYDPASn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbYDPASn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 20:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbYDPASg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 20:18:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44257 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbYDPASg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 20:18:36 -0400
Date: Wed, 16 Apr 2008 02:18:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Yinghai.Lu@sun.com, apw@shadowen.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [patch] mm: sparsemem memory_present() memory corruption fix
Message-ID: <20080416001816.GA26295@elte.hu>
References: <20080415161532.GA15088@elte.hu> <alpine.LFD.1.00.0804151010500.2879@woody.linux-foundation.org> <Pine.LNX.4.64.0804151232080.1785@schroedinger.engr.sgi.com> <20080415195430.GA23015@elte.hu> <Pine.LNX.4.64.0804151255390.1785@schroedinger.engr.sgi.com> <20080415201734.GA25628@elte.hu> <4805115D.5030703@cs.helsinki.fi> <20080415204025.GA29784@elte.hu> <alpine.LFD.1.00.0804151353380.2879@woody.linux-foundation.org> <20080416000356.GA24737@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416000356.GA24737@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> finally found it ... the patch below solves the sparsemem crash and 
> the testsystem boots up fine now:
> 
>   mars:~> uname -a
>   Linux mars 2.6.25-rc9-sched-devel.git-x86-latest.git #985 SMP Wed Apr 16 
>   01:37:37 CEST 2008 i686 i686 i386 GNU/Linux

i re-checked the original SLAB config too and that boots fine as well 
now - so i'm confident that the regression has been sufficiently cured.

it's getting quite late here (or rather, it's getting early :-/ ) so it 
would be nice if others could double-check this calculation (with an eye 
on all possible architectures):

+       unsigned long max_arch_pfn = 1ULL << (MAX_PHYSMEM_BITS-PAGE_SHIFT);

and also check my analysis whether it is correct and whether it matches 
the reported bug patterns. But otherwise the fix looks like a safe fix 
for v2.6.25-final to me - it only filters out values from sparsemem 
input that are nonsensical in the sparsemem framework anyway.

	Ingo
