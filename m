Return-Path: <linux-kernel-owner+w=401wt.eu-S1755525AbYCUT6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525AbYCUT6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 15:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbYCUT6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 15:58:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37268 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbYCUT6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 15:58:23 -0400
Date: Fri, 21 Mar 2008 20:58:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3-mm1 - BUG at system shutdown time
Message-ID: <20080321195813.GC16179@elte.hu>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <10815.1204862325@turing-police.cc.vt.edu> <20080312003227.a94580e8.akpm@linux-foundation.org> <4351.1205374751@turing-police.cc.vt.edu> <20080321134128.GO27245@elte.hu> <3343.1206128318@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3343.1206128318@turing-police.cc.vt.edu>
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


* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:

> git-bisect good ad42b55d36238ebb9fa4d7a538ef691a76397c46
> # good: [56b412e63863ea82a5720315076c7dbd1d9888cd] x86: change x86 to use generic find_next_bit
> git-bisect good 56b412e63863ea82a5720315076c7dbd1d9888cd
> # good: [42de918f25dc9a49fb9688e22c2a3f2b156cc1bf] x86: prevent unconditional writes to DebugCtl MSR
> git-bisect good 42de918f25dc9a49fb9688e22c2a3f2b156cc1bf
> 
> At this point, 'git bisect visualize' shows 9 commits left to bisect 
> through, and all are dated 03/10 or later.  However, since 25-rc3-mm1 
> had the problem, it had to be something in-tree as of 03/05.
> 
> Is it possible that the problem code was in the git-x86 tree when 
> Andrew pulled for -rc3-mm1 and -rc5-mm1, but had been reverted by the 
> time I grabbed the tree, so the /x86/base' was in fact *good* by that 
> point?

no, we frequently regenerate the x86.git tree so the dates have little 
relevance. If for any particular pull, x86/base is good and x86/latest 
is bad, then the bug is somewhere in those 200-300 patches inbetween. 
They are lined up linearly so should be perfectly bisectable.

	Ingo
