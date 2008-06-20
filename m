Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbYFTIF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbYFTIF6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 04:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbYFTIFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 04:05:44 -0400
Received: from rayleigh.systella.fr ([213.41.184.253]:60350 "EHLO
	rayleigh.systella.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbYFTIFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 04:05:41 -0400
X-Greylist: delayed 692 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jun 2008 04:05:41 EDT
Message-ID: <485B6218.4090705@systella.fr>
Date: Fri, 20 Jun 2008 09:54:00 +0200
From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <bertrand@systella.fr>
Reply-To: mt@systella.fr, linux-kernel@vger.kernel.org
User-Agent: Mozilla/5.0 (X11; U; SunOS i86pc; fr; rv:1.7) Gecko/20070606
X-Accept-Language: fr, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: NETDEV WATCHDOG on U60/SMP
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-3.1.8 (rayleigh.systella.fr [192.168.254.1]); Fri, 20 Jun 2008 09:54:02 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello,

	This mail comes from sparclinux mailing list. I repost it on general 
linux kernel mailing list because I'm not sure that this bug is sparc 
specific. Nevertheless, I can only reproduce it on sparc64/SMP.

	My U60 runs linux debian with official 2.6.25 linux kernel (I'm
currently trying 2.6.25.7) and sometimes, when eth2 is stressed, eth2
hangs with NETDEV WATCHDOG :

NETDEV WATCHDOG: eth2: transmit timed out
eth2: transmit timed out, tx_status 00 status 8601.
   diagnostics: net 0ccc media 8880 dma 0000003a fifo 0000
eth2: Interrupt posted but not delivered -- IRQ blocked by another device?
   Flags; bus-master 1, dirty 2283344(0) current 2283344(0)
   Transmit list 00000000 vs. fffff800af098200.
   0: @fffff800af098200  length 00000042 status 0c01059a
   1: @fffff800af098260  length 00000042 status 0c01059a
   2: @fffff800af0982c0  length 00000042 status 0c01059a
   3: @fffff800af098320  length 00000042 status 0c01059a
   4: @fffff800af098380  length 00000042 status 0c01059a
   5: @fffff800af0983e0  length 00000042 status 0c01059a
   6: @fffff800af098440  length 00000042 status 0c01059a
   7: @fffff800af0984a0  length 00000042 status 0c01059a
   8: @fffff800af098500  length 8000002a status 0001002a
   9: @fffff800af098560  length 8000002a status 0001002a
   10: @fffff800af0985c0  length 8000002a status 0001002a
   11: @fffff800af098620  length 8000002a status 0001002a
   12: @fffff800af098680  length 8000002a status 0001002a
   13: @fffff800af0986e0  length 8000002a status 0001002a
   14: @fffff800af098740  length 8000002a status 8001002a
   15: @fffff800af0987a0  length 8000002a status 8001002a
eth2: Resetting the Tx ring pointer.
eth2:  setting full-duplex.
NETDEV WATCHDOG: eth2: transmit timed out
eth2: transmit timed out, tx_status 00 status 8601.
   diagnostics: net 0ccc media 8880 dma 0000003a fifo 0000
eth2: Interrupt posted but not delivered -- IRQ blocked by another device?
   Flags; bus-master 1, dirty 16(0) current 16(0)
   Transmit list 00000000 vs. fffff800af098200.
   0: @fffff800af098200  length 8000002a status 0001002a
   1: @fffff800af098260  length 8000002a status 0001002a
   2: @fffff800af0982c0  length 8000002a status 0001002a
   3: @fffff800af098320  length 8000002a status 0001002a
   4: @fffff800af098380  length 8000002a status 0001002a
   5: @fffff800af0983e0  length 8000002a status 0001002a
   6: @fffff800af098440  length 8000002a status 0001002a
   7: @fffff800af0984a0  length 8000002a status 0001002a
   8: @fffff800af098500  length 8000002a status 0001002a
   9: @fffff800af098560  length 8000002a status 0001002a
   10: @fffff800af0985c0  length 8000002a status 0001002a
   11: @fffff800af098620  length 8000002a status 0001002a
   12: @fffff800af098680  length 8000002a status 0001002a
   13: @fffff800af0986e0  length 8000002a status 0001002a
   14: @fffff800af098740  length 8000002a status 8001002a
   15: @fffff800af0987a0  length 8000002a status 8001002a
eth2: Resetting the Tx ring pointer.
eth2:  setting full-duplex.
...

	I have to reboot this server to restore eth2.
This adapter is a 3Com NIC (3C905). I have tried with several different
3Com adapters with the same result. If I change this NIC (for example 
with a HME or any PCI 2.1 adapter), I cannot reproduce the bug.

	It only occurs when ethernet traffic is high on eth2.

	I have seen this bug since 2.6.20 even on amd64 (but I'm not sure that 
this bug remains in amd64 kernel because I don't have any amd64 
workstation to test, and I don't see it on amd64 since 2.6.24. Maybe it 
is fixed on amd64...).

lspci returns :
0000:00:00.0 Host bridge: Sun Microsystems Computer Corp. Psycho PCI Bus
Module
0000:00:01.0 Bridge: Sun Microsystems Computer Corp. EBUS (rev 01)
0000:00:01.1 Ethernet controller: Sun Microsystems Computer Corp. Happy
Meal 10/100 Ethernet [hme] (rev 01)
0000:00:02.0 Ethernet controller: 3Com Corporation 3c905C-TX/TX-M
[Tornado] (rev 78)
0000:00:03.0 SCSI storage controller: LSI Logic / Symbios Logic 53c875
(rev 14)
0000:00:03.1 SCSI storage controller: LSI Logic / Symbios Logic 53c875
(rev 14)
0000:00:04.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 02)
0000:00:05.0 USB Controller: NEC Corporation USB (rev 43)
0000:00:05.1 USB Controller: NEC Corporation USB (rev 43)
0000:00:05.2 USB Controller: NEC Corporation USB 2.0 (rev 04)
0001:00:00.0 Host bridge: Sun Microsystems Computer Corp. Psycho PCI Bus
Module
0001:80:01.0 Bridge: Sun Microsystems Computer Corp. EBUS (rev 01)
0001:80:01.1 Ethernet controller: Sun Microsystems Computer Corp. Happy
Meal 10/100 Ethernet [hme] (rev 01)

ifconfig:
eth0      Link encap:Ethernet  HWaddr 08:00:20:a1:4b:33
           inet adr:192.168.0.128  Bcast:192.168.0.255  Masque:255.255.255.0
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
           RX packets:16709366 errors:0 dropped:0 overruns:0 frame:1
           TX packets:21355942 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 lg file transmission:1000
           RX bytes:2391901923 (2.2 GiB)  TX bytes:21605391421 (20.1 GiB)
           Interruption:14 Adresse de base:0x3000

eth1      Link encap:Ethernet  HWaddr 08:00:20:a1:4b:33
           inet adr:192.168.254.1  Bcast:192.168.254.255
Masque:255.255.255.0
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
           RX packets:20207169 errors:0 dropped:0 overruns:0 frame:0
           TX packets:17280402 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 lg file transmission:1000
           RX bytes:19068335140 (17.7 GiB)  TX bytes:8246313479 (7.6 GiB)
           Interruption:24 Adresse de base:0x1800

eth2      Link encap:Ethernet  HWaddr 00:04:75:df:1c:6d
           inet adr:192.168.253.1  Bcast:192.168.253.255
Masque:255.255.255.0
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
           RX packets:1843643 errors:0 dropped:0 overruns:0 frame:0
           TX packets:2416959 errors:13 dropped:0 overruns:0 carrier:0
           collisions:0 lg file transmission:1000
           RX bytes:157416047 (150.1 MiB)  TX bytes:2313298605 (2.1 GiB)
           Interruption:17 Adresse de base:0x8000

lo        Link encap:Boucle locale
           inet adr:127.0.0.1  Masque:255.0.0.0
           UP LOOPBACK RUNNING  MTU:16436  Metric:1
           RX packets:7839862 errors:0 dropped:0 overruns:0 frame:0
           TX packets:7839862 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 lg file transmission:0
           RX bytes:3713209874 (3.4 GiB)  TX bytes:3713209874 (3.4 GiB)

Interruptions:
            CPU0       CPU2
   0: 1253580857 1253580260     <NULL>  timer
   1:          0          0      sun4u  PSYCHO_PCIERR
   2:          0          0      sun4u  PSYCHO_UE
   3:          0          0      sun4u  PSYCHO_CE
   8:     733411          0      sun4u  su(kbd)
   9:          0    4396224      sun4u  su(mouse)
  10:          0          0      sun4u  parport0
  11:          4          0      sun4u  floppy
  12:          0          0      sun4u  cs4231(capture)
  13:          0          0      sun4u  cs4231(play)
  14:          0   37976886      sun4u  eth0
  15:          0  218660455      sun4u  sym53c8xx
  16:         30          0      sun4u  sym53c8xx
  17:    2042976    2011664      sun4u  eth2
  18:  137883796          0      sun4u  aic7xxx
  19:          0    1208028      sun4u  ohci_hcd:usb2
  20:          0     650947      sun4u  ohci_hcd:usb3
  21:          1          4      sun4u  ehci_hcd:usb1
  22:          0          0      sun4u  PSYCHO_PCIERR
  24:    4957716   33460983      sun4u  eth1

	Any idea ?

	Regards,

	JKB
