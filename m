Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbYHUQ5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbYHUQ5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 12:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYHUQ5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 12:57:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50844 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYHUQ5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 12:57:36 -0400
Date: Thu, 21 Aug 2008 17:56:48 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, hsweeten@visionengravers.com,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Skip memory holes in FLATMEM when reading /proc/pagetypeinfo (resend)
Message-ID: <20080821165648.GF22837@flint.arm.linux.org.uk>
References: <20080821132804.GA6206@csn.ul.ie> <20080821093400.fe02a76f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821093400.fe02a76f.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 09:34:00AM -0700, Andrew Morton wrote:
> On Thu, 21 Aug 2008 14:28:05 +0100 Mel Gorman <mel@csn.ul.ie> wrote:
> > This patch lets architectures say when FLATMEM can have holes in the
> > memmap. Rather than an expensive check for valid memory, /proc/pagetypeinfo
> > will confirm that the page linkages are still valid by checking page->zone
> > is still the expected zone. The lookup of page_zone is safe as there is a
> > limited range of memory that is accessed when calling page_zone.  Even if
> > page_zone happens to return the correct zone, the impact is that the counters
> > in /proc/pagetypeinfo are slightly off but fragmentation monitoring is
> > unlikely to be relevant on an embedded system.
> 
> Sounds like this might fix an oops.  Does it?
> 
> The patch applies to 2.6.25 and to 2.6.26.  Should it be backported?

The only concern there is with this patch is that we're still walking
over the memory, which could contain anything.  We could be unlucky
and end up with page_zone(page) == zone.

It'll do as a stop gap, but I think the real solution is to switch over
to using sparsemem, and get rid of ARMs private version (which even
pre-dates discontigmem.)  That first assumes that we have sparsemem
working on ARM - however folk seem to prefer discontigmem over
sparsemem so I don't know what state sparsemem on ARM is in. :(
