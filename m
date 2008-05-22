Return-Path: <linux-kernel-owner+w=401wt.eu-S1762106AbYEVVAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762106AbYEVVAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761910AbYEVVAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:00:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760933AbYEVVAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:00:08 -0400
Date: Thu, 22 May 2008 16:59:02 -0400
From: Bill Nottingham <notting@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problems with suspend and USB storage
Message-ID: <20080522205902.GA3409@nostromo.devel.redhat.com>
Mail-Followup-To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <20080515163315.GA17779@nostromo.devel.redhat.com> <20080516072907.GA21157@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <20080516072907.GA21157@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greg KH (greg@kroah.com) said: 
> On Thu, May 15, 2008 at 12:33:15PM -0400, Bill Nottingham wrote:
> > 
> > I've been testing suspend/hibernate with various USB devices under
> > 2.6.25.2. Test box is a Thinkpad T60 (uhci, ehci).
> > The results are somewhat dismal.
> 
> If you look at 2.6.26-rc, there are some good changes there that should
> help things out a lot.  USB_PERSIST is much better there, but it missed
> .25 as it wasn't tested enough (although it is shipping in openSUSE
> 11.0, and seems to be working well there...)

Testing 2.6.26-rc3 + gregkh-04-usb-2.6.26-rc3.patch... things are
much better.

However, there's one thing that still fails - hibernate to a usb
device attached via a PCI Express card reader. Log is attached - 
do you need any more information? (Devices in the same card reader work
fine across suspend to RAM & resume.)

Bill

--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg
Content-Transfer-Encoding: quoted-printable

Adding 3151672k swap on /dev/sdb2.  Priority:-1 extents:1 across:3151672k
PM: Hibernation mode set to 'shutdown'
PM: Marking nosave pages: 000000000009f000 - 0000000000100000
PM: Basic memory bitmaps created
PM: Syncing filesystems ... done.
Freezing user space processes ... (elapsed 0.00 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Shrinking memory...  =08-=08done (0 pages freed)
PM: Freed 0 kbytes in 0.09 seconds (0.00 MB/s)
Suspending console(s)
sd 0:0:0:0: [sda] Synchronizing SCSI cache
usb-storage: storage_suspend
hub 1-0:1.0: hub_suspend
usb usb1: bus suspend
ehci_hcd 0000:00:1d.7: suspend root hub
nsc-ircc 00:0a: disabled
ACPI: PCI interrupt for device 0000:02:00.0 disabled
ACPI handle has no context!
ACPI: PCI interrupt for device 0000:00:1f.2 disabled
ata6: port disabled. ignoring.
ACPI: PCI interrupt for device 0000:00:1f.1 disabled
ACPI: PCI interrupt for device 0000:00:1d.7 disabled
ehci_hcd 0000:00:1d.7: --> no state change
uhci_hcd 0000:00:1d.3: uhci_pci_suspend
ACPI: PCI interrupt for device 0000:00:1d.3 disabled
uhci_hcd 0000:00:1d.3: --> no state change
uhci_hcd 0000:00:1d.2: uhci_pci_suspend
ACPI: PCI interrupt for device 0000:00:1d.2 disabled
uhci_hcd 0000:00:1d.2: --> no state change
uhci_hcd 0000:00:1d.1: uhci_pci_suspend
ACPI: PCI interrupt for device 0000:00:1d.1 disabled
uhci_hcd 0000:00:1d.1: --> no state change
uhci_hcd 0000:00:1d.0: uhci_pci_suspend
ACPI: PCI interrupt for device 0000:00:1d.0 disabled
uhci_hcd 0000:00:1d.0: --> no state change
ACPI: PCI interrupt for device 0000:00:1b.0 disabled
Disabling non-boot CPUs ...
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
kvm: disabling virtualization on CPU1
CPU 1 is now offline
lockdep: fixing up alternatives.
SMP alternatives: switching to UP code
CPU0 attaching sched-domain:
 domain 0: span 0
  groups: 0
CPU1 is down
Extended CMOS year: 2000
PM: Creating hibernation image:=20
PM: Need to copy 80534 pages
PM: Normal pages needed: 80534 + 1024 + 54, available pages: 702362
PM: Hibernation image created (80534 pages copied)
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Extended CMOS year: 2000
Enabling non-boot CPUs ...
CPU0 attaching NULL sched-domain.
lockdep: fixing up alternatives.
SMP alternatives: switching to SMP code
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3988.72 BogoMIPS (lpj=3D19=
94363)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 06
kvm: enabling virtualization on CPU1
CPU0 attaching sched-domain:
 domain 0: span 0-1
  groups: 0 1
  domain 1: span 0-1
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1
  groups: 1 0
  domain 1: span 0-1
   groups: 0-1
Switched to high resolution mode on CPU 1
CPU1 is up
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1b.0 to 64
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PCI: Setting latency timer of device 0000:00:1c.1 to 64
PCI: Setting latency timer of device 0000:00:1c.2 to 64
PCI: Setting latency timer of device 0000:00:1c.3 to 64
uhci_hcd 0000:00:1d.0: PCI legacy resume
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: uhci_pci_resume
uhci_hcd 0000:00:1d.1: PCI legacy resume
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: uhci_pci_resume
uhci_hcd 0000:00:1d.2: PCI legacy resume
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: uhci_pci_resume
uhci_hcd 0000:00:1d.3: PCI legacy resume
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: uhci_pci_resume
ehci_hcd 0000:00:1d.7: PCI legacy resume
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.7 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ata6: port disabled. ignoring.
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:00.0 to 64
ata5.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
ata5.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
ata5.00: ACPI cmd e3/00:79:00:00:00:a0 succeeded
ata5.00: ACPI cmd e3/00:01:00:00:00:a0 succeeded
ata5.00: configured for UDMA/33
nsc-ircc 00:0a: activated
usb usb1: usb resume
ehci_hcd 0000:00:1d.7: resume root hub
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ACPI cmd ef/5f:00:00:00:00:a0 succeeded
ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
ata1.00: configured for UDMA/100
hub 1-0:1.0: hub_resume
hub 1-0:1.0: port 4: status 0503 change 0000
usb-storage: storage_resume
sd 0:0:0:0: [sda] Starting disk
ata1.00: configured for UDMA/100
ata1: EH complete
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't suppor=
t DPO or FUA
PM: writing image.
PM: Free swap pages: 787918
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command WRITE_10 (10 bytes)
usb-storage:  2a 00 00 8e c4 d0 00 00 08 00
usb-storage: Bulk Command S 0x43425355 T 0x73 L 4096 F 0 Trg 0 LUN 0 CL 10
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=3D0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
usb-storage: Status code -32; transferred 0/4096
usb-storage: clearing endpoint halt for pipe 0xc0010200
usb-storage: usb_stor_control_msg: rq=3D01 rqtype=3D02 value=3D0000 index=
=3D02 len=3D0
usb-storage: usb_stor_clear_halt: result =3D 0
usb-storage: Bulk data transfer result 0x2
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result =3D 0
usb-storage: Bulk Status S 0x53425355 T 0x73 R 4096 Stat 0x1
usb-storage: -- transport indicates command failure
usb-storage: -- unexpectedly short transfer
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: Bulk Command S 0x43425355 T 0x74 L 18 F 128 Trg 0 LUN 0 CL 6
usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
usb-storage: Status code 0; transferred 31/31
usb-storage: -- transfer complete
usb-storage: Bulk command transfer result=3D0
usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: Bulk data transfer result 0x0
usb-storage: Attempting to get CSW...
usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
usb-storage: Status code 0; transferred 13/13
usb-storage: -- transfer complete
usb-storage: Bulk status result =3D 0
usb-storage: Bulk Status S 0x53425355 T 0x74 R 0 Stat 0x0
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x6, ASC: 0x28, ASCQ: 0x0
usb-storage: Unit Attention: Not ready to ready change, medium may have cha=
nged
usb-storage: scsi cmd done, result=3D0x2
end_request: I/O error, dev sdb, sector 9356496
Read-error on swap-device (8:16:9356504)
usb-storage: *** thread sleeping.
PM: Saving image data pages (80692 pages) ...     <1>Read-error on swap-dev=
ice (8:16:9356512)
=08=08=08=08  0%<1>Read-error on swap-device (8:16:9356520)
Read-error on swap-device (8:16:9356528)
Read-error on swap-device (8:16:9356536)
Read-error on swap-device (8:16:9356544)
Read-error on swap-device (8:16:9356552)
Read-error on swap-device (8:16:9356560)
Read-error on swap-device (8:16:9356568)
Read-error on swap-device (8:16:9356576)
Read-error on swap-device (8:16:9356584)
Read-error on swap-device (8:16:9356592)
Read-error on swap-device (8:16:9356600)
Read-error on swap-device (8:16:9356608)
Read-error on swap-device (8:16:9356616)
Read-error on swap-device (8:16:9356624)
Read-error on swap-device (8:16:9356632)
Read-error on swap-device (8:16:9356640)
Read-error on swap-device (8:16:9356648)
Read-error on swap-device (8:16:9356656)
Read-error on swap-device (8:16:9356664)
Read-error on swap-device (8:16:9356672)
Read-error on swap-device (8:16:9356680)
Read-error on swap-device (8:16:9356688)
Read-error on swap-device (8:16:9356696)
Read-error on swap-device (8:16:9356704)
Read-error on swap-device (8:16:9356712)
Read-error on swap-device (8:16:9356720)
Read-error on swap-device (8:16:9356728)
Read-error on swap-device (8:16:9356736)
Read-error on swap-device (8:16:9356744)
Read-error on swap-device (8:16:9356752)
Read-error on swap-device (8:16:9356760)
Read-error on swap-device (8:16:9356768)
Read-error on swap-device (8:16:9356776)
Read-error on swap-device (8:16:9356784)
Read-error on swap-device (8:16:9356792)
Read-error on swap-device (8:16:9356800)
Read-error on swap-device (8:16:9356808)
Read-error on swap-device (8:16:9356816)
Read-error on swap-device (8:16:9356824)
Read-error on swap-device (8:16:9356832)
Read-error on swap-device (8:16:9356840)
Read-error on swap-device (8:16:9356848)
Read-error on swap-device (8:16:9356856)
Read-error on swap-device (8:16:9356864)
Read-error on swap-device (8:16:9356872)
Read-error on swap-device (8:16:9356880)
Read-error on swap-device (8:16:9356888)
Read-error on swap-device (8:16:9356896)
Read-error on swap-device (8:16:9356904)
Read-error on swap-device (8:16:9356912)
Read-error on swap-device (8:16:9356920)
Read-error on swap-device (8:16:9356928)
Read-error on swap-device (8:16:9356936)
Read-error on swap-device (8:16:9356944)
Read-error on swap-device (8:16:9356952)
Read-error on swap-device (8:16:9356960)
Read-error on swap-device (8:16:9356968)
Read-error on swap-device (8:16:9356976)
Read-error on swap-device (8:16:9356984)
Read-error on swap-device (8:16:9356992)
Read-error on swap-device (8:16:9357000)
Read-error on swap-device (8:16:9357008)
Read-error on swap-device (8:16:9357016)
Read-error on swap-device (8:16:9357024)
Read-error on swap-device (8:16:9357032)
Read-error on swap-device (8:16:9357040)
Read-error on swap-device (8:16:9357048)
Read-error on swap-device (8:16:9357056)
Read-error on swap-device (8:16:9357064)
Read-error on swap-device (8:16:9357072)
Read-error on swap-device (8:16:9357080)
Read-error on swap-device (8:16:9357088)
Read-error on swap-device (8:16:9357096)
Read-error on swap-device (8:16:9357104)
Read-error on swap-device (8:16:9357112)
Read-error on swap-device (8:16:9357120)
Read-error on swap-device (8:16:9357128)
Read-error on swap-device (8:16:9357136)
Read-error on swap-device (8:16:9357144)
Read-error on swap-device (8:16:9357152)
Read-error on swap-device (8:16:9357160)
Read-error on swap-device (8:16:9357168)
Read-error on swap-device (8:16:9357176)
Read-error on swap-device (8:16:9357184)
Read-error on swap-device (8:16:9357192)
Read-error on swap-device (8:16:9357200)
Read-error on swap-device (8:16:9357208)
Read-error on swap-device (8:16:9357216)
Read-error on swap-device (8:16:9357224)
Read-error on swap-device (8:16:9357232)
Read-error on swap-device (8:16:9357240)
Read-error on swap-device (8:16:9357248)
Read-error on swap-device (8:16:9357256)
Read-error on swap-device (8:16:9357264)
Read-error on swap-device (8:16:9357272)
Read-error on swap-device (8:16:9357280)
Read-error on swap-device (8:16:9357288)
Read-error on swap-device (8:16:9357296)
Read-error on swap-device (8:16:9357304)
Read-error on swap-device (8:16:9357312)
Read-error on swap-device (8:16:9357320)
Read-error on swap-device (8:16:9357328)
Read-error on swap-device (8:16:9357336)
Read-error on swap-device (8:16:9357344)
Read-error on swap-device (8:16:9357352)
Read-error on swap-device (8:16:9357360)
Read-error on swap-device (8:16:9357368)
Read-error on swap-device (8:16:9357376)
Read-error on swap-device (8:16:9357384)
Read-error on swap-device (8:16:9357392)
Read-error on swap-device (8:16:9357400)
Read-error on swap-device (8:16:9357408)
Read-error on swap-device (8:16:9357416)
Read-error on swap-device (8:16:9357424)
Read-error on swap-device (8:16:9357432)
Read-error on swap-device (8:16:9357440)
Read-error on swap-device (8:16:9357448)
Read-error on swap-device (8:16:9357456)
Read-error on swap-device (8:16:9357464)
Read-error on swap-device (8:16:9357472)
Read-error on swap-device (8:16:9357480)
Read-error on swap-device (8:16:9357488)
Read-error on swap-device (8:16:9357496)
Read-error on swap-device (8:16:9357504)
Read-error on swap-device (8:16:9357512)
Read-error on swap-device (8:16:9357520)
Read-error on swap-device (8:16:9357528)
Read-error on swap-device (8:16:9357536)
Read-error on swap-device (8:16:9357544)
Read-error on swap-device (8:16:9357552)
Read-error on swap-device (8:16:9357560)
Read-error on swap-device (8:16:9357568)
Read-error on swap-device (8:16:9357576)
Read-error on swap-device (8:16:9357584)
Read-error on swap-device (8:16:9357592)
Read-error on swap-device (8:16:9357600)
Read-error on swap-device (8:16:9357608)
Read-error on swap-device (8:16:9357616)
Read-error on swap-device (8:16:9357624)
Read-error on swap-device (8:16:9357632)
Read-error on swap-device (8:16:9357640)
Read-error on swap-device (8:16:9357648)
Read-error on swap-device (8:16:9357656)
Read-error on swap-device (8:16:9357664)
Read-error on swap-device (8:16:9357672)
Read-error on swap-device (8:16:9357680)
Read-error on swap-device (8:16:9357688)
Read-error on swap-device (8:16:9357696)
Read-error on swap-device (8:16:9357704)
Read-error on swap-device (8:16:9357712)
Read-error on swap-device (8:16:9357720)
Read-error on swap-device (8:16:9357728)
Read-error on swap-device (8:16:9357736)
Read-error on swap-device (8:16:9357744)
Read-error on swap-device (8:16:9357752)
Read-error on swap-device (8:16:9357760)
Read-error on swap-device (8:16:9357768)
Read-error on swap-device (8:16:9357776)
Read-error on swap-device (8:16:9357784)
Read-error on swap-device (8:16:9357792)
Read-error on swap-device (8:16:9357800)
Read-error on swap-device (8:16:9357808)
Read-error on swap-device (8:16:9357816)
Read-error on swap-device (8:16:9357824)
Read-error on swap-device (8:16:9357832)
Read-error on swap-device (8:16:9357840)
Read-error on swap-device (8:16:9357848)
Read-error on swap-device (8:16:9357856)
Read-error on swap-device (8:16:9357864)
Read-error on swap-device (8:16:9357872)
Read-error on swap-device (8:16:9357880)
Read-error on swap-device (8:16:9357888)
Read-error on swap-device (8:16:9357896)
Read-error on swap-device (8:16:9357904)
Read-error on swap-device (8:16:9357912)
Read-error on swap-device (8:16:9357920)
Read-error on swap-device (8:16:9357928)
Read-error on swap-device (8:16:9357936)
Read-error on swap-device (8:16:9357944)
Read-error on swap-device (8:16:9357952)
Read-error on swap-device (8:16:9357960)
Read-error on swap-device (8:16:9357968)
Read-error on swap-device (8:16:9357976)
Read-error on swap-device (8:16:9357984)
Read-error on swap-device (8:16:9357992)
Read-error on swap-device (8:16:9358000)
Read-error on swap-device (8:16:9358008)
Read-error on swap-device (8:16:9358016)
Read-error on swap-device (8:16:9358024)
Read-error on swap-device (8:16:9358032)
Read-error on swap-device (8:16:9358040)
Read-error on swap-device (8:16:9358048)
Read-error on swap-device (8:16:9358056)
Read-error on swap-device (8:16:9358064)
Read-error on swap-device (8:16:9358072)
Read-error on swap-device (8:16:9358080)
Read-error on swap-device (8:16:9358088)
Read-error on swap-device (8:16:9358096)
Read-error on swap-device (8:16:9358104)
Read-error on swap-device (8:16:9358112)
Read-error on swap-device (8:16:9358120)
Read-error on swap-device (8:16:9358128)
Read-error on swap-device (8:16:9358136)
Read-error on swap-device (8:16:9358144)
Read-error on swap-device (8:16:9358152)
Read-error on swap-device (8:16:9358160)
Read-error on swap-device (8:16:9358168)
Read-error on swap-device (8:16:9358176)
Read-error on swap-device (8:16:9358184)
Read-error on swap-device (8:16:9358192)
Read-error on swap-device (8:16:9358200)
Read-error on swap-device (8:16:9358208)
Read-error on swap-device (8:16:9358216)
Read-error on swap-device (8:16:9358224)
Read-error on swap-device (8:16:9358232)
Read-error on swap-device (8:16:9358240)
Read-error on swap-device (8:16:9358248)
Read-error on swap-device (8:16:9358256)
Read-error on swap-device (8:16:9358264)
Read-error on swap-device (8:16:9358272)
Read-error on swap-device (8:16:9358280)
Read-error on swap-device (8:16:9358288)
Read-error on swap-device (8:16:9358296)
Read-error on swap-device (8:16:9358304)
Read-error on swap-device (8:16:9358312)
Read-error on swap-device (8:16:9358320)
Read-error on swap-device (8:16:9358328)
Read-error on swap-device (8:16:9358336)
Read-error on swap-device (8:16:9358344)
Read-error on swap-device (8:16:9358352)
Read-error on swap-device (8:16:9358360)
Read-error on swap-device (8:16:9358368)
Read-error on swap-device (8:16:9358376)
Read-error on swap-device (8:16:9358384)
Read-error on swap-device (8:16:9358392)
Read-error on swap-device (8:16:9358400)
Read-error on swap-device (8:16:9358408)
Read-error on swap-device (8:16:9358416)
Read-error on swap-device (8:16:9358424)
Read-error on swap-device (8:16:9358432)
Read-error on swap-device (8:16:9358440)
Read-error on swap-device (8:16:9358448)
Read-error on swap-device (8:16:9358456)
Read-error on swap-device (8:16:9358464)
Read-error on swap-device (8:16:9358472)
Read-error on swap-device (8:16:9358480)
Read-error on swap-device (8:16:9358488)
Read-error on swap-device (8:16:9358496)
Read-error on swap-device (8:16:9358504)
Read-error on swap-device (8:16:9358512)
Read-error on swap-device (8:16:9358520)
Read-error on swap-device (8:16:9358528)
Read-error on swap-device (8:16:9358536)
Read-error on swap-device (8:16:9358544)
Read-error on swap-device (8:16:9358552)
Read-error on swap-device (8:16:9358560)
Read-error on swap-device (8:16:9358568)
Read-error on swap-device (8:16:9358576)
Read-error on swap-device (8:16:9358584)
Read-error on swap-device (8:16:9358592)
Read-error on swap-device (8:16:9358600)
Read-error on swap-device (8:16:9358608)
Read-error on swap-device (8:16:9358616)
Read-error on swap-device (8:16:9358624)
Read-error on swap-device (8:16:9358632)
Read-error on swap-device (8:16:9358640)
Read-error on swap-device (8:16:9358648)
Read-error on swap-device (8:16:9358656)
Read-error on swap-device (8:16:9358664)
Read-error on swap-device (8:16:9358672)
Read-error on swap-device (8:16:9358680)
Read-error on swap-device (8:16:9358688)
Read-error on swap-device (8:16:9358696)
Read-error on swap-device (8:16:9358704)
Read-error on swap-device (8:16:9358712)
Read-error on swap-device (8:16:9358720)
Read-error on swap-device (8:16:9358728)
Read-error on swap-device (8:16:9358736)
Read-error on swap-device (8:16:9358744)
Read-error on swap-device (8:16:9358752)
Read-error on swap-device (8:16:9358760)
Read-error on swap-device (8:16:9358768)
Read-error on swap-device (8:16:9358776)
Read-error on swap-device (8:16:9358784)
Read-error on swap-device (8:16:9358792)
Read-error on swap-device (8:16:9358800)
Read-error on swap-device (8:16:9358808)
Read-error on swap-device (8:16:9358816)
Read-error on swap-device (8:16:9358824)
Read-error on swap-device (8:16:9358832)
Read-error on swap-device (8:16:9358840)
Read-error on swap-device (8:16:9358848)
Read-error on swap-device (8:16:9358856)
Read-error on swap-device (8:16:9358864)
Read-error on swap-device (8:16:9358872)
Read-error on swap-device (8:16:9358880)
Read-error on swap-device (8:16:9358888)
Read-error on swap-device (8:16:9358896)
Read-error on swap-device (8:16:9358904)
Read-error on swap-device (8:16:9358912)
Read-error on swap-device (8:16:9358920)
Read-error on swap-device (8:16:9358928)
Read-error on swap-device (8:16:9358936)
Read-error on swap-device (8:16:9358944)
Read-error on swap-device (8:16:9358952)
Read-error on swap-device (8:16:9358960)
Read-error on swap-device (8:16:9358968)
Read-error on swap-device (8:16:9358976)
Read-error on swap-device (8:16:9358984)
Read-error on swap-device (8:16:9358992)
Read-error on swap-device (8:16:9359000)
Read-error on swap-device (8:16:9359008)
Read-error on swap-device (8:16:9359016)
Read-error on swap-device (8:16:9359024)
Read-error on swap-device (8:16:9359032)
Read-error on swap-device (8:16:9359040)
Read-error on swap-device (8:16:9359048)
Read-error on swap-device (8:16:9359056)
Read-error on swap-device (8:16:9359064)
Read-error on swap-device (8:16:9359072)
Read-error on swap-device (8:16:9359080)
Read-error on swap-device (8:16:9359088)
Read-error on swap-device (8:16:9359096)
Read-error on swap-device (8:16:9359104)
Read-error on swap-device (8:16:9359112)
Read-error on swap-device (8:16:9359120)
Read-error on swap-device (8:16:9359128)
Read-error on swap-device (8:16:9359136)
Read-error on swap-device (8:16:9359144)
Read-error on swap-device (8:16:9359152)
Read-error on swap-device (8:16:9359160)
Read-error on swap-device (8:16:9359168)
Read-error on swap-device (8:16:9359176)
Read-error on swap-device (8:16:9359184)
Read-error on swap-device (8:16:9359192)
Read-error on swap-device (8:16:9359200)
Read-error on swap-device (8:16:9359208)
Read-error on swap-device (8:16:9359216)
Read-error on swap-device (8:16:9359224)
Read-error on swap-device (8:16:9359232)
Read-error on swap-device (8:16:9359240)
Read-error on swap-device (8:16:9359248)
Read-error on swap-device (8:16:9359256)
Read-error on swap-device (8:16:9359264)
Read-error on swap-device (8:16:9359272)
Read-error on swap-device (8:16:9359280)
Read-error on swap-device (8:16:9359288)
Read-error on swap-device (8:16:9359296)
Read-error on swap-device (8:16:9359304)
Read-error on swap-device (8:16:9359312)
Read-error on swap-device (8:16:9359320)
Read-error on swap-device (8:16:9359328)
Read-error on swap-device (8:16:9359336)
Read-error on swap-device (8:16:9359344)
Read-error on swap-device (8:16:9359352)
Read-error on swap-device (8:16:9359360)
Read-error on swap-device (8:16:9359368)
Read-error on swap-device (8:16:9359376)
Read-error on swap-device (8:16:9359384)
Read-error on swap-device (8:16:9359392)
Read-error on swap-device (8:16:9359400)
Read-error on swap-device (8:16:9359408)
Read-error on swap-device (8:16:9359416)
Read-error on swap-device (8:16:9359424)
Read-error on swap-device (8:16:9359432)
Read-error on swap-device (8:16:9359440)
Read-error on swap-device (8:16:9359448)
Read-error on swap-device (8:16:9359456)
Read-error on swap-device (8:16:9359464)
Read-error on swap-device (8:16:9359472)
Read-error on swap-device (8:16:9359480)
Read-error on swap-device (8:16:9359488)
Read-error on swap-device (8:16:9359496)
Read-error on swap-device (8:16:9359504)
Read-error on swap-device (8:16:9359512)
Read-error on swap-device (8:16:9359520)
Read-error on swap-device (8:16:9359528)
Read-error on swap-device (8:16:9359536)
Read-error on swap-device (8:16:9359544)
Read-error on swap-device (8:16:9359552)
Read-error on swap-device (8:16:9359560)
Read-error on swap-device (8:16:9359568)
Read-error on swap-device (8:16:9359576)
Read-error on swap-device (8:16:9359584)
Read-error on swap-device (8:16:9359592)
Read-error on swap-device (8:16:9359600)
Read-error on swap-device (8:16:9359608)
Read-error on swap-device (8:16:9359616)
Read-error on swap-device (8:16:9359624)
Read-error on swap-device (8:16:9359632)
Read-error on swap-device (8:16:9359640)
Read-error on swap-device (8:16:9359648)
Read-error on swap-device (8:16:9359656)
Read-error on swap-device (8:16:9359664)
Read-error on swap-device (8:16:9359672)
Read-error on swap-device (8:16:9359680)
Read-error on swap-device (8:16:9359688)
Read-error on swap-device (8:16:9359696)
Read-error on swap-device (8:16:9359704)
Read-error on swap-device (8:16:9359712)
Read-error on swap-device (8:16:9359720)
Read-error on swap-device (8:16:9359728)
Read-error on swap-device (8:16:9359736)
Read-error on swap-device (8:16:9359744)
Read-error on swap-device (8:16:9359752)
Read-error on swap-device (8:16:9359760)
Read-error on swap-device (8:16:9359768)
Read-error on swap-device (8:16:9359776)
Read-error on swap-device (8:16:9359784)
Read-error on swap-device (8:16:9359792)
Read-error on swap-device (8:16:9359800)
Read-error on swap-device (8:16:9359808)
Read-error on swap-device (8:16:9359816)
Read-error on swap-device (8:16:9359824)
Read-error on swap-device (8:16:9359832)
Read-error on swap-device (8:16:9359840)
Read-error on swap-device (8:16:9359848)
Read-error on swap-device (8:16:9359856)
Read-error on swap-device (8:16:9359864)
Read-error on swap-device (8:16:9359872)
Read-error on swap-device (8:16:9359880)
Read-error on swap-device (8:16:9359888)
Read-error on swap-device (8:16:9359896)
Read-error on swap-device (8:16:9359904)
Read-error on swap-device (8:16:9359912)
Read-error on swap-device (8:16:9359920)
Read-error on swap-device (8:16:9359928)
Read-error on swap-device (8:16:9359936)
Read-error on swap-device (8:16:9359944)
Read-error on swap-device (8:16:9359952)
Read-error on swap-device (8:16:9359960)
Read-error on swap-device (8:16:9359968)
Read-error on swap-device (8:16:9359976)
Read-error on swap-device (8:16:9359984)
Read-error on swap-device (8:16:9359992)
Read-error on swap-device (8:16:9360000)
Read-error on swap-device (8:16:9360008)
Read-error on swap-device (8:16:9360016)
Read-error on swap-device (8:16:9360024)
Read-error on swap-device (8:16:9360032)
Read-error on swap-device (8:16:9360040)
Read-error on swap-device (8:16:9360048)
Read-error on swap-device (8:16:9360056)
Read-error on swap-device (8:16:9360064)
Read-error on swap-device (8:16:9360072)
Read-error on swap-device (8:16:9360080)
Read-error on swap-device (8:16:9360088)
Read-error on swap-device (8:16:9360096)
Read-error on swap-device (8:16:9360104)
Read-error on swap-device (8:16:9360112)
Read-error on swap-device (8:16:9360120)
Read-error on swap-device (8:16:9360128)
Read-error on swap-device (8:16:9360136)
Read-error on swap-device (8:16:9360144)
Read-error on swap-device (8:16:9360152)
Read-error on swap-device (8:16:9360160)
Read-error on swap-device (8:16:9360168)
Read-error on swap-device (8:16:9360176)
Read-error on swap-device (8:16:9360184)
Read-error on swap-device (8:16:9360192)
Read-error on swap-device (8:16:9360200)
Read-error on swap-device (8:16:9360208)
Read-error on swap-device (8:16:9360216)
Read-error on swap-device (8:16:9360224)
Read-error on swap-device (8:16:9360232)
Read-error on swap-device (8:16:9360240)
Read-error on swap-device (8:16:9360248)
Read-error on swap-device (8:16:9360256)
Read-error on swap-device (8:16:9360264)
Read-error on swap-device (8:16:9360272)
Read-error on swap-device (8:16:9360280)
Read-error on swap-device (8:16:9360288)
Read-error on swap-device (8:16:9360296)
Read-error on swap-device (8:16:9360304)
Read-error on swap-device (8:16:9360312)
Read-error on swap-device (8:16:9360320)
Read-error on swap-device (8:16:9360328)
Read-error on swap-device (8:16:9360336)
Read-error on swap-device (8:16:9360344)
Read-error on swap-device (8:16:9360352)
Read-error on swap-device (8:16:9360360)
Read-error on swap-device (8:16:9360368)
Read-error on swap-device (8:16:9360376)
Read-error on swap-device (8:16:9360384)
Read-error on swap-device (8:16:9360392)
Read-error on swap-device (8:16:9360400)
Read-error on swap-device (8:16:9360408)
Read-error on swap-device (8:16:9360416)
Read-error on swap-device (8:16:9360424)
Read-error on swap-device (8:16:9360432)
Read-error on swap-device (8:16:9360440)
Read-error on swap-device (8:16:9360448)
Read-error on swap-device (8:16:9360456)
Read-error on swap-device (8:16:9360464)
Read-error on swap-device (8:16:9360472)
Read-error on swap-device (8:16:9360480)
Read-error on swap-device (8:16:9360488)
Read-error on swap-device (8:16:9360496)
Read-error on swap-device (8:16:9360504)
Read-error on swap-device (8:16:9360512)
Read-error on swap-device (8:16:9360520)
Read-error on swap-device (8:16:9360528)
Read-error on swap-device (8:16:9360536)
Read-error on swap-device (8:16:9360544)
Read-error on swap-device (8:16:9360552)
Read-error on swap-device (8:16:9360560)
Read-error on swap-device (8:16:9360568)
Read-error on swap-device (8:16:9360576)
Read-error on swap-device (8:16:9360584)
PM: Wrote 322768 kbytes in 0.41 seconds (787.23 MB/s)
Restarting tasks ... <7>hub 1-0:1.0: state 7 ports 8 chg 0000 evt 0000
done.
PM: Basic memory bitmaps freed

--u3/rZRmxL6MmkK24--
