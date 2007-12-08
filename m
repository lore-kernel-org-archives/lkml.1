Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbXLHSii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbXLHSii (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 13:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbXLHShx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 13:37:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59507 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753783AbXLHShv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 13:37:51 -0500
Date: Sat, 8 Dec 2007 10:37:23 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Matt Mackall <mpm@selenic.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: tipc_init(), WARNING: at arch/x86/mm/highmem_32.c:52,
 [2.6.24-rc4-git5: Reported regressions from 2.6.23]
In-Reply-To: <20071208100950.a3547868.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.9999.0712081034470.12046@woody.linux-foundation.org>
References: <200712080340.49546.rjw@sisk.pl> <20071208093039.GA28054@elte.hu> <20071208163749.GI19691@waste.org> <alpine.LFD.0.9999.0712080941170.12046@woody.linux-foundation.org> <alpine.LFD.0.9999.0712080948310.12046@woody.linux-foundation.org>
 <20071208100950.a3547868.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 8 Dec 2007, Andrew Morton wrote:
>
> > So which warning is it that triggers the bogus error?
> 
> It's a kmap_atomic() debugging patch which I wrote ages ago and whcih Ingo
> sucked into his tree.  I don't _think_ this warning is present in your tree
> at all.

Ok, that explains it.

> Knocking out __GFP_ZERO at the point where the slab allocator(s) call the
> page allocator seems like a good approach to me.
> 
> But I don't think we need to do anything for 2.6.24..

Good. Although we should perhaps look at that reported performance problem 
with SLUB. It looks like SLUB will do a memclear() for the area twice 
(first for the whole page, then for the thing it allocated) for the slow 
case. Maybe that exacerbates the problem.

			Linus
