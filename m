Return-Path: <linux-kernel-owner+w=401wt.eu-S933777AbXBZHAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777AbXBZHAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 02:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933778AbXBZHAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 02:00:07 -0500
Received: from holomorphy.com ([66.93.40.71]:50623 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933777AbXBZHAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 02:00:05 -0500
Date: Sun, 25 Feb 2007 22:59:43 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, john stultz <johnstul@us.ibm.com>
Subject: Re: Make sure we populate the initroot filesystem late enough
Message-ID: <20070226065943.GA3037@holomorphy.com>
References: <200612112059.kBBKx1j7022473@hera.kernel.org> <1172448057.3971.9.camel@shinybook.infradead.org> <Pine.LNX.4.64.0702251614420.12485@woody.linux-foundation.org> <1172452660.3971.33.camel@shinybook.infradead.org> <Pine.LNX.4.64.0702251940500.12485@woody.linux-foundation.org> <1172462466.3971.46.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172462466.3971.46.camel@shinybook.infradead.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 25, 2007 at 11:01:06PM -0500, David Woodhouse wrote:
> Yeah, I did that before giving up on it for the day and going in search
> of dinner. It changes the failure mode to a BUG() in
> cache_free_debugcheck(), at line 2876 of mm/slab.c
> It smells like the pages weren't actually reserved in the first place
> and we were blithely allocating them. The only problem with that theory
> is that the initrd doesn't seem to be getting corrupted -- and if we
> were handing out its pages like that then surely _something_ would have
> scribbled on it before we tried to read it.
> When I head back in tomorrow morning I'll instrument free_initrd_mem()
> to check that the PageReserved bit was actually set on each page, before
> clearing it. And I'll make the page allocation routines check whether
> they're giving out pages between initrd_start and initrd_end, etc.

Another few things to try would be inserting checks in page_alloc.c for
pages in that specific range before some flag set in free_initrd_mem()
is set, and (conflicting with that, though easily reconciled) unmapping
initrd memory in free_initrd_mem() instead of freeing it.


-- wli
