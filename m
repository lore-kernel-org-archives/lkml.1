Return-Path: <linux-kernel-owner+w=401wt.eu-S1751814AbXCCUPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbXCCUPv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 15:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbXCCUPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 15:15:51 -0500
Received: from email.authentidate.de ([213.61.157.66]:56359 "EHLO
	email.authentidate.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbXCCUPr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 15:15:47 -0500
Subject: Re: usbserial not working/oops on removal
From: Andreas Laumann <al@authentidate.de>
To: Oliver Neukum <oliver@neukum.org>
Cc: Kevin Fenzi <kevin@scrye.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200703031633.18597.oliver@neukum.org>
References: <20070302193715.568098a6@ningauble.scrye.com>
	 <200703031138.20582.oliver@neukum.org>
	 <1172928441.3710.8.camel@justine.inexnet.de>
	 <200703031633.18597.oliver@neukum.org>
Content-Type: text/plain; charset=UTF-8
Organization: AuthentiDate International AG
Date: Sat, 03 Mar 2007 21:15:24 +0100
Message-Id: <1172952925.5393.10.camel@justine.inexnet.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 03.03.2007, 16:33 +0100 schrieb Oliver Neukum:
> Am Samstag, 3. März 2007 14:27 schrieb Andreas Laumann:
> > Unfortunately your fix  does not work.  The first one seems registered
> > correctly, but after that it fails again for the next one.
> 
> Please try this additional patch on top of the first.
> 
> 	Regards
> 		Oliver
> 
> --- a/drivers/usb/serial/usb-serial.c	2007-03-03 16:28:22.000000000 +0100
> +++ b/drivers/usb/serial/usb-serial.c	2007-03-03 16:28:26.000000000 +0100
> @@ -847,7 +847,6 @@
>  		port = kzalloc(sizeof(struct usb_serial_port), GFP_KERNEL);
>  		if (!port)
>  			goto probe_error;
> -		port->number = i + serial->minor;
>  		port->serial = serial;
>  		spin_lock_init(&port->lock);
>  		mutex_init(&port->mutex);
> @@ -982,6 +981,9 @@
>  	}
>  	serial->minor = minor;
>  
> +	for (i = 0; i < max_endpoints; ++i)
> +		serial->port[i]->number = i + serial->minor;
> +
>  	/* register all of the individual ports with the driver core */
>  	for (i = 0; i < num_ports; ++i) {
>  		port = serial->port[i];


Now, we're back in business. The combined patches are working  with rawhide's
 kernel-2.6.20-1.2962.fc7.x86_64 which in fact is 2.6.21rc2-git2

usbcore: registered new interface driver usbserial
drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registered for Reiner SCT Cyberjack USB card reader
cyberjack 5-2.2:1.0: Reiner SCT Cyberjack USB card reader converter detected
usb 5-2.2: Reiner SCT Cyberjack USB card reader converter now attached to ttyUSB0
cyberjack 5-2.3:1.0: Reiner SCT Cyberjack USB card reader converter detected
usb 5-2.3: Reiner SCT Cyberjack USB card reader converter now attached to ttyUSB1
usbcore: registered new interface driver cyberjack
drivers/usb/serial/cyberjack.c: v1.01 Matthias Bruestle
drivers/usb/serial/cyberjack.c: REINER SCT cyberJack pinpad/e-com USB Chipcard Reader Driver


Good job, Oliver.

Regards
	Andreas




-- 
All that is necessary for the triumph of evil is that good men do
nothing. - Edmund Burke (1729 - 1797)


