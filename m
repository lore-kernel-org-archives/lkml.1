Return-Path: <linux-kernel-owner+w=401wt.eu-S1030286AbXBTQyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030286AbXBTQyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:54:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030282AbXBTQyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:54:14 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:45065 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030285AbXBTQyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:54:10 -0500
Message-ID: <45DB27B0.70905@garzik.org>
Date: Tue, 20 Feb 2007 11:54:08 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH] pata_sl82c105: remove un-needed code paths
References: <20070220175151.4fcaa326@localhost.localdomain>
In-Reply-To: <20070220175151.4fcaa326@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> Remove the DMA setup function. As pointed out by Sergey we set the actual
> DMA clock timing in set_dmamode so we don't actually need to do anything
> with it at set up time, but just leave the PIO timings loaded.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ata/pata_sl82c105.c linux-2.6.20-mm2/drivers/ata/pata_sl82c105.c
> --- linux.vanilla-2.6.20-mm2/drivers/ata/pata_sl82c105.c	2007-02-20 13:37:58.000000000 +0000
> +++ linux-2.6.20-mm2/drivers/ata/pata_sl82c105.c	2007-02-20 13:58:10.000000000 +0000
> @@ -7,6 +7,13 @@
>   * 		SL82C105/Winbond 553 IDE driver
>   *
>   * and in part on the documentation and errata sheet
> + *
> + *
> + * Note: The controller like many controllers has shared timings for
> + * PIO and DMA. We thus flip to the DMA timings in dma_start and flip back
> + * in the dma_stop function. Thus we actually don't need a set_dmamode
> + * method as the PIO method is always called and will set the right PIO
> + * timing parameters.
>   */
>  
>  #include <linux/kernel.h>
> @@ -19,7 +26,7 @@
>  #include <linux/libata.h>
>  
>  #define DRV_NAME "pata_sl82c105"
> -#define DRV_VERSION "0.2.3"
> +#define DRV_VERSION "0.2.5"

applied

