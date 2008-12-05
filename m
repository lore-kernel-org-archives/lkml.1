Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbYLEIxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbYLEIxY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 03:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbYLEIxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 03:53:16 -0500
Received: from hpsmtp-eml20.KPNXCHANGE.COM ([213.75.38.85]:45994 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852AbYLEIxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 03:53:15 -0500
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: MSI changes in .28
Date: Fri, 5 Dec 2008 09:53:10 +0100
User-Agent: KMail/1.9.9
Cc: rjw@sisk.pl, greg@kroah.com, mingo@elte.hu, jbarnes@virtuousgeek.org,
       lenb@kernel.org, linux-kernel@vger.kernel.org, tiwai@suse.de,
       akpm@linux-foundation.org, ink@jurassic.park.msu.ru
References: <200812020320.31876.rjw@sisk.pl> <200812020629.26714.elendil@planet.nl> <alpine.LFD.2.00.0812020735150.3256@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812020735150.3256@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812050953.12238.elendil@planet.nl>
X-OriginalArrivalTime: 05 Dec 2008 08:53:12.0863 (UTC) FILETIME=[E7BB7AF0:01C956B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 December 2008, Linus Torvalds wrote:
> So, it looks like you have MSI enabled in -rc6, and not in -rc3.

I've just compared dmesg for my *desktop* and there I see the following
between 2.6.28-rc6 and current 2.6.28-rc7:

 pcieport-driver 0000:00:1c.0: setting latency timer to 64
 pcieport-driver 0000:00:1c.0: found MSI capability
-pcieport-driver 0000:00:1c.0: irq 47 for MSI/MSI-X
+pcieport-driver 0000:00:1c.0: irq 511 for MSI/MSI-X
 pci_express 0000:00:1c.0:pcie00: allocate port service
 pci_express 0000:00:1c.0:pcie02: allocate port service
 pcieport-driver 0000:00:1c.2: setting latency timer to 64
 pcieport-driver 0000:00:1c.2: found MSI capability
-pcieport-driver 0000:00:1c.2: irq 46 for MSI/MSI-X
+pcieport-driver 0000:00:1c.2: irq 510 for MSI/MSI-X
 pci_express 0000:00:1c.2:pcie00: allocate port service
 pci_express 0000:00:1c.2:pcie02: allocate port service
 pcieport-driver 0000:00:1c.3: setting latency timer to 64
 pcieport-driver 0000:00:1c.3: found MSI capability
-pcieport-driver 0000:00:1c.3: irq 45 for MSI/MSI-X
+pcieport-driver 0000:00:1c.3: irq 509 for MSI/MSI-X
 pci_express 0000:00:1c.3:pcie00: allocate port service
 pci_express 0000:00:1c.3:pcie02: allocate port service
 pcieport-driver 0000:00:1c.4: setting latency timer to 64
 pcieport-driver 0000:00:1c.4: found MSI capability
-pcieport-driver 0000:00:1c.4: irq 44 for MSI/MSI-X
+pcieport-driver 0000:00:1c.4: irq 508 for MSI/MSI-X
 pci_express 0000:00:1c.4:pcie00: allocate port service
 pci_express 0000:00:1c.4:pcie02: allocate port service
 pcieport-driver 0000:00:1c.5: setting latency timer to 64
 pcieport-driver 0000:00:1c.5: found MSI capability
-pcieport-driver 0000:00:1c.5: irq 43 for MSI/MSI-X
+pcieport-driver 0000:00:1c.5: irq 507 for MSI/MSI-X
[...]
 ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
-ahci 0000:00:1f.2: irq 42 for MSI/MSI-X
+ahci 0000:00:1f.2: irq 506 for MSI/MSI-X
 ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[...]
 e1000e 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
 e1000e 0000:01:00.0: setting latency timer to 64
-e1000e 0000:01:00.0: irq 41 for MSI/MSI-X
+e1000e 0000:01:00.0: irq 505 for MSI/MSI-X

I.e. very similar to the change between rc-3 and rc-7 you commented on
for my notebook.

Is this really MSI being (not) enabled, or just it using much higher
IRQ numbers?
