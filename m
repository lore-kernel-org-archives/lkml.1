Return-Path: <linux-kernel-owner+w=401wt.eu-S1762145AbXHDCPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762145AbXHDCPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 22:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756287AbXHDCPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 22:15:33 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:19550 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970AbXHDCPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 22:15:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fZokcezuRfQtmx6Clm8yhZd/vd4mjlNMKOYyjGQ3KCyUicvcmmWec9Y+5H9B+AXTJ9reIlDzcOJ7xKpqTPiCEokx+UWmHJm0gMDIpnPkHtXz/S3JF2u+x4BIINF01VXVhXwu3V++dNfpPyULT1gMO+6fkROpiv6mtVoQZGmr1VQ=
Message-ID: <e9c3a7c20708031915y1fee8c62i9da0f42cddbb44dd@mail.gmail.com>
Date: Fri, 3 Aug 2007 19:15:31 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: [-mm patch] DMA engine kconfig improvements
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Shannon Nelson" <shannon.nelson@intel.com>,
       linux-kernel@vger.kernel.org, "Wolfgang Denk" <wd@denx.de>
In-Reply-To: <20070726052628.GL3572@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070725040304.111550f4.akpm@linux-foundation.org>
	 <20070726052628.GL3572@stusta.de>
X-Google-Sender-Auth: 3fb32596b562f992
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.22-rc6-mm1:
> >...
> > +dma-arch-fix.patch
> >
> >  Fix git-dma.patch
> >...
>
> This results in an ARM-only driver in an X86-only menu...
>
> What about the patch below instead that also improves a few other things?
I like it, just a few nits:

> -menu "DMA Engine support"
> -       depends on HAS_DMA
> +menuconfig DMADEVICES
> +       bool "DMA Engine support"
> +       depends on (PCI && X86) || ARCH_IOP32X || ARCH_IOP33X || ARCH_IOP13XX
> +       help
> +         Intel(R) DMA engines
> +
Perhaps we should go ahead and define ARCH_HAS_DMA_OFFLOAD and have
DMADEVICES depend on that option.  A ppc32 driver is in the works:
http://marc.info/?l=linux-raid&m=117400143317440&w=2

> +if DMADEVICES
> +
> +comment "DMA Devices"
> +
> +config INTEL_IOATDMA
> +       tristate "Intel I/OAT DMA support"
> +       depends on PCI && X86
> +       select DMA_ENGINE
> +       select DCA
> +       help
> +         Enable support for the Intel(R) I/OAT DMA engine present
> +         in recent Intel Xeon CPUs.
> +
> +         Say yes if you have such a CPU.
It is actually in recent chipsets, not the CPU, but yes the user
should have more help making this decision.

Regards,
Dan (for Shannon while he is on vacation)
