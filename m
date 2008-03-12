Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbYCLXZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbYCLXZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 19:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbYCLXZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 19:25:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56444 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbYCLXZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 19:25:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47D8661A.4090809@s5r6.in-berlin.de>
Date: Thu, 13 Mar 2008 00:24:10 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: David Moore <dcm@MIT.EDU>
CC: Jarod Wilson <jwilson@redhat.com>, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: fw-ohci: sync AT dma buffer before use
References: <200803121743.29438.jwilson@redhat.com> <1205361349.19600.24.camel@aries.csail.mit.edu>
In-Reply-To: <1205361349.19600.24.camel@aries.csail.mit.edu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Moore wrote:
> 1. The dma_sync should probably be done before the context_append
> because the controller could in theory start reading the data as soon as
> context_append is called right?

Yes, but its syncing is superfluous anyway, as mentioned in the other 
post.  *If* it is doing something for Jarod's setup, then only because 
of side effects like memory barrier properties.

> 2. As an optimization, we should attempt to allocate the payload in the
> lower 32-bits of physical memory, to prevent extra memcopies on x86_64.
> I think this can be done by adding GFP_DMA32 to kmalloc where the
> payload was allocated in fw-cdev.c.  There might be other places where
> we would benefit from GFP_DMA32 also.  Of course, these optimizations
> are probably better saved for another patch.

I think so too.  GFP_DMA32 would be appropriate on machines with 
"software IOMMU" alias swiotlb.

Does GFP_DMA32 have adverse affects on machines with a real IOMMU?
-- 
Stefan Richter
-=====-==--- --== -==--
http://arcgraph.de/sr/
