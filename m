Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbXLJLbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbXLJLbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 06:31:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbXLJLa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 06:30:57 -0500
Received: from khc.piap.pl ([195.187.100.11]:60858 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbXLJLa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 06:30:56 -0500
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "David P. Reed" <dpreed@reed.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with MCP51 laptops
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de>
	<20071207160439.71b7f46a@the-village.bc.nu>
	<20071209125458.GB4381@ucw.cz>
	<20071209165908.GA15910@one.firstfloor.org>
	<20071209212513.GC24284@elf.ucw.cz> <475CBDD7.5050602@keyaccess.nl>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 10 Dec 2007 12:30:53 +0100
In-Reply-To: <475CBDD7.5050602@keyaccess.nl> (Rene Herman's message of "Mon, 10 Dec 2007 05:17:27 +0100")
Message-ID: <m3bq8y23de.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman <rene.herman@keyaccess.nl> writes:

> Alan, did you double-check that 8 us? I tried to but I seem to not
> have trustworthy documentation.

I remember 16-bit CPU-driven ISA was able to do 2-3 MB/s transfers,
that means at least 1 Maccesses/second = up to 1 microsecond/access.

Perhaps IO ports accesses were slower than memory? But 8-12 times?
Perhaps port 0x80 was using (slower) 8-bit timings?

Bus-mastering ISA cards were able to do ca. 5 MB/s with 8 MHz (10 MHz?)
clocking, some old machines didn't like it.

Googling suggests that a slave access on 8-bit ISA bus was taking
6 cycles by default (including 4 wait states), 16-bit - 3 cycles
(with 1 WS). Respectively 0.75 us and 0.375 us, and 0.25 us for
16-bit 0WS memory access (with standard 8 MHz clock).

These values could be changed with BIOS setup, and devices could
use 0WS or I/O CHRDY signals if they didn't like the defaults
(dir 0WS mean 1 WS for 8-bit devices?).
-- 
Krzysztof Halasa
