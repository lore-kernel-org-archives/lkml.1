Return-Path: <linux-kernel-owner+w=401wt.eu-S1761053AbXEWXH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761053AbXEWXH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 19:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbXEWXHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 19:07:15 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42791 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756797AbXEWXHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 19:07:13 -0400
Date: Wed, 23 May 2007 16:07:12 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Russell King <rmk+lkml@arm.linux.org.uk>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: Define CONFIG_BOUNCE to avoid useless inclusion of bounce buffer
 logic.
In-Reply-To: <20070523225812.GE1976@flint.arm.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0705231603470.23000@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705212100420.24947@schroedinger.engr.sgi.com>
 <20070522133906.ae9c362a.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0705212225590.25388@schroedinger.engr.sgi.com>
 <20070523140702.GA16972@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0705231011000.19822@schroedinger.engr.sgi.com>
 <20070523225812.GE1976@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007, Russell King wrote:

> > GFP_DMA allocations are an exception and that exception can be removed 
> > from the core VM by not defining ZONE_DMA. You cannot switch off the 
> > NORMAL zone.
> 
> I'd like to be able to switch off the normal and highmem zones and leave
> just the DMA zone behind.  The normal and highmem zones are just a waste
> of space on ARM.

If you do not have exceptional memory requirements then you do not need a 
DMA zone. The core code allows you to switch off ZONE_DMA but not 
ZONE_NORMAL. For a description of the roles of the zones see 
include/linux/mmzone.h

> > Nope. The DMA zone is for crappy DMA devices that can only use a portion 
> > of memory.
> 
> I'm sorry, we're going to have to agree to disagree then.
> 
> As for your assertion that it's "crappy DMA devices" there are modern
> PCI based platforms being produced by Marvell (which were designed by
> Intel) which can only DMA from 64MB of memory, inspite of the PCI
> device having full PCI busmastering capabilities.

Ok sorry for the word choice.

> At the end of the day, it is _far_ simpler from an architectural point
> of view for memory to live in the DMA zone and disable the normal and
> highmem zones than it is to selectively populate the normal zone
> depending on whether device X is configured, and then also have to hack
> around various drivers which decide they want to use __GFP_DMA because
> of some antequated x86ism which doesn't apply on non-x86.

If you switch off CONFIG_ZONE_DMA then __GFP_DMA becomes a no op. So no 
problem. Many of us want to rid the kernel of __GFP_DMA. Please join the 
club and nuke the useless ZONE_DMA on your platforms.


