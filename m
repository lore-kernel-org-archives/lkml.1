Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbXFNTz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbXFNTz5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 15:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbXFNTzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 15:55:46 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60069 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755933AbXFNTzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 15:55:44 -0400
Date: Thu, 14 Jun 2007 21:56:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 01/14] Define functions for page cache handling
Message-ID: <20070614195646.GB2258@uranus.ravnborg.org>
References: <20070614193839.878721298@sgi.com> <20070614194052.663061482@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614194052.663061482@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 12:38:40PM -0700, clameter@sgi.com wrote:
> We use the macros PAGE_CACHE_SIZE PAGE_CACHE_SHIFT PAGE_CACHE_MASK
> and PAGE_CACHE_ALIGN in various places in the kernel. Many times
> common operations like calculating the offset or the index are coded
> using shifts and adds. This patch provides inline function to
> get the calculations accomplished in a consistent way.
> 
> All functions take an address_space pointer. The address space pointer
> will be used in the future to eventually support a variable size
> page cache. Information reachable via the mapping may then determine
> page size.
> 
> New function			Related base page constant
> ---------------------------------------------------
> page_cache_shift(a)		PAGE_CACHE_SHIFT
> page_cache_size(a)		PAGE_CACHE_SIZE
> page_cache_mask(a)		PAGE_CACHE_MASK
> page_cache_index(a, pos)	Calculate page number from position
> page_cache_next(addr, pos)	Page number of next page
> page_cache_offset(a, pos)	Calculate offset into a page
> page_cache_pos(a, index, offset)
> 				Form position based on page number
> 				and an offset.
> 
> This provides a basis that would allow the conversion of all page cache
> handling in the kernel and ultimately allow the removal of the PAGE_CACHE_*
> constants.

We need access to PAGE_SIZE in vmlinux.lds.h.
What is your plan with that usage?

	Sam
