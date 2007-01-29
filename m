Return-Path: <linux-kernel-owner+w=401wt.eu-S1750886AbXA2Pe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750886AbXA2Pe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 10:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbXA2Pe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 10:34:28 -0500
Received: from ku-gbr.de ([81.3.11.18]:54940 "EHLO ku-gbr.de"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750886AbXA2Pe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 10:34:27 -0500
X-Greylist: delayed 2755 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jan 2007 10:34:27 EST
Date: Mon, 29 Jan 2007 15:47:59 +0100
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Cc: s.hauer@pengutronix.de, ppisa4lists@pikron.com
Subject: Re: ARM i.MX serial: fix tx buffer overflows
Message-ID: <20070129144758.GA2760@synertronixx3>
Mail-Followup-To: linux-kernel@vger.kernel.org, s.hauer@pengutronix.de,
	ppisa4lists@pikron.com
References: <20070105155144.GD5838@localhost.localdomain> <200701051901.52486.ppisa4lists@pikron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200701051901.52486.ppisa4lists@pikron.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2007-01-05 19:01 +0100 schrieb Pavel Pisa:

> It applies only for interrupts going through GPIO layer.
> The problem has been noticed by Konstantin Kletschke
> some time ago.
> 
>   No IRQF_TRIGGER set_type function for IRQ 26 (MPU)

Yes. I reported this also.

>  drivers/serial/imx.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.19-rt/drivers/serial/imx.c
> ===================================================================
> +++ linux-2.6.19-rt/drivers/serial/imx.c
> @@ -403,7 +403,8 @@ static int imx_startup(struct uart_port 
>  	if (retval) goto error_out2;
>  
>  	retval = request_irq(sport->rtsirq, imx_rtsint,
> -			     IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
> +			     (sport->rtsirq < IMX_IRQS) ? 0 :
> +			       IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
>  			     DRIVER_NAME, sport);
>  	if (retval) goto error_out3;


Okay, this indeed fixes my

No IRQF_TRIGGER set_type function for IRQ 26 (MPU)

here!

Regards, Konsti

-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
