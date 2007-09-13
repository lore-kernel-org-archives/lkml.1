Return-Path: <linux-kernel-owner+w=401wt.eu-S1763107AbXIMQzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763107AbXIMQzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 12:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbXIMQzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 12:55:45 -0400
Received: from as1.cineca.com ([130.186.84.251]:34227 "EHLO as1.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbXIMQzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 12:55:45 -0400
X-Greylist: delayed 6394 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Sep 2007 12:55:44 EDT
From: Luca Risolia <luca.risolia@studio.unibo.it>
Reply-To: luca.risolia@studio.unibo.it
To: aherrman@arcor.de
Subject: Re: [PATCH] v4l: Build error with et61x251, if V4L1_COMPAT is not selected
Date: Thu, 13 Sep 2007 17:07:16 +0200
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, linux-usb-devel@lists.sourceforge.net,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
References: <20070913123627.GD10348@devil>
In-Reply-To: <20070913123627.GD10348@devil>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709131707.16666.luca.risolia@studio.unibo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 September 2007 14:36:27 aherrman@arcor.de wrote:
> With current git tree I get an build error
> for et61x251, if V4L1_COMPAT is not selected:
>
> drivers/media/video/et61x251/et61x251_core.c: In et61x251_show_:
> drivers/media/video/et61x251/et61x251_core.c:718: error: implicit
> declaration of to_video_device
>
> Fix: add VIDEO_V4L1_COMPAT as a dependency for this driver.

No, wait. The driver really is V4L2 only. If you can, please fix it by 
replacing to_video_device() with container_of() instead:

cam = video_get_drvdata(container_of(cd, struct video_device, class_dev));

Best regards
Luca Risolia

>
> Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
> ---
>  drivers/media/video/et61x251/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/et61x251/Kconfig
> b/drivers/media/video/et61x251/Kconfig index dcc1a03..9143424 100644
> --- a/drivers/media/video/et61x251/Kconfig
> +++ b/drivers/media/video/et61x251/Kconfig
> @@ -1,6 +1,6 @@
>  config USB_ET61X251
>  	tristate "USB ET61X[12]51 PC Camera Controller support"
> -	depends on VIDEO_V4L2
> +	depends on VIDEO_V4L2 && VIDEO_V4L1_COMPAT
>  	---help---
>  	  Say Y here if you want support for cameras based on Etoms ET61X151
>  	  or ET61X251 PC Camera Controllers.


