Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYESPRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYESPRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbYESPRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:17:07 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50793 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbYESPRF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:17:05 -0400
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: Bryan Wu <cooloney@kernel.org>, "me@felipebalbi.com" <me@felipebalbi.com>,
       "david-b@pacbell.net" <david-b@pacbell.net>,
       "tony@atomide.com" <tony@atomide.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sonic Zhang <sonic.zhang@analog.com>
Date: Mon, 19 May 2008 20:46:32 +0530
Subject: RE: [PATCH 2/2] MUSB: Real fix bug 4 usb bugs found on Blackfin
Thread-Topic: [PATCH 2/2] MUSB: Real fix bug 4 usb bugs found on Blackfin
Thread-Index: Aci4DaY2wcf+n+eNTBe0f3PnT7hC2ABtTOeQ
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02225E79C1@dbde02.ent.ti.com>
References: <1211022081-27298-1-git-send-email-cooloney@kernel.org>
 <1211022081-27298-3-git-send-email-cooloney@kernel.org>
In-Reply-To: <1211022081-27298-3-git-send-email-cooloney@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am unable to visit any of these links. I get the following error "Unknown or invalid plugin: 'tracker'".

Regards,
Anand

> -----Original Message-----
> From: linux-usb-owner@vger.kernel.org
> [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of Bryan Wu
> Sent: Saturday, May 17, 2008 4:31 PM
> To: me@felipebalbi.com; david-b@pacbell.net; tony@atomide.com
> Cc: linux-omap@vger.kernel.org; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org; Bryan Wu; Sonic Zhang
> Subject: [PATCH 2/2] MUSB: Real fix bug 4 usb bugs found on Blackfin
>
>  - USB-IDE
>
> <http://blackfin.uclinux.org/gf/project/linux-kernel/tracker/?action=TrackerItemEdit&tracker_item_id=3789>
>  - 30G iPod
>
> <http://blackfin.uclinux.org/gf/project/linux-kernel/tracker/?action=TrackerItemEdit&tracker_item_id=3806>
>  - USB to CF/SD card reader
>
> <http://blackfin.uclinux.org/gf/project/linux-kernel/tracker/?action=TrackerItemEdit&tracker_item_id=3790>
>
> <http://blackfin.uclinux.org/gf/project/linux-kernel/tracker/?action=TrackerItemEdit&tracker_item_id=3807>
>
> Sonic found, when we got STALL, we should clear the toggle.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/usb/musb/musb_host.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/musb/musb_host.c
> b/drivers/usb/musb/musb_host.c
> index 535922d..806c479 100644
> --- a/drivers/usb/musb/musb_host.c
> +++ b/drivers/usb/musb/musb_host.c
> @@ -1473,7 +1473,7 @@ void musb_host_rx(struct musb *musb, u8 epnum)
>                         (void)
> musb->dma_controller->channel_abort(dma);
>                         xfer_len = dma->actual_len;
>                 }
> -               musb_h_flush_rxfifo(hw_ep, 0);
> +               musb_h_flush_rxfifo(hw_ep, MUSB_RXCSR_CLRDATATOG);
>                 musb_writeb(epio, MUSB_RXINTERVAL, 0);
>                 done = true;
>                 goto finish;
> --
> 1.5.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
