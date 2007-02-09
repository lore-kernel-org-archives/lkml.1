Return-Path: <linux-kernel-owner+w=401wt.eu-S1945999AbXBICN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945999AbXBICN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 21:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946012AbXBICNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 21:13:25 -0500
Received: from waste.org ([66.93.16.53]:47542 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945999AbXBICNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 21:13:25 -0500
Date: Thu, 8 Feb 2007 20:00:39 -0600
From: Matt Mackall <mpm@selenic.com>
To: Paul Mundt <lethal@linux-sh.org>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@osdl.org>, Hugh Dickins <hugh@veritas.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3 take2] smaps: extract pte walker from smaps code
Message-ID: <20070209020038.GN16722@waste.org>
References: <Pine.LNX.4.64.0702062212550.13931@chino.kir.corp.google.com> <20070207062934.GA11967@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070207062934.GA11967@linux-sh.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 07, 2007 at 03:29:34PM +0900, Paul Mundt wrote:
> On Tue, Feb 06, 2007 at 10:15:47PM -0800, David Rientjes wrote:
> > Extracts the page table entry walker from the smaps-specific code in
> > fs/proc/task_mmu.c.  This will be used later for clearing the reference
> > bits on pages to measure the number of pages accessed over a time period
> > through /proc/pid/smaps.
> > 
> I like the general idea of this patch set, however..
> 
> > Since the PTE walker is now extracted from the smaps code,
> > smaps_pte_func() is invoked for each PTE in the VMA.  Its behavior is
> > identical to the existing implementation, except it is slightly slower
> > because each PTE now invokes a function call.
> > 
> Perhaps this is something that needs to be looked at more closely and
> made more generic? There are many ranged page table walkers that aren't
> so performance critical that the function call cost would cause too much
> pain. ioremap_page_range() comes to mind, and there's bound to be others.
> This would also help people to get the pte map/unmap right, which seems
> to pop up from time to time as well..

I've been looking at a similar refactoring of other code and I think
the way to go is a callback per block-of-PTEs with start and end
pointers. That gets rid of most of the call indirection overhead.

-- 
Mathematics is the supreme nostalgia of our time.
