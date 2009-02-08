Return-Path: <linux-kernel-owner+w=401wt.eu-S1753751AbZBHS3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbZBHS3y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 13:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbZBHS3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 13:29:44 -0500
Received: from fnoeppeil36.netpark.at ([217.175.205.164]:42975 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbZBHS3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 13:29:44 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Feb 2009 13:29:43 EST
Date: Sun, 8 Feb 2009 19:23:00 +0100
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtc: t reaches -1, tested 0
Message-ID: <20090208192300.51d0a80c@scarran.roarinelk.net>
In-Reply-To: <498EE7D6.4090100@gmail.com>
References: <498EE7D6.4090100@gmail.com>
Organization: Private
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Roel,

On Sun, 08 Feb 2009 15:10:30 +0100
Roel Kluin <roel.kluin@gmail.com> wrote:
> With a postfix decrement t will reach -1 rather than 0,
> so the warning nor errot_out occur.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/rtc/rtc-au1xxx.c b/drivers/rtc/rtc-au1xxx.c
> index 8906a68..979ed04 100644
> --- a/drivers/rtc/rtc-au1xxx.c
> +++ b/drivers/rtc/rtc-au1xxx.c
> @@ -81,7 +81,7 @@ static int __devinit au1xtoy_rtc_probe(struct platform_device *pdev)
>  	if (au_readl(SYS_TOYTRIM) != 32767) {
>  		/* wait until hardware gives access to TRIM register */
>  		t = 0x00100000;
> -		while ((au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_T0S) && t--)
> +		while ((au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_T0S) && --t)
>  			msleep(1);
>  
>  		if (!t) {

Thank you, obviously correct.

Acked-by: Manuel Lauss <mano@roarinelk.homelinux.net>
