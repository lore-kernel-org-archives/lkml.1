Return-Path: <linux-kernel-owner+w=401wt.eu-S1762149AbZCaQd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762149AbZCaQd7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 12:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbZCaQdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 12:33:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:56963 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbZCaQdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 12:33:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="399091402"
Message-ID: <49D245EA.80704@intel.com>
Date: Tue, 31 Mar 2009 09:33:46 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Guennadi Liakhovetski <lg@denx.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
Subject: Re: [PATCH] dmaengine: fix regression introduced by d6103085dfd83c13db65c3bd7e182f021d77c541
References: <Pine.LNX.4.64.0903311755540.4806@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0903311755540.4806@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> chan is an index variable, used to loop over a list of channels, and here 
> it is used _after_ the loop, in which case it doesn't point to a DMA 
> channel struct anymore. Dereferencing it leads to a corruption of a random 
> memory location, which in my case was a pointer inside a clock struct. Fix 
> it by using a local variable pointing to the DMA device.
> 
> Signed-off-by: Guennadi Liakhovetski <lg@denx.de>
> ---
> 
> Guys, this was a _real_ bad joke, cost me almost a day, and that patch has 
> been reviewed by two persons...
> 
> <rant>
> So far 2.6.29(-next) has been very bad for me, regressions all over the 
> place, lots of wasted time hunting them down:-(
> </rant>
> 

Guennadi,

Thanks for testing the 'next' branch and finding this before it hit 
mainline.  I will fold this change into the existing commit with a 
[lg@denx.de: fix bad usage of 'chan' in dma_async_device_register]

Regards,
Dan
