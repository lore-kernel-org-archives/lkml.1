Return-Path: <linux-kernel-owner+w=401wt.eu-S1756276AbYFYLsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276AbYFYLsZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 07:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbYFYLsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 07:48:15 -0400
Received: from averell.mail.tiscali.it ([213.205.33.55]:46737 "EHLO
	averell.mail.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbYFYLsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 07:48:13 -0400
X-Greylist: delayed 316 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jun 2008 07:48:12 EDT
Message-ID: <48622F3A.6070801@shiftmail.org>
Date: Wed, 25 Jun 2008 13:42:50 +0200
From: kurk <kurk@shiftmail.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Bug in MPT Fusion 2.6.26-rc7 unbootable
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I'm no kernel expert, I hope I made no mistakes in this report. It seems
to me that a bug was added to the MPT Fusion driver in 2.6.26 (rc7).

I compiled 2.6.26-rc7 on a machine with controller LSI53C1080 and it
cannot boot. Doing the same with 2.6.25, very similar config file, boots
without problems.

I tried to forward-port the Fusion driver from 2.6.25 to 2.6.26-rc7 by
simply copying over the directory drivers/message/fusion/ from 2.6.25 to
2.6.26-rc7 but unfortunately this doesn't compile, so I am stuck not
being able to use 2.6.26 on this machine (actually I have not tried
versions of 2.6.26 earlier than rc7... I don't have much time now).

I connected a serial cable in order to obtain the boot error message. I
obtained two of those on different boots. I will paste these at the end
of this email.


This is the verbose lspci of the controller (obtained with 2.6.25):
----------------------------------------
01:01.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1030 PCI-X
Fusion-MPT Dual Ultra320 SCSI (rev 07)
         Subsystem: IBM Unknown device 026d
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr+ Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 72 (4250ns min, 4500ns max), Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 22
         Region 0: I/O ports at 2300 [size=256]
         Region 1: Memory at fbff0000 (64-bit, non-prefetchable) [size=64K]
         Region 3: Memory at fbfe0000 (64-bit, non-prefetchable) [size=64K]
         Capabilities: [50] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
         Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
                 Address: 0000000000000000  Data: 0000
         Capabilities: [68] PCI-X non-bridge device
                 Command: DPERE- ERO- RBC=512 OST=1
                 Status: Dev=01:01.0 64bit+ 133MHz+ SCD- USC- DC=simple
DMMRBC=2048 DMOST=8 DMCRS=16 RSCEM- 266MHz- 533MHz-
         Kernel driver in use: mptspi
         Kernel modules: mptspi
----------------------------------------


This is an excerpt of the dmesg on 2.6.25 where the controller WORKS:
--------------------------------------------------------------------
Fusion MPT base driver 3.04.06
Copyright (c) 1999-2007 LSI Corporation
Fusion MPT SPI Host driver 3.04.06
...
mptbase: ioc0: Initiating bringup
...
ioc0: LSI53C1030 B2: Capabilities={Initiator}
Probing IDE interface ide1...
hdc: LG CD-ROM CRN-8245B, ATAPI CD/DVD-ROM drive
scsi0 : ioc0: LSI53C1030 B2, FwRev=01000e00h, Ports=1, MaxQ=222, IRQ=22
...
scsi0 : ioc0: LSI53C1030 B2, FwRev=01000e00h, Ports=1, MaxQ=222, IRQ=22
hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/33 mode selected
ide1 at 0x170-0x177,0x376 on irq 15
tg3.c:v3.90 (April 12, 2008)
ACPI: PCI Interrupt 0000:02:01.0[A] -> GSI 24 (level, low) -> IRQ 24
scsi 0:0:0:0: Direct-Access     IBM-ESXS DTN018C1UCDY10F  S23J PQ: 0 ANSI: 3
  target0:0:0: Beginning Domain Validation
  target0:0:0: Ending Domain Validation
  target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
scsi 0:0:1:0: Direct-Access     IBM-ESXS DTN018C1UCDY10F  S23J PQ: 0 ANSI: 3
  target0:0:1: Beginning Domain Validation
...
ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 25 (level, low) -> IRQ 25
  target0:0:1: Ending Domain Validation
  target0:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
...
hdc: ATAPI 24X CD-ROM drive, 128kB Cache
Uniform CD-ROM driver Revision: 3.20
scsi 0:0:8:0: Processor         IBM      25P3495a S320  1 1    PQ: 0 ANSI: 2
  target0:0:8: Beginning Domain Validation
  target0:0:8: Ending Domain Validation
  target0:0:8: asynchronous
Driver 'sd' needs updating - please use bus_type methods
sd 0:0:0:0: [sda] 35548320 512-byte hardware sectors (18201 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: cb 00 00 08
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 0:0:1:0: Attached scsi generic sg1 type 0
scsi 0:0:8:0: Attached scsi generic sg2 type 3
--------------------------------------------------------------------


It is an x86 32bit PC compile. This is the excerpt of the .config file
grepping for FUSION
------------------------------------
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=40
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LAN=m
# CONFIG_FUSION_LOGGING is not set
------------------------------------



This is the boot error message obtained with serial cable. I left it
running for 8 minutes for this. It loops so the message never ends.
--------------------------------------------------------------------

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

BUG: unable to handle kernel NULL pointer dereference at 0000034c

IP: [<f885cc5e>] :mptspi:mptspi_dv_renegotiate_work+0xa/0x9f

Oops: 0000 [#1] SMP

Modules linked in: ide_pci_generic(+) floppy mptspi(+) mptscsih ohci_hcd
tg3 mptbase scsi_transport_spi usbcore serverworks ide_core ata_generic
libata scsi_mod dock thermal processor fan thermal_sys



Pid: 9, comm: events/0 Not tainted (2.6.26-rc7 #1)

EIP: 0060:[<f885cc5e>] EFLAGS: 00010282 CPU: 0

EIP is at mptspi_dv_renegotiate_work+0xa/0x9f [mptspi]

EAX: f7a447c0 EBX: f7429900 ECX: f7a447c4 EDX: c1908988

ESI: f7a447c0 EDI: 0000034c EBP: f7429904 ESP: f7477f80

  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068

Process events/0 (pid: 9, ti=f7476000 task=f744d770 task.ti=f7476000)

Stack: f744d8e0 c190b260 00000000 c1908984 f7429900 f7a447c0 f885cc54
f7429904

        c012f253 f7429900 c012f934 f742990c 00000000 c012f9e8 00000000
f744d770

        c0131bdc f7477fc4 f7477fc4 f7429900 c012f934 00000000 c0131b1b
c0131ae3

Call Trace:

  [<f885cc54>] mptspi_dv_renegotiate_work+0x0/0x9f [mptspi]

  [<c012f253>] run_workqueue+0x75/0xf6

  [<c012f934>] worker_thread+0x0/0xbf

  [<c012f9e8>] worker_thread+0xb4/0xbf

  [<c0131bdc>] autoremove_wake_function+0x0/0x2b

  [<c012f934>] worker_thread+0x0/0xbf

  [<c0131b1b>] kthread+0x38/0x5d

  [<c0131ae3>] kthread+0x0/0x5d

  [<c0104573>] kernel_thread_helper+0x7/0x10

  =======================

Code: 70 e8 9e f8 ff ff 8b 47 70 e8 44 b7 fe ff 8b 47 70 5a 5b 5e 5f 5d
e9 89 f8 ff ff 58 5b 5e 5f 5d c3 55 57 56 53 83 ec 10 8b 78 10 <8b> 2f
e8 c7 98 90 c7 66 83 bf 96 02 00 00 00 8b 85 3c 01 00 00

EIP: [<f885cc5e>] mptspi_dv_renegotiate_work+0xa/0x9f [mptspi] SS:ESP
0068:f7477f80

---[ end trace e311270f757682e4 ]---

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptbase: ioc0: Recovered from IOC FAULT

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptbase: ioc0: Recovered from IOC FAULT

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptbase: ioc0: Recovered from IOC FAULT

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptbase: ioc0: Recovered from IOC FAULT

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptbase: ioc0: Recovered from IOC FAULT

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptbase: ioc0: Recovered from IOC FAULT

scsi0 : ioc0: LSI53C1030 B2, FwRev=01000e00h, Ports=1, MaxQ=222, IRQ=223

  target0:0:0: mptspi: ioc0: dma_alloc_coherent for parameters failed

hdc: ATAPI 24X CD-ROM drive, 128kB Cache

Uniform CD-ROM driver Revision: 3.20

mptscsih: ioc0: attempting task abort! (sc=f7862e80)

scsi 0:0:0:0: CDB: Inquiry: 12 00 00 00 24 00

mptscsih: ioc0: WARNING - TM Handler for type=1: IOC Not operational
(0x40008112)!

mptscsih: ioc0: WARNING -  Issuing HardReset!!

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

md: raid1 personality registered for level 1

device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised:
dm-devel@redhat.com

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

scsi 0:0:0:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 0,
sc=f7862e80, mf = f7a62da0, idx=f

mptbase: ioc0: Recovered from IOC FAULT

mptscsih: ioc0: task abort: FAILED (sc=f7862e80)

mptscsih: ioc0: attempting target reset! (sc=f7862e80)

scsi 0:0:0:0: CDB: Inquiry: 12 00 00 00 24 00

  target0:0:0: mptspi: ioc0: dma_alloc_coherent for parameters failed

  target0:0:0: FAST-5 WIDE SCSI 2.4 MB/s ST RTI WRFLOW PCOMP (844 ns,
offset 68)

  target0:0:0: mptspi: ioc0: dma_alloc_coherent for parameters failed

mptscsih: ioc0: Issue of TaskMgmt failed!

mptscsih: ioc0: target reset: FAILED (sc=f7862e80)

mptscsih: ioc0: attempting bus reset! (sc=f7862e80)

scsi 0:0:0:0: CDB: Inquiry: 12 00 00 00 24 00

mptscsih: ioc0: WARNING - TM Handler for type=4: IOC Not operational
(0x40008112)!

mptscsih: ioc0: WARNING -  Issuing HardReset!!

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptbase: ioc0: Recovered from IOC FAULT

mptscsih: ioc0: bus reset: FAILED (sc=f7862e80)

mptscsih: ioc0: attempting host reset! (sc=f7862e80)

mptbase: ioc0: Initiating recovery

  target0:0:0: mptspi: ioc0: dma_alloc_coherent for parameters failed

  target0:0:0: FAST-5 WIDE SCSI 2.4 MB/s ST RTI WRFLOW PCOMP (844 ns,
offset 68)

  target0:0:0: mptspi: ioc0: dma_alloc_coherent for parameters failed

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptscsih: ioc0: host reset: SUCCESS (sc=f7862e80)

scsi 0:0:0:0: Device offlined - not ready after error recovery

  target0:0:1: mptspi: ioc0: dma_alloc_coherent for parameters failed

  target0:0:1: mptspi: ioc0: dma_alloc_coherent for parameters failed

  target0:0:1: FAST-5 WIDE SCSI 2.4 MB/s ST RTI WRFLOW PCOMP (844 ns,
offset 68)

  target0:0:1: mptspi: ioc0: dma_alloc_coherent for parameters failed

mptscsih: ioc0: attempting task abort! (sc=f7862e80)

scsi 0:0:1:0: CDB: Inquiry: 12 00 00 00 24 00

mptscsih: ioc0: WARNING - TM Handler for type=1: IOC Not operational
(0x40008112)!

mptscsih: ioc0: WARNING -  Issuing HardReset!!

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

scsi 0:0:1:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 1,
sc=f7862e80, mf = f7a62f80, idx=14

mptbase: ioc0: Recovered from IOC FAULT

mptscsih: ioc0: task abort: FAILED (sc=f7862e80)

mptscsih: ioc0: attempting target reset! (sc=f7862e80)

scsi 0:0:1:0: CDB: Inquiry: 12 00 00 00 24 00

  target0:0:1: mptspi: ioc0: dma_alloc_coherent for parameters failed

  target0:0:1: FAST-5 WIDE SCSI 2.4 MB/s ST RTI WRFLOW PCOMP (844 ns,
offset 68)

  target0:0:1: mptspi: ioc0: dma_alloc_coherent for parameters failed

mptscsih: ioc0: Issue of TaskMgmt failed!

mptscsih: ioc0: target reset: FAILED (sc=f7862e80)

mptscsih: ioc0: attempting bus reset! (sc=f7862e80)

scsi 0:0:1:0: CDB: Inquiry: 12 00 00 00 24 00

mptscsih: ioc0: WARNING - TM Handler for type=4: IOC Not operational
(0x40008112)!

mptscsih: ioc0: WARNING -  Issuing HardReset!!

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptbase: ioc0: Recovered from IOC FAULT

mptscsih: ioc0: bus reset: FAILED (sc=f7862e80)

mptscsih: ioc0: attempting host reset! (sc=f7862e80)

mptbase: ioc0: Initiating recovery

  target0:0:1: mptspi: ioc0: dma_alloc_coherent for parameters failed

  target0:0:1: FAST-5 WIDE SCSI 2.4 MB/s ST RTI WRFLOW PCOMP (844 ns,
offset 68)

  target0:0:1: mptspi: ioc0: dma_alloc_coherent for parameters failed

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptscsih: ioc0: host reset: SUCCESS (sc=f7862e80)

scsi 0:0:1:0: Device offlined - not ready after error recovery

  target0:0:2: mptspi: ioc0: dma_alloc_coherent for parameters failed

  target0:0:2: mptspi: ioc0: dma_alloc_coherent for parameters failed

  target0:0:2: FAST-5 WIDE SCSI 2.4 MB/s ST RTI WRFLOW PCOMP (844 ns,
offset 68)

  target0:0:2: mptspi: ioc0: dma_alloc_coherent for parameters failed

mptscsih: ioc0: attempting task abort! (sc=f7862e80)

scsi 0:0:2:0: CDB: Inquiry: 12 00 00 00 24 00

mptscsih: ioc0: WARNING - TM Handler for type=1: IOC Not operational
(0x40008112)!

mptscsih: ioc0: WARNING -  Issuing HardReset!!

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

scsi 0:0:2:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 2,
sc=f7862e80, mf = f7a63160, idx=19

mptbase: ioc0: Recovered from IOC FAULT

mptscsih: ioc0: task abort: FAILED (sc=f7862e80)

mptscsih: ioc0: attempting target reset! (sc=f7862e80)

scsi 0:0:2:0: CDB: Inquiry: 12 00 00 00 24 00

  target0:0:2: mptspi: ioc0: dma_alloc_coherent for parameters failed

  target0:0:2: FAST-5 WIDE SCSI 2.4 MB/s ST RTI WRFLOW PCOMP (844 ns,
offset 68)

  target0:0:2: mptspi: ioc0: dma_alloc_coherent for parameters failed

mptscsih: ioc0: Issue of TaskMgmt failed!

mptscsih: ioc0: target reset: FAILED (sc=f7862e80)

mptscsih: ioc0: attempting bus reset! (sc=f7862e80)

scsi 0:0:2:0: CDB: Inquiry: 12 00 00 00 24 00

mptscsih: ioc0: WARNING - TM Handler for type=4: IOC Not operational
(0x40008112)!

mptscsih: ioc0: WARNING -  Issuing HardReset!!

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptbase: ioc0: Recovered from IOC FAULT

mptscsih: ioc0: bus reset: FAILED (sc=f7862e80)

mptscsih: ioc0: attempting host reset! (sc=f7862e80)

mptbase: ioc0: Initiating recovery

  target0:0:2: mptspi: ioc0: dma_alloc_coherent for parameters failed

  target0:0:2: FAST-5 WIDE SCSI 2.4 MB/s ST RTI WRFLOW PCOMP (844 ns,
offset 68)

  target0:0:2: mptspi: ioc0: dma_alloc_coherent for parameters failed

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptscsih: ioc0: host reset: SUCCESS (sc=f7862e80)

scsi 0:0:2:0: Device offlined - not ready after error recovery

  target0:0:3: mptspi: ioc0: dma_alloc_coherent for parameters failed

  target0:0:3: mptspi: ioc0: dma_alloc_coherent for parameters failed

  target0:0:3: FAST-5 WIDE SCSI 2.4 MB/s ST RTI WRFLOW PCOMP (844 ns,
offset 68)

  target0:0:3: mptspi: ioc0: dma_alloc_coherent for parameters failed

mptscsih: ioc0: attempting task abort! (sc=f7862e80)

scsi 0:0:3:0: CDB: Inquiry: 12 00 00 00 24 00

mptscsih: ioc0: WARNING - TM Handler for type=1: IOC Not operational
(0x40008112)!

mptscsih: ioc0: WARNING -  Issuing HardReset!!

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -










This one I obtained it in 5 minutes in another boot with a very slightly
differing .config file (not changing in the MPT Fusion options). You can
see that the stack trace is slightly different.
--------------------------------------------------------------------

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

ACPI: Resource is not an IRQ entry

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

BUG: unable to handle kernel NULL pointer dereference at 0000034c

IP: [<f8856c5e>] :mptspi:mptspi_dv_renegotiate_work+0xa/0x9f

Oops: 0000 [#1] SMP

Modules linked in: ide_pci_generic(+) floppy mptspi(+) mptscsih mptbase
scsi_transport_spi ohci_hcd usbcore tg3 serverworks ide_core ata_generic
libata scsi_mod dock thermal processor fan



Pid: 9, comm: events/0 Not tainted (2.6.26-rc7 #3)

EIP: 0060:[<f8856c5e>] EFLAGS: 00010282 CPU: 0

EIP is at mptspi_dv_renegotiate_work+0xa/0x9f [mptspi]

EAX: f783f480 EBX: f7429900 ECX: f783f484 EDX: c1908548

ESI: f783f480 EDI: 0000034c EBP: f7429904 ESP: f7477f80

  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068

Process events/0 (pid: 9, ti=f7476000 task=f744d770 task.ti=f7476000)

Stack: 00000000 c012cea5 f7429900 c1908544 f7429900 f783f480 f8856c54
f7429904

        c012c82a f7429900 c012cee7 f742990c 00000000 c012cf9b 00000000
f744d770

        c012f190 f7477fc4 f7477fc4 f7429900 c012cee7 00000000 c012f0cf
c012f097

Call Trace:

  [<c012cea5>] queue_delayed_work_on+0x9a/0xa6

  [<f8856c54>] mptspi_dv_renegotiate_work+0x0/0x9f [mptspi]

  [<c012c82a>] run_workqueue+0x6c/0xe4

  [<c012cee7>] worker_thread+0x0/0xbf

  [<c012cf9b>] worker_thread+0xb4/0xbf

  [<c012f190>] autoremove_wake_function+0x0/0x2b

  [<c012cee7>] worker_thread+0x0/0xbf

  [<c012f0cf>] kthread+0x38/0x5d

  [<c012f097>] kthread+0x0/0x5d

  [<c01043c3>] kernel_thread_helper+0x7/0x10

  =======================

Code: 70 e8 9e f8 ff ff 8b 47 70 e8 44 37 ff ff 8b 47 70 5a 5b 5e 5f 5d
e9 89 f8 ff ff 58 5b 5e 5f 5d c3 55 57 56 53 83 ec 10 8b 78 10 <8b> 2f
e8 ff cc 90 c7 66 83 bf 96 02 00 00 00 8b 85 3c 01 00 00

EIP: [<f8856c5e>] mptspi_dv_renegotiate_work+0xa/0x9f [mptspi] SS:ESP
0068:f7477f80

---[ end trace e7ec2a28a4a72094 ]---

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptbase: ioc0: Recovered from IOC FAULT

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptbase: ioc0: Recovered from IOC FAULT

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptbase: ioc0: Recovered from IOC FAULT

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptbase: ioc0: Recovered from IOC FAULT

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptbase: ioc0: Recovered from IOC FAULT

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptbase: ioc0: Recovered from IOC FAULT

scsi0 : ioc0: LSI53C1030 B2, FwRev=01000e00h, Ports=1, MaxQ=222, IRQ=223

  target0:0:0: mptspi: ioc0: dma_alloc_coherent for parameters failed

hdc: ATAPI 24X CD-ROM drive, 128kB Cache

Uniform CD-ROM driver Revision: 3.20

mptscsih: ioc0: attempting task abort! (sc=f7858e80)

scsi 0:0:0:0: CDB: Inquiry: 12 00 00 00 24 00

mptscsih: ioc0: WARNING - TM Handler for type=1: IOC Not operational
(0x40008112)!

mptscsih: ioc0: WARNING -  Issuing HardReset!!

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

md: raid1 personality registered for level 1

device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised:
dm-devel@redhat.com

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

scsi 0:0:0:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 0,
sc=f7858e80, mf = f79e2da0, idx=f

mptbase: ioc0: Recovered from IOC FAULT

mptscsih: ioc0: task abort: FAILED (sc=f7858e80)

mptscsih: ioc0: attempting target reset! (sc=f7858e80)

scsi 0:0:0:0: CDB: Inquiry: 12 00 00 00 24 00

mptscsih: ioc0: Issue of TaskMgmt failed!

mptscsih: ioc0: target reset: FAILED (sc=f7858e80)

mptscsih: ioc0: attempting bus reset! (sc=f7858e80)

scsi 0:0:0:0: CDB: Inquiry: 12 00 00 00 24 00

mptscsih: ioc0: WARNING - TM Handler for type=4: IOC Not operational
(0x40008112)!

mptscsih: ioc0: WARNING -  Issuing HardReset!!

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptbase: ioc0: Recovered from IOC FAULT

mptscsih: ioc0: bus reset: FAILED (sc=f7858e80)

mptscsih: ioc0: attempting host reset! (sc=f7858e80)

mptbase: ioc0: Initiating recovery

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptscsih: ioc0: host reset: SUCCESS (sc=f7858e80)

scsi 0:0:0:0: Device offlined - not ready after error recovery

  target0:0:1: mptspi: ioc0: dma_alloc_coherent for parameters failed

mptscsih: ioc0: attempting task abort! (sc=f7858080)

scsi 0:0:1:0: CDB: Inquiry: 12 00 00 00 24 00

mptscsih: ioc0: WARNING - TM Handler for type=1: IOC Not operational
(0x40008112)!

mptscsih: ioc0: WARNING -  Issuing HardReset!!

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

scsi 0:0:1:0: mptscsih: ioc0: completing cmds: fw_channel 0, fw_id 1,
sc=f7858080, mf = f79e2f80, idx=14

mptbase: ioc0: Recovered from IOC FAULT

mptscsih: ioc0: task abort: FAILED (sc=f7858080)

mptscsih: ioc0: attempting target reset! (sc=f7858080)

scsi 0:0:1:0: CDB: Inquiry: 12 00 00 00 24 00

  target0:0:1: mptspi: ioc0: dma_alloc_coherent for parameters failed

  target0:0:1: asynchronous

  target0:0:1: mptspi: ioc0: dma_alloc_coherent for parameters failed

mptscsih: ioc0: Issue of TaskMgmt failed!

mptscsih: ioc0: target reset: FAILED (sc=f7858080)

mptscsih: ioc0: attempting bus reset! (sc=f7858080)

scsi 0:0:1:0: CDB: Inquiry: 12 00 00 00 24 00

mptscsih: ioc0: WARNING - TM Handler for type=4: IOC Not operational
(0x40008112)!

mptscsih: ioc0: WARNING -  Issuing HardReset!!

mptbase: ioc0: Initiating recovery

mptbase: ioc0: WARNING - IOC is in FAULT state!!!

mptbase: ioc0: WARNING -            FAULT code = 8112h

mptbase: ioc0: ERROR - Doorbell ACK timeout (count=4999),
IntStatus=80000009!

mptbase: ioc0: Recovered from IOC FAULT

mptscsih: ioc0: bus reset: FAILED (sc=f7858080)

mptscsih: ioc0: attempting host reset! (sc=f7858080)

mptbase: ioc0: Initiating recovery

  target0:0:1: mptspi: ioc0: dma_alloc_coherent for par

