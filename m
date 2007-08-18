Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbXHRJbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbXHRJbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 05:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750720AbXHRJbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 05:31:43 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1311 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750716AbXHRJbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 05:31:42 -0400
Date: Sat, 18 Aug 2007 07:10:36 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, dkegel@google.com,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       David Miller <davem@davemloft.net>, Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC 2/9] Use NOMEMALLOC reclaim to allow reclaim if PF_MEMALLOC is set
Message-ID: <20070818071035.GA4667@ucw.cz>
References: <20070814153021.446917377@sgi.com> <20070814153501.305923060@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814153501.305923060@sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> If we exhaust the reserves in the page allocator when PF_MEMALLOC is set
> then no longer give up but call into reclaim with PF_MEMALLOC set.
> 
> This is in essence a recursive call back into page reclaim with another
> page flag (__GFP_NOMEMALLOC) set. The recursion is bounded since potential
> allocations with __PF_NOMEMALLOC set will not enter that branch again.
> 
> This means that allocation under PF_MEMALLOC will no longer run out of
> memory. Allocations under PF_MEMALLOC will do a limited form of reclaim
> instead.
> 
> The reclaim is of particular important to stacked filesystems that may
> do a lot of allocations in the write path. Reclaim will be working
> as long as there are clean file backed pages to reclaim.

I don't get it. Lets say that we have stacked filesystem that needs
it. That filesystem is broken today.

Now you give it second chance by reclaiming clean pages, but there are
no guarantees that we have any.... so that filesystem is still broken
with your patch...?

Should we fix the filesystem instead?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
