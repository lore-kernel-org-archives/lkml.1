Return-Path: <linux-kernel-owner+w=401wt.eu-S967387AbXIKUVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967387AbXIKUVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934242AbXIKUTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:19:34 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58414 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934164AbXIKUTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:19:31 -0400
Date: Tue, 11 Sep 2007 13:19:30 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Mel Gorman <mel@skynet.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: tbench regression - Why process scheduler has impact on tbench
 and why small per-cpu slab (SLUB) cache creates the scenario?
In-Reply-To: <200709110117.57387.nickpiggin@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0709111314190.25781@schroedinger.engr.sgi.com>
References: <1188953218.26438.34.camel@ymzhang> <200709100810.46341.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709101201140.24491@schroedinger.engr.sgi.com>
 <200709110117.57387.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007, Nick Piggin wrote:

> The impression I got at vm meeting was that SLUB was good to go :(

Its not? I have had Intel test this thoroughly and they assured me that it 
is up to SLAB. This particular case is an synthetic tests for a PAGE_SIZE 
alloc and SLUB was not optimized for that case because PAGE_SIZEd 
allocations should be handled by the page allocators. Quicklists were 
introduced for the explicit purpose to get these messy page sized cases 
out of the slab allocators.

> But slab allocations don't really control the macro behaviour of a
> benchmark like that so much. So don't wait until something happens
> with the scheduler, fix it now.

Ok so you are for pushing in the page allocator pass through patch from mm 
into rc6? Isnt it a bit late for such a change? I would think that 2.6.24
is early enough.
