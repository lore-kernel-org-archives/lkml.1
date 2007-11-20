Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbXKTDde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbXKTDde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 22:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXKTDd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 22:33:27 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43347 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751484AbXKTDd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 22:33:26 -0500
Date: Mon, 19 Nov 2007 19:33:25 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       travis@sgi.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 00/45] [RFC] CPU ops and a rework of per cpu data handling
 on x86_64
In-Reply-To: <200711200425.34849.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0711191932290.21689@schroedinger.engr.sgi.com>
References: <20071120011132.143632442@sgi.com> <20071119.175116.55102316.davem@davemloft.net>
 <200711200425.34849.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

n Tue, 20 Nov 2007, Andi Kleen wrote:

> 
> > Although we have a per-cpu area base in a fixed global register
> > for addressing, the above isn't beneficial on sparc64 because
> > the atomic is much slower than doing a:
> >
> > 	local_irq_disable();
> > 	nonatomic_percpu_memory_op();
> > 	local_irq_enable();
> 
> Again might be pointing out the obvious, but you 
> need of course save_flags()/restore_flags(), not disable/enable().
> 
> If it was just disable/enable x86 could do it much faster too 
> and Christoph probably would never felt the need to approach
> this project for his SLUB fast path.

I already have no need for that anymore with the material now in Andrews 
tree. However, this cuts out another 6 cycles from the fastpath and I 
found that the same principles reduce overhead all over the kernel.


