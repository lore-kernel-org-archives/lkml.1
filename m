Return-Path: <linux-kernel-owner+w=401wt.eu-S1759972AbXFQMNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972AbXFQMNN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 08:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758764AbXFQMM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 08:12:59 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50917
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360AbXFQMM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 08:12:58 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Subject: Re: b44: high ping times with wireless-dev
Date: Sun, 17 Jun 2007 14:12:44 +0200
User-Agent: KMail/1.9.6
Cc: netdev <netdev@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       Gary Zambrano <zambrano@broadcom.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       "Jeff Garzik" <jgarzik@pobox.com>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>
References: <200706162327.47413.maxi@daemonizer.de> <200706171255.40155.mb@bu3sch.de> <200706171403.34299.maxi@daemonizer.de>
In-Reply-To: <200706171403.34299.maxi@daemonizer.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706171412.45074.mb@bu3sch.de>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 June 2007 14:03:30 Maximilian Engelhardt wrote:
> On Sunday 17 June 2007, Michael Buesch wrote:
> > On Saturday 16 June 2007 23:27:43 Maximilian Engelhardt wrote:
> > > [...]
> > > ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
> > > ACPI: PCI Interrupt 0000:02:02.0[A] -> Link [LNKD] -> GSI 10 (level, low)
> > > -> IRQ 10
> > > ssb: Sonics Silicon Backplane found on PCI device 0000:02:02.0
> > > b44.c:v2.0
> > > eth0: Broadcom 44xx/47xx 10/100BaseT Ethernet 00:c0:9f:29:99:a7
> > > [...]
> >
> > Ok, I prepared two debugging patches.
> >
> > Please enable SonicsSiliconBackplane Debugging in the kernel kconfig,
> > so I can get more detail information about your card.
> > Device Drivers/Sonics Silicon Backplane/SSB debugging
> > (Must disable "No SSB kernel messages")
> >
> > Please apply and test the attached debugging patches in a row.
> > So apply patch 1 and test if it works again. If not, apply
> > patch 2 and test if it works.
> > Always save complete dmesg log on each test run and send it to me.
> >
> > Thanks for testing.
> > (This time it seems we are actually getting somewhere, when
> > dealing with sane people. :D )
> 
> I did the tests with my kernel where only the card is on interrupt 10. dmesg 
> is attached.
> With the first patch applied networking does work again. I also additionally 
> tried patch2 and it also does work.

Great!
To me this seems to be a silicon bug. The IRQ routing value, which is read
from the chip here, is hardcoded in the old b44 driver.
I'll implement a workaround for this and submit a patch.

-- 
Greetings Michael.
