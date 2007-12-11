Return-Path: <linux-kernel-owner+w=401wt.eu-S1753454AbXLKNVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbXLKNVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 08:21:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbXLKNVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 08:21:12 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34448 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752159AbXLKNVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 08:21:11 -0500
Date: Tue, 11 Dec 2007 13:14:13 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <david@davidnewall.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Rene Herman <rene.herman@keyaccess.nl>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <andi@firstfloor.org>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
Message-ID: <20071211131413.1079be59@the-village.bc.nu>
In-Reply-To: <475DEB23.1000304@davidnewall.com>
References: <475879CD.9080006@reed.com>
	<p733auekcly.fsf@bingen.suse.de>
	<20071207160439.71b7f46a@the-village.bc.nu>
	<20071209125458.GB4381@ucw.cz>
	<20071209165908.GA15910@one.firstfloor.org>
	<20071209212513.GC24284@elf.ucw.cz>
	<475CBDD7.5050602@keyaccess.nl>
	<m3bq8y23de.fsf@maximus.localdomain>
	<475DE37F.20706@davidnewall.com>
	<475DE6F4.80702@zytor.com>
	<475DEB23.1000304@davidnewall.com>
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

> I really *hate* the idea that access to non-present hardware is used to 
> generate a delay.  That sucks so badly.  It's worthy of a school-aged 
> hacker, not of a world-leading operating system.  It's so not 
> best-practice that it's worst-practice.

Actually its very good practice.

The LPC bus behaviour is absolutely and precisely defined. The timing of
the inb is defined in bus clocks which is perfect as the devices needing
delay are running at a fraction of busclock usually busclock/2.

Older processors did not have a high precision timer so you couldn't
calibrate loop based delays for 1uS.

Port 0x80 is used all over the place for this, not just in Linux but in a
large number of DOS programs and other PC OS's. It's even got specific
hardware support in many of the chipsets so that you can make the latched
last 0x80 write appear on the parallel port for debugging.

Alan
