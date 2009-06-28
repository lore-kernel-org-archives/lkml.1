Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbZF1QAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbZF1QAh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbZF1QA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:00:29 -0400
Received: from www.tglx.de ([62.245.132.106]:36261 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbZF1QA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:00:28 -0400
Date: Sun, 28 Jun 2009 18:00:21 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: vijay baskar <cn.vijaibaskar@gdatech.co.in>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: UIO driver for framebuffer
Message-ID: <20090628160021.GC3639@local>
References: <4A436265.4050502@gdatech.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A436265.4050502@gdatech.co.in>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 05:11:25PM +0530, vijay baskar wrote:
> Hi all,
>
> I have written a uio driver for framebuffer device.

Why? Framebuffer devices should be handled by the framebuffer subsystem which
already makes the framebuffer accessible from userspace in a way that's
supported by many userspace libraries. Why do you want to reinvent the wheel
in an incompatible way?

> I added device  
> specific register memory in uio.mem. I also added DMA param memory in  
> uio.mem to perform DMA from userspace. Also video RAM  
> <http://fixunix.com/#> was mapped in kernel space using  
> dma_alloc_coherent() and a logical address was obtained. This logical  
> address was also added in uio.mem with memtype as UIO_MEM_LOGICAL  
> because i can fill video ram from userspace.Read and write to this DMA  
> param memory from userspace is not having any effect. Also video RAM  
> memory that i filled up is not getting written to the framebuffer device  
> when DMA is started. Also one more info that i noted was that values  
> assigned to logical addresses in kernel space are not reflected in  
> userspace after mmap. The values in userspace show different values  
> compared to that in kernel space.
> This is a bit confusing for me.

For me too.

> Why is this happening?? Have I missed  
> any information??

Yes, UIO is not for devices that are already supported by other subsystems.

> Am i on the right path??

I don't think so, unless you can provide good technical reasons for your
concept.

Thanks,
Hans

>
> regards,
> vijai
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
