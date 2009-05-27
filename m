Return-Path: <linux-kernel-owner+w=401wt.eu-S1758846AbZE0Dar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846AbZE0Dar (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 23:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbZE0Dai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 23:30:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:35702 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754875AbZE0Dah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 23:30:37 -0400
Subject: Re: Oops in usb-serial with keyspan adapter on current upstream
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0905251116250.23874-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0905251116250.23874-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Wed, 27 May 2009 13:30:30 +1000
Message-Id: <1243395030.17847.55.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Very clever.  Does this simpler patch also fix the problem?

Yes it does, thanks.

Tested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
> 
> Index: usb-2.6/drivers/usb/serial/usb-serial.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/serial/usb-serial.c
> +++ usb-2.6/drivers/usb/serial/usb-serial.c
> @@ -974,6 +974,7 @@ int usb_serial_probe(struct usb_interfac
>  		if (retval > 0) {
>  			/* quietly accept this device, but don't bind to a
>  			   serial port as it's about to disappear */
> +			serial->num_ports = 0;
>  			goto exit;
>  		}
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

