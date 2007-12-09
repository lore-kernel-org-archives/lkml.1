Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbXLIPyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbXLIPyb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 10:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751225AbXLIPyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 10:54:23 -0500
Received: from mail.atlantis.sk ([80.94.52.35]:51740 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbXLIPyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 10:54:22 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
Date: Sun, 9 Dec 2007 16:54:11 +0100
User-Agent: KMail/1.9.7
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <475879CD.9080006@reed.com> <20071207160439.71b7f46a@the-village.bc.nu> <20071209125458.GB4381@ucw.cz>
In-Reply-To: <20071209125458.GB4381@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712091654.15072.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 December 2007 13:54:58 you wrote:
> Hi!
>
> > > modern CPU compared to the bus. But the delay really needs to be
> > > something that is about IO port speed. Ok in theory you could try to
> > > measure a outb using RDTSC and then use udelay, but first you would
> > > need
> >
> > You don't need to. Port 0x80 historically is about 8uS so just udelay(8)
> > and make sure the initial default delay is conservative enough before the
> > CPU speed is computed.
> >
> > 0x80 should be fine for anything PC compatible anyway, its specifically
> > reserved as a debug port and supported for *exactly* that purpose by
> > many chipsets.
>
> Actually, I've seen few pci cards with leds on port 0x80, and I
> wonder: is our outb_p really correct?
>
> I mean, we expect 8usec delay -- historical ISA timing -- but when
> _PCI_ card with leds is inserted, it is likely to be faster than old
> ISA, right?
> 							Pavel

Yes, there are PCI POST debug cards too. And also MiniPCI ones for notebooks. 
Port 0x80 could be used for more useful things than delay with these cards 
(and mainboards with integrated LED display) - like (kernel) debugging or as 
a temperature display (when exported to userspace).

-- 
Ondrej Zary
