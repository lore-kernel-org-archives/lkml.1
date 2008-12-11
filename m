Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbYLKQDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbYLKQDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756293AbYLKQDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:03:03 -0500
Received: from hpsmtp-eml16.KPNXCHANGE.COM ([213.75.38.116]:40137 "EHLO
	hpsmtp-eml16.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756240AbYLKQDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:03:00 -0500
From: Frans Pop <elendil@planet.nl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [patch] ohci1394: don't leave interrupts enabled during suspend/resume
Date: Thu, 11 Dec 2008 17:02:57 +0100
User-Agent: KMail/1.9.9
Cc: Robert Hancock <hancockr@shaw.ca>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200812061316.38460.elendil@planet.nl> <200812102246.52798.elendil@planet.nl> <494041F5.7000209@s5r6.in-berlin.de>
In-Reply-To: <494041F5.7000209@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_xmTQJLJ/d6Ceo9W"
Message-Id: <200812111702.57999.elendil@planet.nl>
X-OriginalArrivalTime: 11 Dec 2008 16:02:58.0461 (UTC) FILETIME=[EF9FFCD0:01C95BA9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_xmTQJLJ/d6Ceo9W
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 10 December 2008, Stefan Richter wrote:
> Then I have no other idea what to try.

OK and thanks for your efforts to help investigate this.

As the patch I originally submitted still does fix the issue for me, I 
would personally be happy enough if that gets included.

> Whether the Ricoh R5C832 FireWire controller or another device issues
> the interrupt is IMO still not clear.  If it was the FireWire
> controller, then it would be fundamentally broken. 
> ohci1394_pci_suspend performs actually two register writes which both
> independently disable interrupts on the controller, and I have a hard
> time to believe that the controller gets both of these straight-forward
> things wrong.

I have tried one last thing: a suspend/resume with debugging enabled for 
the driver. Attached the results of a 'dmesg | grep 1394' split for boot 
up to suspend and for resume for easier comparison.

One possibly significant difference is that on boot there are two lines
"irq_handler: Bus reset requested" and "Cancel request received", which 
are not there during resume. That's even though in both cases 
ohci_initialize() is called which includes the trigger for the bus reset.

Significant?


--Boundary-00=_xmTQJLJ/d6Ceo9W
Content-Type: text/plain;
  charset="iso-8859-1";
  name="1394.boot"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="1394.boot"

ohci1394 0000:02:06.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ohci1394: fw-host0: Remapped memory spaces reg 0xffffc2000007e000
ohci1394: fw-host0: Soft reset finished
ohci1394: fw-host0: Iso contexts reg: 000000a8 implemented: 0000000f
ohci1394: fw-host0: Iso contexts reg: 00000098 implemented: 0000000f
ohci1394: fw-host0: Receive DMA ctx=0 initialized
ohci1394: fw-host0: Receive DMA ctx=0 initialized
ohci1394: fw-host0: Transmit DMA ctx=0 initialized
ohci1394: fw-host0: Transmit DMA ctx=1 initialized
ohci1394: fw-host0: physUpperBoundOffset=00000000
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[e0101000-e01017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
ieee1394: CSR: setting expire to 25, HZ=250
ohci1394: fw-host0: IntEvent: 00030010
ohci1394: fw-host0: irq_handler: Bus reset requested
ohci1394: fw-host0: Cancel request received
ohci1394: fw-host0: Got RQPkt interrupt status=0x00008409
ohci1394: fw-host0: SelfID interrupt received (phyid 0, root)
ohci1394: fw-host0: SelfID packet 0x807f8842 received
ieee1394: Including SelfID 0x42887f80
ohci1394: fw-host0: SelfID for this node is 0x807f8842
ohci1394: fw-host0: SelfID complete
ohci1394: fw-host0: PhyReqFilter=ffffffffffffffff
ieee1394: selfid_complete called with successful SelfID stage ... irm_id: 0xFFC0 node_id: 0xFFC0
ieee1394: NodeMgr: Processing reset for host 0
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Got phy packet ctx=0 ... discarded
ieee1394: send packet at S100: 003c0000 ffc3ffff
ohci1394: fw-host0: Inserting packet for node 0-00:0000, tlabel=0, tcode=0x0, speed=0
ohci1394: fw-host0: Starting transmit DMA ctx=0
ieee1394: send packet local: ffc00140 ffc0ffff f0000400
ohci1394: fw-host0: IntEvent: 00000001
ieee1394: received packet: ffc00140 ffc0ffff f0000400
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008011
ieee1394: send packet local: ffc00160 ffc00000 00000000 c8350404
ieee1394: received packet: ffc00160<6>ohci1394: fw-host0: Packet sent to node 60 tcode=0xE tLabel=0 ack=0x11 spd=0 data=0x00000000 ctx=0
ieee1394: send packet local: ffc00540 ffc0ffff f0000404
ieee1394: received packet: ffc00540 ffc0ffff f0000404
ieee1394: send packet local: ffc00560 ffc00000 00000000 34393331
ieee1394: received packet: ffc00560 ffc00000 00000000 34393331
ieee1394: send packet local: ffc00940 ffc0ffff f0000408
ieee1394: received packet: ffc00940 ffc0ffff f0000408
ieee1394: send packet local: ffc00960 ffc00000 00000000 32a264e0
ieee1394: received packet: ffc00960 ffc00000 00000000 32a264e0
ieee1394: send packet local: ffc00d40 ffc0ffff f000040c
ieee1394: received packet: ffc00d40 ffc0ffff f000040c
ieee1394: send packet local: ffc00d60 ffc00000 00000000 99241b00
ieee1394: received packet: ffc00d60 ffc00000 00000000 99241b00
ieee1394: send packet local: ffc01140 ffc0ffff f0000410
ieee1394: received packet: ffc01140 ffc0ffff f0000410
ieee1394: send packet local: ffc01160 ffc00000 00000000 10221929
ieee1394: received packet: ffc01160 ffc00000 00000000 10221929
ieee1394: send packet local: ffc01550 ffc0ffff f0000400 04000000
ieee1394: received packet: ffc01550 ffc0ffff f0000400 04000000
ieee1394: send packet local: ffc01570 ffc00000 00000000 04000000
ieee1394: received packet: ffc01570 ffc00000 00000000 04000000
ieee1394: NodeMgr: raw=0xe064a232 irmc=1 cmc=1 isc=1 bmc=0 pmc=0 cyc_clk_acc=100 max_rec=2048 max_rom=1024 gen=3 lspd=2
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001b249929192210]
ohci1394: fw-host0: suspend called
ohci1394: fw-host0: Cancel request received
ohci1394: fw-host0: Soft reset finished
ohci1394: fw-host0: Device removed.
ohci1394: fw-host0: Device removed.

--Boundary-00=_xmTQJLJ/d6Ceo9W
Content-Type: text/plain;
  charset="iso-8859-1";
  name="1394.resume"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="1394.resume"

ohci1394: fw-host0: resume called
ohci1394 0000:02:06.1: restoring config space at offset 0xf (was 0x4020200, writing 0x4020205)
ohci1394 0000:02:06.1: restoring config space at offset 0x4 (was 0x0, writing 0xe0101000)
ohci1394 0000:02:06.1: restoring config space at offset 0x3 (was 0x800000, writing 0x804010)
ohci1394 0000:02:06.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
ohci1394: fw-host0: Soft reset finished
ohci1394: fw-host0: Receive DMA ctx=0 initialized
ohci1394: fw-host0: Receive DMA ctx=0 initialized
ohci1394: fw-host0: Transmit DMA ctx=0 initialized
ohci1394: fw-host0: Transmit DMA ctx=1 initialized
ohci1394: fw-host0: physUpperBoundOffset=00000000
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[e0101000-e01017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
ohci1394: fw-host0: IntEvent: 00030010
ohci1394: fw-host0: Got RQPkt interrupt status=0x00008409
ohci1394: fw-host0: SelfID interrupt received (phyid 0, root)
ohci1394: fw-host0: SelfID packet 0x807f8842 received
ieee1394: Including SelfID 0x42887f80
ohci1394: fw-host0: SelfID for this node is 0x807f8842
ohci1394: fw-host0: SelfID complete
ohci1394: fw-host0: PhyReqFilter=ffffffffffffffff
ieee1394: selfid_complete called with successful SelfID stage ... irm_id: 0xFFC0 node_id: 0xFFC0
ieee1394: NodeMgr: Processing reset for host 0
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Got phy packet ctx=0 ... discarded
[<ffffffffa00f2068>] (ohci_irq_handler+0x0/0xa4f [ohci1394])
ieee1394: send packet local: ffc01940 ffc0ffff f0000400
ieee1394: received packet: ffc01940 ffc0ffff f0000400
ieee1394: send packet local: ffc01960 ffc00000 00000000 c8350404
ieee1394: received packet: ffc01960 ffc00000 00000000 c8350404
ieee1394: send packet local: ffc01d40 ffc0ffff f0000404
ieee1394: received packet: ffc01d40 ffc0ffff f0000404
ieee1394: send packet local: ffc01d60 ffc00000 00000000 34393331
ieee1394: received packet: ffc01d60 ffc00000 00000000 34393331
ieee1394: send packet local: ffc02140 ffc0ffff f0000408
ieee1394: received packet: ffc02140 ffc0ffff f0000408
ieee1394: send packet local: ffc02160 ffc00000 00000000 32a264e0
ieee1394: received packet: ffc02160 ffc00000 00000000 32a264e0
ieee1394: send packet local: ffc02540 ffc0ffff f000040c
ieee1394: received packet: ffc02540 ffc0ffff f000040c
ieee1394: send packet local: ffc02560 ffc00000 00000000 99241b00
ieee1394: received packet: ffc02560 ffc00000 00000000 99241b00
ieee1394: send packet local: ffc02940 ffc0ffff f0000410
ieee1394: received packet: ffc02940 ffc0ffff f0000410
ieee1394: send packet local: ffc02960 ffc00000 00000000 10221929
ieee1394: received packet: ffc02960 ffc00000 00000000 10221929
ieee1394: send packet local: ffc02d50 ffc0ffff f0000400 04000000
ieee1394: received packet: ffc02d50 ffc0ffff f0000400 04000000
ieee1394: send packet local: ffc02d70 ffc00000 00000000 04000000
ieee1394: received packet: ffc02d70 ffc00000 00000000 04000000

--Boundary-00=_xmTQJLJ/d6Ceo9W--
