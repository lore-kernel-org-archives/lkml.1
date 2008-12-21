Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbYLUGtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbYLUGtV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 01:49:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbYLUGtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 01:49:12 -0500
Received: from mta23.gyao.ne.jp ([125.63.38.249]:54640 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750984AbYLUGtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 01:49:11 -0500
Date: Sun, 21 Dec 2008 15:47:06 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-sh <linux-sh@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] sh: maple: add support for Maple controller as a joystick
Message-ID: <20081221064706.GB31320@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	LKML <linux-kernel@vger.kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-sh <linux-sh@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
References: <1229728542.1441.6.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229728542.1441.6.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 11:15:42PM +0000, Adrian McMenamin wrote:
> Not sure what happened with earlier submissions, so here is an up-to-date
> patch for the Dreamcast Maple controlled.
> 
> 
> Add support for the SEGA Dreamcast Maple controller as a joystick
> 
> Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> ---
> 
> diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
> index be5c14a..ca7ce42 100644
> --- a/drivers/input/joystick/Kconfig
> +++ b/drivers/input/joystick/Kconfig
> @@ -294,4 +294,17 @@ config JOYSTICK_XPAD_LEDS
>  	  This option enables support for the LED which surrounds the Big X on
>  	  XBox 360 controller.
>  
> +config JOYSTICK_MAPLE
> +	tristate "Dreamcast control pad"
> +	depends on SH_DREAMCAST
> +	select MAPLE
> +	help

Please don't do this kind of dependency garbage. The only dependency this
device has is on the maple bus, there is nothing inherently dreamcast
specific about it.

CONFIG_MAPLE already has the dreamcast dependency in this case, and I
would speculate the only reason that you added the dreamcast dependency
was to work around the fact that select would complain on plaforms where
the MAPLE symbol is not visible.

This is an indicator that select is not the thing you should be using
here in the first place. So, just change this to depends on MAPLE and be
done with it. As soon as you have to start mixing and matching
depends/selects that already have a dependency on each other, you have
already lost.
