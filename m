Return-Path: <linux-kernel-owner+w=401wt.eu-S935429AbZLPWbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935429AbZLPWbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935246AbZLPWbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:31:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43614 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932548AbZLPWbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:31:08 -0500
Date: Wed, 16 Dec 2009 14:30:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic/gpio.h: add some forward decls of the
 device struct
Message-Id: <20091216143032.b01644b0.akpm@linux-foundation.org>
In-Reply-To: <1260359619-15618-1-git-send-email-vapier@gentoo.org>
References: <1260359619-15618-1-git-send-email-vapier@gentoo.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Dec 2009 06:53:39 -0500
Mike Frysinger <vapier@gentoo.org> wrote:

> After the recent commit a4177ee7f, attempting to include asm-generic/gpio.h
> in otherwise "slim" code results in ugly warnings like so:
> 
>   CC      arch/blackfin/kernel/bfin_gpio.o
> In file included from arch/blackfin/include/asm/gpio.h:278,
>                  from arch/blackfin/kernel/bfin_gpio.c:15:
> include/asm-generic/gpio.h:193: warning:
> ___struct device___ declared inside parameter list
> its scope is only this definition or declaration, which is probably not what you want
> 
> So add simple C forward decls of the struct device to avoid these.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  include/asm-generic/gpio.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index 66d6106..204bed3 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -28,6 +28,7 @@ static inline int gpio_is_valid(int number)
>  	return ((unsigned)number) < ARCH_NR_GPIOS;
>  }
>  
> +struct device;
>  struct seq_file;
>  struct module;
>  
> @@ -181,6 +182,8 @@ static inline void gpio_set_value_cansleep(unsigned gpio, int value)
>  
>  #ifndef CONFIG_GPIO_SYSFS
>  
> +struct device;
> +
>  /* sysfs support is only available with gpiolib, where it's optional */
>  
>  static inline int gpio_export(unsigned gpio, bool direction_may_change)

There was no need to add duplicated forward declarations.  Just move
them all to the top, outside ifdefs.
