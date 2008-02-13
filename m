Return-Path: <linux-kernel-owner+w=401wt.eu-S1762453AbYBMCTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762453AbYBMCTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 21:19:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754363AbYBMCTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 21:19:13 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51346 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754268AbYBMCTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 21:19:13 -0500
Date: Tue, 12 Feb 2008 18:19:10 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Christian Bell <christian.bell@qlogic.com>
cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
       Rik van Riel <riel@redhat.com>, Andrea Arcangeli <andrea@qumranet.com>,
       a.p.zijlstra@chello.nl, izike@qumranet.com,
       Roland Dreier <rdreier@cisco.com>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: [ofa-general] Re: Demand paging for memory regions
In-Reply-To: <20080213015533.GP29340@mv.qlogic.com>
Message-ID: <Pine.LNX.4.64.0802121816260.12328@schroedinger.engr.sgi.com>
References: <20080209015659.GC7051@v2.random>
 <Pine.LNX.4.64.0802081813300.5602@schroedinger.engr.sgi.com>
 <20080209075556.63062452@bree.surriel.com> <Pine.LNX.4.64.0802091345490.12965@schroedinger.engr.sgi.com>
 <ada3arzxgkz.fsf_-_@cisco.com> <47B2174E.5000708@opengridcomputing.com>
 <Pine.LNX.4.64.0802121408150.9591@schroedinger.engr.sgi.com>
 <adazlu5vlub.fsf@cisco.com> <20080212232329.GC31435@obsidianresearch.com>
 <Pine.LNX.4.64.0802121657430.11628@schroedinger.engr.sgi.com>
 <20080213015533.GP29340@mv.qlogic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008, Christian Bell wrote:

> I think there are very potential clients of the interface when an
> optimistic approach is used.  Part of the trick, however, has to do
> with being able to re-start transfers instead of buffering the data
> or making guarantees about delivery that could cause deadlock (as was
> alluded to earlier in this thread).  InfiniBand is constrained in
> this regard since it requires message-ordering between endpoints (or
> queue pairs).  One could argue that this is still possible with IB,
> at the cost of throwing more packets away when a referenced page is
> not in memory.  With this approach, the worse case demand paging
> scenario is met when the active working set of referenced pages is
> larger than the amount physical memory -- but HPC applications are
> already bound by this anyway.
> 
> You'll find that Quadrics has the most experience in this area and
> that their entire architecture is adapted to being optimistic about
> demand paging in RDMA transfers -- they've been maintaining a patchset
> to do this for years.

The notifier patchset that we are discussing here was mostly inspired by 
their work. 

There is no need to restart transfers that you have never started in the 
first place. The remote side would never start a transfer if the page 
reference has been torn down. In order to start the transfer a fault 
handler on the remote side would have to setup the association between the 
memory on both ends again.



