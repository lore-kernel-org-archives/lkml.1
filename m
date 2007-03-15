Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbXCOU2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbXCOU2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbXCOU2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:28:38 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49851 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751962AbXCOU2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:28:37 -0400
Date: Thu, 15 Mar 2007 13:28:36 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 0/4] Arch independent quicklists V2
In-Reply-To: <20070313042742.e35b7511.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703151324150.27311@schroedinger.engr.sgi.com>
References: <20070313071325.4920.82870.sendpatchset@schroedinger.engr.sgi.com>
 <20070313005334.853559ca.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703130413080.5720@schroedinger.engr.sgi.com>
 <20070313042742.e35b7511.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007, Andrew Morton wrote:

> > 1. We need to support other states of pages other than zeroed.
> 
> What does this mean?

pgd are not completely zeroed. They contain mappings that are always 
present. Thus the state is not a zeroed state.

> > 2. Prezeroing does not make much sense if a large portion of the
> >    page is being used. Performance is better if the whole page 
> >    is zeroed directly before use.Prezeroing only makes sense for sparse
> >    allocations like the page table pages.
> 
> This is not related to the above discussion.

Really? I definitely see the word prezeroing in the discussion.

> > I already tried that 3 years ago and there was *no* benefit for usual
> > users of the a page allocator. The advantage exists only if a small
> > portion of the page is used. F.e. For one cacheline there was a 4x 
> > improvement. See lkml archives for prezeroing.
> 
> Unsurprised.  Were non-temporal stores tried?

Yes with no material change. The work lead to making ia64 use non 
temporal stores for spin unlock but it was not useful for prezeroing.

