Return-Path: <linux-kernel-owner+w=401wt.eu-S1760218AbXKMRwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760218AbXKMRwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 12:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756635AbXKMRwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 12:52:46 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54202 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757130AbXKMRwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 12:52:45 -0500
Date: Tue, 13 Nov 2007 17:52:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: earny@net4u.de
Cc: list-lkml@net4u.de, linux-kernel@vger.kernel.org
Subject: Re: [BUG] pcmcia serial_cs no interrupts
Message-ID: <20071113175201.72995c65@the-village.bc.nu>
In-Reply-To: <200711131755.25246.list-lkml@net4u.de>
References: <200711131755.25246.list-lkml@net4u.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 17:55:25 +0100
Ernst Herzberg <list-lkml@net4u.de> wrote:

> 
> This pcmcia-card (UMTS Modem) only works if it shares his interrupt with
> another device, eg an usb mice. Moving the mice increases the connection
> speed, unplugging hangs the connection.

Thats consistent with the card not generating interrupts, or the
interrupts being misrouted. The serial driver polls the interrupt pending
bits on the chip so the actual serial chip is clearly expecting
interrupts to go somewhere. Given this seems to be card not laptop
specific it looks like there is magic intiialisation gloop required by
this chipset that we don't have.

> At the moment this card is my only way to reach the internet, but here in
> the hospital i have a lot time to test patches;)

You may want to boot with irqpoll that may help a bit.

Some info at: 

A helpful start would be to know if the setserial command (applied to
whatever tty your system calls the card) helps as given in:

https://bugs.launchpad.net/ubuntu/+source/pcmciautils/+bug/99479
