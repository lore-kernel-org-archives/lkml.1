Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638AbXKDXA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbXKDXA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 18:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbXKDXAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 18:00:20 -0500
Received: from khc.piap.pl ([195.187.100.11]:33653 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753206AbXKDXAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 18:00:19 -0500
To: andi@lisas.de
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-user@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
References: <471527E5.1050407@s5r6.in-berlin.de>
	<m34pgpmszu.fsf@maximus.localdomain>
	<47166C83.2050207@s5r6.in-berlin.de>
	<m3fy09ffp9.fsf@maximus.localdomain>
	<4719A0C4.3050301@s5r6.in-berlin.de>
	<m3bqausztv.fsf@maximus.localdomain>
	<4719FF0F.3080504@s5r6.in-berlin.de>
	<m3ejfp4bg9.fsf@maximus.localdomain>
	<4724C9DA.7030900@s5r6.in-berlin.de>
	<m33avvdlbq.fsf@maximus.localdomain>
	<20071104193109.GA4033@rhlx01.hs-esslingen.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 05 Nov 2007 00:00:16 +0100
In-Reply-To: <20071104193109.GA4033@rhlx01.hs-esslingen.de> (Andreas Mohr's message of "Sun, 4 Nov 2007 20:31:09 +0100")
Message-ID: <m38x5dhb0f.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr <andim2@users.sourceforge.net> writes:

> EEPROM dump (VT6306)
> 00: 00 11 06 66 45 55 56 E1 04 04 32 55 F8 00 A2 02
      --------- GUID --------

> 10: A1 00 40 63 06 11 44 30 03 DF 40 80 00 20 00 73
                  - subs ID -

> 20: 3C 10 00 00 00 00 FF FF FF FF FF FF FF FF FF FF
>
> Your VT6307 chip is in OHCI 1.0 mode

Thanks for the data. It's the same as for all my VT6307, excluding
GUID (different for every card) and PCI subsystem vendor/device IDs.

I guess Stefan could now try to write these values (except GUID
and probably PCI subsystem IDs, and with OHCI 1.1 bit) to the "bad"
card :-) I wouldn't try with a good card yet, though (unless you
know how to repair it and/or you want to risk it, and/or you
want to use the DOS utility mentioned by Stefan).

I would try myself but I have no VT6306.

BTW I don't know where I found the info about VT6306 not working
with I^2C EEPROMs but it seems to be false, the datasheets claim
both chips can get startup info from 4-wire or I^2C EEPROM. Given
that both chips have identical EEPROM interface (except "fast I^2C
mode" which means nothing) I'd be surprised if the program can't
set OHCI 1.1 on VT6306.

> And viewing from a quite problematic angle (card is in running PC,
> difficult to view) strongly seems to indicate a VT630_6_ (the "6" is
> quite clearly visible).
> This means that I currently cannot offer any mfct. date data however,
> unfortunately.

Yeah. I think (feel or something) VIA does the usual thing with
revision numbers so rev 0x46 means always the same silicon (VT6306)
and rev 0x80 is always the same VT6307. There might be other
revisions but I think we won't find non-VT6306 rev 0x46 or
non-VT6307 rev 0x80.

And, for someone using the old driver, VT6306 should probably have
8/8 IR/IT contexts while VT6307 - 4/8 (the new driver doesn't seem
to show this info and I think VT6306 can be limited to 4 as well).
-- 
Krzysztof Halasa
