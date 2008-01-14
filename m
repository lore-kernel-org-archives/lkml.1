Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbYANNbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbYANNbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 08:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbYANNah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 08:30:37 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:52962 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751290AbYANNaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 08:30:35 -0500
Date: Mon, 14 Jan 2008 14:30:19 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Marc Pignat" <marc.pignat@hevs.ch>,
       wim@iguana.be, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH] watchdog on gpio
Message-ID: <20080114143019.5d7ffaf4@siona>
In-Reply-To: <8bd0f97a0801140422n3d3e3835v7f57dbe33c7a6db0@mail.gmail.com>
References: <200801101611.08867.marc.pignat@hevs.ch>
	<8bd0f97a0801140004q6a32c2ceh397a2208d3012f0e@mail.gmail.com>
	<20080114090329.6efa2921@lxorguk.ukuu.org.uk>
	<8bd0f97a0801140128i2ebf9236uabe0e0b8cf15fbe@mail.gmail.com>
	<20080114092905.227c5a38@lxorguk.ukuu.org.uk>
	<8bd0f97a0801140145s5e13083ej926aa9d5f87e3a99@mail.gmail.com>
	<20080114131429.40453e5f@siona>
	<8bd0f97a0801140422n3d3e3835v7f57dbe33c7a6db0@mail.gmail.com>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2008 07:22:39 -0500
"Mike Frysinger" <vapier.adi@gmail.com> wrote:

> > There is: platform_driver_probe(). It takes the probe function as a
> > parameter so that it can be left out of the platform_driver struct.
> > After it returns, there are no references to the probe function left
> > around, so if you call platform_driver_probe() instead of
> > platform_driver_register(), the probe function can be __init.  
> 
> ah, thanks for that.  i think in that case, there's no way to bind the
> release function to the process ?  which means the driver is no longer
> unloadable ?  which means the platform driver release function can be
> scrubbed as well as the module exit function as well as changing the
> Kconfig to be a bool ?

No, you can still provide a remove() callback, but it can usually be
__exit_p since it will only be needed if you compile the driver as a
module.

The platform_driver will be registered just as before; the only
difference is that it won't have a probe() callback so dynamically
added devices can't be bound to the driver. If the driver has a
remove() callback, it will be called when the driver is unregistered,
but that will usually only happen if the driver is compiled as a
module (and has a module exit function.)

Haavard
