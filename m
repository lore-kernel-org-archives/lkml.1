Return-Path: <linux-kernel-owner+w=401wt.eu-S1161915AbXECNxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161915AbXECNxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 09:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161922AbXECNxf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 09:53:35 -0400
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:43577 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161915AbXECNxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 09:53:31 -0400
X-Greylist: delayed 4143 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 May 2007 09:53:30 EDT
Message-ID: <4639D927.4080406@tobbe.nu>
Date: Thu, 03 May 2007 14:44:23 +0200
From: Tobias Bengtsson <tobbe@tobbe.nu>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: SDHCI issues on Ricoh in 2.6.20, 21 and 21-rc7-mm2
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Inserting a SD card after bootup does not work.
Please cc any response to me personally as I'm not on the list.

This is the hardware I have (in a Fujitsu Siemens Amilo SI 1520 laptop):
  07:09.1 Generic system peripheral [0805]: Ricoh Co Ltd R5C822 
SD/SDIO/MMC/MS/MSPro Host Adapter (rev 19)
        Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10ad
        Flags: bus master, medium devsel, latency 64, IRQ 22
        Memory at dc001800 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2

When booting up with card in slot, device /dev/mmcblk0 is created, 
everything is fine. See long output below.
The dmesg output is from 2.6.21.

Then removing modules and then removing card:
  for i in sdhci mmc_block mmc_core; do
    /sbin/rmmod $i >/dev/null 2>&1
  done
  dmesg -c
    [ 1360.900000] sdhci [sdhci_drv_exit()]: Exiting
    [ 1360.900000] PM: Removing info for mmc:mmc0:37a1
    [ 1360.900000] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 
width 0 timing 0
    [ 1360.900000] PM: Removing info for No Bus:mmc0
    [ 1360.904000] ACPI: PCI interrupt for device 0000:07:09.1 disabled

Inserting card, dmesg -c -> no output, no events in udevmonitor, no 
device created.
Removing card -> no output
Inserting modules again:
  for i in mmc_core mmc_block sdhci; do
    /sbin/modprobe $i >/dev/null 2>&1
  done
  dmesg -c
[ 1573.484000] sdhci: Secure Digital Host Controller Interface driver
[ 1573.484000] sdhci: Copyright(c) Pierre Ossman
[ 1573.488000] sdhci: SDHCI controller found at 0000:07:09.1 [1180:0822] 
(rev 19)
[ 1573.488000] sdhci [sdhci_probe()]: found 1 slot(s)
[ 1573.488000] ACPI: PCI Interrupt 0000:07:09.1[B] -> GSI 21 (level, 
low) -> IRQ 22
[ 1573.488000] sdhci [sdhci_probe_slot()]: slot 0 at 0xdc001800, irq 22
[ 1573.488000] sdhci: ============== REGISTER DUMP ==============
[ 1573.488000] sdhci: Sys addr: 0x00000000 | Version:  0x00000200
[ 1573.488000] sdhci: Blk size: 0x00000000 | Blk cnt:  0x00000000
[ 1573.488000] sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
[ 1573.488000] sdhci: Present:  0x01f20000 | Host ctl: 0x00000000
[ 1573.488000] sdhci: Power:    0x00000000 | Blk gap:  0x00000000
[ 1573.488000] sdhci: Wake-up:  0x00000000 | Clock:    0x00000000
[ 1573.488000] sdhci: Timeout:  0x00000008 | Int stat: 0x00000000
[ 1573.488000] sdhci: Int enab: 0x00ff00fb | Sig enab: 0x00ff00fb
[ 1573.488000] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[ 1573.488000] sdhci: Caps:     0x018021a1 | Max curr: 0x00000040
[ 1573.488000] sdhci: ===========================================
[ 1573.492000] PM: Adding info for No Bus:mmc0
[ 1573.492000] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 
timing 0
[ 1573.492000] mmc0: SDHCI at 0xdc001800 irq 22 DMA
[ 1573.492000] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 
timing 0
[ 1573.492000] mmc0: clock 128906Hz busmode 1 powermode 2 cs 0 Vdd 21 
width 0 timing 0
[ 1573.496000] mmc0: clock 128906Hz busmode 1 powermode 2 cs 1 Vdd 21 
width 0 timing 0
[ 1573.496000] mmc0: starting CMD0 arg 00000000 flags 00000040
[ 1573.496000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (0)
[ 1573.496000] mmc0: req done (CMD0): 1/0/0: 00000000 00000000 00000000 
00000000
[ 1573.500000] mmc0: clock 128906Hz busmode 1 powermode 2 cs 0 Vdd 21 
width 0 timing 0
[ 1573.500000] mmc0: starting CMD8 arg 000001aa flags 00000075
[ 1573.504000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (8)
[ 1573.504000] mmc0: req done (CMD8): 1/0/0: 00000000 00000000 00000000 
00000000
[ 1573.504000] mmc0: starting CMD55 arg 00000000 flags 00000015
[ 1573.504000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[ 1573.504000] mmc0: req done (CMD55): 1/0/0: 00000000 00000000 00000000 
00000000
[ 1573.504000] mmc0: starting CMD55 arg 00000000 flags 00000015
[ 1573.504000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[ 1573.504000] mmc0: req done (CMD55): 1/0/0: 00000000 00000000 00000000 
00000000
[ 1573.504000] mmc0: starting CMD55 arg 00000000 flags 00000015
[ 1573.508000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[ 1573.508000] mmc0: req done (CMD55): 1/0/0: 00000000 00000000 00000000 
00000000
[ 1573.508000] mmc0: starting CMD55 arg 00000000 flags 00000015
[ 1573.508000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[ 1573.508000] mmc0: req done (CMD55): 1/0/0: 00000000 00000000 00000000 
00000000
[ 1573.508000] mmc0: starting CMD1 arg 00000000 flags 00000061
[ 1573.508000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (1)
[ 1573.508000] mmc0: req done (CMD1): 1/0/0: 00000000 00000000 00000000 
00000000
[ 1573.508000] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 
timing 0

Inserting card again -> no output.
Removing modules -> usual output.
Inserting card -> no output.
Loading modules
diff /tmp/sd-start-with-card /tmp/sd-start-without-card
11c11
< sdhci: Present:  0x01fa0000 | Host ctl: 0x00000000
---
 > sdhci: Present:  0x01f20000 | Host ctl: 0x00000000
13c13
< sdhci: Wake-up:  0x00000000 | Clock:    0x00008000
---
 > sdhci: Wake-up:  0x00000000 | Clock:    0x00000000



Booting up, device /dev/mmcblk0 is created, everything is fine.

[   18.708000] sdhci: Secure Digital Host Controller Interface driver
[   18.708000] sdhci: Copyright(c) Pierre Ossman
[   18.708000] sdhci: SDHCI controller found at 0000:07:09.1 [1180:0822] 
(rev 19)
[   18.708000] sdhci [sdhci_probe()]: found 1 slot(s)
[   18.708000] PCI: Enabling device 0000:07:09.1 (0000 -> 0002)
[   18.708000] ACPI: PCI Interrupt 0000:07:09.1[B] -> GSI 21 (level, 
low) -> IRQ 22
[   18.712000] sdhci [sdhci_probe_slot()]: slot 0 at 0xdc001800, irq 22
[   18.712000] PCI: Setting latency timer of device 0000:07:09.1 to 64
[   18.712000] sdhci: ============== REGISTER DUMP ==============
[   18.712000] sdhci: Sys addr: 0x00000000 | Version:  0x00000200
[   18.712000] sdhci: Blk size: 0x00000000 | Blk cnt:  0x00000000
[   18.712000] sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
[   18.712000] sdhci: Present:  0x01ff0000 | Host ctl: 0x00000000
[   18.712000] sdhci: Power:    0x00000000 | Blk gap:  0x00000000
[   18.712000] sdhci: Wake-up:  0x00000000 | Clock:    0x00000000
[   18.712000] sdhci: Timeout:  0x00000000 | Int stat: 0x00000000
[   18.712000] sdhci: Int enab: 0x00ff00fb | Sig enab: 0x00ff00fb
[   18.712000] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[   18.712000] sdhci: Caps:     0x018021a1 | Max curr: 0x00000040
[   18.712000] sdhci: ===========================================
[   18.712000] PM: Adding info for No Bus:mmc0
[   18.712000] mmc0: clock 0Hz busmode 1 powermode 0 cs 0 Vdd 0 width 0 
timing 0
[   18.716000] mmc0: SDHCI at 0xdc001800 irq 22 DMA
[   18.716000] mmc0: clock 0Hz busmode 1 powermode 1 cs 0 Vdd 21 width 0 
timing 0
[   18.716000] mmc0: clock 128906Hz busmode 1 powermode 2 cs 0 Vdd 21 
width 0 timing 0
[   18.716000] mmc0: clock 128906Hz busmode 1 powermode 2 cs 1 Vdd 21 
width 0 timing 0
[   18.720000] mmc0: starting CMD0 arg 00000000 flags 00000040
[   18.720000] sdhci [sdhci_send_command()]: Sending cmd (0)
[   18.720000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.720000] sdhci [sdhci_finish_command()]: Ending cmd (0)
[   18.720000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (0)
[   18.720000] mmc0: req done (CMD0): 0/0/0: 00000000 00000000 00000000 
00000000
[   18.728000] mmc0: clock 128906Hz busmode 1 powermode 2 cs 0 Vdd 21 
width 0 timing 0
[   18.728000] mmc0: starting CMD8 arg 000001aa flags 00000075
[   18.728000] sdhci [sdhci_send_command()]: Sending cmd (8)
[   18.728000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00018000
[   18.728000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (8)
[   18.732000] mmc0: req done (CMD8): 1/0/0: 00000000 00000000 00000000 
00000000
[   18.732000] mmc0: starting CMD55 arg 00000000 flags 00000015
[   18.732000] sdhci [sdhci_send_command()]: Sending cmd (37)
[   18.732000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.732000] sdhci [sdhci_finish_command()]: Ending cmd (37)
[   18.732000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   18.732000] mmc0: req done (CMD55): 0/0/0: 00400120 00000000 00000000 
00000000
[   18.732000] mmc0: starting CMD41 arg 00000000 flags 00000061
[   18.732000] sdhci [sdhci_send_command()]: Sending cmd (29)
[   18.732000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.732000] sdhci [sdhci_finish_command()]: Ending cmd (29)
[   18.732000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (29)
[   18.732000] mmc0: req done (CMD41): 0/0/0: 00ff8000 00000000 00000000 
00000000
[   18.732000] mmc0: clock 128906Hz busmode 1 powermode 2 cs 0 Vdd 20 
width 0 timing 0
[   18.732000] mmc0: clock 128906Hz busmode 1 powermode 2 cs 1 Vdd 20 
width 0 timing 0
[   18.732000] mmc0: starting CMD0 arg 00000000 flags 00000040
[   18.732000] sdhci [sdhci_send_command()]: Sending cmd (0)
[   18.736000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.736000] sdhci [sdhci_finish_command()]: Ending cmd (0)
[   18.736000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (0)
[   18.736000] mmc0: req done (CMD0): 0/0/0: 00000000 00000000 00000000 
00000000
[   18.736000] mmc0: clock 128906Hz busmode 1 powermode 2 cs 0 Vdd 20 
width 0 timing 0
[   18.736000] mmc0: starting CMD8 arg 000001aa flags 00000075
[   18.736000] sdhci [sdhci_send_command()]: Sending cmd (8)
[   18.736000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00018000
[   18.736000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (8)
[   18.740000] mmc0: req done (CMD8): 1/0/0: 00000000 00000000 00000000 
00000000
[   18.740000] mmc0: starting CMD55 arg 00000000 flags 00000015
[   18.740000] sdhci [sdhci_send_command()]: Sending cmd (37)
[   18.740000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.740000] sdhci [sdhci_finish_command()]: Ending cmd (37)
[   18.740000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   18.740000] mmc0: req done (CMD55): 0/0/0: 00400120 00000000 00000000 
00000000
[   18.740000] mmc0: starting CMD41 arg 00300000 flags 00000061
[   18.740000] sdhci [sdhci_send_command()]: Sending cmd (29)
[   18.740000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.740000] sdhci [sdhci_finish_command()]: Ending cmd (29)
[   18.740000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (29)
[   18.740000] mmc0: req done (CMD41): 0/0/0: 00ff8000 00000000 00000000 
00000000
[   18.756000] mmc0: starting CMD55 arg 00000000 flags 00000015
[   18.756000] sdhci [sdhci_send_command()]: Sending cmd (37)
[   18.756000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.756000] sdhci [sdhci_finish_command()]: Ending cmd (37)
[   18.756000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   18.756000] mmc0: req done (CMD55): 0/0/0: 00000120 00000000 00000000 
00000000
[   18.756000] mmc0: starting CMD41 arg 00300000 flags 00000061
[   18.756000] sdhci [sdhci_send_command()]: Sending cmd (29)
[   18.756000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.756000] sdhci [sdhci_finish_command()]: Ending cmd (29)
[   18.756000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (29)
[   18.756000] mmc0: req done (CMD41): 0/0/0: 00ff8000 00000000 00000000 
00000000
[   18.772000] mmc0: starting CMD55 arg 00000000 flags 00000015
[   18.772000] sdhci [sdhci_send_command()]: Sending cmd (37)
[   18.772000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.772000] sdhci [sdhci_finish_command()]: Ending cmd (37)
[   18.772000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   18.772000] mmc0: req done (CMD55): 0/0/0: 00000120 00000000 00000000 
00000000
[   18.772000] mmc0: starting CMD41 arg 00300000 flags 00000061
[   18.772000] sdhci [sdhci_send_command()]: Sending cmd (29)
[   18.772000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.772000] sdhci [sdhci_finish_command()]: Ending cmd (29)
[   18.772000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (29)
[   18.772000] mmc0: req done (CMD41): 0/0/0: 00ff8000 00000000 00000000 
00000000
[   18.788000] mmc0: starting CMD55 arg 00000000 flags 00000015
[   18.788000] sdhci [sdhci_send_command()]: Sending cmd (37)
[   18.788000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.788000] sdhci [sdhci_finish_command()]: Ending cmd (37)
[   18.788000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   18.788000] mmc0: req done (CMD55): 0/0/0: 00000120 00000000 00000000 
00000000
[   18.788000] mmc0: starting CMD41 arg 00300000 flags 00000061
[   18.788000] sdhci [sdhci_send_command()]: Sending cmd (29)
[   18.788000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.788000] sdhci [sdhci_finish_command()]: Ending cmd (29)
[   18.788000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (29)
[   18.788000] mmc0: req done (CMD41): 0/0/0: 00ff8000 00000000 00000000 
00000000
[   18.792000] Bluetooth: Core ver 2.11
[   18.792000] PM: Adding info for platform:bluetooth
[   18.792000] NET: Registered protocol family 31
[   18.792000] Bluetooth: HCI device and connection manager initialized
[   18.792000] Bluetooth: HCI socket layer initialized
[   18.804000] mmc0: starting CMD55 arg 00000000 flags 00000015
[   18.804000] sdhci [sdhci_send_command()]: Sending cmd (37)
[   18.804000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.804000] sdhci [sdhci_finish_command()]: Ending cmd (37)
[   18.804000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   18.804000] mmc0: req done (CMD55): 0/0/0: 00000120 00000000 00000000 
00000000
[   18.804000] mmc0: starting CMD41 arg 00300000 flags 00000061
[   18.804000] sdhci [sdhci_send_command()]: Sending cmd (29)
[   18.804000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.804000] sdhci [sdhci_finish_command()]: Ending cmd (29)
[   18.804000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (29)
[   18.804000] mmc0: req done (CMD41): 0/0/0: 00ff8000 00000000 00000000 
00000000
[   18.820000] mmc0: starting CMD55 arg 00000000 flags 00000015
[   18.820000] sdhci [sdhci_send_command()]: Sending cmd (37)
[   18.820000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.820000] sdhci [sdhci_finish_command()]: Ending cmd (37)
[   18.820000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   18.820000] mmc0: req done (CMD55): 0/0/0: 00000120 00000000 00000000 
00000000
[   18.820000] mmc0: starting CMD41 arg 00300000 flags 00000061
[   18.820000] sdhci [sdhci_send_command()]: Sending cmd (29)
[   18.820000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.820000] sdhci [sdhci_finish_command()]: Ending cmd (29)
[   18.820000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (29)
[   18.820000] mmc0: req done (CMD41): 0/0/0: 00ff8000 00000000 00000000 
00000000
[   18.836000] mmc0: starting CMD55 arg 00000000 flags 00000015
[   18.836000] sdhci [sdhci_send_command()]: Sending cmd (37)
[   18.836000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.836000] sdhci [sdhci_finish_command()]: Ending cmd (37)
[   18.836000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   18.836000] mmc0: req done (CMD55): 0/0/0: 00000120 00000000 00000000 
00000000
[   18.836000] mmc0: starting CMD41 arg 00300000 flags 00000061
[   18.836000] sdhci [sdhci_send_command()]: Sending cmd (29)
[   18.836000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.836000] sdhci [sdhci_finish_command()]: Ending cmd (29)
[   18.836000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (29)
[   18.836000] mmc0: req done (CMD41): 0/0/0: 00ff8000 00000000 00000000 
00000000
[   18.852000] mmc0: starting CMD55 arg 00000000 flags 00000015
[   18.852000] sdhci [sdhci_send_command()]: Sending cmd (37)
[   18.852000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.852000] sdhci [sdhci_finish_command()]: Ending cmd (37)
[   18.852000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   18.852000] mmc0: req done (CMD55): 0/0/0: 00000120 00000000 00000000 
00000000
[   18.852000] mmc0: starting CMD41 arg 00300000 flags 00000061
[   18.852000] sdhci [sdhci_send_command()]: Sending cmd (29)
[   18.852000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.852000] sdhci [sdhci_finish_command()]: Ending cmd (29)
[   18.852000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (29)
[   18.852000] mmc0: req done (CMD41): 0/0/0: 80ff8000 00000000 00000000 
00000000
[   18.852000] mmc0: starting CMD2 arg 00000000 flags 00000067
[   18.852000] sdhci [sdhci_send_command()]: Sending cmd (2)
[   18.852000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.852000] sdhci [sdhci_finish_command()]: Ending cmd (2)
[   18.852000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (2)
[   18.852000] mmc0: req done (CMD2): 0/0/0: 01504153 30333242 92cad337 
a1007200
[   18.852000] mmc0: starting CMD3 arg 00000000 flags 00000075
[   18.852000] sdhci [sdhci_send_command()]: Sending cmd (3)
[   18.852000] PM: Adding info for No Bus:timer
[   18.856000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.856000] sdhci [sdhci_finish_command()]: Ending cmd (3)
[   18.856000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (3)
[   18.856000] mmc0: req done (CMD3): 0/0/0: 37a10520 00000000 00000000 
00000000
[   18.856000] mmc0: starting CMD2 arg 00000000 flags 00000067
[   18.856000] sdhci [sdhci_send_command()]: Sending cmd (2)
[   18.856000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00018000
[   18.856000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (2)
[   18.856000] mmc0: req done (CMD2): 1/0/0: 00000000 00000000 00000000 
00000000
[   18.856000] sdhci [sdhci_send_command()]: Sending cmd (2)
[   18.860000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00018000
[   18.860000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (2)
[   18.860000] mmc0: req done (CMD2): 1/0/0: 00000000 00000000 00000000 
00000000
[   18.860000] sdhci [sdhci_send_command()]: Sending cmd (2)
[   18.860000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00018000
[   18.860000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (2)
[   18.864000] mmc0: req done (CMD2): 1/0/0: 00000000 00000000 00000000 
00000000
[   18.864000] sdhci [sdhci_send_command()]: Sending cmd (2)
[   18.864000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00018000
[   18.864000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (2)
[   18.868000] mmc0: req done (CMD2): 1/0/0: 00000000 00000000 00000000 
00000000
[   18.868000] mmc0: clock 128906Hz busmode 2 powermode 2 cs 0 Vdd 20 
width 0 timing 0
[   18.868000] mmc0: starting CMD9 arg 37a10000 flags 00000007
[   18.868000] sdhci [sdhci_send_command()]: Sending cmd (9)
[   18.868000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.868000] sdhci [sdhci_finish_command()]: Ending cmd (9)
[   18.868000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (9)
[   18.868000] mmc0: req done (CMD9): 0/0/0: 005d0132 135981da f6d9cfff 
16400000
[   18.868000] mmc0: starting CMD7 arg 37a10000 flags 00000015
[   18.868000] sdhci [sdhci_send_command()]: Sending cmd (7)
[   18.868000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.868000] sdhci [sdhci_finish_command()]: Ending cmd (7)
[   18.868000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (7)
[   18.868000] mmc0: req done (CMD7): 0/0/0: 00000700 00000000 00000000 
00000000
[   18.868000] mmc0: clock 128906Hz busmode 2 powermode 2 cs 0 Vdd 20 
width 0 timing 0
[   18.868000] mmc0: starting CMD55 arg 37a10000 flags 00000015
[   18.868000] sdhci [sdhci_send_command()]: Sending cmd (37)
[   18.872000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.872000] sdhci [sdhci_finish_command()]: Ending cmd (37)
[   18.872000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   18.872000] mmc0: req done (CMD55): 0/0/0: 00000920 00000000 00000000 
00000000
[   18.872000] mmc0: starting CMD51 arg 00000000 flags 00000035
[   18.872000] sdhci [sdhci_send_command()]: Sending cmd (33)
[   18.872000] sdhci [sdhci_prepare_data()]: blksz 0008 blks 0001 flags 
00000200
[   18.872000] sdhci [sdhci_prepare_data()]: tsac 100 ms nsac 0 clk
[   18.872000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.872000] sdhci [sdhci_finish_command()]: Ending cmd (33)
[   18.872000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   18.872000] sdhci [sdhci_finish_data()]: Ending data transfer (8 bytes)
[   18.872000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (33)
[   18.872000] mmc0: req done (CMD51): 0/0/0: 00000920 00000000 00000000 
00000000
[   18.872000] mmc0: starting CMD7 arg 00000000 flags 00000000
[   18.872000] sdhci [sdhci_send_command()]: Sending cmd (7)
[   18.872000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.872000] sdhci [sdhci_finish_command()]: Ending cmd (7)
[   18.872000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (7)
[   18.872000] mmc0: req done (CMD7): 0/0/0: 00000000 00000000 00000000 
00000000
[   18.872000] mmc0: selected 25.000MHz transfer rate
[   18.872000] mmc0: clock 25000000Hz busmode 2 powermode 2 cs 0 Vdd 20 
width 0 timing 0
[   18.872000] PM: Adding info for mmc:mmc0:37a1
[   18.888000] Bluetooth: HCI USB driver ver 2.9
[   18.936000] PM: Adding info for No Bus:seq
[   18.956000] mmc0: starting CMD7 arg 37a10000 flags 00000015
[   18.956000] sdhci [sdhci_send_command()]: Sending cmd (7)
[   18.956000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.956000] sdhci [sdhci_finish_command()]: Ending cmd (7)
[   18.956000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (7)
[   18.956000] mmc0: req done (CMD7): 0/0/0: 00000700 00000000 00000000 
00000000
[   18.960000] mmc0: starting CMD55 arg 37a10000 flags 00000015
[   18.960000] sdhci [sdhci_send_command()]: Sending cmd (37)
[   18.960000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.960000] sdhci [sdhci_finish_command()]: Ending cmd (37)
[   18.960000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (37)
[   18.960000] mmc0: req done (CMD55): 0/0/0: 00000920 00000000 00000000 
00000000
[   18.960000] mmc0: starting CMD6 arg 00000002 flags 00000015
[   18.960000] sdhci [sdhci_send_command()]: Sending cmd (6)
[   18.960000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.960000] sdhci [sdhci_finish_command()]: Ending cmd (6)
[   18.960000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (6)
[   18.960000] mmc0: req done (CMD6): 0/0/0: 00000920 00000000 00000000 
00000000
[   18.960000] mmc0: clock 25000000Hz busmode 2 powermode 2 cs 0 Vdd 20 
width 2 timing 0
[   18.960000] mmc0: starting CMD16 arg 00000200 flags 00000015
[   18.960000] sdhci [sdhci_send_command()]: Sending cmd (10)
[   18.960000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.960000] sdhci [sdhci_finish_command()]: Ending cmd (10)
[   18.960000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (10)
[   18.960000] mmc0: req done (CMD16): 0/0/0: 00000900 00000000 00000000 
00000000
[   18.960000] mmcblk0: mmc0:37a1 S032B 30400KiB
[   18.960000]  mmcblk0:<7>mmc0: starting CMD18 arg 00000000 flags 00000035
[   18.960000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   18.960000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   18.960000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   18.960000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   18.960000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   18.960000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   18.960000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   18.960000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   18.960000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   18.960000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   18.960000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   18.960000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   18.960000]  p1
[   19.004000] PM: Removing info for No Bus:usbdev3.2_ep03
[   19.004000] PM: Removing info for No Bus:usbdev3.2_ep83
[   19.004000] PM: Adding info for No Bus:usbdev3.2_ep03
[   19.004000] PM: Adding info for No Bus:usbdev3.2_ep83
[   19.004000] PM: Adding info for No Bus:hci0
[   19.004000] usbcore: registered new interface driver hci_usb
[   19.028000] mmc0: starting CMD18 arg 01da0000 flags 00000035
[   19.028000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.028000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.028000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.028000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.028000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.028000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.028000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.028000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.028000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.028000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.028000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.028000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.028000] mmc0: starting CMD18 arg 01daf000 flags 00000035
[   19.028000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.028000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.028000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.028000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.028000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.028000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.028000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.028000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.028000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.028000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.028000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.028000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.028000] mmc0: starting CMD18 arg 01da8000 flags 00000035
[   19.028000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.028000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.028000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.028000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.028000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.032000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x0000000a
[   19.032000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.032000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.032000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.032000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.032000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.032000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.032000] mmc0: starting CMD18 arg 01d90000 flags 00000035
[   19.032000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.032000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.032000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.032000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.032000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.032000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.032000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.032000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.032000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.032000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.032000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.032000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.032000] mmc0: starting CMD18 arg 01dae000 flags 00000035
[   19.032000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.032000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.032000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.032000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.032000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.036000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.036000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.036000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.036000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.036000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.036000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.036000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.036000] mmc0: starting CMD18 arg 01d7e000 flags 00000035
[   19.036000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.036000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.036000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.036000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.036000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.036000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.036000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.036000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.036000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.036000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.036000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.036000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.036000] mmc0: starting CMD18 arg 00000000 flags 00000035
[   19.036000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.036000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.036000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.036000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.036000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.040000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.040000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.040000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.040000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.040000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.040000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.040000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.040000] mmc0: starting CMD18 arg 00001000 flags 00000035
[   19.040000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.040000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.040000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.040000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.040000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.040000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.040000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.040000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.040000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.040000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.040000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.040000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.040000] mmc0: starting CMD18 arg 00002000 flags 00000035
[   19.040000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.040000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.040000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.040000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.040000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.040000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.040000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.040000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.040000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.040000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.040000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.040000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.040000] mmc0: starting CMD18 arg 00003000 flags 00000035
[   19.040000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.040000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.040000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.040000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.040000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.044000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.044000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.044000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.044000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.044000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.044000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.044000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.044000] mmc0: starting CMD18 arg 00004000 flags 00000035
[   19.044000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.044000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.044000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.044000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.044000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.044000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.044000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.044000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.044000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.044000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.044000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.044000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.044000] mmc0: starting CMD18 arg 00005000 flags 00000035
[   19.044000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.044000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.044000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.044000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.044000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.044000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.044000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.044000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.044000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.044000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.044000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.044000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.044000] mmc0: starting CMD18 arg 00006000 flags 00000035
[   19.044000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.044000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.044000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.044000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.044000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.048000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.048000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.048000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.048000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.048000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.048000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.048000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.048000] mmc0: starting CMD18 arg 00007000 flags 00000035
[   19.048000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.048000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.048000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.048000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.048000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.048000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.048000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.048000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.048000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.048000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.048000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.048000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.048000] mmc0: starting CMD18 arg 00008000 flags 00000035
[   19.048000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.048000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.048000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.048000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.048000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.052000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.052000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.052000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.052000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.052000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.052000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.052000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.052000] mmc0: starting CMD18 arg 00009000 flags 00000035
[   19.052000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.052000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.052000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.052000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.052000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.052000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.052000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.052000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.052000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.052000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.052000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.052000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.052000] mmc0: starting CMD18 arg 0000a000 flags 00000035
[   19.052000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.052000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.052000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.052000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.052000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.052000] PM: Adding info for No Bus:sequencer
[   19.052000] PM: Adding info for No Bus:sequencer2
[   19.056000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.056000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.056000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.056000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.056000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.056000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.056000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.064000] mmc0: starting CMD18 arg 0000b000 flags 00000035
[   19.064000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.064000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.064000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.064000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.064000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.064000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.064000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.064000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.064000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.064000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.064000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.064000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.064000] mmc0: starting CMD18 arg 0000c000 flags 00000035
[   19.064000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.064000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.064000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.064000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.064000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.068000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.068000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.068000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.068000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.068000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.068000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.068000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.068000] mmc0: starting CMD18 arg 0000d000 flags 00000035
[   19.068000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.068000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.068000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.068000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.068000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.068000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.068000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.068000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.068000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.068000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.068000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.068000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.068000] mmc0: starting CMD18 arg 0000e000 flags 00000035
[   19.068000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.068000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.068000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.068000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.068000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.068000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.068000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.068000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.068000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.068000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.068000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.068000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.068000] mmc0: starting CMD18 arg 0000f000 flags 00000035
[   19.068000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.068000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.068000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.068000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.068000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.072000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.072000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.072000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.072000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.072000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.072000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.072000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.072000] mmc0: starting CMD18 arg 00010000 flags 00000035
[   19.072000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.072000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.072000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.072000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.072000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.072000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.072000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.072000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.072000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.072000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.072000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.072000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.072000] mmc0: starting CMD18 arg 00040000 flags 00000035
[   19.072000] sdhci [sdhci_send_command()]: Sending cmd (12)
[   19.072000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0008 flags 
00000a00
[   19.072000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.072000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.072000] sdhci [sdhci_finish_command()]: Ending cmd (12)
[   19.076000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.076000] sdhci [sdhci_finish_data()]: Ending data transfer (4096 
bytes)
[   19.076000] sdhci [sdhci_send_command()]: Sending cmd (c)
[   19.076000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000003
[   19.076000] sdhci [sdhci_finish_command()]: Ending cmd (c)
[   19.076000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (12)
[   19.076000] mmc0: req done (CMD18): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.080000] mmc0: starting CMD17 arg 01d96600 flags 00000035
[   19.080000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.080000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.080000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.080000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.080000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.080000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.080000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.080000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.080000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.080000] mmc0: starting CMD17 arg 01d96800 flags 00000035
[   19.080000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.080000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.080000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.080000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.080000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.080000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.080000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.080000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.080000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.080000] mmc0: starting CMD17 arg 01d96a00 flags 00000035
[   19.080000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.080000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.080000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.080000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.080000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.084000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.084000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.084000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.084000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.084000] mmc0: starting CMD17 arg 01d96c00 flags 00000035
[   19.084000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.084000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.084000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.084000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.084000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.084000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.084000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.084000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.084000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.084000] mmc0: starting CMD17 arg 01d96e00 flags 00000035
[   19.084000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.084000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.084000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.084000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.084000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.084000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.084000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.084000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.084000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.084000] mmc0: starting CMD17 arg 01d97000 flags 00000035
[   19.084000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.084000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.084000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.084000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.084000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.084000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.084000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.084000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.084000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.084000] mmc0: starting CMD17 arg 01d97200 flags 00000035
[   19.084000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.084000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.084000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.084000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.084000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.084000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.084000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.084000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.084000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.084000] mmc0: starting CMD17 arg 01d97400 flags 00000035
[   19.084000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.084000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.084000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.084000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.084000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.084000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.084000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.084000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.084000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.084000] mmc0: starting CMD17 arg 01daf600 flags 00000035
[   19.084000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.084000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.084000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.084000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.084000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.084000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.084000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.084000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.084000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.084000] mmc0: starting CMD17 arg 01daf800 flags 00000035
[   19.084000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.084000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.084000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.084000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.084000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.084000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.084000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.084000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.084000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.084000] mmc0: starting CMD17 arg 01dafa00 flags 00000035
[   19.084000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.084000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.084000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.084000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.084000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.088000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.088000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.088000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.088000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.088000] mmc0: starting CMD17 arg 01dafc00 flags 00000035
[   19.088000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.088000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.088000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.088000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.088000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.088000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.088000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.088000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.088000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.088000] mmc0: starting CMD17 arg 01dafe00 flags 00000035
[   19.088000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.088000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.088000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.088000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.088000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.088000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.088000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.088000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.088000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.088000] mmc0: starting CMD17 arg 01da7600 flags 00000035
[   19.088000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.088000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.088000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.088000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.088000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.088000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.088000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.088000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.088000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.088000] mmc0: starting CMD17 arg 01da7800 flags 00000035
[   19.088000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.088000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.088000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.088000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.088000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.088000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.088000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.088000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.088000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.088000] mmc0: starting CMD17 arg 01da7a00 flags 00000035
[   19.088000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.088000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.088000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.088000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.088000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.088000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.088000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.088000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.088000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.088000] mmc0: starting CMD17 arg 01da7c00 flags 00000035
[   19.088000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.088000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.088000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.088000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.088000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.092000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.092000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.092000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.092000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.092000] mmc0: starting CMD17 arg 01da7e00 flags 00000035
[   19.092000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.092000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.092000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.092000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.092000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.092000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.092000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.092000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.092000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.092000] mmc0: starting CMD17 arg 01da8000 flags 00000035
[   19.092000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.092000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.092000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.092000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.092000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.092000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.092000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.092000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.092000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.092000] mmc0: starting CMD17 arg 01da8200 flags 00000035
[   19.092000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.092000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.092000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.092000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.092000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.092000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.092000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.092000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.092000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.092000] mmc0: starting CMD17 arg 01da8400 flags 00000035
[   19.092000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.092000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.092000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.092000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.092000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.092000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.092000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.092000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.092000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.092000] mmc0: starting CMD17 arg 01d8f600 flags 00000035
[   19.092000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.092000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.092000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.092000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.092000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.092000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.092000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.092000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.092000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.092000] mmc0: starting CMD17 arg 01d8f800 flags 00000035
[   19.092000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.092000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.092000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.092000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.092000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.092000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.092000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.092000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.092000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.092000] mmc0: starting CMD17 arg 01d8fa00 flags 00000035
[   19.092000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.092000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.092000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.092000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.092000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.092000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.092000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.092000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.092000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.092000] mmc0: starting CMD17 arg 01d8fc00 flags 00000035
[   19.092000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.092000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.092000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.092000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.092000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.096000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.096000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.096000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.096000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.096000] mmc0: starting CMD17 arg 01d8fe00 flags 00000035
[   19.096000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.096000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.096000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.096000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.096000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.096000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.096000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.096000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.096000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.096000] mmc0: starting CMD17 arg 01d90000 flags 00000035
[   19.096000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.096000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.096000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.096000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.096000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.096000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.096000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.096000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.096000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.096000] mmc0: starting CMD17 arg 01d90200 flags 00000035
[   19.096000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.096000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.096000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.096000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.096000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.096000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.096000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.096000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.096000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.096000] mmc0: starting CMD17 arg 01d90400 flags 00000035
[   19.096000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.096000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.096000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.096000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.096000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.096000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.096000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.096000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.096000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.096000] mmc0: starting CMD17 arg 01dad600 flags 00000035
[   19.096000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.096000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.096000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.096000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.096000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.096000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.096000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.096000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.096000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.096000] mmc0: starting CMD17 arg 01dad800 flags 00000035
[   19.096000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.096000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.096000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.096000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.096000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.096000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.096000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.096000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.096000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.096000] mmc0: starting CMD17 arg 01dada00 flags 00000035
[   19.096000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.096000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.096000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.096000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.096000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.096000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.096000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.100000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.100000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.100000] mmc0: starting CMD17 arg 01dadc00 flags 00000035
[   19.100000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.100000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.100000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.100000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.100000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.100000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.100000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.100000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.100000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.100000] mmc0: starting CMD17 arg 01dade00 flags 00000035
[   19.100000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.100000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.100000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.100000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.100000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.100000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.100000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.100000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.100000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.100000] mmc0: starting CMD17 arg 01dae000 flags 00000035
[   19.100000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.100000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.100000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.100000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.100000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.100000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.100000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.100000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.100000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.100000] mmc0: starting CMD17 arg 01dae200 flags 00000035
[   19.100000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.100000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.100000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.100000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.100000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.100000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.100000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.100000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.100000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.100000] mmc0: starting CMD17 arg 01dae400 flags 00000035
[   19.100000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.100000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.100000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.100000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.100000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.100000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.100000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.100000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.100000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.100000] mmc0: starting CMD17 arg 01d7d600 flags 00000035
[   19.100000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.100000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.100000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.100000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.100000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.100000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.100000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.100000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.100000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.100000] mmc0: starting CMD17 arg 01d7d800 flags 00000035
[   19.100000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.100000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.100000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.100000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.100000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.100000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.100000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.100000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.100000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.100000] mmc0: starting CMD17 arg 01d7da00 flags 00000035
[   19.100000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.100000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.100000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.100000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.100000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.104000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.104000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.104000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.104000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.104000] mmc0: starting CMD17 arg 01d7dc00 flags 00000035
[   19.104000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.104000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.104000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.104000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.104000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.104000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.104000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.104000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.104000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.104000] mmc0: starting CMD17 arg 01d7de00 flags 00000035
[   19.104000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.104000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.104000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.104000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.104000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.104000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.104000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.104000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.104000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.104000] mmc0: starting CMD17 arg 01d7e000 flags 00000035
[   19.104000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.104000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.104000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.104000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.104000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.104000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.104000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.104000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.104000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.112000] mmc0: starting CMD17 arg 01d7e200 flags 00000035
[   19.112000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.112000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.112000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.112000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.112000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.112000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.112000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.112000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.112000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.112000] mmc0: starting CMD17 arg 01d7e400 flags 00000035
[   19.112000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.112000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.112000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.112000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.112000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.112000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.112000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.112000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.112000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.112000] mmc0: starting CMD17 arg 01dae600 flags 00000035
[   19.112000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.112000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.112000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.112000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.112000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.112000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.112000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.112000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.112000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.112000] mmc0: starting CMD17 arg 01dae800 flags 00000035
[   19.112000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.112000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.112000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.112000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.112000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.112000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.112000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.112000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.112000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.112000] mmc0: starting CMD17 arg 01daea00 flags 00000035
[   19.112000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.112000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.112000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.112000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.112000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.112000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.112000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.112000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.112000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.112000] mmc0: starting CMD17 arg 01daec00 flags 00000035
[   19.112000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.112000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.112000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.112000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.112000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.112000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.112000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.112000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.112000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.112000] mmc0: starting CMD17 arg 01daee00 flags 00000035
[   19.112000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.112000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.112000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.112000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.112000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.112000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.112000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.112000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.112000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.112000] mmc0: starting CMD17 arg 01daf000 flags 00000035
[   19.112000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.112000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.112000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.112000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.112000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.112000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.112000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.112000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.112000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.112000] mmc0: starting CMD17 arg 01daf200 flags 00000035
[   19.112000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.112000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.112000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.112000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.112000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.116000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.116000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.116000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.116000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.116000] mmc0: starting CMD17 arg 01daf400 flags 00000035
[   19.116000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.116000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.116000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.116000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.116000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.116000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.116000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.116000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.116000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.116000] mmc0: starting CMD17 arg 00006600 flags 00000035
[   19.116000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.116000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.116000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.116000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.116000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.116000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.116000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.116000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.116000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.116000] mmc0: starting CMD17 arg 00006800 flags 00000035
[   19.116000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.116000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.116000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.116000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.116000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.116000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.116000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.116000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.116000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.116000] mmc0: starting CMD17 arg 00006a00 flags 00000035
[   19.116000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.116000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.116000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.116000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.116000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.116000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.116000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.116000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.116000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.116000] mmc0: starting CMD17 arg 00006c00 flags 00000035
[   19.116000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.116000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.116000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.116000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.116000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.116000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.116000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.116000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.116000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.116000] mmc0: starting CMD17 arg 00006e00 flags 00000035
[   19.116000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.116000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.116000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.116000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.116000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.116000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.116000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.116000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.120000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.120000] mmc0: starting CMD17 arg 00007000 flags 00000035
[   19.120000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.120000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.120000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.120000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.120000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.120000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.120000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.120000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.120000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.120000] mmc0: starting CMD17 arg 00007200 flags 00000035
[   19.120000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.120000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.120000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.120000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.120000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.120000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.120000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.120000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.120000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.120000] mmc0: starting CMD17 arg 00007400 flags 00000035
[   19.120000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.120000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.120000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.120000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.120000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.120000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.120000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.120000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.120000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.120000] mmc0: starting CMD17 arg 00007600 flags 00000035
[   19.120000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.120000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.120000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.120000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.120000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.120000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.120000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.120000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.120000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.120000] mmc0: starting CMD17 arg 00007800 flags 00000035
[   19.120000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.120000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.120000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.120000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.120000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.120000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.120000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.120000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.120000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.120000] mmc0: starting CMD17 arg 00007a00 flags 00000035
[   19.120000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.120000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.120000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.120000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.120000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.120000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.120000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.120000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.120000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.120000] mmc0: starting CMD17 arg 00007c00 flags 00000035
[   19.120000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.120000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.120000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.120000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.120000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.124000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.124000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.124000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.124000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.124000] mmc0: starting CMD17 arg 00007e00 flags 00000035
[   19.124000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.124000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.124000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.124000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.124000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.124000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.124000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.124000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.124000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.124000] mmc0: starting CMD17 arg 00008000 flags 00000035
[   19.124000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.124000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.124000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.124000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.124000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.124000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.124000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.124000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.124000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.124000] mmc0: starting CMD17 arg 00008200 flags 00000035
[   19.124000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.124000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.124000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.124000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.124000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.124000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.124000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.124000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.124000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.124000] mmc0: starting CMD17 arg 00008400 flags 00000035
[   19.124000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.124000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.124000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.124000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.124000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.124000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.124000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.124000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.124000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.124000] mmc0: starting CMD17 arg 00008600 flags 00000035
[   19.124000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.124000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.124000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.124000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.124000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.124000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.124000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.124000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.124000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.124000] mmc0: starting CMD17 arg 00008800 flags 00000035
[   19.124000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.124000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.124000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.124000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.124000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.124000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.124000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.124000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.124000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.124000] mmc0: starting CMD17 arg 00008a00 flags 00000035
[   19.124000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.124000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.124000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.124000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.124000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.128000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.128000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.128000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.128000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.128000] mmc0: starting CMD17 arg 00008c00 flags 00000035
[   19.128000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.128000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.128000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.128000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.128000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.128000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.128000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.128000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.128000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.128000] mmc0: starting CMD17 arg 00008e00 flags 00000035
[   19.128000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.128000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.128000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.128000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.128000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.128000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.128000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.128000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.128000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.128000] mmc0: starting CMD17 arg 00009000 flags 00000035
[   19.128000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.128000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.128000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.128000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.128000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.128000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.128000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.128000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.128000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.140000] mmc0: starting CMD17 arg 00009200 flags 00000035
[   19.140000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.140000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.140000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.140000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.140000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.140000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.140000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.140000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.140000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.140000] mmc0: starting CMD17 arg 00009400 flags 00000035
[   19.140000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.140000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.140000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.140000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.140000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.140000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.140000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.140000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.140000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.140000] mmc0: starting CMD17 arg 00009600 flags 00000035
[   19.140000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.140000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.140000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.140000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.140000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.140000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.140000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.140000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.140000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.140000] mmc0: starting CMD17 arg 00009800 flags 00000035
[   19.140000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.140000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.140000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.140000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.140000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.140000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.140000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.140000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.140000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.140000] mmc0: starting CMD17 arg 00009a00 flags 00000035
[   19.140000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.140000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.140000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.140000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.140000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.140000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.140000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.140000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.140000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.140000] mmc0: starting CMD17 arg 00009c00 flags 00000035
[   19.140000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.140000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.140000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.140000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.140000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.140000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.140000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.140000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.140000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.140000] mmc0: starting CMD17 arg 00009e00 flags 00000035
[   19.140000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.140000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.140000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.140000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.140000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.144000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.144000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.144000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.144000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.144000] mmc0: starting CMD17 arg 0000a000 flags 00000035
[   19.144000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.144000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.144000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.144000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.144000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.144000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.144000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.144000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.144000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.144000] mmc0: starting CMD17 arg 0000a200 flags 00000035
[   19.144000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.144000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.144000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.144000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.144000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.144000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.144000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.144000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.144000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.144000] mmc0: starting CMD17 arg 0000a400 flags 00000035
[   19.144000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.144000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.144000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.144000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.144000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.144000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.144000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.144000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.144000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.144000] mmc0: starting CMD17 arg 0000a600 flags 00000035
[   19.144000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.144000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.144000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.144000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.144000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.144000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.144000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.144000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.144000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.144000] mmc0: starting CMD17 arg 0000a800 flags 00000035
[   19.144000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.144000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.144000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.144000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.144000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.144000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.144000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.144000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.144000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.144000] mmc0: starting CMD17 arg 0000aa00 flags 00000035
[   19.144000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.144000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.144000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.144000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.144000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.144000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.144000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.144000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.144000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.144000] mmc0: starting CMD17 arg 0000ac00 flags 00000035
[   19.144000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.144000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.144000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.144000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.144000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.148000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.148000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.148000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.148000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.148000] mmc0: starting CMD17 arg 0000ae00 flags 00000035
[   19.148000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.148000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.148000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.148000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.148000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.148000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.148000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.148000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.148000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.148000] mmc0: starting CMD17 arg 0000b000 flags 00000035
[   19.148000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.148000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.148000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.148000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.148000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.148000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.148000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.148000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.148000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.148000] mmc0: starting CMD17 arg 0000b200 flags 00000035
[   19.148000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.148000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.148000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.148000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.148000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.148000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.148000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.148000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.148000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.148000] mmc0: starting CMD17 arg 0000b400 flags 00000035
[   19.148000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.148000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.148000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.148000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.148000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.148000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.148000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.148000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.148000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.148000] mmc0: starting CMD17 arg 0000b600 flags 00000035
[   19.148000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.148000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.148000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.148000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.148000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.148000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.148000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.148000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.148000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.148000] mmc0: starting CMD17 arg 0000b800 flags 00000035
[   19.148000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.148000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.148000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.148000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.148000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.148000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.148000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.148000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.148000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.148000] mmc0: starting CMD17 arg 0000ba00 flags 00000035
[   19.148000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.148000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.148000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.148000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.148000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.152000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.152000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.152000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.152000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.152000] mmc0: starting CMD17 arg 0000bc00 flags 00000035
[   19.152000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.152000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.152000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.152000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.152000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.152000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.152000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.152000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.152000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.152000] mmc0: starting CMD17 arg 0000be00 flags 00000035
[   19.152000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.152000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.152000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.152000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.152000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.152000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.152000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.152000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.152000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.152000] mmc0: starting CMD17 arg 0000c000 flags 00000035
[   19.152000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.152000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.152000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.152000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.152000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.152000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.152000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.152000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.152000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.152000] mmc0: starting CMD17 arg 0000c200 flags 00000035
[   19.152000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.152000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.152000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.152000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.152000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.152000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.152000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.152000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.152000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.152000] mmc0: starting CMD17 arg 0000c400 flags 00000035
[   19.152000] sdhci [sdhci_send_command()]: Sending cmd (11)
[   19.152000] sdhci [sdhci_prepare_data()]: blksz 0200 blks 0001 flags 
00000200
[   19.152000] sdhci [sdhci_prepare_data()]: tsac 50 ms nsac 10000 clk
[   19.152000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000001
[   19.152000] sdhci [sdhci_finish_command()]: Ending cmd (11)
[   19.152000] sdhci [sdhci_irq()]: *** sdhci:slot0 got interrupt: 
0x00000002
[   19.152000] sdhci [sdhci_finish_data()]: Ending data transfer (512 bytes)
[   19.152000] sdhci [sdhci_tasklet_finish()]: Ending request, cmd (11)
[   19.152000] mmc0: req done (CMD17): 0/0/0: 00000900 00000000 00000000 
00000000
[   19.352000] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, 
low) -> IRQ 23
[   19.352000] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   19.392000] Synaptics Touchpad, model: 1, fw: 5.10, id: 0x258eb1, 
caps: 0xa04713/0x0

