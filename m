Return-Path: <linux-kernel-owner+w=401wt.eu-S1760078AbYEANlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbYEANlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 09:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755170AbYEANl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 09:41:29 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:38369 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbYEANl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 09:41:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=qg90U01XZXXvFohgIp25EsdclwAvPmcm4hiFCuoVG4ahx26NFVewtz9b+IrvnNInfKECgSr0x1OU3855ZFR9dBU0bz2xm5Qo2zCDxAqE4W13hkWwPyZ/WXcsQatT0ED2ov56zHWGeP1swjS5cqtfa6iLb8MYD1k1xbwIR7P3Xgg=
Message-ID: <a44ae5cd0805010641j34243377wd7d4b76efd7e670d@mail.gmail.com>
Date: Thu, 1 May 2008 09:41:20 -0400
From: "Miles Lane" <miles.lane@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: 2.6.25-git16 -- IEEE 1394 device has ROM CRC error -- No /dev/video0 device
Cc: linux-kernel@vger.kernel.org, "Kristian Hoegsberg" <krh@redhat.com>,
       linux1394-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2008 at 9:08 AM, Miles Lane <miles.lane@gmail.com> wrote:
> Hi Stefan.  Thanks for your patch.  It worked great.  Now I see this
>  in the logs:
>
>  ohci1394: fw-host0: SelfID received outside of bus reset sequence
>  IEEE 1394 device has ROM CRC error
>  IEEE 1394 device has ROM CRC error
>  Program usplash tried to access /dev/mem between 0->8000000.
>  ieee1394: Node added: ID:BUS[0-00:1023]  GUID[00d0f54000000173]
>  ieee1394: Host added: ID:BUS[0-01:1023]  GUID[00e018000027d06c]
>  IEEE 1394 device has ROM CRC error
>  IEEE 1394 device has ROM CRC error
>  IEEE 1394 device has ROM CRC error
>  IEEE 1394 device has ROM CRC error
>  IEEE 1394 device has ROM CRC error
>
>  Also, "cat /sys/bus/ieee1394/drivers/raw1394/device_ids" no longer
>  causes an error.
>
>  Is it necessary for the code to spit out so many CRC errors for the
>  OrangeMicro iBot?  Also, are these errors indicating a significant
>  problem with the iBot?

I noticed that no /dev/video0 device was being created, so I enabled
all the video driver options and rebuilt my kernel with ieee1394
debugging enabled.
Unfortunately, I still don't get a /dev/video0 device for my
OrangeMicro iBot.  Is this simply due to the CRC error?  If so, is
there a way of working around this, since the webcam works okay under
Windows?

Here is what I see in the log now:

ohci1394: fw-host0: Iso contexts reg: 000000a8 implemented: 0000000f
ohci1394: fw-host0: Iso contexts reg: 00000098 implemented: 0000000f
ohci1394: fw-host0: Receive DMA ctx=0 initialized
ohci1394: fw-host0: Receive DMA ctx=0 initialized
ohci1394: fw-host0: Transmit DMA ctx=0 initialized
ohci1394: fw-host0: Transmit DMA ctx=1 initialized
ohci1394: fw-host0: physUpperBoundOffset=00000000
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]
MMIO=[ee084000-ee0847ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
ieee1394: CSR: setting expire to 30, HZ=300
ohci1394: fw-host0: IntEvent: 00030010
ohci1394: fw-host0: Detected bus-reset loop. Forced a bus reset!
ohci1394: fw-host0: irq_handler: Bus reset requested
ohci1394: fw-host0: Cancel request received
ohci1394: fw-host0: Got RQPkt interrupt status=0x00008409
ohci1394: fw-host0: SelfID interrupt received (phyid 1, root)
ohci1394: fw-host0: SelfID packet 0x807f8490 received
ieee1394: Including SelfID 0x90847f80
ohci1394: fw-host0: SelfID packet 0x817f88d2 received
ieee1394: Including SelfID 0xd2887f81
ohci1394: fw-host0: SelfID for this node is 0x817f88d2
ohci1394: fw-host0: SelfID complete
ohci1394: fw-host0: PhyReqFilter=ffffffffffffffff
ieee1394: selfid_complete called with successful SelfID stage ...
irm_id: 0xFFC1 node_id: 0xFFC1
ohci1394: fw-host0: Cycle master enabled
ieee1394: NodeMgr: Processing reset for host 0
ohci1394: fw-host0: IntEvent: 00010010
ohci1394: fw-host0: Got RQPkt interrupt status=0x00008409
ohci1394: fw-host0: SelfID received outside of bus reset sequence
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Got phy packet ctx=0 ... discarded
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Got phy packet ctx=0 ... discarded
ieee1394: send packet at S100: 01800000 fe7fffff
ohci1394: fw-host0: Inserting packet for node 0-00:0000, tlabel=0,
tcode=0x0, speed=0
ohci1394: fw-host0: Starting transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008011
ohci1394: fw-host0: Packet sent to node 0 tcode=0xE tLabel=0 ack=0x11
spd=0 data=0x00000000 ctx=0
ieee1394: send packet at S100: 013c0000 fec3ffff
ohci1394: fw-host0: Inserting packet for node 0-00:0000, tlabel=0,
tcode=0x0, speed=0
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008011
ohci1394: fw-host0: Packet sent to node 60 tcode=0xE tLabel=0 ack=0x11
spd=0 data=0x00000000 ctx=0
ieee1394: send packet at S400: ffc00140 ffc1ffff f0000400
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=0,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=0 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=0
ieee1394: received packet: ffc10060 ffc00000 00000000 0cfb2004
ieee1394: send packet at S400: ffc00540 ffc1ffff f0000404
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=1,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=1 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=1
ieee1394: received packet: ffc10460 ffc00000 00000000 34393331
ieee1394: send packet at S400: ffc00940 ffc1ffff f0000408
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=2,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=2 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=2
ieee1394: received packet: ffc10860 ffc00000 00000000 0040ff20
ieee1394: send packet at S400: ffc00d40 ffc1ffff f000040c
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=3,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=3 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=3
ieee1394: received packet: ffc10c60 ffc00000 00000000 40f5d000
ieee1394: send packet at S400: ffc01140 ffc1ffff f0000410
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=4,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=4 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=4
ieee1394: received packet: ffc11060 ffc00000 00000000 73010000
ieee1394: send packet at S400: ffc01540 ffc1ffff f0000414
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=5,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=5 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=5
ieee1394: received packet: ffc11460 ffc00000 00000000 b3460400
ieee1394: send packet at S400: ffc01940 ffc1ffff f0000418
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=6,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=6 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=6
ieee1394: received packet: ffc11860 ffc00000 00000000 f5d00003
ieee1394: send packet at S400: ffc01d40 ffc1ffff f000041c
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=7,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=7 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=7
ieee1394: received packet: ffc11c60 ffc00000 00000000 98010706
ieee1394: send packet at S400: ffc02140 ffc1ffff f0000420
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=8,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=8 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=8
ieee1394: received packet: ffc12060 ffc00000 00000000 0200008d
ieee1394: send packet at S400: ffc02540 ffc1ffff f0000424
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=9,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=9 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=9
ieee1394: received packet: ffc12460 ffc00000 00000000 040000d1
ieee1394: send packet at S400: ffc02940 ffc1ffff f0000428
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=10,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=10 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=10
ieee1394: received packet: ffc12860 ffc00000 00000000 eac20200
ieee1394: send packet at S400: ffc02d40 ffc1ffff f000042c
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=11,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=11 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=11
ieee1394: received packet: ffc12c60 ffc00000 00000000 40f5d000
ieee1394: send packet at S400: ffc03140 ffc1ffff f0000430
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=12,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=12 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=12
ieee1394: received packet: ffc13060 ffc00000 00000000 73010000
ieee1394: send packet at S400: ffc03540 ffc1ffff f0000434
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=13,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=13 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=13
ieee1394: received packet: ffc13460 ffc00000 00000000 62440300
ieee1394: send packet at S400: ffc03940 ffc1ffff f0000438
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=14,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=14 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=14
ieee1394: received packet: ffc13860 ffc00000 00000000 2da00012
ieee1394: send packet at S400: ffc03d40 ffc1ffff f000043c
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=15,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=15 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=15
ieee1394: received packet: ffc13c60 ffc00000 00000000 00010013
ieee1394: send packet at S400: ffc04140 ffc1ffff f0000440
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=16,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=16 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=16
ieee1394: received packet: ffc14060 ffc00000 00000000 010000d4
ieee1394: send packet at S400: ffc04540 ffc1ffff f0000444
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=17,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=17 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=17
ieee1394: received packet: ffc14460 ffc00000 00000000 26120300
ieee1394: send packet at S400: ffc04940 ffc1ffff f0000448
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=18,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=18 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=18
ieee1394: received packet: ffc14860 ffc00000 00000000 00003c40
ieee1394: send packet at S400: ffc04d40 ffc1ffff f000044c
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=19,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=19 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=19
ieee1394: received packet: ffc14c60 ffc00000 00000000 02000081
ieee1394: send packet at S400: ffc05140 ffc1ffff f0000450
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=20,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=20 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=20
ieee1394: received packet: ffc15060 ffc00000 00000000 08000082
ieee1394: send packet at S400: ffc05540 ffc1ffff f0000454
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=21,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=21 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=21
ieee1394: received packet: ffc15460 ffc00000 00000000 dd420600
ieee1394: send packet at S400: ffc05940 ffc1ffff f0000458
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=22,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=22 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=22
ieee1394: received packet: ffc15860 ffc00000 00000000 00000000
ieee1394: send packet at S400: ffc05d40 ffc1ffff f000045c
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=23,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=23 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=23
ieee1394: received packet: ffc15c60 ffc00000 00000000 00000000
ieee1394: send packet at S400: ffc06140 ffc1ffff f0000460
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=24,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=24 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=24
ieee1394: received packet: ffc16060 ffc00000 00000000 4e41524f
ieee1394: send packet at S400: ffc06540 ffc1ffff f0000464
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=25,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=25 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=25
ieee1394: received packet: ffc16460 ffc00000 00000000 4d204547
ieee1394: send packet at S400: ffc06940 ffc1ffff f0000468
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=26,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=26 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=26
ieee1394: received packet: ffc16860 ffc00000 00000000 4f524349
ieee1394: send packet at S400: ffc06d40 ffc1ffff f000046c
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=27,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=27 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=27
ieee1394: received packet: ffc16c60 ffc00000 00000000 00000000
ieee1394: send packet at S400: ffc07140 ffc1ffff f0000470
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=28,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=28 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=28
ieee1394: received packet: ffc17060 ffc00000 00000000 cb480400
ieee1394: send packet at S400: ffc07540 ffc1ffff f0000474
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=29,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=29 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=29
ieee1394: received packet: ffc17460 ffc00000 00000000 00000000
ieee1394: send packet at S400: ffc07940 ffc1ffff f0000478
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=30,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=30 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=30
ieee1394: received packet: ffc17860 ffc00000 00000000 00000000
ieee1394: send packet at S400: ffc07d40 ffc1ffff f000047c
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=31,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=31 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=31
ieee1394: received packet: ffc17c60 ffc00000 00000000 544f4249
ieee1394: send packet at S400: ffc08140 ffc1ffff f0000480
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=32,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=32 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=32
ieee1394: received packet: ffc18060 ffc00000 00000000 00000000
IEEE 1394 device has ROM CRC error
IEEE 1394 device has ROM CRC error
ieee1394: NodeMgr: raw=0x20ff4000 irmc=0 cmc=0 isc=1 bmc=0 pmc=0
cyc_clk_acc=255 max_rec=32 max_rom=4 gen=0 lspd=0
ieee1394: Node added: ID:BUS[0-00:1023]  GUID[00d0f54000000173]
ieee1394: send packet local: ffc10140 ffc1ffff f0000400
ieee1394: received packet: ffc10140 ffc1ffff f0000400
ieee1394: send packet local: ffc10160 ffc10000 00000000 c32b0404
ieee1394: received packet: ffc10160 ffc10000 00000000 c32b0404
ieee1394: send packet local: ffc10540 ffc1ffff f0000404
ieee1394: received packet: ffc10540 ffc1ffff f0000404
ieee1394: send packet local: ffc10560 ffc10000 00000000 34393331
ieee1394: received packet: ffc10560 ffc10000 00000000 34393331
ieee1394: send packet local: ffc10940 ffc1ffff f0000408
ieee1394: received packet: ffc10940 ffc1ffff f0000408
ieee1394: send packet local: ffc10960 ffc10000 00000000 32a264e0
ieee1394: received packet: ffc10960 ffc10000 00000000 32a264e0
ieee1394: send packet local: ffc10d40 ffc1ffff f000040c
ieee1394: received packet: ffc10d40 ffc1ffff f000040c
ieee1394: send packet local: ffc10d60 ffc10000 00000000 0018e000
ieee1394: received packet: ffc10d60 ffc10000 00000000 0018e000
ieee1394: send packet local: ffc11140 ffc1ffff f0000410
ieee1394: received packet: ffc11140 ffc1ffff f0000410
ieee1394: send packet local: ffc11160 ffc10000 00000000 6cd02700
ieee1394: received packet: ffc11160 ffc10000 00000000 6cd02700
ieee1394: send packet local: ffc11550 ffc1ffff f0000400 04000000
ieee1394: received packet: ffc11550 ffc1ffff f0000400 04000000
ieee1394: send packet local: ffc11570 ffc10000 00000000 04000000
ieee1394: received packet: ffc11570 ffc10000 00000000 04000000
ieee1394: NodeMgr: raw=0xe064a232 irmc=1 cmc=1 isc=1 bmc=0 pmc=0
cyc_clk_acc=100 max_rec=2048 max_rom=1024 gen=3 lspd=2
ieee1394: Host added: ID:BUS[0-01:1023]  GUID[00e018000027d06c]
ieee1394: send packet at S400: ffc08540 ffc1ffff f0000234
ohci1394: fw-host0: Inserting packet for node 0-00:1023, tlabel=33,
tcode=0x4, speed=2
ohci1394: fw-host0: Waking transmit DMA ctx=0
ohci1394: fw-host0: IntEvent: 00000001
ohci1394: fw-host0: Got reqTxComplete interrupt status=0x00008012
ohci1394: fw-host0: Packet sent to node 0 tcode=0x4 tLabel=33 ack=0x12
spd=0 data=0x00000000 ctx=0
ohci1394: fw-host0: IntEvent: 00000020
ohci1394: fw-host0: Got RSPkt interrupt status=0x00008451
ohci1394: fw-host0: Single packet rcv'd
ohci1394: fw-host0: Packet received from node 0 ack=0x11 spd=2
tcode=0x6 length=20 ctx=0 tlabel=33
ieee1394: received packet: ffc18460 ffc06000 00000000 00000000
IEEE 1394 device has ROM CRC error
IEEE 1394 device has ROM CRC error
IEEE 1394 device has ROM CRC error
IEEE 1394 device has ROM CRC error
IEEE 1394 device has ROM CRC error
ieee1394: raw1394: /dev/raw1394 device initialized
video1394: Installed video1394 module
