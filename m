Return-Path: <linux-kernel-owner+w=401wt.eu-S1764719AbYFFI1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764719AbYFFI1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYFFI1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:27:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58906 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586AbYFFI1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:27:41 -0400
Date: Fri, 6 Jun 2008 10:27:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: linux-next: Tree for June 5
Message-ID: <20080606082710.GB10826@elte.hu>
References: <20080605175217.cee497f3.sfr@canb.auug.org.au> <20080605195604.41623687.akpm@linux-foundation.org> <20080606071707.GB9708@elte.hu> <20080606072536.GA19334@elte.hu> <20080606003327.9ac0e91b.akpm@linux-foundation.org> <20080606074137.GA28962@elte.hu> <20080606004743.a78180c3.akpm@linux-foundation.org> <20080606175358.a439d1bb.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606175358.a439d1bb.sfr@canb.auug.org.au>
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


* Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> > arch/x86/mm/kmmio.c: In function 'get_kmmio_probe':
> > arch/x86/mm/kmmio.c:85: error: implicit declaration of function 'list_for_each_entry_rcu'
> 
> You need the following patch from linux-next.  Which should be the commit
> immediately after the merge of the ftrace tree.
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
> 
> >From ee19aa543ada9ce11a0b3b8480f3a268ff86cb02 Mon Sep 17 00:00:00 2001
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 27 May 2008 12:53:04 +1000
> Subject: [PATCH] ftrace: fix rculist split fallout

ah, that one - that's in the tip/tracing/mmiotrace-mergefixups branch. 
ideally this should be embedded in the merge commit of 
tip/core/rcu+tip/auto-ftrace-next [so that no bisection can ever hit the 
combined trees without also getting the merge fixup], but havent found a 
good Git way of doing that yet.

	Ingo

----------->
commit 668a6c3654560aef8741642478973e205a4f02bf
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon May 19 13:35:24 2008 +0200

    - fix mmioftrace + rcu merge interaction
    
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index b65871e..93d8203 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/list.h>
+#include <linux/rculist.h>
 #include <linux/spinlock.h>
 #include <linux/hash.h>
 #include <linux/init.h>
