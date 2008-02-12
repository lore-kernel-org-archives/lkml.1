Return-Path: <linux-kernel-owner+w=401wt.eu-S1760597AbYBLPwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760597AbYBLPwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753635AbYBLPwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:52:08 -0500
Received: from mga06.intel.com ([134.134.136.21]:20940 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753568AbYBLPwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:52:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,341,1199692800"; 
   d="scan'208";a="257590320"
Date: Tue, 12 Feb 2008 07:54:48 -0800
From: mark gross <mgross@linux.intel.com>
To: David Miller <davem@davemloft.net>
Cc: muli@il.ibm.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH]intel-iommu batched iotlb flushes
Message-ID: <20080212155448.GC27490@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <20080211224105.GB24412@linux.intel.com> <20080212085256.GF5750@rhun.haifa.ibm.com> <20080212.010006.255202479.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212.010006.255202479.davem@davemloft.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 01:00:06AM -0800, David Miller wrote:
> From: Muli Ben-Yehuda <muli@il.ibm.com>
> Date: Tue, 12 Feb 2008 10:52:56 +0200
> 
> > The streaming DMA-API was designed to conserve IOMMU mappings for
> > machines where IOMMU mappings are a scarce resource, and is a poor
> > fit for a modern IOMMU such as VT-d with a 64-bit IO address space
> > (or even an IOMMU with a 32-bit address space such as Calgary) where
> > there are plenty of IOMMU mappings available.
> 
> For the 64-bit case what you are suggesting eventually amounts
> to mapping all available RAM in the IOMMU.

Something could be done:
we could enable drivers to have DMA-pools they manage that get mapped
and are re-used.

I would rather the DMA-pools be tied to PID's that way any bad behavior
would be limited to the address space of the process using the device.
I haven't thought about how hard this would be to do but it would be
nice.  I think this could be tricky.

Application sets up ring buffer of device DMA memory, passes this to
driver/stack.  Need to handle hitting high water marks and application
exit clean up sanely... 

--mgross

> 
> Although an extreme version of your suggestion, it would be the
> most efficient as it would require zero IOMMU flush operations.
> 
> But we'd lose things like protection and other benefits.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
