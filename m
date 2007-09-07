Return-Path: <linux-kernel-owner+w=401wt.eu-S965485AbXIGP7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965485AbXIGP7k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 11:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932448AbXIGP7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 11:59:31 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:45730 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757546AbXIGP7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 11:59:31 -0400
Date: Fri, 7 Sep 2007 08:58:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Zhang Wei <wei.zhang@freescale.com>
Cc: paulus@samba.org, shannon.nelson@intel.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, galak@kernel.crashing.org,
       Ebony Zhu <ebony.zhu@freescale.com>
Subject: Re: [PATCH 5/5] Add DMA engine driver for Freescale MPC85xx
 processors.
Message-Id: <20070907085845.54dc88f8.randy.dunlap@oracle.com>
In-Reply-To: <11891624582950-git-send-email-wei.zhang@freescale.com>
References: <11891624582950-git-send-email-wei.zhang@freescale.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 Sep 2007 18:54:18 +0800 Zhang Wei wrote:

> Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
> Signed-off-by: Ebony Zhu <ebony.zhu@freescale.com>
> ---
>  drivers/dma/Kconfig  |    8 +
>  drivers/dma/Makefile |    1 +
>  drivers/dma/fsldma.c |  995 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/dma/fsldma.h |  188 ++++++++++
>  4 files changed, 1192 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/dma/fsldma.c
>  create mode 100644 drivers/dma/fsldma.h
> 
> --- /dev/null
> +++ b/drivers/dma/fsldma.c
> @@ -0,0 +1,995 @@

Thanks for using kernel-doc notation.  However, ...

> +/**
> + * fsl_dma_alloc_descriptor - Allocate descriptor from channel's DMA pool.

Function parameters need to be listed & described here.
See Documentation/kernel-doc-nano-HOWTO.txt or other source files
for examples.

(Applies to all documented function interfaces here.)

> + *
> + * Return - The descriptor allocated. NULL for failed.
> + */
> +static struct fsl_desc_sw *fsl_dma_alloc_descriptor(
> +					struct fsl_dma_chan *fsl_chan,
> +					gfp_t flags)
> +{
...
> +}

> +/**
> + * fsl_chan_xfer_ld_queue -- Transfer the link descriptors in channel
> + *                           ld_queue.

The function's "short description" (unfortunately) must be on only one
line.  E.g.:

 * fsl_chan_xfer_ld_queue - Transfer link descriptors in channel ld_queue.

> + */
> +static void fsl_chan_xfer_ld_queue(struct fsl_dma_chan *fsl_chan)
> +{
...
> +}

> diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
> new file mode 100644
> index 0000000..05be9ed
> --- /dev/null
> +++ b/drivers/dma/fsldma.h
> @@ -0,0 +1,188 @@
> +struct fsl_dma_chan_regs {
> +	__mix32	mr;		/* 0x00 - Mode Register */
> +	__mix32	sr;		/* 0x04 - Status Register */
> +	__mix64	cdar;		/* 0x08 - Cureent descriptor address register */

                                          Current

> +	__mix64	sar;		/* 0x10 - Source Address Register */
> +	__mix64	dar;		/* 0x18 - Destination Address Register */
> +	__mix32	bcr;		/* 0x20 - Byte Count Register */
> +	__mix64	ndar;		/* 0x24 - Next Descriptor Address Register */
> +};

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
