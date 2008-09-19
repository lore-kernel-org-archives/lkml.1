Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbYISQQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbYISQQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 12:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbYISQQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 12:16:07 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:36003 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbYISQQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 12:16:06 -0400
Date: Fri, 19 Sep 2008 18:15:51 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Michael Trimarchi <trimarchimichael@yahoo.it>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Victor <linux@maxim.org.za>,
       Anti Sullin <anti.sullin@artecdesign.ee>
Subject: Re: [PATCH] atmel_serial: update the powersave handler to match
 serial core
Message-ID: <20080919181551.3507b34b@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <690570.15660.qm@web26204.mail.ukl.yahoo.com>
References: <690570.15660.qm@web26204.mail.ukl.yahoo.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 19 Sep 2008 16:15:42.0268 (UTC) FILETIME=[F69A6FC0:01C91A72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Trimarchi <trimarchimichael@yahoo.it> wrote:
> > Michael Trimarchi wrote:  
> > > > +    /* we can not wake up if we're running on slow clock */
> > > > +    atmel_port->may_wakeup = device_may_wakeup(&pdev->dev);
> > > > +    if (atmel_serial_clk_will_stop())
> > > > +        device_set_wakeup_enable(&pdev->dev, 0);
> > > > +    
> > > This is not true, the wakeup in the slow clock is possible, configure the
> > > input pin of the serial device as a gpio, and wake up on gpio. Then you
> > > must reconfigure as a serial pin, and you can wake up on slow clock.  
> > 
> > Yes, but the current driver doesn't actually support that, does it?
> >   
> 
> Yes I know, but we can think about it and support when is possible
> to wake-up the serial device. Each serial device can change the status
> of the gpio-pin before suspendig and register and handler on it (I think one
> interrupt handler for all the serial that can do that), then reset it after resume.
> I think not all the serial device can do that in the atmel architectures but I suppose
> that can be very usefull for example in gprs application.

I agree it would be useful. It would require changing the port mux
configuration from the driver though, and there's no standardized
interface for doing that. Maybe this is a good motivation to come up
with one?

Btw, I assume the first character you receive will be lost when you do
this, right?

Haavard
