Return-Path: <linux-kernel-owner+w=401wt.eu-S1756110AbYGOHoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbYGOHoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 03:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbYGOHoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 03:44:06 -0400
Received: from mail.gmx.net ([213.165.64.20]:53232 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754709AbYGOHn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 03:43:59 -0400
X-Authenticated: #23500402
X-Provags-ID: V01U2FsdGVkX19O7HIRADhOVMzXQ8GB/oNw/IfDXYGd+HG5BRKKXi
	b7N17vl0LkPFyP
Date: Tue, 15 Jul 2008 09:43:56 +0200
From: Andre Prendel <andre_prendel@gmx.de>
To: Zhao Yakui <yakui.zhao@intel.com>
Cc: Andre Prendel <andre_prendel@gmx.de>, Zhang Rui <rui.zhang@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       kernel-testers@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: ACPI Error under 2.6.26-rc*
Message-ID: <20080715074356.GB4724@linux.int.dgn.ag>
References: <20080709083829.GA5748@linux.int.dgn.ag> <200807102255.23090.rjw@sisk.pl> <1215739210.1617.28.camel@rzhang-dt> <1215739682.1617.32.camel@rzhang-dt> <20080714080914.GA4965@linux.int.dgn.ag> <1216030982.32159.38.camel@yakui_zhao.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216030982.32159.38.camel@yakui_zhao.sh.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 06:23:02PM +0800, Zhao Yakui wrote:
> > Hello Rui,
> > 
> > that's quite strange. Booting the system to get an acpidump I have
> > looked at the dmesg output and there is no ACPI Error like the one
> > above. There is only an ACPI Exeption.
> > 
> > [...]
> > Jul 13 22:00:18 ubuntu kernel: [    0.104111] ACPI: Core revision 20080321
> > Jul 13 22:00:18 ubuntu kernel: [    0.104259] ACPI Exception
> > (tbxface-0629): AE_NO_ACPI_TABLES, While loading namespace from ACPI
> > tables [20080321]
> > [...]
> > 
> Will you please boot the 2.6.26-rc* kernel with the option of acpi=off
> and attach the output of acpidump?

root@ubuntu:/home/andre/src/acpi/pmtools-20071116/acpidump# ./acpidump
ACPI tables were not found. If you know location of RSD PTR table
(from dmesg, etc), supply it with either --addr or -a option
 
> >>From the  2.6.25.10 kernel log it seems that the ACPI Data/NVS region is
> located in the following e820 memory region:
>   > BIOS-e820: 000000001fff0000 - 000000001fff8000 (ACPI data)
>   >BIOS-e820: 000000001fff8000 - 0000000020000000 (ACPI NVS)
> 
> >>From the 2.6.26-rc* kernel log it seems that the ACPI Data/NVS region is
> located in the following e820 memory region:
>     BIOS-e820: 0000000021ff0000 - 0000000021ff8000 (ACPI data)
>     BIOS-e820: 0000000021ff8000 - 0000000022000000 (ACPI NVS)
> 
> Please also confirm whether the kernel 2.6.25.10 and 2.6.26-rc* use the
> same bios.

It is the same machine and the same bios settings.
 
> > Booting again I found the error again
> > 
> > [...]
> > Jul 13 22:10:50 ubuntu kernel: [    0.000000] ACPI Error
> > (tbutils-0472): Invalid length 0x0 in RSDT/XSDT [20080321]
> > [...]
> > 
> > and acpidump says:
> > root@ubuntu:/home/andre/src/acpi/pmtools-20071116/acpidump#
> > ./acpidumpACPI tables were not found. If you know location of RSD PTR
> > table (from dmesg, etc), supply it with either --addr or -a option
> > 
> > Linux 2.6.25.10 always works.
> Will you please boot the working kernel and attach the output of
> acpidump?

DSDT @ 0x1fff0100
  0000: 44 53 44 54 c2 33 00 00 01 73 53 69 53 00 00 00  DSDT.3...sSiS...
  0010: 37 33 35 00 00 00 00 00 00 01 00 00 4d 53 46 54  735.........MSFT
  0020: 0d 00 00 01 08 41 50 49 43 0a 00 14 0c 5f 50 49  .....APIC...._PI
  0030: 43 01 70 68 41 50 49 43 10 13 5c 5f 50 52 5f 5b  C.phAPIC..\_PR_[
  0040: 83 0b 43 50 55 31 01 00 00 00 00 00 08 5c 5f 53  ..CPU1.......\_S
  0050: 30 5f 12 0a 04 0a 00 0a 00 0a 00 0a 00 08 5c 5f  0_............\_
  0060: 53 31 5f 12 0a 04 0a 01 0a 00 0a 00 0a 00 08 5c  S1_............\
  0070: 5f 53 34 5f 12 0a 04 0a 04 0a 00 0a 00 0a 00 08  _S4_............
  0080: 5c 5f 53 35 5f 12 0a 04 0a 05 0a 00 0a 00 0a 00  \_S5_...........
  0090: 14 41 05 4d 43 54 48 02 a0 09 95 87 68 87 69 a4  .A.MCTH.....h.i.
  00a0: 0a 00 72 87 68 0a 01 60 08 42 55 46 30 11 02 60  ..r.h..`.BUF0..`
  00b0: 08 42 55 46 31 11 02 60 70 68 42 55 46 30 70 69  .BUF1..`phBUF0pi
  00c0: 42 55 46 31 a2 1b 60 76 60 a0 12 93 83 88 42 55  BUF1..`v`.....BU
  00d0: 46 30 60 00 83 88 42 55 46 31 60 00 a1 03 a4 00  F0`...BUF1`.....
  00e0: a4 01 10 89 12 03 5c 5f 53 42 5f 5b 82 82 0b 03  ......\_SB_[....
  00f0: 50 43 49 30 08 5f 48 49 44 0c 41 d0 0a 03 08 5f  PCI0._HID.A...._
  0100: 41 44 52 0a 00 08 5f 42 42 4e 0a 00 08 43 52 53  ADR..._BBN...CRS
  0110: 5f 11 46 0a 0a a2 88 0d 00 02 0c 00 00 00 00 00  _.F.............
  0120: ff 00 00 00 00 01 47 01 f8 0c f8 0c 01 08 88 0d  ......G.........
  0130: 00 01 0c 03 00 00 00 00 f7 0c 00 00 f8 0c 88 0d  ................
  0140: 00 01 0c 03 00 00 00 0d ff ff 00 00 00 f3 87 17  ................
  0150: 00 00 0c 03 00 00 00 00 00 00 0a 00 ff ff 0b 00  ................
  0160: 00 00 00 00 00 00 02 00 87 17 00 00 0c 03 00 00  ................
  0170: 00 00 00 b0 0c 00 ff ff 0d 00 00 00 00 00 00 50  ...............P
  0180: 01 00 87 17 00 00 0c 03 00 00 00 00 00 00 00 20  ............... 
  0190: ff ff df ff 00 00 00 00 00 00 e0 df 87 17 00 00  ................
  01a0: 0c 03 00 00 00 00 00 10 e0 fe ff ff df ff 00 00  ................
  01b0: 00 00 00 f0 ff 00 79 00 5b 80 54 4d 45 4d 02 0a  ......y.[.TMEM..
  01c0: 60 0a 05 5b 81 21 54 4d 45 4d 01 4d 45 4d 31 08  `..[.!TMEM.MEM1.
  01d0: 4d 45 4d 32 08 4d 45 4d 33 08 4d 45 4d 34 08 4d  MEM2.MEM3.MEM4.M
  01e0: 45 4d 50 04 00 04 08 53 52 41 4d 12 23 10 0a 02  EMP....SRAM.#...
  01f0: 0a 08 0a 08 0a 10 0a 04 0a 10 0a 10 0a 20 0a 08  ............. ..
  0200: 0a 20 0a 20 0a 40 0a 04 0b 00 01 0a 40 0a 80 08  . . .@......@...
  0210: 54 4f 4d 5f 0a 00 14 3e 4d 53 49 5a 02 7b 69 4d  TOM_...>MSIZ.{iM
  0220: 45 4d 50 60 7b 68 0a 0f 61 70 00 62 7b 68 0a 20  EMP`{h..ap.b{h. 
  0230: 63 a0 21 60 70 83 88 53 52 41 4d 61 00 62 79 62  c.!`p..SRAMa.byb
  0240: 0a 02 62 a0 07 63 79 62 0a 01 62 77 62 0c 00 00  ..b..cyb..bwb...
  0250: 10 00 62 a4 62 14 4c 05 4d 44 45 54 00 a0 05 54  ..b.b.L.MDET...T
  0260: 4f 4d 5f a1 49 04 a0 3e 46 4c 41 47 70 4d 53 49  OM_.I..>FLAGpMSI
  0270: 5a 4d 45 4d 31 0a 01 60 72 4d 53 49 5a 4d 45 4d  ZMEM1..`rMSIZMEM
  0280: 32 0a 02 60 60 72 4d 53 49 5a 4d 45 4d 33 0a 04  2..``rMSIZMEM3..
  0290: 60 60 72 4d 53 49 5a 4d 45 4d 34 0a 08 60 60 70  ``rMSIZMEM4..``p
  02a0: 60 54 4f 4d 5f a1 07 a4 0c 00 00 00 20 a4 54 4f  `TOM_....... .TO
  02b0: 4d 5f 14 11 54 46 43 53 00 74 4d 44 45 54 0b c0  M_..TFCS.tMDET..
  02c0: 7f 60 a4 60 08 46 4c 41 47 0a 01 08 4f 53 46 4c  .`.`.FLAG...OSFL
  02d0: 0a 00 14 44 04 5f 49 4e 49 00 5c 2f 04 5f 53 42  ...D._INI.\/._SB
  02e0: 5f 50 43 49 30 53 42 52 47 49 4f 44 54 a0 20 4d  _PCI0SBRGIODT. M
  02f0: 43 54 48 5c 5f 4f 53 5f 0d 4d 69 63 72 6f 73 6f  CTH\_OS_.Microso
  0300: 66 74 20 57 69 6e 64 6f 77 73 20 4e 54 00 a1 08  ft Windows NT...
  0310: 70 0a 01 4f 53 46 4c 14 12 5f 52 45 47 02 a0 0b  p..OSFL.._REG...
  0320: 93 68 0a 02 70 69 46 4c 41 47 14 38 5f 43 52 53  .h..piFLAG.8_CRS
  0330: 00 8a 43 52 53 5f 0a 76 54 4d 45 4d 8a 43 52 53  ..CRS_.vTMEM.CRS
  0340: 5f 0a 82 54 4c 45 4e 70 4d 44 45 54 54 4d 45 4d  _..TLENpMDETTMEM
  0350: 74 0c 00 00 c0 fe 54 4d 45 4d 54 4c 45 4e a4 43  t.....TMEMTLEN.C
  0360: 52 53 5f 14 18 5f 50 52 54 00 a0 0a 41 50 49 43  RS_.._PRT...APIC
  0370: a4 50 49 43 30 a1 06 a4 50 49 43 31 08 50 49 43  .PIC0...PIC1.PIC
  0380: 30 12 41 1d 21 12 0d 04 0c ff ff 01 00 0a 00 0a  0.A.!...........
  0390: 00 0a 10 12 0d 04 0c ff ff 01 00 0a 01 0a 00 0a  ................
  03a0: 11 12 0d 04 0c ff ff 01 00 0a 02 0a 00 0a 12 12  ................
  03b0: 0d 04 0c ff ff 01 00 0a 03 0a 00 0a 13 12 0d 04  ................
  03c0: 0c ff ff 02 00 0a 00 0a 00 0a 17 12 0d 04 0c ff  ................
  03d0: ff 02 00 0a 01 0a 00 0a 11 12 0d 04 0c ff ff 02  ................
  03e0: 00 0a 02 0a 00 0a 12 12 0d 04 0c ff ff 02 00 0a  ................
  03f0: 03 0a 00 0a 13 12 0d 04 0c ff ff 03 00 0a 00 0a  ................
  0400: 00 0a 16 12 0d 04 0c ff ff 09 00 0a 00 0a 00 0a  ................
  0410: 10 12 0d 04 0c ff ff 09 00 0a 01 0a 00 0a 11 12  ................
  0420: 0d 04 0c ff ff 09 00 0a 02 0a 00 0a 12 12 0d 04  ................
  0430: 0c ff ff 09 00 0a 03 0a 00 0a 13 12 0d 04 0c ff  ................
  0440: ff 0b 00 0a 00 0a 00 0a 11 12 0d 04 0c ff ff 0b  ................
  0450: 00 0a 01 0a 00 0a 12 12 0d 04 0c ff ff 0b 00 0a  ................
  0460: 02 0a 00 0a 13 12 0d 04 0c ff ff 0b 00 0a 03 0a  ................
  0470: 00 0a 10 12 0d 04 0c ff ff 0d 00 0a 00 0a 00 0a  ................
  0480: 12 12 0d 04 0c ff ff 0d 00 0a 01 0a 00 0a 13 12  ................
  0490: 0d 04 0c ff ff 0d 00 0a 02 0a 00 0a 10 12 0d 04  ................
  04a0: 0c ff ff 0d 00 0a 03 0a 00 0a 11 12 0d 04 0c ff  ................
  04b0: ff 0f 00 0a 00 0a 00 0a 13 12 0d 04 0c ff ff 0f  ................
  04c0: 00 0a 01 0a 00 0a 10 12 0d 04 0c ff ff 0f 00 0a  ................
  04d0: 02 0a 00 0a 11 12 0d 04 0c ff ff 0f 00 0a 03 0a  ................
  04e0: 00 0a 12 12 0d 04 0c ff ff 11 00 0a 00 0a 00 0a  ................
  04f0: 11 12 0d 04 0c ff ff 11 00 0a 01 0a 00 0a 12 12  ................
  0500: 0d 04 0c ff ff 11 00 0a 02 0a 00 0a 13 12 0d 04  ................
  0510: 0c ff ff 11 00 0a 03 0a 00 0a 10 12 0d 04 0c ff  ................
  0520: ff 13 00 0a 00 0a 00 0a 10 12 0d 04 0c ff ff 13  ................
  0530: 00 0a 01 0a 00 0a 11 12 0d 04 0c ff ff 13 00 0a  ................
  0540: 02 0a 00 0a 12 12 0d 04 0c ff ff 13 00 0a 03 0a  ................
  0550: 00 0a 13 08 50 49 43 31 12 49 2d 21 12 15 04 0c  ....PIC1.I-!....
  0560: ff ff 01 00 0a 00 5c 2e 5f 53 42 5f 4c 4e 4b 41  ......\._SB_LNKA
  0570: 0a 00 12 15 04 0c ff ff 01 00 0a 01 5c 2e 5f 53  ............\._S
  0580: 42 5f 4c 4e 4b 42 0a 00 12 15 04 0c ff ff 01 00  B_LNKB..........
  0590: 0a 02 5c 2e 5f 53 42 5f 4c 4e 4b 43 0a 00 12 15  ..\._SB_LNKC....
  05a0: 04 0c ff ff 01 00 0a 03 5c 2e 5f 53 42 5f 4c 4e  ........\._SB_LN
  05b0: 4b 44 0a 00 12 15 04 0c ff ff 02 00 0a 00 5c 2e  KD............\.
  05c0: 5f 53 42 5f 4c 4e 4b 48 0a 00 12 15 04 0c ff ff  _SB_LNKH........
  05d0: 02 00 0a 01 5c 2e 5f 53 42 5f 4c 4e 4b 42 0a 00  ....\._SB_LNKB..
  05e0: 12 15 04 0c ff ff 02 00 0a 02 5c 2e 5f 53 42 5f  ..........\._SB_
  05f0: 4c 4e 4b 43 0a 00 12 15 04 0c ff ff 02 00 0a 03  LNKC............
  0600: 5c 2e 5f 53 42 5f 4c 4e 4b 44 0a 00 12 15 04 0c  \._SB_LNKD......
  0610: ff ff 03 00 0a 00 5c 2e 5f 53 42 5f 4c 4e 4b 47  ......\._SB_LNKG
  0620: 0a 00 12 15 04 0c ff ff 09 00 0a 00 5c 2e 5f 53  ............\._S
  0630: 42 5f 4c 4e 4b 41 0a 00 12 15 04 0c ff ff 09 00  B_LNKA..........
  0640: 0a 01 5c 2e 5f 53 42 5f 4c 4e 4b 42 0a 00 12 15  ..\._SB_LNKB....
  0650: 04 0c ff ff 09 00 0a 02 5c 2e 5f 53 42 5f 4c 4e  ........\._SB_LN
  0660: 4b 43 0a 00 12 15 04 0c ff ff 09 00 0a 03 5c 2e  KC............\.
  0670: 5f 53 42 5f 4c 4e 4b 44 0a 00 12 15 04 0c ff ff  _SB_LNKD........
  0680: 0b 00 0a 00 5c 2e 5f 53 42 5f 4c 4e 4b 42 0a 00  ....\._SB_LNKB..
  0690: 12 15 04 0c ff ff 0b 00 0a 01 5c 2e 5f 53 42 5f  ..........\._SB_
  06a0: 4c 4e 4b 43 0a 00 12 15 04 0c ff ff 0b 00 0a 02  LNKC............
  06b0: 5c 2e 5f 53 42 5f 4c 4e 4b 44 0a 00 12 15 04 0c  \._SB_LNKD......
  06c0: ff ff 0b 00 0a 03 5c 2e 5f 53 42 5f 4c 4e 4b 41  ......\._SB_LNKA
  06d0: 0a 00 12 15 04 0c ff ff 0d 00 0a 00 5c 2e 5f 53  ............\._S
  06e0: 42 5f 4c 4e 4b 43 0a 00 12 15 04 0c ff ff 0d 00  B_LNKC..........
  06f0: 0a 01 5c 2e 5f 53 42 5f 4c 4e 4b 44 0a 00 12 15  ..\._SB_LNKD....
  0700: 04 0c ff ff 0d 00 0a 02 5c 2e 5f 53 42 5f 4c 4e  ........\._SB_LN
  0710: 4b 41 0a 00 12 15 04 0c ff ff 0d 00 0a 03 5c 2e  KA............\.
  0720: 5f 53 42 5f 4c 4e 4b 42 0a 00 12 15 04 0c ff ff  _SB_LNKB........
  0730: 0f 00 0a 00 5c 2e 5f 53 42 5f 4c 4e 4b 44 0a 00  ....\._SB_LNKD..
  0740: 12 15 04 0c ff ff 0f 00 0a 01 5c 2e 5f 53 42 5f  ..........\._SB_
  0750: 4c 4e 4b 41 0a 00 12 15 04 0c ff ff 0f 00 0a 02  LNKA............
  0760: 5c 2e 5f 53 42 5f 4c 4e 4b 42 0a 00 12 15 04 0c  \._SB_LNKB......
  0770: ff ff 0f 00 0a 03 5c 2e 5f 53 42 5f 4c 4e 4b 43  ......\._SB_LNKC
  0780: 0a 00 12 15 04 0c ff ff 11 00 0a 00 5c 2e 5f 53  ............\._S
  0790: 42 5f 4c 4e 4b 42 0a 00 12 15 04 0c ff ff 11 00  B_LNKB..........
  07a0: 0a 01 5c 2e 5f 53 42 5f 4c 4e 4b 43 0a 00 12 15  ..\._SB_LNKC....
  07b0: 04 0c ff ff 11 00 0a 02 5c 2e 5f 53 42 5f 4c 4e  ........\._SB_LN
  07c0: 4b 44 0a 00 12 15 04 0c ff ff 11 00 0a 03 5c 2e  KD............\.
  07d0: 5f 53 42 5f 4c 4e 4b 41 0a 00 12 15 04 0c ff ff  _SB_LNKA........
  07e0: 13 00 0a 00 5c 2e 5f 53 42 5f 4c 4e 4b 41 0a 00  ....\._SB_LNKA..
  07f0: 12 15 04 0c ff ff 13 00 0a 01 5c 2e 5f 53 42 5f  ..........\._SB_
  0800: 4c 4e 4b 42 0a 00 12 15 04 0c ff ff 13 00 0a 02  LNKB............
  0810: 5c 2e 5f 53 42 5f 4c 4e 4b 43 0a 00 12 15 04 0c  \._SB_LNKC......
  0820: ff ff 13 00 0a 03 5c 2e 5f 53 42 5f 4c 4e 4b 44  ......\._SB_LNKD
  0830: 0a 00 5b 82 85 a3 01 53 42 52 47 08 5f 41 44 52  ..[....SBRG._ADR
  0840: 0c 00 00 02 00 08 5c 2e 5f 53 42 5f 50 52 53 41  ......\._SB_PRSA
  0850: 11 0b 0a 08 30 23 00 08 18 38 79 00 08 5c 2e 5f  ....0#...8y..\._
  0860: 53 42 5f 50 52 53 42 11 0b 0a 08 30 23 00 08 18  SB_PRSB....0#...
  0870: 38 79 00 08 5c 2e 5f 53 42 5f 50 52 53 43 11 0b  8y..\._SB_PRSC..
  0880: 0a 08 30 23 b8 d4 18 38 79 00 08 5c 2e 5f 53 42  ..0#...8y..\._SB
  0890: 5f 50 52 53 44 11 0b 0a 08 30 23 b8 d4 18 38 79  _PRSD....0#...8y
  08a0: 00 08 5c 2e 5f 53 42 5f 50 52 53 45 11 0b 0a 08  ..\._SB_PRSE....
  08b0: 30 23 b8 d4 18 38 79 00 08 5c 2e 5f 53 42 5f 50  0#...8y..\._SB_P
  08c0: 52 53 46 11 0b 0a 08 30 23 b8 d4 18 38 79 00 08  RSF....0#...8y..
  08d0: 5c 2e 5f 53 42 5f 50 52 53 47 11 0b 0a 08 30 23  \._SB_PRSG....0#
  08e0: b8 d4 18 38 79 00 08 5c 2e 5f 53 42 5f 50 52 53  ...8y..\._SB_PRS
  08f0: 48 11 0b 0a 08 30 23 b8 d4 18 38 79 00 5b 80 50  H....0#...8y.[.P
  0900: 41 32 44 02 0a 41 0a 04 5b 80 50 45 32 48 02 0a  A2D..A..[.PE2H..
  0910: 60 0a 04 10 4a 51 5c 5f 53 42 5f 5b 81 24 2f 03  `...JQ\_SB_[.$/.
  0920: 50 43 49 30 53 42 52 47 50 41 32 44 01 50 49 52  PCI0SBRGPA2D.PIR
  0930: 41 08 50 49 52 42 08 50 49 52 43 08 50 49 52 44  A.PIRB.PIRC.PIRD
  0940: 08 5b 81 24 2f 03 50 43 49 30 53 42 52 47 50 45  .[.$/.PCI0SBRGPE
  0950: 32 48 01 50 49 52 45 08 50 49 52 46 08 50 49 52  2H.PIRE.PIRF.PIR
  0960: 47 08 50 49 52 48 08 08 42 55 46 41 11 09 0a 06  G.PIRH..BUFA....
  0970: 23 00 80 18 79 00 5b 82 45 09 4c 4e 4b 41 08 5f  #...y.[.E.LNKA._
  0980: 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 01 14  HID.A...._UID...
  0990: 19 5f 53 54 41 00 7b 50 49 52 41 0a 80 60 a0 05  ._STA.{PIRA..`..
  09a0: 60 a4 0a 09 a1 04 a4 0a 0b 14 0b 5f 50 52 53 00  `.........._PRS.
  09b0: a4 50 52 53 41 14 11 5f 44 49 53 00 7d 50 49 52  .PRSA.._DIS.}PIR
  09c0: 41 0a 80 50 49 52 41 14 28 5f 43 52 53 00 8b 42  A..PIRA.(_CRS..B
  09d0: 55 46 41 0a 01 49 52 41 30 7b 50 49 52 41 0a 0f  UFA..IRA0{PIRA..
  09e0: 60 70 01 61 79 61 60 49 52 41 30 a4 42 55 46 41  `p.aya`IRA0.BUFA
  09f0: 14 1c 5f 53 52 53 01 8b 68 0a 01 49 52 41 5f 82  .._SRS..h..IRA_.
  0a00: 49 52 41 5f 60 76 60 70 60 50 49 52 41 5b 82 45  IRA_`v`p`PIRA[.E
  0a10: 09 4c 4e 4b 42 08 5f 48 49 44 0c 41 d0 0c 0f 08  .LNKB._HID.A....
  0a20: 5f 55 49 44 0a 02 14 19 5f 53 54 41 00 7b 50 49  _UID...._STA.{PI
  0a30: 52 42 0a 80 60 a0 05 60 a4 0a 09 a1 04 a4 0a 0b  RB..`..`........
  0a40: 14 0b 5f 50 52 53 00 a4 50 52 53 42 14 11 5f 44  .._PRS..PRSB.._D
  0a50: 49 53 00 7d 50 49 52 42 0a 80 50 49 52 42 14 28  IS.}PIRB..PIRB.(
  0a60: 5f 43 52 53 00 8b 42 55 46 41 0a 01 49 52 41 30  _CRS..BUFA..IRA0
  0a70: 7b 50 49 52 42 0a 0f 60 70 01 61 79 61 60 49 52  {PIRB..`p.aya`IR
  0a80: 41 30 a4 42 55 46 41 14 1c 5f 53 52 53 01 8b 68  A0.BUFA.._SRS..h
  0a90: 0a 01 49 52 41 5f 82 49 52 41 5f 60 76 60 70 60  ..IRA_.IRA_`v`p`
  0aa0: 50 49 52 42 5b 82 45 09 4c 4e 4b 43 08 5f 48 49  PIRB[.E.LNKC._HI
  0ab0: 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 03 14 19 5f  D.A...._UID...._
  0ac0: 53 54 41 00 7b 50 49 52 43 0a 80 60 a0 05 60 a4  STA.{PIRC..`..`.
  0ad0: 0a 09 a1 04 a4 0a 0b 14 0b 5f 50 52 53 00 a4 50  ........._PRS..P
  0ae0: 52 53 43 14 11 5f 44 49 53 00 7d 50 49 52 43 0a  RSC.._DIS.}PIRC.
  0af0: 80 50 49 52 43 14 28 5f 43 52 53 00 8b 42 55 46  .PIRC.(_CRS..BUF
  0b00: 41 0a 01 49 52 41 30 7b 50 49 52 43 0a 0f 60 70  A..IRA0{PIRC..`p
  0b10: 01 61 79 61 60 49 52 41 30 a4 42 55 46 41 14 1c  .aya`IRA0.BUFA..
  0b20: 5f 53 52 53 01 8b 68 0a 01 49 52 41 5f 82 49 52  _SRS..h..IRA_.IR
  0b30: 41 5f 60 76 60 70 60 50 49 52 43 5b 82 45 09 4c  A_`v`p`PIRC[.E.L
  0b40: 4e 4b 44 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55  NKD._HID.A...._U
  0b50: 49 44 0a 04 14 19 5f 53 54 41 00 7b 50 49 52 44  ID...._STA.{PIRD
  0b60: 0a 80 60 a0 05 60 a4 0a 09 a1 04 a4 0a 0b 14 0b  ..`..`..........
  0b70: 5f 50 52 53 00 a4 50 52 53 44 14 11 5f 44 49 53  _PRS..PRSD.._DIS
  0b80: 00 7d 50 49 52 44 0a 80 50 49 52 44 14 28 5f 43  .}PIRD..PIRD.(_C
  0b90: 52 53 00 8b 42 55 46 41 0a 01 49 52 41 30 7b 50  RS..BUFA..IRA0{P
  0ba0: 49 52 44 0a 0f 60 70 01 61 79 61 60 49 52 41 30  IRD..`p.aya`IRA0
  0bb0: a4 42 55 46 41 14 1c 5f 53 52 53 01 8b 68 0a 01  .BUFA.._SRS..h..
  0bc0: 49 52 41 5f 82 49 52 41 5f 60 76 60 70 60 50 49  IRA_.IRA_`v`p`PI
  0bd0: 52 44 5b 82 45 09 4c 4e 4b 45 08 5f 48 49 44 0c  RD[.E.LNKE._HID.
  0be0: 41 d0 0c 0f 08 5f 55 49 44 0a 05 14 19 5f 53 54  A...._UID...._ST
  0bf0: 41 00 7b 50 49 52 45 0a 80 60 a0 05 60 a4 0a 09  A.{PIRE..`..`...
  0c00: a1 04 a4 0a 0b 14 0b 5f 50 52 53 00 a4 50 52 53  ......._PRS..PRS
  0c10: 45 14 11 5f 44 49 53 00 7d 50 49 52 45 0a 80 50  E.._DIS.}PIRE..P
  0c20: 49 52 45 14 28 5f 43 52 53 00 8b 42 55 46 41 0a  IRE.(_CRS..BUFA.
  0c30: 01 49 52 41 30 7b 50 49 52 45 0a 0f 60 70 01 61  .IRA0{PIRE..`p.a
  0c40: 79 61 60 49 52 41 30 a4 42 55 46 41 14 1c 5f 53  ya`IRA0.BUFA.._S
  0c50: 52 53 01 8b 68 0a 01 49 52 41 5f 82 49 52 41 5f  RS..h..IRA_.IRA_
  0c60: 60 76 60 70 60 50 49 52 45 5b 82 45 09 4c 4e 4b  `v`p`PIRE[.E.LNK
  0c70: 46 08 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44  F._HID.A...._UID
  0c80: 0a 06 14 19 5f 53 54 41 00 7b 50 49 52 46 0a 80  ...._STA.{PIRF..
  0c90: 60 a0 05 60 a4 0a 09 a1 04 a4 0a 0b 14 0b 5f 50  `..`.........._P
  0ca0: 52 53 00 a4 50 52 53 46 14 11 5f 44 49 53 00 7d  RS..PRSF.._DIS.}
  0cb0: 50 49 52 46 0a 80 50 49 52 46 14 28 5f 43 52 53  PIRF..PIRF.(_CRS
  0cc0: 00 8b 42 55 46 41 0a 01 49 52 41 30 7b 50 49 52  ..BUFA..IRA0{PIR
  0cd0: 46 0a 0f 60 70 01 61 79 61 60 49 52 41 30 a4 42  F..`p.aya`IRA0.B
  0ce0: 55 46 41 14 1c 5f 53 52 53 01 8b 68 0a 01 49 52  UFA.._SRS..h..IR
  0cf0: 41 5f 82 49 52 41 5f 60 76 60 70 60 50 49 52 46  A_.IRA_`v`p`PIRF
  0d00: 5b 82 45 09 4c 4e 4b 47 08 5f 48 49 44 0c 41 d0  [.E.LNKG._HID.A.
  0d10: 0c 0f 08 5f 55 49 44 0a 07 14 19 5f 53 54 41 00  ..._UID...._STA.
  0d20: 7b 50 49 52 47 0a 80 60 a0 05 60 a4 0a 09 a1 04  {PIRG..`..`.....
  0d30: a4 0a 0b 14 0b 5f 50 52 53 00 a4 50 52 53 47 14  ....._PRS..PRSG.
  0d40: 11 5f 44 49 53 00 7d 50 49 52 47 0a 80 50 49 52  ._DIS.}PIRG..PIR
  0d50: 47 14 28 5f 43 52 53 00 8b 42 55 46 41 0a 01 49  G.(_CRS..BUFA..I
  0d60: 52 41 30 7b 50 49 52 47 0a 0f 60 70 01 61 79 61  RA0{PIRG..`p.aya
  0d70: 60 49 52 41 30 a4 42 55 46 41 14 1c 5f 53 52 53  `IRA0.BUFA.._SRS
  0d80: 01 8b 68 0a 01 49 52 41 5f 82 49 52 41 5f 60 76  ..h..IRA_.IRA_`v
  0d90: 60 70 60 50 49 52 47 5b 82 45 09 4c 4e 4b 48 08  `p`PIRG[.E.LNKH.
  0da0: 5f 48 49 44 0c 41 d0 0c 0f 08 5f 55 49 44 0a 08  _HID.A...._UID..
  0db0: 14 19 5f 53 54 41 00 7b 50 49 52 48 0a 80 60 a0  .._STA.{PIRH..`.
  0dc0: 05 60 a4 0a 09 a1 04 a4 0a 0b 14 0b 5f 50 52 53  .`.........._PRS
  0dd0: 00 a4 50 52 53 48 14 11 5f 44 49 53 00 7d 50 49  ..PRSH.._DIS.}PI
  0de0: 52 48 0a 80 50 49 52 48 14 28 5f 43 52 53 00 8b  RH..PIRH.(_CRS..
  0df0: 42 55 46 41 0a 01 49 52 41 30 7b 50 49 52 48 0a  BUFA..IRA0{PIRH.
  0e00: 0f 60 70 01 61 79 61 60 49 52 41 30 a4 42 55 46  .`p.aya`IRA0.BUF
  0e10: 41 14 1c 5f 53 52 53 01 8b 68 0a 01 49 52 41 5f  A.._SRS..h..IRA_
  0e20: 82 49 52 41 5f 60 76 60 70 60 50 49 52 48 5b 82  .IRA_`v`p`PIRH[.
  0e30: 4f 26 53 59 53 52 08 5f 48 49 44 0c 41 d0 0c 02  O&SYSR._HID.A...
  0e40: 14 12 5f 53 54 41 00 a0 08 4f 53 46 4c a4 0a 0f  .._STA...OSFL...
  0e50: a4 0a 00 08 49 4f 52 47 11 4a 06 0a 66 4b 10 00  ....IORG.J..fK..
  0e60: 10 4b 22 00 1e 4b 44 00 1c 4b 62 00 02 4b 65 00  .K"..KD..Kb..Ke.
  0e70: 0b 4b 72 00 0e 4b 80 00 01 4b 84 00 03 4b 88 00  .Kr..K...K...K..
  0e80: 01 4b 8c 00 03 4b 90 00 10 4b a2 00 1e 4b e0 00  .K...K...K...K..
  0e90: 10 4b 90 02 08 47 01 80 04 80 04 00 10 47 01 d0  .K...G.......G..
  0ea0: 04 d0 04 00 02 47 01 00 08 00 08 00 80 4b 80 08  .....G.......K..
  0eb0: 80 47 01 00 0c 00 0c 00 20 47 01 f0 03 f0 03 00  .G...... G......
  0ec0: 02 79 00 08 49 4f 39 38 11 4e 07 0a 7a 4b 10 00  .y..IO98.N..zK..
  0ed0: 10 4b 22 00 1e 4b 44 00 1c 4b 62 00 02 4b 65 00  .K"..KD..Kb..Ke.
  0ee0: 0b 4b 72 00 0e 4b 80 00 01 4b 84 00 03 4b 88 00  .Kr..K...K...K..
  0ef0: 01 4b 8c 00 03 4b 90 00 10 4b a2 00 1e 4b e0 00  .K...K...K...K..
  0f00: 10 4b 90 02 08 47 01 80 04 80 04 00 10 47 01 d0  .K...G.......G..
  0f10: 04 d0 04 00 02 47 01 00 08 00 08 00 80 4b 80 08  .....G.......K..
  0f20: 80 47 01 00 0c 00 0c 00 20 85 11 00 00 00 00 ee  .G...... .......
  0f30: ff 00 00 ee ff 00 00 00 00 00 00 02 00 47 01 f0  .............G..
  0f40: 03 f0 03 00 02 79 00 14 47 15 5f 43 52 53 00 a0  .....y..G._CRS..
  0f50: 49 0a 4f 53 46 4c 8b 49 4f 39 38 0a 4a 50 4d 49  I.OSFL.IO98.JPMI
  0f60: 4e 8b 49 4f 39 38 0a 4c 50 4d 41 58 8c 49 4f 39  N.IO98.LPMAX.IO9
  0f70: 38 0a 4f 50 4c 45 4e 8b 49 4f 39 38 0a 56 53 4d  8.OPLEN.IO98.VSM
  0f80: 49 4e 8b 49 4f 39 38 0a 58 53 4d 41 58 8c 49 4f  IN.IO98.XSMAX.IO
  0f90: 39 38 0a 5b 53 4c 45 4e 70 5c 2f 04 5f 53 42 5f  98.[SLENp\/._SB_
  0fa0: 50 43 49 30 53 42 52 47 50 4d 42 53 50 4d 49 4e  PCI0SBRGPMBSPMIN
  0fb0: 70 50 4d 49 4e 50 4d 41 58 a0 0c 50 4d 49 4e 70  pPMINPMAX..PMINp
  0fc0: 0a 80 50 4c 45 4e 70 5c 2f 04 5f 53 42 5f 50 43  ..PLENp\/._SB_PC
  0fd0: 49 30 53 42 52 47 53 4d 42 53 53 4d 49 4e 70 53  I0SBRGSMBSSMINpS
  0fe0: 4d 49 4e 53 4d 41 58 a0 0c 53 4d 49 4e 70 0a 20  MINSMAX..SMINp. 
  0ff0: 53 4c 45 4e a4 49 4f 39 38 a1 45 0a 8b 49 4f 52  SLEN.IO98.E..IOR
  1000: 47 0a 4a 50 4d 30 30 8b 49 4f 52 47 0a 4c 50 4d  G.JPM00.IORG.LPM
  1010: 30 31 8c 49 4f 52 47 0a 4f 50 4d 4c 4e 8b 49 4f  01.IORG.OPMLN.IO
  1020: 52 47 0a 56 53 4d 30 30 8b 49 4f 52 47 0a 58 53  RG.VSM00.IORG.XS
  1030: 4d 30 31 8c 49 4f 52 47 0a 5b 53 4d 4c 4e 70 5c  M01.IORG.[SMLNp\
  1040: 2f 04 5f 53 42 5f 50 43 49 30 53 42 52 47 50 4d  /._SB_PCI0SBRGPM
  1050: 42 53 50 4d 30 30 70 50 4d 30 30 50 4d 30 31 a0  BSPM00pPM00PM01.
  1060: 0c 50 4d 30 30 70 0a 80 50 4d 4c 4e 70 5c 2f 04  .PM00p..PMLNp\/.
  1070: 5f 53 42 5f 50 43 49 30 53 42 52 47 53 4d 42 53  _SB_PCI0SBRGSMBS
  1080: 53 4d 30 30 70 53 4d 30 30 53 4d 30 31 a0 0c 53  SM00pSM00SM01..S
  1090: 4d 30 30 70 0a 20 53 4d 4c 4e a4 49 4f 52 47 5b  M00p. SMLN.IORG[
  10a0: 82 48 0b 5c 2e 5f 53 42 5f 4d 45 4d 5f 08 5f 48  .H.\._SB_MEM_._H
  10b0: 49 44 0c 41 d0 0c 01 14 1d 5f 53 54 41 00 a0 13  ID.A....._STA...
  10c0: 5c 2f 03 5f 53 42 5f 50 43 49 30 4f 53 46 4c a4  \/._SB_PCI0OSFL.
  10d0: 0a 0f a4 0a 00 08 4d 45 4d 31 11 4e 04 0a 4a 86  ......MEM1.N..J.
  10e0: 09 00 01 00 00 00 00 00 00 0a 00 86 09 00 00 00  ................
  10f0: 00 0e 00 00 00 02 00 86 09 00 01 00 00 10 00 00  ................
  1100: 00 f0 1f 86 09 00 00 00 00 c0 fe 00 10 00 00 86  ................
  1110: 09 00 00 00 00 e0 fe 00 10 00 00 86 09 00 00 00  ................
  1120: 00 fc ff 00 00 04 00 79 00 14 2f 5f 43 52 53 00  .......y../_CRS.
  1130: 8a 4d 45 4d 31 0a 20 54 4f 50 31 74 5c 2f 03 5f  .MEM1. TOP1t\/._
  1140: 53 42 5f 50 43 49 30 4d 44 45 54 0c 00 00 10 00  SB_PCI0MDET.....
  1150: 54 4f 50 31 a4 4d 45 4d 31 5b 82 36 50 49 43 5f  TOP1.MEM1[.6PIC_
  1160: 08 5f 48 49 44 0b 41 d0 14 12 5f 53 54 41 00 a0  ._HID.A..._STA..
  1170: 08 4f 53 46 4c a4 0a 0f a4 0a 00 08 5f 43 52 53  .OSFL......._CRS
  1180: 11 10 0a 0d 4b 20 00 02 4b a0 00 02 22 04 00 79  ....K ..K..."..y
  1190: 00 5b 82 35 44 4d 41 44 08 5f 48 49 44 0c 41 d0  .[.5DMAD._HID.A.
  11a0: 02 00 08 5f 43 52 53 11 20 0a 1d 2a 10 04 4b 00  ..._CRS. ..*..K.
  11b0: 00 10 4b 81 00 03 4b 87 00 01 4b 89 00 03 4b 8f  ..K...K...K...K.
  11c0: 00 01 4b c0 00 20 79 00 5b 82 21 54 4d 52 5f 08  ..K.. y.[.!TMR_.
  11d0: 5f 48 49 44 0c 41 d0 01 00 08 5f 43 52 53 11 0c  _HID.A...._CRS..
  11e0: 0a 09 4b 40 00 04 22 01 00 79 00 5b 82 21 52 54  ..K@.."..y.[.!RT
  11f0: 43 5f 08 5f 48 49 44 0c 41 d0 0b 00 08 5f 43 52  C_._HID.A...._CR
  1200: 53 11 0c 0a 09 4b 70 00 02 22 00 01 79 00 5b 82  S....Kp.."..y.[.
  1210: 1e 53 50 4b 52 08 5f 48 49 44 0c 41 d0 08 00 08  .SPKR._HID.A....
  1220: 5f 43 52 53 11 09 0a 06 4b 61 00 01 79 00 5b 82  _CRS....Ka..y.[.
  1230: 21 43 4f 50 52 08 5f 48 49 44 0c 41 d0 0c 04 08  !COPR._HID.A....
  1240: 5f 43 52 53 11 0c 0a 09 4b f0 00 10 22 00 20 79  _CRS....K...". y
  1250: 00 5b 80 50 53 52 47 00 0c c2 e2 0f 00 0a 01 5b  .[.PSRG........[
  1260: 81 12 50 53 52 47 01 50 4b 32 45 01 50 4d 32 45  ..PSRG.PK2E.PM2E
  1270: 01 00 06 5b 82 41 07 50 53 32 4d 08 5f 48 49 44  ...[.A.PS2M._HID
  1280: 0c 41 d0 0f 03 08 5f 43 49 44 0c 41 d0 0f 13 14  .A...._CID.A....
  1290: 14 5f 53 54 41 00 a0 08 50 4d 32 45 a4 0a 0f a1  ._STA...PM2E....
  12a0: 04 a4 0a 00 08 4d 32 52 30 11 08 0a 05 22 00 10  .....M2R0...."..
  12b0: 79 00 08 4d 32 52 31 11 10 0a 0d 4b 60 00 01 4b  y..M2R1....K`..K
  12c0: 64 00 01 22 00 10 79 00 14 1d 5f 43 52 53 00 a0  d.."..y..._CRS..
  12d0: 0f 91 50 4d 32 45 4f 53 46 4c a4 4d 32 52 30 a1  ..PM2EOSFL.M2R0.
  12e0: 06 a4 4d 32 52 31 5b 82 2f 50 53 32 4b 08 5f 48  ..M2R1[./PS2K._H
  12f0: 49 44 0c 41 d0 03 03 08 5f 43 49 44 0c 41 d0 03  ID.A...._CID.A..
  1300: 0b 08 5f 43 52 53 11 10 0a 0d 4b 60 00 01 4b 64  .._CRS....K`..Kd
  1310: 00 01 22 02 00 79 00 08 2e 50 53 32 4b 5f 50 52  .."..y...PS2K_PR
  1320: 57 12 06 02 0a 0f 0a 04 10 23 5c 5f 47 50 45 14  W........#\_GPE.
  1330: 1c 5f 4c 30 46 00 86 5c 2f 04 5f 53 42 5f 50 43  ._L0F..\/._SB_PC
  1340: 49 30 53 42 52 47 50 53 32 4b 0a 02 08 2e 50 53  I0SBRGPS2K....PS
  1350: 32 4d 5f 50 52 57 12 06 02 0a 0f 0a 04 14 07 52  2M_PRW.........R
  1360: 52 49 4f 04 a3 14 07 52 47 4e 52 04 a3 14 07 52  RIO....RGNR....R
  1370: 44 4d 41 03 a3 08 53 50 49 4f 0a 2e 5b 80 57 49  DMA...SPIO..[.WI
  1380: 4e 31 01 53 50 49 4f 0a 02 5b 81 10 57 49 4e 31  N1.SPIO..[..WIN1
  1390: 01 49 4e 44 58 08 44 41 54 41 08 5b 86 42 07 49  .INDX.DATA.[.B.I
  13a0: 4e 44 58 44 41 54 41 01 00 10 43 46 47 5f 08 00  NDXDATA...CFG_..
  13b0: 20 4c 44 4e 5f 08 00 40 14 41 43 54 52 08 00 48   LDN_..@.ACTR..H
  13c0: 17 49 4f 41 48 08 49 4f 41 4c 08 49 4f 45 48 08  .IOAH.IOAL.IOEH.
  13d0: 49 4f 45 4c 08 00 40 06 49 4e 54 52 08 00 08 49  IOEL..@.INTR...I
  13e0: 4e 54 31 08 00 08 44 4d 43 48 08 00 48 25 47 50  NT1...DMCH..H%GP
  13f0: 34 30 08 00 48 17 4f 50 54 31 08 4f 50 54 32 08  40..H.OPT1.OPT2.
  1400: 4f 50 54 33 08 4f 50 54 34 08 4f 50 54 35 08 14  OPT3.OPT4.OPT5..
  1410: 34 45 4e 46 47 00 70 0a 87 49 4e 44 58 70 0a 01  4ENFG.p..INDXp..
  1420: 49 4e 44 58 70 0a 55 49 4e 44 58 a0 0f 93 53 50  INDXp.UINDX...SP
  1430: 49 4f 0a 2e 70 0a 55 49 4e 44 58 a1 08 70 0a aa  IO..p.UINDX..p..
  1440: 49 4e 44 58 14 14 45 58 46 47 00 70 0a 02 49 4e  INDX..EXFG.p..IN
  1450: 44 58 70 0a 02 44 41 54 41 08 4c 44 46 44 0a 00  DXp..DATA.LDFD..
  1460: 08 4c 44 55 31 0a 01 08 4c 44 55 32 0a 02 08 4c  .LDU1...LDU2...L
  1470: 44 4c 50 0a 03 08 4c 44 50 4d 0a 04 08 4c 44 47  DLP...LDPM...LDG
  1480: 4d 0a 06 08 4c 44 49 52 0a 07 08 4c 44 4d 44 0a  M...LDIR...LDMD.
  1490: 08 5b 82 41 06 46 44 43 30 08 5f 48 49 44 0c 41  .[.A.FDC0._HID.A
  14a0: d0 07 00 14 1a 5f 53 54 41 00 a0 0e 46 44 53 54  ....._STA...FDST
  14b0: a4 47 53 54 41 4c 44 46 44 a1 04 a4 0a 00 14 0e  .GSTALDFD.......
  14c0: 5f 44 49 53 00 44 44 49 53 4c 44 46 44 14 0b 5f  _DIS.DDISLDFD.._
  14d0: 43 52 53 00 a4 46 43 52 53 14 0b 5f 50 52 53 00  CRS..FCRS.._PRS.
  14e0: a4 46 50 52 53 14 0e 5f 53 52 53 01 44 45 4e 42  .FPRS.._SRS.DENB
  14f0: 4c 44 46 44 5b 82 49 07 55 41 52 31 08 5f 48 49  LDFD[.I.UAR1._HI
  1500: 44 0c 41 d0 05 01 08 5f 55 49 44 0a 01 14 1a 5f  D.A...._UID...._
  1510: 53 54 41 00 a0 0e 55 31 53 54 a4 47 53 54 41 4c  STA...U1ST.GSTAL
  1520: 44 55 31 a1 04 a4 0a 00 14 0e 5f 44 49 53 00 44  DU1......._DIS.D
  1530: 44 49 53 4c 44 55 31 14 13 5f 43 52 53 00 a4 50  DISLDU1.._CRS..P
  1540: 43 52 53 4c 44 55 31 0a 01 0a 08 14 17 5f 53 52  CRSLDU1......_SR
  1550: 53 01 50 53 52 53 68 4c 44 55 31 45 4e 46 47 45  S.PSRShLDU1ENFGE
  1560: 58 46 47 14 0b 5f 50 52 53 00 a4 43 31 50 52 5b  XFG.._PRS..C1PR[
  1570: 82 40 0a 55 41 52 32 14 30 5f 48 49 44 00 45 4e  .@.UAR2.0_HID.EN
  1580: 46 47 70 4c 44 55 32 4c 44 4e 5f 7b 4f 50 54 32  FGpLDU2LDN_{OPT2
  1590: 0a 07 60 45 58 46 47 a0 08 60 a4 0c 41 d0 05 10  ..`EXFG..`..A...
  15a0: a1 07 a4 0c 41 d0 05 01 08 5f 55 49 44 0a 02 14  ....A...._UID...
  15b0: 1a 5f 53 54 41 00 a0 0e 55 32 53 54 a4 47 53 54  ._STA...U2ST.GST
  15c0: 41 4c 44 55 32 a1 04 a4 0a 00 14 0e 5f 44 49 53  ALDU2......._DIS
  15d0: 00 44 44 49 53 4c 44 55 32 14 13 5f 43 52 53 00  .DDISLDU2.._CRS.
  15e0: a4 50 43 52 53 4c 44 55 32 0a 01 0a 08 14 17 5f  .PCRSLDU2......_
  15f0: 53 52 53 01 50 53 52 53 68 4c 44 55 32 45 4e 46  SRS.PSRShLDU2ENF
  1600: 47 45 58 46 47 14 0b 5f 50 52 53 00 a4 43 32 50  GEXFG.._PRS..C2P
  1610: 52 5b 82 4e 10 49 52 44 41 08 5f 48 49 44 0c 41  R[.N.IRDA._HID.A
  1620: d0 05 10 14 1a 5f 53 54 41 00 a0 0e 49 52 53 54  ....._STA...IRST
  1630: a4 47 53 54 41 4c 44 49 52 a1 04 a4 0a 00 14 0e  .GSTALDIR.......
  1640: 5f 44 49 53 00 44 44 49 53 4c 44 49 52 14 4b 0a  _DIS.DDISLDIR.K.
  1650: 5f 43 52 53 00 08 42 55 46 36 11 10 0a 0d 47 01  _CRS..BUF6....G.
  1660: 00 00 00 00 10 08 22 00 00 79 00 8c 42 55 46 36  ......"..y..BUF6
  1670: 0a 02 49 4f 4c 4f 8c 42 55 46 36 0a 03 49 4f 48  ..IOLO.BUF6..IOH
  1680: 49 8c 42 55 46 36 0a 04 49 4f 52 4c 8c 42 55 46  I.BUF6..IORL.BUF
  1690: 36 0a 05 49 4f 52 48 8b 42 55 46 36 0a 09 49 52  6..IORH.BUF6..IR
  16a0: 51 4d 45 4e 46 47 70 4c 44 49 52 4c 44 4e 5f a0  QMENFGpLDIRLDN_.
  16b0: 13 41 43 54 52 70 0a 10 49 4f 4c 4f 70 0a 03 49  .ACTRp..IOLOp..I
  16c0: 4f 48 49 a1 0f 70 0a 00 49 4f 4c 4f 70 0a 00 49  OHI..p..IOLOp..I
  16d0: 4f 48 49 70 49 4f 4c 4f 49 4f 52 4c 70 49 4f 48  OHIpIOLOIORLpIOH
  16e0: 49 49 4f 52 48 79 0a 01 49 4e 54 52 49 52 51 4d  IIORHy..INTRIRQM
  16f0: 45 58 46 47 a4 42 55 46 36 14 0f 5f 53 52 53 01  EXFG.BUF6.._SRS.
  1700: 50 53 52 53 68 4c 44 49 52 08 5f 50 52 53 11 12  PSRShLDIR._PRS..
  1710: 0a 0f 30 47 01 10 03 10 03 08 08 22 18 0e 38 79  ..0G......."..8y
  1720: 00 5b 82 43 09 4c 50 54 5f 08 5f 48 49 44 0c 41  .[.C.LPT_._HID.A
  1730: d0 04 00 14 3b 5f 53 54 41 00 45 4e 46 47 70 4c  ....;_STA.ENFGpL
  1740: 44 4c 50 4c 44 4e 5f 7b 4f 50 54 31 0a 02 60 45  DLPLDN_{OPT1..`E
  1750: 58 46 47 a0 10 7d 60 7b 80 4c 50 53 54 00 0a 01  XFG..}`{.LPST...
  1760: 00 00 a4 00 a1 0a a4 47 53 54 41 4c 44 4c 50 14  .......GSTALDLP.
  1770: 0e 5f 44 49 53 00 44 44 49 53 4c 44 4c 50 14 13  ._DIS.DDISLDLP..
  1780: 5f 43 52 53 00 a4 50 43 52 53 4c 44 4c 50 0a 01  _CRS..PCRSLDLP..
  1790: 0a 08 14 17 5f 53 52 53 01 50 53 52 53 68 4c 44  ...._SRS.PSRShLD
  17a0: 4c 50 45 4e 46 47 45 58 46 47 14 0b 5f 50 52 53  LPENFGEXFG.._PRS
  17b0: 00 a4 4c 50 50 52 5b 82 49 08 45 43 50 5f 08 5f  ..LPPR[.I.ECP_._
  17c0: 48 49 44 0c 41 d0 04 01 14 35 5f 53 54 41 00 45  HID.A....5_STA.E
  17d0: 4e 46 47 70 4c 44 4c 50 4c 44 4e 5f 7b 4f 50 54  NFGpLDLPLDN_{OPT
  17e0: 31 0a 02 60 45 58 46 47 a0 11 60 a0 0e 4c 50 53  1..`EXFG..`..LPS
  17f0: 54 a4 47 53 54 41 4c 44 4c 50 a1 03 a4 00 14 0e  T.GSTALDLP......
  1800: 5f 44 49 53 00 44 44 49 53 4c 44 4c 50 14 0f 5f  _DIS.DDISLDLP.._
  1810: 43 52 53 00 a4 45 43 52 53 4c 44 4c 50 14 17 5f  CRS..ECRSLDLP.._
  1820: 53 52 53 01 45 53 52 53 68 4c 44 4c 50 45 4e 46  SRS.ESRShLDLPENF
  1830: 47 45 58 46 47 14 0b 5f 50 52 53 00 a4 45 50 52  GEXFG.._PRS..EPR
  1840: 53 5b 82 47 13 47 41 4d 45 08 5f 48 49 44 0c 41  S[.G.GAME._HID.A
  1850: d0 b0 2f 14 0f 5f 53 54 41 00 a4 47 53 54 41 4c  ../.._STA..GSTAL
  1860: 44 47 4d 14 0e 5f 44 49 53 00 44 44 49 53 4c 44  DGM.._DIS.DDISLD
  1870: 47 4d 14 45 09 5f 43 52 53 00 08 42 55 46 36 11  GM.E._CRS..BUF6.
  1880: 0d 0a 0a 47 01 00 00 00 00 01 08 79 00 8c 42 55  ...G.......y..BU
  1890: 46 36 0a 02 49 4f 4c 4f 8c 42 55 46 36 0a 03 49  F6..IOLO.BUF6..I
  18a0: 4f 48 49 8c 42 55 46 36 0a 04 49 4f 52 4c 8c 42  OHI.BUF6..IORL.B
  18b0: 55 46 36 0a 05 49 4f 52 48 45 4e 46 47 70 4c 44  UF6..IORHENFGpLD
  18c0: 47 4d 4c 44 4e 5f a0 16 93 49 4f 41 4c 0a 01 70  GMLDN_...IOAL..p
  18d0: 0a 01 49 4f 4c 4f 70 0a 02 49 4f 48 49 a1 0f 70  ..IOLOp..IOHI..p
  18e0: 0a 09 49 4f 4c 4f 70 0a 02 49 4f 48 49 70 49 4f  ..IOLOp..IOHIpIO
  18f0: 4c 4f 49 4f 52 4c 70 49 4f 48 49 49 4f 52 48 45  LOIORLpIOHIIORHE
  1900: 58 46 47 a4 42 55 46 36 08 5f 50 52 53 11 18 0a  XFG.BUF6._PRS...
  1910: 15 30 47 01 01 02 01 02 01 08 30 47 01 09 02 09  .0G.......0G....
  1920: 02 01 08 38 79 00 14 43 05 5f 53 52 53 01 8c 68  ...8y..C._SRS..h
  1930: 0a 02 49 4f 4c 4f 8c 68 0a 03 49 4f 48 49 45 4e  ..IOLO.h..IOHIEN
  1940: 46 47 70 4c 44 47 4d 4c 44 4e 5f a0 16 93 49 4f  FGpLDGMLDN_...IO
  1950: 4c 4f 0a 01 70 0a 02 49 4f 41 48 70 0a 01 49 4f  LO..p..IOAHp..IO
  1960: 41 4c a1 0f 70 0a 02 49 4f 41 48 70 0a 09 49 4f  AL..p..IOAHp..IO
  1970: 41 4c 44 45 4e 42 4c 44 47 4d 5b 82 4c 16 4d 49  ALDENBLDGM[.L.MI
  1980: 44 49 08 5f 48 49 44 0c 41 d0 b0 06 14 0f 5f 53  DI._HID.A....._S
  1990: 54 41 00 a4 47 53 54 41 4c 44 4d 44 14 0e 5f 44  TA..GSTALDMD.._D
  19a0: 49 53 00 44 44 49 53 4c 44 4d 44 14 4e 0a 5f 43  IS.DDISLDMD.N._C
  19b0: 52 53 00 08 42 55 46 36 11 10 0a 0d 47 01 00 00  RS..BUF6....G...
  19c0: 00 00 10 02 22 00 00 79 00 8c 42 55 46 36 0a 02  ...."..y..BUF6..
  19d0: 49 4f 4c 4f 8c 42 55 46 36 0a 03 49 4f 48 49 8c  IOLO.BUF6..IOHI.
  19e0: 42 55 46 36 0a 04 49 4f 52 4c 8c 42 55 46 36 0a  BUF6..IORL.BUF6.
  19f0: 05 49 4f 52 48 8b 42 55 46 36 0a 09 49 52 51 4d  .IORH.BUF6..IRQM
  1a00: 45 4e 46 47 70 4c 44 4d 44 4c 44 4e 5f a0 16 93  ENFGpLDMDLDN_...
  1a10: 49 4f 41 4c 0a 30 70 0a 30 49 4f 4c 4f 70 0a 03  IOAL.0p.0IOLOp..
  1a20: 49 4f 48 49 a1 0f 70 0a 00 49 4f 4c 4f 70 0a 03  IOHI..p..IOLOp..
  1a30: 49 4f 48 49 70 49 4f 4c 4f 49 4f 52 4c 70 49 4f  IOHIpIOLOIORLpIO
  1a40: 48 49 49 4f 52 48 79 0a 01 49 4e 54 52 49 52 51  HIIORHy..INTRIRQ
  1a50: 4d 45 58 46 47 a4 42 55 46 36 08 5f 50 52 53 11  MEXFG.BUF6._PRS.
  1a60: 1e 0a 1b 30 47 01 30 03 30 03 10 02 22 20 0e 30  ...0G.0.0..." .0
  1a70: 47 01 00 03 00 03 10 02 22 20 0e 38 79 00 14 49  G......." .8y..I
  1a80: 06 5f 53 52 53 01 8c 68 0a 02 49 4f 4c 4f 8c 68  ._SRS..h..IOLO.h
  1a90: 0a 03 49 4f 48 49 8b 68 0a 09 49 52 51 4d 45 4e  ..IOHI.h..IRQMEN
  1aa0: 46 47 70 4c 44 4d 44 4c 44 4e 5f a0 16 93 49 4f  FGpLDMDLDN_...IO
  1ab0: 4c 4f 0a 30 70 0a 03 49 4f 41 48 70 0a 30 49 4f  LO.0p..IOAHp.0IO
  1ac0: 41 4c a1 0f 70 0a 03 49 4f 41 48 70 0a 00 49 4f  AL..p..IOAHp..IO
  1ad0: 41 4c 82 49 52 51 4d 60 74 60 0a 01 49 4e 54 52  AL.IRQM`t`..INTR
  1ae0: 44 45 4e 42 4c 44 4d 44 08 46 44 53 54 0a 00 08  DENBLDMD.FDST...
  1af0: 55 31 53 54 0a 00 08 55 32 53 54 0a 00 08 49 52  U1ST...U2ST...IR
  1b00: 53 54 0a 00 08 4c 50 53 54 0a 00 14 4b 06 49 4f  ST...LPST...K.IO
  1b10: 44 54 00 a0 13 93 47 53 54 41 4c 44 46 44 0a 0f  DT....GSTALDFD..
  1b20: 70 0a 01 46 44 53 54 a0 13 93 47 53 54 41 4c 44  p..FDST...GSTALD
  1b30: 55 31 0a 0f 70 0a 01 55 31 53 54 a0 13 93 47 53  U1..p..U1ST...GS
  1b40: 54 41 4c 44 55 32 0a 0f 70 0a 01 55 32 53 54 a0  TALDU2..p..U2ST.
  1b50: 13 93 47 53 54 41 4c 44 49 52 0a 0f 70 0a 01 49  ..GSTALDIR..p..I
  1b60: 52 53 54 a0 13 93 47 53 54 41 4c 44 4c 50 0a 0f  RST...GSTALDLP..
  1b70: 70 0a 01 4c 50 53 54 14 38 47 53 54 41 01 45 4e  p..LPST.8GSTA.EN
  1b80: 46 47 70 68 4c 44 4e 5f a0 09 41 43 54 52 70 0a  FGphLDN_..ACTRp.
  1b90: 0f 60 a1 17 a0 0f 7d 49 4f 41 48 49 4f 41 4c 00  .`....}IOAHIOAL.
  1ba0: 70 0a 0d 60 a1 05 70 0a 00 60 45 58 46 47 a4 60  p..`..p..`EXFG.`
  1bb0: 14 1a 44 44 49 53 01 45 4e 46 47 70 68 4c 44 4e  ..DDIS.ENFGphLDN
  1bc0: 5f 70 00 41 43 54 52 45 58 46 47 14 1a 44 45 4e  _p.ACTREXFG..DEN
  1bd0: 42 01 45 4e 46 47 70 68 4c 44 4e 5f 70 01 41 43  B.ENFGphLDN_p.AC
  1be0: 54 52 45 58 46 47 14 4d 0a 50 43 52 53 03 8c 50  TREXFG.M.PCRS..P
  1bf0: 42 55 46 0a 02 49 4f 4c 4f 8c 50 42 55 46 0a 03  BUF..IOLO.PBUF..
  1c00: 49 4f 48 49 8b 50 42 55 46 0a 02 49 4f 48 4c 8b  IOHI.PBUF..IOHL.
  1c10: 50 42 55 46 0a 04 49 4f 52 4c 8c 50 42 55 46 0a  PBUF..IORL.PBUF.
  1c20: 06 41 4c 4d 4e 8c 50 42 55 46 0a 07 4c 45 4e 47  .ALMN.PBUF..LENG
  1c30: 8c 50 42 55 46 0a 09 49 52 51 4c 45 4e 46 47 70  .PBUF..IRQLENFGp
  1c40: 68 4c 44 4e 5f 70 49 4f 41 48 49 4f 48 49 70 49  hLDN_pIOAHIOHIpI
  1c50: 4f 41 4c 49 4f 4c 4f 70 49 4f 48 4c 49 4f 52 4c  OALIOLOpIOHLIORL
  1c60: 70 69 41 4c 4d 4e a0 0f 93 49 4f 4c 4f 0a bc 70  piALMN...IOLO..p
  1c70: 0a 04 4c 45 4e 47 a1 07 70 6a 4c 45 4e 47 70 01  ..LENG..pjLENGp.
  1c80: 60 79 60 49 4e 54 52 49 52 51 4c 45 58 46 47 a4  `y`INTRIRQLEXFG.
  1c90: 50 42 55 46 14 43 05 50 53 52 53 02 8c 68 0a 02  PBUF.C.PSRS..h..
  1ca0: 50 4f 4c 42 8c 68 0a 03 50 4f 48 42 8c 68 0a 09  POLB.h..POHB.h..
  1cb0: 50 49 52 51 45 4e 46 47 70 69 4c 44 4e 5f 70 50  PIRQENFGpiLDN_pP
  1cc0: 4f 4c 42 49 4f 41 4c 70 50 4f 48 42 49 4f 41 48  OLBIOALpPOHBIOAH
  1cd0: 82 50 49 52 51 60 74 60 0a 01 49 4e 54 52 70 01  .PIRQ`t`..INTRp.
  1ce0: 41 43 54 52 45 58 46 47 14 48 0f 45 43 52 53 01  ACTREXFG.H.ECRS.
  1cf0: 8c 45 42 55 46 0a 02 45 50 4c 4f 8c 45 42 55 46  .EBUF..EPLO.EBUF
  1d00: 0a 03 45 50 48 49 8b 45 42 55 46 0a 02 45 50 48  ..EPHI.EBUF..EPH
  1d10: 4c 8b 45 42 55 46 0a 04 45 50 52 4c 8b 45 42 55  L.EBUF..EPRL.EBU
  1d20: 46 0a 06 41 4c 4d 31 8b 45 42 55 46 0a 0a 45 34  F..ALM1.EBUF..E4
  1d30: 4c 4f 8b 45 42 55 46 0a 0c 45 34 52 4c 8b 45 42  LO.EBUF..E4RL.EB
  1d40: 55 46 0a 11 45 49 52 51 8b 45 42 55 46 0a 14 45  UF..EIRQ.EBUF..E
  1d50: 44 4d 41 45 4e 46 47 70 68 4c 44 4e 5f 70 49 4f  DMAENFGphLDN_pIO
  1d60: 41 48 45 50 48 49 70 49 4f 41 4c 45 50 4c 4f 70  AHEPHIpIOALEPLOp
  1d70: 45 50 48 4c 45 50 52 4c 72 45 50 48 4c 0b 00 04  EPHLEPRLrEPHL...
  1d80: 45 34 4c 4f 70 45 34 4c 4f 45 34 52 4c a0 11 93  E4LOpE4LOE4RL...
  1d90: 45 50 48 4c 0b bc 03 70 0b 01 04 41 4c 4d 31 a1  EPHL...p...ALM1.
  1da0: 09 70 0b 01 08 41 4c 4d 31 70 01 60 70 49 4e 54  .p...ALM1p.`pINT
  1db0: 52 61 79 60 61 45 49 52 51 70 44 4d 43 48 61 a0  Ray`aEIRQpDMCHa.
  1dc0: 0c 94 61 0a 03 70 0a 00 45 44 4d 41 a1 0b 70 01  ..a..p..EDMA..p.
  1dd0: 60 79 60 61 45 44 4d 41 45 58 46 47 a4 45 42 55  `y`aEDMAEXFG.EBU
  1de0: 46 14 48 07 45 53 52 53 02 8c 68 0a 02 4c 4f 45  F.H.ESRS..h..LOE
  1df0: 50 8c 68 0a 03 48 49 45 50 8b 68 0a 11 49 52 51  P.h..HIEP.h..IRQ
  1e00: 45 8b 68 0a 14 44 4d 41 45 45 4e 46 47 70 69 4c  E.h..DMAEENFGpiL
  1e10: 44 4e 5f 70 4c 4f 45 50 49 4f 41 4c 70 48 49 45  DN_pLOEPIOALpHIE
  1e20: 50 49 4f 41 48 82 49 52 51 45 60 74 60 0a 01 49  PIOAH.IRQE`t`..I
  1e30: 4e 54 52 a0 13 44 4d 41 45 82 44 4d 41 45 60 74  NTR..DMAE.DMAE`t
  1e40: 60 0a 01 44 4d 43 48 a1 08 70 0a 04 44 4d 43 48  `..DMCH..p..DMCH
  1e50: 70 01 41 43 54 52 45 58 46 47 08 43 4e 42 46 11  p.ACTREXFG.CNBF.
  1e60: 05 0a 02 f8 03 14 4d 04 55 41 42 53 01 45 4e 46  ......M.UABS.ENF
  1e70: 47 70 68 4c 44 4e 5f 8c 43 4e 42 46 0a 00 49 4f  GphLDN_.CNBF..IO
  1e80: 4c 4f 8c 43 4e 42 46 0a 01 49 4f 48 49 8b 43 4e  LO.CNBF..IOHI.CN
  1e90: 42 46 0a 00 49 4f 41 44 70 49 4f 41 4c 49 4f 4c  BF..IOADpIOALIOL
  1ea0: 4f 70 49 4f 41 48 49 4f 48 49 45 58 46 47 a4 49  OpIOAHIOHIEXFG.I
  1eb0: 4f 41 44 08 43 53 43 50 0a 00 5b 84 30 55 52 50  OAD.CSCP..[.0URP
  1ec0: 31 00 00 00 14 0b 5f 53 54 41 00 a4 43 53 43 50  1....._STA..CSCP
  1ed0: 14 0d 5f 4f 4e 5f 00 70 0a 01 43 53 43 50 14 0d  .._ON_.p..CSCP..
  1ee0: 5f 4f 46 46 00 70 0a 00 43 53 43 50 5b 84 30 55  _OFF.p..CSCP[.0U
  1ef0: 52 50 32 00 00 00 14 0b 5f 53 54 41 00 a4 43 53  RP2....._STA..CS
  1f00: 43 50 14 0d 5f 4f 4e 5f 00 70 0a 01 43 53 43 50  CP.._ON_.p..CSCP
  1f10: 14 0d 5f 4f 46 46 00 70 0a 00 43 53 43 50 5b 84  .._OFF.p..CSCP[.
  1f20: 30 46 44 44 50 00 00 00 14 0b 5f 53 54 41 00 a4  0FDDP....._STA..
  1f30: 43 53 43 50 14 0d 5f 4f 4e 5f 00 70 0a 01 43 53  CSCP.._ON_.p..CS
  1f40: 43 50 14 0d 5f 4f 46 46 00 70 0a 00 43 53 43 50  CP.._OFF.p..CSCP
  1f50: 5b 84 30 4c 50 54 50 00 00 00 14 0b 5f 53 54 41  [.0LPTP....._STA
  1f60: 00 a4 43 53 43 50 14 0d 5f 4f 4e 5f 00 70 0a 01  ..CSCP.._ON_.p..
  1f70: 43 53 43 50 14 0d 5f 4f 46 46 00 70 0a 00 43 53  CSCP.._OFF.p..CS
  1f80: 43 50 08 46 43 52 53 11 23 0a 20 47 01 f2 03 f2  CP.FCRS.#. G....
  1f90: 03 01 02 47 01 f4 03 f4 03 01 02 47 01 f7 03 f7  ...G.......G....
  1fa0: 03 01 01 22 40 00 2a 04 00 79 00 08 50 42 55 46  ..."@.*..y..PBUF
  1fb0: 11 10 0a 0d 47 01 00 00 00 00 01 08 22 01 00 79  ....G......."..y
  1fc0: 00 08 45 42 55 46 11 1b 0a 18 47 01 78 03 78 03  ..EBUF....G.x.x.
  1fd0: 01 08 47 01 78 07 78 07 01 04 22 80 00 2a 00 00  ..G.x.x..."..*..
  1fe0: 79 00 08 46 50 52 53 11 26 0a 23 31 00 47 01 f2  y..FPRS.&.#1.G..
  1ff0: 03 f2 03 01 02 47 01 f4 03 f4 03 01 02 47 01 f7  .....G.......G..
  2000: 03 f7 03 01 01 22 40 00 2a 04 00 38 79 00 08 43  ....."@.*..8y..C
  2010: 31 50 52 11 44 04 0a 40 31 00 47 01 f8 03 f8 03  1PR.D..@1.G.....
  2020: 04 08 22 10 00 30 47 01 f8 03 f8 03 04 08 22 18  .."..0G.......".
  2030: 0c 30 47 01 f8 02 f8 02 04 08 22 18 0c 30 47 01  .0G......."..0G.
  2040: e8 03 e8 03 04 08 22 18 0c 30 47 01 e8 02 e8 02  ......"..0G.....
  2050: 04 08 22 18 0c 38 79 00 08 43 32 50 52 11 44 04  .."..8y..C2PR.D.
  2060: 0a 40 31 00 47 01 f8 02 f8 02 04 08 22 08 00 30  .@1.G......."..0
  2070: 47 01 f8 02 f8 02 04 08 22 18 0c 30 47 01 f8 03  G......."..0G...
  2080: f8 03 04 08 22 18 0c 30 47 01 e8 03 e8 03 04 08  ...."..0G.......
  2090: 22 18 0c 30 47 01 e8 02 e8 02 04 08 22 18 0c 38  "..0G......."..8
  20a0: 79 00 08 4c 50 50 52 11 37 0a 34 31 00 47 01 78  y..LPPR.7.41.G.x
  20b0: 03 78 03 01 08 22 80 00 30 47 01 78 03 78 03 01  .x..."..0G.x.x..
  20c0: 08 22 a0 00 30 47 01 78 02 78 02 01 08 22 a0 00  ."..0G.x.x..."..
  20d0: 30 47 01 bc 03 bc 03 01 04 22 a0 00 38 79 00 08  0G......."..8y..
  20e0: 45 50 52 53 11 49 0a 0a a5 31 00 47 01 78 03 78  EPRS.I...1.G.x.x
  20f0: 03 01 08 47 01 78 07 78 07 01 04 22 80 00 2a 02  ...G.x.x..."..*.
  2100: 00 30 47 01 78 03 78 03 01 08 47 01 78 07 78 07  .0G.x.x...G.x.x.
  2110: 01 04 22 a0 00 2a 0b 00 30 47 01 78 02 78 02 01  .."..*..0G.x.x..
  2120: 08 47 01 78 06 78 06 01 04 22 a0 00 2a 0b 00 30  .G.x.x..."..*..0
  2130: 47 01 bc 03 bc 03 01 04 47 01 bc 07 bc 07 01 04  G.......G.......
  2140: 22 a0 00 2a 0b 00 30 47 01 78 03 78 03 01 08 47  "..*..0G.x.x...G
  2150: 01 78 07 78 07 01 04 22 a0 00 2a 00 00 30 47 01  .x.x..."..*..0G.
  2160: 78 02 78 02 01 08 47 01 78 06 78 06 01 04 22 a0  x.x...G.x.x...".
  2170: 00 2a 00 00 30 47 01 bc 03 bc 03 01 04 47 01 bc  .*..0G.......G..
  2180: 07 bc 07 01 04 22 a0 00 2a 00 00 38 79 00 08 2e  ....."..*..8y...
  2190: 55 41 52 31 5f 50 52 30 12 06 01 55 52 50 31 08  UAR1_PR0...URP1.
  21a0: 2e 55 41 52 32 5f 50 52 30 12 06 01 55 52 50 32  .UAR2_PR0...URP2
  21b0: 08 2e 46 44 43 30 5f 50 52 30 12 06 01 46 44 44  ..FDC0_PR0...FDD
  21c0: 50 08 2e 45 43 50 5f 5f 50 52 30 12 06 01 4c 50  P..ECP__PR0...LP
  21d0: 54 50 08 2e 4c 50 54 5f 5f 50 52 30 12 06 01 4c  TP..LPT__PR0...L
  21e0: 50 54 50 08 2e 55 41 52 31 5f 50 52 57 12 06 02  PTP..UAR1_PRW...
  21f0: 0a 08 0a 04 10 23 5c 5f 47 50 45 14 1c 5f 4c 30  .....#\_GPE.._L0
  2200: 38 00 86 5c 2f 04 5f 53 42 5f 50 43 49 30 53 42  8..\/._SB_PCI0SB
  2210: 52 47 55 41 52 31 0a 02 08 2e 55 41 52 32 5f 50  RGUAR1....UAR2_P
  2220: 52 57 12 06 02 0a 08 0a 04 14 12 50 4d 42 53 00  RW.........PMBS.
  2230: 7d 79 0a 08 0a 08 00 0a 00 60 a4 60 14 12 53 4d  }y.......`.`..SM
  2240: 42 53 00 7d 79 0a 0c 0a 08 00 0a 00 60 a4 60 5b  BS.}y.......`.`[
  2250: 80 50 57 52 47 01 50 4d 42 53 0a 80 5b 80 53 4d  .PWRG.PMBS..[.SM
  2260: 52 47 01 53 4d 42 53 0a 20 5b 82 4c dd 49 44 45  RG.SMBS. [.L.IDE
  2270: 43 08 5f 41 44 52 0c 05 00 02 00 08 52 54 54 5f  C._ADR......RTT_
  2280: 12 22 10 0a 0c 0a 01 0a 02 0a 03 0a 04 0a 05 0a  ."..............
  2290: 06 0a 07 0a 08 0a 09 0a 0a 0a 0b 0a 0d 0a 0e 0a  ................
  22a0: 0f 0a 0f 08 44 41 54 54 12 12 08 0a 08 0a 01 0a  ....DATT........
  22b0: 02 0a 03 0a 04 0a 05 0a 06 0a 0c 08 55 44 54 54  ............UDTT
  22c0: 12 1a 0c 0a 0a 0a 14 0a 1e 0a 28 0a 32 0a 3c 0a  ..........(.2.<.
  22d0: 46 0a 50 0a 5a 0a 64 0a 6e 0a 78 08 49 44 45 54  F.P.Z.d.n.x.IDET
  22e0: 12 38 03 12 13 07 0a 78 0a b4 0a f0 0b 86 01 0b  .8.....x........
  22f0: 58 02 0a 96 0b e0 01 12 10 07 0a 03 0a 03 0a 04  X...............
  2300: 0a 06 0a 08 0a 03 0a 08 12 10 07 0a 01 0a 03 0a  ................
  2310: 04 0a 07 0a 0c 0a 02 0a 08 08 55 44 4d 54 12 0e  ..........UDMT..
  2320: 06 0a 0b 0a 07 0a 05 0a 04 0a 02 0a 01 08 50 49  ..............PI
  2330: 4f 54 12 0e 06 0a 00 0a 07 0a 04 0a 03 0a 01 0a  OT..............
  2340: 01 08 44 4d 41 54 12 0c 05 0a 00 0a 01 0a 01 0a  ..DMAT..........
  2350: 01 0a 02 5b 80 43 46 34 30 02 0a 40 0a 0c 5b 81  ...[.CF40..@..[.
  2360: 45 07 43 46 34 30 02 52 43 54 30 04 44 41 54 30  E.CF40.RCT0.DAT0
  2370: 03 00 01 55 44 54 30 04 00 03 55 44 43 30 01 52  ...UDT0...UDC0.R
  2380: 43 54 31 04 44 41 54 31 03 00 01 55 44 54 31 04  CT1.DAT1...UDT1.
  2390: 00 03 55 44 43 31 01 52 43 54 32 04 44 41 54 32  ..UDC1.RCT2.DAT2
  23a0: 03 00 01 55 44 54 32 04 00 03 55 44 43 32 01 52  ...UDT2...UDC2.R
  23b0: 43 54 33 04 44 41 54 33 03 00 01 55 44 54 33 04  CT3.DAT3...UDT3.
  23c0: 00 03 55 44 43 33 01 00 10 00 01 43 30 45 4e 01  ..UDC3.....C0EN.
  23d0: 43 31 45 4e 01 08 49 44 45 50 11 03 0a 14 8a 49  C1EN..IDEP.....I
  23e0: 44 45 50 0a 00 47 54 4d 30 8a 49 44 45 50 0a 04  DEP..GTM0.IDEP..
  23f0: 47 54 4d 31 8a 49 44 45 50 0a 08 47 54 4d 32 8a  GTM1.IDEP..GTM2.
  2400: 49 44 45 50 0a 0c 47 54 4d 33 8a 49 44 45 50 0a  IDEP..GTM3.IDEP.
  2410: 10 47 54 4d 34 5b 82 47 61 49 44 45 30 08 5f 41  .GTM4[.GaIDE0._A
  2420: 44 52 0a 00 14 43 1e 5f 47 54 4d 00 70 0c ff ff  DR...C._GTM.p...
  2430: ff ff 60 70 0c ff ff ff ff 61 70 0c ff ff ff ff  ..`p.....ap.....
  2440: 62 70 0c ff ff ff ff 63 70 0a 10 64 a0 48 19 43  bp.....cp..d.H.C
  2450: 30 45 4e a0 48 0c 7c 93 44 41 54 30 0a 00 93 52  0EN.H.|.DAT0...R
  2460: 43 54 30 0a 00 00 70 83 88 5c 2f 04 5f 53 42 5f  CT0...p..\/._SB_
  2470: 50 43 49 30 49 44 45 43 52 54 54 5f 5c 2f 04 5f  PCI0IDECRTT_\/._
  2480: 53 42 5f 50 43 49 30 49 44 45 43 52 43 54 30 00  SB_PCI0IDECRCT0.
  2490: 65 70 83 88 5c 2f 04 5f 53 42 5f 50 43 49 30 49  ep..\/._SB_PCI0I
  24a0: 44 45 43 44 41 54 54 5c 2f 04 5f 53 42 5f 50 43  DECDATT\/._SB_PC
  24b0: 49 30 49 44 45 43 44 41 54 30 00 66 72 65 66 65  I0IDECDAT0.frefe
  24c0: 77 65 0a 1e 60 a0 0d 93 66 0a 03 7d 64 0a 02 64  we..`...f..}d..d
  24d0: 70 60 61 a0 48 04 93 5c 2f 04 5f 53 42 5f 50 43  p`a.H..\/._SB_PC
  24e0: 49 30 49 44 45 43 55 44 43 30 0a 01 70 83 88 5c  I0IDECUDC0..p..\
  24f0: 2f 04 5f 53 42 5f 50 43 49 30 49 44 45 43 55 44  /._SB_PCI0IDECUD
  2500: 54 54 5c 2f 04 5f 53 42 5f 50 43 49 30 49 44 45  TT\/._SB_PCI0IDE
  2510: 43 55 44 54 30 00 61 7d 64 0a 01 64 a0 48 0c 7c  CUDT0.a}d..d.H.|
  2520: 93 44 41 54 31 0a 00 93 52 43 54 31 0a 00 00 70  .DAT1...RCT1...p
  2530: 83 88 5c 2f 04 5f 53 42 5f 50 43 49 30 49 44 45  ..\/._SB_PCI0IDE
  2540: 43 52 54 54 5f 5c 2f 04 5f 53 42 5f 50 43 49 30  CRTT_\/._SB_PCI0
  2550: 49 44 45 43 52 43 54 31 00 65 70 83 88 5c 2f 04  IDECRCT1.ep..\/.
  2560: 5f 53 42 5f 50 43 49 30 49 44 45 43 44 41 54 54  _SB_PCI0IDECDATT
  2570: 5c 2f 04 5f 53 42 5f 50 43 49 30 49 44 45 43 44  \/._SB_PCI0IDECD
  2580: 41 54 31 00 66 72 65 66 65 77 65 0a 1e 62 a0 0d  AT1.frefewe..b..
  2590: 93 66 0a 03 7d 64 0a 08 64 70 62 63 a0 48 04 93  .f..}d..dpbc.H..
  25a0: 5c 2f 04 5f 53 42 5f 50 43 49 30 49 44 45 43 55  \/._SB_PCI0IDECU
  25b0: 44 43 31 0a 01 70 83 88 5c 2f 04 5f 53 42 5f 50  DC1..p..\/._SB_P
  25c0: 43 49 30 49 44 45 43 55 44 54 54 5c 2f 04 5f 53  CI0IDECUDTT\/._S
  25d0: 42 5f 50 43 49 30 49 44 45 43 55 44 54 31 00 63  B_PCI0IDECUDT1.c
  25e0: 7d 64 0a 04 64 70 60 47 54 4d 30 70 61 47 54 4d  }d..dp`GTM0paGTM
  25f0: 31 70 62 47 54 4d 32 70 63 47 54 4d 33 70 64 47  1pbGTM2pcGTM3pdG
  2600: 54 4d 34 a4 49 44 45 50 14 4d 20 5f 53 54 4d 03  TM4.IDEP.M _STM.
  2610: 70 68 49 44 45 50 70 47 54 4d 30 60 70 47 54 4d  phIDEPpGTM0`pGTM
  2620: 31 61 70 47 54 4d 32 62 70 47 54 4d 33 63 70 47  1apGTM2bpGTM3cpG
  2630: 54 4d 34 64 a0 41 04 90 92 93 61 0c ff ff ff ff  TM4d.A....a.....
  2640: 92 93 61 0a 00 a0 30 7b 64 0a 01 00 70 0a 01 55  ..a...0{d...p..U
  2650: 44 43 30 70 89 5c 2f 04 5f 53 42 5f 50 43 49 30  DC0p.\/._SB_PCI0
  2660: 49 44 45 43 55 44 54 54 01 61 00 0a 00 0a 00 65  IDECUDTT.a.....e
  2670: 70 65 55 44 54 30 a0 4e 0a 90 92 93 60 0c ff ff  peUDT0.N....`...
  2680: ff ff 92 93 60 0a 00 70 89 83 88 5c 2f 04 5f 53  ....`..p...\/._S
  2690: 42 5f 50 43 49 30 49 44 45 43 49 44 45 54 0a 00  B_PCI0IDECIDET..
  26a0: 00 01 60 00 0a 00 0a 00 66 70 83 88 83 88 5c 2f  ..`.....fp....\/
  26b0: 04 5f 53 42 5f 50 43 49 30 49 44 45 43 49 44 45  ._SB_PCI0IDECIDE
  26c0: 54 0a 01 00 66 00 67 70 89 5c 2f 04 5f 53 42 5f  T...f.gp.\/._SB_
  26d0: 50 43 49 30 49 44 45 43 44 41 54 54 01 67 00 0a  PCI0IDECDATT.g..
  26e0: 00 0a 00 44 41 54 30 70 83 88 83 88 5c 2f 04 5f  ...DAT0p....\/._
  26f0: 53 42 5f 50 43 49 30 49 44 45 43 49 44 45 54 0a  SB_PCI0IDECIDET.
  2700: 02 00 66 00 67 70 89 5c 2f 04 5f 53 42 5f 50 43  ..f.gp.\/._SB_PC
  2710: 49 30 49 44 45 43 52 54 54 5f 01 67 00 0a 00 0a  I0IDECRTT_.g....
  2720: 00 52 43 54 30 a0 41 04 90 92 93 63 0c ff ff ff  .RCT0.A....c....
  2730: ff 92 93 63 0a 00 a0 30 7b 64 0a 04 00 70 0a 01  ...c...0{d...p..
  2740: 55 44 43 31 70 89 5c 2f 04 5f 53 42 5f 50 43 49  UDC1p.\/._SB_PCI
  2750: 30 49 44 45 43 55 44 54 54 01 63 00 0a 00 0a 00  0IDECUDTT.c.....
  2760: 65 70 65 55 44 54 31 a0 4e 0a 90 92 93 62 0c ff  epeUDT1.N....b..
  2770: ff ff ff 92 93 62 0a 00 70 89 83 88 5c 2f 04 5f  .....b..p...\/._
  2780: 53 42 5f 50 43 49 30 49 44 45 43 49 44 45 54 0a  SB_PCI0IDECIDET.
  2790: 00 00 01 62 00 0a 00 0a 00 66 70 83 88 83 88 5c  ...b.....fp....\
  27a0: 2f 04 5f 53 42 5f 50 43 49 30 49 44 45 43 49 44  /._SB_PCI0IDECID
  27b0: 45 54 0a 01 00 66 00 67 70 89 5c 2f 04 5f 53 42  ET...f.gp.\/._SB
  27c0: 5f 50 43 49 30 49 44 45 43 44 41 54 54 01 67 00  _PCI0IDECDATT.g.
  27d0: 0a 00 0a 00 44 41 54 31 70 83 88 83 88 5c 2f 04  ....DAT1p....\/.
  27e0: 5f 53 42 5f 50 43 49 30 49 44 45 43 49 44 45 54  _SB_PCI0IDECIDET
  27f0: 0a 02 00 66 00 67 70 89 5c 2f 04 5f 53 42 5f 50  ...f.gp.\/._SB_P
  2800: 43 49 30 49 44 45 43 52 54 54 5f 01 67 00 0a 00  CI0IDECRTT_.g...
  2810: 0a 00 52 43 54 31 5b 82 4a 10 44 52 56 30 08 5f  ..RCT1[.J.DRV0._
  2820: 41 44 52 0a 00 14 4c 0f 5f 47 54 46 00 70 11 0a  ADR...L._GTF.p..
  2830: 0a 07 03 00 00 00 00 a0 ef 66 70 11 0a 0a 07 03  .........fp.....
  2840: 00 00 00 00 a0 ef 67 8c 66 0a 01 4d 4f 44 45 8c  ......g.f..MODE.
  2850: 67 0a 01 55 4d 4f 44 a0 44 0c 7c 93 44 41 54 30  g..UMOD.D.|.DAT0
  2860: 0a 00 93 52 43 54 30 0a 00 00 a0 33 55 44 43 30  ...RCT0....3UDC0
  2870: 70 89 5c 2f 04 5f 53 42 5f 50 43 49 30 49 44 45  p.\/._SB_PCI0IDE
  2880: 43 55 44 4d 54 01 55 44 54 30 00 0a 00 0a 00 55  CUDMT.UDT0.....U
  2890: 4d 4f 44 7d 55 4d 4f 44 0a 40 55 4d 4f 44 a1 4f  MOD}UMOD.@UMOD.O
  28a0: 04 70 89 5c 2f 04 5f 53 42 5f 50 43 49 30 49 44  .p.\/._SB_PCI0ID
  28b0: 45 43 50 49 4f 54 01 52 43 54 30 00 0a 00 0a 00  ECPIOT.RCT0.....
  28c0: 4d 4f 44 45 70 83 88 5c 2f 04 5f 53 42 5f 50 43  MODEp..\/._SB_PC
  28d0: 49 30 49 44 45 43 44 4d 41 54 4d 4f 44 45 00 55  I0IDECDMATMODE.U
  28e0: 4d 4f 44 7d 55 4d 4f 44 0a 20 55 4d 4f 44 70 89  MOD}UMOD. UMODp.
  28f0: 5c 2f 04 5f 53 42 5f 50 43 49 30 49 44 45 43 50  \/._SB_PCI0IDECP
  2900: 49 4f 54 01 52 43 54 30 00 0a 00 0a 00 4d 4f 44  IOT.RCT0.....MOD
  2910: 45 7d 4d 4f 44 45 0a 08 4d 4f 44 45 73 66 67 65  E}MODE..MODEsfge
  2920: a4 65 5b 82 4a 10 44 52 56 31 08 5f 41 44 52 0a  .e[.J.DRV1._ADR.
  2930: 01 14 4c 0f 5f 47 54 46 00 70 11 0a 0a 07 03 00  ..L._GTF.p......
  2940: 00 00 00 b0 ef 66 70 11 0a 0a 07 03 00 00 00 00  .....fp.........
  2950: b0 ef 67 8c 66 0a 01 4d 4f 44 45 8c 67 0a 01 55  ..g.f..MODE.g..U
  2960: 4d 4f 44 a0 44 0c 7c 93 44 41 54 31 0a 00 93 52  MOD.D.|.DAT1...R
  2970: 43 54 31 0a 00 00 a0 33 55 44 43 31 70 89 5c 2f  CT1....3UDC1p.\/
  2980: 04 5f 53 42 5f 50 43 49 30 49 44 45 43 55 44 4d  ._SB_PCI0IDECUDM
  2990: 54 01 55 44 54 31 00 0a 00 0a 00 55 4d 4f 44 7d  T.UDT1.....UMOD}
  29a0: 55 4d 4f 44 0a 40 55 4d 4f 44 a1 4f 04 70 89 5c  UMOD.@UMOD.O.p.\
  29b0: 2f 04 5f 53 42 5f 50 43 49 30 49 44 45 43 50 49  /._SB_PCI0IDECPI
  29c0: 4f 54 01 52 43 54 31 00 0a 00 0a 00 4d 4f 44 45  OT.RCT1.....MODE
  29d0: 70 83 88 5c 2f 04 5f 53 42 5f 50 43 49 30 49 44  p..\/._SB_PCI0ID
  29e0: 45 43 44 4d 41 54 4d 4f 44 45 00 55 4d 4f 44 7d  ECDMATMODE.UMOD}
  29f0: 55 4d 4f 44 0a 20 55 4d 4f 44 70 89 5c 2f 04 5f  UMOD. UMODp.\/._
  2a00: 53 42 5f 50 43 49 30 49 44 45 43 50 49 4f 54 01  SB_PCI0IDECPIOT.
  2a10: 52 43 54 31 00 0a 00 0a 00 4d 4f 44 45 7d 4d 4f  RCT1.....MODE}MO
  2a20: 44 45 0a 08 4d 4f 44 45 73 66 67 65 a4 65 5b 82  DE..MODEsfge.e[.
  2a30: 47 61 49 44 45 31 08 5f 41 44 52 0a 01 14 43 1e  GaIDE1._ADR...C.
  2a40: 5f 47 54 4d 00 70 0c ff ff ff ff 60 70 0c ff ff  _GTM.p.....`p...
  2a50: ff ff 61 70 0c ff ff ff ff 62 70 0c ff ff ff ff  ..ap.....bp.....
  2a60: 63 70 0a 10 64 a0 48 19 43 31 45 4e a0 48 0c 7c  cp..d.H.C1EN.H.|
  2a70: 93 44 41 54 32 0a 00 93 52 43 54 32 0a 00 00 70  .DAT2...RCT2...p
  2a80: 83 88 5c 2f 04 5f 53 42 5f 50 43 49 30 49 44 45  ..\/._SB_PCI0IDE
  2a90: 43 52 54 54 5f 5c 2f 04 5f 53 42 5f 50 43 49 30  CRTT_\/._SB_PCI0
  2aa0: 49 44 45 43 52 43 54 32 00 65 70 83 88 5c 2f 04  IDECRCT2.ep..\/.
  2ab0: 5f 53 42 5f 50 43 49 30 49 44 45 43 44 41 54 54  _SB_PCI0IDECDATT
  2ac0: 5c 2f 04 5f 53 42 5f 50 43 49 30 49 44 45 43 44  \/._SB_PCI0IDECD
  2ad0: 41 54 32 00 66 72 65 66 65 77 65 0a 1e 60 a0 0d  AT2.frefewe..`..
  2ae0: 93 66 0a 03 7d 64 0a 02 64 70 60 61 a0 48 04 93  .f..}d..dp`a.H..
  2af0: 5c 2f 04 5f 53 42 5f 50 43 49 30 49 44 45 43 55  \/._SB_PCI0IDECU
  2b00: 44 43 32 0a 01 70 83 88 5c 2f 04 5f 53 42 5f 50  DC2..p..\/._SB_P
  2b10: 43 49 30 49 44 45 43 55 44 54 54 5c 2f 04 5f 53  CI0IDECUDTT\/._S
  2b20: 42 5f 50 43 49 30 49 44 45 43 55 44 54 32 00 61  B_PCI0IDECUDT2.a
  2b30: 7d 64 0a 01 64 a0 48 0c 7c 93 44 41 54 33 0a 00  }d..d.H.|.DAT3..
  2b40: 93 52 43 54 33 0a 00 00 70 83 88 5c 2f 04 5f 53  .RCT3...p..\/._S
  2b50: 42 5f 50 43 49 30 49 44 45 43 52 54 54 5f 5c 2f  B_PCI0IDECRTT_\/
  2b60: 04 5f 53 42 5f 50 43 49 30 49 44 45 43 52 43 54  ._SB_PCI0IDECRCT
  2b70: 33 00 65 70 83 88 5c 2f 04 5f 53 42 5f 50 43 49  3.ep..\/._SB_PCI
  2b80: 30 49 44 45 43 44 41 54 54 5c 2f 04 5f 53 42 5f  0IDECDATT\/._SB_
  2b90: 50 43 49 30 49 44 45 43 44 41 54 33 00 66 72 65  PCI0IDECDAT3.fre
  2ba0: 66 65 77 65 0a 1e 62 a0 0d 93 66 0a 03 7d 64 0a  fewe..b...f..}d.
  2bb0: 08 64 70 62 63 a0 48 04 93 5c 2f 04 5f 53 42 5f  .dpbc.H..\/._SB_
  2bc0: 50 43 49 30 49 44 45 43 55 44 43 33 0a 01 70 83  PCI0IDECUDC3..p.
  2bd0: 88 5c 2f 04 5f 53 42 5f 50 43 49 30 49 44 45 43  .\/._SB_PCI0IDEC
  2be0: 55 44 54 54 5c 2f 04 5f 53 42 5f 50 43 49 30 49  UDTT\/._SB_PCI0I
  2bf0: 44 45 43 55 44 54 33 00 63 7d 64 0a 04 64 70 60  DECUDT3.c}d..dp`
  2c00: 47 54 4d 30 70 61 47 54 4d 31 70 62 47 54 4d 32  GTM0paGTM1pbGTM2
  2c10: 70 63 47 54 4d 33 70 64 47 54 4d 34 a4 49 44 45  pcGTM3pdGTM4.IDE
  2c20: 50 14 4d 20 5f 53 54 4d 03 70 68 49 44 45 50 70  P.M _STM.phIDEPp
  2c30: 47 54 4d 30 60 70 47 54 4d 31 61 70 47 54 4d 32  GTM0`pGTM1apGTM2
  2c40: 62 70 47 54 4d 33 63 70 47 54 4d 34 64 a0 41 04  bpGTM3cpGTM4d.A.
  2c50: 90 92 93 61 0c ff ff ff ff 92 93 61 0a 00 a0 30  ...a.......a...0
  2c60: 7b 64 0a 01 00 70 0a 01 55 44 43 32 70 89 5c 2f  {d...p..UDC2p.\/
  2c70: 04 5f 53 42 5f 50 43 49 30 49 44 45 43 55 44 54  ._SB_PCI0IDECUDT
  2c80: 54 01 61 00 0a 00 0a 00 65 70 65 55 44 54 32 a0  T.a.....epeUDT2.
  2c90: 4e 0a 90 92 93 60 0c ff ff ff ff 92 93 60 0a 00  N....`.......`..
  2ca0: 70 89 83 88 5c 2f 04 5f 53 42 5f 50 43 49 30 49  p...\/._SB_PCI0I
  2cb0: 44 45 43 49 44 45 54 0a 00 00 01 60 00 0a 00 0a  DECIDET....`....
  2cc0: 00 66 70 83 88 83 88 5c 2f 04 5f 53 42 5f 50 43  .fp....\/._SB_PC
  2cd0: 49 30 49 44 45 43 49 44 45 54 0a 01 00 66 00 67  I0IDECIDET...f.g
  2ce0: 70 89 5c 2f 04 5f 53 42 5f 50 43 49 30 49 44 45  p.\/._SB_PCI0IDE
  2cf0: 43 44 41 54 54 01 67 00 0a 00 0a 00 44 41 54 32  CDATT.g.....DAT2
  2d00: 70 83 88 83 88 5c 2f 04 5f 53 42 5f 50 43 49 30  p....\/._SB_PCI0
  2d10: 49 44 45 43 49 44 45 54 0a 02 00 66 00 67 70 89  IDECIDET...f.gp.
  2d20: 5c 2f 04 5f 53 42 5f 50 43 49 30 49 44 45 43 52  \/._SB_PCI0IDECR
  2d30: 54 54 5f 01 67 00 0a 00 0a 00 52 43 54 32 a0 41  TT_.g.....RCT2.A
  2d40: 04 90 92 93 63 0c ff ff ff ff 92 93 63 0a 00 a0  ....c.......c...
  2d50: 30 7b 64 0a 04 00 70 0a 01 55 44 43 33 70 89 5c  0{d...p..UDC3p.\
  2d60: 2f 04 5f 53 42 5f 50 43 49 30 49 44 45 43 55 44  /._SB_PCI0IDECUD
  2d70: 54 54 01 63 00 0a 00 0a 00 65 70 65 55 44 54 33  TT.c.....epeUDT3
  2d80: a0 4e 0a 90 92 93 62 0c ff ff ff ff 92 93 62 0a  .N....b.......b.
  2d90: 00 70 89 83 88 5c 2f 04 5f 53 42 5f 50 43 49 30  .p...\/._SB_PCI0
  2da0: 49 44 45 43 49 44 45 54 0a 00 00 01 62 00 0a 00  IDECIDET....b...
  2db0: 0a 00 66 70 83 88 83 88 5c 2f 04 5f 53 42 5f 50  ..fp....\/._SB_P
  2dc0: 43 49 30 49 44 45 43 49 44 45 54 0a 01 00 66 00  CI0IDECIDET...f.
  2dd0: 67 70 89 5c 2f 04 5f 53 42 5f 50 43 49 30 49 44  gp.\/._SB_PCI0ID
  2de0: 45 43 44 41 54 54 01 67 00 0a 00 0a 00 44 41 54  ECDATT.g.....DAT
  2df0: 33 70 83 88 83 88 5c 2f 04 5f 53 42 5f 50 43 49  3p....\/._SB_PCI
  2e00: 30 49 44 45 43 49 44 45 54 0a 02 00 66 00 67 70  0IDECIDET...f.gp
  2e10: 89 5c 2f 04 5f 53 42 5f 50 43 49 30 49 44 45 43  .\/._SB_PCI0IDEC
  2e20: 52 54 54 5f 01 67 00 0a 00 0a 00 52 43 54 33 5b  RTT_.g.....RCT3[
  2e30: 82 4a 10 44 52 56 30 08 5f 41 44 52 0a 00 14 4c  .J.DRV0._ADR...L
  2e40: 0f 5f 47 54 46 00 70 11 0a 0a 07 03 00 00 00 00  ._GTF.p.........
  2e50: a0 ef 66 70 11 0a 0a 07 03 00 00 00 00 a0 ef 67  ..fp...........g
  2e60: 8c 66 0a 01 4d 4f 44 45 8c 67 0a 01 55 4d 4f 44  .f..MODE.g..UMOD
  2e70: a0 44 0c 7c 93 44 41 54 32 0a 00 93 52 43 54 32  .D.|.DAT2...RCT2
  2e80: 0a 00 00 a0 33 55 44 43 32 70 89 5c 2f 04 5f 53  ....3UDC2p.\/._S
  2e90: 42 5f 50 43 49 30 49 44 45 43 55 44 4d 54 01 55  B_PCI0IDECUDMT.U
  2ea0: 44 54 32 00 0a 00 0a 00 55 4d 4f 44 7d 55 4d 4f  DT2.....UMOD}UMO
  2eb0: 44 0a 40 55 4d 4f 44 a1 4f 04 70 89 5c 2f 04 5f  D.@UMOD.O.p.\/._
  2ec0: 53 42 5f 50 43 49 30 49 44 45 43 50 49 4f 54 01  SB_PCI0IDECPIOT.
  2ed0: 52 43 54 32 00 0a 00 0a 00 4d 4f 44 45 70 83 88  RCT2.....MODEp..
  2ee0: 5c 2f 04 5f 53 42 5f 50 43 49 30 49 44 45 43 44  \/._SB_PCI0IDECD
  2ef0: 4d 41 54 4d 4f 44 45 00 55 4d 4f 44 7d 55 4d 4f  MATMODE.UMOD}UMO
  2f00: 44 0a 20 55 4d 4f 44 70 89 5c 2f 04 5f 53 42 5f  D. UMODp.\/._SB_
  2f10: 50 43 49 30 49 44 45 43 50 49 4f 54 01 52 43 54  PCI0IDECPIOT.RCT
  2f20: 32 00 0a 00 0a 00 4d 4f 44 45 7d 4d 4f 44 45 0a  2.....MODE}MODE.
  2f30: 08 4d 4f 44 45 73 66 67 65 a4 65 5b 82 4a 10 44  .MODEsfge.e[.J.D
  2f40: 52 56 31 08 5f 41 44 52 0a 01 14 4c 0f 5f 47 54  RV1._ADR...L._GT
  2f50: 46 00 70 11 0a 0a 07 03 00 00 00 00 b0 ef 66 70  F.p...........fp
  2f60: 11 0a 0a 07 03 00 00 00 00 b0 ef 67 8c 66 0a 01  ...........g.f..
  2f70: 4d 4f 44 45 8c 67 0a 01 55 4d 4f 44 a0 44 0c 7c  MODE.g..UMOD.D.|
  2f80: 93 44 41 54 33 0a 00 93 52 43 54 33 0a 00 00 a0  .DAT3...RCT3....
  2f90: 33 55 44 43 33 70 89 5c 2f 04 5f 53 42 5f 50 43  3UDC3p.\/._SB_PC
  2fa0: 49 30 49 44 45 43 55 44 4d 54 01 55 44 54 33 00  I0IDECUDMT.UDT3.
  2fb0: 0a 00 0a 00 55 4d 4f 44 7d 55 4d 4f 44 0a 40 55  ....UMOD}UMOD.@U
  2fc0: 4d 4f 44 a1 4f 04 70 89 5c 2f 04 5f 53 42 5f 50  MOD.O.p.\/._SB_P
  2fd0: 43 49 30 49 44 45 43 50 49 4f 54 01 52 43 54 33  CI0IDECPIOT.RCT3
  2fe0: 00 0a 00 0a 00 4d 4f 44 45 70 83 88 5c 2f 04 5f  .....MODEp..\/._
  2ff0: 53 42 5f 50 43 49 30 49 44 45 43 44 4d 41 54 4d  SB_PCI0IDECDMATM
  3000: 4f 44 45 00 55 4d 4f 44 7d 55 4d 4f 44 0a 20 55  ODE.UMOD}UMOD. U
  3010: 4d 4f 44 70 89 5c 2f 04 5f 53 42 5f 50 43 49 30  MODp.\/._SB_PCI0
  3020: 49 44 45 43 50 49 4f 54 01 52 43 54 33 00 0a 00  IDECPIOT.RCT3...
  3030: 0a 00 4d 4f 44 45 7d 4d 4f 44 45 0a 08 4d 4f 44  ..MODE}MODE..MOD
  3040: 45 73 66 67 65 a4 65 5b 82 3b 55 53 42 31 08 5f  Esfge.e[.;USB1._
  3050: 41 44 52 0c 02 00 02 00 08 5f 50 52 57 12 06 02  ADR......_PRW...
  3060: 0a 0e 0a 04 10 1f 5c 5f 47 50 45 14 18 5f 4c 30  ......\_GPE.._L0
  3070: 45 00 86 5c 2f 03 5f 53 42 5f 50 43 49 30 55 53  E..\/._SB_PCI0US
  3080: 42 31 0a 02 5b 82 3b 55 53 42 32 08 5f 41 44 52  B1..[.;USB2._ADR
  3090: 0c 03 00 02 00 08 5f 50 52 57 12 06 02 0a 04 0a  ......_PRW......
  30a0: 04 10 1f 5c 5f 47 50 45 14 18 5f 4c 30 34 00 86  ...\_GPE.._L04..
  30b0: 5c 2f 03 5f 53 42 5f 50 43 49 30 55 53 42 32 0a  \/._SB_PCI0USB2.
  30c0: 02 5b 82 3b 4c 41 4e 5f 08 5f 41 44 52 0c 00 00  .[.;LAN_._ADR...
  30d0: 03 00 08 5f 50 52 57 12 06 02 0a 0c 0a 04 10 1f  ..._PRW.........
  30e0: 5c 5f 47 50 45 14 18 5f 4c 30 43 00 86 5c 2f 03  \_GPE.._L0C..\/.
  30f0: 5f 53 42 5f 50 43 49 30 4c 41 4e 5f 0a 02 5b 82  _SB_PCI0LAN_..[.
  3100: 3b 4d 44 4d 5f 08 5f 41 44 52 0c 06 00 02 00 08  ;MDM_._ADR......
  3110: 5f 50 52 57 12 06 02 0a 05 0a 04 10 1f 5c 5f 47  _PRW.........\_G
  3120: 50 45 14 18 5f 4c 30 35 00 86 5c 2f 03 5f 53 42  PE.._L05..\/._SB
  3130: 5f 50 43 49 30 4d 44 4d 5f 0a 02 5b 82 3b 41 55  _PCI0MDM_..[.;AU
  3140: 44 5f 08 5f 41 44 52 0c 07 00 02 00 08 5f 50 52  D_._ADR......_PR
  3150: 57 12 06 02 0a 0a 0a 04 10 1f 5c 5f 47 50 45 14  W.........\_GPE.
  3160: 18 5f 4c 30 41 00 86 5c 2f 03 5f 53 42 5f 50 43  ._L0A..\/._SB_PC
  3170: 49 30 41 55 44 5f 0a 02 08 5f 50 52 57 12 06 02  I0AUD_..._PRW...
  3180: 0a 0b 0a 04 10 1a 5c 5f 47 50 45 14 13 5f 4c 30  ......\_GPE.._L0
  3190: 42 00 86 5c 2e 5f 53 42 5f 50 43 49 30 0a 02 08  B..\._SB_PCI0...
  31a0: 53 4c 50 53 0a 00 5b 82 44 06 53 4c 50 42 08 5f  SLPS..[.D.SLPB._
  31b0: 48 49 44 0c 41 d0 0c 0e 14 2a 53 42 45 56 00 a0  HID.A....*SBEV..
  31c0: 13 53 4c 50 53 70 0a 00 53 4c 50 53 86 53 4c 50  .SLPSp..SLPS.SLP
  31d0: 42 0a 02 a1 0f 70 0a 01 53 4c 50 53 86 53 4c 50  B....p..SLPS.SLP
  31e0: 42 0a 80 10 1c 5c 5f 47 50 45 14 15 5f 4c 30 32  B....\_GPE.._L02
  31f0: 00 5c 2f 03 5f 53 42 5f 53 4c 50 42 53 42 45 56  .\/._SB_SLPBSBEV
  3200: 08 5f 50 52 57 12 06 02 0a 02 0a 04 5b 80 46 4e  ._PRW.......[.FN
  3210: 4f 52 01 0b 34 04 0a 04 5b 80 53 49 4f 52 01 0b  OR..4...[.SIOR..
  3220: 70 03 0a 02 5b 81 10 53 49 4f 52 01 53 49 4e 44  p...[..SIOR.SIND
  3230: 08 53 44 54 41 08 5b 80 53 4c 45 44 01 0b 62 08  .SDTA.[.SLED..b.
  3240: 0a 01 5b 81 0d 53 4c 45 44 01 00 06 52 30 36 32  ..[..SLED...R062
  3250: 02 10 4e 04 5f 53 49 5f 14 47 04 5f 53 53 54 01  ..N._SI_.G._SST.
  3260: a0 36 68 a0 0c 93 68 0a 01 70 0a 00 52 30 36 32  .6h...h..p..R062
  3270: a0 0c 93 68 0a 02 70 0a 00 52 30 36 32 a0 0c 93  ...h..p..R062...
  3280: 68 0a 03 70 0a 01 52 30 36 32 a0 0c 93 68 0a 04  h..p..R062...h..
  3290: 70 0a 02 52 30 36 32 a1 08 70 0a 00 52 30 36 32  p..R062..p..R062
  32a0: 14 4e 04 5f 50 54 53 01 70 68 44 42 47 38 7d 68  .N._PTS.phDBG8}h
  32b0: 0a a0 60 70 60 50 34 38 5f 5b 22 0a 64 7d 68 0a  ..`p`P48_[".d}h.
  32c0: b0 60 70 60 50 34 39 5f 70 0b 04 08 50 35 32 5f  .`p`P49_p...P52_
  32d0: 70 0a 01 50 35 35 5f 7d 50 34 32 5f 0a 08 50 34  p..P55_}P42_..P4
  32e0: 32 5f 70 0a 01 5c 2e 5f 53 42 5f 53 4c 50 53 14  2_p..\._SB_SLPS.
  32f0: 25 5f 57 41 4b 01 79 68 0a 04 44 42 47 38 a0 16  %_WAK.yh..DBG8..
  3300: 92 93 68 0a 04 72 68 0a 06 60 7d 60 0a a0 60 70  ..h..rh..`}`..`p
  3310: 60 50 34 38 5f 5b 80 50 52 34 38 01 0b 48 08 0a  `P48_[.PR48..H..
  3320: 01 5b 81 0b 50 52 34 38 01 50 34 38 5f 08 5b 80  .[..PR48.P48_.[.
  3330: 50 52 34 32 01 0b 42 08 0a 01 5b 81 0b 50 52 34  PR42..B...[..PR4
  3340: 32 01 50 34 32 5f 08 5b 80 50 52 34 39 01 0b 49  2.P42_.[.PR49..I
  3350: 08 0a 01 5b 81 0b 50 52 34 39 01 50 34 39 5f 08  ...[..PR49.P49_.
  3360: 5b 80 50 52 35 32 01 0b 52 08 0a 02 5b 81 0b 50  [.PR52..R...[..P
  3370: 52 35 32 02 50 35 32 5f 10 5b 80 50 52 35 35 01  R52.P52_.[.PR55.
  3380: 0b 55 08 0a 01 5b 81 0b 50 52 35 35 01 50 35 35  .U...[..PR55.P55
  3390: 5f 08 5b 80 54 45 4d 50 01 0a 80 0a 01 5b 81 0b  _.[.TEMP.....[..
  33a0: 54 45 4d 50 01 44 42 47 38 08 5b 80 44 45 42 30  TEMP.DBG8.[.DEB0
  33b0: 01 0a 90 0a 02 5b 81 0b 44 45 42 30 02 44 42 47  .....[..DEB0.DBG
  33c0: 39 10                                            9.

FACS @ 0x1fff8000
  0000: 46 41 43 53 40 00 00 00 00 00 00 00 00 00 00 00  FACS@...........
  0010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

FACP @ 0x1fff0030
  0000: 46 41 43 50 74 00 00 00 01 8c 41 4d 49 49 4e 54  FACPt.....AMIINT
  0010: 53 69 53 37 33 35 58 58 00 10 00 00 4d 53 46 54  SiS735XX....MSFT
  0020: 0b 00 00 01 00 80 ff 1f 00 01 ff 1f 00 00 09 00  ................
  0030: 48 08 00 00 e1 1e 1f 00 00 08 00 00 00 00 00 00  H...............
  0040: 04 08 00 00 00 00 00 00 00 00 00 00 08 08 00 00  ................
  0050: 20 08 00 00 30 08 00 00 04 02 00 04 04 04 10 00   ...0...........
  0060: 64 00 e8 03 00 04 10 00 01 03 0d 00 00 00 00 00  d...............
  0070: 21 00 00 00                                      !...

RSDT @ 0x1fff0000
  0000: 52 53 44 54 28 00 00 00 01 d6 41 4d 49 49 4e 54  RSDT(.....AMIINT
  0010: 53 69 53 37 33 35 58 58 00 10 00 00 4d 53 46 54  SiS735XX....MSFT
  0020: 0b 00 00 01 30 00 ff 1f                          ....0...

RSD PTR @ 0xfa340
  0000: 52 53 44 20 50 54 52 20 8c 41 4d 49 20 20 20 00  RSD PTR .AMI   .
  0010: 00 00 ff 1f                                      ....


Thanks,
Andre
