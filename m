Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZDGMpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZDGMpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:45:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZDGMpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:45:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47363 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZDGMpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:45:04 -0400
Subject: Re: [PATCH] intel-iommu: fix build with CONFIG_BRANCH_TRACER=y
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090407121457.GC11641@elte.hu>
References: <1238839639.3560.37.camel@macbook.infradead.org>
	 <20090407053739.GA10500@elte.hu>
	 <1239083045.22733.383.camel@macbook.infradead.org>
	 <20090407054818.GA5557@elte.hu> <20090407055245.GA10406@elte.hu>
	 <1239084280.22733.404.camel@macbook.infradead.org>
	 <20090407061558.GA31261@elte.hu> <20090407084950.GA1467@elte.hu>
	 <20090407090229.GA2467@elte.hu>
	 <1239104035.22733.443.camel@macbook.infradead.org>
	 <20090407121457.GC11641@elte.hu>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 05:44:23 -0700
Message-Id: <1239108263.22733.492.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 14:14 +0200, Ingo Molnar wrote:
> Well, i consider it a feature that it flags weird if (x, y) 
> constructs: and yes, these iterators you introduced, while they are 
> legit C, definitely count as 'weird'. If regular code was doing it, 
> not a loop abstraction, i'd call it non-obvious and borderline 
> broken straight away.
> 
> We should _never ever_ put comma statements into if () constructs 
> without a _really_ good reason - and if yes, we can flag that we 
> know what we are doing, via extra parentheses.

I disagree. I don't think we should be declaring valid C syntax as 'off
limits', however rare it is.

_Especially_ if it only actually fails with a fairly esoteric config
option set. That's just asking for build breakage.

> and if yes, we can flag that we know what we are doing, via extra 
> parentheses.

That's hardly much of a barrier. The requirement to sprinkle
gratuitous-looking extra parentheses around the place really isn't going
to give us much of a _benefit_ in return for the build breakage.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

