Return-Path: <linux-kernel-owner+w=401wt.eu-S2993272AbXDTQCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993272AbXDTQCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767144AbXDTQBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:01:15 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56841 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767146AbXDTQBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:01:06 -0400
Date: Fri, 20 Apr 2007 09:01:04 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: Adam Litke <aglitke@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 4/8] Enhance fallback functions in libs to support higher
  order pages
In-Reply-To: <20070420082129.GI6525@kernel.dk>
Message-ID: <Pine.LNX.4.64.0704200900060.20068@schroedinger.engr.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
 <20070419163525.11948.3482.sendpatchset@schroedinger.engr.sgi.com>
 <a0a62dfc0704191148v15434469kc3130821cb251072@mail.gmail.com>
 <Pine.LNX.4.64.0704191208340.12936@schroedinger.engr.sgi.com>
 <20070420082129.GI6525@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Jens Axboe wrote:

> This works fine as long as you are in the submitter context, but once
> you pass the into the block layer, we don't have any way to find the
> address space (at least we don't want to). Would something like this be
> workable, name withstanding:
> 
> static unsigned long page_size(struct page *page)
> {
>         struct address_space *mapping;
>         int order = 0;
> 
>         mapping = page_mapping(page);
>         if (mapping)
>                 order = mapping->order;
> 
>         return PAGE_CACHE_SIZE << order;
> }

There is much simpler solution (possible with mm)

PAGE_SIZE << compound_order(page)

compound_order will return 0 for a non compound page.

