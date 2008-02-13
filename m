Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbYBMTqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbYBMTqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYBMTqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:46:24 -0500
Received: from nat-0.pathscale.com ([198.186.3.72]:35961 "EHLO
	mx.mv.qlogic.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751272AbYBMTqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:46:23 -0500
Date: Wed, 13 Feb 2008 11:46:21 -0800
From: Christian Bell <christian.bell@qlogic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <andrea@qumranet.com>,
       a.p.zijlstra@chello.nl, izike@qumranet.com,
       Roland Dreier <rdreier@cisco.com>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: [ofa-general] Re: Demand paging for memory regions
Message-ID: <20080213194621.GD19742@mv.qlogic.com>
References: <ada3arzxgkz.fsf_-_@cisco.com> <47B2174E.5000708@opengridcomputing.com> <Pine.LNX.4.64.0802121408150.9591@schroedinger.engr.sgi.com> <adazlu5vlub.fsf@cisco.com> <20080212232329.GC31435@obsidianresearch.com> <Pine.LNX.4.64.0802121657430.11628@schroedinger.engr.sgi.com> <20080213012638.GD31435@obsidianresearch.com> <Pine.LNX.4.64.0802121819530.12328@schroedinger.engr.sgi.com> <20080213040905.GQ29340@mv.qlogic.com> <Pine.LNX.4.64.0802131052360.18472@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802131052360.18472@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Christoph Lameter wrote:

> Right. We (SGI) have done something like this for a long time with XPmem 
> and it scales ok.

I'd dispute this based on experience developing PGAS language support
on the Altix but more importantly (and less subjectively), I think
that "scales ok" refers to a very specific case.  Sure, pages (and/or
regions) can be large on some systems and the number of systems may
not always be in the thousands but you're still claiming scalability
for a mechanism that essentially logs who accesses the regions.  Then
there's the fact that reclaim becomes a collective communication
operation over all region accessors.  Makes me nervous.

> > When messages are sufficiently large, the control messaging necessary
> > to setup/teardown the regions is relatively small.  This is not
> > always the case however -- in programming models that employ smaller
> > messages, the one-sided nature of RDMA is the most attractive part of
> > it.  
> 
> The messaging would only be needed if a process comes under memory 
> pressure. As long as there is enough memory nothing like this will occur.
> 
> > Nothing any communication/runtime system can't already do today.  The
> > point of RDMA demand paging is enabling the possibility of using RDMA
> > without the implied synchronization -- the optimistic part.  Using
> > the notifiers to duplicate existing memory region handling for RDMA
> > hardware that doesn't have HW page tables is possible but undermines
> > the more important consumer of your patches in my opinion.
> 

> The notifier schemet should integrate into existing memory region 
> handling and not cause a duplication. If you already have library layers 
> that do this then it should be possible to integrate it.

I appreciate that you're trying to make a general case for the
applicability of notifiers on all types of existing RDMA hardware and
wire protocols.  Also, I'm not disagreeing whether a HW page table
is required or not: clearly it's not required to make *some* use of
the notifier scheme.

However, short of providing user-level notifications for pinned pages
that are inadvertently released to the O/S, I don't believe that the
patchset provides any significant added value for the HPC community
that can't optimistically do RDMA demand paging.


    . . christian

