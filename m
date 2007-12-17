Return-Path: <linux-kernel-owner+w=401wt.eu-S936308AbXLQVdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936308AbXLQVdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932991AbXLQVdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:33:08 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47925 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761947AbXLQVdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:33:04 -0500
Date: Mon, 17 Dec 2007 21:25:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Rene Herman <rene.herman@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Rolland <rol@as2917.net>,
       Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override.
Message-ID: <20071217212509.5edaa372@the-village.bc.nu>
In-Reply-To: <4766D175.7040807@reed.com>
References: <4762C551.5070003@zytor.com>
	<20071214210652.GB28793@elf.ucw.cz>
	<4763001A.1070102@zytor.com>
	<20071214232955.545ab809@the-village.bc.nu>
	<20071215080831.404cdb32@tux.DEF.witbe.net>
	<47638C8C.2090604@gmail.com>
	<476438B4.2020600@zytor.com>
	<476462BE.3030701@gmail.com>
	<4764687D.6080609@zytor.com>
	<476524DB.7020806@gmail.com>
	<20071216152250.GA21245@elte.hu>
	<4765D43E.1010800@gmail.com>
	<4765D95C.4010404@zytor.com>
	<4765DCB0.8030901@gmail.com>
	<4765EE7F.80002@zytor.com>
	<47667366.7010405@gmail.com>
	<4766AE88.4080904@zytor.com>
	<4766D175.7040807@reed.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> responds to reads differently than "unused" ports.  In particular, an 
> inb takes 1/2 the elapsed time compared to a read to "known" unused port 
> 0xed - 792 tsc ticks for port 80 compared to about 1450 tsc ticks for 
> port 0xed and other unused ports (tsc at 800 MHz).

Well at least we know where the port is now - thats too fast for an LPC
bus device, so it must be an SMI trap.

Only easy way to find out is to use the debugging event counters and see
how many instruction cycles are issued as part of the 0x80 port. If its
suprisingly high then you've got a firmware bug and can go spank HP.
