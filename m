Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbYGBRxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbYGBRxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 13:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbYGBRxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 13:53:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751185AbYGBRxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 13:53:08 -0400
Date: Wed, 2 Jul 2008 10:53:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [PATCH] mfd: fix a bug in the asic3 irq demux code
Message-Id: <20080702105303.990e6395.akpm@linux-foundation.org>
In-Reply-To: <1215020573.24941.1.camel@localhost.localdomain>
References: <1215020573.24941.1.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 Jul 2008 19:42:53 +0200 Philipp Zabel <philipp.zabel@gmail.com> wrote:

> Wrong irq numbers were given to desc->handle_irq, which
> on some devices caused endless loops (asic3_irq_demux
> calling itself, basically).
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> ---
>  drivers/mfd/asic3.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
> index 8e41130..59ec9c6 100644
> --- a/drivers/mfd/asic3.c
> +++ b/drivers/mfd/asic3.c
> @@ -308,7 +308,7 @@ static void asic3_irq_demux(unsigned int irq, struct irq_desc *desc)
>  		for (i = ASIC3_NUM_GPIOS; i < ASIC3_NR_IRQS; i++) {
>  			/* They start at bit 4 and go up */
>  			if (status & (1 << (i - ASIC3_NUM_GPIOS + 4))) {
> -				desc = irq_desc +  + i;
> +				desc = irq_desc + asic->irq_base + i;
>  				desc->handle_irq(asic->irq_base + i,
>  						 desc);
>  			}

hm, I seem to have a pile of mfd patches.  I'll look to offload those
on Samuel.

Samuel, will you be setting up an MFD git tree for linux-next?  (You
should, please).
