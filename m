Return-Path: <linux-kernel-owner+w=401wt.eu-S1752518AbZIWRcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbZIWRcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 13:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbZIWRcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 13:32:31 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:34392 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbZIWRca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 13:32:30 -0400
Message-ID: <4ABA5BBB.2040804@oracle.com>
Date: Wed, 23 Sep 2009 10:32:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Greg KH <gregkh@suse.de>, Oliver Neukum <oliver@neukum.org>,
       Elina Pasheva <epasheva@sierrawireless.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [origin tree build failure] [PATCH] USB sierra: Fix build if
 !CONFIG_PM
References: <20090923135539.GA6542@kroah.com> <20090923172456.GA8948@elte.hu>
In-Reply-To: <20090923172456.GA8948@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt013.oracle.com [141.146.116.22]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4ABA5B80.01E3:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>       USB: support for autosuspend in sierra while online
> 
> FYI, -tip testing found a build failure with the sierra driver on 
> !CONFIG_PM - fixed via the patch below.
> 
> Thanks,
> 
> 	Ingo
> 
> -------------------->
> From 26f8ed899041199caa9315e057a28d10f81b5b88 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed, 23 Sep 2009 19:19:47 +0200
> Subject: [PATCH] USB sierra: Fix build if !CONFIG_PM
> 
> This build failure:
> 
>   drivers/usb/serial/sierra.c: In function 'sierra_suspend':
>   drivers/usb/serial/sierra.c:936: error: 'struct usb_device' has no member named 'auto_pm'
> 
> Triggers because the ->auto_pm functionality depends on CONFIG_PM.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Ack.
http://marc.info/?l=linux-usb&m=125305135600816&w=2

lossy. :(


> ---
>  drivers/usb/serial/sierra.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
> index 68fa0e4..b089a70 100644
> --- a/drivers/usb/serial/sierra.c
> +++ b/drivers/usb/serial/sierra.c
> @@ -912,6 +912,8 @@ static void sierra_release(struct usb_serial *serial)
>  	}
>  }
>  
> +#ifdef CONFIG_PM
> +
>  static void stop_read_write_urbs(struct usb_serial *serial)
>  {
>  	int i, j;
> @@ -989,6 +991,8 @@ static int sierra_resume(struct usb_serial *serial)
>  	return ec ? -EIO : 0;
>  }
>  
> +#endif /* CONFIG_PM */
> +
>  static struct usb_serial_driver sierra_device = {
>  	.driver = {
>  		.owner =	THIS_MODULE,
> @@ -1009,8 +1013,10 @@ static struct usb_serial_driver sierra_device = {
>  	.tiocmset          = sierra_tiocmset,
>  	.attach            = sierra_startup,
>  	.release           = sierra_release,
> +#ifdef CONFIG_PM
>  	.suspend	   = sierra_suspend,
>  	.resume		   = sierra_resume,
> +#endif
>  	.read_int_callback = sierra_instat_callback,
>  };
>  
> --
