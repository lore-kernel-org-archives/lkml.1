Return-Path: <linux-kernel-owner+w=401wt.eu-S1755652AbZCLL2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbZCLL2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbZCLL2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:28:01 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:43258 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbZCLL2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:28:00 -0400
Date: Thu, 12 Mar 2009 12:24:41 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       akpm@linux-foundation.org
Subject: Re: [PATCH] fix/improve generic page table walker
Message-ID: <20090312122441.46782f9b@skybase>
In-Reply-To: <20090312111916.5dbdb1e5@skybase>
References: <20090311144951.58c6ab60@skybase>
	<1236792263.3205.45.camel@calx>
	<20090312093335.6dd67251@skybase>
	<20090312111916.5dbdb1e5@skybase>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Mar 2009 11:19:16 +0100
Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> On Thu, 12 Mar 2009 09:33:35 +0100
> Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> 
> > > I've gone to lengths to keep VMAs out of the equation, so I can't say
> > > I'm excited about this solution.  
> > 
> > The minimum fix is to add the mmap_sem. If a vma is unmapped while you
> > walk the page tables, they can get freed. You do have a dependency on
> > the vma list. All the other page table walkers in mm/ start with the
> > vma, then do the four loops. It would be consistent if the generic page
> > table walker would do the same.
> > 
> > Having thought about the problem again, I think I found a way how to
> > deal with the problem in the s390 page table primitives. The fix is not
> > exactly nice but it will work. With it s390 will be able to walk
> > addresses outside of the vma address range.
> 
> Ok, the patch below fixes the problem without vma operations in the
> generic page table walker. We still need the mmap_sem part though.

Hmm, thinko on my part. If would need the address of the pgd entry to do
what I'm trying to achieve but I only have the pgd entry itself. Back
to the vma operation in walk_page_range I'm afraid.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

