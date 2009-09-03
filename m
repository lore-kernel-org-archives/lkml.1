Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbZICIqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbZICIqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 04:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbZICIqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 04:46:37 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:41575 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbZICIqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 04:46:36 -0400
X-SourceIP: 213.93.53.227
Subject: RE: [RFC PATCH] Add TRACE_IRQFLAGS_SUPPORT, LOCKDEP_SUPPORT then
 enable ftrace for ia64
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Luming Yu <luming.yu@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "Yu, Fenghua" <fenghua.yu@intel.com>, Felix Blyakher <felixb@sgi.com>,
       "Li, Shaohua" <shaohua.li@intel.com>, Bob Picco <bob.picco@hp.com>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA3E038DE7E@orsmsx505.amr.corp.intel.com>
References: <3877989d0908272018va6ee8f7n7ab2838fdf1b26e6@mail.gmail.com>
	 <20090828062212.GB11552@elte.hu>
	 <57C9024A16AD2D4C97DC78E552063EA3E038DE7E@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain
Date: Thu, 03 Sep 2009 10:46:30 +0200
Message-Id: <1251967590.7447.0.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-02 at 16:27 -0700, Luck, Tony wrote:
> >> diff -BruN linux-2.6.31-rc6/arch/ia64/include/asm/page.h
> >> linux-2.6.31-rc6-lockdep/arch/ia64/include/asm/page.h
> >> --- linux-2.6.31-rc6/arch/ia64/include/asm/page.h	2009-08-13
> >> 15:43:34.000000000 -0700
> >> +++ linux-2.6.31-rc6-lockdep/arch/ia64/include/asm/page.h	2009-08-23
> >> 18:59:00.000000000 -0700
> >> @@ -41,7 +41,7 @@
> >>  #define PAGE_SIZE		(__IA64_UL_CONST(1) << PAGE_SHIFT)
> >>  #define PAGE_MASK		(~(PAGE_SIZE - 1))
> >> 
> >> -#define PERCPU_PAGE_SHIFT	16	/* log2() of max. size of per-CPU area */
> >> +#define PERCPU_PAGE_SHIFT	20	/*16 log2() of max. size of per-CPU area */
> >>  #define PERCPU_PAGE_SIZE	(__IA64_UL_CONST(1) << PERCPU_PAGE_SHIFT)
> >
> > Why was this seemingly unrelated change done in a lockdep patch?
> 
> IIRC it is because the lockdep code needs a lot more percpu memory than the
> 64K that ia64 allocates.
> 
> But I think that I'd prefer to only allocate the extra space when it
> is needed:
> 
> #ifdef CONFIG_LOCKDEP
> #define PERCPU_PAGE_SHIFT 20 /* Need a Megabyte for lockdep */
> #else
> #define PERCPU_PAGE_SHIFT 16 /* 64K should be enough for normal use */
> #endif

Hmm, isn't all that percpu stuff in a special section, who's size you
can query at boot time and set-up accordingly?



