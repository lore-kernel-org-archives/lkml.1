Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYCPAZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYCPAZO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 20:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751872AbYCPAZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 20:25:01 -0400
Received: from main.gmane.org ([80.91.229.2]:42037 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbYCPAY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 20:24:56 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Suspend to RAM reboots on resume with S3
Date: Sun, 16 Mar 2008 00:24:40 +0000 (UTC)
Message-ID: <frhpc6$99f$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc3-cwma2-0-0-cust739.swan.cable.ntl.com
User-Agent: Pan/0.129 (Benson & Hedges Moscow Gold)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have a desktop on which suspend to RAM has always fails to resume when 
the BIOS is set to use S3 - when attempting to resume the video BIOS 
posts itself, warms the monitor up, powersaves it, posts itself again and 
goes to the regular BIOS post indicating a reboot. Hibernation started 
working many kernels ago. Windows 98 seems able to do suspend to RAM on 
S3 and Linux will suspend to RAM if S1 is set in the BIOS. The latest 
test was done with 2.6.25-rc5 (git tree pulled this morning) and the 
result is the same in kernels going back to 2.6.17 . Using pm_trace gives 
a magic number that doesn't match anything:
[    2.466686] Using IPI Shortcut mode
[    2.467205]   Magic number: 0:691:51
[    2.468707] Freeing unused kernel memory: 320k freed

(Originally filed on 
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/86099 ).

dmidecode and acpidump output are included below.

dmidecode:
# dmidecode 2.9
SMBIOS 2.3 present.
28 structures occupying 951 bytes.
Table at 0x000F05F0.

Handle 0x0000, DMI type 0, 20 bytes
BIOS Information
	Vendor: American Megatrends Inc.
	Version: 62710
	Release Date: 10/16/2001
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 256 kB
	Characteristics:
		ISA is supported
		PCI is supported
		PNP is supported
		APM is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		ESCD support is available
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		5.25"/360 KB floppy services are supported (int 13h)
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 KB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		AGP is supported
		LS-120 boot is supported
		ATAPI Zip drive boot is supported
		BIOS boot specification is supported

Handle 0x0001, DMI type 1, 25 bytes
System Information
	Manufacturer: SNC302EEH                       
	Product Name: SNC302EEH                       
	Version:        
	Serial Number:  
	UUID: Not Present
	Wake-up Type: Power Switch

Handle 0x0002, DMI type 2, 8 bytes
Base Board Information
	Manufacturer:                             
	Product Name: 7ZM
	Version:    
	Serial Number:  

Handle 0x0003, DMI type 3, 17 bytes
Chassis Information
	Manufacturer:                                 
	Type: Desktop
	Lock: Not Present
	Version: SNC302EEH                       
	Serial Number:  
	Asset Tag:  
	Boot-up State: Unknown
	Power Supply State: Unknown
	Thermal State: Unknown
	Security Status: Unknown
	OEM Information: 0x00000000

Handle 0x0004, DMI type 4, 32 bytes
Processor Information
	Socket Designation: Socket-A
	Type: Central Processor
	Family: K6
	Manufacturer: AMD                             
	ID: 42 06 00 00 55 00 00 00
	Signature: Family 6, Model 4, Stepping 2
	Flags:
		FPU (Floating-point unit on-chip)
		DE (Debugging extension)
		TSC (Time stamp counter)
		PAE (Physical address extension)
	Version: Athlon(tm)                      
	Voltage: 1.6 V
	External Clock: 100 MHz
	Max Speed: 1400 MHz
	Current Speed: 850 MHz
	Status: Populated, Enabled
	Upgrade: Slot 1
	L1 Cache Handle: 0x0005
	L2 Cache Handle: 0x0006
	L3 Cache Handle: Not Provided

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1 Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 128 KB
	Maximum Size: 1024 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: None
	System Type: Unified
	Associativity: 4-way Set-associative

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2 Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 256 KB
	Maximum Size: 8192 KB
	Supported SRAM Types:
		Synchronous
	Installed SRAM Type: Synchronous
	Speed: Unknown
	Error Correction Type: None
	System Type: Unified
	Associativity: 4-way Set-associative

Handle 0x0007, DMI type 5, 22 bytes
Memory Controller Information
	Error Detecting Method: None
	Error Correcting Capabilities: None
	Supported Interleave: Four-way Interleave
	Current Interleave: Four-way Interleave
	Maximum Memory Module Size: 512 MB
	Maximum Total Memory Size: 1536 MB
	Supported Speeds:
		Unknown
	Supported Memory Types:
		Parity
		DIMM
		SDRAM
	Memory Module Voltage: 3.3 V
	Associated Memory Slots: 3
		0x0008
		0x0009
		0x000A
	Enabled Error Correcting Capabilities:
		None

Handle 0x0008, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM1
	Bank Connections: 0 1
	Current Speed: Unknown
	Type: DIMM SDRAM
	Installed Size: 256 MB (Double-bank Connection)
	Enabled Size: 256 MB (Double-bank Connection)
	Error Status: OK

Handle 0x0009, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM2
	Bank Connections: 2 3
	Current Speed: Unknown
	Type: DIMM SDRAM
	Installed Size: 256 MB (Double-bank Connection)
	Enabled Size: 256 MB (Double-bank Connection)
	Error Status: OK

Handle 0x000A, DMI type 6, 12 bytes
Memory Module Information
	Socket Designation: DIMM3
	Bank Connections: 4 5
	Current Speed: Unknown
	Type: DIMM SDRAM
	Installed Size: 128 MB (Double-bank Connection)
	Enabled Size: 128 MB (Double-bank Connection)
	Error Status: OK

Handle 0x000B, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI1
	Type: 32-bit PCI
	Current Usage: Available
	Length: Long
	ID: 1
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x000C, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI2
	Type: 32-bit PCI
	Current Usage: In Use
	Length: Long
	ID: 2
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x000D, DMI type 9, 13 bytes
System Slot Information
	Designation: PCI3
	Type: 32-bit PCI
	Current Usage: In Use
	Length: Long
	ID: 3
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x000E, DMI type 9, 13 bytes
System Slot Information
	Designation: AGP
	Type: 32-bit AGP 4x
	Current Usage: In Use
	Length: Long
	ID: 4
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x000F, DMI type 10, 6 bytes
On Board Device Information
	Type: Sound
	Status: Enabled
	Description: VIA Inc.     

Handle 0x0010, DMI type 11, 5 bytes
OEM Strings
	String 1: SMBIOS Support from AMI
	String 2: Clock Gen

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: Serial Port A
	External Connector Type: DB-9 male
	Port Type: Serial Port 16550A Compatible

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: Serial Port B
	External Connector Type: DB-9 male
	Port Type: Serial Port 16550A Compatible

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: Parallel Port
	External Connector Type: DB-25 female
	Port Type: Parallel Port ECP/EPP

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: KEYBOARD
	External Connector Type: PS/2
	Port Type: Keyboard Port

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: None
	Internal Connector Type: None
	External Reference Designator: PS/2 MOUSE
	External Connector Type: PS/2
	Port Type: Mouse Port

Handle 0x0016, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: FLOPPY
	Internal Connector Type: On Board Floppy
	External Reference Designator: None
	External Connector Type: None
	Port Type: None

Handle 0x0017, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: IDE1
	Internal Connector Type: On Board IDE
	External Reference Designator: None
	External Connector Type: None
	Port Type: None

Handle 0x0018, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: IDE2
	Internal Connector Type: On Board IDE
	External Reference Designator: None
	External Connector Type: None
	Port Type: None

Handle 0x0019, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB1
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: USB1
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x001A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB2
	Internal Connector Type: Access Bus (USB)
	External Reference Designator: USB2
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x001B, DMI type 13, 22 bytes
BIOS Language Information
	Installable Languages: 1
		enUS
	Currently Installed Language: enUS

acpidump:
DSDT @ 0x27ff00b0
  0000: 44 53 44 54 bf 29 00 00 01 6d 56 49 41 00 00 00  DSDT.)...mVIA...
  0010: 56 54 38 33 37 31 00 00 00 10 00 00 4d 53 46 54  VT8371......MSFT
  0020: 0b 00 00 01 08 41 50 49 43 0a 00 14 0c 5f 50 49  .....APIC...._PI
  0030: 43 01 70 68 41 50 49 43 10 13 5c 5f 50 52 5f 5b  C.phAPIC..\_PR_[
  0040: 83 0b 43 50 55 31 01 00 00 00 00 00 5b 80 43 53  ..CPU1......[.CS
  0050: 37 32 01 0a 72 0a 02 5b 81 10 43 53 37 32 01 43  72..r..[..CS72.C
  0060: 49 37 32 08 43 4f 37 33 08 08 5c 5f 53 30 5f 12  I72.CO73..\_S0_.
  0070: 0a 04 0a 00 0a 00 0a 00 0a 00 08 5c 53 53 31 5f  ...........\SS1_
  0080: 12 0a 04 0a 04 0a 00 0a 00 0a 00 08 5c 5f 53 33  ............\_S3
  0090: 5f 12 0a 04 0a 01 0a 00 0a 00 0a 00 08 5c 5f 53  _............\_S
  00a0: 34 5f 12 0a 04 0a 02 0a 00 0a 00 0a 00 08 5c 5f  4_............\_
  00b0: 53 35 5f 12 0a 04 0a 02 0a 00 0a 00 0a 00 08 50  S5_............P
  00c0: 54 42 46 11 06 0a 03 00 00 00 8c 50 54 42 46 0a  TBF........PTBF.
  00d0: 00 50 54 42 30 8c 50 54 42 46 0a 01 50 54 42 31  .PTB0.PTBF..PTB1
  00e0: 8c 50 54 42 46 0a 02 50 54 42 32 14 41 05 4d 43  .PTBF..PTB2.A.MC
  00f0: 54 48 02 a0 09 95 87 68 87 69 a4 0a 00 72 87 68  TH.....h.i...r.h
  0100: 0a 01 60 08 42 55 46 30 11 02 60 08 42 55 46 31  ..`.BUF0..`.BUF1
  0110: 11 02 60 70 68 42 55 46 30 70 69 42 55 46 31 a2  ..`phBUF0piBUF1.
  0120: 1b 60 76 60 a0 12 93 83 88 42 55 46 30 60 00 83  .`v`.....BUF0`..
  0130: 88 42 55 46 31 60 00 a1 03 a4 00 a4 01 10 88 24  .BUF1`.........$
  0140: 02 5c 5f 53 42 5f 5b 82 19 50 57 52 42 08 5f 48  .\_SB_[..PWRB._H
  0150: 49 44 0c 41 d0 0c 0c 14 09 5f 53 54 41 00 a4 0a  ID.A....._STA...
  0160: 0b 5b 82 80 1e 02 50 43 49 30 08 5f 48 49 44 0c  .[....PCI0._HID.
  0170: 41 d0 0a 03 08 5f 41 44 52 0a 00 08 5f 42 42 4e  A...._ADR..._BBN
  0180: 0a 00 08 5f 53 33 44 0a 02 08 43 52 53 5f 11 4c  ..._S3D...CRS_.L
  0190: 08 0a 88 88 0d 00 02 0c 00 00 00 00 00 ff 00 00  ................
  01a0: 00 00 01 47 01 f8 0c f8 0c 01 08 88 0d 00 01 0c  ...G............
  01b0: 03 00 00 00 00 f7 0c 00 00 f8 0c 88 0d 00 01 0c  ................
  01c0: 03 00 00 00 0d ff ff 00 00 00 f3 87 17 00 00 0c  ................
  01d0: 03 00 00 00 00 00 00 0a 00 ff ff 0b 00 00 00 00  ................
  01e0: 00 00 00 02 00 87 17 00 00 0c 03 00 00 00 00 00  ................
  01f0: 00 0c 00 ff ff 0d 00 00 00 00 00 00 00 02 00 87  ................
  0200: 17 00 00 0c 03 00 00 00 00 00 00 00 20 ff ff df  ............ ...
  0210: ff 00 00 00 00 00 00 e0 df 79 00 5b 80 42 53 52  .........y.[.BSR
  0220: 30 02 0a f4 0a 01 5b 81 17 42 53 52 30 01 53 50  0.....[..BSR0.SP
  0230: 4c 56 03 57 32 46 47 02 00 02 52 54 43 58 01 5b  LV.W2FG...RTCX.[
  0240: 80 54 4d 45 4d 02 0a 57 0a 01 5b 81 0b 54 4d 45  .TMEM..W..[..TME
  0250: 4d 01 4d 45 4d 54 08 08 54 4f 4d 5f 0a 00 14 2c  M.MEMT..TOM_...,
  0260: 4d 44 45 54 00 a0 05 54 4f 4d 5f a1 1a a0 10 46  MDET...TOM_....F
  0270: 4c 41 47 79 4d 45 4d 54 0a 18 54 4f 4d 5f a1 07  LAGyMEMT..TOM_..
  0280: a4 0c 00 00 00 20 a4 54 4f 4d 5f 14 11 54 46 43  ..... .TOM_..TFC
  0290: 53 00 74 4d 44 45 54 0b c0 7f 60 a4 60 08 46 4c  S.tMDET...`.`.FL
  02a0: 41 47 0a 01 08 4f 53 46 4c 0a 00 14 44 04 5f 49  AG...OSFL...D._I
  02b0: 4e 49 00 5c 2f 04 5f 53 42 5f 50 43 49 30 53 42  NI.\/._SB_PCI0SB
  02c0: 52 47 49 4f 44 54 a0 20 4d 43 54 48 5c 5f 4f 53  RGIODT. MCTH\_OS
  02d0: 5f 0d 4d 69 63 72 6f 73 6f 66 74 20 57 69 6e 64  _.Microsoft Wind
  02e0: 6f 77 73 20 4e 54 00 a1 08 70 0a 01 4f 53 46 4c  ows NT...p..OSFL
  02f0: 14 12 5f 52 45 47 02 a0 0b 93 68 0a 02 70 69 46  .._REG....h..piF
  0300: 4c 41 47 14 38 5f 43 52 53 00 8a 43 52 53 5f 0a  LAG.8_CRS..CRS_.
  0310: 76 54 4d 45 4d 8a 43 52 53 5f 0a 82 54 4c 45 4e  vTMEM.CRS_..TLEN
  0320: 70 4d 44 45 54 54 4d 45 4d 74 0c 00 00 e0 ff 54  pMDETTMEMt.....T
  0330: 4d 45 4d 54 4c 45 4e a4 43 52 53 5f 08 5f 50 52  MEMTLEN.CRS_._PR
  0340: 54 12 43 16 10 12 15 04 0c ff ff 07 00 0a 02 5c  T.C............\
  0350: 2e 5f 53 42 5f 4c 4e 4b 43 0a 00 12 15 04 0c ff  ._SB_LNKC.......
  0360: ff 07 00 0a 03 5c 2e 5f 53 42 5f 4c 4e 4b 44 0a  .....\._SB_LNKD.
  0370: 00 12 15 04 0c ff ff 09 00 0a 00 5c 2e 5f 53 42  ...........\._SB
  0380: 5f 4c 4e 4b 42 0a 00 12 15 04 0c ff ff 09 00 0a  _LNKB...........
  0390: 01 5c 2e 5f 53 42 5f 4c 4e 4b 43 0a 00 12 15 04  .\._SB_LNKC.....
  03a0: 0c ff ff 09 00 0a 02 5c 2e 5f 53 42 5f 4c 4e 4b  .......\._SB_LNK
  03b0: 44 0a 00 12 15 04 0c ff ff 09 00 0a 03 5c 2e 5f  D............\._
  03c0: 53 42 5f 4c 4e 4b 41 0a 00 12 15 04 0c ff ff 0a  SB_LNKA.........
  03d0: 00 0a 00 5c 2e 5f 53 42 5f 4c 4e 4b 43 0a 00 12  ...\._SB_LNKC...
  03e0: 15 04 0c ff ff 0a 00 0a 01 5c 2e 5f 53 42 5f 4c  .........\._SB_L
  03f0: 4e 4b 44 0a 00 12 15 04 0c ff ff 0a 00 0a 02 5c  NKD............\
  0400: 2e 5f 53 42 5f 4c 4e 4b 41 0a 00 12 15 04 0c ff  ._SB_LNKA.......
  0410: ff 0a 00 0a 03 5c 2e 5f 53 42 5f 4c 4e 4b 42 0a  .....\._SB_LNKB.
  0420: 00 12 15 04 0c ff ff 0f 00 0a 00 5c 2e 5f 53 42  ...........\._SB
  0430: 5f 4c 4e 4b 44 0a 00 12 15 04 0c ff ff 0f 00 0a  _LNKD...........
  0440: 01 5c 2e 5f 53 42 5f 4c 4e 4b 41 0a 00 12 15 04  .\._SB_LNKA.....
  0450: 0c ff ff 0f 00 0a 02 5c 2e 5f 53 42 5f 4c 4e 4b  .......\._SB_LNK
  0460: 42 0a 00 12 15 04 0c ff ff 0f 00 0a 03 5c 2e 5f  B............\._
  0470: 53 42 5f 4c 4e 4b 43 0a 00 12 15 04 0c ff ff 01  SB_LNKC.........
  0480: 00 0a 00 5c 2e 5f 53 42 5f 4c 4e 4b 41 0a 00 12  ...\._SB_LNKA...
  0490: 15 04 0c ff ff 01 00 0a 01 5c 2e 5f 53 42 5f 4c  .........\._SB_L
  04a0: 4e 4b 42 0a 00 5b 82 8e 2d 01 53 42 52 47 08 5f  NKB..[..-.SBRG._
  04b0: 41 44 52 0c 00 00 07 00 08 5c 2e 5f 53 42 5f 49  ADR......\._SB_I
  04c0: 50 52 53 11 0b 0a 08 30 23 f8 de 18 38 79 00 5b  PRS....0#...8y.[
  04d0: 80 50 49 58 30 02 0a 55 0a 04 5b 80 50 49 58 31  .PIX0..U..[.PIX1
  04e0: 02 0a 85 0a 01 5b 80 50 49 58 32 02 0a 50 0a 03  .....[.PIX2..P..
  04f0: 5b 80 50 49 58 33 02 0a 08 0a 01 10 41 33 5c 5f  [.PIX3......A3\_
  0500: 53 42 5f 5b 81 2a 2f 03 50 43 49 30 53 42 52 47  SB_[.*/.PCI0SBRG
  0510: 50 49 58 30 01 00 04 50 49 52 41 04 50 49 52 42  PIX0...PIRA.PIRB
  0520: 04 50 49 52 43 04 00 04 50 49 52 44 04 00 04 5b  .PIRC...PIRD...[
  0530: 81 1a 2f 03 50 43 49 30 53 42 52 47 50 49 58 31  ../.PCI0SBRGPIX1
  0540: 01 45 50 33 43 01 45 4e 33 43 01 5b 81 30 2f 03  .EP3C.EN3C.[.0/.
  0550: 50 43 49 30 53 42 52 47 50 49 58 32 01 46 4c 44  PCI0SBRGPIX2.FLD
  0560: 41 02 4c 50 44 41 02 00 04 46 4c 49 52 04 4c 50  A.LPDA...FLIR.LP
  0570: 49 52 04 55 31 49 52 04 55 32 49 52 04 5b 81 17  IR.U1IR.U2IR.[..
  0580: 2f 03 50 43 49 30 53 42 52 47 50 49 58 33 01 00  /.PCI0SBRGPIX3..
  0590: 06 53 42 52 56 02 08 49 52 51 41 0a 00 08 49 52  .SBRV..IRQA...IR
  05a0: 51 42 0a 00 08 49 52 51 43 0a 00 08 49 52 51 44  QB...IRQC...IRQD
  05b0: 0a 00 08 49 43 52 53 11 09 0a 06 23 00 80 18 79  ...ICRS....#...y
  05c0: 00 5b 82 49 09 4c 4e 4b 41 08 5f 48 49 44 0c 41  .[.I.LNKA._HID.A
  05d0: d0 0c 0f 08 5f 55 49 44 0a 01 14 1d 5f 53 54 41  ...._UID...._STA
  05e0: 00 70 50 49 52 41 49 52 51 41 a0 08 50 49 52 41  .pPIRAIRQA..PIRA
  05f0: a4 0a 0b a1 04 a4 0a 09 14 0b 5f 50 52 53 00 a4  .........._PRS..
  0600: 49 50 52 53 14 0d 5f 44 49 53 00 70 0a 00 50 49  IPRS.._DIS.p..PI
  0610: 52 41 14 23 5f 43 52 53 00 8b 49 43 52 53 0a 01  RA.#_CRS..ICRS..
  0620: 49 52 41 30 70 01 61 79 61 49 52 51 41 49 52 41  IRA0p.ayaIRQAIRA
  0630: 30 a4 49 43 52 53 14 25 5f 53 52 53 01 8b 68 0a  0.ICRS.%_SRS..h.
  0640: 01 49 52 41 5f 82 49 52 41 5f 60 76 60 70 60 50  .IRA_.IRA_`v`p`P
  0650: 49 52 41 70 50 49 52 41 49 52 51 41 5b 82 49 09  IRApPIRAIRQA[.I.
  0660: 4c 4e 4b 42 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f  LNKB._HID.A...._
  0670: 55 49 44 0a 02 14 1d 5f 53 54 41 00 70 50 49 52  UID...._STA.pPIR
  0680: 42 49 52 51 42 a0 08 50 49 52 42 a4 0a 0b a1 04  BIRQB..PIRB.....
  0690: a4 0a 09 14 0b 5f 50 52 53 00 a4 49 50 52 53 14  ....._PRS..IPRS.
  06a0: 0d 5f 44 49 53 00 70 0a 00 50 49 52 42 14 23 5f  ._DIS.p..PIRB.#_
  06b0: 43 52 53 00 8b 49 43 52 53 0a 01 49 52 41 30 70  CRS..ICRS..IRA0p
  06c0: 01 61 79 61 49 52 51 42 49 52 41 30 a4 49 43 52  .ayaIRQBIRA0.ICR
  06d0: 53 14 25 5f 53 52 53 01 8b 68 0a 01 49 52 41 5f  S.%_SRS..h..IRA_
  06e0: 82 49 52 41 5f 60 76 60 70 60 50 49 52 42 70 50  .IRA_`v`p`PIRBpP
  06f0: 49 52 42 49 52 51 42 5b 82 49 09 4c 4e 4b 43 08  IRBIRQB[.I.LNKC.
  0700: 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 03  _HID.A...._UID..
  0710: 14 1d 5f 53 54 41 00 70 50 49 52 43 49 52 51 43  .._STA.pPIRCIRQC
  0720: a0 08 50 49 52 43 a4 0a 0b a1 04 a4 0a 09 14 0b  ..PIRC..........
  0730: 5f 50 52 53 00 a4 49 50 52 53 14 0d 5f 44 49 53  _PRS..IPRS.._DIS
  0740: 00 70 0a 00 50 49 52 43 14 23 5f 43 52 53 00 8b  .p..PIRC.#_CRS..
  0750: 49 43 52 53 0a 01 49 52 41 30 70 01 61 79 61 49  ICRS..IRA0p.ayaI
  0760: 52 51 43 49 52 41 30 a4 49 43 52 53 14 25 5f 53  RQCIRA0.ICRS.%_S
  0770: 52 53 01 8b 68 0a 01 49 52 41 5f 82 49 52 41 5f  RS..h..IRA_.IRA_
  0780: 60 76 60 70 60 50 49 52 43 70 50 49 52 43 49 52  `v`p`PIRCpPIRCIR
  0790: 51 43 5b 82 49 09 4c 4e 4b 44 08 5f 48 49 44 0c  QC[.I.LNKD._HID.
  07a0: 41 d0 0c 0f 08 5f 55 49 44 0a 04 14 1d 5f 53 54  A...._UID...._ST
  07b0: 41 00 70 50 49 52 44 49 52 51 44 a0 08 50 49 52  A.pPIRDIRQD..PIR
  07c0: 44 a4 0a 0b a1 04 a4 0a 09 14 0b 5f 50 52 53 00  D.........._PRS.
  07d0: a4 49 50 52 53 14 0d 5f 44 49 53 00 70 0a 00 50  .IPRS.._DIS.p..P
  07e0: 49 52 44 14 23 5f 43 52 53 00 8b 49 43 52 53 0a  IRD.#_CRS..ICRS.
  07f0: 01 49 52 41 30 70 01 61 79 61 49 52 51 44 49 52  .IRA0p.ayaIRQDIR
  0800: 41 30 a4 49 43 52 53 14 25 5f 53 52 53 01 8b 68  A0.ICRS.%_SRS..h
  0810: 0a 01 49 52 41 5f 82 49 52 41 5f 60 76 60 70 60  ..IRA_.IRA_`v`p`
  0820: 50 49 52 44 70 50 49 52 44 49 52 51 44 5b 82 46  PIRDpPIRDIRQD[.F
  0830: 14 53 59 53 52 08 5f 48 49 44 0c 41 d0 0c 02 14  .SYSR._HID.A....
  0840: 12 5f 53 54 41 00 a0 08 4f 53 46 4c a4 0a 0f a4  ._STA...OSFL....
  0850: 0a 00 08 49 4f 52 47 11 42 07 0a 6e 4b 10 00 10  ...IORG.B..nK...
  0860: 4b 22 00 1e 4b 44 00 1c 4b 62 00 02 4b 65 00 0b  K"..KD..Kb..Ke..
  0870: 4b 72 00 0e 4b 80 00 01 4b 84 00 03 4b 88 00 01  Kr..K...K...K...
  0880: 4b 8c 00 03 4b 90 00 10 4b a2 00 1e 4b e0 00 10  K...K...K...K...
  0890: 4b 90 02 08 47 01 d0 04 d0 04 00 02 47 01 00 00  K...G.......G...
  08a0: 00 00 00 00 47 01 00 00 00 00 00 00 47 01 f0 03  ....G.......G...
  08b0: f0 03 00 02 47 01 00 0c 00 0c 00 80 86 09 00 01  ....G...........
  08c0: 00 c0 0e 00 00 40 00 00 79 00 14 4a 0a 5f 43 52  .....@..y..J._CR
  08d0: 53 00 8b 49 4f 52 47 0a 42 50 4d 30 30 8b 49 4f  S..IORG.BPM00.IO
  08e0: 52 47 0a 44 50 4d 30 31 8c 49 4f 52 47 0a 47 50  RG.DPM01.IORG.GP
  08f0: 4d 4c 4e 8b 49 4f 52 47 0a 4a 53 4d 30 30 8b 49  MLN.IORG.JSM00.I
  0900: 4f 52 47 0a 4c 53 4d 30 31 8c 49 4f 52 47 0a 4f  ORG.LSM01.IORG.O
  0910: 53 4d 4c 4e 70 5c 2f 04 5f 53 42 5f 50 43 49 30  SMLNp\/._SB_PCI0
  0920: 50 4d 55 5f 50 4d 42 53 50 4d 30 30 70 50 4d 30  PMU_PMBSPM00pPM0
  0930: 30 50 4d 30 31 a0 0c 50 4d 30 30 70 0a 80 50 4d  0PM01..PM00p..PM
  0940: 4c 4e 70 5c 2f 04 5f 53 42 5f 50 43 49 30 50 4d  LNp\/._SB_PCI0PM
  0950: 55 5f 53 4d 42 53 53 4d 30 30 70 53 4d 30 30 53  U_SMBSSM00pSM00S
  0960: 4d 30 31 a0 0c 53 4d 30 30 70 0a 10 53 4d 4c 4e  M01..SM00p..SMLN
  0970: a4 49 4f 52 47 5b 82 4f 09 5c 2e 5f 53 42 5f 4d  .IORG[.O.\._SB_M
  0980: 45 4d 5f 08 5f 48 49 44 0c 41 d0 0c 01 14 1d 5f  EM_._HID.A....._
  0990: 53 54 41 00 a0 13 5c 2f 03 5f 53 42 5f 50 43 49  STA...\/._SB_PCI
  09a0: 30 4f 53 46 4c a4 0a 0f a4 0a 00 08 4d 45 4d 31  0OSFL.......MEM1
  09b0: 11 35 0a 32 86 09 00 01 00 00 00 00 00 00 0a 00  .5.2............
  09c0: 86 09 00 00 00 00 0f 00 00 00 01 00 86 09 00 01  ................
  09d0: 00 00 10 00 00 00 f0 1f 86 09 00 00 00 00 ff ff  ................
  09e0: 00 00 01 00 79 00 14 2f 5f 43 52 53 00 8a 4d 45  ....y../_CRS..ME
  09f0: 4d 31 0a 20 54 4f 50 31 74 5c 2f 03 5f 53 42 5f  M1. TOP1t\/._SB_
  0a00: 50 43 49 30 4d 44 45 54 0c 00 00 10 00 54 4f 50  PCI0MDET.....TOP
  0a10: 31 a4 4d 45 4d 31 5b 82 36 50 49 43 5f 08 5f 48  1.MEM1[.6PIC_._H
  0a20: 49 44 0b 41 d0 14 12 5f 53 54 41 00 a0 08 4f 53  ID.A..._STA...OS
  0a30: 46 4c a4 0a 0f a4 0a 00 08 5f 43 52 53 11 10 0a  FL......._CRS...
  0a40: 0d 4b 20 00 02 4b a0 00 02 22 04 00 79 00 5b 82  .K ..K..."..y.[.
  0a50: 35 44 4d 41 44 08 5f 48 49 44 0c 41 d0 02 00 08  5DMAD._HID.A....
  0a60: 5f 43 52 53 11 20 0a 1d 2a 10 04 4b 00 00 10 4b  _CRS. ..*..K...K
  0a70: 81 00 03 4b 87 00 01 4b 89 00 03 4b 8f 00 01 4b  ...K...K...K...K
  0a80: c0 00 20 79 00 5b 82 21 54 4d 52 5f 08 5f 48 49  .. y.[.!TMR_._HI
  0a90: 44 0c 41 d0 01 00 08 5f 43 52 53 11 0c 0a 09 4b  D.A...._CRS....K
  0aa0: 40 00 04 22 01 00 79 00 5b 82 21 52 54 43 5f 08  @.."..y.[.!RTC_.
  0ab0: 5f 48 49 44 0c 41 d0 0b 00 08 5f 43 52 53 11 0c  _HID.A...._CRS..
  0ac0: 0a 09 4b 70 00 02 22 00 01 79 00 5b 82 1e 53 50  ..Kp.."..y.[..SP
  0ad0: 4b 52 08 5f 48 49 44 0c 41 d0 08 00 08 5f 43 52  KR._HID.A...._CR
  0ae0: 53 11 09 0a 06 4b 61 00 01 79 00 5b 82 21 43 4f  S....Ka..y.[.!CO
  0af0: 50 52 08 5f 48 49 44 0c 41 d0 0c 04 08 5f 43 52  PR._HID.A...._CR
  0b00: 53 11 0c 0a 09 4b f0 00 10 22 00 20 79 00 5b 80  S....K...". y.[.
  0b10: 50 53 52 47 00 0b 10 04 0a 01 5b 81 0d 50 53 52  PSRG......[..PSR
  0b20: 47 01 00 02 50 53 32 45 01 5b 82 3c 50 53 32 4d  G...PS2E.[.<PS2M
  0b30: 08 5f 48 49 44 0c 41 d0 0f 03 08 5f 43 49 44 0c  ._HID.A...._CID.
  0b40: 41 d0 0f 13 14 14 5f 53 54 41 00 a0 08 50 53 32  A....._STA...PS2
  0b50: 45 a4 0a 0f a1 04 a4 0a 00 08 5f 43 52 53 11 08  E........._CRS..
  0b60: 0a 05 22 00 10 79 00 5b 82 2f 50 53 32 4b 08 5f  .."..y.[./PS2K._
  0b70: 48 49 44 0c 41 d0 03 03 08 5f 43 49 44 0c 41 d0  HID.A...._CID.A.
  0b80: 03 0b 08 5f 43 52 53 11 10 0a 0d 4b 60 00 01 4b  ..._CRS....K`..K
  0b90: 64 00 01 22 02 00 79 00 14 07 52 52 49 4f 04 a3  d.."..y...RRIO..
  0ba0: 14 07 52 47 4e 52 04 a3 14 07 52 44 4d 41 03 a3  ..RGNR....RDMA..
  0bb0: 08 53 50 49 4f 0b f0 03 5b 80 57 49 4e 31 01 53  .SPIO...[.WIN1.S
  0bc0: 50 49 4f 0a 02 5b 81 10 57 49 4e 31 01 49 4e 44  PIO..[..WIN1.IND
  0bd0: 58 08 44 41 54 41 08 5b 86 4b 08 49 4e 44 58 44  X.DATA.[.K.INDXD
  0be0: 41 54 41 01 00 40 70 43 52 43 30 08 43 52 43 31  ATA..@pCRC0.CRC1
  0bf0: 08 43 52 43 32 08 43 52 43 33 08 43 52 43 34 08  .CRC2.CRC3.CRC4.
  0c00: 43 52 43 35 08 43 52 43 36 08 43 52 43 37 08 43  CRC5.CRC6.CRC7.C
  0c10: 52 43 38 08 43 52 43 39 08 43 52 43 41 08 43 52  RC8.CRC9.CRCA.CR
  0c20: 43 42 08 43 52 43 43 08 43 52 43 44 08 43 52 43  CB.CRCC.CRCD.CRC
  0c30: 45 08 43 52 43 46 08 43 52 44 30 08 43 52 44 31  E.CRCF.CRD0.CRD1
  0c40: 08 43 52 44 32 08 43 52 44 33 08 43 52 44 34 08  .CRD2.CRD3.CRD4.
  0c50: 43 52 44 35 08 43 52 44 36 08 43 52 44 37 08 43  CRD5.CRD6.CRD7.C
  0c60: 52 44 38 08 14 0c 45 4e 46 47 00 70 01 45 4e 33  RD8...ENFG.p.EN3
  0c70: 43 14 0c 45 58 46 47 00 70 00 45 4e 33 43 08 46  C..EXFG.p.EN3C.F
  0c80: 44 53 54 0a 00 08 55 31 53 54 0a 00 08 55 32 53  DST...U1ST...U2S
  0c90: 54 0a 00 08 49 52 53 54 0a 00 08 4c 50 53 54 0a  T...IRST...LPST.
  0ca0: 00 08 45 50 53 54 0a 00 14 48 05 49 4f 44 54 00  ..EPST...H.IODT.
  0cb0: 45 4e 46 47 a0 10 7b 43 52 43 32 0a 10 00 70 0a  ENFG..{CRC2...p.
  0cc0: 01 46 44 53 54 a0 10 7b 43 52 43 32 0a 04 00 70  .FDST..{CRC2...p
  0cd0: 0a 01 55 31 53 54 a0 10 7b 43 52 43 32 0a 08 00  ..U1ST..{CRC2...
  0ce0: 70 0a 01 55 32 53 54 7b 43 52 43 32 0a 03 60 a0  p..U2ST{CRC2..`.
  0cf0: 0d 92 93 60 0a 03 70 0a 01 4c 50 53 54 45 58 46  ...`..p..LPSTEXF
  0d00: 47 14 0a 5f 49 4e 49 00 49 4f 44 54 08 43 53 43  G.._INI.IODT.CSC
  0d10: 50 0a 00 5b 84 30 55 52 50 31 01 00 00 14 0b 5f  P..[.0URP1....._
  0d20: 53 54 41 00 a4 43 53 43 50 14 0d 5f 4f 4e 5f 00  STA..CSCP.._ON_.
  0d30: 70 0a 01 43 53 43 50 14 0d 5f 4f 46 46 00 70 0a  p..CSCP.._OFF.p.
  0d40: 00 43 53 43 50 5b 84 30 55 52 50 32 01 00 00 14  .CSCP[.0URP2....
  0d50: 0b 5f 53 54 41 00 a4 43 53 43 50 14 0d 5f 4f 4e  ._STA..CSCP.._ON
  0d60: 5f 00 70 0a 01 43 53 43 50 14 0d 5f 4f 46 46 00  _.p..CSCP.._OFF.
  0d70: 70 0a 00 43 53 43 50 5b 84 30 46 44 44 50 00 00  p..CSCP[.0FDDP..
  0d80: 00 14 0b 5f 53 54 41 00 a4 43 53 43 50 14 0d 5f  ..._STA..CSCP.._
  0d90: 4f 4e 5f 00 70 0a 01 43 53 43 50 14 0d 5f 4f 46  ON_.p..CSCP.._OF
  0da0: 46 00 70 0a 00 43 53 43 50 5b 84 30 4c 50 54 50  F.p..CSCP[.0LPTP
  0db0: 00 00 00 14 0b 5f 53 54 41 00 a4 43 53 43 50 14  ....._STA..CSCP.
  0dc0: 0d 5f 4f 4e 5f 00 70 0a 01 43 53 43 50 14 0d 5f  ._ON_.p..CSCP.._
  0dd0: 4f 46 46 00 70 0a 00 43 53 43 50 5b 82 4c 15 46  OFF.p..CSCP[.L.F
  0de0: 44 43 30 08 5f 48 49 44 0c 41 d0 07 00 14 3e 5f  DC0._HID.A....>_
  0df0: 53 54 41 00 a0 09 92 45 50 33 43 a4 0a 00 a1 2d  STA....EP3C....-
  0e00: 45 4e 46 47 70 43 52 43 32 60 7b 60 0a 10 60 70  ENFGpCRC2`{`..`p
  0e10: 43 52 43 33 61 45 58 46 47 a0 05 60 a4 0a 0f a1  CRC3aEXFG..`....
  0e20: 0c a0 05 61 a4 0a 0d a1 04 a4 0a 00 14 1f 5f 44  ...a.........._D
  0e30: 49 53 00 45 4e 46 47 70 43 52 43 32 60 7b 60 0a  IS.ENFGpCRC2`{`.
  0e40: ef 60 70 60 43 52 43 32 45 58 46 47 14 2c 5f 43  .`p`CRC2EXFG.,_C
  0e50: 52 53 00 08 42 55 46 46 11 1b 0a 18 47 01 f2 03  RS..BUFF....G...
  0e60: f2 03 02 04 47 01 f7 03 f7 03 01 01 22 40 00 2a  ....G......."@.*
  0e70: 04 04 79 00 a4 42 55 46 46 08 5f 50 52 53 11 1b  ..y..BUFF._PRS..
  0e80: 0a 18 47 01 f2 03 f2 03 02 04 47 01 f7 03 f7 03  ..G.......G.....
  0e90: 01 01 22 40 00 2a 04 04 79 00 14 4e 09 5f 53 52  .."@.*..y..N._SR
  0ea0: 53 01 8c 68 0a 02 49 4f 4c 4f 8c 68 0a 03 49 4f  S..h..IOLO.h..IO
  0eb0: 48 49 8b 68 0a 11 49 52 51 30 8c 68 0a 14 44 4d  HI.h..IRQ0.h..DM
  0ec0: 41 30 45 4e 46 47 70 43 52 43 32 60 7b 60 0a ef  A0ENFGpCRC2`{`..
  0ed0: 61 70 61 43 52 43 32 70 49 4f 4c 4f 60 7a 60 0a  apaCRC2pIOLO`z`.
  0ee0: 02 60 7b 60 0a fc 60 70 49 4f 48 49 61 79 61 0a  .`{`..`pIOHIaya.
  0ef0: 06 61 7d 60 61 60 70 60 43 52 43 33 82 49 52 51  .a}`a`p`CRC3.IRQ
  0f00: 30 60 a0 07 94 60 0a 00 76 60 70 60 46 4c 49 52  0`...`..v`p`FLIR
  0f10: 82 44 4d 41 30 60 a0 07 94 60 0a 00 76 60 70 60  .DMA0`...`..v`p`
  0f20: 46 4c 44 41 70 43 52 43 32 60 7d 60 0a 10 61 70  FLDApCRC2`}`..ap
  0f30: 61 43 52 43 32 45 58 46 47 5b 82 46 1c 55 41 52  aCRC2EXFG[.F.UAR
  0f40: 31 08 5f 48 49 44 0c 41 d0 05 01 08 5f 55 49 44  1._HID.A...._UID
  0f50: 0a 01 14 45 04 5f 53 54 41 00 a0 09 92 45 50 33  ...E._STA....EP3
  0f60: 43 a4 0a 00 45 4e 46 47 70 43 52 43 32 60 7b 60  C...ENFGpCRC2`{`
  0f70: 0a 04 60 a0 09 60 45 58 46 47 a4 0a 0f a1 1a 70  ..`..`EXFG.....p
  0f80: 43 52 43 37 61 a0 09 61 45 58 46 47 a4 0a 0d a1  CRC7a..aEXFG....
  0f90: 08 45 58 46 47 a4 0a 00 14 1f 5f 44 49 53 00 45  .EXFG....._DIS.E
  0fa0: 4e 46 47 70 43 52 43 32 60 7b 60 0a fb 60 70 60  NFGpCRC2`{`..`p`
  0fb0: 43 52 43 32 45 58 46 47 14 49 08 5f 43 52 53 00  CRC2EXFG.I._CRS.
  0fc0: 08 42 46 55 31 11 10 0a 0d 47 01 f8 03 f8 03 08  .BFU1....G......
  0fd0: 08 22 10 00 79 00 8b 42 46 55 31 0a 02 49 4d 49  ."..y..BFU1..IMI
  0fe0: 4e 8b 42 46 55 31 0a 04 49 4d 41 58 8b 42 46 55  N.BFU1..IMAX.BFU
  0ff0: 31 0a 09 49 52 51 30 45 4e 46 47 70 43 52 43 37  1..IRQ0ENFGpCRC7
  1000: 60 70 60 61 7b 61 0a c0 61 79 61 0a 02 61 7b 60  `p`a{a..aya..a{`
  1010: 0a 3f 60 79 60 0a 02 60 7d 60 61 60 70 60 49 4d  .?`y`..`}`a`p`IM
  1020: 49 4e 70 60 49 4d 41 58 45 58 46 47 70 55 31 49  INp`IMAXEXFGpU1I
  1030: 52 60 70 0a 01 61 79 61 60 49 52 51 30 a4 42 46  R`p..aya`IRQ0.BF
  1040: 55 31 08 5f 50 52 53 11 36 0a 33 30 47 01 f8 03  U1._PRS.6.30G...
  1050: f8 03 08 08 22 10 00 30 47 01 f8 02 f8 02 08 08  ...."..0G.......
  1060: 22 08 00 30 47 01 e8 03 e8 03 08 08 22 10 00 30  "..0G......."..0
  1070: 47 01 e8 02 e8 02 08 08 22 08 00 38 79 00 14 42  G......."..8y..B
  1080: 08 5f 53 52 53 01 8c 68 0a 02 49 4f 4c 4f 8c 68  ._SRS..h..IOLO.h
  1090: 0a 03 49 4f 48 49 8b 68 0a 09 49 52 51 30 45 4e  ..IOHI.h..IRQ0EN
  10a0: 46 47 70 43 52 43 32 60 7b 60 0a fb 61 70 61 43  FGpCRC2`{`..apaC
  10b0: 52 43 32 70 49 4f 4c 4f 60 7a 60 0a 02 60 7b 60  RC2pIOLO`z`..`{`
  10c0: 0a fe 60 70 49 4f 48 49 61 79 61 0a 06 61 7d 60  ..`pIOHIaya..a}`
  10d0: 61 60 70 60 43 52 43 37 82 49 52 51 30 60 a0 07  a`p`CRC7.IRQ0`..
  10e0: 94 60 0a 00 76 60 70 60 55 31 49 52 70 43 52 43  .`..v`p`U1IRpCRC
  10f0: 32 60 7d 60 0a 04 61 70 61 43 52 43 32 45 58 46  2`}`..apaCRC2EXF
  1100: 47 5b 82 47 1e 55 41 52 32 14 2a 5f 48 49 44 00  G[.G.UAR2.*_HID.
  1110: 45 4e 46 47 70 43 52 43 45 60 45 58 46 47 7b 60  ENFGpCRCE`EXFG{`
  1120: 0a 38 60 a0 08 60 a4 0c 41 d0 05 10 a1 07 a4 0c  .8`..`..A.......
  1130: 41 d0 05 01 08 5f 55 49 44 0a 02 14 45 04 5f 53  A...._UID...E._S
  1140: 54 41 00 a0 09 92 45 50 33 43 a4 0a 00 45 4e 46  TA....EP3C...ENF
  1150: 47 70 43 52 43 32 60 7b 60 0a 08 60 a0 09 60 45  GpCRC2`{`..`..`E
  1160: 58 46 47 a4 0a 0f a1 1a 70 43 52 43 38 61 a0 09  XFG.....pCRC8a..
  1170: 61 45 58 46 47 a4 0a 0d a1 08 45 58 46 47 a4 0a  aEXFG.....EXFG..
  1180: 00 14 1f 5f 44 49 53 00 45 4e 46 47 70 43 52 43  ..._DIS.ENFGpCRC
  1190: 32 60 7b 60 0a f7 60 70 60 43 52 43 32 45 58 46  2`{`..`p`CRC2EXF
  11a0: 47 14 49 08 5f 43 52 53 00 08 42 46 55 32 11 10  G.I._CRS..BFU2..
  11b0: 0a 0d 47 01 f8 02 f8 02 08 08 22 08 00 79 00 8b  ..G......."..y..
  11c0: 42 46 55 32 0a 02 49 4d 49 4e 8b 42 46 55 32 0a  BFU2..IMIN.BFU2.
  11d0: 04 49 4d 41 58 8b 42 46 55 32 0a 09 49 52 51 30  .IMAX.BFU2..IRQ0
  11e0: 45 4e 46 47 70 43 52 43 38 60 70 60 61 7b 61 0a  ENFGpCRC8`p`a{a.
  11f0: c0 61 79 61 0a 02 61 7b 60 0a 3f 60 79 60 0a 02  .aya..a{`.?`y`..
  1200: 60 7d 60 61 60 70 60 49 4d 49 4e 70 60 49 4d 41  `}`a`p`IMINp`IMA
  1210: 58 45 58 46 47 70 55 32 49 52 60 70 0a 01 61 79  XEXFGpU2IR`p..ay
  1220: 61 60 49 52 51 30 a4 42 46 55 32 08 5f 50 52 53  a`IRQ0.BFU2._PRS
  1230: 11 36 0a 33 30 47 01 f8 03 f8 03 08 08 22 10 00  .6.30G......."..
  1240: 30 47 01 f8 02 f8 02 08 08 22 08 00 30 47 01 e8  0G......."..0G..
  1250: 03 e8 03 08 08 22 10 00 30 47 01 e8 02 e8 02 08  ....."..0G......
  1260: 08 22 08 00 38 79 00 14 42 08 5f 53 52 53 01 8c  ."..8y..B._SRS..
  1270: 68 0a 02 49 4f 4c 4f 8c 68 0a 03 49 4f 48 49 8b  h..IOLO.h..IOHI.
  1280: 68 0a 09 49 52 51 30 45 4e 46 47 70 43 52 43 32  h..IRQ0ENFGpCRC2
  1290: 60 7b 60 0a f7 61 70 61 43 52 43 32 70 49 4f 4c  `{`..apaCRC2pIOL
  12a0: 4f 60 7a 60 0a 02 60 7b 60 0a fe 60 70 49 4f 48  O`z`..`{`..`pIOH
  12b0: 49 61 79 61 0a 06 61 7d 60 61 60 70 60 43 52 43  Iaya..a}`a`p`CRC
  12c0: 38 82 49 52 51 30 60 a0 07 94 60 0a 00 76 60 70  8.IRQ0`...`..v`p
  12d0: 60 55 32 49 52 70 43 52 43 32 60 7d 60 0a 08 61  `U2IRpCRC2`}`..a
  12e0: 70 61 43 52 43 32 45 58 46 47 5b 82 43 27 45 43  paCRC2EXFG[.C'EC
  12f0: 50 5f 08 5f 48 49 44 0c 41 d0 04 01 14 45 04 5f  P_._HID.A....E._
  1300: 53 54 41 00 a0 09 92 45 50 33 43 a4 0a 00 45 4e  STA....EP3C...EN
  1310: 46 47 70 43 52 43 32 60 7b 60 0a 03 60 a0 1b 93  FGpCRC2`{`..`...
  1320: 60 0a 01 a0 0c 43 52 43 36 45 58 46 47 a4 0a 0f  `....CRC6EXFG...
  1330: a1 08 45 58 46 47 a4 0a 0d a1 08 45 58 46 47 a4  ..EXFG.....EXFG.
  1340: 0a 00 14 19 5f 44 49 53 00 45 4e 46 47 7d 43 52  ...._DIS.ENFG}CR
  1350: 43 46 0a 10 43 52 43 46 45 58 46 47 14 46 11 5f  CF..CRCFEXFG.F._
  1360: 43 52 53 00 08 42 55 46 45 11 1b 0a 18 47 01 78  CRS..BUFE....G.x
  1370: 03 78 03 08 08 47 01 78 07 78 07 04 04 22 80 00  .x...G.x.x..."..
  1380: 2a 08 00 79 00 8b 42 55 46 45 0a 02 49 4d 49 31  *..y..BUFE..IMI1
  1390: 8b 42 55 46 45 0a 04 49 4d 41 31 8c 42 55 46 45  .BUFE..IMA1.BUFE
  13a0: 0a 06 41 4c 4e 31 8c 42 55 46 45 0a 07 4c 45 4e  ..ALN1.BUFE..LEN
  13b0: 31 8b 42 55 46 45 0a 0a 49 4d 49 32 8b 42 55 46  1.BUFE..IMI2.BUF
  13c0: 45 0a 0c 49 4d 41 32 8b 42 55 46 45 0a 11 49 52  E..IMA2.BUFE..IR
  13d0: 51 30 8c 42 55 46 45 0a 14 44 4d 41 30 45 4e 46  Q0.BUFE..DMA0ENF
  13e0: 47 70 43 52 43 36 60 45 58 46 47 70 60 61 7b 61  GpCRC6`EXFGp`a{a
  13f0: 0a c0 61 79 61 0a 02 61 79 60 0a 02 60 7d 60 61  ..aya..ay`..`}`a
  1400: 60 70 60 49 4d 49 31 70 60 49 4d 41 31 72 60 0b  `p`IMI1p`IMA1r`.
  1410: 00 04 60 70 60 49 4d 49 32 70 60 49 4d 41 32 a0  ..`p`IMI2p`IMA2.
  1420: 17 93 49 4d 49 31 0b bc 03 70 0a 04 41 4c 4e 31  ..IMI1...p..ALN1
  1430: 70 0a 04 4c 45 4e 31 a1 0f 70 0a 08 41 4c 4e 31  p..LEN1..p..ALN1
  1440: 70 0a 08 4c 45 4e 31 70 4c 50 49 52 60 70 0a 01  p..LEN1pLPIR`p..
  1450: 61 79 61 60 49 52 51 30 70 4c 50 44 41 60 7b 60  aya`IRQ0pLPDA`{`
  1460: 0a 03 60 70 0a 01 61 79 61 60 44 4d 41 30 a4 42  ..`p..aya`DMA0.B
  1470: 55 46 45 08 5f 50 52 53 11 4c 04 0a 48 30 47 01  UFE._PRS.L..H0G.
  1480: 78 03 78 03 08 08 47 01 78 07 78 07 04 04 22 a0  x.x...G.x.x...".
  1490: 00 2a 0b 00 30 47 01 78 02 78 02 08 08 47 01 78  .*..0G.x.x...G.x
  14a0: 06 78 06 04 04 22 a0 00 2a 0b 00 30 47 01 bc 03  .x..."..*..0G...
  14b0: bc 03 04 04 47 01 bc 07 bc 07 04 04 22 a0 00 2a  ....G......."..*
  14c0: 0b 00 38 79 00 14 49 09 5f 53 52 53 01 8c 68 0a  ..8y..I._SRS..h.
  14d0: 02 49 4f 4c 4f 8c 68 0a 03 49 4f 48 49 8b 68 0a  .IOLO.h..IOHI.h.
  14e0: 11 49 52 51 30 8c 68 0a 14 44 4d 41 30 45 4e 46  .IRQ0.h..DMA0ENF
  14f0: 47 70 43 52 43 32 62 7d 62 0a 03 63 70 63 43 52  GpCRC2b}b..cpcCR
  1500: 43 32 70 49 4f 4c 4f 60 7a 60 0a 02 60 70 49 4f  C2pIOLO`z`..`pIO
  1510: 48 49 61 79 61 0a 06 61 7d 60 61 60 70 60 43 52  HIaya..a}`a`p`CR
  1520: 43 36 82 49 52 51 30 60 a0 07 94 60 0a 00 76 60  C6.IRQ0`...`..v`
  1530: 70 60 4c 50 49 52 82 44 4d 41 30 60 a0 07 94 60  p`LPIR.DMA0`...`
  1540: 0a 00 76 60 70 60 4c 50 44 41 70 62 43 52 43 32  ..v`p`LPDApbCRC2
  1550: 7b 43 52 43 46 0a ef 43 52 43 46 45 58 46 47 5b  {CRCF..CRCFEXFG[
  1560: 82 4e 1d 4c 50 54 5f 08 5f 48 49 44 0c 41 d0 04  .N.LPT_._HID.A..
  1570: 00 14 42 04 5f 53 54 41 00 a0 09 92 45 50 33 43  ..B._STA....EP3C
  1580: a4 0a 00 45 4e 46 47 70 43 52 43 32 60 7b 60 0a  ...ENFGpCRC2`{`.
  1590: 01 60 a0 09 60 45 58 46 47 a4 0a 00 a1 17 a0 0c  .`..`EXFG.......
  15a0: 43 52 43 36 45 58 46 47 a4 0a 0f a1 08 45 58 46  CRC6EXFG.....EXF
  15b0: 47 a4 0a 00 14 19 5f 44 49 53 00 45 4e 46 47 7d  G....._DIS.ENFG}
  15c0: 43 52 43 46 0a 10 43 52 43 46 45 58 46 47 14 42  CRCF..CRCFEXFG.B
  15d0: 0c 5f 43 52 53 00 08 42 55 46 45 11 10 0a 0d 47  ._CRS..BUFE....G
  15e0: 01 78 03 78 03 08 08 22 80 00 79 00 8b 42 55 46  .x.x..."..y..BUF
  15f0: 45 0a 02 49 4d 49 31 8b 42 55 46 45 0a 04 49 4d  E..IMI1.BUFE..IM
  1600: 41 31 8c 42 55 46 45 0a 06 41 4c 4e 31 8c 42 55  A1.BUFE..ALN1.BU
  1610: 46 45 0a 07 4c 45 4e 31 8b 42 55 46 45 0a 09 49  FE..LEN1.BUFE..I
  1620: 52 51 30 45 4e 46 47 70 43 52 43 36 60 45 58 46  RQ0ENFGpCRC6`EXF
  1630: 47 70 60 61 7b 61 0a c0 61 79 61 0a 02 61 79 60  Gp`a{a..aya..ay`
  1640: 0a 02 60 7d 60 61 60 70 60 49 4d 49 31 70 60 49  ..`}`a`p`IMI1p`I
  1650: 4d 41 31 a0 17 93 49 4d 49 31 0b bc 03 70 0a 04  MA1...IMI1...p..
  1660: 41 4c 4e 31 70 0a 04 4c 45 4e 31 a1 0f 70 0a 08  ALN1p..LEN1..p..
  1670: 41 4c 4e 31 70 0a 08 4c 45 4e 31 70 4c 50 49 52  ALN1p..LEN1pLPIR
  1680: 60 70 0a 01 61 79 61 60 49 52 51 30 a4 42 55 46  `p..aya`IRQ0.BUF
  1690: 45 08 5f 50 52 53 11 2a 0a 27 30 47 01 78 03 78  E._PRS.*.'0G.x.x
  16a0: 03 08 08 22 a0 00 30 47 01 78 02 78 02 08 08 22  ..."..0G.x.x..."
  16b0: a0 00 30 47 01 bc 03 bc 03 04 04 22 a0 00 38 79  ..0G......."..8y
  16c0: 00 14 4d 07 5f 53 52 53 01 8c 68 0a 02 49 4f 4c  ..M._SRS..h..IOL
  16d0: 4f 8c 68 0a 03 49 4f 48 49 8b 68 0a 09 49 52 51  O.h..IOHI.h..IRQ
  16e0: 30 45 4e 46 47 70 43 52 43 32 62 7d 62 0a 03 63  0ENFGpCRC2b}b..c
  16f0: 70 63 43 52 43 32 70 49 4f 4c 4f 60 7a 60 0a 02  pcCRC2pIOLO`z`..
  1700: 60 70 49 4f 48 49 61 79 61 0a 06 61 7d 60 61 60  `pIOHIaya..a}`a`
  1710: 70 60 43 52 43 36 82 49 52 51 30 60 a0 07 94 60  p`CRC6.IRQ0`...`
  1720: 0a 00 76 60 70 60 4c 50 49 52 70 62 43 52 43 32  ..v`p`LPIRpbCRC2
  1730: 7b 43 52 43 46 0a ef 43 52 43 46 45 58 46 47 08  {CRCF..CRCFEXFG.
  1740: 2e 55 41 52 31 5f 50 52 30 12 06 01 55 52 50 31  .UAR1_PR0...URP1
  1750: 08 2e 55 41 52 31 5f 50 52 57 12 06 02 0a 08 0a  ..UAR1_PRW......
  1760: 04 10 23 5c 5f 47 50 45 14 1c 5f 4c 30 38 00 86  ..#\_GPE.._L08..
  1770: 5c 2f 04 5f 53 42 5f 50 43 49 30 53 42 52 47 55  \/._SB_PCI0SBRGU
  1780: 41 52 31 0a 02 5b 82 46 05 50 4d 55 5f 08 5f 41  AR1..[.F.PMU_._A
  1790: 44 52 0c 04 00 07 00 14 12 50 4d 42 53 00 7d 79  DR.......PMBS.}y
  17a0: 0a 08 0a 08 00 0a 00 60 a4 60 14 12 53 4d 42 53  .......`.`..SMBS
  17b0: 00 7d 79 0a 04 0a 08 00 0a 00 60 a4 60 14 12 48  .}y.......`.`..H
  17c0: 4d 42 53 00 7d 79 0a 0c 0a 08 00 0a 00 60 a4 60  MBS.}y.......`.`
  17d0: 5b 80 50 57 52 47 01 50 4d 42 53 0a 40 5b 82 4c  [.PWRG.PMBS.@[.L
  17e0: a8 49 44 45 30 08 5f 41 44 52 0c 01 00 07 00 08  .IDE0._ADR......
  17f0: 52 45 47 46 0a 01 14 12 5f 52 45 47 02 a0 0b 93  REGF...._REG....
  1800: 68 0a 02 70 69 52 45 47 46 08 54 49 4d 30 12 44  h..piREGF.TIM0.D
  1810: 0b 0c 12 0b 04 0a 78 0a b4 0a f0 0b 84 03 12 0a  ......x.........
  1820: 04 0a 20 0a 31 0a 65 0a a8 12 12 08 0a 02 0a 01  .. .1.e.........
  1830: 0a 00 0a 00 0a 00 0a 00 0a 00 0a 00 12 12 08 0a  ................
  1840: 04 0a 03 0a 02 0a 02 0a 01 0a 01 0a 00 0a 00 12  ................
  1850: 12 08 0a 05 0a 04 0a 03 0a 02 0a 02 0a 01 0a 01  ................
  1860: 0a 00 12 0e 06 0a 70 0a 49 0a 36 0a 27 0a 19 0a  ......p.I.6.'...
  1870: 0f 12 0e 06 0a 02 0a 01 0a 00 0a 00 0a 00 0a 00  ................
  1880: 12 0e 06 0a 06 0a 04 0a 02 0a 01 0a 00 0a 00 12  ................
  1890: 0e 06 0a 07 0a 06 0a 04 0a 02 0a 01 0a 00 12 0e  ................
  18a0: 06 0a 00 0a 00 0a 00 0a 01 0a 01 0a 01 12 0a 04  ................
  18b0: 0a 04 0a 03 0a 02 0a 00 12 0a 04 0a 02 0a 01 0a  ................
  18c0: 00 0a 00 08 54 4d 44 30 11 03 0a 14 8a 54 4d 44  ....TMD0.....TMD
  18d0: 30 0a 00 50 49 4f 30 8a 54 4d 44 30 0a 04 44 4d  0..PIO0.TMD0..DM
  18e0: 41 30 8a 54 4d 44 30 0a 08 50 49 4f 31 8a 54 4d  A0.TMD0..PIO1.TM
  18f0: 44 30 0a 0c 44 4d 41 31 8a 54 4d 44 30 0a 10 43  D0..DMA1.TMD0..C
  1900: 48 4e 46 5b 80 43 46 47 32 02 0a 40 0a 20 5b 81  HNF[.CFG2..@. [.
  1910: 4a 06 43 46 47 32 03 00 40 04 53 53 50 54 08 53  J.CFG2..@.SSPT.S
  1920: 4d 50 54 08 50 53 50 54 08 50 4d 50 54 08 00 20  MPT.PSPT.PMPT.. 
  1930: 53 53 55 54 03 53 43 42 43 01 53 53 43 52 01 53  SSUT.SCBC.SSCR.S
  1940: 53 55 45 03 53 4d 55 54 03 00 01 53 4d 43 52 01  SUE.SMUT...SMCR.
  1950: 53 4d 55 45 03 50 53 55 54 03 50 43 42 43 01 50  SMUE.PSUT.PCBC.P
  1960: 53 43 52 01 50 53 55 45 03 50 4d 55 54 03 00 01  SCR.PSUE.PMUT...
  1970: 50 4d 43 52 01 50 4d 55 45 03 08 47 4d 50 54 0a  PMCR.PMUE..GMPT.
  1980: 00 08 47 4d 55 45 0a 00 08 47 4d 55 54 0a 00 08  ..GMUE...GMUT...
  1990: 47 53 50 54 0a 00 08 47 53 55 45 0a 00 08 47 53  GSPT...GSUE...GS
  19a0: 55 54 0a 00 08 47 42 43 53 0a 00 5b 82 4d 11 43  UT...GBCS..[.M.C
  19b0: 48 4e 30 08 5f 41 44 52 0a 00 14 27 5f 47 54 4d  HN0._ADR...'_GTM
  19c0: 00 a4 47 54 4d 5f 50 4d 50 54 50 4d 55 45 50 4d  ..GTM_PMPTPMUEPM
  19d0: 55 54 50 53 50 54 50 53 55 45 50 53 55 54 50 43  UTPSPTPSUEPSUTPC
  19e0: 42 43 14 4b 0a 5f 53 54 4d 03 70 68 5b 31 70 68  BC.K._STM.ph[1ph
  19f0: 54 4d 44 30 70 50 4d 50 54 47 4d 50 54 70 50 4d  TMD0pPMPTGMPTpPM
  1a00: 55 45 47 4d 55 45 70 50 4d 55 54 47 4d 55 54 70  UEGMUEpPMUTGMUTp
  1a10: 50 53 50 54 47 53 50 54 70 50 53 55 45 47 53 55  PSPTGSPTpPSUEGSU
  1a20: 45 70 50 53 55 54 47 53 55 54 70 50 43 42 43 47  EpPSUTGSUTpPCBCG
  1a30: 42 43 53 53 54 4d 5f 70 47 4d 50 54 50 4d 50 54  BCSSTM_pGMPTPMPT
  1a40: 70 47 4d 55 45 50 4d 55 45 70 47 4d 55 54 50 4d  pGMUEPMUEpGMUTPM
  1a50: 55 54 70 47 53 50 54 50 53 50 54 70 47 53 55 45  UTpGSPTPSPTpGSUE
  1a60: 50 53 55 45 70 47 53 55 54 50 53 55 54 70 47 42  PSUEpGSUTPSUTpGB
  1a70: 43 53 50 43 42 43 70 47 54 46 5f 0a 00 69 41 54  CSPCBCpGTF_..iAT
  1a80: 41 30 70 47 54 46 5f 0a 01 6a 41 54 41 31 5b 82  A0pGTF_..jATA1[.
  1a90: 1c 44 52 56 30 08 5f 41 44 52 0a 00 14 0f 5f 47  .DRV0._ADR...._G
  1aa0: 54 46 00 a4 52 41 54 41 41 54 41 30 5b 82 1c 44  TF..RATAATA0[..D
  1ab0: 52 56 31 08 5f 41 44 52 0a 01 14 0f 5f 47 54 46  RV1._ADR...._GTF
  1ac0: 00 a4 52 41 54 41 41 54 41 31 5b 82 4d 11 43 48  ..RATAATA1[.M.CH
  1ad0: 4e 31 08 5f 41 44 52 0a 01 14 27 5f 47 54 4d 00  N1._ADR...'_GTM.
  1ae0: a4 47 54 4d 5f 53 4d 50 54 53 4d 55 45 53 4d 55  .GTM_SMPTSMUESMU
  1af0: 54 53 53 50 54 53 53 55 45 53 53 55 54 53 43 42  TSSPTSSUESSUTSCB
  1b00: 43 14 4b 0a 5f 53 54 4d 03 70 68 5b 31 70 68 54  C.K._STM.ph[1phT
  1b10: 4d 44 30 70 53 4d 50 54 47 4d 50 54 70 53 4d 55  MD0pSMPTGMPTpSMU
  1b20: 45 47 4d 55 45 70 53 4d 55 54 47 4d 55 54 70 53  EGMUEpSMUTGMUTpS
  1b30: 53 50 54 47 53 50 54 70 53 53 55 45 47 53 55 45  SPTGSPTpSSUEGSUE
  1b40: 70 53 53 55 54 47 53 55 54 70 53 43 42 43 47 42  pSSUTGSUTpSCBCGB
  1b50: 43 53 53 54 4d 5f 70 47 4d 50 54 53 4d 50 54 70  CSSTM_pGMPTSMPTp
  1b60: 47 4d 55 45 53 4d 55 45 70 47 4d 55 54 53 4d 55  GMUESMUEpGMUTSMU
  1b70: 54 70 47 53 50 54 53 53 50 54 70 47 53 55 45 53  TpGSPTSSPTpGSUES
  1b80: 53 55 45 70 47 53 55 54 53 53 55 54 70 47 42 43  SUEpGSUTSSUTpGBC
  1b90: 53 53 43 42 43 70 47 54 46 5f 0a 00 69 41 54 41  SSCBCpGTF_..iATA
  1ba0: 32 70 47 54 46 5f 0a 01 6a 41 54 41 33 5b 82 1c  2pGTF_..jATA3[..
  1bb0: 44 52 56 30 08 5f 41 44 52 0a 00 14 0f 5f 47 54  DRV0._ADR...._GT
  1bc0: 46 00 a4 52 41 54 41 41 54 41 32 5b 82 1c 44 52  F..RATAATA2[..DR
  1bd0: 56 31 08 5f 41 44 52 0a 01 14 0f 5f 47 54 46 00  V1._ADR...._GTF.
  1be0: a4 52 41 54 41 41 54 41 33 14 41 15 47 54 4d 5f  .RATAATA3.A.GTM_
  1bf0: 0f 70 ff 50 49 4f 30 70 ff 50 49 4f 31 70 ff 44  .p.PIO0p.PIO1p.D
  1c00: 4d 41 30 70 ff 44 4d 41 31 70 0a 10 43 48 4e 46  MA0p.DMA1p..CHNF
  1c10: a0 05 52 45 47 46 a1 06 a4 54 4d 44 30 70 89 83  ..REGF...TMD0p..
  1c20: 88 54 49 4d 30 0a 01 00 01 68 00 0a 00 0a 00 66  .TIM0....h.....f
  1c30: 70 83 88 83 88 54 49 4d 30 0a 00 00 66 00 67 70  p....TIM0...f.gp
  1c40: 67 44 4d 41 30 70 67 50 49 4f 30 70 89 83 88 54  gDMA0pgPIO0p...T
  1c50: 49 4d 30 0a 01 00 01 6b 00 0a 00 0a 00 66 70 83  IM0....k.....fp.
  1c60: 88 83 88 54 49 4d 30 0a 00 00 66 00 67 70 67 44  ...TIM0...f.gpgD
  1c70: 4d 41 31 70 67 50 49 4f 31 a0 4a 05 69 a0 14 53  MA1pgPIO1.J.i..S
  1c80: 42 52 56 70 83 88 83 88 54 49 4d 30 0a 04 00 6a  BRVp....TIM0...j
  1c90: 00 65 a1 24 a0 11 6e 70 83 88 83 88 54 49 4d 30  .e.$..np....TIM0
  1ca0: 0a 03 00 6a 00 65 a1 10 70 83 88 83 88 54 49 4d  ...j.e..p....TIM
  1cb0: 30 0a 02 00 6a 00 65 70 83 88 83 88 54 49 4d 30  0...j.ep....TIM0
  1cc0: 0a 05 00 65 00 44 4d 41 30 7d 43 48 4e 46 0a 01  ...e.DMA0}CHNF..
  1cd0: 43 48 4e 46 a0 4a 05 6c a0 14 53 42 52 56 70 83  CHNF.J.l..SBRVp.
  1ce0: 88 83 88 54 49 4d 30 0a 04 00 6d 00 65 a1 24 a0  ...TIM0...m.e.$.
  1cf0: 11 6e 70 83 88 83 88 54 49 4d 30 0a 03 00 6d 00  .np....TIM0...m.
  1d00: 65 a1 10 70 83 88 83 88 54 49 4d 30 0a 02 00 6d  e..p....TIM0...m
  1d10: 00 65 70 83 88 83 88 54 49 4d 30 0a 05 00 65 00  .ep....TIM0...e.
  1d20: 44 4d 41 31 7d 43 48 4e 46 0a 04 43 48 4e 46 70  DMA1}CHNF..CHNFp
  1d30: 54 4d 44 30 5b 31 a4 54 4d 44 30 14 4a 1e 53 54  TMD0[1.TMD0.J.ST
  1d40: 4d 5f 08 a0 05 52 45 47 46 a1 06 a4 54 4d 44 30  M_...REGF...TMD0
  1d50: a0 09 53 42 52 56 70 0a 07 60 a1 05 70 0a 03 60  ..SBRVp..`..p..`
  1d60: 70 0a 00 47 4d 55 45 70 60 47 4d 55 54 70 0a 00  p..GMUEp`GMUTp..
  1d70: 47 53 55 45 70 60 47 53 55 54 a0 4b 07 7b 43 48  GSUEp`GSUT.K.{CH
  1d80: 4e 46 0a 01 00 70 89 83 88 54 49 4d 30 0a 05 00  NF...p...TIM0...
  1d90: 02 44 4d 41 30 00 0a 00 0a 00 60 a0 09 94 60 0a  .DMA0.....`...`.
  1da0: 05 70 0a 05 60 a0 17 53 42 52 56 70 83 88 83 88  .p..`..SBRVp....
  1db0: 54 49 4d 30 0a 08 00 60 00 47 4d 55 54 a1 2d a0  TIM0...`.GMUT.-.
  1dc0: 17 47 42 43 53 70 83 88 83 88 54 49 4d 30 0a 07  .GBCSp....TIM0..
  1dd0: 00 60 00 47 4d 55 54 a1 13 70 83 88 83 88 54 49  .`.GMUT..p....TI
  1de0: 4d 30 0a 06 00 60 00 47 4d 55 54 7d 47 4d 55 45  M0...`.GMUT}GMUE
  1df0: 0a 07 47 4d 55 45 a1 2c a0 2a 7d 93 50 49 4f 30  ..GMUE.,.*}.PIO0
  1e00: ff 93 50 49 4f 30 0a 00 00 a0 19 7b 95 44 4d 41  ..PIO0.....{.DMA
  1e10: 30 ff 94 44 4d 41 30 0a 00 00 70 44 4d 41 30 50  0..DMA0...pDMA0P
  1e20: 49 4f 30 a0 4b 07 7b 43 48 4e 46 0a 04 00 70 89  IO0.K.{CHNF...p.
  1e30: 83 88 54 49 4d 30 0a 05 00 02 44 4d 41 31 00 0a  ..TIM0....DMA1..
  1e40: 00 0a 00 60 a0 09 94 60 0a 05 70 0a 05 60 a0 17  ...`...`..p..`..
  1e50: 53 42 52 56 70 83 88 83 88 54 49 4d 30 0a 08 00  SBRVp....TIM0...
  1e60: 60 00 47 53 55 54 a1 2d a0 17 47 42 43 53 70 83  `.GSUT.-..GBCSp.
  1e70: 88 83 88 54 49 4d 30 0a 07 00 60 00 47 53 55 54  ...TIM0...`.GSUT
  1e80: a1 13 70 83 88 83 88 54 49 4d 30 0a 06 00 60 00  ..p....TIM0...`.
  1e90: 47 53 55 54 7d 47 53 55 45 0a 07 47 53 55 45 a1  GSUT}GSUE..GSUE.
  1ea0: 2c a0 2a 7d 93 50 49 4f 31 ff 93 50 49 4f 31 0a  ,.*}.PIO1..PIO1.
  1eb0: 00 00 a0 19 7b 95 44 4d 41 31 ff 94 44 4d 41 31  ....{.DMA1..DMA1
  1ec0: 0a 00 00 70 44 4d 41 31 50 49 4f 31 7b 89 83 88  ...pDMA1PIO1{...
  1ed0: 54 49 4d 30 0a 00 00 04 50 49 4f 30 00 0a 00 0a  TIM0....PIO0....
  1ee0: 00 0a 03 60 70 83 88 83 88 54 49 4d 30 0a 01 00  ...`p....TIM0...
  1ef0: 60 00 61 70 61 47 4d 50 54 7b 89 83 88 54 49 4d  `.apaGMPT{...TIM
  1f00: 30 0a 00 00 04 50 49 4f 31 00 0a 00 0a 00 0a 03  0....PIO1.......
  1f10: 60 70 83 88 83 88 54 49 4d 30 0a 01 00 60 00 61  `p....TIM0...`.a
  1f20: 70 61 47 53 50 54 08 41 54 30 31 11 0a 0a 07 03  paGSPT.AT01.....
  1f30: 00 00 00 00 00 ef 08 41 54 30 32 11 0a 0a 07 00  .......AT02.....
  1f40: 00 00 00 00 00 90 08 41 54 30 33 11 0a 0a 07 00  .......AT03.....
  1f50: 00 00 00 00 00 c6 08 41 54 30 34 11 0a 0a 07 00  .......AT04.....
  1f60: 00 00 00 00 00 91 08 41 54 41 30 11 03 0a 1d 08  .......ATA0.....
  1f70: 41 54 41 31 11 03 0a 1d 08 41 54 41 32 11 03 0a  ATA1.....ATA2...
  1f80: 1d 08 41 54 41 33 11 03 0a 1d 08 41 54 41 42 11  ..ATA3.....ATAB.
  1f90: 03 0a 1d 8c 41 54 41 42 0a 00 43 4d 44 43 14 4c  ....ATAB..CMDC.L
  1fa0: 05 47 54 46 42 0b 77 43 4d 44 43 0a 38 60 72 60  .GTFB.wCMDC.8`r`
  1fb0: 0a 08 61 5b 13 41 54 41 42 61 0a 38 43 4d 44 58  ..a[.ATABa.8CMDX
  1fc0: 77 43 4d 44 43 0a 07 60 8c 41 54 41 42 72 60 0a  wCMDC..`.ATABr`.
  1fd0: 02 00 41 30 30 31 8c 41 54 41 42 72 60 0a 06 00  ..A001.ATABr`...
  1fe0: 41 30 30 35 70 68 43 4d 44 58 70 69 41 30 30 31  A005phCMDXpiA001
  1ff0: 70 6a 41 30 30 35 75 43 4d 44 43 14 42 24 47 54  pjA005uCMDC.B$GT
  2000: 46 5f 0a 70 69 5b 31 70 0a 00 43 4d 44 43 08 49  F_.pi[1p..CMDC.I
  2010: 44 34 39 0b 00 0c 08 49 44 35 39 0a 00 08 49 44  D49....ID59...ID
  2020: 35 33 0a 04 08 49 44 36 33 0b 00 0f 08 49 44 38  53...ID63....ID8
  2030: 38 0b 00 0f 08 49 52 44 59 0a 01 08 50 49 4f 54  8....IRDY...PIOT
  2040: 0a 00 08 44 4d 41 54 0a 00 a0 4d 05 93 87 69 0b  ...DMAT...M...i.
  2050: 00 02 8b 69 0a 62 49 57 34 39 70 49 57 34 39 49  ...i.bIW49pIW49I
  2060: 44 34 39 8b 69 0a 6a 49 57 35 33 70 49 57 35 33  D49.i.jIW53pIW53
  2070: 49 44 35 33 8b 69 0a 7e 49 57 36 33 70 49 57 36  ID53.i.~IW63pIW6
  2080: 33 49 44 36 33 8b 69 0a 76 49 57 35 39 70 49 57  3ID63.i.vIW59pIW
  2090: 35 39 49 44 35 39 8b 69 0a b0 49 57 38 38 70 49  59ID59.i..IW88pI
  20a0: 57 38 38 49 44 38 38 70 0a a0 67 a0 48 05 68 70  W88ID88p..g.H.hp
  20b0: 0a b0 67 7b 43 48 4e 46 0a 08 49 52 44 59 a0 12  ..g{CHNF..IRDY..
  20c0: 7b 43 48 4e 46 0a 10 00 70 50 49 4f 31 50 49 4f  {CHNF...pPIO1PIO
  20d0: 54 a1 0a 70 50 49 4f 30 50 49 4f 54 a0 27 7b 43  T..pPIO0PIOT.'{C
  20e0: 48 4e 46 0a 04 00 a0 12 7b 43 48 4e 46 0a 10 00  HNF.....{CHNF...
  20f0: 70 44 4d 41 31 44 4d 41 54 a1 0a 70 44 4d 41 30  pDMA1DMAT..pDMA0
  2100: 44 4d 41 54 a1 28 7b 43 48 4e 46 0a 02 49 52 44  DMAT.({CHNF..IRD
  2110: 59 70 50 49 4f 30 50 49 4f 54 a0 12 7b 43 48 4e  YpPIO0PIOT..{CHN
  2120: 46 0a 01 00 70 44 4d 41 30 44 4d 41 54 a0 47 04  F...pDMA0DMAT.G.
  2130: 90 90 7b 49 44 35 33 0a 04 00 7b 49 44 38 38 0b  ..{ID53...{ID88.
  2140: 00 ff 00 44 4d 41 54 70 89 83 88 54 49 4d 30 0a  ...DMATp...TIM0.
  2150: 05 00 02 44 4d 41 54 00 0a 00 0a 00 61 a0 09 94  ...DMAT.....a...
  2160: 61 0a 05 70 0a 05 61 47 54 46 42 41 54 30 31 7d  a..p..aGTFBAT01}
  2170: 0a 40 61 00 67 a1 46 04 a0 43 04 90 7b 49 44 36  .@a.g.F..C..{ID6
  2180: 33 0b 00 ff 00 50 49 4f 54 7b 89 83 88 54 49 4d  3....PIOT{...TIM
  2190: 30 0a 00 00 04 50 49 4f 54 00 0a 00 0a 00 0a 03  0....PIOT.......
  21a0: 60 7d 0a 20 83 88 83 88 54 49 4d 30 0a 0b 00 60  `}. ....TIM0...`
  21b0: 00 61 47 54 46 42 41 54 30 31 61 67 a0 38 49 52  .aGTFBAT01ag.8IR
  21c0: 44 59 7b 89 83 88 54 49 4d 30 0a 00 00 04 50 49  DY{...TIM0....PI
  21d0: 4f 54 00 0a 00 0a 00 0a 03 60 7d 0a 08 83 88 83  OT.......`}.....
  21e0: 88 54 49 4d 30 0a 0a 00 60 00 61 47 54 46 42 41  .TIM0...`.aGTFBA
  21f0: 54 30 31 61 67 a1 17 a0 15 7b 49 44 34 39 0b 00  T01ag....{ID49..
  2200: 04 00 47 54 46 42 41 54 30 31 0a 01 67 a0 24 90  ..GTFBAT01..g.$.
  2210: 7b 49 44 35 39 0b 00 01 00 7b 49 44 35 39 0a ff  {ID59....{ID59..
  2220: 00 47 54 46 42 41 54 30 33 7b 49 44 35 39 0a ff  .GTFBAT03{ID59..
  2230: 00 67 70 41 54 41 42 5b 31 a4 41 54 41 42 14 2c  .gpATAB[1.ATAB.,
  2240: 52 41 54 41 01 8c 68 0a 00 43 4d 44 4e 77 43 4d  RATA..h..CMDNwCM
  2250: 44 4e 0a 38 60 5b 13 68 0a 08 60 52 45 54 42 70  DN.8`[.h..`RETBp
  2260: 52 45 54 42 5b 31 a4 52 45 54 42 5b 82 43 04 55  RETB[1.RETB[.C.U
  2270: 53 42 5f 08 5f 41 44 52 0c 02 00 07 00 08 5f 53  SB_._ADR......_S
  2280: 33 44 0a 02 08 5f 50 52 57 12 06 02 0a 09 0a 04  3D..._PRW.......
  2290: 10 1f 5c 5f 47 50 45 14 18 5f 4c 30 39 00 86 5c  ..\_GPE.._L09..\
  22a0: 2f 03 5f 53 42 5f 50 43 49 30 55 53 42 5f 0a 02  /._SB_PCI0USB_..
  22b0: 5b 82 22 55 53 42 31 08 5f 41 44 52 0c 03 00 07  [."USB1._ADR....
  22c0: 00 08 53 53 33 44 0a 02 08 5f 50 52 57 12 06 02  ..SS3D..._PRW...
  22d0: 0a 09 0a 04 5b 82 0f 41 43 39 5f 08 5f 41 44 52  ....[..AC9_._ADR
  22e0: 0c 05 00 07 00 5b 82 35 4d 43 39 5f 08 5f 41 44  .....[.5MC9_._AD
  22f0: 52 0c 06 00 07 00 5b 80 41 43 4c 4b 02 0a 41 0a  R.....[.ACLK..A.
  2300: 01 5b 81 0d 41 43 4c 4b 01 00 06 4d 43 39 50 02  .[..ACLK...MC9P.
  2310: 08 5f 50 52 57 12 06 02 0a 0d 0a 04 08 5f 50 52  ._PRW........_PR
  2320: 57 12 06 02 0a 05 0a 04 10 1a 5c 5f 47 50 45 14  W.........\_GPE.
  2330: 13 5f 4c 30 35 00 86 5c 2e 5f 53 42 5f 50 43 49  ._L05..\._SB_PCI
  2340: 30 0a 02 08 53 4c 50 53 0a 00 5b 82 3a 53 4c 50  0...SLPS..[.:SLP
  2350: 42 08 5f 48 49 44 0c 41 d0 0c 0e 14 0d 53 42 45  B._HID.A.....SBE
  2360: 56 00 86 53 4c 50 42 0a 80 10 1c 5c 5f 47 50 45  V..SLPB....\_GPE
  2370: 14 15 5f 4c 30 30 00 5c 2f 03 5f 53 42 5f 53 4c  .._L00.\/._SB_SL
  2380: 50 42 53 42 45 56 5b 80 46 4e 4f 52 01 0b 4c 08  PBSBEV[.FNOR..L.
  2390: 0a 04 10 44 17 5c 5f 54 5a 5f 08 54 48 42 46 11  ...D.\_TZ_.THBF.
  23a0: 07 0a 04 00 00 00 00 14 18 4b 45 4c 56 01 7b 68  .........KELV.{h
  23b0: 0a ff 60 77 60 0a 0a 60 72 60 0b ac 0a 60 a4 60  ..`w`..`r`...`.`
  23c0: 08 50 4c 43 59 0a 00 5b 80 54 48 4f 52 01 0a 72  .PLCY..[.THOR..r
  23d0: 0a 02 5b 81 10 54 48 4f 52 01 45 43 4d 49 08 45  ..[..THOR.ECMI.E
  23e0: 43 4d 44 08 5b 86 1c 45 43 4d 49 45 43 4d 44 01  CMD.[..ECMIECMD.
  23f0: 00 40 78 54 4d 49 4e 08 54 4d 41 58 08 54 43 52  .@xTMIN.TMAX.TCR
  2400: 54 08 08 54 53 50 5f 0a 05 08 54 43 31 5f 0a 02  T..TSP_...TC1_..
  2410: 08 54 43 32 5f 0a 04 5b 80 54 53 4e 31 01 0b 20  .TC2_..[.TSN1.. 
  2420: 0c 0a 01 5b 81 0b 54 53 4e 31 01 43 55 52 54 08  ...[..TSN1.CURT.
  2430: 14 07 54 43 48 47 00 a3 14 38 52 54 4d 50 00 80  ..TCHG...8RTMP..
  2440: 43 55 52 54 60 74 60 0a b3 60 80 60 60 72 60 0a  CURT`t`..`.``r`.
  2450: 01 60 7b 60 0a ff 60 70 60 61 78 60 0a 0a 60 62  .`{`..`p`ax`..`b
  2460: 74 61 62 60 7a 60 0a 01 60 70 60 44 42 47 38 a4  tab`z`..`p`DBG8.
  2470: 60 5b 85 44 09 54 48 52 4d 14 0f 5f 43 52 54 00  `[.D.THRM.._CRT.
  2480: a4 4b 45 4c 56 54 43 52 54 14 21 5f 54 4d 50 00  .KELVTCRT.!_TMP.
  2490: a0 0f 93 54 43 52 54 0a 4f a4 4b 45 4c 56 0a 1e  ...TCRT.O.KELV..
  24a0: a1 0a a4 4b 45 4c 56 52 54 4d 50 08 5f 50 53 4c  ...KELVRTMP._PSL
  24b0: 12 0c 01 5c 2e 5f 50 52 5f 43 50 55 31 14 10 5f  ...\._PR_CPU1.._
  24c0: 54 53 50 00 77 54 53 50 5f 0a 0a 60 a4 60 14 0b  TSP.wTSP_..`.`..
  24d0: 5f 54 43 31 00 a4 54 43 31 5f 14 0b 5f 54 43 32  _TC1..TC1_.._TC2
  24e0: 00 a4 54 43 32 5f 14 20 5f 50 53 56 00 a0 0e 50  ..TC2_. _PSV...P
  24f0: 4c 43 59 a4 4b 45 4c 56 54 4d 49 4e a1 0a a4 4b  LCY.KELVTMIN...K
  2500: 45 4c 56 54 4d 41 58 5b 80 53 49 4f 52 01 0b 4c  ELVTMAX[.SIOR..L
  2510: 08 0a 04 5b 80 47 50 4f 42 01 0b 4c 08 0a 04 5b  ...[.GPOB..L...[
  2520: 81 47 0a 47 50 4f 42 01 47 50 30 30 01 47 50 30  .G.GPOB.GP00.GP0
  2530: 31 01 47 50 30 32 01 47 50 30 33 01 47 50 30 34  1.GP02.GP03.GP04
  2540: 01 47 50 30 35 01 47 50 30 36 01 47 50 30 37 01  .GP05.GP06.GP07.
  2550: 47 50 30 38 01 47 50 30 39 01 47 50 30 41 01 47  GP08.GP09.GP0A.G
  2560: 50 30 42 01 47 50 30 43 01 47 50 30 44 01 47 50  P0B.GP0C.GP0D.GP
  2570: 30 45 01 47 50 30 46 01 47 50 31 30 01 47 50 31  0E.GP0F.GP10.GP1
  2580: 31 01 47 50 31 32 01 47 50 31 33 01 47 50 31 34  1.GP12.GP13.GP14
  2590: 01 47 50 31 35 01 47 50 31 36 01 47 50 31 37 01  .GP15.GP16.GP17.
  25a0: 47 50 31 38 01 47 50 31 39 01 47 50 31 41 01 47  GP18.GP19.GP1A.G
  25b0: 50 31 42 01 47 50 31 43 01 47 50 31 44 01 47 50  P1B.GP1C.GP1D.GP
  25c0: 31 45 01 47 50 31 46 01 5b 80 5c 2f 04 5f 53 42  1E.GP1F.[.\/._SB
  25d0: 5f 50 43 49 30 50 4d 55 5f 50 52 57 43 02 0a 54  _PCI0PMU_PRWC..T
  25e0: 0a 01 5b 81 29 5c 2f 04 5f 53 42 5f 50 43 49 30  ..[.)\/._SB_PCI0
  25f0: 50 4d 55 5f 50 52 57 43 01 47 50 4f 53 02 50 57  PMU_PRWC.GPOS.PW
  2600: 43 31 01 50 57 43 32 01 50 57 43 33 01 5b 80 5c  C1.PWC2.PWC3.[.\
  2610: 2f 03 5f 53 42 5f 50 43 49 30 53 32 4b 5f 02 0a  /._SB_PCI0S2K_..
  2620: 52 0a 01 5b 81 18 5c 2f 03 5f 53 42 5f 50 43 49  R..[..\/._SB_PCI
  2630: 30 53 32 4b 5f 01 00 07 53 54 50 5f 01 5b 80 41  0S2K_...STP_.[.A
  2640: 43 49 4f 01 0b 2f 08 0a 01 5b 81 0b 41 43 49 4f  CIO../...[..ACIO
  2650: 01 41 43 46 47 08 10 4c 0f 5f 53 49 5f 14 49 0e  .ACFG..L._SI_.I.
  2660: 5f 53 53 54 01 a0 4f 0d 68 a0 3d 93 68 0a 01 70  _SST..O.h.=.h..p
  2670: 0a 01 47 50 30 35 70 0a 00 53 54 50 5f 70 0a 01  ..GP05p..STP_p..
  2680: 47 50 30 38 70 0a 01 47 50 30 42 70 0a 01 47 50  GP08p..GP0Bp..GP
  2690: 30 43 70 0a 00 47 50 30 30 70 0a 00 47 50 4f 53  0Cp..GP00p..GPOS
  26a0: 70 0a 01 50 57 43 33 a0 3d 93 68 0a 02 70 0a 01  p..PWC3.=.h..p..
  26b0: 47 50 30 35 70 0a 00 53 54 50 5f 70 0a 01 47 50  GP05p..STP_p..GP
  26c0: 30 38 70 0a 01 47 50 30 42 70 0a 01 47 50 30 43  08p..GP0Bp..GP0C
  26d0: 70 0a 00 47 50 30 30 70 0a 00 47 50 4f 53 70 0a  p..GP00p..GPOSp.
  26e0: 01 50 57 43 33 a0 2f 93 68 0a 03 70 0a 00 47 50  .PWC3./.h..p..GP
  26f0: 30 35 70 0a 01 53 54 50 5f 70 0a 00 47 50 30 38  05p..STP_p..GP08
  2700: 70 0a 00 47 50 30 42 70 0a 00 47 50 30 30 70 0a  p..GP0Bp..GP00p.
  2710: 01 47 50 4f 53 a0 2f 93 68 0a 04 70 0a 00 47 50  .GPOS./.h..p..GP
  2720: 30 35 70 0a 01 53 54 50 5f 70 0a 00 47 50 30 38  05p..STP_p..GP08
  2730: 70 0a 00 47 50 30 42 70 0a 00 47 50 30 30 70 0a  p..GP0Bp..GP00p.
  2740: 02 47 50 4f 53 a1 01 14 0b 5f 4d 53 47 01 a0 02  .GPOS...._MSG...
  2750: 68 a1 01 14 49 0c 5f 50 54 53 01 70 68 44 42 47  h...I._PTS.phDBG
  2760: 38 a0 23 92 5c 2f 03 5f 53 42 5f 50 43 49 30 4f  8.#.\/._SB_PCI0O
  2770: 53 46 4c 70 0a 03 5c 2f 03 5f 53 42 5f 50 43 49  SFLp..\/._SB_PCI
  2780: 30 57 32 46 47 a0 16 93 68 0a 01 a2 10 57 41 4b  0W2FG...h....WAK
  2790: 53 5b 21 0a 50 70 0a 01 57 41 4b 53 a0 33 93 68  S[!.Pp..WAKS.3.h
  27a0: 0a 01 70 5c 2f 04 5f 53 42 5f 50 43 49 30 4d 43  ..p\/._SB_PCI0MC
  27b0: 39 5f 4d 43 39 50 50 54 42 30 70 0a 00 5c 2f 04  9_MC9PPTB0p..\/.
  27c0: 5f 53 42 5f 50 43 49 30 4d 43 39 5f 4d 43 39 50  _SB_PCI0MC9_MC9P
  27d0: 70 68 5c 2f 03 5f 53 42 5f 50 43 49 30 53 50 4c  ph\/._SB_PCI0SPL
  27e0: 56 a2 10 50 53 31 53 5b 21 0a 50 70 0a 01 50 53  V..PS1S[!.Pp..PS
  27f0: 31 53 70 0a 01 50 53 31 45 a0 23 92 5c 2f 03 5f  1Sp..PS1E.#.\/._
  2800: 53 42 5f 50 43 49 30 4f 53 46 4c 70 0a 03 5c 2f  SB_PCI0OSFLp..\/
  2810: 03 5f 53 42 5f 50 43 49 30 57 32 46 47 14 41 0c  ._SB_PCI0W2FG.A.
  2820: 5f 57 41 4b 01 79 68 0a 04 44 42 47 38 86 5c 2e  _WAK.yh..DBG8.\.
  2830: 5f 53 42 5f 50 57 52 42 0a 02 5b 22 0b 94 02 70  _SB_PWRB..["...p
  2840: 0a 01 53 57 42 54 70 0a 01 50 57 42 54 a0 47 04  ..SWBTp..PWBT.G.
  2850: 91 93 68 0a 01 93 68 0a 04 5c 2f 04 5f 53 42 5f  ..h...h..\/._SB_
  2860: 50 43 49 30 53 42 52 47 45 4e 46 47 70 0a 00 5c  PCI0SBRGENFGp..\
  2870: 2f 04 5f 53 42 5f 50 43 49 30 53 42 52 47 43 52  /._SB_PCI0SBRGCR
  2880: 43 46 5c 2f 04 5f 53 42 5f 50 43 49 30 53 42 52  CF\/._SB_PCI0SBR
  2890: 47 45 58 46 47 a0 1d 93 68 0a 01 70 50 54 42 30  GEXFG...h..pPTB0
  28a0: 5c 2f 04 5f 53 42 5f 50 43 49 30 4d 43 39 5f 4d  \/._SB_PCI0MC9_M
  28b0: 43 39 50 70 0a 00 50 53 31 45 70 0a 00 5c 2f 03  C9Pp..PS1Ep..\/.
  28c0: 5f 53 42 5f 50 43 49 30 57 32 46 47 a0 05 94 68  _SB_PCI0W2FG...h
  28d0: 0a 01 86 5c 2e 5f 54 5a 5f 54 48 52 4d 0a 81 5b  ...\._TZ_THRM..[
  28e0: 80 47 50 53 30 01 0b 22 08 0a 01 5b 81 0b 47 50  .GPS0.."...[..GP
  28f0: 53 30 01 53 57 42 54 01 5b 80 57 41 4b 50 01 0b  S0.SWBT.[.WAKP..
  2900: 28 08 0a 01 5b 81 0d 57 41 4b 50 01 00 07 57 41  (...[..WAKP...WA
  2910: 4b 53 01 5b 80 50 4d 53 30 01 0b 00 08 0a 04 5b  KS.[.PMS0......[
  2920: 81 16 50 4d 53 30 01 00 0a 52 54 43 53 01 00 0d  ..PMS0...RTCS...
  2930: 50 57 42 54 01 00 07 5b 80 53 4d 49 30 01 0b 04  PWBT...[.SMI0...
  2940: 08 0a 01 5b 81 0d 53 4d 49 30 01 00 02 47 53 4d  ...[..SMI0...GSM
  2950: 49 01 5b 80 53 4d 49 31 01 0b 2a 08 0a 01 5b 81  I.[.SMI1..*...[.
  2960: 0d 53 4d 49 31 01 00 05 45 53 4d 49 01 5b 80 49  .SMI1...ESMI.[.I
  2970: 4f 54 50 01 0b 28 08 0a 04 5b 81 14 49 4f 54 50  OTP..(...[..IOTP
  2980: 01 00 0f 50 53 31 53 01 00 0f 50 53 31 45 01 5b  ...PS1S...PS1E.[
  2990: 80 54 45 4d 50 01 0a 80 0a 01 5b 81 0b 54 45 4d  .TEMP.....[..TEM
  29a0: 50 01 44 42 47 38 08 5b 80 44 45 42 30 01 0a 90  P.DBG8.[.DEB0...
  29b0: 0a 02 5b 81 0b 44 45 42 30 02 44 42 47 39 10     ..[..DEB0.DBG9.

FACS @ 0x27ff8000
  0000: 46 41 43 53 40 00 00 00 00 00 00 00 00 00 00 00  FACS@...........
  0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

FACP @ 0x27ff0030
  0000: 46 41 43 50 74 00 00 00 01 3a 41 4d 49 49 4e 54  FACPt....:AMIINT
  0010: 56 49 41 5f 4b 37 20 20 11 00 00 00 4d 53 46 54  VIA_K7  ....MSFT
  0020: 97 00 00 00 00 80 ff 27 b0 00 ff 27 00 00 09 00  .......'...'....
  0030: 2f 08 00 00 e1 1e 1f 00 00 08 00 00 00 00 00 00  /...............
  0040: 04 08 00 00 00 00 00 00 22 00 00 00 08 08 00 00  ........".......
  0050: 20 08 00 00 00 00 00 00 04 02 01 04 04 00 00 00   ...............
  0060: 65 00 e9 03 00 04 10 00 00 04 7d 7e 32 00 00 00  e.........}~2...
  0070: a5 00 00 00                                      ....

RSDT @ 0x27ff0000
  0000: 52 53 44 54 28 00 00 00 01 a0 41 4d 49 49 4e 54  RSDT(.....AMIINT
  0010: 56 49 41 5f 4b 37 20 20 10 00 00 00 4d 53 46 54  VIA_K7  ....MSFT
  0020: 97 00 00 00 30 00 ff 27                          ....0..'

RSD PTR @ 0xfaa80
  0000: 52 53 44 20 50 54 52 20 84 41 4d 49 20 20 20 00  RSD PTR .AMI   .
  0010: 00 00 ff 27                                      ...'

-- 
Sitsofe | http://sucs.org/~sits/

