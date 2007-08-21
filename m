Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbXHUU7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbXHUU7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbXHUU71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:59:27 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51573 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752794AbXHUU7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:59:25 -0400
Date: Tue, 21 Aug 2007 13:59:24 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Rik van Riel <riel@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dkegel@google.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC 0/7] Postphone reclaim laundry to write at high water marks
In-Reply-To: <46CB01B7.3050201@redhat.com>
Message-ID: <Pine.LNX.4.64.0708211355430.3082@schroedinger.engr.sgi.com>
References: <20070820215040.937296148@sgi.com> <46CB01B7.3050201@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2007, Rik van Riel wrote:

> Christoph Lameter wrote:
> 
> > 1. First reclaiming non dirty pages. Dirty pages are deferred until reclaim
> >    has reestablished the high marks. Then all the dirty pages (the laundry)
> >    is written out.
> 
> That sounds like a horrendously bad idea.  While one process
> is busy freeing all the non dirty pages, other processes can
> allocate those pages, leaving you with no memory to free up
> the dirty pages!

What is preventing that from occurring right now? If the dirty pags are 
aligned in the right way you can have the exact same situation.
 
> Also, writing out all the dirty pages at once seems like it
> could hurt latency quite badly, especially on large systems.

We only write back the dirty pages that we are about to reclaim not all of 
them. The bigger batching occurs if we go through multiple priorities. 
Plus writeback in the sync reclaim case is stopped if the device becomes 
contended anyways.

