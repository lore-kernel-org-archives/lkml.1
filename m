Return-Path: <linux-kernel-owner+w=401wt.eu-S1763986AbXEWRPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763986AbXEWRPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935612AbXEWRPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:15:15 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53310 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935476AbXEWRPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:15:12 -0400
Date: Wed, 23 May 2007 10:15:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: Define CONFIG_BOUNCE to avoid useless inclusion of bounce buffer
 logic.
In-Reply-To: <20070523140702.GA16972@flint.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0705231011000.19822@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705212100420.24947@schroedinger.engr.sgi.com>
 <20070522133906.ae9c362a.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0705212225590.25388@schroedinger.engr.sgi.com>
 <20070523140702.GA16972@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Russell King wrote:

> > That is wrong. ppc should have ZONE_NORMAL and no ZONE_DMA.
> > Otherwise you cannot switch off ZONE_DMA and you cannot switch off 
> > bounce. ZONE_DMA is a zone for exceptional allocs. If you do not have 
> > those then you only have normal allocs -> ZONE_NORMAL.
> 
> That sounds very wrong to me.  Since about 1995 ARM has always placed
> all DMA-able memory in the DMA zone, and none in the normal zone.
> 
> The reason for doing this is that normal allocations fall back to DMA
> allocations when the normal zone becomes full/empty.  However, DMA
> allocations can never be satisfied by allocations from the normal zone.

Usually DMA is done via ZONE_NORMAL allocations. GFP_DMA allocs and 
ZONE_DMA are for devices that cannot performa DMA to all of memory.

There is no need to fall back if you do not have such devices. So no need 
for ZONE_DMA.

> Moreover, special casing the "doesn't use __GFP_DMA allocations on this
> machine so places all memory in ZONE_NORMAL" is just too complicated -
> I've no idea which of the 100+ ARM machine support currently merged
> into the Linux kernel uses __GFP_DMA allocations and which don't.

GFP_DMA allocations are an exception and that exception can be removed 
from the core VM by not defining ZONE_DMA. You cannot switch off the 
NORMAL zone.

> The DMA zone is for memory allocations _for_ _DMA_.  If all your memory
> is DMA-able then it belongs in the DMA zone.

Nope. The DMA zone is for crappy DMA devices that can only use a portion 
of memory.

