Return-Path: <linux-kernel-owner+w=401wt.eu-S1758154AbZIQMbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154AbZIQMbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 08:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754958AbZIQMbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 08:31:24 -0400
Received: from h155.mvista.com ([63.81.120.155]:6126 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753354AbZIQMbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 08:31:23 -0400
Message-ID: <4AB22CAB.1080905@ru.mvista.com>
Date: Thu, 17 Sep 2009 16:33:47 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-usb@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Sonic Zhang <sonic.zhang@analog.com>, Cliff Cai <cliff.cai@analog.com>
Subject: Re: [PATCH 05/11] USB: musb: add notes for Blackfin anomalies
References: <1253144325-1203-1-git-send-email-vapier@gentoo.org> <1253144325-1203-5-git-send-email-vapier@gentoo.org>
In-Reply-To: <1253144325-1203-5-git-send-email-vapier@gentoo.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Mike Frysinger wrote:

> From: Sonic Zhang <sonic.zhang@analog.com>

> Add some helpful notes about how the driver works around different
> anomalies that exist in the on-chip host controller.
> 
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

    Grammar and style nipicking follows... :-)

> diff --git a/drivers/usb/musb/blackfin.h b/drivers/usb/musb/blackfin.h
> index a240c1e..de62962 100644
> --- a/drivers/usb/musb/blackfin.h
> +++ b/drivers/usb/musb/blackfin.h
> @@ -14,6 +14,35 @@
>   * Blackfin specific definitions
>   */
>  
> +/* Anomalies notes:
> + *
> + *  05000450 - USB DMA Mode 1 Short Packet Data Corruption:
> + *             MUSB driver is designed to transfer buffer of N * maxpacket size
> + *             in DMA mode 1 and leave rest data to the next transfer in DMA
> + *             mode 0, so we never transmit a short packet in DMA mode 1.
> + *
> + *  05000463 - This anomaly doesn't affect this driver,Since it

    No comma needed here, and why capitalize "since"?

> + *             never uses L1 or L2 memory as data destination.
> + *
> + *  05000464 - This anomaly doesn't affect this driver,Since it

    Same here...

> + *             never uses L1 or L2 memory as data source.
> + *
> + *  05000465 - Actually,the anomaly still can be seen when SCLK
> + *             is over 100 MHz,and there is no way to workaround
> + *             for bulk endpoints,because the wMaxPackSize of bulk
> + *             is less than or equal to 512,while the fifo size of

    Shouldn't there be spaces after commas?

> + *             endpoint 5,6,7 is 1024,the double buffer mode is

    Either comma doesn't fit here, or "so" is needed after it...

> + *             enabled automatically when these endpoints are used
> + *             for bulk OUT.
> + *
> + *  05000466 - This anomaly doesn't affect this driver,Since it

    No comma or uppercase needed...

> + *             never mixs concurrent DMA and core accesses to the

    "Mixes"...

> + *             TX endpoint FIFOs.

WBR, Sergei
