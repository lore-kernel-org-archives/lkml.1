Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbXEOTtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbXEOTtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 15:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbXEOTtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 15:49:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:55488 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbXEOTtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 15:49:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=XAgEsSc2CxlJNVGZ5Fj6B6dOFko4Do4SpuyQ3jSF1gw0UWxm+DhPNjPYFAxOkWkuU7itfv5rkpiyYmnj996fL0eO5CQAg/4DCWoo5UgBDjouW3mBIxdamEe/47bpkwgNF//o7dyXZCcC9HzrCwPK4kiJM83T6gQ7h0CV1zlV5EU=
Date: Tue, 15 May 2007 23:50:06 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mchehab@infradead.org
Subject: Re: [PATCH] em28xx and ivtv should depend on PCI
Message-ID: <20070515195006.GA5669@martell.zuzino.mipt.ru>
References: <E1Ho2p6-0003Tt-B7@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Ho2p6-0003Tt-B7@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2007 at 08:36:40PM +0100, Al Viro wrote:
> --- a/drivers/media/video/ivtv/Kconfig
> +++ b/drivers/media/video/ivtv/Kconfig
> @@ -1,6 +1,6 @@
>  config VIDEO_IVTV
>  	tristate "Conexant cx23416/cx23415 MPEG encoder/decoder support"
> -	depends on VIDEO_V4L1 && VIDEO_V4L2 && USB && I2C && EXPERIMENTAL
> +	depends on VIDEO_V4L1 && VIDEO_V4L2 && USB && I2C && EXPERIMENTAL && PCI
>  	select FW_LOADER
>  	select VIDEO_TUNER
>  	select VIDEO_TVEEPROM

Don't forget to remove #error:

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

--- a/drivers/media/video/ivtv/ivtv-driver.h
+++ b/drivers/media/video/ivtv/ivtv-driver.h
@@ -71,10 +71,6 @@ #ifdef CONFIG_LIRC_I2C
 #  error "This driver is not compatible with the LIRC I2C kernel configuration option."
 #endif /* CONFIG_LIRC_I2C */
 
-#ifndef CONFIG_PCI
-#  error "This driver requires kernel PCI support."
-#endif /* CONFIG_PCI */
-
 #define IVTV_ENCODER_OFFSET	0x00000000
 #define IVTV_ENCODER_SIZE	0x00800000	/* Last half isn't needed 0x01000000 */
 

