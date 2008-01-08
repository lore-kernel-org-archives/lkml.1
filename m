Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbYAHOkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbYAHOkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 09:40:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbYAHOj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 09:39:59 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43911 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759206AbYAHOj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 09:39:57 -0500
Date: Tue, 8 Jan 2008 14:37:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "David P. Reed" <dpreed@reed.com>
Cc: Bodo Eggert <7eggert@gmx.de>, Rene Herman <rene.herman@keyaccess.nl>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christer Weinigel <christer@weinigel.se>, Ingo Molnar <mingo@elte.hu>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
Message-ID: <20080108143702.5569c7bf@lxorguk.ukuu.org.uk>
In-Reply-To: <478375AA.3090306@reed.com>
References: <9BdU5-1YW-9@gated-at.bofh.it>
	<9BeZN-3Gf-5@gated-at.bofh.it>
	<9BnTB-1As-31@gated-at.bofh.it>
	<9BrX4-8go-1@gated-at.bofh.it>
	<9BuBG-4eR-51@gated-at.bofh.it>
	<9BvRd-6aL-71@gated-at.bofh.it>
	<9GRQW-1DX-13@gated-at.bofh.it>
	<9GSah-23W-1@gated-at.bofh.it>
	<9GSDy-2GD-23@gated-at.bofh.it>
	<9GTpK-40d-15@gated-at.bofh.it>
	<9GUvy-5H2-11@gated-at.bofh.it>
	<9GVKU-7SS-25@gated-at.bofh.it>
	<E1JBxnV-00046d-CS@be1.7eggert.dyndns.org>
	<478281A6.1000704@zytor.com>
	<alpine.LSU.0.999.0801072226060.16143@be1.lrz>
	<4782A355.1070207@zytor.com>
	<alpine.LSU.0.999.0801072316440.16143@be1.lrz>
	<4782AED5.1060406@keyaccess.nl>
	<4782B4B9.2020608@zytor.com>
	<4782B515.3010008@keyaccess.nl>
	<alpine.LSU.0.999.0801081333530.12636@be1.lrz>
	<478375AA.3090306@reed.com>
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

> The last time I heard of a 12 MHz bus in a PC system was in the days of 
> the PC-AT, when some clone makers sped up their buses (pre PCI!!!) in an 
> attempt to allow adapter card *memory* to run at the 12 MHz speed.

It wasn't about clone makers speeding up their busses. The ISA bus
originally ran at the CPU clock - 4.77/8/6/10 .. etc. Quite a few board
makers assumed 8MHz and while faster isn't a big problem at 8bit trying
to do the 8/16 bit decode with logic chips at 8MHz is quite tight and
above that generally broke. 8bit tends to work fine because you've got a
lot more timing headroom.

> I can't believe that we are not supporting today's machines correctly 
> because we are still trying to be compatible with a few (at most a 
> hundre thousand were manufactured!  Much less still functioning or 
> running Linux) machines.

It is about supporting this properly. Properly for ISA devices means
using I/O delays. Properly for chipset devices is probably using udelay.

> Now I understand that PC/104 machines and other things are very non PC 
> compatible, but are x86 processor architectures.  Do they even run x86 
> under 2.6.24?

Linux runs on x86, it isn't limited to PC type architectures at all. We
don't need a BIOS, we don't need legacy compatible I/O devices.

> for "relics" and develop a merged architecture called "modern machines" 
> to include only those PCs that have been made to work since, say, the 
> release of (cough) WIndows 2000?

No point. We've got the 64bit kernel for that. That is a much saner
boundary to throw out all the nutty stuff.

Alan
