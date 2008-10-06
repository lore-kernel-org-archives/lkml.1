Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbYJFIz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbYJFIz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 04:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbYJFIzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 04:55:13 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:34388 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbYJFIzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 04:55:10 -0400
Date: Mon, 6 Oct 2008 11:54:44 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Alan Cox <alan@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/19] modinfo: Remove duplicate modinfo from some
	drivers
Message-ID: <20081006085444.GB25182@cs181140183.pp.htv.fi>
References: <20081005163302.3799.61899.stgit@localhost.localdomain> <20081005163858.3799.47269.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20081005163858.3799.47269.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 05:39:08PM +0100, Alan Cox wrote:
> 
> ---
> 
>  drivers/input/tablet/wacom_sys.c            |    4 ++++
>  drivers/media/video/cx23885/cx23885-video.c |    4 ----
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
> index 5fbc463..b7c372f 100644
> --- a/drivers/input/tablet/wacom_sys.c
> +++ b/drivers/input/tablet/wacom_sys.c
> @@ -394,5 +394,9 @@ static void __exit wacom_exit(void)
>  	usb_deregister(&wacom_driver);
>  }
>  
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);
> +MODULE_LICENSE(DRIVER_LICENSE);

This adds one more duplication.

The current duplication comes from the fact the MODULE_* are in
wacom.h (sic) which gets #include'd from two C files.

Your patch is most likely correct if you also remove the MODULE_*
from wacom.h.

>  module_init(wacom_init);
>  module_exit(wacom_exit);
> diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
> index 6047c78..022adc3 100644
> --- a/drivers/media/video/cx23885/cx23885-video.c
> +++ b/drivers/media/video/cx23885/cx23885-video.c
> @@ -40,10 +40,6 @@
>  #include <linux/videodev.h>
>  #endif
>  
> -MODULE_DESCRIPTION("v4l2 driver module for cx23885 based TV cards");
> -MODULE_AUTHOR("Steven Toth <stoth@linuxtv.org>");
> -MODULE_LICENSE("GPL");
> -
>  /* ------------------------------------------------------------------ */
>  
>  static unsigned int video_nr[] = {[0 ... (CX23885_MAXBOARDS - 1)] = UNSET };

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

