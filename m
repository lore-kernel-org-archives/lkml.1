Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbZFISL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbZFISL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 14:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZFISLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 14:11:19 -0400
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:43585 "HELO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751997AbZFISLS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 14:11:18 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] gpiolib: add gpio_request/free_irq
Date: Tue, 9 Jun 2009 14:11:17 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090191701F@mi8nycmail19.Mi8.com>
In-Reply-To: <200906052219.47888.david-b@pacbell.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] gpiolib: add gpio_request/free_irq
Thread-Index: AcnmZmqHsjSiSiCXTBOSHlZtBG0YEwCw2tog
References: <200906051151.05779.hartleys@visionengravers.com> <200906052219.47888.david-b@pacbell.net>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "David Brownell" <david-b@pacbell.net>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 09 Jun 2009 18:11:18.0995 (UTC) FILETIME=[AFDB3A30:01C9E92D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 05, 2009 10:20 PM, David Brownell wrote:
> On Friday 05 June 2009, H Hartley Sweeten wrote:
> Add support functions to gpiolib to request/free gpio irqs.
> 
> I'm not keen on this.
> 
>  - At best it's a convenience layer ... for something that's
>    not the least bit awkward to do otherwise.
> 

I agree it's a convenience layer, but it cleans up the error path in
many drivers that allocate a number of gpio irqs.  It also insures
that the gpios get requested before they are connected to an interrupt.
A number of drivers either don't do the gpio_request or they don't
set the gpio as an input before doing the request_irq.

>  - Coupling it to gpiolib sort of defeats the point of saying
>    that gpiolib is just an *implementation* of the interface.
>    Where's the code to run for non-gpiolib platforms?
> 

But if a driver is using the gpiolib interface calls wouldn't that
prevent that driver from working on a platform that does not support
gpiolib? File include/linux/gpio.h defines all the gpiolib calls to
either return an error code or WARN_ON(1) when called.

>  - Since it implicitly couples gpio_request() to a flavor of
>    request_irq(), it precludes sharing those IRQs.
> 

Can't the IRQ be shared by passing IRQF_SHARED as one of the flags?

> Basically, board setup can know that the GPIO is being used
> as an IRQ, and do the request()/direction_input() before it
> passes gpio_to_irq() to the driver. That's worked in every
> case I've happened across so far...

I agree it works as-is right now.  I just thought this would be a
convenient wrapper to handle a common setup step.  If it's overkill
or not appropriate to add to gpiolib please disregard the patch.

I have cleaned up the patch to be more inline with how the various
drivers would use it.  If there is any potential interest I will
repost the patch.

Thanks for your comments,
Hartley
