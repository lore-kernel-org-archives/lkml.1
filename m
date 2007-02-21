Return-Path: <linux-kernel-owner+w=401wt.eu-S1423064AbXBUUNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423064AbXBUUNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 15:13:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423065AbXBUUNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 15:13:12 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:41651 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423064AbXBUUNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 15:13:11 -0500
Date: Wed, 21 Feb 2007 15:13:03 -0500
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, Krzysztof Halasa <khc@pm.waw.pl>,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>
Subject: Re: PCI riser cards and PCI irq routing, etc
Message-ID: <20070221201303.GH22464@csclub.uwaterloo.ca>
References: <45D85DA1.7090502@xs4all.nl> <m3odnpq3yr.fsf@maximus.localdomain> <45DA7643.4020305@xs4all.nl> <200702201456.30794.s0348365@sms.ed.ac.uk> <45DB174F.30708@xs4all.nl> <45DC0FCC.7010705@xs4all.nl> <m3wt2bem13.fsf@maximus.localdomain> <45DC5E67.8060101@xs4all.nl> <45DC8B3A.2080301@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45DC8B3A.2080301@xs4all.nl>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 07:11:06PM +0100, Udo van den Heuvel wrote:
> BTW:
> 
> Is the situation, with default DN setting of 19 as displayed below,
> `normal` w.r.t. interrupts?
> I mean: Both the DVB card with DN19 and the Unichrome Pro video adapter
> have the same irq although they are on different busses.

Unfortunately, on bus 0, which is always the main bus of a system, there
is no such thing as normal.  The BIOS knows how the mainboard is wired
and hence knows how to assign IRQs.  It is only ones you get past bus 0
and onto secondary busses behind bridges that fixed rules apply since
that is when things have to work universally.  So in your case, via can
do whatever they want with IRQs for each DN, since they know the layout
of the mainboard.  The problem with riser cards without a pci bridge
chip, is that they try to modify bus 0 without the knowledge of the
board maker, which means the bios won't have a clue how it is wired.
Use of any riser card not explicitly supported by the board is hence
unsupported and really not recommended.

> (...)
> 00:13.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>         Subsystem: TERRATEC Electronic GmbH Unknown device 1157
>         Flags: bus master, medium devsel, latency 32, IRQ 16
>         Memory at fdffc000 (32-bit, non-prefetchable) [size=512]
> 
> 00:14.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
>         Subsystem: TERRATEC Electronic GmbH Unknown device 1155
>         Flags: bus master, medium devsel, latency 32, IRQ 20
>         Memory at fdffb000 (32-bit, non-prefetchable) [size=512]
> 
> 01:00.0 VGA compatible controller: VIA Technologies, Inc. UniChrome Pro
> IGP (rev
>  01) (prog-if 00 [VGA])
>         Subsystem: VIA Technologies, Inc. UniChrome Pro IGP
>         Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 16
>         Memory at f4000000 (32-bit, prefetchable) [size=64M]
>         Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
>         [virtual] Expansion ROM at fc000000 [disabled] [size=64K]
>         Capabilities: [60] Power Management version 2
>         Capabilities: [70] AGP version 3.0
> 
> How can I find out what INT_A/B/C/D line is mapped to what irq?

Read the manual/developer guide.

--
Len Sorensen
