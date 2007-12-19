Return-Path: <linux-kernel-owner+w=401wt.eu-S1755437AbXLSQsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbXLSQsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 11:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbXLSQsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 11:48:21 -0500
Received: from rn-out-0910.google.com ([64.233.170.188]:55493 "EHLO
	rn-out-0102.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752484AbXLSQsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 11:48:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bB7G4OD7vhudA8+8bx0YEmqnHvDJov/XDJsWocLtmxADDF/rEHe2u+5xxTm11kOI8DqPnd9hD7lC1F1OVhkNaUrj3E0py/eR28J9l2A2pE5Q3SfauBhD01ju/+dTUKkcWakkmH6Sc4rEPagtlCGlBMmEUBAU7gd7GmL/Oe9nlO4=
Message-ID: <82e4877d0712190848r4168b3dp80e53fdcd7c82ce5@mail.gmail.com>
Date: Wed, 19 Dec 2007 11:48:16 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: Fix DMI out of memory problems
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, ak@suse.de,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20071219104823.GI3521@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0712181848430.3663@mini.warudkars.net>
	 <20071219104823.GI3521@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 19, 2007 5:48 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Parag Warudkar <parag.warudkar@gmail.com> wrote:
>

> [ note: i had to manually fix up your patch because your email client
>   added an extra space to every diff line - see
>   Documentation/email-clients.txt on how to avoid that. I also did a few
>   small cleanups - please check patches via scripts/checkpatch.pl. I've
>   attached the merged patch below. ]

Thanks for fixing this up - the only recommended option missing in
pine is quell-flowed-text. Will set it up and see how that goes.

>
> What's the worst-case symptom you get with that bug - any failure type
> thing - or only annoying boot messages? Could you perhaps post the diff
> -u between the unpatched and patched kernel's full dmesg/bootlog? Are
> there any specific DMI quirks that are skipped due to us wasting DMI
> space on empty strings?

I did not see any failures on my desktop at least - being a newer
Intel board (P35) it does not seem to require any quirks - for those
HP desktops which do require quirks it sounds plausible that some may
be missed without the patch. dmesg diff does not look significantly
different apart from the obviously absent DMI OOM messages and time.c
/ apic timer calibration differences along with same but differently
placed lines - not sure why that happens, may not be related to this
patch I think.

--- 2.6.24-rc5-patched	2007-12-19 07:21:05.000000000 -0500
+++ 2.6.24-rc5-new	2007-12-19 11:36:54.000000000 -0500
@@ -1,4 +1,4 @@
-Linux version 2.6.24-rc5 (root@pavillion.hsd1.mi.comcast.net) (gcc
version 4.1.2 20070626 (Red Hat 4.1.2-14)) #2 SMP Mon Dec 17 18:42:27
EST 2007
+Linux version 2.6.24-rc5 (parag@pavillion.hsd1.mi.comcast.net) (gcc
version 4.1.2 20070626 (Red Hat 4.1.2-14)) #2 SMP Wed Dec 19 11:32:37
EST 2007
 Command line: ro root=/dev/VolGroup00/LogVol00 rhgb quiet
 BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009ec00 (usable)
@@ -75,7 +75,7 @@
 PID hash table entries: 4096 (order: 12, 32768 bytes)
 hpet clockevent registered
 TSC calibrated against HPET
-time.c: Detected 2199.954 MHz processor.
+time.c: Detected 2199.958 MHz processor.
 Console: colour VGA+ 80x25
 console [tty0] enabled
 Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
@@ -85,7 +85,7 @@
 Placing software IO TLB between 0x7add000 - 0xbadd000
 Memory: 6107352k/7077888k available (2349k kernel code, 182900k
reserved, 1103k data, 216k init)
 SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
-Calibrating delay using timer specific routine.. 4403.90 BogoMIPS (lpj=8807812)
+Calibrating delay using timer specific routine.. 4403.90 BogoMIPS (lpj=8807800)
 Security Framework initialized
 SELinux:  Initializing.
 SELinux:  Starting in permissive mode
@@ -101,12 +101,12 @@
 SMP alternatives: switching to UP code
 ACPI: Core revision 20070126
 Using local APIC timer interrupts.
-APIC timer calibration result 12499737
+APIC timer calibration result 12499803
 Detected 12.499 MHz APIC timer.
 SMP alternatives: switching to SMP code
 Booting processor 1/2 APIC 0x1
 Initializing CPU#1
-Calibrating delay using timer specific routine.. 4399.88 BogoMIPS (lpj=8799760)
+Calibrating delay using timer specific routine.. 4399.95 BogoMIPS (lpj=8799915)
 CPU: L1 I cache: 32K, L1 D cache: 32K
 CPU: L2 cache: 2048K
 CPU: Physical Processor ID: 0
@@ -192,9 +192,9 @@
 checking if image is initramfs...<7>Switched to high resolution mode on CPU 1
 Switched to high resolution mode on CPU 0
  it is
-Freeing initrd memory: 3036k freed
+Freeing initrd memory: 3037k freed
 audit: initializing netlink socket (disabled)
-audit(1198048697.636:1): initialized
+audit(1198064108.636:1): initialized
 Total HugeTLB memory allocated, 0
 VFS: Disk quotas dquot_6.5.1
 Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
@@ -318,17 +318,9 @@
 ata2: SATA max UDMA/100 mmio m512@0xf9ffec00 tf 0xf9ffecc0 irq 17
 usb 8-5: new high speed USB device using ehci_hcd and address 2
 ata1: SATA link down (SStatus 0 SControl 310)
-usb 8-5: configuration #1 chosen from 1 choice
 ata2: SATA link down (SStatus 0 SControl 310)
 ahci 0000:00:1f.2: version 3.0
 ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
-usb 8-7: new high speed USB device using ehci_hcd and address 3
-usb 8-7: configuration #1 chosen from 1 choice
-hub 8-7:1.0: USB hub found
-hub 8-7:1.0: 3 ports detected
-usb 8-7.2: new low speed USB device using ehci_hcd and address 4
-usb 8-7.2: configuration #1 chosen from 1 choice
-hiddev96: USB HID v1.11 Device [Apple Cinema Display] on usb-0000:00:1d.7-7.2
 ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
 ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part
 PCI: Setting latency timer of device 0000:00:1f.2 to 64
@@ -400,11 +392,19 @@
  [LDM] sdc1
 sd 7:0:0:0: [sdc] Attached SCSI disk
 Initializing USB Mass Storage driver...
+usb 8-5: configuration #1 chosen from 1 choice
+usb 8-7: new high speed USB device using ehci_hcd and address 3
+usb 8-7: configuration #1 chosen from 1 choice
+hub 8-7:1.0: USB hub found
+hub 8-7:1.0: 3 ports detected
 scsi8 : SCSI emulation for USB Mass Storage devices
-usbcore: registered new interface driver usb-storage
-USB Mass Storage support registered.
 usb-storage: device found at 2
 usb-storage: waiting for device to settle before scanning
+usb 8-7.2: new low speed USB device using ehci_hcd and address 4
+usb 8-7.2: configuration #1 chosen from 1 choice
+hiddev96: USB HID v1.11 Device [Apple Cinema Display] on usb-0000:00:1d.7-7.2
+usbcore: registered new interface driver usb-storage
+USB Mass Storage support registered.
 usb-storage: device scan complete
 scsi 8:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
 scsi 8:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
@@ -442,7 +442,8 @@
 SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
 SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
 SELinux: policy loaded with handle_unknown=deny
-audit(1198048714.948:2): policy loaded auid=4294967295
+audit(1198064127.320:2): policy loaded auid=4294967295
+shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
 e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
 e1000e: Copyright (c) 1999-2007 Intel Corporation.
 ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
@@ -451,16 +452,14 @@
 input: PC Speaker as /class/input/input3
 ACPI: Power Button (FF) [PWRF]
 input: Power Button (CM) as /class/input/input4
+ACPI: Power Button (CM) [PWRB]
 0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1d:60:d1:07:13
 0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
 0000:00:19.0: eth0: MAC: 5, PHY: 6, PBA No: ffffff-0ff
-shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
 ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 18
-ACPI: Power Button (CM) [PWRB]
 sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 cdda tray
 Uniform CD-ROM driver Revision: 3.20
 sr 3:0:0:0: Attached scsi CD-ROM sr0
-usbcore: registered new interface driver appledisplay
 sd 2:0:0:0: Attached scsi generic sg0 type 0
 sr 3:0:0:0: Attached scsi generic sg1 type 5
 sd 4:0:0:0: Attached scsi generic sg2 type 0
@@ -469,6 +468,7 @@
 sd 8:0:0:1: Attached scsi generic sg5 type 0
 sd 8:0:0:2: Attached scsi generic sg6 type 0
 sd 8:0:0:3: Attached scsi generic sg7 type 0
+usbcore: registered new interface driver appledisplay
 floppy0: no floppy controllers found
 lp: driver loaded but no devices found
 SELinux: initialized (dev ramfs, type ramfs), uses genfs_contexts
@@ -505,3 +505,4 @@
 eth0: no IPv6 routers present
 Bridge firewalling registered
 virbr0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
+ip_tables: (C) 2000-2006 Netfilter Core Team

>
> Also, shouldnt we perhaps increase DMI_MAX_DATA from 2K to 4K?
>

Google doesn't reveal anyone apart from HP Desktop owners [*] with
large empty OEM strings as having this problem - and with this patch
the existing 2K is underutilized - less than 500 bytes on my desktop.
So I think we can defer the increase until someone actually needs that
much DMI space for valid purposes.

Thanks

Parag

[*] http://forums.fedoraforum.org/archive/index.php/t-163317.html
[*] http://ubuntuforums.org/archive/index.php/t-357738.html
