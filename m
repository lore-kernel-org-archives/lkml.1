Return-Path: <linux-kernel-owner+w=401wt.eu-S1422789AbXBUTgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422789AbXBUTgP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 14:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422832AbXBUTgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 14:36:15 -0500
Received: from khc.piap.pl ([195.187.100.11]:47389 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422789AbXBUTgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 14:36:14 -0500
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: PCI riser cards and PCI irq routing, etc
References: <45D85DA1.7090502@xs4all.nl> <m3odnpq3yr.fsf@maximus.localdomain>
	<45DA7643.4020305@xs4all.nl>
	<200702201456.30794.s0348365@sms.ed.ac.uk> <45DB174F.30708@xs4all.nl>
	<45DC0FCC.7010705@xs4all.nl> <m3wt2bem13.fsf@maximus.localdomain>
	<45DC5E67.8060101@xs4all.nl>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 21 Feb 2007 20:36:12 +0100
In-Reply-To: <45DC5E67.8060101@xs4all.nl> (Udo van den Heuvel's message of "Wed, 21 Feb 2007 15:59:51 +0100")
Message-ID: <m3649vs3pv.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Udo van den Heuvel <udovdh@xs4all.nl> writes:

> But the IRQ for the DVB-T card doesn't work.

That's because the card drives incorrect INT line. The system (BIOS,
Linux) thinks the card would drive INT_D (as seen at the MB PCI slot)
and and card drives (its INT_A) INT_B.

> I would need to test the DVB-T card alone to be sure it has working IRQ.
> If so, what would be the conclusion?

I'd expect it to work. Anyway, you'd need to change the mapping.
Of course, you have to select device # = 19 (0x13).

> What IRQ rerouting would I need to try? 1 of 3 choices?
> Or one best bet?

You can test if it works first by connecting lines INT B and INT D
on the motherboard (or on the device 0x14 slot). That's pins B7 and B8
(you may want to google PCI slot pinout, "B" is the "component side").
I think a small piece of conductive film (aluminum or so) placed
carefully with the card would do. Make sure not to damage the
connector pins and not to short any additional connectors.

It can a) work, b) not work, c) give you "interrupt stuck -> disabled"
messages (and perhaps make the system unusable until the film is
removed).

I'd verify my speculation WRT the riser card is correct and the lines
are indeed connected as follows:
   (device 0x13=19) ABCD -> BCDA (MB slot = device 0x14=20).
That means pin A6 on device 0x13 connected to B7 on device 0x14 and on
edge connector going to MB slot, pin B7 on 0x13 to A7 on 0x14/MB,
pin A7 on 0x13 to B8 on 0x14/MB, pin B8 on 0x13 to pin A6 on 0x14/MB.

If that is the case and the alu film works, then (assuming you only
need a single IRQ for 0x13) you have to cut connection between A6 on
0x13 and B7 on 0x14 (B7 on 0x14 and B7 on edge connector should stay),
then connect that A6 on 0x13 to B8 on 0x14/MB.

I think the modification should rather be done by someone who knows
how to solder electronics.
-- 
Krzysztof Halasa
