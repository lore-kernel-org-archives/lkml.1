Return-Path: <linux-kernel-owner+w=401wt.eu-S1030447AbXBGIay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030447AbXBGIay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 03:30:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030458AbXBGIax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 03:30:53 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:54952 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030447AbXBGIax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 03:30:53 -0500
Date: Wed, 7 Feb 2007 00:30:38 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@osdl.org>, Hugh Dickins <hugh@veritas.com>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3 take2] smaps: extract pte walker from smaps code
In-Reply-To: <Pine.LNX.4.64.0702062212550.13931@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0702070017360.26926@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702062212550.13931@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007, David Rientjes wrote:

> Extracts the page table entry walker from the smaps-specific code in
> fs/proc/task_mmu.c.  This will be used later for clearing the reference
> bits on pages to measure the number of pages accessed over a time period
> through /proc/pid/smaps.

Clearing reference bits? Ummm... That is a pretty inaccurate measure since 
reclaim can remove pages and revert the reference bits. It can never work 
reliably.

> The new struct pte_walker includes the struct vm_area_struct of the memory
> to walk over.  Iteration begins at the start address and completes at the
> the end address.  A pointer to another data structure may be stored in the
> private field such as the struct mem_size_stats, which acts as the smaps
> accumulator.  For each page table entry in the VMA, the func function is
> called with the corresponding struct pte_walker, the pte_t, and its
> address.

Would it be possible to sync up with the people doing the page table 
interface?

Could we somehow consolidate smaps and numa_maps?

