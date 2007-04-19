Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbXDSWu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbXDSWu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 18:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbXDSWu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 18:50:28 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46217 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754285AbXDSWu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 18:50:27 -0400
Date: Fri, 20 Apr 2007 08:50:12 +1000
From: David Chinner <dgc@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Adam Litke <aglitke@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 4/8] Enhance fallback functions in libs to support higher order pages
Message-ID: <20070419225011.GK32602149@melbourne.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com> <20070419163525.11948.3482.sendpatchset@schroedinger.engr.sgi.com> <a0a62dfc0704191148v15434469kc3130821cb251072@mail.gmail.com> <Pine.LNX.4.64.0704191208340.12936@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704191208340.12936@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 12:10:34PM -0700, Christoph Lameter wrote:
> Variable Order Page Cache: Add functions to establish sizes
> 
> We use the macros PAGE_CACHE_SIZE PAGE_CACHE_SHIFT PAGE_CACHE_MASK
> and PAGE_CACHE_ALIGN in various places in the kernel. These are now
> the base page size but we do not have a means to calculating these
> values for higher order pages.
> 
> Provide these functions. An address_space pointer must be passed
> to them.
> 
> New function			Related base page constant
> ---------------------------------------------------
> page_cache_shift(a)		PAGE_CACHE_SHIFT
> page_cache_size(a)		PAGE_CACHE_SIZE
> page_cache_mask(a)		PAGE_CACHE_MASK
> page_cache_align(addr,a)	PAGE_CACHE_ALIGN(addr)

I think PAGE_CACHE_SIZE is a redundant define with these
modifications.  The page cache size in now variable and it is based
on a multiple of PAGE_SIZE. Hence I suggest that PAGE_CACHE_SIZE and
it's derivitives should be made to go away completely with this
change.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
