Return-Path: <linux-kernel-owner+w=401wt.eu-S1761542AbYBLXqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761542AbYBLXqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYBLXqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:46:00 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59192
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752688AbYBLXp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:45:59 -0500
Date: Tue, 12 Feb 2008 15:46:30 -0800 (PST)
Message-Id: <20080212.154630.241691261.davem@davemloft.net>
To: mgross@linux.intel.com
Cc: muli@il.ibm.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH]intel-iommu batched iotlb flushes
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080212155448.GC27490@linux.intel.com>
References: <20080212085256.GF5750@rhun.haifa.ibm.com>
	<20080212.010006.255202479.davem@davemloft.net>
	<20080212155448.GC27490@linux.intel.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: mark gross <mgross@linux.intel.com>
Date: Tue, 12 Feb 2008 07:54:48 -0800

> Something could be done:
> we could enable drivers to have DMA-pools they manage that get mapped
> and are re-used.
> 
> I would rather the DMA-pools be tied to PID's that way any bad behavior
> would be limited to the address space of the process using the device.
> I haven't thought about how hard this would be to do but it would be
> nice.  I think this could be tricky.

Yes, this is a good idea especially for networking.

For transmit on 10GB links the IOMMU setup is near the top
of the profiles.

What a driver could do is determine the maximum number of
IOMMU pages it could need to map one maximally sized packet.
So then it allocates enough space for all such entries in
it's TX ring.

This eliminates the range allocation from the transmit path.
All that's left is "remap DMA range X to scatterlist Y"

And yes it would be nice to have dma_map_skb() type interfaces
so that we don't walk into the IOMMU code N times per packet.
