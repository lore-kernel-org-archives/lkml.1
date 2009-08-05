Return-Path: <linux-kernel-owner+w=401wt.eu-S934636AbZHEPJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934636AbZHEPJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 11:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934587AbZHEPJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 11:09:14 -0400
Received: from verein.lst.de ([213.95.11.210]:59965 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934577AbZHEPJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 11:09:13 -0400
Date: Wed, 5 Aug 2009 17:08:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Christoph Hellwig <hch@lst.de>, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: convert to asm-generic/hardirq.h
Message-ID: <20090805150856.GA5535@lst.de>
References: <20090804145244.GH20487@lst.de> <4A791067.3030405@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A791067.3030405@snapgear.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 02:53:59PM +1000, Greg Ungerer wrote:
> Hi Christoph,
> 
> Christoph Hellwig wrote:
> >Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Compile testing revealed:
> 
>   LD      vmlinux
> kernel/built-in.o: In function `ack_bad':
> handle.c:(.text+0x215f6): undefined reference to `ack_bad_irq'
> kernel/built-in.o: In function `handle_bad_irq':
> (.text+0x219dc): undefined reference to `ack_bad_irq'
> make[2]: *** [vmlinux] Error 1
> 
> 
> I did this to fix it:
> 
> --- a/arch/m68k/include/asm/hardirq_no.h
> +++ b/arch/m68k/include/asm/hardirq_no.h
> @@ -14,9 +14,6 @@
>  # error HARDIRQ_BITS is too low!
>  #endif
> 
> -void ack_bad_irq(unsigned int irq);
> -#define ack_bad_irq ack_bad_irq
> -

Sorry.  Yeah, m68knommu should use the default ack_bad_irq.

