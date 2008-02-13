Return-Path: <linux-kernel-owner+w=401wt.eu-S1765375AbYBMBBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765375AbYBMBBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764823AbYBMBBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:01:19 -0500
Received: from relay2.sgi.com ([192.48.171.30]:54423 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754448AbYBMBBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:01:18 -0500
Date: Tue, 12 Feb 2008 17:01:17 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
cc: Roland Dreier <rdreier@cisco.com>, Rik van Riel <riel@redhat.com>,
       steiner@sgi.com, Andrea Arcangeli <andrea@qumranet.com>,
       a.p.zijlstra@chello.nl, izike@qumranet.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: [ofa-general] Re: Demand paging for memory regions
In-Reply-To: <20080212232329.GC31435@obsidianresearch.com>
Message-ID: <Pine.LNX.4.64.0802121657430.11628@schroedinger.engr.sgi.com>
References: <20080209012446.GB7051@v2.random>
 <Pine.LNX.4.64.0802081725200.5445@schroedinger.engr.sgi.com>
 <20080209015659.GC7051@v2.random> <Pine.LNX.4.64.0802081813300.5602@schroedinger.engr.sgi.com>
 <20080209075556.63062452@bree.surriel.com> <Pine.LNX.4.64.0802091345490.12965@schroedinger.engr.sgi.com>
 <ada3arzxgkz.fsf_-_@cisco.com> <47B2174E.5000708@opengridcomputing.com>
 <Pine.LNX.4.64.0802121408150.9591@schroedinger.engr.sgi.com>
 <adazlu5vlub.fsf@cisco.com> <20080212232329.GC31435@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Jason Gunthorpe wrote:

> Well, certainly today the memfree IB devices store the page tables in
> host memory so they are already designed to hang onto packets during
> the page lookup over PCIE, adding in faulting makes this time
> larger.

You really do not need a page table to use it. What needs to be maintained 
is knowledge on both side about what pages are currently shared across 
RDMA. If the VM decides to reclaim a page then the notification is used to 
remove the remote entry. If the remote side then tries to access the page 
again then the page fault on the remote side will stall until the local 
page has been brought back. RDMA can proceed after both sides again agree 
on that page now being sharable.
