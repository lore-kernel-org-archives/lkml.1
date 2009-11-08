Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbZKHJKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbZKHJKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 04:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbZKHJKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 04:10:36 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56930 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbZKHJKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 04:10:35 -0500
Date: Sun, 8 Nov 2009 09:10:10 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Ben Dooks <ben-linux@fluff.org>, Brian Swetland <swetland@google.com>,
       Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: dream: glue for mmc controller
Message-ID: <20091108091009.GB20529@n2100.arm.linux.org.uk>
References: <20091103105319.GA2492@elf.ucw.cz> <20091103105737.GE20341@fluff.org.uk> <20091108081314.GA16482@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091108081314.GA16482@elf.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 09:13:14AM +0100, Pavel Machek wrote:
> > > +#include <asm/io.h>
> > > +#include <asm/gpio.h>
> > linux/gpio.h
> > linux/io.h
> 
> I got compile errors when trying to use linux/gpio.h:
> 
> arch/arm/mach-msm/board-dream-gpio.c: In function
> 'dream_gpio_configure':
> arch/arm/mach-msm/board-dream-gpio.c:109: error: 'GPIOF_OUTPUT_LOW'
> undeclared (first use in this function)

This means it's abusing the gpio header files - which are intended for
the generic GPIO support, but are being used for this platforms private
non-generic GPIO based stuff.

> arch/arm/mach-msm/board-dream-gpio.c:291: error: 'IRQF_TRIGGER_HIGH'
> undeclared (first use in this function)
> arch/arm/mach-msm/board-dream-gpio.c:293: error: implicit declaration
> of function 'set_irq_wake'

That's showing its missing a linux/interrupt.h include.
