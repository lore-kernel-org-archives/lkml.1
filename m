Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbXLJSDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbXLJSDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 13:03:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbXLJSDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 13:03:01 -0500
Received: from mail.atlantis.sk ([80.94.52.35]:42156 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbXLJSDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 13:03:00 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
Date: Mon, 10 Dec 2007 19:02:52 +0100
User-Agent: KMail/1.9.7
Cc: Rene Herman <rene.herman@keyaccess.nl>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <475879CD.9080006@reed.com> <475CBDD7.5050602@keyaccess.nl> <m3bq8y23de.fsf@maximus.localdomain>
In-Reply-To: <m3bq8y23de.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712101902.55933.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2007 12:30:53 Krzysztof Halasa wrote:
> Rene Herman <rene.herman@keyaccess.nl> writes:
> > Alan, did you double-check that 8 us? I tried to but I seem to not
> > have trustworthy documentation.
>
> I remember 16-bit CPU-driven ISA was able to do 2-3 MB/s transfers,
> that means at least 1 Maccesses/second = up to 1 microsecond/access.

Hard disk is limited to about 2 MB/s when connected through ISA controller, 
IIRC. That's 16-bit PIO transfer.

> Perhaps IO ports accesses were slower than memory? But 8-12 times?
> Perhaps port 0x80 was using (slower) 8-bit timings?
>
> Bus-mastering ISA cards were able to do ca. 5 MB/s with 8 MHz (10 MHz?)
> clocking, some old machines didn't like it.

Yes, ISA clock can be changed on many machines. Most cards run fine even at 11 
(33/3) MHz with zero wait states. In fact, I haven't seen any card that did 
not.

> Googling suggests that a slave access on 8-bit ISA bus was taking
> 6 cycles by default (including 4 wait states), 16-bit - 3 cycles
> (with 1 WS). Respectively 0.75 us and 0.375 us, and 0.25 us for
> 16-bit 0WS memory access (with standard 8 MHz clock).
>
> These values could be changed with BIOS setup, and devices could
> use 0WS or I/O CHRDY signals if they didn't like the defaults
> (dir 0WS mean 1 WS for 8-bit devices?).

-- 
Ondrej Zary
