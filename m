Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbXJ2Tu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbXJ2Tu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbXJ2TuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:50:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:56667 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753316AbXJ2TuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:50:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,343,1188802800"; 
   d="scan'208";a="307935496"
From: Jesse Barnes <jesse.barnes@intel.com>
To: dri-devel@lists.sourceforge.net
Subject: Re: [RFC] AGP initial support for chipset flushing..
Date: Mon, 29 Oct 2007 12:47:23 -0700
User-Agent: KMail/1.9.7
Cc: Dave Airlie <airlied@skynet.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sourceforge.net, keithp@keithp.com
References: <Pine.LNX.4.64.0710290811070.1170@skynet.skynet.ie>
In-Reply-To: <Pine.LNX.4.64.0710290811070.1170@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710291247.24791.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 29, 2007 1:15 am Dave Airlie wrote:
> Hi,
>
> We've uncovered a need when using the new memory manager to flush the
> chipset global write buffers on certain intel chipset due to a lack
> of coherency..
>
> The attached patches add a new AGP interface  for this purpose and
> implements this in the Intel AGP driver. This stuff is based of some
> guesswork in the 915 case from comments in the documentation :).

In this case, we're performing basically a dma_sync*(...DMA_TO_DEVICE) 
right?  Can we be sure that a single flush is sufficient?  Is there any 
window between when we flush and when we start accessing memory with 
the device that we could get into more caching trouble?

> Unfortuantely the 965 BIOS doesn't set this stuff up properly and it
> doesn't use a standard BAR address, so I have to do it by hand, I'd
> appreciate any commentary particularly in the setting up of the
> resource stuff.

Looks reasonable, I'm not sure we can do much better.  The only concern 
I have is that allocating some more PCI space like that may end up 
clobbering some *other* hidden BIOS mapping, but there's not a whole 
lot we can do about that.

Jesse
