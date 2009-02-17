Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbZBQBH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbZBQBH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 20:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbZBQBHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 20:07:14 -0500
Received: from mga12.intel.com ([143.182.124.36]:39462 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751156AbZBQBHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 20:07:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,219,1233561600"; 
   d="scan'208";a="111269715"
Subject: Re: [patch] SLQB slab allocator (try 2)
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mel Gorman <mel@csn.ul.ie>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <4999BBE6.2080003@cs.helsinki.fi>
References: <20090123154653.GA14517@wotan.suse.de>
	 <200902041748.41801.nickpiggin@yahoo.com.au>
	 <20090204152709.GA4799@csn.ul.ie>
	 <200902051459.30064.nickpiggin@yahoo.com.au>
	 <20090216184200.GA31264@csn.ul.ie>  <4999BBE6.2080003@cs.helsinki.fi>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 17 Feb 2009 09:06:55 +0800
Message-Id: <1234832815.2604.410.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-16 at 21:17 +0200, Pekka Enberg wrote:
> Hi Mel,
> 
> Mel Gorman wrote:
> > I haven't done much digging in here yet. Between the large page bug and
> > other patches in my inbox, I haven't had the chance yet but that doesn't
> > stop anyone else taking a look.
> 
> So how big does an improvement/regression have to be not to be 
> considered within noise? I mean, I randomly picked one of the results 
> ("x86-64 speccpu integer tests") and ran it through my "summarize" 
> script and got the following results:
> 
> 		min      max      mean     std_dev
>    slub		0.96     1.09     1.01     0.04
>    slub-min	0.95     1.10     1.00     0.04
>    slub-rvrt	0.90     1.08     0.99     0.05
>    slqb		0.96     1.07     1.00     0.04
> 
> Apart from slub-rvrt (which seems to be regressing, interesting) all the 
> allocators seem to perform equally well. Hmm?
I wonder if different compilation of kernel might cause different cache alignment
which has much impact on small result difference.

If a workload isn't slab-allocation intensive, perhaps the impact caused by different
compilation is a little bigger.


> 
> Btw, Yanmin, do you have access to the tests Mel is running (especially 
> the ones where slub-rvrt seems to do worse)?
As it takes a long time (more than 20 hours) to run cpu2006, I run cpu2000 instead
of cpu2006. Now, we are trying to integrate cpu2006 into testing infrastructure.
﻿Let me check it firstly.

>  Can you see this kind of 
> regression? The results make we wonder whether we should avoid reverting 
> all of the page allocator pass-through and just add a kmalloc cache for 
> 8K allocations. Or not address the netperf regression at all. Double-hmm.
> 
> 			Pekka

