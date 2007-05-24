Return-Path: <linux-kernel-owner+w=401wt.eu-S1760290AbXEXHum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290AbXEXHum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 03:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756156AbXEXHuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 03:50:35 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2448 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952AbXEXHue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 03:50:34 -0400
Date: Thu, 24 May 2007 08:50:21 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Christoph Lameter <clameter@sgi.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: Define CONFIG_BOUNCE to avoid useless inclusion of bounce buffer logic.
Message-ID: <20070524075021.GA4310@flint.arm.linux.org.uk>
Mail-Followup-To: Christoph Lameter <clameter@sgi.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	jens.axboe@oracle.com
References: <Pine.LNX.4.64.0705212100420.24947@schroedinger.engr.sgi.com> <20070522133906.ae9c362a.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0705212225590.25388@schroedinger.engr.sgi.com> <20070523140702.GA16972@flint.arm.linux.org.uk> <Pine.LNX.4.64.0705231011000.19822@schroedinger.engr.sgi.com> <20070523225812.GE1976@flint.arm.linux.org.uk> <Pine.LNX.4.64.0705231603470.23000@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705231603470.23000@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 04:07:12PM -0700, Christoph Lameter wrote:
> On Wed, 23 May 2007, Russell King wrote:
> > At the end of the day, it is _far_ simpler from an architectural point
> > of view for memory to live in the DMA zone and disable the normal and
> > highmem zones than it is to selectively populate the normal zone
> > depending on whether device X is configured, and then also have to hack
> > around various drivers which decide they want to use __GFP_DMA because
> > of some antequated x86ism which doesn't apply on non-x86.
> 
> If you switch off CONFIG_ZONE_DMA then __GFP_DMA becomes a no op. So no 
> problem. Many of us want to rid the kernel of __GFP_DMA. Please join the 
> club and nuke the useless ZONE_DMA on your platforms.

Absolutely and utterly impossible - with over 100 different machine
types I don't have anything approaching the necessary knowledge to
_special_ _case_ those platforms which _might_ be able to survive
without the DMA zone.  And that's what it'll be - a set of special
cases in the initialisation path.

As I've tried to explain, from day 1 of the multi-zone Linux MM, it's
always made more sense to put everything into zone DMA and (eventually)
hope that the normal and highmem zones eventually go away.

Who cares what happens to __GFP_DMA - it's irrelevant, since both
__GFP_DMA and non-_GFP_DMA allocations will come from the DMA zone
when the normal zone is empty.  Where the normal zone is _never_
populated with any memory, defining __GFP_DMA to zero will have no
effect.

So, let me repeat: it makes much much much more sense to get rid of
__GFP_DMA _and_ the normal and highmem zones than it does to get rid
of the DMA zone.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
