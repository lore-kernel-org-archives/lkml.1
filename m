Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbXLKOdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbXLKOdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 09:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbXLKOdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 09:33:39 -0500
Received: from [81.2.110.250] ([81.2.110.250]:36124 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751615AbXLKOdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 09:33:38 -0500
Date: Tue, 11 Dec 2007 14:25:52 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <david@davidnewall.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Paul Rolland <rol@as2917.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
Message-ID: <20071211142552.2ae6ea9a@the-village.bc.nu>
In-Reply-To: <475E95A3.3070801@davidnewall.com>
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
	<20071211084059.3d03e11d@tux.DEF.witbe.net>
	<475E5D4B.8020101@keyaccess.nl>
	<475E7DC2.4060509@davidnewall.com>
	<475E8D91.20201@keyaccess.nl>
	<475E95A3.3070801@davidnewall.com>
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

> That could be true if outb_p were used only in architecture dependent 
> code, but it's not.  It's used in drivers that are supposed to run on 
> all sorts of platforms.  Why does a megaraid controller need delays on 
> i386 but not on Sparc, PowerPC, Alpha and others?  Is it buggy on most 
> platforms, or just unnecessarily slow on Intel?

Each platform provides its own versions of the various _p functions which
work as required for that platform.

As to megaraid, I don't have the docs so I couldn't specifically tell you
but the use in that driver looks dubious as its not an ISA/LPC device.

> It's most commonly a zero delay.  Only in the minority of architectures 
> is it otherwise.  If a delay is needed, then put one in, but don't put 
> in a paper promise that's more likely to be ignored than observed.

Most of those platforms have hardware that was designed not to need those
delays and they know that their CMOS clock etc are not clocked at half
the LPC bus clock. Thus they don't need _p.

> without need.  Not surprising since it has such a vague specific 
> meaning.  One could say, Linux on i386 is liberally sprinkled with 

"vague specific" ? sorry don't follow you.

Its an ISA bus delay on systems that need it (or an LPC bus delay on
newer ones).

> I really prefer accurate code, but I'm also pragmatic and realise that 
> it's far too much work to fix this any time soon.  But if it were to be 
> fixed, then perhaps _p would take an additional parameter, measured in 
> cycles of delay.

measured in what, against what, for which bus.

inb_p/outb_p are really only meaningful for ISA/LPC bus devices. In those
cases it is precisely defined. Its use for PCI devices is a bit suspect
and as a general rule probably wrong.

Alan
