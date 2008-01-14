Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbYANJG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbYANJG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 04:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753132AbYANJGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 04:06:15 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35184 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752891AbYANJGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:06:13 -0500
Date: Mon, 14 Jan 2008 09:03:29 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Marc Pignat" <marc.pignat@hevs.ch>, wim@iguana.be,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH] watchdog on gpio
Message-ID: <20080114090329.6efa2921@lxorguk.ukuu.org.uk>
In-Reply-To: <8bd0f97a0801140004q6a32c2ceh397a2208d3012f0e@mail.gmail.com>
References: <200801101611.08867.marc.pignat@hevs.ch>
	<8bd0f97a0801140004q6a32c2ceh397a2208d3012f0e@mail.gmail.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > #include <linux/gpio_wdt.h>
> 
> perhaps "watchdog" rather than "wdt" considering it's already
> "linux/watchdog.h" ?

or _wdt/wdt_ like the rest of the watchdog code uses for watchdog names
(wdt ->watchdog timer).

>
> > +       case WDIOC_KEEPALIVE:
> > +               gpio_wdt_keepalive(wdt);
> > +               return 0;
> 
> this two lines should be merged.

No.

> > +       default:
> > +               return -ENOIOCTLCMD;
> 
> should be -ENOTTY like all the other watchdogs

Yes. That's a common confusion. -ENOIOCTLCMD is a magic code used
internally by some mid layers to indicate the driver doesn't know the
ioctl so use default behaviour. -ENOTTY (confusingly but this is Unix
history) is the right answer for unknowns.
> 
> > +static char banner[] __initdata = KERN_INFO PFX "fixed %d.%03d seconds timeout (nowayout= %d)\n";
> 
> this only gets used once in the init function ... having it be broken
> out like this is kind of silly

Saves memory - you can't make inlined strings __initdata without breaking
some compilers. So it is correct.

> 
> > +static int __init gpio_wdt_probe(struct platform_device *pdev)
> 
> shouldnt this be __devinit ?

IFF the device can be found/removed dynamically.

> > +       if (watchdog) {
> > +               printk(KERN_ERR PFX "only one device supported\n");
> > +               return -ENODEV;
> > +       }
> 
> why ?  it'd be trivial to abstract this driver away from a global
> "watchdog" state into a proper arbitrary # of gpio watchdogs.

The core watchdog code only supports one watchdog currently. This again
is correct.

