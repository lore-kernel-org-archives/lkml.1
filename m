Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbXGGKZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbXGGKZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 06:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752734AbXGGKZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 06:25:18 -0400
Received: from ns2.suse.de ([195.135.220.15]:48731 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbXGGKZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 06:25:17 -0400
Date: Sat, 7 Jul 2007 12:25:02 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070707102502.GH29213@v2.random>
References: <20070706222651.GG5777@v2.random> <18063.14949.850984.791608@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18063.14949.850984.791608@cargo.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2007 at 05:01:57PM +1000, Paul Mackerras wrote:
> Andrea Arcangeli writes:
> 
> > So my whole idea is to once and for all to decuple the size of the
> > pte-entry (4k on x86/amd64) with the page allocator granularity. The
> > HARD_PAGE_SHIFT will be 4k still, the common code PAGE_SIZE will be
> > variable and configurable at compile time with CONFIG_PAGE_SHIFT.
> 
> How does the page cache work with your scheme?  For example if I have
> 1000 1kB files cached in the page cache, and 16k PAGE_SIZE, does that
> use up 4M, or 16M?

It uses 16M of course. Like I said before:

   This whole issue is really a pure tradeoff between memory consumption
   and I/O and CPU performance (and for the dvd-ram and xfs also a way to

The CONFIG_PAGE_SHIFT allows you to ship a "monster" kernel for db
usage with hundred gigs of ram, with 64k page size and 64k blocksize,
getting the whole advantages. We of course must make sure that
CONFIG_PAGE_SHIFT=12 doesn't provide any slowdown.

Then us mere mortals will enjoy running with 8k page size too, with
our 2-4G of ram. I used 8k page size with an alpha workstation back in
2000 and I didn't feel any substantial ram waste, I had about 2G of
ram. Ok, now the kernel is larger, but even git learnt using packs ;)
