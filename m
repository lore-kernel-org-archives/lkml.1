Return-Path: <linux-kernel-owner+w=401wt.eu-S1757988AbYHHQbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbYHHQbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbYHHQay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:30:54 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:21325 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbYHHQay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:30:54 -0400
Date: Fri, 8 Aug 2008 18:36:25 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Jean Delvare <khali@linux-fr.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fbdev-devel@lists.sourceforge.net,
       Antonino Daplas <adaplas@gmail.com>,
       Petr Vandrovec <vandrove@vc.cvut.cz>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [PATCH 2/3] matroxfb: i2c structure
 templates clean-up
Message-Id: <20080808183625.51f5622a.krzysztof.h1@poczta.fm>
In-Reply-To: <20080808170208.6c76ff46@hyperion.delvare>
References: <20080808164937.141a95e0@hyperion.delvare>
	<20080808170208.6c76ff46@hyperion.delvare>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 4ee2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008 17:02:08 +0200
Jean Delvare <khali@linux-fr.org> wrote:

> Clean up the use of structure templates in i2c-matroxfb. In this case
> it's more efficient to initialize the few fields we need individually.
> This makes i2c-matroxfb.ko 16% smaller on my system.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---

Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>

>  drivers/video/matrox/i2c-matroxfb.c |   11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> --- linux-2.6.26-rc6.orig/drivers/video/matrox/i2c-matroxfb.c	2008-06-17 20:23:41.000000000 +0200
> +++ linux-2.6.26-rc6/drivers/video/matrox/i2c-matroxfb.c	2008-06-17 20:27:36.000000000 +0200
> @@ -87,13 +87,7 @@ static int matroxfb_gpio_getscl(void* da
>  	return (matroxfb_read_gpio(b->minfo) & b->mask.clock) ? 1 : 0;
>  }
>  
> -static struct i2c_adapter matrox_i2c_adapter_template =
> -{
> -	.owner =	THIS_MODULE,
> -	.id =		I2C_HW_B_G400,
> -};
> -
> -static struct i2c_algo_bit_data matrox_i2c_algo_template =
> +static const struct i2c_algo_bit_data matrox_i2c_algo_template =
>  {
>  	.setsda		= matroxfb_gpio_setsda,
>  	.setscl		= matroxfb_gpio_setscl,
> @@ -112,7 +106,8 @@ static int i2c_bus_reg(struct i2c_bit_ad
>  	b->minfo = minfo;
>  	b->mask.data = data;
>  	b->mask.clock = clock;
> -	b->adapter = matrox_i2c_adapter_template;
> +	b->adapter.owner = THIS_MODULE;
> +	b->adapter.id = I2C_HW_B_G400;
>  	snprintf(b->adapter.name, sizeof(b->adapter.name), name,
>  		minfo->fbcon.node);
>  	i2c_set_adapdata(&b->adapter, b);
> 
> -- 
> Jean Delvare
> 
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> Linux-fbdev-devel mailing list
> Linux-fbdev-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-fbdev-devel
> 


----------------------------------------------------------------------
Tylko dla detektywow! Konkurs na Smaker.pl
Kliknij >>> http://link.interia.pl/f1eb1

