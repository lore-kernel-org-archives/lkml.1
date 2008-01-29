Return-Path: <linux-kernel-owner+w=401wt.eu-S1762204AbYA2Tz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762204AbYA2Tz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbYA2TzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:55:14 -0500
Received: from relay1.sgi.com ([192.48.171.29]:50312 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751374AbYA2TzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:55:12 -0500
Date: Tue, 29 Jan 2008 11:55:10 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address ranges
In-Reply-To: <20080129162004.GL7233@v2.random>
Message-ID: <Pine.LNX.4.64.0801291153520.25300@schroedinger.engr.sgi.com>
References: <20080128202840.974253868@sgi.com> <20080128202923.849058104@sgi.com>
 <20080129162004.GL7233@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jan 2008, Andrea Arcangeli wrote:

> > +	mmu_notifier(invalidate_range, mm, address,
> > +				address + PAGE_SIZE - 1, 0);
> >  	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
> >  	if (likely(pte_same(*page_table, orig_pte))) {
> >  		if (old_page) {
> 
> What's the point of invalidate_range when the size is PAGE_SIZE? And
> how can it be right to invalidate_range _before_ ptep_clear_flush?

I am not sure. AFAICT you wrote that code.

It seems to be okay to invalidate range if you hold mmap_sem writably. In 
that case no additional faults can happen that would create new ptes.



