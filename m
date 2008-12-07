Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYLGRvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYLGRvW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 12:51:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbYLGRvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 12:51:12 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60733 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752143AbYLGRvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 12:51:11 -0500
Date: Sun, 7 Dec 2008 17:51:18 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Kay Sievers" <kay.sievers@vrfy.org>
Cc: "Evgeniy Polyakov" <zbr@ioremap.net>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       linux-kernel@vger.kernel.org,
       "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>
Subject: Re: Runaway loop with the current git.
Message-ID: <20081207175118.09c633e8@lxorguk.ukuu.org.uk>
In-Reply-To: <ac3eb2510812070939h17ef6316hea96fe89f01207a6@mail.gmail.com>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk>
	<E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au>
	<20081207155507.GA15355@gondor.apana.org.au>
	<ac3eb2510812070803i150d91e7led58128796e8045e@mail.gmail.com>
	<20081207160921.693f637a@lxorguk.ukuu.org.uk>
	<20081207163151.GA31838@ioremap.net>
	<20081207170108.39dfd93f@lxorguk.ukuu.org.uk>
	<ac3eb2510812070922q2531a188v37874a042b259ac9@mail.gmail.com>
	<20081207172855.55fee78f@lxorguk.ukuu.org.uk>
	<ac3eb2510812070939h17ef6316hea96fe89f01207a6@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Dec 2008 18:39:48 +0100
"Kay Sievers" <kay.sievers@vrfy.org> wrote:

> On Sun, Dec 7, 2008 at 18:28, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> > /dev/console is a logical mapping to a device which may well be
> >> > different, loaded after PCI is initialised and dependant on PCI.
> >>
> >> So wrong. If no driver is associated, like early, in that case, we
> >> must return -ENODEV, instead of calling modprobe in a loop. It's a
> >> built-in device, and it's easy to fix.
> >
> > You've clearly no idea how initrd even works have you ?
> 
> Not sure, if you understand the real problem. A kernel forked binary
> is allowed to access /dev/console, but it triggers a kernel bug.

If there is a hotplug load for the console device then it cannot. Just as
a request for the driver for /dev/hda cannot open /dev/hda* again.

> Nonsense. The kernel calls /sbin/modprobe directly, no hotplug involved.

Its up to you if the kernel calls modprobe and what your modprobe is

> The kernel calls modprobe for something, modprobe tries to log an
> error, and the kernel calls modprobe again. Bug! No hotplug involved.

A modprobe to load the console device shouln't open /dev/console. Very
simple and always been true.

> >                                Kernel issues hotplug message
> >                                .....
> >                                Kernel detects this is stuck
> >                                Kernel replies with -ENODEV/-ENXIO to try
> > and rescue itself from buggy initrd scripts
> 
> Totally wrong, It never was that way

Funny but its been that way for many many years. Just as it cannot try and
syslog an error when loading the AF_UNIX socket family.

Alan
