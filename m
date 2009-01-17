Return-Path: <linux-kernel-owner+w=401wt.eu-S1764215AbZAQSIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764215AbZAQSIt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 13:08:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757053AbZAQSIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 13:08:39 -0500
Received: from THUNK.ORG ([69.25.196.29]:41513 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756059AbZAQSIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 13:08:38 -0500
Date: Sat, 17 Jan 2009 13:08:35 -0500
From: Theodore Tso <tytso@mit.edu>
To: We La <w.landgraf@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc2 rt2860 driver
Message-ID: <20090117180835.GR10683@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	We La <w.landgraf@yahoo.com>, linux-kernel@vger.kernel.org
References: <755926.36103.qm@web112217.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <755926.36103.qm@web112217.mail.gq1.yahoo.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2009 at 06:30:01AM -0800, We La wrote:
> 3) eth cards don't work more since 2.6.27 .  ifconfig eth0
> successful, but no connection.  I suppose that's a problem of the
> kernel config (because on other compilations/configurations it
> works) -- perhaps of the iptables, package treatment, or routing,
> not of the eth drivers themselves. However, although searching long
> time, I don't find out the reason.  This should be checked, and
> removed from the kernel config such options which potentially turn
> networking not longer working.

That's not a useful bug report.  "eth0" is the name given to a large
number of different ethernet drivers.  For example on my X61 laptop,
running 2.6.29-rc1, eth0 works just fine --- and it refers to the
e1000e driver.  i.e., from my boot-time dmesg:

[    1.383904] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
[    1.384002] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    1.384165] e1000e 0000:00:19.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.384285] e1000e 0000:00:19.0: setting latency timer to 64
[    1.384536] e1000e 0000:00:19.0: irq 27 for MSI/MSI-X
[    1.590106] 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:16:d3:cc:a4:27
[    1.590236] 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
[    1.590370] 0000:00:19.0: eth0: MAC: 5, PHY: 6, PBA No: ffffff-0ff

On my Lenovo S10 netbook, eth0 refers to the Broadcom Tigon3 (tg3)
driver.  From my boot-time dmesg: (this happens to be a 2.6.28 kernel
since I was testing a reported ext4 problem at the time, but
2.6.29-rc1 also works just fine)

[    1.962792] tg3.c:v3.94 (August 14, 2008)
[    1.962979] tg3 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.963149] tg3 0000:02:00.0: setting latency timer to 64
[    2.193004] eth0: Tigon3 [partno(BCM95906) rev c002 PHY(5906)] (PCI Express) 10/100Base-TX Ethernet 00:1e:68:f0:94:f8
[    2.193187] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[0] TSOcap[0]
[    2.193356] eth0: dma_rwctrl[76180000] dma_mask[64-bit]

As for why it doesn't work on your system, we really need to know what
device driver is involved.  If you send the dmesg output right after
your system booted on 2 6.27 system, where your ethernet device
worked, and a dmesg output after your system booted on a 2.6.28
kernel, where you are having trouble, and your kernel .config from
2.6.28, we probably can help you.  At a guess you probably didn't
configure the right network driver, or maybe for some reason the
ethernet device didn't come up correctly (does ifconfig -a show the
eth0 device?), or some other user/configuration error.  It certainly
isn'ta problem with all "eth cards", as you seem to suggest.

Regards,

						- Ted
