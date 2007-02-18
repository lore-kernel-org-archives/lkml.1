Return-Path: <linux-kernel-owner+w=401wt.eu-S1750857AbXBRQPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750857AbXBRQPf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 11:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbXBRQPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 11:15:34 -0500
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3412 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbXBRQPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 11:15:34 -0500
Message-ID: <45D87BA2.9020001@xs4all.nl>
Date: Sun, 18 Feb 2007 17:15:30 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <20070218155445.GV7584@csclub.uwaterloo.ca>
In-Reply-To: <20070218155445.GV7584@csclub.uwaterloo.ca>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Sun, Feb 18, 2007 at 03:07:29PM +0100, Udo van den Heuvel wrote:
>> How, based on what information, does Linux assign an IRQ to each card,
>> plugged into the riser?
>> How can one tweak/influence the irq routing?
>> How can I make a dual riser card work so that both cards have a working
>> interrupt?
>> Or if stuff should work all by itself, what could be wrong?
> 
> The PCI specifications cover how pci to pci bridges should work.
> 
> My understanding (which is better of verified against the specs) is:
[....]
> The same rules apply behind a PCI bridge, so whatever INTA is on the
> slot with the pci bridge chip, should make to INTA on slots 0, 4, 8, etc
> behind the bridge, while INTB is seen as INTA on slots 1, 5, 9, etc.

FYI: My situation is a VIA Epia EN12000 with a TranquilPC dual PCI riser
where only the Device Number can be changed.
The kernel sees the two DVB cards in there as:

saa7146: register extension 'budget_av'.
ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 16 (level, low) -> IRQ 16
saa7146: found saa7146 @ mem f8c3e000 (revision 1, irq 16) (0x153b,0x1157).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (Terratec Cinergy 1200 DVB-T).
adapter failed MAC signature check
encoded MAC from EEPROM was
ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
KNC1-0: MAC addr = 00:0a:ac:01:d6:87
DVB: registering frontend 0 (Philips TDA10046H DVB-T)...
budget-av: ci interface initialised.
ACPI: PCI Interrupt 0000:00:14.0[A] -> GSI 17 (level, low) -> IRQ 20
saa7146: found saa7146 @ mem f8cb2000 (revision 1, irq 20) (0x153b,0x1155).
saa7146 (1): dma buffer size 192512
DVB: registering new adapter (TerraTec Cinergy 1200 DVB-S).
adapter failed MAC signature check
encoded MAC from EEPROM was
ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
sd 0:0:0:0: Attached scsi generic sg0 type 0
KNC1-1: MAC addr = 00:0a:ac:12:93:8d
DVB: registering frontend 1 (ST STV0299 DVB-S)...
budget-av: ci interface initialised.

So IRQ 16 and 20. But when using the stock 2.6.20 kernel there is no
communication with the DVB-T card (the frontend), so there is no
/dev/dvb/* entry. This points to an IRQ problem.

How can I find out the actual IRQ that the card is using?
If it is different from what Linux thinks: how do I tell Linux?

> On a PC, the BIOS is supposed to assign interrupts to devices based on
> those rules, since that is how the hardware must be done according to
> the PCI specifications.  

I set the BIOS for 'PnP OS installed'. Should I change that?

> (....)

Thanks for your response!

Kind regards,
Udo



