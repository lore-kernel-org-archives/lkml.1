Return-Path: <linux-kernel-owner+w=401wt.eu-S1752055AbZH1HNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055AbZH1HNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 03:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZH1HNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 03:13:13 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:64035 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbZH1HNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 03:13:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tAv2FLPm3lJqnIIHkVzGekPhRYVfObCAClr0sdk0N7spsrqf7hgcZo7qfcRRCv084h
         MV/h/szNGjAYhyW1W2q2RqhrT6Sptl62BeDJb1Q4bLZG7wGNnm7GspWrJk+/wGX4kc+d
         4awRK6f4v3iagXV09pLHRN+QnvO7Fod1FFv90=
MIME-Version: 1.0
In-Reply-To: <664902dd0908272057g143f5717k7ae12e8f0e12f67d@mail.gmail.com>
References: <664902dd0908270449x24f3ee12k615540ffe22e5b58@mail.gmail.com>
	 <20090827161929.253e001d@jbarnes-g45>
	 <664902dd0908272057g143f5717k7ae12e8f0e12f67d@mail.gmail.com>
Date: Fri, 28 Aug 2009 15:13:13 +0800
Message-ID: <664902dd0908280013j287df5bcqe5fa3e552db40e85@mail.gmail.com>
Subject: Re: (Re)assignment of PCI BARs
From: Beng Tan <bengtan1@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've found a satisfactory fix for myself ... not quite sure if I've
got the full picture correct, but for those who are interested in
reading ...

Using the boot parameter pci=resource_alignment=26@00:1c.3; I was able
to get the kernel to reassign the intervening bridge. My iomem was
then (excerpt only) ...

88000000-9fffffff : PCI Bus 0000:0d
  88000000-8801ffff : 0000:0d:00.0
  90000000-9fffffff : 0000:0d:00.0
a0000000-a00fffff : PCI Bus 0000:0d
  a0000000-a000ffff : 0000:0d:00.0
  a0010000-a0013fff : 0000:0d:00.1
a0100000-a0100fff : Intel Flush Page
d0000000-dfffffff : 0000:00:02.0

Forcing a resource_alignment reallocated the bridge's windows and
freed up space for the graphics card, which is now like so:

0d:00.0 VGA compatible controller: ATI Technologies Inc Unknown device
9540 (prog-if 00 [VGA controller])
  Subsystem: Giga-byte Technology Unknown device 21ae
  Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B-
  Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
  Latency: 0, Cache Line Size: 64 bytes
  Interrupt: pin A routed to IRQ 19
  Region 0: Memory at 90000000 (64-bit, prefetchable) [size=256M]
  Region 2: Memory at a0000000 (64-bit, non-prefetchable) [size=64K]
  Region 4: I/O ports at de00 [size=256]
  Expansion ROM at 88000000 [disabled] [size=128K]

(I'm not sure if an align order of 26 is too much. A lesser number may
work just as well, but I haven't tested this)

>From here on, the card and everything else just worked, including X
(albeit with some xorg.conf tweaking).

So, all I have to do is go buy two monitors :( and I can have 3
external monitors on my old crappy laptop :)

For those who are also interested in hooking external PCIe cards to
their laptop's Expresscard port, the PE2L hardware does work. However,
you may encounter BIOS-induced PCI resource allocation issues, and
whether your distribution is recent enough to fix this is an open
question.

Thanks all for reading.

Beng
