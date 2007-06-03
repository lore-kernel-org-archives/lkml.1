Return-Path: <linux-kernel-owner+w=401wt.eu-S1752618AbXFCWY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbXFCWY7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 18:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbXFCWYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 18:24:53 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4200 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbXFCWYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 18:24:52 -0400
Date: Sun, 3 Jun 2007 23:24:39 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Christoph Lameter <clameter@sgi.com>
Cc: Paul Mackerras <paulus@samba.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: Define CONFIG_BOUNCE to avoid useless inclusion of bounce buffer logic.
Message-ID: <20070603222439.GA16422@flint.arm.linux.org.uk>
Mail-Followup-To: Christoph Lameter <clameter@sgi.com>,
	Paul Mackerras <paulus@samba.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	jens.axboe@oracle.com
References: <Pine.LNX.4.64.0705212100420.24947@schroedinger.engr.sgi.com> <20070522133906.ae9c362a.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0705212225590.25388@schroedinger.engr.sgi.com> <20070523140702.GA16972@flint.arm.linux.org.uk> <Pine.LNX.4.64.0705231011000.19822@schroedinger.engr.sgi.com> <18005.2746.374990.29287@cargo.ozlabs.ibm.com> <Pine.LNX.4.64.0705232056400.24495@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705232056400.24495@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 09:03:02PM -0700, Christoph Lameter wrote:
> On Thu, 24 May 2007, Paul Mackerras wrote:
> > Also there is the problem that some drivers use ZONE_DMA allocations
> > because their device can only generate addresses below some limit, but
> > on a platform with an IOMMU there is in fact no restriction on what
> > memory the device can access.
> 
> That problem is to some extend addressed by switching ZONE_DMA off which 
> results in GFP_DMA becoming meaningless. And if GFP_DMA and ZONE_DMA is 
> gone from a platform then the MAX_DMA_ADDRESS inconsistencies are solved 
> since the cause of the inconsistencies has evaporated.

Suffice it to say then that with this approach ARM will _never_ be able
to have ZONE_DMA turned off, even on platforms where there are no DMA
restrictions.  I guess that's something we'll just have to live with.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
