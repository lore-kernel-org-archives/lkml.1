Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbZDGLeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbZDGLeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 07:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbZDGLej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 07:34:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50113 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbZDGLei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 07:34:38 -0400
Subject: Re: [PATCH] intel-iommu: fix build with CONFIG_BRANCH_TRACER=y
From: David Woodhouse <dwmw2@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: torvalds@linux-foundation.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090407090229.GA2467@elte.hu>
References: <1238839639.3560.37.camel@macbook.infradead.org>
	 <20090407053739.GA10500@elte.hu>
	 <1239083045.22733.383.camel@macbook.infradead.org>
	 <20090407054818.GA5557@elte.hu> <20090407055245.GA10406@elte.hu>
	 <1239084280.22733.404.camel@macbook.infradead.org>
	 <20090407061558.GA31261@elte.hu> <20090407084950.GA1467@elte.hu>
	 <20090407090229.GA2467@elte.hu>
Content-Type: text/plain
Date: Tue, 07 Apr 2009 04:33:55 -0700
Message-Id: <1239104035.22733.443.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-07 at 11:02 +0200, Ingo Molnar wrote:
> for_each_active_iommu() and for_each_iommu() uses some tricky
> C that is weird and borderline valid but does not allow the
> macro evaluation trick used by the branch tracer/profiler:
> 
>    drivers/pci/intr_remapping.c:680:28: error: macro "if" passed 2
> arguments, but takes just 1
> 
> Switch it to a braced group statement.

It doesn't even need the braces -- just putting simple parens around the
comma-expression would have sufficed (that was Andrew's attempt).

But it's a workaround, not a fix -- if we're going to #define if() then
we should damn well make it transparent, and not have to work around
breakage in arbitrary places.

Hence the patch I sent to Linus last night, which fixes it in the
_right_ place:
	http://marc.info/?l=linux-kernel&m=123907505308502&w=2

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

