Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbYHUQfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbYHUQfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 12:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbYHUQfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 12:35:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33183 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801AbYHUQfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 12:35:04 -0400
Date: Thu, 21 Aug 2008 09:34:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       hsweeten@visionengravers.com
Subject: Re: [PATCH] Skip memory holes in FLATMEM when reading
 /proc/pagetypeinfo (resend)
Message-Id: <20080821093400.fe02a76f.akpm@linux-foundation.org>
In-Reply-To: <20080821132804.GA6206@csn.ul.ie>
References: <20080821132804.GA6206@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008 14:28:05 +0100 Mel Gorman <mel@csn.ul.ie> wrote:

> This is a resend. The last patch went to Russell King with lkml cc'd as I
> wasn't subscribed to the linux-arm list. However, I haven't heard it being
> picked up so trying linux-arm this time.
> 
> ===
> 
> Ordinarily, memory holes in flatmem still have a valid memmap and is safe
> to use. However, an architecture (ARM) frees up the memmap backing memory
> holes on the assumption it is never used. /proc/pagetypeinfo reads the
> whole range of pages in a zone believing that the memmap is valid and that
> pfn_valid will return false if it is not. On ARM, freeing the memmap breaks
> the page->zone linkages even though pfn_valid() returns true and the kernel
> can oops shortly afterwards due to accessing a bogus struct zone *.
> 
> This patch lets architectures say when FLATMEM can have holes in the
> memmap. Rather than an expensive check for valid memory, /proc/pagetypeinfo
> will confirm that the page linkages are still valid by checking page->zone
> is still the expected zone. The lookup of page_zone is safe as there is a
> limited range of memory that is accessed when calling page_zone.  Even if
> page_zone happens to return the correct zone, the impact is that the counters
> in /proc/pagetypeinfo are slightly off but fragmentation monitoring is
> unlikely to be relevant on an embedded system.

Sounds like this might fix an oops.  Does it?

The patch applies to 2.6.25 and to 2.6.26.  Should it be backported?

