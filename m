Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbYFPUOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbYFPUOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 16:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbYFPUOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 16:14:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51951 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753520AbYFPUOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 16:14:14 -0400
Date: Mon, 16 Jun 2008 20:56:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       jaswinder@infradead.org
Subject: Re: [PATCH] ip2: use request_firmware()
Message-ID: <20080616205638.2e9930fe@lxorguk.ukuu.org.uk>
In-Reply-To: <4856C6C8.6060506@garzik.org>
References: <1213609751.26255.673.camel@pmac.infradead.org>
	<20080616115950.41bc65aa@lxorguk.ukuu.org.uk>
	<4856C6C8.6060506@garzik.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Acked-by: Alan Cox <alan@redhat.com>
> 
> Except for the part where the firmware is pointlessly separated from the 
> driver.
> 
> We do not need two parallel driver hierarchies, one for firmware, one 
> for C source.

It makes enormous sense to me that we split them up. I don't care about
or believe the gnewspeak about licensing some people spew on the issue
but as a simple practical consideration:

- I don't want to wade through a ton of hex when looking at the driver
- I don't gain anything but having a ton of hex in the driver files
- I'd rather the ip2 firmware was ultimately loaded and unloaded when
needed as it saves us a load of non-pageable RAM.
- The firmware is a separate piece of software run on a separate CPU on a
seperate box on a separate card.

So from purely technical perspectives I think the patch is a very good
one, and as the nearest thing we have to a serial maintainer it gets my
ack. The only thing they share is an agreed API over the ISA/PCI bus -
and that isn't defined by peering at the firmware image.

Alan
