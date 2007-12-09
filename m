Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbXLIWgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbXLIWgI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 17:36:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbXLIWf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 17:35:56 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53510 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751225AbXLIWf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 17:35:56 -0500
Date: Sun, 9 Dec 2007 22:29:28 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <andi@firstfloor.org>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
Message-ID: <20071209222928.3f7b63a4@the-village.bc.nu>
In-Reply-To: <20071209212513.GC24284@elf.ucw.cz>
References: <475879CD.9080006@reed.com>
	<p733auekcly.fsf@bingen.suse.de>
	<20071207160439.71b7f46a@the-village.bc.nu>
	<20071209125458.GB4381@ucw.cz>
	<20071209165908.GA15910@one.firstfloor.org>
	<20071209212513.GC24284@elf.ucw.cz>
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

On Sun, 9 Dec 2007 22:25:13 +0100
Pavel Machek <pavel@ucw.cz> wrote:

> On Sun 2007-12-09 17:59:08, Andi Kleen wrote:
> > > I mean, we expect 8usec delay -- historical ISA timing -- but when
> > > _PCI_ card with leds is inserted, it is likely to be faster than old
> > > ISA, right?
> > 
> > Yes, i guess switching to udelay at least on newer systems would
> > be a good idea.  I'm not quite sure about systems without TSC though.
> 
> Something like this? (Warning, will not probably even compile on
> x86-64, I do not have 64-bit compiler near me).

You need to stick in a bug trap to verify that the udelay is not called
before the cpu timer has been set up.
