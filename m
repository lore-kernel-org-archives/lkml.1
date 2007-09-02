Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbXIBEM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbXIBEM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 00:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbXIBEMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 00:12:47 -0400
Received: from proxy3.bredband.net ([195.54.101.73]:64323 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbXIBEMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 00:12:46 -0400
X-Greylist: delayed 1259 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Sep 2007 00:12:46 EDT
Date: Sun, 2 Sep 2007 04:56:34 +0200
From: Mats Johannesson <spamcan@bredband.net>
To: linux-kernel@vger.kernel.org, andi@lisas.de
Subject: Re: 2.6.23-rc4-mm1
Message-ID: <20070902045634.06ea0515@loke.fish.not>
X-Mailer: Sylpheed-Claws 2.4.0 (GTK+ 2.4.13; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-09-01 16:07:48 Torsten Kaiser wrote:
[...]
> The good:
>> +hpet-force-enable-on-vt8235-37-chipsets.patch
>> +hpet-force-enable-on-vt8235-37-chipsets-fix.patch
>
> Kernel 2.6.23-rc4-mm1 works on one of my systems with:
> 00:00.0 Host bridge: VIA Technologies, Inc. VT8385 [K8T800 AGP] Host
> Bridge (rev 01)
> 00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI bridge
> [K8T800/K8T890 South]

And glory, glory, my Acer Aspire 1520 (1524) AMD64 notebook with the
old vt8235 chipset got a good kick in the behind as well. I didn't
even enable anything hpet related in the .config:

root@sleipner:~# grep -i hpet /var/log/kern.log
Sep  2 05:36:59 sleipner kernel: Force enabled HPET at base address
0xfed00000
Sep  2 05:36:59 sleipner kernel: hpet clockevent registered
Sep  2 05:37:13 sleipner kernel: Time: hpet clocksource has been
installed.

root@sleipner:~# cat /proc/timer_list
[...]
Tick Device: mode:     1
Clock Event Device: hpet
 max_delta_ns:   149983015715
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: <ffffffff8021198a>
 set_mode:       <ffffffff802119be>
 event_handler:  <ffffffff80242c6a>
tick_broadcast_mask: 00000000
tick_broadcast_oneshot_mask: 00000000

For the benefit of Andreas Mohr (and other interested parties) I now
follow the instructions in "HPET force-enable investigations on Via
VT8235 (was: Re: extra"
http://marc.info/?l=linux-kernel&m=118643307224094&w=2

Diff for easy comparison:

--- lspci-d-1106-3177-xxx-23-rc4.txt
+++ lspci-d-1106-3177-xxx-23-rc4-mm1.txt
@@ -5,10 +5,10 @@
 30: 00 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00
 40: 44 80 f0 0b a0 0b 10 00 8c 20 00 00 04 00 00 08
 50: 01 08 09 00 00 00 00 00 43 9e 00 0a 10 fe 00 fe
-60: 00 00 60 00 01 60 0b 04 00 00 00 00 00 00 00 00
+60: 00 00 60 00 01 60 0b 04 80 00 d0 fe 00 00 00 00
 70: 06 11 77 31 00 00 00 00 00 00 00 00 20 00 00 00
 80: 00 84 59 00 da 40 00 00 01 40 00 00 00 18 00 00
-90: 00 75 0f 00 90 c1 07 00 00 3d 0f 00 00 00 00 00
+90: 00 75 0f 00 90 c1 07 00 00 3d 10 00 00 00 00 00
 a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 c0: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00

Full dumps:

(On 2.6.23-rc4): lspci -d 1106:3177 -xxx
00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge
00: 06 11 77 31 87 00 10 02 00 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 77 31
30: 00 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00
40: 44 80 f0 0b a0 0b 10 00 8c 20 00 00 04 00 00 08
50: 01 08 09 00 00 00 00 00 43 9e 00 0a 10 fe 00 fe
60: 00 00 60 00 01 60 0b 04 00 00 00 00 00 00 00 00
70: 06 11 77 31 00 00 00 00 00 00 00 00 20 00 00 00
80: 00 84 59 00 da 40 00 00 01 40 00 00 00 18 00 00
90: 00 75 0f 00 90 c1 07 00 00 3d 0f 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 01 81 01 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 44 00 00 00 00 00 00 00 04 00 00 00
f0: 00 00 00 00 00 00 1b 00 00 00 00 00 01 00 00 00

(On 2.6.23-rc4-mm1): lspci -d 1106:3177 -xxx
00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge
00: 06 11 77 31 87 00 10 02 00 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 06 11 77 31
30: 00 00 00 00 c0 00 00 00 00 00 00 00 00 00 00 00
40: 44 80 f0 0b a0 0b 10 00 8c 20 00 00 04 00 00 08
50: 01 08 09 00 00 00 00 00 43 9e 00 0a 10 fe 00 fe
60: 00 00 60 00 01 60 0b 04 80 00 d0 fe 00 00 00 00
70: 06 11 77 31 00 00 00 00 00 00 00 00 20 00 00 00
80: 00 84 59 00 da 40 00 00 01 40 00 00 00 18 00 00
90: 00 75 0f 00 90 c1 07 00 00 3d 10 00 00 00 00 00
a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
c0: 01 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 01 81 01 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 00 00 00 00 44 00 00 00 00 00 00 00 04 00 00 00
f0: 00 00 00 00 00 00 1b 00 00 00 00 00 01 00 00 00

And a full "lspci -nn":

00:00.0 Host bridge [0600]: VIA Technologies, Inc. K8M800 Host Bridge
[1106:0204]
00:00.1 Host bridge [0600]: VIA Technologies, Inc. K8M800 Host Bridge
[1106:1204]
00:00.2 Host bridge [0600]: VIA Technologies, Inc. K8M800 Host Bridge
[1106:2204]
00:00.3 Host bridge [0600]: VIA Technologies, Inc. K8M800 Host Bridge
[1106:3204]
00:00.4 Host bridge [0600]: VIA Technologies, Inc. K8M800 Host Bridge
[1106:4204]
00:00.7 Host bridge [0600]: VIA Technologies, Inc. K8M800 Host Bridge
[1106:7204]
00:01.0 PCI bridge [0604]: VIA Technologies, Inc. VT8237 PCI bridge
[K8T800/K8T890 South] [1106:b188]
00:0a.0 Ethernet controller [0200]: Linksys, A Division of Cisco
Systems [AirConn] INPROCOMM IPN 2220 Wireless LAN Adapter (rev 01)
[17fe:2220]
00:0b.0 CardBus bridge [0607]: Texas Instruments PCI7420 CardBus
Controller [104c:ac8e]
00:0b.1 CardBus bridge [0607]: Texas Instruments PCI7420 CardBus
Controller [104c:ac8e]
00:0b.2 FireWire (IEEE 1394) [0c00]: Texas Instruments PCI7x20
1394a-2000 OHCI Two-Port PHY/Link-Layer Controller [104c:802e]
00:0c.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
RTL-8169 Gigabit Ethernet [10ec:8169] (rev 10)
00:10.0 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI
USB 1.1 Controller [1106:3038] (rev 80)
00:10.1 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI
USB 1.1 Controller [1106:3038] (rev 80)
00:10.2 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI
USB 1.1 Controller [1106:3038] (rev 80)
00:10.3 USB Controller [0c03]: VIA Technologies, Inc. USB 2.0
[1106:3104] (rev 82)
00:11.0 ISA bridge [0601]: VIA Technologies, Inc. VT8235 ISA Bridge
[1106:3177]
00:11.1 IDE interface [0101]: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE [1106:0571]
(rev 06)
00:11.5 Multimedia audio controller [0401]: VIA Technologies, Inc.
VT8233/A/8235/8237 AC97 Audio Controller [1106:3059] (rev 50)
00:11.6 Communication controller [0780]: VIA Technologies, Inc. AC'97
Modem Controller [1106:3068] (rev 80)
00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] HyperTransport Technology Configuration [1022:1100]
00:18.1 Host bridge [0600]: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Address Map [1022:1101]
00:18.2 Host bridge [0600]: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] DRAM Controller [1022:1102]
00:18.3 Host bridge [0600]: Advanced Micro Devices [AMD] K8
[Athlon64/Opteron] Miscellaneous Control [1022:1103]
01:00.0 VGA compatible controller [0300]: nVidia Corporation NV36
[GeForce FX Go5700] [10de:0347] (rev a1)

Mvh
Mats Johannesson
