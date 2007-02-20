Return-Path: <linux-kernel-owner+w=401wt.eu-S965088AbXBTPo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965088AbXBTPo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965091AbXBTPo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:44:27 -0500
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:4594 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965088AbXBTPo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:44:26 -0500
Message-ID: <45DB174F.30708@xs4all.nl>
Date: Tue, 20 Feb 2007 16:44:15 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <m3odnpq3yr.fsf@maximus.localdomain> <45DA7643.4020305@xs4all.nl> <200702201456.30794.s0348365@sms.ed.ac.uk>
In-Reply-To: <200702201456.30794.s0348365@sms.ed.ac.uk>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=8300CC02
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair John Strachan wrote:
> On Tuesday 20 February 2007 04:17, Udo van den Heuvel wrote:
>> Krzysztof Halasa wrote:
>>> Is it a VIA ITX board? I think I have VIA's riser card somewhere,
>>> could check what it does.
>> Yes, VIA Epia EN12000.
>> Interesting to check the riser card.
> 
> Just be aware that there are two types of PCI riser -- risers that work in any 
> board, and Via Epia-specific risers. The latter requires a BIOS update on 
> some Epias and presumably has some advantages, possible the ones you're 
> looking for.

This card is sold by TranquilPC for their T2e case which holds Mini-ITX
boards. My EN12000 has the latest BIOS I could find on the VIA site:
http://www.via.com.tw/en/products/mainboards/downloads.jsp?motherboard_id=399#BIOS


I just tested with Device Number 12 and DN 18 (the only free locations
to try besides the DN 19 default, if I am correct on this).

DN 12 gave me this:

00:0c.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: TERRATEC Electronic GmbH Unknown device 1157
        Flags: medium devsel, IRQ 255
        Memory at fdfff000 (32-bit, non-prefetchable) [size=512]


No irq! The other card remained at DN20 and irq 20.
So no visible i2c at all (!) for the DVB-T card.

DN 18 gave me:

00:12.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: TERRATEC Electronic GmbH Unknown device 1157
        Flags: bus master, medium devsel, latency 32, IRQ 20
        Memory at fdffc000 (32-bit, non-prefetchable) [size=512]

00:14.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: TERRATEC Electronic GmbH Unknown device 1155
        Flags: bus master, medium devsel, latency 32, IRQ 21
        Memory at fdffb000 (32-bit, non-prefetchable) [size=512]

The DVB-T card had the same problems as with DN19 in irq mode. Visible
i2c bus but not usable i2c.

Any ideas about how to proceed?
What to test?


BTW:

Another case I am considering has this drawing for the riser:
http://www.morex.com.tw/drawing/MAR122-J%20Drawing.pdf
DN ranges from 20 to 31. Would this improve the situation?

Kind regards,
Udo
