Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYBSNae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYBSNae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 08:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbYBSNa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 08:30:26 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:41333
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbYBSNaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 08:30:25 -0500
Date: Tue, 19 Feb 2008 14:30:09 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 3/6] mmu_notifier: invalidate_page callbacks
Message-ID: <20080219133009.GG7128@v2.random>
References: <20080215064859.384203497@sgi.com> <20080215193736.9d6e7da3.akpm@linux-foundation.org> <Pine.LNX.4.64.0802161121130.25573@schroedinger.engr.sgi.com> <200802191946.10695.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802191946.10695.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 07:46:10PM +1100, Nick Piggin wrote:
> On Sunday 17 February 2008 06:22, Christoph Lameter wrote:
> > On Fri, 15 Feb 2008, Andrew Morton wrote:
> 
> > > >  		flush_cache_page(vma, address, pte_pfn(*pte));
> > > >  		entry = ptep_clear_flush(vma, address, pte);
> > > > +		mmu_notifier(invalidate_page, mm, address);
> > >
> > > I just don't see how ths can be done if the callee has another thread in
> > > the middle of establishing IO against this region of memory.
> > > ->invalidate_page() _has_ to be able to block.  Confused.
> >
> > The page lock is held and that holds off I/O?
> 
> I think the actual answer is that "it doesn't matter".

Agreed. The PG_lock itself taken when invalidate_page is called, is
used to serialized the VM against the VM, not the VM against I/O.
