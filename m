Return-Path: <linux-kernel-owner+w=401wt.eu-S1030463AbXCGI2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030463AbXCGI2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 03:28:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965144AbXCGI2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 03:28:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38963 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030463AbXCGI2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 03:28:34 -0500
Date: Wed, 7 Mar 2007 09:27:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch 4/6] mm: merge populate and nopage into fault (fixes nonlinear)
Message-ID: <20070307082755.GA25733@elte.hu>
References: <20070221023656.6306.246.sendpatchset@linux.site> <20070221023735.6306.83373.sendpatchset@linux.site> <20070306225101.f393632c.akpm@linux-foundation.org> <20070307070853.GB15877@wotan.suse.de> <20070307081948.GA9563@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070307081948.GA9563@wotan.suse.de>
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


* Nick Piggin <npiggin@suse.de> wrote:

> If it doesn't look very impressive, it could be because it leaves all 
> the old crud around for backwards compatibility (the worst offenders 
> are removed in patch 6/6).
> 
> If you look at the patchset as a whole, it removes about 250 lines, 
> mostly of (non trivial) duplicated code in filemap.c memory.c shmem.c 
> fremap.c, that is nonlinear pages specific and doesn't get anywhere 
> near the testing that the linear fault path does.
> 
> A minimal fix for nonlinear pages would have required changing all 
> ->populate handlers, which I simply thought was not very productive 
> considering the testing and coverage issues, and that I was going to 
> rewrite the nonlinear path anyway.
> 
> If you like, you can consider patches 1,2,3 as the fix, and ignore 
> nonlinear (hey, it doesn't even bother checking truncate_count 
> today!).
> 
> Then 4,5,6 is the fault/nonlinear rewrite, take it or leave it. I 
> thought you would have liked the patches...

btw., if we decide that nonlinear isnt worth the continuing maintainance 
pain, we could internally implement/emulate sys_remap_file_pages() via a 
call to mremap() and essentially deprecate it, without breaking the ABI 
- and remove all the nonlinear code. (This would split fremap areas into 
separate vmas)

	Ingo
