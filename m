Return-Path: <linux-kernel-owner+w=401wt.eu-S1757165Ab0ANXUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab0ANXUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:20:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756977Ab0ANXUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:20:44 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:30259 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931Ab0ANXUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:20:42 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=MBZYQ9x+QlOPfBBYL4DPwQ==:17 a=9C_dstAvG6lOyf-IIWcA:9
 a=HFOn4NRNrj1_0Y3qWiSKtvwaCiIA:4 a=pNev89yVH18O0Cki1MwA:9
 a=nHJOg7JHF4tUtB2T5H1UHSfO7UQA:4 a=FP58Ms26AAAA:8 a=rrt64fB9aDB9m4hIvhkA:9
 a=znmId8EvnRbj_NXfvXoA:7 a=UWRVwyGC9DqSMfoI9cW0bEncqLQA:4
 a=9Iz2j-YWILbCbrEE:21 a=J337vBeBILcuyjgq:21 a=SiL-sS5O4X3i7fceYXcA:9
 a=M2-efOPYjMirc8IwTbmVfaoVyJcA:4 a=45Ci3ivaxP3_hpK8DyAA:9
 a=QLEleuUjhaELJF0kKwe-3agZxegA:4
Date: Thu, 14 Jan 2010 17:20:38 -0600
From: Neil Schemenauer <nas@arctrix.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>
Subject: ATA error with Asus A7VX board
Message-ID: <20100114232037.GA17411@arctrix.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
X-PGP-Fingerprint: 9B3B 987B F40E 9320 0619  0A17 A366 302E B1DE 86CE
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I have what seems to be a poorly designed board (based on the number
of problems that a Google search turns up). However, since I guess
there are still people that have it and I have some capability to do
some debugging I thought I should try to fix it rather than throwing
it out.

It is possible that my problem is caused by a bad cable, bad memory,
or a bad drive, but I suspect the board is just temperamental
(specifically, the way interrupts are handled). The drive had a lot
of bad sectors a while ago but writing over them seemed to have
fixed it. The drive was working without errors with another board
for a while now.

I've tried booting with and without the "noapic" command line option
and with the old ide driver and the pata_via driver. Each
configuration seems to have its own problems. Certain configurations
generated errors like "IRQ nobody cared" and "spurious interrupt".
The noapic and ide driver combination results in the following error:

[  366.463909] spurious 8259A interrupt: IRQ7.
[ 5432.078546] hda: task_no_data_intr: status=0x30 { DeviceFault SeekComplete }
[ 5432.078555] hda: possibly failed opcode: 0xb0
[ 5462.224012] hda: lost interrupt

The "noapic" and pata_via is what I'm running now. It works for a
while and then I get an error like the following:

ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata4.00: BMDMA stat 0x65
ata4.00: failed command: READ DMA
ata4.00: cmd c8/00:18:4f:27:1b/00:00:00:00:00/e0 tag 0 dma 12288 in
         res 51/10:18:4f:27:1b/00:00:00:00:00/a0 Emask 0x81 (invalid argument)
ata4.00: status: { DRDY ERR }
ata4.00: error: { IDNF }
ata4.00: configured for UDMA/100
ata4.01: configured for UDMA/100
sd 3:0:0:0: [sda] Result: hostbyte=0x00 driverbyte=0x08
sd 3:0:0:0: [sda] Sense Key : 0xb [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 0b 14 00 00 00 00 0c 00 0a 80 00 00 00 00 00 
        00 1b 27 4f 
sd 3:0:0:0: [sda] ASC=0x14 ASCQ=0x0
sd 3:0:0:0: [sda] CDB: cdb[0]=0x28: 28 00 00 1b 27 4f 00 00 18 00
end_request: I/O error, dev sda, sector 1779535
ata4: EH complete

I'm attaching the kernel log for the pata_via and ide setups and the
output from lspci.

Best regards,

  Neil

--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="lspci-v.txt"

00:00.0 Host bridge: VIA Technologies, Inc. VT8377 [KT400/KT600 AGP] Host Bridge
	Subsystem: ASUSTeK Computer Inc. A7V8X motherboard
	Flags: bus master, 66MHz, medium devsel, latency 0
	Memory at f8000000 (32-bit, prefetchable) [size=64M]
	Capabilities: [a0] AGP version 2.0
	Capabilities: [c0] Power Management version 2

00:01.0 PCI bridge: VIA Technologies, Inc. VT8235 PCI Bridge (prog-if 00 [Normal decode])
	Flags: bus master, 66MHz, medium devsel, latency 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: e7800000-e7ffffff
	Prefetchable memory behind bridge: eff00000-f7ffffff
	Capabilities: [80] Power Management version 2

00:07.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host Controller (rev 46) (prog-if 10 [OHCI])
	Subsystem: VIA Technologies, Inc. IEEE 1394 Host Controller
	Flags: bus master, stepping, medium devsel, latency 32, IRQ 10
	Memory at e7000000 (32-bit, non-prefetchable) [size=2K]
	I/O ports at b800 [size=128]
	Capabilities: [50] Power Management version 2

00:08.0 RAID bus controller: Promise Technology, Inc. PDC20376 (FastTrak 376) (rev 02)
	Subsystem: ASUSTeK Computer Inc. A7V8X motherboard
	Flags: bus master, 66MHz, medium devsel, latency 96, IRQ 10
	I/O ports at b400 [size=64]
	I/O ports at b000 [size=16]
	I/O ports at a800 [size=128]
	Memory at e6800000 (32-bit, non-prefetchable) [size=4K]
	Memory at e6000000 (32-bit, non-prefetchable) [size=128K]
	Capabilities: [60] Power Management version 2

00:09.0 Ethernet controller: Broadcom Corporation BCM4401 100Base-T (rev 01)
	Subsystem: ASUSTeK Computer Inc. A7V8X motherboard
	Flags: bus master, fast devsel, latency 32, IRQ 12
	Memory at e5800000 (32-bit, non-prefetchable) [size=8K]
	Expansion ROM at efef0000 [disabled] [size=16K]
	Capabilities: [40] Power Management version 2

00:0b.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100] (rev 05)
	Subsystem: Intel Corporation Unknown device 0009
	Flags: bus master, medium devsel, latency 32, IRQ 4
	Memory at ef000000 (32-bit, prefetchable) [size=4K]
	I/O ports at a400 [size=32]
	Memory at e5000000 (32-bit, non-prefetchable) [size=1M]
	[virtual] Expansion ROM at 40000000 [disabled] [size=1M]
	Capabilities: [dc] Power Management version 1

00:0e.0 Multimedia video controller: Internext Compression Inc iTVC16 (CX23416) MPEG-2 Encoder (rev 01)
	Subsystem: Hauppauge computer works Inc. WinTV PVR 250
	Flags: bus master, medium devsel, latency 64, IRQ 10
	Memory at e8000000 (32-bit, prefetchable) [size=64M]
	Capabilities: [44] Power Management version 2

00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. VT6202 USB2.0 4 port controller
	Flags: bus master, medium devsel, latency 32, IRQ 3
	I/O ports at a000 [size=32]
	Capabilities: [80] Power Management version 2

00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. VT6202 USB2.0 4 port controller
	Flags: bus master, medium devsel, latency 32, IRQ 3
	I/O ports at 9800 [size=32]
	Capabilities: [80] Power Management version 2

00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. VT6202 USB2.0 4 port controller
	Flags: bus master, medium devsel, latency 32, IRQ 3
	I/O ports at 9400 [size=32]
	Capabilities: [80] Power Management version 2

00:10.3 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 82) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. A7V8X motherboard
	Flags: bus master, medium devsel, latency 32, IRQ 3
	Memory at e4800000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [80] Power Management version 2

00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge
	Subsystem: ASUSTeK Computer Inc. A7V8X motherboard
	Flags: bus master, stepping, medium devsel, latency 0
	Capabilities: [c0] Power Management version 2

00:11.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06) (prog-if 8a [Master SecP PriP])
	Subsystem: ASUSTeK Computer Inc. A7V8X / A7V333 motherboard
	Flags: bus master, medium devsel, latency 32, IRQ 255
	[virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	[virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	[virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	[virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	I/O ports at 9000 [size=16]
	Capabilities: [c0] Power Management version 2

00:11.5 Multimedia audio controller: VIA Technologies, Inc. VT8233/A/8235/8237 AC97 Audio Controller (rev 50)
	Subsystem: ASUSTeK Computer Inc. A7V8X Motherboard (Realtek ALC650 codec)
	Flags: medium devsel, IRQ 7
	I/O ports at e000 [size=256]
	Capabilities: [c0] Power Management version 2

01:00.0 VGA compatible controller: ATI Technologies Inc Radeon RV200 QW [Radeon 7500] (prog-if 00 [VGA])
	Subsystem: ATI Technologies Inc Radeon 7500
	Flags: bus master, stepping, 66MHz, medium devsel, latency 64, IRQ 11
	Memory at f0000000 (32-bit, prefetchable) [size=128M]
	I/O ports at d800 [size=256]
	Memory at e7800000 (32-bit, non-prefetchable) [size=64K]
	Expansion ROM at effe0000 [disabled] [size=128K]
	Capabilities: [58] AGP version 2.0
	Capabilities: [50] Power Management version 2


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="smartctl.txt"

smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.7 and 7200.7 Plus family
Device Model:     ST3200822A
Serial Number:    3LJ1SWF5
Firmware Version: 3.01
User Capacity:    200,049,647,616 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   6
ATA Standard is:  ATA/ATAPI-6 T13 1410D revision 2
Local Time is:    Thu Jan 14 17:08:55 2010 CST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)	Offline data collection activity
					was completed without error.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (  37)	The self-test routine was interrupted
					by the host with a hard or soft reset.
Total time to complete Offline 
data collection: 		 ( 430) seconds.
Offline data collection
capabilities: 			 (0x5b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					No Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					No General Purpose Logging support.
Short self-test routine 
recommended polling time: 	 (   1) minutes.
Extended self-test routine
recommended polling time: 	 ( 111) minutes.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   056   045   006    Pre-fail  Always       -       169686569
  3 Spin_Up_Time            0x0003   097   096   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       267
  5 Reallocated_Sector_Ct   0x0033   099   099   036    Pre-fail  Always       -       42
  7 Seek_Error_Rate         0x000f   082   061   030    Pre-fail  Always       -       193571553
  9 Power_On_Hours          0x0032   083   083   000    Old_age   Always       -       15179
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       203
194 Temperature_Celsius     0x0022   038   046   000    Old_age   Always       -       38
195 Hardware_ECC_Recovered  0x001a   056   044   000    Old_age   Always       -       169686569
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   189   000    Old_age   Always       -       11
200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age   Offline      -       0
202 TA_Increase_Count       0x0032   100   253   000    Old_age   Always       -       0

SMART Error Log Version: 1
ATA Error Count: 12042 (device log contains only the most recent five errors)
	CR = Command Register [HEX]
	FR = Features Register [HEX]
	SC = Sector Count Register [HEX]
	SN = Sector Number Register [HEX]
	CL = Cylinder Low Register [HEX]
	CH = Cylinder High Register [HEX]
	DH = Device/Head Register [HEX]
	DC = Device Command Register [HEX]
	ER = Error register [HEX]
	ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 12042 occurred at disk power-on lifetime: 14108 hours (587 days + 20 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 08 4f 04 2b e0  Error: UNC 8 sectors at LBA = 0x002b044f = 2819151

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 00 08 4f 04 2b e0 00      08:10:32.287  READ DMA
  27 00 00 00 00 00 e0 00      08:10:28.361  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 02      08:10:28.353  IDENTIFY DEVICE
  ef 03 44 00 00 00 a0 02      08:10:28.334  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00      08:10:28.331  READ NATIVE MAX ADDRESS EXT

Error 12041 occurred at disk power-on lifetime: 14108 hours (587 days + 20 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 08 4f 04 2b e0  Error: UNC 8 sectors at LBA = 0x002b044f = 2819151

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 00 08 4f 04 2b e0 00      08:10:20.345  READ DMA
  27 00 00 00 00 00 e0 00      08:10:28.361  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 02      08:10:28.353  IDENTIFY DEVICE
  ef 03 44 00 00 00 a0 02      08:10:28.334  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00      08:10:28.331  READ NATIVE MAX ADDRESS EXT

Error 12040 occurred at disk power-on lifetime: 14108 hours (587 days + 20 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 08 4f 04 2b e0  Error: UNC 8 sectors at LBA = 0x002b044f = 2819151

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 00 08 4f 04 2b e0 00      08:10:20.345  READ DMA
  27 00 00 00 00 00 e0 00      08:10:20.343  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 02      08:10:20.342  IDENTIFY DEVICE
  ef 03 44 00 00 00 a0 02      08:10:20.323  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00      08:10:16.443  READ NATIVE MAX ADDRESS EXT

Error 12039 occurred at disk power-on lifetime: 14108 hours (587 days + 20 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 08 4f 04 2b e0  Error: UNC 8 sectors at LBA = 0x002b044f = 2819151

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 00 08 4f 04 2b e0 00      08:10:20.345  READ DMA
  27 00 00 00 00 00 e0 00      08:10:20.343  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 02      08:10:20.342  IDENTIFY DEVICE
  ef 03 44 00 00 00 a0 02      08:10:20.323  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00      08:10:16.443  READ NATIVE MAX ADDRESS EXT

Error 12038 occurred at disk power-on lifetime: 14108 hours (587 days + 20 hours)
  When the command that caused the error occurred, the device was active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 08 4f 04 2b e0  Error: UNC 8 sectors at LBA = 0x002b044f = 2819151

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  c8 00 08 4f 04 2b e0 00      08:10:12.412  READ DMA
  27 00 00 00 00 00 e0 00      08:10:12.408  READ NATIVE MAX ADDRESS EXT
  ec 00 00 00 00 00 a0 02      08:10:12.400  IDENTIFY DEVICE
  ef 03 44 00 00 00 a0 02      08:10:12.381  SET FEATURES [Set transfer mode]
  27 00 00 00 00 00 e0 00      08:10:16.443  READ NATIVE MAX ADDRESS EXT

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short captive       Interrupted (host reset)      50%     14108         -
# 2  Short offline       Completed without error       00%     14108         -
# 3  Short offline       Completed: read failure       90%     14108         2819151
# 4  Extended offline    Interrupted (host reset)      60%     14027         -
# 5  Short offline       Completed without error       00%     14026         -
# 6  Extended captive    Interrupted (host reset)      90%     14026         -
# 7  Extended captive    Interrupted (host reset)      90%     14026         -
# 8  Short captive       Interrupted (host reset)      50%     14025         -
# 9  Short captive       Interrupted (host reset)      50%     14025         -
#10  Short captive       Interrupted (host reset)      50%     14025         -
#11  Extended captive    Completed: read failure       90%     14025         1907693
#12  Extended captive    Completed: read failure       90%     14025         1906646
#13  Extended captive    Completed: read failure       90%     14025         1905599
#14  Short offline       Completed without error       00%     13374         -
#15  Short offline       Completed: read failure       90%     13374         1905423
#16  Short offline       Completed without error       00%      9986         -
#17  Short offline       Completed without error       00%      4741         -
#18  Short offline       Completed without error       00%       291         -
#19  Short offline       Completed without error       00%       160         -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.


--OgqxwSJOaUobr8KG
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="kernlog-ide.txt.gz"
Content-Transfer-Encoding: base64

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

--OgqxwSJOaUobr8KG
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="kernlog-pata.txt.gz"
Content-Transfer-Encoding: base64

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

--OgqxwSJOaUobr8KG--
