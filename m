Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbXCML1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbXCML1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 07:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbXCML1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 07:27:54 -0400
Received: from smtp.osdl.org ([65.172.181.24]:42740 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753235AbXCML1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 07:27:53 -0400
Date: Tue, 13 Mar 2007 04:27:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 0/4] Arch independent quicklists V2
Message-Id: <20070313042742.e35b7511.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703130413080.5720@schroedinger.engr.sgi.com>
References: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com>
	<20070313005334.853559ca.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0703130413080.5720@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 13 Mar 2007 04:17:26 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> On Tue, 13 Mar 2007, Andrew Morton wrote:
> 
> > > On Tue, 13 Mar 2007 00:13:25 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> > > Page table pages have the characteristics that they are typically zero
> > > or in a known state when they are freed.
> > 
> > Well if they're zero then perhaps they should be released to the page 
> > allocator to satisfy the next __GFP_ZERO request.  If that request is 
> > for a pagetable page, we break even (except we get to remove 
> > special-case code).  If that __GFP_ZERO allocation was or some 
> > application other than for a pagetable, we win.
> 
> Nope that wont work.
> 
> 1. We need to support other states of pages other than zeroed.

What does this mean?

> 2. Prezeroing does not make much sense if a large portion of the
>    page is being used. Performance is better if the whole page 
>    is zeroed directly before use.Prezeroing only makes sense for sparse
>    allocations like the page table pages.

This is not related to the above discussion.

> > (Will require some work in the page allocator)
> > (That work will open the path to using the idle thread to prezero pages)
> 
> I already tried that 3 years ago and there was *no* benefit for usual
> users of the a page allocator. The advantage exists only if a small
> portion of the page is used. F.e. For one cacheline there was a 4x 
> improvement. See lkml archives for prezeroing.

Unsurprised.  Were non-temporal stores tried?
