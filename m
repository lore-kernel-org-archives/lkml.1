Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbZF0Lou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbZF0Lou (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 07:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbZF0Lom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 07:44:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:60937 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbZF0Lok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 07:44:40 -0400
Subject: Re: [PATCH v2] IA64 Compilation Error Fix for Intel IOMMU Identity
 Mapping Support
From: David Woodhouse <dwmw2@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Wright <chrisw@redhat.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, fenghua.yu@intel.com,
       akpm@linux-foundation.org, tony.luck@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       linux-ia64@vger.kernel.org
In-Reply-To: <alpine.LFD.2.01.0906251858540.3605@localhost.localdomain>
References: <20090625003841.GA12226@linux-os.sc.intel.com>
	 <20090625095643F.fujita.tomonori@lab.ntt.co.jp>
	 <20090625041605.GA9330@linux-os.sc.intel.com>
	 <20090625134827W.fujita.tomonori@lab.ntt.co.jp>
	 <1245913886.17089.91.camel@macbook.infradead.org>
	 <1245966743.30355.42.camel@macbook.infradead.org>
	 <20090625234342.GD28176@x200.localdomain>
	 <alpine.LFD.2.01.0906251835060.3605@localhost.localdomain>
	 <20090626015205.GE28176@x200.localdomain>
	 <alpine.LFD.2.01.0906251858540.3605@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 27 Jun 2009 12:44:09 +0100
Message-Id: <1246103049.663.437.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 19:00 -0700, Linus Torvalds wrote:
> 
> On Thu, 25 Jun 2009, Chris Wright wrote:
> > I tested it on x86; works fine and creates a slightly tighter set of page
> > tables (matching to e820).  But I don't have an IA-64 box w/ an IOMMU.
> > 
> > It does have one problem, however, the graphics work around code isn't
> > compiled in on IA-64, so it needs:
> 
> Ok. Sounds like what I want is to get this patch through the ia64 people, 
> after it has gotten some testing there. Since ia64 is where the current 
> kernel fails anyway, that sounds like the motivation will be there too.
> 
> And there's little point in me merging it until it's been tested to fix 
> the actual problem we have now.

Well, the main problem is that the kernel doesn't build -- and it _has_
been tested to fix that.

As long as the daily linux-next test builds work, nobody really seems to
_care_ about VT-d on IA64 -- certainly not enough to get me a box when
they asked me to become VT-d maintainer.

Now that I chase it up, I've received only one test report and that was
"oh, even 2.6.29 doesn't boot on this box with VT-d enabled".

The patch _does_ fix the build breakage, definitely seems to be doing
the right thing, and the worst case is that the new feature doesn't work
on IA64. So I think we should merge it.

I'll bash some heads together and try to get myself some hardware so I
can actually test it on IA64 -- it looks like we have more problems
there than the small possibility that the new passthrough feature might
do the wrong thing (and in fact I suspect all IA64 VT-d hardware is new
enough to have the _hardware_ passthrough anyway, so won't need this
identity mapping set up at all).

Please pull Chris's fix from
	git://git.infradead.org/iommu-2.6.git

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

