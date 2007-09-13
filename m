Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbXIMBPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbXIMBPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 21:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbXIMBPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 21:15:10 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55813 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbXIMBPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 21:15:09 -0400
Message-ID: <46E88F1B.5050405@garzik.org>
Date: Wed, 12 Sep 2007 21:15:07 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Kees Cook <kees@ubuntu.com>
CC: linux-kernel@vger.kernel.org, Ben Collins <bcollins@ubuntu.com>
Subject: Re: [PATCH] usb: fix unterminated usn_device_id lists
References: <20070913004709.GL8183@outflux.net>
In-Reply-To: <20070913004709.GL8183@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook wrote:
> This patch against 2.6.23-rc6 fixes a unterminated list of USB device ids.
> 
> Signed-off-by: Kees Cook <kees@ubuntu.com>
> ---
>  linux-2.6.23-rc6/drivers/media/video/usbvision/usbvision-cards.c |    1 +
>  1 file changed, 1 insertion(+)
> ---
> diff -urp -x '*.o' linux-2.6.23-rc6~/drivers/media/video/usbvision/usbvision-cards.c linux-2.6.23-rc6/drivers/media/video/usbvision/usbvision-cards.c
> --- linux-2.6.23-rc6~/drivers/media/video/usbvision/usbvision-cards.c	2007-09-11 23:17:19.000000000 -0700
> +++ linux-2.6.23-rc6/drivers/media/video/usbvision/usbvision-cards.c	2007-09-12 17:26:46.000000000 -0700
> @@ -1081,6 +1081,7 @@ struct usb_device_id usbvision_table [] 
>  	{ USB_DEVICE(0x2304, 0x0301), .driver_info=PINNA_LINX_VD_IN_CAB_PAL },
>  	{ USB_DEVICE(0x2304, 0x0419), .driver_info=PINNA_PCTV_BUNGEE_PAL_FM },
>  	{ USB_DEVICE(0x2400, 0x4200), .driver_info=HPG_WINTV },
> +	{ 0, },

FWIW I (and several drivers) tend to prefer the more clean version,

	{ },

or even

	{ },	/* terminate list */

Regards,

	Jeff



