Return-Path: <linux-kernel-owner+w=401wt.eu-S966194AbXDGRyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966194AbXDGRyM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 13:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966207AbXDGRx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 13:53:59 -0400
Received: from dilbert.robsims.com ([209.120.158.98]:58582 "EHLO
	mail.robsims.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966197AbXDGRxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 13:53:50 -0400
Date: Sat, 7 Apr 2007 11:53:48 -0600
From: Rob Sims <lkml-z@robsims.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Thomas Glanzmann <thomas@glanzmann.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andreas =?iso-8859-1?Q?Allg=F6wer?= <andreas.allgoewer@web.de>,
       Michael Gernoth <simigern@cip.informatik.uni-erlangen.de>
Subject: Re: sky2 PHY setup
Message-ID: <20070407175348.GB18457@robsims.com>
References: <20070202151601.677ec5d9@freekitty> <20070203073012.GO1693@cip.informatik.uni-erlangen.de> <20070205090429.31d7bd32@freekitty> <20070222193611.GR20035@cip.informatik.uni-erlangen.de> <20070316002912.GB17594@cip.informatik.uni-erlangen.de> <20070316095932.5e920222@freekitty> <20070316203645.GA24699@robsims.com> <20070316141648.15d7ff75@freekitty> <20070327032406.GA25659@robsims.com> <20070404111930.46321146@freekitty>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="adJ1OR3c6QgCpb/j"
Content-Disposition: inline
In-Reply-To: <20070404111930.46321146@freekitty>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--adJ1OR3c6QgCpb/j
Content-Type: multipart/mixed; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline


--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 04, 2007 at 11:19:30AM -0700, Stephen Hemminger wrote:
> On Mon, 26 Mar 2007 21:24:06 -0600
> Rob Sims <lkml-z@robsims.com> wrote:
>=20
> > On Fri, Mar 16, 2007 at 02:16:48PM -0700, Stephen Hemminger wrote:

> > > Use ethtool -S to if there are any pause frames, etc. See if frames a=
re
> > > still making it into PHY statistics but not being received.
> > >=20
> > > Use ethtool -d to dump registers. Need current version of ethtool wit=
h decode logic.
> > >=20
> > > Then look for things like is Ram buffer read/write pointer changing?
> > >=20
> > > Is GMAC stuck in pause:
> > >=20
> > > Normal is:
> > > 	GMAC 1
> > > 	Status                       0x5010  (see GM_GPSR_XXX in sky2.h)
> > > 	Control                      0x1800
> > >=20
> > > Stuck is
> > > 	GMAC 1
> > > 	Status			     0x5810 (or 0x5A10)
> >=20
> > First, here's the described hang in action, on the Core2 Duo on a 1Gb
> > hub:
> > GMAC 1 Status/Control remains at 0x5010/0x1800 until module is removed.
> > Read/write buffer pointers are changing.  Full ethtool output in
> > http://www.robsims.com/sky2.netmon.log.gz
> >=20
> > This machine was also having major throughput problems - 17 kB/s.
> > Rebooting brought it to ~ 20 MB/s.  Booting into a kernel with the
> > proprietary sk98lin kernel module showed ~ 80MB/s.  Finally, returning
> > to sky2 gave 117 MB/s.  Tests run using netcat, dd, /dev/zero, and
> > /dev/null, transmitting from the problem box to an e1000 via a Netgear
> > GS108.  No hangs were observed during the "load test."
>=20
> The vendor driver does not do hardware flow control correctly. It ignores
> Tx pause frames.
=20
> Were you using Jumbo MTU?

No - 1500.

> You might have over run the hub and it wedged.  Try doing:
> 	ethtool -r eth0
> that forces a down/up

I'm still seeing throughput drop to under 1 Mb/s (50-100kB/s)
periodically.  I did an ethtool -S and ethtool -d to capture state.
(sky2-fail.log).  I ran ethtool -r and retested; no change
(sky2-ethtool-r.log).  Finally, ifdown - rmmod - modprobe - ifup, which
restored to Gigabit speeds (96+ MB/s), (sky2-modcycle.log).

Please let me know if there's anything else I can poke into.  As a
reminder, this is a 88E8053 r20.  Next time I see a degradation, I'll
try cycling the switch.
--=20
Rob

--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sky2-fail.log"

NIC statistics:
     tx_bytes: 84771583
     rx_bytes: 94680579
     tx_broadcast: 3
     rx_broadcast: 1356
     tx_multicast: 655
     rx_multicast: 22
     tx_unicast: 173780
     rx_unicast: 181842
     tx_mac_pause: 0
     rx_mac_pause: 0
     collisions: 0
     late_collision: 0
     aborted: 0
     single_collisions: 0
     multi_collisions: 0
     rx_short: 0
     rx_runt: 0
     rx_64_byte_packets: 2360
     rx_65_to_127_byte_packets: 82349
     rx_128_to_255_byte_packets: 35420
     rx_256_to_511_byte_packets: 8584
     rx_512_to_1023_byte_packets: 3734
     rx_1024_to_1518_byte_packets: 50773
     rx_1518_to_max_byte_packets: 0
     rx_too_long: 0
     rx_fifo_overflow: 0
     rx_jabber: 0
     rx_fcs_error: 0
     tx_64_byte_packets: 1744
     tx_65_to_127_byte_packets: 102366
     tx_128_to_255_byte_packets: 19607
     tx_256_to_511_byte_packets: 8735
     tx_512_to_1023_byte_packets: 4438
     tx_1024_to_1518_byte_packets: 31033
     tx_1519_to_max_byte_packets: 0
     tx_fifo_underrun: 0

PCI config
----------
00: ab 11 62 43 07 00 10 00 20 00 00 02 04 00 00 00
10: 04 c0 9f fa 00 00 00 00 01 c8 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 42 81
30: 00 00 9c fa 48 00 00 00 00 00 00 00 05 01 00 00
40: 00 00 f0 01 00 80 a0 01 01 50 02 fe 00 20 00 13
50: 03 5c fc 80 00 00 00 01 00 00 00 01 05 e0 82 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Control Registers
-----------------
Register Access Port             0x00
LED Control/Status               0xA603164A
Interrupt Source                 0x00000000
Interrupt Mask                   0xC000001D
Interrupt Hardware Error Source  0x00000000
Interrupt Hardware Error Mask    0x2E003F3F

Bus Management Unit
-------------------
CSR Receive Queue 1              0x00010000
CSR Sync Queue 1                 0xFFFFFFFF
CSR Async Queue 1                0x00000000

MAC Addresses
---------------
Addr 1            00 1A 92 23 52 4D
Addr 2            00 1A 92 23 52 4D
Addr 3            00 00 00 00 00 00

Connector type               0x4A (J)
PMD type                     0x31 (1)
PHY type                     0x80
Chip Id                      0xB6 Yukon-2 EC (rev 0)
Ram Buffer                   0x0C

Status BMU:
-----------
Control                                0x0002220A
Last Index                             0x07FF
Put Index                              0x025F
List Address                           0x0000000012760000
Transmit 1 done index                  0x0118
Transmit index threshold               0x000A

Status FIFO
	Write Pointer            0x16
	Read Pointer             0x16
	Level                    0x00
	Watermark                0x10
	ISR Watermark            0x10
Status level
	Init 0x000030D4 Value 0x000030D4
	Test 0x04       Control 0x02
TX status
	Init 0x0001E848 Value 0x0001E848
	Test 0x04       Control 0x02
ISR
	Init 0x000009C4 Value 0x000009C4
	Test 0x04       Control 0x02

GMAC control             0x005A
GPHY control             0x2002
LINK control             0x02

GMAC 1
Status                       0x5010
Control                      0x1800
Transmit                     0x1000
Receive                      0xE000
Transmit flow control        0xFFFF
Transmit parameter           0xD7C4
Serial mode                  0x221E
      Source address:  00 1A 92 23 52 4D
    Physical address:  00 1A 92 23 52 4D

Rx GMAC 1
End Address                      0x0000007F
Almost Full Thresh               0x00000070
Control/Test                     0x0900228A
FIFO Flush Mask                  0x0000187B
FIFO Flush Threshold             0x0000000B
Truncation Threshold             0x0000017C
Upper Pause Threshold            0x00000000
Lower Pause Threshold            0x00000081
VLAN Tag                         0x00000007
FIFO Write Pointer               0x00000000
FIFO Write Level                 0x00000000
FIFO Read Pointer                0x00000000
FIFO Read Level                  0x00000007

Tx GMAC 1
End Address                      0x0000007F
Almost Full Thresh               0x00000010
Control/Test                     0x0102220A
FIFO Flush Mask                  0x00000000
FIFO Flush Threshold             0x00000000
Truncation Threshold             0x00000000
Upper Pause Threshold            0x00000000
Lower Pause Threshold            0x00000081
VLAN Tag                         0x00000046
FIFO Write Pointer               0x00000046
FIFO Write Level                 0x00000F0F
FIFO Read Pointer                0x00000000
FIFO Read Level                  0x00000046

Receive Queue 1
---------------
Buffer control                   0x05F8
Byte Counter                     49408
Descriptor Address               0x00000000324C5010
Status                           0x00720100
Timestamp                        0x7920F1B4
BMU Control/Status               0x000061AA
Done                             0x0000
Request                          0x00000000324C5010
Csum1      Offset 8572 Position   14
Csum2      Offset 8572 Position  14

Sync Transmit Queue 1 (disabled)

Async Transmit Queue 1
---------------
Buffer control                   0x0030
Byte Counter                     49438
Descriptor Address               0x0000000015DD2CE7
Status                           0x00000000
Timestamp                        0x00010000
BMU Control/Status               0x800011AA
Done                             0x0000
Request                          0x0000000015DD2D17
Csum Start 0x0032 Pos    0 Write 0

Receive RAMbuffer 1
---------------
Start Address                    0x00000000
End Address                      0x00000E7F
Write Pointer                    0x00000187
Read Pointer                     0x00000187
Upper Threshold/Pause Packets    0x00000D80
Lower Threshold/Pause Packets    0x000003A0
Upper Threshold/High Priority    0x00000AE0
Lower Threshold/High Priority    0x00000740
Packet Counter                   0x00000000
Level                            0x00000000
Control                          0x0002221A

Sync Transmit RAMbuffer 1 (disabled)

Async Transmit RAMbuffer 1
---------------
Start Address                    0x00000E80
End Address                      0x000017FF
Write Pointer                    0x000015C6
Read Pointer                     0x000015C6
Packet Counter                   0x00000000
Level                            0x00000000
Control                          0x0002222A

--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sky2-ethtool-r.log"

NIC statistics:
     tx_bytes: 87827569
     rx_bytes: 95371155
     tx_broadcast: 3
     rx_broadcast: 1359
     tx_multicast: 655
     rx_multicast: 22
     tx_unicast: 176221
     rx_unicast: 184113
     tx_mac_pause: 0
     rx_mac_pause: 0
     collisions: 0
     late_collision: 0
     aborted: 0
     single_collisions: 0
     multi_collisions: 0
     rx_short: 0
     rx_runt: 0
     rx_64_byte_packets: 2366
     rx_65_to_127_byte_packets: 84081
     rx_128_to_255_byte_packets: 35584
     rx_256_to_511_byte_packets: 8599
     rx_512_to_1023_byte_packets: 3746
     rx_1024_to_1518_byte_packets: 51118
     rx_1518_to_max_byte_packets: 0
     rx_too_long: 0
     rx_fifo_overflow: 0
     rx_jabber: 0
     rx_fcs_error: 0
     tx_64_byte_packets: 1749
     tx_65_to_127_byte_packets: 102951
     tx_128_to_255_byte_packets: 19765
     tx_256_to_511_byte_packets: 8744
     tx_512_to_1023_byte_packets: 4444
     tx_1024_to_1518_byte_packets: 32415
     tx_1519_to_max_byte_packets: 0
     tx_fifo_underrun: 0

PCI config
----------
00: ab 11 62 43 07 00 10 00 20 00 00 02 04 00 00 00
10: 04 c0 9f fa 00 00 00 00 01 c8 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 42 81
30: 00 00 9c fa 48 00 00 00 00 00 00 00 05 01 00 00
40: 00 00 f0 01 00 80 a0 01 01 50 02 fe 00 20 00 13
50: 03 5c fc 80 00 00 00 01 00 00 00 01 05 e0 82 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Control Registers
-----------------
Register Access Port             0x00
LED Control/Status               0xA603164A
Interrupt Source                 0x00000000
Interrupt Mask                   0xC000001D
Interrupt Hardware Error Source  0x00000000
Interrupt Hardware Error Mask    0x2E003F3F

Bus Management Unit
-------------------
CSR Receive Queue 1              0x00010000
CSR Sync Queue 1                 0xFFFFFFFF
CSR Async Queue 1                0x00000000

MAC Addresses
---------------
Addr 1            00 1A 92 23 52 4D
Addr 2            00 1A 92 23 52 4D
Addr 3            00 00 00 00 00 00

Connector type               0x4A (J)
PMD type                     0x31 (1)
PHY type                     0x80
Chip Id                      0xB6 Yukon-2 EC (rev 0)
Ram Buffer                   0x0C

Status BMU:
-----------
Control                                0x0002220A
Last Index                             0x07FF
Put Index                              0x022D
List Address                           0x0000000012760000
Transmit 1 done index                  0x00FC
Transmit index threshold               0x000A

Status FIFO
	Write Pointer            0x2E
	Read Pointer             0x2E
	Level                    0x00
	Watermark                0x10
	ISR Watermark            0x10
Status level
	Init 0x000030D4 Value 0x000030D4
	Test 0x04       Control 0x02
TX status
	Init 0x0001E848 Value 0x0001E848
	Test 0x04       Control 0x02
ISR
	Init 0x000009C4 Value 0x000009C4
	Test 0x04       Control 0x02

GMAC control             0x005A
GPHY control             0x2002
LINK control             0x02

GMAC 1
Status                       0x5010
Control                      0x1800
Transmit                     0x1000
Receive                      0xE000
Transmit flow control        0xFFFF
Transmit parameter           0xD7C4
Serial mode                  0x221E
      Source address:  00 1A 92 23 52 4D
    Physical address:  00 1A 92 23 52 4D

Rx GMAC 1
End Address                      0x0000007F
Almost Full Thresh               0x00000070
Control/Test                     0x0900228A
FIFO Flush Mask                  0x0000187B
FIFO Flush Threshold             0x0000000B
Truncation Threshold             0x0000017C
Upper Pause Threshold            0x00000000
Lower Pause Threshold            0x00000081
VLAN Tag                         0x00000040
FIFO Write Pointer               0x00000000
FIFO Write Level                 0x00000000
FIFO Read Pointer                0x00000000
FIFO Read Level                  0x00000040

Tx GMAC 1
End Address                      0x0000007F
Almost Full Thresh               0x00000010
Control/Test                     0x0102220A
FIFO Flush Mask                  0x00000000
FIFO Flush Threshold             0x00000000
Truncation Threshold             0x00000000
Upper Pause Threshold            0x00000000
Lower Pause Threshold            0x00000081
VLAN Tag                         0x00000008
FIFO Write Pointer               0x00000008
FIFO Write Level                 0x00000F0F
FIFO Read Pointer                0x00000000
FIFO Read Level                  0x00000008

Receive Queue 1
---------------
Buffer control                   0x05F8
Byte Counter                     49408
Descriptor Address               0x0000000005BB9810
Status                           0x00720100
Timestamp                        0x7920F1B4
BMU Control/Status               0x000061AA
Done                             0x0000
Request                          0x0000000005BB9810
Csum1      Offset 8572 Position   14
Csum2      Offset 8572 Position  14

Sync Transmit Queue 1 (disabled)

Async Transmit Queue 1
---------------
Buffer control                   0x0030
Byte Counter                     49438
Descriptor Address               0x0000000002A78257
Status                           0x00000000
Timestamp                        0x00010000
BMU Control/Status               0x800011AA
Done                             0x0000
Request                          0x0000000002A78287
Csum Start 0x0032 Pos    0 Write 0

Receive RAMbuffer 1
---------------
Start Address                    0x00000000
End Address                      0x00000E7F
Write Pointer                    0x00000AC0
Read Pointer                     0x00000AC0
Upper Threshold/Pause Packets    0x00000D80
Lower Threshold/Pause Packets    0x000003A0
Upper Threshold/High Priority    0x00000AE0
Lower Threshold/High Priority    0x00000740
Packet Counter                   0x00000000
Level                            0x00000000
Control                          0x0002221A

Sync Transmit RAMbuffer 1 (disabled)

Async Transmit RAMbuffer 1
---------------
Start Address                    0x00000E80
End Address                      0x000017FF
Write Pointer                    0x00001788
Read Pointer                     0x00001788
Packet Counter                   0x00000000
Level                            0x00000000
Control                          0x0002222A

--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sky2-modcycle.log"

NIC statistics:
     tx_bytes: 3173910
     rx_bytes: 111677
     tx_broadcast: 4
     rx_broadcast: 1
     tx_multicast: 17
     rx_multicast: 0
     tx_unicast: 2254
     rx_unicast: 1451
     tx_mac_pause: 0
     rx_mac_pause: 0
     collisions: 0
     late_collision: 0
     aborted: 0
     single_collisions: 0
     multi_collisions: 0
     rx_short: 0
     rx_runt: 0
     rx_64_byte_packets: 5
     rx_65_to_127_byte_packets: 1413
     rx_128_to_255_byte_packets: 24
     rx_256_to_511_byte_packets: 4
     rx_512_to_1023_byte_packets: 6
     rx_1024_to_1518_byte_packets: 0
     rx_1518_to_max_byte_packets: 0
     rx_too_long: 0
     rx_fifo_overflow: 0
     rx_jabber: 0
     rx_fcs_error: 0
     tx_64_byte_packets: 6
     tx_65_to_127_byte_packets: 92
     tx_128_to_255_byte_packets: 63
     tx_256_to_511_byte_packets: 27
     tx_512_to_1023_byte_packets: 23
     tx_1024_to_1518_byte_packets: 2064
     tx_1519_to_max_byte_packets: 0
     tx_fifo_underrun: 0

PCI config
----------
00: ab 11 62 43 07 00 10 00 20 00 00 02 04 00 00 00
10: 04 c0 9f fa 00 00 00 00 01 c8 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 42 81
30: 00 00 9c fa 48 00 00 00 00 00 00 00 05 01 00 00
40: 00 00 f0 01 00 80 a0 01 01 50 02 fe 00 20 00 13
50: 03 5c fc 80 00 00 00 01 00 00 00 01 05 e0 82 00
60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
70: 00 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Control Registers
-----------------
Register Access Port             0x00
LED Control/Status               0xA603164A
Interrupt Source                 0x00000000
Interrupt Mask                   0xC000001D
Interrupt Hardware Error Source  0x00000000
Interrupt Hardware Error Mask    0x2E003F3F

Bus Management Unit
-------------------
CSR Receive Queue 1              0x00010000
CSR Sync Queue 1                 0xFFFFFFFF
CSR Async Queue 1                0x00000000

MAC Addresses
---------------
Addr 1            00 1A 92 23 52 4D
Addr 2            00 1A 92 23 52 4D
Addr 3            00 00 00 00 00 00

Connector type               0x4A (J)
PMD type                     0x31 (1)
PHY type                     0x80
Chip Id                      0xB6 Yukon-2 EC (rev 0)
Ram Buffer                   0x0C

Status BMU:
-----------
Control                                0x0002220A
Last Index                             0x07FF
Put Index                              0x065B
List Address                           0x0000000012760000
Transmit 1 done index                  0x01AF
Transmit index threshold               0x000A

Status FIFO
	Write Pointer            0x16
	Read Pointer             0x16
	Level                    0x00
	Watermark                0x10
	ISR Watermark            0x10
Status level
	Init 0x000030D4 Value 0x000030D4
	Test 0x04       Control 0x02
TX status
	Init 0x0001E848 Value 0x0001E848
	Test 0x04       Control 0x02
ISR
	Init 0x000009C4 Value 0x000009C4
	Test 0x04       Control 0x02

GMAC control             0x005A
GPHY control             0x2002
LINK control             0x02

GMAC 1
Status                       0x5010
Control                      0x1800
Transmit                     0x1000
Receive                      0xE000
Transmit flow control        0xFFFF
Transmit parameter           0xD7C4
Serial mode                  0x221E
      Source address:  00 1A 92 23 52 4D
    Physical address:  00 1A 92 23 52 4D

Rx GMAC 1
End Address                      0x0000007F
Almost Full Thresh               0x00000070
Control/Test                     0x0900228A
FIFO Flush Mask                  0x0000187B
FIFO Flush Threshold             0x0000000B
Truncation Threshold             0x0000017C
Upper Pause Threshold            0x00000000
Lower Pause Threshold            0x00000081
VLAN Tag                         0x00000033
FIFO Write Pointer               0x00000000
FIFO Write Level                 0x00000000
FIFO Read Pointer                0x00000000
FIFO Read Level                  0x00000033

Tx GMAC 1
End Address                      0x0000007F
Almost Full Thresh               0x00000010
Control/Test                     0x0102220A
FIFO Flush Mask                  0x00000000
FIFO Flush Threshold             0x00000000
Truncation Threshold             0x00000000
Upper Pause Threshold            0x00000000
Lower Pause Threshold            0x00000081
VLAN Tag                         0x0000007A
FIFO Write Pointer               0x0000007A
FIFO Write Level                 0x00000F0F
FIFO Read Pointer                0x00000000
FIFO Read Level                  0x0000007A

Receive Queue 1
---------------
Buffer control                   0x05F8
Byte Counter                     49408
Descriptor Address               0x0000000036A60010
Status                           0x00420100
Timestamp                        0x7920F1B4
BMU Control/Status               0x000061AA
Done                             0x0000
Request                          0x0000000036A60010
Csum1      Offset 20860 Position   14
Csum2      Offset 20860 Position  14

Sync Transmit Queue 1 (disabled)

Async Transmit Queue 1
---------------
Buffer control                   0x0030
Byte Counter                     49438
Descriptor Address               0x0000000026F315A7
Status                           0x000005EA
Timestamp                        0x00010000
BMU Control/Status               0x800011AA
Done                             0x0000
Request                          0x0000000026F315D7
Csum Start 0x0032 Pos    0 Write 0

Receive RAMbuffer 1
---------------
Start Address                    0x00000000
End Address                      0x00000E7F
Write Pointer                    0x00000E33
Read Pointer                     0x00000E33
Upper Threshold/Pause Packets    0x00000D80
Lower Threshold/Pause Packets    0x000003A0
Upper Threshold/High Priority    0x00000AE0
Lower Threshold/High Priority    0x00000740
Packet Counter                   0x00000000
Level                            0x00000000
Control                          0x0002221A

Sync Transmit RAMbuffer 1 (disabled)

Async Transmit RAMbuffer 1
---------------
Start Address                    0x00000E80
End Address                      0x000017FF
Write Pointer                    0x0000137A
Read Pointer                     0x0000137A
Packet Counter                   0x00000000
Level                            0x00000000
Control                          0x0002222A

--CdrF4e02JqNVZeln--

--adJ1OR3c6QgCpb/j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGF9qsnvKppSZW8osRAn7uAJ4+HileX2aErTfZ8a6lfN8XyivIIgCfVgCW
ixHT/Fx+lgl8uJo9ZUQS/8I=
=T30H
-----END PGP SIGNATURE-----

--adJ1OR3c6QgCpb/j--
