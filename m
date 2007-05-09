Return-Path: <linux-kernel-owner+w=401wt.eu-S971238AbXEIAX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971238AbXEIAX1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 20:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968516AbXEIAXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 20:23:17 -0400
Received: from waste.org ([66.93.16.53]:49692 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S970261AbXEIAXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 20:23:16 -0400
Date: Tue, 8 May 2007 19:23:08 -0500
From: Matt Mackall <mpm@selenic.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, clameter@sgi.com
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch added to -mm tree
Message-ID: <20070509002307.GV11115@waste.org>
References: <200705082302.l48N2KrZ004229@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705082302.l48N2KrZ004229@shell0.pdx.osdl.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 04:02:20PM -0700, akpm@linux-foundation.org wrote:
>  	bool "SLOB (Simple Allocator)"
>  	help
>  	   SLOB replaces the SLAB allocator with a drastically simpler
>  	   allocator.  SLOB is more space efficient that SLAB but does not
> -	   scale well (single lock for all operations) and is more susceptible
> -	   to fragmentation. SLOB it is a great choice to reduce
> -	   memory usage and code size for embedded systems.
> +	   scale well (single lock for all operations) and is also highly
> +	   susceptible to fragmentation. SLUB can accomplish a higher object
> +	   density. It is usually better to use SLUB instead of SLOB.

This isn't accurate.

First, SLOB no longer runs on SMP because SLAB grew some RCU-related
hair. So it now effectively has no locks at all! 

Second, I think the fragmentation issues are exaggerated. Before SLAB
was introduced, Linux's kmalloc was the moral equivalent of SLOB
(without SLAB emulation) and fragmentation was not the driving force
for replacement. Small Linux 1.x machines frequently had uptimes of 1+
years without fragmenting to death. Instead, it was performance with
large amounts of RAM - the old kmalloc (and SLOB) have performance
proportional to memory size.

Third, I don't think it's possible even in theory for a SLAB-like
allocator to be as efficient as SLOB simply due to the constraints of
putting only objects of the same size on a given page. So consider me
skeptical on the density claim.

It is usually better to use SLUB simply because you're more likely to
have 1GB of RAM rather than 4MB.

-- 
Mathematics is the supreme nostalgia of our time.
