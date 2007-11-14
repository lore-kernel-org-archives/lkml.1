Return-Path: <linux-kernel-owner+w=401wt.eu-S1761464AbXKNV4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464AbXKNV4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764838AbXKNV4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:56:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46446 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764642AbXKNV4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:56:13 -0500
Date: Wed, 14 Nov 2007 13:45:43 -0800
From: Greg KH <greg@kroah.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Shannon Nelson <shannon.nelson@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, hskinnemoen@atmel.com,
       stable@kernel.org
Subject: Re: [stable] [PATCH] dmaengine: Fix broken device refcounting
Message-ID: <20071114214543.GC9901@kroah.com>
References: <1194461167.8489.6.camel@dwillia2-linux.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194461167.8489.6.camel@dwillia2-linux.ch.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 11:46:07AM -0700, Dan Williams wrote:
> From: Haavard Skinnemoen <hskinnemoen@atmel.com>
> 
> When a DMA device is unregistered, its reference count is decremented
> twice for each channel: Once dma_class_dev_release() and once in
> dma_chan_cleanup(). This may result in the DMA device driver's
> remove() function completing before all channels have been cleaned
> up, causing lots of use-after-free fun.
> 
> Fix it by incrementing the device's reference count twice for each
> channel during registration.
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> [dan.j.williams@intel.com: kill unnecessary client refcounting]
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Shannon Nelson <shannon.nelson@intel.com>
> Cc: stable@kernel.org

I don't see this in Linus's tree yet, right?

When it goes in, can you resend it to the stable@kernel.org people?

thanks,

greg k-h
