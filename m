Return-Path: <linux-kernel-owner+w=401wt.eu-S1946612AbXBIQ2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946612AbXBIQ2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946611AbXBIQ2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:28:36 -0500
Received: from waste.org ([66.93.16.53]:41914 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946614AbXBIQ2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:28:35 -0500
Date: Fri, 9 Feb 2007 10:15:49 -0600
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>, Andrew Morton <akpm@osdl.org>,
       Hugh Dickins <hugh@veritas.com>, Paul Mundt <lethal@linux-sh.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3 take2] smaps: extract pte walker from smaps code
Message-ID: <20070209161549.GO16722@waste.org>
References: <Pine.LNX.4.64.0702062212550.13931@chino.kir.corp.google.com> <Pine.LNX.4.64.0702070017360.26926@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702070017360.26926@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 12:30:38AM -0800, Christoph Lameter wrote:
> On Tue, 6 Feb 2007, David Rientjes wrote:
> 
> > Extracts the page table entry walker from the smaps-specific code in
> > fs/proc/task_mmu.c.  This will be used later for clearing the reference
> > bits on pages to measure the number of pages accessed over a time period
> > through /proc/pid/smaps.
> 
> Clearing reference bits? Ummm... That is a pretty inaccurate measure since 
> reclaim can remove pages and revert the reference bits. It can never work 
> reliably.
> 
> > The new struct pte_walker includes the struct vm_area_struct of the memory
> > to walk over.  Iteration begins at the start address and completes at the
> > the end address.  A pointer to another data structure may be stored in the
> > private field such as the struct mem_size_stats, which acts as the smaps
> > accumulator.  For each page table entry in the VMA, the func function is
> > called with the corresponding struct pte_walker, the pte_t, and its
> > address.
> 
> Would it be possible to sync up with the people doing the page table 
> interface?

Have a pointer to this?

-- 
Mathematics is the supreme nostalgia of our time.
