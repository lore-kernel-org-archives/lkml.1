Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbYISPo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbYISPo5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 11:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYISPot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 11:44:49 -0400
Received: from mail.artecdesign.ee ([195.50.213.123]:41701 "EHLO
	postikukk.artecdesign.ee" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbYISPos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 11:44:48 -0400
X-Greylist: delayed 1470 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Sep 2008 11:44:47 EDT
Message-ID: <48D3C319.4040605@artecdesign.ee>
Date: Fri, 19 Sep 2008 18:19:53 +0300
From: Anti Sullin <anti.sullin@artecdesign.ee>
User-Agent: Icedove 1.5.0.14eol (X11/20080724)
MIME-Version: 1.0
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Victor <linux@maxim.org.za>
Subject: Re: [PATCH] atmel_serial: update the powersave handler to match serial
 core
References: <1221837111-20107-1-git-send-email-haavard.skinnemoen@atmel.com>
In-Reply-To: <1221837111-20107-1-git-send-email-haavard.skinnemoen@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ADG-Spam-Score: -5.9 (-----)
X-ADG-Spam-ScoreInt: -58
X-ADG-Spam-Report: Content analysis details:   (-5.9 points, 5.5 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
X-ADG-ExiScan-Signature: 3f05ab7f0a228bce17862c6f85efb187
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more bug of mine...

Haavard Skinnemoen wrote:
>  }
> @@ -1491,11 +1498,9 @@ static int atmel_serial_resume(struct platform_device *pdev)
>  	struct uart_port *port = platform_get_drvdata(pdev);
>  	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
>  
> -	if (atmel_port->suspended) {
> -		uart_resume_port(&atmel_uart, port);
> -		atmel_port->suspended = 0;
> -	} else
> -		disable_irq_wake(port->irq);
> +	device_set_wakeup_enable(&pdev->dev, atmel_port->may_wakeup);
> +
> +	uart_resume_port(&atmel_uart, port);
Just now noticed - these two lines should be switched.
>  
>  	return 0;
>  }



-- 
Anti Sullin
Embedded Software Engineer
Artec Design LLC
Akadeemia tee 23A, 12618, Tallinn, Estonia
http://www.artecdesign.ee 
