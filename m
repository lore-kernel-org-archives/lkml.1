Return-Path: <linux-kernel-owner+w=401wt.eu-S1161081AbXAZQ7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161081AbXAZQ7B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:59:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161082AbXAZQ66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:58:58 -0500
Received: from calculon.skynet.ie ([193.1.99.88]:40430 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161050AbXAZQ6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:58:43 -0500
Date: Fri, 26 Jan 2007 16:58:40 +0000 (GMT)
From: Mel Gorman <mel@csn.ul.ie>
X-X-Sender: mel@skynet.skynet.ie
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] Allow huge page allocations to use GFP_HIGH_MOVABLE
In-Reply-To: <Pine.LNX.4.64.0701260832260.6141@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0701261649040.23091@skynet.skynet.ie>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
 <20070125234558.28809.21103.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0701260832260.6141@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Christoph Lameter wrote:

> Unmovable allocations in the movable zone. Yuck.

I know, but my objective at this time is to allow the hugepage pool to be 
resized at runtime for situations where the number of required hugepages 
is not known in advance. Having a zone for movable pages allows that to 
happen. Also, it's possible that migration of hugepages will be supported 
at some time in the future. That's a more reasonable possibility than 
moving kernel memory.

> Why dont you abandon the
> whole concept of statically sized movable zone and go back to the nice
> earlier idea of dynamically assigning MAX_ORDER chunks to be movable or not?
>

Because Andrew has made it pretty clear he will not take those patches on 
the grounds of complexity - at least until it can be shown that they fix 
the e1000 problem. Any improvement on the behavior of those patches such 
as address biasing to allow memory hot-remove of the higher addresses 
makes them even more complex.

Also, almost every time the anti-frag patches are posted, someone suggests 
that zones be used instead. I wanted to show what those patches look like.
(of course, every time I post the zone approach, someone suggests I go 
back the other way)

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
