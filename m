Return-Path: <linux-kernel-owner+w=401wt.eu-S932857AbYD3XWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857AbYD3XWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbYD3XWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:22:45 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:54283 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756008AbYD3XWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:22:44 -0400
X-Greylist: delayed 1244 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2008 19:22:43 EDT
Message-ID: <4818FA62.9020503@snapgear.com>
Date: Thu, 01 May 2008 09:01:54 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Sebastian Siewior <bigeasy@linutronix.de>
CC: Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: Add info about removing mcfserial
References: <20080430201408.GA22731@Chamillionaire.breakpoint.cc>
In-Reply-To: <20080430201408.GA22731@Chamillionaire.breakpoint.cc>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sebastian Siewior wrote:
> From: Sebastian Siewior <bigeasy@linutronix.de>
> 
> Schedule a removal for this driver. Alternative driver is
> available for a while now.
> 
> Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
> ---
> Greg said [1] and I hope .28 is not too late.
> [1] http://www.mail-archive.com/uclinux-dev@uclinux.org/msg04453.html

.28 is ok with me.

Regards
Greg



>  Documentation/feature-removal-schedule.txt |    8 ++++++++
>  drivers/serial/Kconfig                     |    6 +++++-
>  drivers/serial/mcfserial.c                 |    1 +
>  3 files changed, 14 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 3c35d45..27c0056 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -304,3 +304,11 @@ When:	2.6.26
>  Why:	Implementation became generic; users should now include
>  	linux/semaphore.h instead.
>  Who:	Matthew Wilcox <willy@linux.intel.com>
> +
> +---------------------------
> +
> +What:	old style serial driver for ColdFire (CONFIG_SERIAL_COLDFIRE)
> +When:	2.6.28
> +Why:	This driver still uses the old interface and has been replaced
> +	by CONFIG_SERIAL_MCF.
> +Who:	Sebastian Siewior <sebastian@breakpoint.cc>
> diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
> index 36acbcc..62e6eb1 100644
> --- a/drivers/serial/Kconfig
> +++ b/drivers/serial/Kconfig
> @@ -976,11 +976,15 @@ config SERIAL_68328_RTS_CTS
>  	depends on SERIAL_68328
>  
>  config SERIAL_COLDFIRE
> -	bool "ColdFire serial support"
> +	bool "ColdFire serial support (DEPRECATED)"
>  	depends on COLDFIRE
>  	help
>  	  This driver supports the built-in serial ports of the Motorola ColdFire
>  	  family of CPUs.
> +	  This driver is deprecated because it supports only the old interface
> +	  for serial drivers and features like magic keys are not working.
> +	  Please switch to the new style driver because this driver will be
> +	  removed soon.
>  
>  config SERIAL_MCF
>  	bool "Coldfire serial support (new style driver)"
> diff --git a/drivers/serial/mcfserial.c b/drivers/serial/mcfserial.c
> index 43af40d..56007cc 100644
> --- a/drivers/serial/mcfserial.c
> +++ b/drivers/serial/mcfserial.c
> @@ -1,3 +1,4 @@
> +#warning This driver is deprecated. Check Kconfig for details.
>  /*
>   * mcfserial.c -- serial driver for ColdFire internal UARTS.
>   *

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
