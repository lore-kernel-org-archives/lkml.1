Return-Path: <linux-kernel-owner+w=401wt.eu-S935319AbZLPUqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935319AbZLPUqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 15:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965051AbZLPUq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 15:46:28 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:58064 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965047AbZLPUq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 15:46:27 -0500
To: "H Hartley Sweeten" <hartleys@visionengravers.com>
Cc: "kernel list" <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH] pxa27x_udc.c: use resource_size()
References: <BD79186B4FD85F4B8E60E381CAEE19090200EA9E@mi8nycmail19.Mi8.com>
From: Robert Jarzmik <robert.jarzmik@free.fr>
X-URL: http://belgarath.falguerolles.org/
Date: Wed, 16 Dec 2009 21:46:15 +0100
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200EA9E@mi8nycmail19.Mi8.com> (H. Hartley Sweeten's message of "Mon\, 14 Dec 2009 18\:05\:02 -0500")
Message-ID: <87oclytzoo.fsf@free.fr>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H Hartley Sweeten" <hartleys@visionengravers.com> writes:

> Use resource_size().
>
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Robert Jarzmik <robert.jarzmik@free.fr>
>
> ---
>
> diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
> index adda120..72c89d9 100644
> --- a/drivers/usb/gadget/pxa27x_udc.c
> +++ b/drivers/usb/gadget/pxa27x_udc.c
> @@ -2439,7 +2439,7 @@ static int __init pxa_udc_probe(struct platform_device *pdev)
>  	}
>  
>  	retval = -ENOMEM;
> -	udc->regs = ioremap(regs->start, regs->end - regs->start + 1);
> +	udc->regs = ioremap(regs->start, resource_size(regs));
>  	if (!udc->regs) {
>  		dev_err(&pdev->dev, "Unable to map UDC I/O memory\n");
>  		goto err_map; 

Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

-- 
Robert
