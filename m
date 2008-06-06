Return-Path: <linux-kernel-owner+w=401wt.eu-S1759575AbYFFBQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759575AbYFFBQp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 21:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYFFBQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 21:16:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43134 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYFFBQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 21:16:33 -0400
Date: Fri, 06 Jun 2008 10:15:33 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Johannes Weiner <hannes@saeurebad.de>
Subject: Re: [PATCH -mm 00/14] bootmem rewrite v4
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080605224940.434439989@saeurebad.de>
References: <20080605224940.434439989@saeurebad.de>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080606100854.3759.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK.
I reviewed this patch set, and my ia64 box can boot up with it. :-)

Thanks.

Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>


> Hi,
> 
> This is a complete overhaul of the bootmem allocator while preserving
> most of its original functionality.
> 
> free_bootmem and reserve_bootmem become a bit stricter than they are
> right now, callsites have to make sure that the PFN range is
> contiguous but it might go across node boundaries.
> 
> alloc_bootmem satisfying the allocation goal is more likely as the
> routines will try to allocate on the node holding the goal first
> before falling back as opposed to the original behaviour that
> satisfies the goal only if it is on the first node.
> 
> All in all, I think the code has become simpler and cleaner.  All
> public interfaces have been documented, too.
> 
> version 4: based on -mmotm from 08-06-05
>   o fixed fallback logic in alloc_bootmem_core (take the fallback even
>     in cases where sidx is zero) to make Yasunori's machine boot again
>   o fixed bogus range checks in ___alloc_bootmem_nopanic
>   o removed bogus `fallback'-offset calculation in alloc_bootmem_core
>   o renamed last_offset to last_end_off
>   o renamed last_success to hint_idx
>   o start searching after the end of the previous allocation, not at
>     its beginning
>   o improved more identifier names for offsets, pfns, indices and
>     addresses
>   o adjusted debugging output to output hex numbers consistently
> 
> version 3:
>   o fixed kerneldoc as noted by Chris Malley
>   o fixed incorrect bdata->last_success treatment as noted by
>     Yasunori Goto
> 
> version 2:
>   o broken up patches into logical chunks
> 
> ---
> 
>  arch/alpha/mm/numa.c     |    2 +-
>  arch/arm/plat-omap/fb.c  |    4 +-
>  arch/avr32/mm/init.c     |    3 +-
>  arch/ia64/mm/discontig.c |   19 +-
>  arch/m32r/mm/discontig.c |    3 +-
>  arch/m32r/mm/init.c      |    4 +-
>  arch/mn10300/mm/init.c   |    6 +-
>  arch/sh/mm/init.c        |    2 +-
>  include/linux/bootmem.h  |   87 +++---
>  mm/bootmem.c             |  934 +++++++++++++++++++++++++---------------------
>  10 files changed, 570 insertions(+), 494 deletions(-)
> 

-- 
Yasunori Goto 


