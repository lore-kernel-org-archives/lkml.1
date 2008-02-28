Return-Path: <linux-kernel-owner+w=401wt.eu-S1760095AbYB1AIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095AbYB1AIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:08:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbYB1AIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:08:10 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33750 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753624AbYB1AIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:08:09 -0500
Date: Wed, 27 Feb 2008 16:08:07 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Nick Piggin <npiggin@suse.de>, Steve Wise <swise@opengridcomputing.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Kanoj Sarcar <kanojsarcar@yahoo.com>, Roland Dreier <rdreier@cisco.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       general@lists.openfabrics.org, akpm@linux-foundation.org
Subject: Re: [kvm-devel] [PATCH] mmu notifiers #v7
In-Reply-To: <20080227234317.GM28483@v2.random>
Message-ID: <Pine.LNX.4.64.0802271605480.15667@schroedinger.engr.sgi.com>
References: <20080219084357.GA22249@wotan.suse.de> <20080219135851.GI7128@v2.random>
 <20080219231157.GC18912@wotan.suse.de> <20080220010941.GR7128@v2.random>
 <20080220103942.GU7128@v2.random> <20080221045430.GC15215@wotan.suse.de>
 <20080221144023.GC9427@v2.random> <20080221161028.GA14220@sgi.com>
 <20080227192610.GF28483@v2.random> <Pine.LNX.4.64.0802271503050.13186@schroedinger.engr.sgi.com>
 <20080227234317.GM28483@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Andrea Arcangeli wrote:

> If RDMA/IB folks needed to block in invalidate_range, I guess they
> need to do so on top of tmpfs too, and that never worked with your
> patch anyway.

How about blocking in invalidate_page()? It can be made to work...

> > Would it not be better to have a solution that fits all instead of hacking 
> > something in now and then having to modify it later?
> 
> The whole point is that your solution fits only GRU and KVM too.

Well so we do not address the issues?
 
> XPMEM in your patch works in a hacked mode limited to anonymous memory
> only, Robin already received incoming mail asking to allow xpmem to
> work on more than anonymous memory, so your solution-that-fits-all
> doesn't actually fit some of Robin's customer needs. So if it doesn't
> even entirely satisfy xpmem users, imagine the other potential
> blocking-users of this code.

The solutions have been mentioned...

> anon_vma lock can remain a spinlock unless you also want to schedule
> inside try_to_unmap.

Either that or a separate rmap as also mentioned before.


