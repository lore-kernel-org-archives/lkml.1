Return-Path: <linux-kernel-owner+w=401wt.eu-S1757019AbZJ1AgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019AbZJ1AgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 20:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756994AbZJ1AgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 20:36:17 -0400
Received: from relay.atmel.no ([80.232.32.139]:59371 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988AbZJ1AgR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 20:36:17 -0400
Date: Wed, 28 Oct 2009 08:35:48 +0800
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Andrew Victor <avictor.za@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, kernel@avr32linux.org,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/3 v2] at91/atmel-mci: inclusion of sd/mmc driver in 
 at91sam9g45 chip and board
Message-ID: <20091028083548.38f1d80c@hskinnemoen-d830>
In-Reply-To: <cd73a99e0910271243x744c956bl598fef9fd4144840@mail.gmail.com>
References: <acfa557032a93e2d3186981b16f7048a5a31028a.1256314995.git.nicolas.ferre@atmel.com>
	<20090930155557.7dae503b@hskinnemoen-d830>
	<a3b1332815576dc4d496937b8a5ab69d36818d00.1256314995.git.nicolas.ferre@atmel.com>
	<cd73a99e0910271243x744c956bl598fef9fd4144840@mail.gmail.com>
Organization: Atmel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Victor <avictor.za@gmail.com> wrote:
> > +static struct mci_platform_data __initdata mci0_data = {
> > +       .slot[0] = {
> > +               .bus_width      = 4,
> > +               .detect_pin     = AT91_PIN_PD10,
> > +               .wp_pin         = -1,
> > +       },  
> 
> Causes at91_set_gpio_input() to be called for pin -1.  Which shouldn't be valid.
> AT91 platforms use 0 to indicate an un-connected GPIO pin, so the
> assignment of "wp_pin" should probably just be removed.

The mci driver expects non-existent pins to have a negative value, as
do all other drivers which use gpio_is_valid().

Haavard
