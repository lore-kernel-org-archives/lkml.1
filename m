Return-Path: <linux-kernel-owner+w=401wt.eu-S1759350AbZFOIws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759350AbZFOIws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757733AbZFOIwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:52:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39421 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757293AbZFOIwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:52:22 -0400
Date: Mon, 15 Jun 2009 10:52:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Robert Love <rlove@google.com>
Subject: Re: [PATCH 1/3] [ARM] msm_serial: serial driver for MSM7K onboard
	serial peripheral.
Message-ID: <20090615085216.GC10822@elf.ucw.cz>
References: <1245033557-10968-1-git-send-email-swetland@google.com> <1245033557-10968-2-git-send-email-swetland@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245033557-10968-2-git-send-email-swetland@google.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Robert Love <rlove@google.com>
> 
> Signed-off-by: Brian Swetland <swetland@google.com>

Some kind of Changelog would be nice ( Enable support for serial
devices on MSM...), and I guess Robert's Signed-off-by: would be welcome.

> diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
> index 1132c5c..037c1e0 100644
> --- a/drivers/serial/Kconfig
> +++ b/drivers/serial/Kconfig
> @@ -1320,6 +1320,16 @@ config SERIAL_SGI_IOC3
>  	  If you have an SGI Altix with an IOC3 serial card,
>  	  say Y or M.  Otherwise, say N.
>  
> +config SERIAL_MSM
> +	bool "MSM on-chip serial port support"
> +	depends on ARM && ARCH_MSM
> +	select SERIAL_CORE
> +
> +config SERIAL_MSM_CONSOLE
> +	bool "MSM serial console support"
> +	depends on SERIAL_MSM=y

"depends on SERIAL_MSM" should be enough?


> diff --git a/drivers/serial/msm_serial.c b/drivers/serial/msm_serial.c
> new file mode 100644
> index 0000000..1a7c856
> --- /dev/null
> +++ b/drivers/serial/msm_serial.c
> @@ -0,0 +1,767 @@
> +/*
> + * drivers/serial/msm_serial.c - driver for msm7k serial device and console
> + *
> + * Copyright (C) 2007 Google, Inc.
> + * Author: Robert Love <rlove@google.com>
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#if defined(CONFIG_SERIAL_MSM_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
> +# define SUPPORT_SYSRQ
> +#endif

SUPPORT_SYSRQ seems to be unused.

> +#include <linux/hrtimer.h>

Are hrtimes required?

Otherwise seems to be okay (plus the issues someone pointed in other
email), you can add my acked-by:. I guess you should submit it to
rmk's patch system...
									Pavel 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
