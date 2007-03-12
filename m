Return-Path: <linux-kernel-owner+w=401wt.eu-S932954AbXCLW0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbXCLW0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 18:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932964AbXCLW0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 18:26:22 -0400
Received: from cheltenham.cs.arizona.edu ([192.12.69.60]:4954 "EHLO
	cheltenham.cs.arizona.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932954AbXCLW0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 18:26:21 -0400
X-Greylist: delayed 823 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Mar 2007 18:26:21 EDT
Date: Mon, 12 Mar 2007 15:12:36 -0700
From: Phil Kaslo <phil@cs.arizona.edu>
Message-Id: <200703122212.l2CMCaxm032601@osprey.cs.arizona.edu>
To: linux-kernel@vger.kernel.org
Subject: Asus P5B-VM motherboard:  cd drive malfunctions if internal nic in use.
Cc: linux-ide@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I have a new machine, Asus motherboard, in which the cd drive malfunctions 
if the internal nic on the mb (RealTek RTL8168b/8111b) is actively in use.   
The cd drive, on ide2, is, as per dmesg, a Sony:
 ide2: BM-DMA at 0xa400-0xa407, BIOS settings: hde:pio, hdf:pio
 hde: SONY DVD RW AW-Q170A, ATAPI CD/DVD-ROM drive
 hde: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(66)

I've seen this on 3 of these new machines so far.  One has a LITE-ON cdrom: 
 hde: LITE-ON DVDRW LH-20A1H, ATAPI CD/DVD-ROM drive
so this is not unique to the Sony.

Motherboard:  Asus P5B-VM  G965 775  BIOS Revision : 613
CPU: Intel Core 2 CPU 6300 1.86GHz

Fedora Core 6, x86_64, Linux version 2.6.19-1.2911.6.4.fc6.
Also, with Linux kernel version 2.6.20.1, from source.
With nic kernel module r1000.ko, version 1.05, from RealTek.
Also with kernel module r8169.ko, from kernel version 2.6.20.1.

>From /proc/interrupts:  ide2/hde/cdrom and eth0 are both on irq 17:
 17:      10602      44763   IO-APIC-fasteoi   ide2, uhci_hcd:usb2, eth0

When i first brought the system up, i got continual messages saying the 
cdrom seemed confused.  Turning off haldaemon quieted those.

Reproduce by bringing up a Fedora 6 or kernel version 2.6.20.1 system 
as above, using the internal nic. Start up an scp of 1 gb file from another 
machine to this machine.  In another window, attempt to mount a data cd, 
or play a music cd.  See it not work, and see error output from dmesg.  
Sample output:

 hde: cdrom_pc_intr: The drive appears confused (ireason = 0x01). Trying to 
 recover by ending request.
 hde: status error: status=0x58 { DriveReady SeekComplete DataRequest }
 ide: failed opcode was: unknown
 hde: drive not ready for command
 ...
 hde: status timeout: status=0xd8 { Busy }
 hde: DMA disabled
 hde: drive not ready for command
 hde: ATAPI reset complete
 end_request: I/O error, dev hde, sector 64
 isofs_fill_super: bread failed, dev=hde, iso_blknum=16, block=16

Workaround - disable the internal nic in the bios.  Use a pci nic card, 
such as an Intel Pro 1000 (kernel module e1000).  Try the above test, and 
see the cd drive work.  Get no error output from dmesg.

>From /proc/interrupts with pci nic: eth1, e1000, is on irq 16 and ide2 is on 17:
 16:      11907    2833837   IO-APIC-fasteoi   uhci_hcd:usb1, eth1, nvidia
 17:         48      84696   IO-APIC-fasteoi   ide2, uhci_hcd:usb2

I do not know if this is a bios problem on this motherboard,
a problem in the r1000 and r8169 drivers for the Realtek nic,
or a problem in the ide drivers that drive the cdrom.

Thanks for any help or clues.

Phil Kaslo
Dept. of Computer Science  520-621/2760
University of Arizona      phil@cs.arizona.edu
Tucson, Ariz. 85721
