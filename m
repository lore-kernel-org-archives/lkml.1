Return-Path: <linux-kernel-owner+w=401wt.eu-S1757355AbYLEI1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355AbYLEI1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYLEI1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:27:40 -0500
Received: from hpsmtp-eml14.KPNXCHANGE.COM ([213.75.38.114]:2850 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953AbYLEI1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:27:39 -0500
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Fri, 5 Dec 2008 09:27:34 +0100
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <alpine.LFD.2.00.0812041917050.3386@nehalem.linux-foundation.org> <200812050744.56018.elendil@planet.nl>
In-Reply-To: <200812050744.56018.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812050927.35737.elendil@planet.nl>
X-OriginalArrivalTime: 05 Dec 2008 08:27:36.0334 (UTC) FILETIME=[53E3C2E0:01C956B3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 December 2008, Frans Pop wrote:
> On Friday 05 December 2008, Linus Torvalds wrote:
> > Here's a patch that implements what I think is the correct quirks
> > (apart from the commented ICH6 lazy detail I didn't do).
>
> I get:
> pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
> pci 0000:00:1f.0: quirk: region 1100-113f claimed by ICH6 GPIO
> pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0500 (mask 007f)
> pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 02e8 (mask 0007)

Sorry, I missed:
> It would be very interesting to see if people affected get any
> printouts about IO decodes that don't show up in /proc/ioports...

Looks like 02e8 is missing (see /proc/ioports below).


I also tried the patch on my ICH7 desktop which gives:
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0680 (mask 007f)
But 0680 is accounted for in /proc/ioports:
0680-06ff : pnp 00:06

Cheers,
FJP

/proc/ioports (for notebook):
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0071 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.1
  0170-0177 : ata_piix
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : ata_piix
02f8-02ff : pnp 00:0c
0376-0376 : 0000:00:1f.1
  0376-0376 : ata_piix
03c0-03df : vesafb
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : ata_piix
03f8-03ff : pnp 00:0c
04d0-04d1 : pnp 00:0c
0500-055f : pnp 00:0a
0800-080f : pnp 00:0a
0cf8-0cff : PCI conf1
1000-107f : 0000:00:1f.0
  1000-107f : pnp 00:0c
    1000-1003 : ACPI PM1a_EVT_BLK
    1004-1005 : ACPI PM1a_CNT_BLK
    1008-100b : ACPI PM_TMR
    1010-1015 : ACPI CPU throttle
    1020-1020 : ACPI PM2_CNT_BLK
    1028-102f : ACPI GPE0_BLK
    1060-107f : iTCO_wdt
1100-113f : 0000:00:1f.0
  1100-113f : pnp 00:0c
1200-121f : pnp 00:0c
2000-2007 : 0000:00:02.0
2008-200f : 0000:00:03.2
2010-2013 : 0000:00:03.2
2018-201f : 0000:00:03.2
2020-2023 : 0000:00:03.2
2030-203f : 0000:00:03.2
2040-2047 : 0000:00:03.3
  2040-2047 : serial
2060-207f : 0000:00:19.0
2080-209f : 0000:00:1a.0
  2080-209f : uhci_hcd
20a0-20bf : 0000:00:1a.1
  20a0-20bf : uhci_hcd
20c0-20df : 0000:00:1d.0
  20c0-20df : uhci_hcd
20e0-20ff : 0000:00:1d.1
  20e0-20ff : uhci_hcd
2100-211f : 0000:00:1d.2
  2100-211f : uhci_hcd
2120-212f : 0000:00:1f.1
  2120-212f : ata_piix
3000-3fff : PCI Bus 0000:02
  3000-30ff : PCI CardBus 0000:03
  3400-34ff : PCI CardBus 0000:03
