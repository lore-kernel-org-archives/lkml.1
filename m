Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbZFSHwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbZFSHwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 03:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZFSHvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 03:51:54 -0400
Received: from relay.atmel.no ([80.232.32.139]:64558 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbZFSHvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 03:51:53 -0400
Date: Fri, 19 Jun 2009 09:51:48 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-usb@vger.kernel.org,
       avictor.za@gmail.com, linux-kernel@vger.kernel.org,
       patrice.vilchez@atmel.com
Subject: Re: [PATCH 2/2] at91/USB: at91sam9g45 series USB host integration
Message-ID: <20090619095148.67a74ed9@hskinnemoen-d830>
In-Reply-To: <200906190043.00428.david-b@pacbell.net>
References: <1244547493-19654-1-git-send-email-nicolas.ferre@atmel.com>
	<1244547493-19654-2-git-send-email-nicolas.ferre@atmel.com>
	<1244547493-19654-3-git-send-email-nicolas.ferre@atmel.com>
	<200906190043.00428.david-b@pacbell.net>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> > --- a/arch/arm/mach-at91/at91sam9g45_devices.c
> > +++ b/arch/arm/mach-at91/at91sam9g45_devices.c

> > +	/* Enable VBus control for UHP ports */
> > +	for (i = 0; i < data->ports; i++) {
> > +		if (data->vbus_pin[i])
> > +			at91_set_gpio_output(data->vbus_pin[i], 0);  
> 
> This should gpio_request() and gpio_direction_output().

Hmm...I thought the driver was supposed to call gpio_request(), not the
platform code?

> Don't use AT91-specific GPIO calls except for things that
> the generic calls don't support ... like enabling open-drain
> outputs, the deglitching support, or input pullups.

This call does port configuration, which you convinced me a long time
ago was a fundamentally different thing from GPIO. If the pin really
requires one of those features, this would definitely be the place to
set it up.

Haavard
