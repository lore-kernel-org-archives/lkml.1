Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbYCTSKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbYCTSKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 14:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbYCTSKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 14:10:11 -0400
Received: from web34508.mail.mud.yahoo.com ([66.163.178.174]:21818 "HELO
	web34508.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753603AbYCTSKJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 14:10:09 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Mar 2008 14:10:09 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=LvdfKeFv+UXtGGKNEWyoUZONP1yFcdTuAKe5tBdp5lZBX38hQ1h45npA0DG2X8ucSJb++hwB8FcsXvboPdFCUROnBzhlOC/wAd2Ww6yPi/VJXcAWVdh8Dsn+pCOGTIstp/lK+9DTykC7kbPiX3GnO/foye8abrnlpkhEZtbKcOo=;
X-YMail-OSG: ivq75CAVM1nO0OYlkyeS0f81crycXl80PNokj.5phbgs71.P.KxRhtZznFudKg23QePZQI0vdw--
X-Mailer: YahooMailRC/902.38 YahooMailWebService/0.7.162
Date: Thu, 20 Mar 2008 11:03:26 -0700 (PDT)
From: osb972ww-linuxczmil@yahoo.com
Subject: Fw: 2.6.24.X: SATA/AHCI related boot delay. - not with 2.6.24.3
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <343296.8242.qm@web34508.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Greetings,
  I'm having a problem with 2.6.23.1-42 (Fedora 8) properly driving a SATA 
drive.  Although it is detected during boot as indicated by the dmesg below, 
once the sytstem is up and running, the drive is not accessible.   The second 
issue is with the CFdrive on the the primary IDE.  It works, but I can't enable 
interrupts with hdparm -u 1 /dev/sda.   

 The interesting thing is when I put in a Fedora 5 system with a 2.6.17 kernel, 
everything works as expected.  I can hdparm -u 1 /dev/hda and it works as  expected, and
 the SATA drive is detected and works properly all on the exact  same hardware.  
 
 I've tried several different SATA drives also.   Thery all work on the old 
 Fedora 5/ 2.6.17 system, and none work on Fedora 8/2.6.23 or 2.6.24 kernels.

W. Wright
 
 
 
 Below I've included parts of dmesg:

 
> Linux version 2.6.23.1-42.fc8 (kojibuilder@xenbuilder4.fedora.phx.redhat.com) 
> (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)) #1 SMP Tue Oct 30 13:55:12 EDT 
> 2007
> 
> SCSI subsystem initialized
> irq 18: nobody cared (try booting with the "irqpoll" option)
>  [] __report_bad_irq+0x36/0x75
>  [] note_interrupt+0x1d7/0x213
>  [] usb_hcd_irq+0x21/0x4e
>  [] handle_IRQ_event+0x23/0x51
>  [] handle_fasteoi_irq+0x86/0xa6
>  [] handle_fasteoi_irq+0x0/0xa6
>  [] do_IRQ+0x8c/0xb9
>  [] irq_exit+0x53/0x6b
>  [] common_interrupt+0x23/0x28
>  [] sha_transform+0xd1/0x1fd
>  [] sha1_update+0x91/0xcc
>  [] update_kernel+0xf/0x1f
>  [] module_verify_signature+0x4a8/0x564
>  [] module_verify+0x4d/0x6c
>  [] do_IRQ+0x9f/0xb9
>  [] sys_init_module+0xe2/0x1651
>  [] handle_mm_fault+0x3a0/0x78b
>  [] autoremove_wake_function+0x0/0x35
>  [] do_page_fault+0x2c0/0x5ef
>  [] dput+0x30/0xd7
>  [] __fput+0x147/0x171
>  [] mntput_no_expire+0x11/0x6a
>  [] irq_exit+0x53/0x6b
>  [] syscall_call+0x7/0xb
>  =======================
> handlers:
> [] (usb_hcd_irq+0x0/0x4e)
> Disabling IRQ #18
> libata version 2.21 loaded.
> ata_piix 0000:00:1f.1: version 2.12
> ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 19
> PCI: Setting latency timer of device 0000:00:1f.1 to 64
> scsi0 : ata_piix
> scsi1 : ata_piix
> ata1: PATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001f800 irq 14
> ata2: PATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001f808 irq 15
> usb 1-2: configuration #1 chosen from 1 choice
> ata1.00: ATA-0: CF 8GB, 20071116, max MWDMA2
> ata1.00: 15858864 sectors, multi 0: LBA
> ata1.00: configured for MWDMA2
> ata2: port disabled. ignoring.
> scsi 0:0:0:0: Direct-Access     ATA      CF 8GB           2007 PQ: 0 ANSI: 5
> sd 0:0:0:0: [sda] 15858864 512-byte hardware sectors (8120 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support 
> DPO or FUA
> sd 0:0:0:0: [sda] 15858864 512-byte hardware sectors (8120 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support 
> DPO or FUA
>  sda: sda1
> sd 0:0:0:0: [sda] Attached SCSI disk
> ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
> ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 18
> PCI: Setting latency timer of device 0000:00:1f.2 to 64
> scsi2 : ata_piix
> scsi3 : ata_piix
> ata3: SATA max UDMA/133 cmd 0x0001f700 ctl 0x0001f602 bmdma 0x0001f300 irq 18
> ata4: SATA max UDMA/133 cmd 0x0001f500 ctl 0x0001f402 bmdma 0x0001f308 irq 18
> usb 1-3: new high speed USB device using ehci_hcd and address 4
> usb 1-3: configuration #1 chosen from 1 choice
> usb 2-1: new low speed USB device using uhci_hcd and address 2
> usb 2-1: configuration #1 chosen from 1 choice
> input: Microsoft Microsoft IntelliMouse® Optical as /class/input/input2
> input: USB HID v1.00 Mouse [Microsoft Microsoft IntelliMouse® Optical] on 
> usb-0000:00:1d.0-1
> ata3.01: qc timeout (cmd 0x27)
> ata3.01: ata_hpa_resize 1: hpa sectors (0) is smaller than sectors (312581808)
> ata3.01: ATA-7: ST3160815AS, 4.AAB, max UDMA/133
> ata3.01: 312581808 sectors, multi 16: LBA48 NCQ (depth 0/32)
> ata3.01: failed to set xfermode (err_mask=0x40)
> ata3: failed to recover some devices, retrying in 5 secs
> ata3.01: qc timeout (cmd 0x27)
> ata3.01: ata_hpa_resize 1: hpa sectors (0) is smaller than sectors (312581808)
> ata3.01: failed to set xfermode (err_mask=0x40)
> ata3.01: limiting speed to UDMA/133:PIO3
> ata3: failed to recover some devices, retrying in 5 secs
> ata3.01: qc timeout (cmd 0x27)
> ata3.01: ata_hpa_resize 1: hpa sectors (0) is smaller than sectors (312581808)
> ata3.01: failed to set xfermode (err_mask=0x40)
> ata3.01: disabled
> ata3: EH pending after completion, repeating EH (cnt=4)
> ata3: soft resetting port
> ata3: EH complete
> kjournald starting.  Commit interval 5 seconds
> EXT3-fs: mounted filesystem with ordered data mode.
> 
> 
> Here's a list of the hardware in the system:
> 
> [wright@Fedora8 ~]$ lspci
> 00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS, 943/940GML and 945GT 
> Express Memory Controller Hub (rev 03)
> 00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS, 
> 943/940GML Express Integrated Graphics Controller (rev 03)
> 00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML 
> Express Integrated Graphics Controller (rev 03)
> 00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 
> (rev 02)
> 00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
> Controller #1 (rev 02)
> 00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
> Controller #2 (rev 02)
> 00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
> Controller #3 (rev 02)
> 00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI 
> Controller #4 (rev 02)
> 00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI 
> Controller (rev 02)
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e2)
> 00:1e.2 Multimedia audio controller: Intel Corporation 82801G (ICH7 Family) 
> AC'97 Audio Controller (rev 02)
> 00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface Bridge 
> (rev 02)
> 00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller 
> (rev 02)
> 00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family) SATA IDE 
> Controller (rev 02)
> 00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 02)
> 01:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E Gigabit 
> Ethernet Controller (rev 15)
> 02:07.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000 
> Controller (PHY/Link)
> 02:08.0 Ethernet controller: Intel Corporation 82801G (ICH7 Family) LAN 
> Controller (rev 02)
> 
> 
> 
> 
> 
> 
> 
> 



