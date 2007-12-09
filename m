Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbXLINKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbXLINKt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 08:10:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750884AbXLINKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 08:10:41 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3571 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750812AbXLINKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 08:10:40 -0500
Date: Sun, 9 Dec 2007 12:54:58 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
Message-ID: <20071209125458.GB4381@ucw.cz>
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <20071207160439.71b7f46a@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207160439.71b7f46a@the-village.bc.nu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > modern CPU compared to the bus. But the delay really needs to be something
> > that is about IO port speed. Ok in theory you could try to measure
> > a outb using RDTSC and then use udelay, but first you would need
> 
> You don't need to. Port 0x80 historically is about 8uS so just udelay(8)
> and make sure the initial default delay is conservative enough before the
> CPU speed is computed.
> 
> 0x80 should be fine for anything PC compatible anyway, its specifically
> reserved as a debug port and supported for *exactly* that purpose by
> many chipsets.

Actually, I've seen few pci cards with leds on port 0x80, and I
wonder: is our outb_p really correct?

I mean, we expect 8usec delay -- historical ISA timing -- but when
_PCI_ card with leds is inserted, it is likely to be faster than old
ISA, right?
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
