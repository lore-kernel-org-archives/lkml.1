Return-Path: <linux-kernel-owner+w=401wt.eu-S1753668AbZJAPIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbZJAPIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 11:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbZJAPIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 11:08:30 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:52511 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752194AbZJAPI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 11:08:29 -0400
Date: Thu, 1 Oct 2009 11:03:16 -0400 (EDT)
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
In-Reply-To: <20091001150346.GD21906@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0910011101390.3911@gentwo.org>
References: <84144f020909220638l79329905sf9a35286130e88d0@mail.gmail.com> <20090922135453.GF25965@csn.ul.ie> <84144f020909221154x820b287r2996480225692fad@mail.gmail.com> <20090922185608.GH25965@csn.ul.ie> <20090930144117.GA17906@csn.ul.ie>
 <alpine.DEB.1.10.0909301053550.9450@gentwo.org> <20090930220541.GA31530@csn.ul.ie> <alpine.DEB.1.10.0909301941570.11850@gentwo.org> <20091001104046.GA21906@csn.ul.ie> <alpine.DEB.1.10.0910011028380.3911@gentwo.org> <20091001150346.GD21906@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009, Mel Gorman wrote:

> True, it might have been improved more if SLUB knew what local hugepage it
> resided within as the kernel portion of the address space is backed by huge
> TLB entries. Note that SLQB could have an advantage here early in boot as
> the page allocator will tend to give it back pages within a single huge TLB
> entry. It loses the advantage when the system has been running for a very long
> time but it might be enough to skew benchmark results on cold-booted systems.

The page allocator serves pages aligned to huge page boundaries as far as
I can remember. You can actually use huge pages in slub if you set the max
order to 9. So a page obtained from the page allocator is always aligned
properly.


