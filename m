Return-Path: <linux-kernel-owner+w=401wt.eu-S932225AbZHCVvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225AbZHCVvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 17:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbZHCVvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 17:51:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753386AbZHCVvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 17:51:08 -0400
Date: Mon, 3 Aug 2009 14:50:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
Subject: Re: [PATCH] gpio: include <linux/gpio.h> not <asm/gpio.h>
Message-Id: <20090803145050.8049bc20.akpm@linux-foundation.org>
In-Reply-To: <200907311059.51142.hartleys@visionengravers.com>
References: <200907311059.51142.hartleys@visionengravers.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009 10:59:50 -0700
H Hartley Sweeten <hartleys@visionengravers.com> wrote:

> Drivers should be including <linux/gpio.h> not <asm/gpio.h>.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> 
> ---
> 
> diff --git a/drivers/gpio/bt8xxgpio.c b/drivers/gpio/bt8xxgpio.c
> index 984b587..fd1c54d 100644
> --- a/drivers/gpio/bt8xxgpio.c
> +++ b/drivers/gpio/bt8xxgpio.c
> @@ -46,8 +46,7 @@
>  #include <linux/module.h>
>  #include <linux/pci.h>
>  #include <linux/spinlock.h>
> -
> -#include <asm/gpio.h>
> +#include <linux/gpio.h>

There's some potential for breakage here.  include/linux/gpio.h has

#ifdef CONFIG_GENERIC_GPIO
#include <asm/gpio.h>

#else

...

#endif


So if there's some configuration which forgot to set
CONFIG_GENERIC_GPIO, the driver will be switched over to use the
include/linux/gpio.h stubs and will break.

Please convince me that this cannot happen ;)
