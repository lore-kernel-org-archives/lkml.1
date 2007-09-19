Return-Path: <linux-kernel-owner+w=401wt.eu-S1762869AbXISRiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762869AbXISRiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 13:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763005AbXISRgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 13:36:33 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52315 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763002AbXISRgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 13:36:32 -0400
Date: Wed, 19 Sep 2007 10:36:31 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [00/17] [RFC] Virtual Compound Page Support
In-Reply-To: <p73ejgvvz9l.fsf@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0709191033430.11138@schroedinger.engr.sgi.com>
References: <20070919033605.785839297@sgi.com> <p73ejgvvz9l.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Andi Kleen wrote:

> > 	alloc_page(GFP_VFALLBACK, order, ....)
> 
> Is there a reason this needs to be a GFP flag versus a wrapper
> around alloc_page/free_page ?  page_alloc.c is already too complicated
> and it's better to keep new features separated. The only drawback
> would be that free_pages would need a different call, but that
> doesn't seem like a big problem.

I tried to make this a wrapper but there is a lot of logic in 
__alloc_pages() that would have to be replicated. Also there are specific 
places in __alloc_pages() were we can establish that we have enough memory
but its the memory fragmentation that prevents us from satisfying the 
request for a larger page.
 
> I'm also a little dubious about your attempts to do vmalloc in
> interrupt context. Is that really needed? GFP_ATOMIC allocations of
> large areas seem to be extremly unreliable to me and not design. Even
> if it works sometimes free probably wouldn't work there due to the
> flushes, which is very nasty. It would be better to drop that.

The flushes are only done on virtuall mapped architectures (xtensa) and 
are simple ASM code that can run in an interrupt context
