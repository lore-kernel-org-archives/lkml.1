Return-Path: <linux-kernel-owner+w=401wt.eu-S1755279AbXJNH6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbXJNH6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 03:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753818AbXJNH6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 03:58:21 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:8606 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbXJNH6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 03:58:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ARf1tlPioO90zbLFJ6lzv/vkxi3EIYmGJuUrJMSMs2SFfKPvPK7YITL6ePHKWylFwFDhqfTWeIlbOL+1EVBfDB5163DHWq0GOSSH212XMx+Z7ueyA/+WNXuE4mvtzkAmzWgTFeKX1jrQvn7mnS5BfqijSpSpl0YfrMSHNkxu/hI=
Message-ID: <8e04b5820710140058o650634av4b0426c463b62cb0@mail.gmail.com>
Date: Sun, 14 Oct 2007 10:58:18 +0300
From: "Ciprian Dorin Craciun" <ciprian.craciun@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Linux v2.6.23.1 suspend/resume problem
In-Reply-To: <1192347847.289067.216320@q5g2000prf.googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192347847.289067.216320@q5g2000prf.googlegroups.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hello all!

    I have just compiled v2.6.23.1 kernel yesterday and started using
it. But it seems there are some issues with the suspend/resume... Whet
my laptop resumes it takes a lot of time, about half a minute to
resume. I watched the timings in the dmesg output and it seems it
hands either at the souncard setup or the SATA controller. (I'm not an
expert, I just guessed that based on dmesg, so I might be wrong...)

    I must add that I haven't encountered this problem with any of the
previous stable kernels. The last one I have used was v2.6.22.9. And
the difference of the two configs is not essential.

    I'll describe my setup:
    -- IBM ThinkPad T43
    -- Debian Etch
    -- lspci output:

00:00.0 Host bridge:
    Intel Corporation Mobile 915GM/PM/GMS/910GML Express Processor to
DRAM Controller (rev 03)
00:02.0 VGA compatible controller:
    Intel Corporation Mobile 915GM/GMS/910GML Express Graphics
Controller (rev 03)
00:02.1 Display controller:
    Intel Corporation Mobile 915GM/GMS/910GML Express Graphics
Controller (rev 03)
00:1c.0 PCI bridge:
    Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI Express
Port 1 (rev 03)
00:1c.2 PCI bridge:
    Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI Express
Port 3 (rev 03)
00:1d.0 USB Controller:
    Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #1
(rev 03)
00:1d.1 USB Controller:
    Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #2
(rev 03)
00:1d.2 USB Controller:
    Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #3
(rev 03)
00:1d.3 USB Controller:
    Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB UHCI #4
(rev 03)
00:1d.7 USB Controller:
    Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB2 EHCI
Controller (rev 03)
00:1e.0 PCI bridge:
    Intel Corporation 82801 Mobile PCI Bridge (rev d3)
00:1e.2 Multimedia audio controller:
    Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) AC'97 Audio
Controller (rev 03)
00:1f.0 ISA bridge:
    Intel Corporation 82801FBM (ICH6M) LPC Interface Bridge (rev 03)
00:1f.2 IDE interface:
    Intel Corporation 82801FBM (ICH6M) SATA Controller (rev 03)
00:1f.3 SMBus:
    Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) SMBus
Controller (rev 03)
02:00.0 Ethernet controller:
    Broadcom Corporation NetXtreme BCM5751M Gigabit Ethernet PCI
Express (rev 11)
04:00.0 CardBus bridge:
    Texas Instruments PCI1510 PC card Cardbus Controller
04:02.0 Network controller:
    Intel Corporation PRO/Wireless 2200BG Network Connection (rev 05)

    -- dmesg output (just before the suspend and after resume)

[   87.811745] Stopping tasks ... done.
[   87.895752] Suspending console(s)
[   88.150565] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   88.150669] sd 0:0:0:0: [sda] Stopping disk
[   88.580745] eth1: Going into suspend...
[   88.581629] ACPI: PCI interrupt for device 0000:04:02.0 disabled
[   88.581638] ACPI handle has no context!
[  119.704434] ACPI: PCI interrupt for device 0000:00:1e.2 disabled
[  119.704550] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
[  119.707120] ACPI: PCI interrupt for device 0000:00:1d.3 disabled
[  119.707152] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
[  119.707183] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
[  119.707213] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
[    0.230501] Intel machine check architecture supported.
[    0.230517] Intel machine check reporting enabled on CPU#0.
[    0.230535] Back to C!
[    0.259350] PM: Writing back config space on device 0000:00:02.1 at
offset 4 (was 0, writing 50000000)
[    0.259477] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 20 (level,
low) -> IRQ 16
[    0.259486] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.259574] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 22 (level,
low) -> IRQ 17
[    0.259582] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.259630] PCI: Enabling device 0000:00:1d.0 (0000 -> 0001)
[    0.259636] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level,
low) -> IRQ 18
[    0.259664] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[    0.259672] PM: Writing back config space on device 0000:00:1d.0 at
offset f (was 100, writing 10b)
[    0.259686] PM: Writing back config space on device 0000:00:1d.0 at
offset 8 (was 1, writing 1821)
[    0.259721] usb usb2: root hub lost power or was reset
[    0.259752] PCI: Enabling device 0000:00:1d.1 (0000 -> 0001)
[    0.259757] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level,
low) -> IRQ 21
[    0.259784] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[    0.259792] PM: Writing back config space on device 0000:00:1d.1 at
offset f (was 200, writing 20b)
[    0.259807] PM: Writing back config space on device 0000:00:1d.1 at
offset 8 (was 1, writing 1841)
[    0.259841] usb usb3: root hub lost power or was reset
[    0.260146] PCI: Enabling device 0000:00:1d.2 (0000 -> 0001)
[    0.260172] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level,
low) -> IRQ 22
[    0.260181] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[    0.260189] PM: Writing back config space on device 0000:00:1d.2 at
offset f (was 300, writing 30b)
[    0.260204] PM: Writing back config space on device 0000:00:1d.2 at
offset 8 (was 1, writing 1861)
[    0.260239] usb usb4: root hub lost power or was reset
[    0.260269] PCI: Enabling device 0000:00:1d.3 (0000 -> 0001)
[    0.260274] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level,
low) -> IRQ 20
[    0.260283] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[    0.260309] PM: Writing back config space on device 0000:00:1d.3 at
offset f (was 400, writing 40b)
[    0.260323] PM: Writing back config space on device 0000:00:1d.3 at
offset 8 (was 1, writing 1881)
[    0.260358] usb usb5: root hub lost power or was reset
[    0.275205] PCI: Enabling device 0000:00:1d.7 (0000 -> 0002)
[    0.275211] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level,
low) -> IRQ 20
[    0.275221] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[    0.275235] PM: Writing back config space on device 0000:00:1d.7 at
offset f (was 400, writing 40b)
[    0.275255] PM: Writing back config space on device 0000:00:1d.7 at
offset 4 (was 0, writing 90040000)
[    0.275265] PM: Writing back config space on device 0000:00:1d.7 at
offset 1 (was 2900006, writing 2900106)
[    0.275339] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.275371] PM: Writing back config space on device 0000:00:1e.2 at
offset 1 (was 2900007, writing 2900003)
[    0.275389] ACPI: PCI Interrupt 0000:00:1e.2[A] -> GSI 22 (level,
low) -> IRQ 17
[    0.275398] PCI: Setting latency timer of device 0000:00:1e.2 to 64
[   18.437412] PM: Writing back config space on device 0000:00:1f.2 at
offset 1 (was 2b00005, writing 2b80005)
[   18.437434] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[   18.437710] PM: Writing back config space on device 0000:02:00.0 at
offset 1 (was 100102, writing 100106)
[   18.437748] PM: Writing back config space on device 0000:04:00.0 at
offset f (was 34001ff, writing 3c0010b)
[   18.437757] PM: Writing back config space on device 0000:04:00.0 at
offset e (was 0, writing 34fc)
[   18.437765] PM: Writing back config space on device 0000:04:00.0 at
offset d (was 0, writing 3400)
[   18.437774] PM: Writing back config space on device 0000:04:00.0 at
offset c (was 0, writing 30fc)
[   18.437782] PM: Writing back config space on device 0000:04:00.0 at
offset b (was 0, writing 3000)
[   18.437791] PM: Writing back config space on device 0000:04:00.0 at
offset a (was 0, writing 97fff000)
[   18.437799] PM: Writing back config space on device 0000:04:00.0 at
offset 9 (was 0, writing 94000000)
[   18.437808] PM: Writing back config space on device 0000:04:00.0 at
offset 8 (was 0, writing cbfff000)
[   18.437816] PM: Writing back config space on device 0000:04:00.0 at
offset 7 (was 0, writing c8000000)
[   18.437825] PM: Writing back config space on device 0000:04:00.0 at
offset 6 (was 0, writing b0060504)
[   18.437835] PM: Writing back config space on device 0000:04:00.0 at
offset 4 (was 0, writing 90300000)
[   18.437844] PM: Writing back config space on device 0000:04:00.0 at
offset 3 (was 20000, writing 24008)
[   18.437855] PM: Writing back config space on device 0000:04:00.0 at
offset 1 (was 2100000, writing 2100107)
[   18.437886] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 16 (level,
low) -> IRQ 18
[   18.437896] eth1: Coming out of suspend...
[   18.438705] ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 21 (level,
low) -> IRQ 19
[   18.568570] sd 0:0:0:0: [sda] Starting disk
[   18.605784] ata1.00: configured for UDMA/100
[   18.803874] ata2.00: configured for UDMA/33
[   18.951220] sd 0:0:0:0: [sda] 78140160 512-byte hardware sectors
(40008 MB)
[   18.951243] sd 0:0:0:0: [sda] Write Protect is off
[   18.951248] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   18.951276] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   23.622002] hdaps: initial latch check good (0x02).
[   24.649776] Restarting tasks ... <3>hub 1-0:1.0: over-current
change on port 3
[   24.664264] done.
[   24.751959] hub 1-0:1.0: over-current change on port 4
[   24.928575] hub 3-0:1.0: over-current change on port 1
[   25.055580] hub 3-0:1.0: over-current change on port 2

    As you can see the problem is at the lines:
[    0.275398] PCI: Setting latency timer of device 0000:00:1e.2 to 64
[   18.437412] PM: Writing back config space on device 0000:00:1f.2 at
offset 1 (was 2b00005, writing 2b80005)

    And those PCI's corespond to:
00:1e.2 Multimedia audio controller:
    Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) AC'97 Audio
Controller (rev 03)
00:1f.2 IDE interface:
    Intel Corporation 82801FBM (ICH6M) SATA Controller (rev 03)

    Thank you all!
    Ciprian.

    P.S.: For now I will stick with v2.6.23.1 to see if there are also
other problems. (I think there is also an issue with the mouse but I'm
not sure...)
