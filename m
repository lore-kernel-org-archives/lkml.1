Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966573Ab0BZXkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 18:40:19 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:39861 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966545Ab0BZXkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 18:40:17 -0500
Date: Fri, 26 Feb 2010 18:39:44 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: Ben Gardner <gardner.ben@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>
Subject: Re: [PATCH 1/3] gpiolib: add gpio_set_direction()
Message-ID: <20100226183944.56bfee13@droptest.queued.net>
In-Reply-To: <14e456b7d269efd860bb36c312de2bc4ad504dca.1267225701.git.gardner.ben@gmail.com>
References: <cover.1267225701.git.gardner.ben@gmail.com>
	<14e456b7d269efd860bb36c312de2bc4ad504dca.1267225701.git.gardner.ben@gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Feb 2010 17:26:24 -0600
Ben Gardner <gardner.ben@gmail.com> wrote:

> Combine gpio_direction_input() and gpio_direction_output() into
> gpio_set_direction().
> Add 'none' and 'inout' directions to the sysfs interface.
> 
> Signed-off-by: Ben Gardner <gardner.ben@gmail.com>
> CC: Andres Salomon <dilinger@collabora.co.uk>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: David Brownell <dbrownell@users.sourceforge.net>
> CC: Jani Nikula <ext-jani.1.nikula@nokia.com>
> ---
>  drivers/gpio/gpiolib.c     |  123 ++++++++++++++++++++++----------------------
>  include/asm-generic/gpio.h |    6 ++
>  include/linux/gpio.h       |    5 ++
>  3 files changed, 73 insertions(+), 61 deletions(-)
> 
[...]
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index 485eeb6..17c7642 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -41,6 +41,8 @@ struct module;
>   *	enabling module power and clock; may sleep
>   * @free: optional hook for chip-specific deactivation, such as
>   *	disabling module power and clock; may sleep
> + * @set_direction: configures signal "offset" as "direction" (0-3, bit0=input,
> + *	bit1=output) or returns error


How about something like the following for set_direction, so we're not
comparing magic bits?

/* gpio direction flags */
#define GPIO_DIR_NONE 0 
#define	GPIO_DIR_INPUT (1 << 0)
#define	GPIO_DIR_OUTPUT (1 << 1)

