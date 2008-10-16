Return-Path: <linux-kernel-owner+w=401wt.eu-S1753946AbYJPQnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbYJPQnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 12:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbYJPQnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 12:43:33 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:6962 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751957AbYJPQnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 12:43:32 -0400
Date: Thu, 16 Oct 2008 20:43:30 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <david-b@pacbell.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch] gpiolib: fix oops in gpio_get_value_cansleep()
Message-ID: <20081016164330.GB27938@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <200810160845.22281.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <200810160845.22281.david-b@pacbell.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2008 at 08:45:22AM -0700, David Brownell wrote:
> From: David Brownell <dbrownell@users.sourceforge.net>
[...]
> So the problem is that gpio_get_value_cansleep() isn't making
> the same sanity check that gpio_get_value() does:  making sure
> this GPIO isn't one of the atypical "no input logic" cases.
> 
> Reported-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  drivers/gpio/gpiolib.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1056,7 +1056,7 @@ int gpio_get_value_cansleep(unsigned gpi
>  
>  	might_sleep_if(extra_checks);
>  	chip = gpio_to_chip(gpio);
> -	return chip->get(chip, gpio - chip->base);
> +	return chip->get ? chip->get(chip, gpio - chip->base) : 0;

Why don't we check the .set in the gpio_set_value? Because
we must always call gpio_direction_output()? It is not exactly the
same we work with the input direction.. is this documented anywhere?

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
