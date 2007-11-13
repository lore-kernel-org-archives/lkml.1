Return-Path: <linux-kernel-owner+w=401wt.eu-S1754021AbXKMLPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbXKMLPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 06:15:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbXKMLPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 06:15:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49052
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752748AbXKMLPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 06:15:10 -0500
Date: Tue, 13 Nov 2007 03:15:10 -0800 (PST)
Message-Id: <20071113.031510.151440585.davem@davemloft.net>
To: clameter@sgi.com
Cc: akpm@linux-foundation.org, linux-mm@vger.kernel.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071106195157.878563669@sgi.com>
References: <20071106195144.983665861@sgi.com>
	<20071106195157.878563669@sgi.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Tue, 06 Nov 2007 11:51:45 -0800

> The core portion of the cpu allocator.
> 
> The per cpu allocator allows dynamic allocation of memory on all
> processor simultaneously. A bitmap is used to track used areas.
> The allocator implements tight packing to reduce the cache footprint
> and increase speed since cacheline contention is typically not a concern
> for memory mainly used by a single cpu. Small objects will fill up gaps
> left by larger allocations that required alignments.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>

Unfortunately, sparc64 fails to boot even with just this patch
applied.

The problem is that for the non-virtualized case this patch bloats up
the BSS section to be more than 8MB in size.  Sparc64 kernel images
cannot be more than 8MB in size total due to various boot loader and
firmware limitations.

I have NR_CPUS set to 64, but it can be up to 4096 on sparc64.

Yes, I could add virtualized area support to sparc64, but we cannot
impose this on every platform.

One thing you could do is simply use a vmalloc allocation in the
non-virtualized case.
