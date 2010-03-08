Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab0CHQe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 11:34:56 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36157 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333Ab0CHQes convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 11:34:48 -0500
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: Mike Frysinger <vapier@gentoo.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Felipe Balbi <felipe.balbi@nokia.com>
CC: "stable@kernel.org" <stable@kernel.org>,
       "stable-review@kernel.org" <stable-review@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sonic Zhang <sonic.zhang@analog.com>
Date: Mon, 8 Mar 2010 22:01:45 +0530
Subject: RE: [PATCH] USB: musb: fix build error introduced by isoc change
Thread-Topic: [PATCH] USB: musb: fix build error introduced by isoc change
Thread-Index: Acq+26YzuNfvU4OJR3ug3Lt1blFnVQAATIaw
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB0321623721@dbde02.ent.ti.com>
References: <1268065561-24350-1-git-send-email-vapier@gentoo.org>
In-Reply-To: <1268065561-24350-1-git-send-email-vapier@gentoo.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> 
> From: Sonic Zhang <sonic.zhang@analog.com>
> 
> The recent commit "usb: musb: Fix for isochronous IN transfer" (f82a689fa)
> seems to have been against an older kernel version.  It uses the old style
> naming of variables.  Unfortunately, this breaks building for most MUSB
> users out there since "bDesiredMode" has been renamed to "desired_mode".
> 

Looks like this code is under a "#ifdef USE_MODE1" check; that's why
we did not find this during regular builds. Felipe's upcoming patches
would make this code redundant anyway.

Till then, we might as well fix it.

> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: Anand Gadiyar <gadiyar@ti.com>

> ---
>  drivers/usb/musb/musb_host.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
> index d21fffa..ef29f38 100644
> --- a/drivers/usb/musb/musb_host.c
> +++ b/drivers/usb/musb/musb_host.c
> @@ -1689,7 +1689,7 @@ void musb_host_rx(struct musb *musb, u8 epnum)
>                                 dma->desired_mode = 1;
>                         if (rx_count < hw_ep->max_packet_sz_rx) {
>                                 length = rx_count;
> -                               dma->bDesiredMode = 0;
> +                               dma->desired_mode = 0;
>                         } else {
>                                 length = urb->transfer_buffer_length;
>                         }
> 