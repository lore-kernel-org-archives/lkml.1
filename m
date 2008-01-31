Return-Path: <linux-kernel-owner+w=401wt.eu-S932707AbYAaQP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707AbYAaQP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbYAaQPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:15:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38326 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763894AbYAaQPp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:15:45 -0500
Date: Thu, 31 Jan 2008 17:15:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 arch updates for v2.6.25
Message-ID: <20080131161523.GA12347@elte.hu>
References: <20080130011550.GA31853@elte.hu> <20080131155739.GA19700@cs181133002.pp.htv.fi> <20080131160033.GA11501@elte.hu> <20080131161235.GB19700@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131161235.GB19700@cs181133002.pp.htv.fi>
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


* Adrian Bunk <bunk@kernel.org> wrote:

> On Thu, Jan 31, 2008 at 05:00:33PM +0100, Ingo Molnar wrote:
> > 
> > * Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > You tested x86 but broke more than half a dozen other archtectures, 
> > > with at least 3 different commits breaking other architectures.
> > 
> > Note that all known breakages are fixed in current -git, except for the 
> > s390 problem that Martin/Nick posted the fix.
> 
> What about the breakages caused by commit 
> a5a19c63f4e55e32dc0bc3d936d7f94793d8b380 (this commit broke the 
> defconfig compilation on at least avr32, blackfin, sh, sparc and uml)?

the patch below fixes that.

	Ingo

---
 include/asm-generic/tlb.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux/include/asm-generic/tlb.h
===================================================================
--- linux.orig/include/asm-generic/tlb.h
+++ linux/include/asm-generic/tlb.h
@@ -15,6 +15,7 @@
 
 #include <linux/swap.h>
 #include <linux/quicklist.h>
+#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
 /*
