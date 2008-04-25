Return-Path: <linux-kernel-owner+w=401wt.eu-S1764563AbYDYREg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764563AbYDYREg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 13:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759476AbYDYRE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:04:28 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:36447
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114AbYDYRE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:04:28 -0400
Date: Fri, 25 Apr 2008 19:04:25 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       Nick Piggin <npiggin@suse.de>, Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 1 of 9] Lock the entire mm to prevent any mmu related
	operation to happen
Message-ID: <20080425170425.GB23300@duo.random>
References: <ec6d8f91b299cf26cce5.1207669444@duo.random> <200804221506.26226.rusty@rustcorp.com.au> <20080425165639.GA23300@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080425165639.GA23300@duo.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 06:56:39PM +0200, Andrea Arcangeli wrote:
> > > +		data->i_mmap_locks = vmalloc(nr_i_mmap_locks *
> > > +					     sizeof(spinlock_t));
> > 
> > This is why non-typesafe allocators suck.  You want 'sizeof(spinlock_t *)' 
> > here.
> > 
> > > +		data->anon_vma_locks = vmalloc(nr_anon_vma_locks *
> > > +					       sizeof(spinlock_t));
> > 
> > and here.
> 
> Great catch! (it was temporarily wasting some ram which isn't nice at all)

As I went into the editor I just found the above already fixed in
#v14-pre3. And I can't move the structure into the file anymore
without kmallocing it. Exposing that structure avoids the
ERR_PTR/PTR_ERR on the retvals and one kmalloc so I think it makes the
code simpler in the end to keep it as it is now. I'd rather avoid
further changes to the 1/N patch, as long as they don't make any
difference at runtime and as long as they involve more than
cut-and-pasting a structure from .h to .c file.
