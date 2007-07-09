Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbXGIOlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbXGIOlD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 10:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbXGIOkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 10:40:53 -0400
Received: from procserver.webwayone.co.uk ([62.8.115.202]:3871 "EHLO
	procserver.webwayone.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752762AbXGIOkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 10:40:52 -0400
X-Greylist: delayed 2430 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jul 2007 10:40:52 EDT
X-DKIM: Sendmail DKIM Filter v1.2.0 procserver.webwayone.co.uk l69E0Hp1030201
DomainKey-Signature: a=rsa-sha1; s=procserver; d=webwayone.co.uk; c=nofws; q=dns;
	h=x-dkim:from:to:subject:x-hashcash:date:message-id:
	user-agent:mime-version:content-type:x-spam-status:x-scanned-by;
	b=Uw4gxQY7EbHktrUodkXEv35L26K36xT9+6v7iSHbPi1QS9K6POimoQuNVhZfchphS
	WOa0ZzNSPnbGZ9w1fs8vQ==
X-DKIM: Sendmail DKIM Filter v1.2.0 procserver.webwayone.co.uk l69E0Hp1030201
From: Graham Murray <gmurray@webwayone.co.uk>
To: linux-kernel@vger.kernel.org
Subject: Specialix SX cards not detected in kernels >=2.6.20
X-Hashcash: 1:20:070709:linux-kernel@vger.kernel.org::d/U6jiw6YYpP96E/:000000000000000000000000000000000H7dh
Date: Mon, 09 Jul 2007 15:00:17 +0100
Message-ID: <7wlkdp8yoe.fsf@gmdev.webwayone.co.uk>
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/22.1.50 (i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There were multiple changes to the char/sx.c driver in kernel 2.6.20. In
kernels 2.6.19 and earlier, the SX multiport serial card works OK, but
in 2.6.20 and later the driver does not seemt to detect the presence of
the card. 

I have enabled sx_debug=-1 and added some printk statements to try and
detect why the card is not detected. These show that sx_init is entered
and within that function the call to pci_register_driver returns 0. I do
not see any other routines in the driver being entered either at startup
(when the module is loaded, which indicates that the system recognises
the PCI ID) or when running 'modprobe sx'. In particular, sx_pci_probe()
is never entered.

lspci -vv for the card

 10:01.0 Communication controller: Specialix Research Ltd. PCI_9050
	Subsystem: Specialix Research Ltd. Unknown device 0300
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
	Interrupt: pin A routed to IRQ 11
	Region 0: Memory at df2ffc00 (32-bit, non-prefetchable) [size=128]
	Region 1: I/O ports at 9c80 [size=128]
	Region 2: Memory at df200000 (32-bit, non-prefetchable) [size=512K]
	Region 3: Memory at df280000 (32-bit, non-prefetchable) [size=256K]

I have enabled CONFIG_PCI_DEBUG and see the following:-

PCI: Probing PCI hardware (bus 00)
...
PCI: Scanning bus 0000:10
PCI: Found 0000:10:01.0 [11cb/2000] 000780 00
PCI: Calling quirk c0362041 for 0000:10:01.0
...
PCI: Calling quirk c027a199 for 0000:10:01.0
PCI: Calling quirk c033cb9e for 0000:10:01.0


Where should I look for and how should I obtain further debug to
determine where the problem lies?

