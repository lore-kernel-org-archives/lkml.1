Return-Path: <linux-kernel-owner+w=401wt.eu-S1753031AbYIYGzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbYIYGzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 02:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYIYGy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 02:54:56 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:32579 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbYIYGy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 02:54:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=WT0nb3HhyDIylSWqSOVqYNf3QHEsUTFa79pE3AhAiODZGkjawXDIhuUlojaqZYorj9
         F1XbL6FcqIJ3NHrsI0ercZnGQlx3+IFaCM34PkKPuiFH8EVqLDrSzu6fG+SrWpdK1CzN
         e72N4ScYfPjZYQMJlkey1Ky9cgrWkARmYyS1I=
Message-ID: <2a27d3730809242354u4cc24b96yda3973bfc3ddac92@mail.gmail.com>
Date: Thu, 25 Sep 2008 14:54:54 +0800
From: "Li Yang" <leoli@freescale.com>
To: "Timur Tabi" <timur@freescale.com>
Subject: Re: [PATCH v2] fsl-dma: allow Freescale Elo DMA driver to be compiled as a module
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       dan.j.williams@intel.com
In-Reply-To: <1222293567-17694-1-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222293567-17694-1-git-send-email-timur@freescale.com>
X-Google-Sender-Auth: b16961991502c5a5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 5:59 AM, Timur Tabi <timur@freescale.com> wrote:
> Modify the Freescale Elo / Elo Plus DMA driver so that it can be compiled as
> a module.
>
> The primary change is to stop treating the DMA controller as a bus, and the
> DMA channels as devices on the bus.  This is because the Open Firmware (OF)
> kernel code does not allow busses to be removed, so although we can call
> of_platform_bus_probe() to probe the DMA channels, there is no
> of_platform_bus_remove().  Instead, the DMA channels are manually probed,
> similar to what fsl_elbc_nand.c does.
>
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
>
> v2: updated per comments
>
> This patch is for the 2.6.28 kernel.  This patch exposes a bug in the dmatest
> module, so my other patch "dmatest: properly handle duplicate DMA channels"
> should be applied if this patch is applied.
[snip]
> +static void __exit of_fsl_dma_exit(void)
> +{
> +       of_unregister_platform_driver(&of_fsl_dma_driver);
>  }
>
> -subsys_initcall(of_fsl_dma_chan_init);
>  subsys_initcall(of_fsl_dma_init);

Not a critical problem.  But module_init() are preferred for modules.

> +module_exit(of_fsl_dma_exit);
> +
> +MODULE_DESCRIPTION("Freescale Elo / Elo Plus DMA driver");
> +MODULE_LICENSE("GPL");

Acked-by: Li Yang <leoli@freescale.com>

- Leo
