Return-Path: <linux-kernel-owner+w=401wt.eu-S1763484AbYBTArR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763484AbYBTArR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYBTArC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:47:02 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:44559
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbYBTArA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:47:00 -0500
Date: Wed, 20 Feb 2008 01:46:35 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Nick Piggin <npiggin@suse.de>
Cc: akpm@linux-foundation.org, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch] my mmu notifiers
Message-ID: <20080220004635.GO7128@v2.random>
References: <20080219084357.GA22249@wotan.suse.de> <20080219135851.GI7128@v2.random> <20080219225923.GA18912@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219225923.GA18912@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 19, 2008 at 11:59:23PM +0100, Nick Piggin wrote:
> That's why I don't understand the need for the pairs: it should be
> done like this.

Yes, except it can't be done like this for xpmem.

> OK, I didn't see the invalidate_pages call...

See the last patch I posted to Andrew, you've probably looked at the
old patches, the old patches didn't work for GRU and didn't work for
xpmem and they weren't optimized to cluster the invalidates for each
4k-large-pte.

> I thought that could be used by a non-sleeping user (not intending
> to try supporting sleeping users). If it is useless then it should
> go away (BTW. I didn't see your recent patch, some of my confusion
> I think stems from Christoph's novel way of merging and splitting
> patches).

I kept improving my patch in case the VM maintainers would consider
xpmem requirements not workable from a linux-VM point of view, and
they preferred to have something obviously safe, strightforward and
non intrusive, despite it doesn't support the only sleeping user out
there I know of (xpmem). My patch supports KVM and GRU (and any other
not sleeping user).

> > No idea why xpmem needs range_begin, I perfectly understand why GRU
> > needs _begin with Chrisotph's patch (gru lacks the page pin) but I
> > dunno why xpmem needs range_begin (xpmem has the page pin so I also
> > think it could avoid using range_begin). Still to support GRU you need
> > both to call invalidate_range in places that can sleep and you need
> > the external rmap notifier. The moment you add xpmem into the equation
> > your and my clean patches become Christoph's one...
> 
> Sorry, I kind of didn't have time to follow the conversation so well
> before; are there patches posted for gru and/or xpmem?

There's some xpmem code posted but the posted one isn't using the mmu
notifiers yet. GRU code may be available from Jack. I only know for
sure their requirements in terms of mmu notifiers.
