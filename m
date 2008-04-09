Return-Path: <linux-kernel-owner+w=401wt.eu-S1757330AbYDITN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330AbYDITN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 15:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbYDITNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 15:13:43 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54942 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754961AbYDITNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 15:13:42 -0400
Date: Wed, 9 Apr 2008 20:09:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Dmitry <dbaryshkov@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       lethal@linux-sh.org, philipp.zabel@gmail.com, pavel@ucw.cz,
       tony@atomide.com, paul@pwsan.com
Subject: Re: [PATCH 5/6] Clocklib: Use correct clock for IrDA on pxa
Message-ID: <20080409200916.78615f39@core>
In-Reply-To: <20080409190504.GA13891@flint.arm.linux.org.uk>
References: <20080403132142.GA26882@doriath.ww600.siemens.net>
	<20080403132402.GA27008@doriath.ww600.siemens.net>
	<20080407160029.f1f9ce4f.akpm@linux-foundation.org>
	<20080407230434.GA525@flint.arm.linux.org.uk>
	<bc64b4640804080247s82ba84chd740c08b2fbb9b1a@mail.gmail.com>
	<20080408193309.GA18053@flint.arm.linux.org.uk>
	<bc64b4640804090015m7dd640d5j31c54b99007f09a7@mail.gmail.com>
	<20080409190504.GA13891@flint.arm.linux.org.uk>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> TBH, I'm not sure what the status of the kernel-side IrDA drivers are -
> maybe this is an issue which Samuel Ortiz could tackle if he has time.
> That would solve this issue on both 8250-based ports as well as SA11x0
> and PXA platforms.

I think "in need of much love" would be a polite way to put it and some
of them are probably going to break soon as they pretend to be tty
devices but fake it badly.

> Basically what I'm thinking is a serial_core function which could be
> called to say "I'm an IrDA driver, and I think I should be using the
> serial port located <here>, please give me control of it" and it'd
> pass over the various parameters including the struct device for it.
> Or something like that.

It's called a line discipline, we've had them for many years. We may need
a way for ldiscs and drivers to co-operate a bit more but these days we
support proper buffering and arbitary baud rates (except on a few
platforms whose maintainers are not paying attention ;)).

So I don't actually see why the FIR layer can't become a good citizen.

Alan
