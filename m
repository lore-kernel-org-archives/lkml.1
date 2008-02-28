Return-Path: <linux-kernel-owner+w=401wt.eu-S1760624AbYB1AVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624AbYB1AVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbYB1AV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:21:26 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:37656
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbYB1AV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:21:26 -0500
Date: Thu, 28 Feb 2008 01:21:21 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       general@lists.openfabrics.org, akpm@linux-foundation.org
Subject: Re: [kvm-devel] [PATCH] mmu notifiers #v7
Message-ID: <20080228002121.GC8091@v2.random>
References: <20080219231157.GC18912@wotan.suse.de> <20080220010941.GR7128@v2.random> <20080220103942.GU7128@v2.random> <20080221045430.GC15215@wotan.suse.de> <20080221144023.GC9427@v2.random> <20080221161028.GA14220@sgi.com> <20080227192610.GF28483@v2.random> <Pine.LNX.4.64.0802271503050.13186@schroedinger.engr.sgi.com> <20080227234317.GM28483@v2.random> <Pine.LNX.4.64.0802271605480.15667@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802271605480.15667@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 04:08:07PM -0800, Christoph Lameter wrote:
> On Thu, 28 Feb 2008, Andrea Arcangeli wrote:
> 
> > If RDMA/IB folks needed to block in invalidate_range, I guess they
> > need to do so on top of tmpfs too, and that never worked with your
> > patch anyway.
> 
> How about blocking in invalidate_page()? It can be made to work...

Yes, it can be made to work with even more extended VM changes than to
only allow invalidate_range to schedule. Those core VM changes should
only be done "by default" (w/o CONFIG_XPMEM=y), if they're doing good
to the VM regardless of xpmem requirements. And I'm not really sure of
that. I think they don't do any good or they would be a mutex
already...

> Well so we do not address the issues?

I'm not suggesting not to address the issues, just that those issues
requires VM core changes, and likely those changes should be
switchable under a CONFIG_XPMEM, so I see no reason to delay the mmu
notifier until those changes are done and merged too. It's kind of a
separate problem.

> Either that or a separate rmap as also mentioned before.

DRI also wants invalidate_page by (mm,addr).
