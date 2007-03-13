Return-Path: <linux-kernel-owner+w=401wt.eu-S933063AbXCMLQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063AbXCMLQG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 07:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933073AbXCMLQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 07:16:06 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42454 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933063AbXCMLQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 07:16:03 -0400
Date: Tue, 13 Mar 2007 04:15:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: clameter@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 0/4] Arch independent quicklists V2
Message-Id: <20070313041551.565891b5.akpm@linux-foundation.org>
In-Reply-To: <45F685C6.8070806@yahoo.com.au>
References: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com>
	<20070313005334.853559ca.akpm@linux-foundation.org>
	<45F65ADA.9010501@yahoo.com.au>
	<20070313035250.f908a50e.akpm@linux-foundation.org>
	<45F685C6.8070806@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 13 Mar 2007 22:06:46 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> Andrew Morton wrote:
> >>On Tue, 13 Mar 2007 19:03:38 +1100 Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> ...
>
> >>Page allocator still requires interrupts to be disabled, which this doesn't.

> >>it is worthwhile.
> > 
> > 
> > If you want a zeroed page for pagecache and someone has just stuffed a
> > known-zero, cache-hot page into the pagetable quicklists, you have good
> > reason to be upset.
> 
> The thing is, pagetable pages are the one really good exception to the
> rule that we should keep cache hot and initialise-on-demand. They
> typically are fairly sparsely populated and sparsely accessed. Even
> for last level page tables, I think it is reasonable to assume they will
> usually be pretty cold.

eh?  I'd have thought that a pte page which has just gone through
zap_pte_range() will very often have a _lot_ of hot cachelines, and
that's a common case.

Still.   It's pretty easy to test.

> > 
> > Maybe, dunno.  It was apparently a win on powerpc many years ago.  I had a
> > fiddle with it 5-6 years ago on x86 using a cache-disabled mapping of the
> > page.  But it needed too much support in core VM to bother.  Since then
> > we've grown per-cpu page magazines and __GFP_ZERO.  Plus I'm not aware of
> > anyone having tried doing it on x86 with non-temporal stores.
> 
> You can win on specifically constructed benchmarks, easily.
> 
> But considering all the other problems you're going to introduce, we'd need
> a significant win on a significant something, IMO.
> 
> You waste memory bandwidth. You also use more CPU and memory cycles
> speculatively, ergo you waste more power.

Yeah, prezeroing in idle is probably pointless.  But I'm not aware of
anyone having tried it properly...
