Return-Path: <linux-kernel-owner+w=401wt.eu-S933161AbXEVKaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161AbXEVKaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 06:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757187AbXEVKa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 06:30:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50635 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833AbXEVKa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 06:30:27 -0400
Message-ID: <4652C640.3090806@garzik.org>
Date: Tue, 22 May 2007 06:30:24 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] CDROM: replace jiffies busyloop with msleep
References: <1179829525.12708.118.camel@chaos>
In-Reply-To: <1179829525.12708.118.camel@chaos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> From: Ingo Molnar <mingo@elte.hu>
> 
> The SJCD driver uses a jiffies busy loop. Replace it with msleep.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> 
> ---
>  drivers/cdrom/sjcd.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/drivers/cdrom/sjcd.c
> ===================================================================
> --- linux-2.6.orig/drivers/cdrom/sjcd.c
> +++ linux-2.6/drivers/cdrom/sjcd.c
> @@ -69,6 +69,7 @@
>  #include <linux/string.h>
>  #include <linux/major.h>
>  #include <linux/init.h>
> +#include <linux/delay.h>
>  
>  #include <asm/system.h>
>  #include <asm/io.h>
> @@ -1709,12 +1710,11 @@ static int __init sjcd_init(void)
>  	printk(KERN_INFO "SJCD: Resetting: ");
>  	sjcd_send_cmd(SCMD_RESET);
>  	for (i = 1000; i > 0 && !sjcd_status_valid; --i) {
> -		unsigned long timer;
> -
>  		/*
>  		 * Wait 10ms approx.
>  		 */
> -		for (timer = jiffies; time_before_eq(jiffies, timer););
> +		msleep(10);
> +

I always worry when I see code like this, wondering if there is some 
arcane reason that I cannot fathom, that is being removed.  You gotta 
wonder how long it has been since this driver was used, by anybody.

Oh well, I cannot find fault with the patch, paranoia worries aside.

ACK.

	Jeff



