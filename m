Return-Path: <linux-kernel-owner+w=401wt.eu-S932701AbZJAOid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbZJAOid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932519AbZJAOic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:38:32 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:50221 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932475AbZJAOib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:38:31 -0400
Date: Thu, 1 Oct 2009 10:32:54 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Nick Piggin <npiggin@suse.de>,
       heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/4] slqb: Record what node is local to a
 kmem_cache_cpu
In-Reply-To: <20091001104046.GA21906@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0910011028380.3911@gentwo.org>
References: <1253624054-10882-1-git-send-email-mel@csn.ul.ie> <1253624054-10882-3-git-send-email-mel@csn.ul.ie> <84144f020909220638l79329905sf9a35286130e88d0@mail.gmail.com> <20090922135453.GF25965@csn.ul.ie> <84144f020909221154x820b287r2996480225692fad@mail.gmail.com>
 <20090922185608.GH25965@csn.ul.ie> <20090930144117.GA17906@csn.ul.ie> <alpine.DEB.1.10.0909301053550.9450@gentwo.org> <20090930220541.GA31530@csn.ul.ie> <alpine.DEB.1.10.0909301941570.11850@gentwo.org> <20091001104046.GA21906@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009, Mel Gorman wrote:

> > Frees are done directly to the target slab page if they are not to the
> > current active slab page. No centralized locks. Concurrent frees from
> > processors on the same node to multiple other nodes (or different pages
> > on the same node) can occur.
> >
>
> So as a total aside, SLQB has an advantage in that it always uses object
> in LIFO order and is more likely to be cache hot. SLUB has an advantage
> when one CPU allocates and another one frees because it potentially
> avoids a cache line bounce. Might be something worth bearing in mind
> when/if a comparison happens later.

SLQB may use cache hot objects regardless of their locality. SLUB
always serves objects that have the same locality first (same page).
SLAB returns objects via the alien caches to the remote node.
So object allocations with SLUB will generate less TLB pressure since they
are localized. SLUB objects are immediately returned to the remote node.
SLAB/SLQB keeps them around for reallocation or queue processing.

> > Look at fallback_alloc() in slab. You can likely copy much of it. It
> > considers memory policies and cpuset constraints.
> >
> True, it looks like some of the logic should be taken from there all right. Can
> the treatment of memory policies be dealt with as a separate thread though? I'd
> prefer to get memoryless nodes sorted out before considering the next two
> problems (per-cpu instability on ppc64 and memory policy handling in SLQB).

Separate email thread? Ok.

