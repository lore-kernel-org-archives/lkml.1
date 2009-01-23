Return-Path: <linux-kernel-owner+w=401wt.eu-S1760797AbZAWSAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760797AbZAWSAZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 13:00:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbZAWSAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 13:00:12 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58095 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756048AbZAWSAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 13:00:11 -0500
Date: Fri, 23 Jan 2009 18:00:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Walrond <andrew@walrond.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: serial8250 madness
Message-ID: <20090123180033.3e67f542@lxorguk.ukuu.org.uk>
In-Reply-To: <497A0164.90409@walrond.org>
References: <497A0164.90409@walrond.org>
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

> ttyS0 works fine. Can get grub output, kernel boot and console via ttyS0 
> as I wanted.
> ttyS1 doesn't work at all. It's detected, enabled in the bios etc etc 
> but just doesn't work at all.

You don't give much information but if it seems to be non working then I
would look hard at the IRQ/IO reported

> Machine B
> 
> ttyS0 and ttyS1 will both receive, but neither will send. Go figure. 
> Tested using a null modem cable, setserial and cu against the known good 
> machine above.

Boggle - what flow control wiring have you done ?

> Machine C
> 
> Grub and kernel outputs fine during boot, right up til the serial8250 
> output appears in the kernel log, at which point it then prints 'LSR 
> safety check engaged' and reboots.
> Tried again without the console=ttyS0,57600 kernel parameter and it 
> boots OK but starts printing the 'LSR...' message again as soon as 
> agetty tries to attach to ttyS0. Doesn't reboot though...
> 
> The Machines are all amd64, various motherboards, identical distros 
> using 2.6.28.1 kernel.
> Either I have a particularly motley collection of kit, or the serial 
> code is in a pretty bad way.

It is maintained and should be pretty solid. Seria console is one of the
less used bits but when it gets broken people do jump up and down and
shout about it.

The big outstanding bug I know about is the incompatibility between the
PnP 8250 drivers and serial console - that may be your machine C case.
That one is rather hard to fix so on the long rather than short term hit
list.

Alan
