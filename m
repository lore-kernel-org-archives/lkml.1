Return-Path: <linux-kernel-owner+w=401wt.eu-S1757868AbYJ3VIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868AbYJ3VIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbYJ3VIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:08:32 -0400
Received: from ipmail05.adl2.internode.on.net ([203.16.214.145]:2516 "EHLO
	ipmail05.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774AbYJ3VIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:08:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEALe+CUl5LIvD/2dsb2JhbADNFINR
X-IronPort-AV: E=Sophos;i="4.33,518,1220193000"; 
   d="scan'208";a="244346378"
Date: Fri, 31 Oct 2008 08:08:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
       Paul Menage <menage@google.com>, Derek Fults <dfults@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/7] cpuset writeback throttling
Message-ID: <20081030210826.GR17077@disturbed>
Mail-Followup-To: David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux-foundation.org>,
	Nick Piggin <npiggin@suse.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Paul Menage <menage@google.com>, Derek Fults <dfults@sgi.com>,
	linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 12:23:10PM -0700, David Rientjes wrote:
> Andrew,
> 
> This is the revised cpuset writeback throttling patchset posted to LKML 
> on Tuesday, October 27.
> 
> The comments from Peter Zijlstra have been addressed.  His concurrent 
> page cache patchset is not currently in -mm, so we can still serialize 
> updating a struct address_space's dirty_nodes on its tree_lock.  When his 
> patchset is merged, the patch at the end of this message can be used to 
> introduce the necessary synchronization.
> 
> This patchset applies nicely to 2.6.28-rc2-mm1 with the exception of the 
> first patch due to the alloc_inode() refactoring to inode_init_always() in
> e9110864c440736beb484c2c74dedc307168b14e from linux-next and additions to 
> include/linux/cpuset.h from 
> oom-print-triggering-tasks-cpuset-and-mems-allowed.patch (oops :).
> 
> Please consider this for inclusion in the -mm tree.
> 
> A simple way of testing this change is to create a large file that exceeds 
> the amount of memory allocated to a specific cpuset.  Then, mmap and 
> modify the large file (such as in the following program) while running a 
> latency sensitive task in a disjoint cpuset.  Notice the writeout 
> throttling that doesn't interfere with the latency sensitive task.

What sort of validation/regression testing has this been through?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
