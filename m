Return-Path: <linux-kernel-owner+w=401wt.eu-S1762861AbXEXEDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762861AbXEXEDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 00:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758974AbXEXEDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 00:03:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50906 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758457AbXEXEDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 00:03:04 -0400
Date: Wed, 23 May 2007 21:03:02 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Mackerras <paulus@samba.org>
cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: Define CONFIG_BOUNCE to avoid useless inclusion of bounce buffer
 logic.
In-Reply-To: <18005.2746.374990.29287@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.64.0705232056400.24495@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705212100420.24947@schroedinger.engr.sgi.com>
 <20070522133906.ae9c362a.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0705212225590.25388@schroedinger.engr.sgi.com>
 <20070523140702.GA16972@flint.arm.linux.org.uk>
 <Pine.LNX.4.64.0705231011000.19822@schroedinger.engr.sgi.com>
 <18005.2746.374990.29287@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007, Paul Mackerras wrote:

> That is (presumably) true today, but is in fact a redefinition of what
> ZONE_DMA historically was for.

I do not know too much about the history but when I tried to correlate
all the different ways that arches use the zone this definition was the 
most consistent between all of them. Add the fact that we always had the
MAX_DMA_ADDRESS limit for DMA. I think the history is due to the 
platform at the time only being able to do DMA to low memory addresses.

The definition of ZONE_DMA is rather problematic. The only common 
denominator is the limitaiton by MAX_DMA_ADDRESS. But that limit varies
from platform to platform. Thus the meaning of GFP_DMA is also varying 
from platfom to platform.
 
> Also there is the problem that some drivers use ZONE_DMA allocations
> because their device can only generate addresses below some limit, but
> on a platform with an IOMMU there is in fact no restriction on what
> memory the device can access.

That problem is to some extend addressed by switching ZONE_DMA off which 
results in GFP_DMA becoming meaningless. And if GFP_DMA and ZONE_DMA is 
gone from a platform then the MAX_DMA_ADDRESS inconsistencies are solved 
since the cause of the inconsistencies has evaporated.

