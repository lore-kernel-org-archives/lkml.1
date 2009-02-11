Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbZBKCDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbZBKCDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 21:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZBKCDI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 21:03:08 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:42353 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbZBKCDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 21:03:06 -0500
Date: Wed, 11 Feb 2009 02:03:00 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Corentin Chary <corentin.chary@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Subject: Re: Oopses and ACPI problems (Linus 2.6.29-rc4)
Message-ID: <20090211020300.GA5786@srcf.ucam.org>
References: <alpine.LFD.2.00.0902081251090.3048@localhost.localdomain> <gemini.ket9w800w44dc0hvg.linux@youmustbejoking.demon.co.uk> <20090209234911.GB862@elte.hu> <5030E21460%linux@youmustbejoking.demon.co.uk> <20090210150431.GA26798@srcf.ucam.org> <5030E7CFF4%linux@youmustbejoking.demon.co.uk> <20090210154533.GA27596@srcf.ucam.org> <71cd59b00902100806s44f40812p441fae0b157cdb9c@mail.gmail.com> <5030FDE2BC%linux@youmustbejoking.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5030FDE2BC%linux@youmustbejoking.demon.co.uk>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 07:16:27PM +0000, Darren Salt wrote:

> From 2.6.28.4:
> [    0.898903] eeepc: Eee PC Hotkey Driver
> [    0.902414] eeepc: Hotkey init (getting ACPI bus status)
> [    0.905913] eeepc: Hotkey init (init flags)
> [    2.620193] eeepc: Hotkey init flags 0x41
> [    2.626667] eeepc: Get control methods supported: 0x101713
> [    2.630215] input: Asus EeePC extra buttons as /class/input/input4

So we see the expected BIOS bizarro pause there...

> From 2.6.29-rc4:
> 
> [    2.141971] eeepc: Eee PC Hotkey Driver
> [    2.145325] eeepc: Hotkey init (getting ACPI bus status)
> [    2.148555] eeepc: Hotkey init (init flags)
> [    2.286445] usb 5-1: new full speed USB device using uhci_hcd and address 2
> [... USB Bluetooth device; Elantech test ...]
> [    2.780187] input: ETPS/2 Elantech Touchpad as /class/input/input5
> [   28.088399] eeepc: Hotkey init flags 0x41
> [   28.094880] eeepc: Get control methods supported: 0x101713
> [   28.098425] input: Asus EeePC extra buttons as /class/input/input6

And a rather more upsetting 26 second pause here. Yeah, ok, that's 
clearly a regression. I don't see any obvious way that it's an 
eeepc-laptop bug, though...

-- 
Matthew Garrett | mjg59@srcf.ucam.org
