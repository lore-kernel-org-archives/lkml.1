Return-Path: <linux-kernel-owner+w=401wt.eu-S1161224AbXBZVxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161224AbXBZVxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161173AbXBZVxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:53:48 -0500
Received: from tim.rpsys.net ([194.106.48.114]:47820 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161224AbXBZVxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:53:47 -0500
Subject: Re: [PATCH] ACPI: ibm-acpi: improve backlight power handling (v2)
From: Richard Purdie <rpurdie@rpsys.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <20070226182604.GJ2909@khazad-dum.debian.net>
References: <Pine.LNX.4.64.0702260154460.10496@twin.jikos.cz>
	 <1172490091.5824.30.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0702261329270.10496@twin.jikos.cz>
	 <20070226142157.GA2909@khazad-dum.debian.net>
	 <1172501357.5824.91.camel@localhost.localdomain>
	 <20070226152035.GB2909@khazad-dum.debian.net>
	 <20070226161203.GD2909@khazad-dum.debian.net>
	 <1172507907.5824.105.camel@localhost.localdomain>
	 <20070226181202.GH2909@khazad-dum.debian.net>
	 <20070226182604.GJ2909@khazad-dum.debian.net>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 21:53:38 +0000
Message-Id: <1172526818.24429.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-26 at 15:26 -0300, Henrique de Moraes Holschuh wrote: 
> Improve the backlight code to emulate as much as possible the power
> management events, as we are unable to really power on or power off the
> backlight.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Richard Purdie <rpurdie@rpsys.net>
> 
>  drivers/acpi/ibm_acpi.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/acpi/ibm_acpi.c b/drivers/acpi/ibm_acpi.c
> index e7309a6..3690136 100644
> --- a/drivers/acpi/ibm_acpi.c
> +++ b/drivers/acpi/ibm_acpi.c
> @@ -86,6 +86,7 @@
>  
>  #include <linux/proc_fs.h>
>  #include <linux/backlight.h>
> +#include <linux/fb.h>
>  #include <asm/uaccess.h>
>  
>  #include <linux/dmi.h>
> @@ -1707,7 +1708,10 @@ static int brightness_write(char *buf)
>  
>  static int brightness_update_status(struct backlight_device *bd)
>  {
> -	return brightness_set(bd->props.brightness);
> +	return brightness_set(
> +		(bd->props.fb_blank == FB_BLANK_UNBLANK &&
> +		 bd->props.power == FB_BLANK_UNBLANK) ?
> +				bd->props.brightness : 0);
>  }
>  
>  static struct backlight_ops ibm_backlight_data = {


