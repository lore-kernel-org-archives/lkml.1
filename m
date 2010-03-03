Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0CCS4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 13:56:12 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52720 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab0CCS4K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:56:10 -0500
MIME-Version: 1.0
In-Reply-To: <20100303.025026.243831910.davem@davemloft.net>
References: <20100303.025026.243831910.davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 3 Mar 2010 11:55:49 -0700
X-Google-Sender-Auth: 8ddf2a1953b5f30b
Message-ID: <fa686aa41003031055o25fd62b6u3c68d6b69d7c6d1@mail.gmail.com>
Subject: Re: [PATCH] uartlite: Fix build on sparc.
To: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 3, 2010 at 3:50 AM, David Miller <davem@davemloft.net> wrote:
>
> We can get this driver enabled via MFD_TIMBERDALE which only
> requires GPIO to be on.
>
> But the of_address_to_resource() function is only present on
> powerpc and microblaze, so we have to conditionalize the
> CONFIG_OF probing bits on that.
>
> Signed-off-by: David S. Miller <davem@davemloft.net>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

Linus or Greg, can you please pick this bug fix up?

Thanks,
g.

>
> diff --git a/drivers/serial/uartlite.c b/drivers/serial/uartlite.c
> index ab2ab3c..f0a6c61 100644
> --- a/drivers/serial/uartlite.c
> +++ b/drivers/serial/uartlite.c
> @@ -19,7 +19,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/init.h>
>  #include <asm/io.h>
> -#if defined(CONFIG_OF)
> +#if defined(CONFIG_OF) && (defined(CONFIG_PPC32) || defined(CONFIG_MICROBLAZE))
>  #include <linux/of.h>
>  #include <linux/of_device.h>
>  #include <linux/of_platform.h>
> @@ -581,7 +581,7 @@ static struct platform_driver ulite_platform_driver = {
>  /* ---------------------------------------------------------------------
>  * OF bus bindings
>  */
> -#if defined(CONFIG_OF)
> +#if defined(CONFIG_OF) && (defined(CONFIG_PPC32) || defined(CONFIG_MICROBLAZE))
>  static int __devinit
>  ulite_of_probe(struct of_device *op, const struct of_device_id *match)
>  {
> @@ -631,11 +631,11 @@ static inline void __exit ulite_of_unregister(void)
>  {
>        of_unregister_platform_driver(&ulite_of_driver);
>  }
> -#else /* CONFIG_OF */
> -/* CONFIG_OF not enabled; do nothing helpers */
> +#else /* CONFIG_OF && (CONFIG_PPC32 || CONFIG_MICROBLAZE) */
> +/* Appropriate config not enabled; do nothing helpers */
>  static inline int __init ulite_of_register(void) { return 0; }
>  static inline void __exit ulite_of_unregister(void) { }
> -#endif /* CONFIG_OF */
> +#endif /* CONFIG_OF && (CONFIG_PPC32 || CONFIG_MICROBLAZE) */
>
>  /* ---------------------------------------------------------------------
>  * Module setup/teardown
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
