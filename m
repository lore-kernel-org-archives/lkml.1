Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbYLJOXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbYLJOXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 09:23:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYLJOXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 09:23:42 -0500
Received: from mga14.intel.com ([143.182.124.37]:27077 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbYLJOXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 09:23:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,747,1220252400"; 
   d="scan'208";a="88616059"
Date: Wed, 10 Dec 2008 22:23:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Gilad Ben-Yossef <gilad@codefidence.com>
Cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
       LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: use stack allocation for struct usb_ctrlrequest
Message-ID: <20081210142301.GA11490@localhost>
References: <20081210073247.GA18630@localhost> <200812101040.09886.laurent.pinchart@skynet.be> <20081210124308.GB6772@localhost> <493FCD12.30000@codefidence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493FCD12.30000@codefidence.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 04:07:14PM +0200, Gilad Ben-Yossef wrote:
> Wu Fengguang wrote:
> 
> > Hi Laurent,
> >
> > On Wed, Dec 10, 2008 at 11:40:09AM +0200, Laurent Pinchart wrote:
> >   
> >> Hi Wu,
> >>
> >> On Wednesday 10 December 2008, Wu Fengguang wrote:
> >>     
> >>> sizeof(struct usb_ctrlrequest) = 8, which is as small as the *dt pointer
> >>> in a 64bit system.
> >>>       
> >> The usb_ctrlrequest pointer is passed down to the hardware and must point to 
> >> DMA-able memory. For this reason you can't use the stack and must kmalloc() 
> >> the structure.
> >>     
> >
> > Ah thanks for the background. Does GFP_NOIO guarantee that?
> >   
> No, GFP_NOIO means - do not generate block IO operations (e.g. move 
> pages to swap, sync dirty buffers to permanent storage etc.) in order to 
> fulfill this allocation.
> 
> The reason for this flag here is presumably that such block IO 
> operations may very cause USB transaction of the very same kind we're 
> trying to service now, which can easily get us to a loop.

Right.

> > e.g. what if the memory is allocated from ZONE_HIGHMEM?
> >   
> In many cases there is no problem to DMA high memory. If you happen to 
> be working with a device that does have problems with full 32 bit 
> addresses then GFP_DMA would be the right flag, not GFP_NOIO.

For 64bit systems, we can easily go beyond 4GB physical memory.
So at least we should add GFP_DMA32 in addition to GFP_NOIO?

Thanks,
Fengguang

