Return-Path: <linux-kernel-owner+w=401wt.eu-S1762172AbXKOIw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762172AbXKOIw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 03:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756547AbXKOIwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 03:52:20 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:50499 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753344AbXKOIwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 03:52:19 -0500
Date: Thu, 15 Nov 2007 09:51:23 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: David Brownell <david-b@pacbell.net>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Message-ID: <20071115095123.3f595b62@dhcp-255-175.norway.atmel.com>
In-Reply-To: <200711150020.33887.david-b@pacbell.net>
References: <200711091136.20051.david-b@pacbell.net>
	<200711142302.02498.david-b@pacbell.net>
	<alpine.LFD.0.9999.0711150824480.3265@localhost.localdomain>
	<200711150020.33887.david-b@pacbell.net>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0-rc1 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007 00:20:33 -0800
David Brownell <david-b@pacbell.net> wrote:

> > >   - gpio_direction_input()/gpio_direction_output() implicitly
> > >     request the pins, if they weren't already requested.  
> > 
> > Eek, that's completely wrong. Allowing to access a resource _before_
> > it is assigned and then doing the assignment implicit is a really bad
> > idea.  
> 
> This is an artifact of making the GPIO interface easy to adopt,
> by letting all the initial adopters wrap "legacy" SOC-specific
> GPIO interfaces instead of creating a bunch of new platform code.

It's still ok for platforms that do not use gpiolib to provide NOP
gpio_request() and gpio_free() functions if they don't care about
tracking gpio usage. That doesn't mean we shouldn't require all drivers
to use those calls -- if they are implemented as empty inlines, it
won't cost anything to call them.

I'd rather speed up the gpio_direction_* functions a bit by removing
the implicit gpio_request() since they may be called a lot more
frequently and, as you pointed out, possibly from atomic context.

Håvard
