Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbZGHQaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbZGHQaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 12:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbZGHQaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 12:30:18 -0400
Received: from mx-out.daemonmail.net ([216.104.160.38]:57519 "EHLO
	mx-out.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbZGHQaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 12:30:16 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Null Pointer BUG in uhci_hcd
Date: Wed, 8 Jul 2009 11:30:04 -0500
User-Agent: KMail/1.9.9
Cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0907071513380.8221-100000@iolanthe.rowland.org> <200907080943.47248.lkml@morethan.org>
In-Reply-To: <200907080943.47248.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907081130.07370.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed July 8 2009, Michael S. Zick wrote:
> On Tue July 7 2009, Alan Stern wrote:
> > On Tue, 7 Jul 2009, Michael S. Zick wrote:
> > 
> > > On Tue July 7 2009, Alan Stern wrote:
> > > > On Tue, 7 Jul 2009, Michael S. Zick wrote:
> > > > 
> > > > > > It looks like there's a serious problem in your UHCI hardware.  
> > > > > > According to the log you posted, it's not working at all.
> > > > > > 
> > > > > 
> > > > > I am using the x86-generic drivers - -
> > > > 
> > > > Not a problem with the drivers, a problem in the hardware.
> > > > 
> > > 
> > > Or hardware that works as the manufacturer intended, but differently
> > > than expected.  Same difference as "broken" when compared to "standard".
> > 
> > No, hardware that doesn't work at all.  As in "all reads return
> > 0xffffffff" -- that's just a guess but something like it would account
> > for what you saw.
> > 
> 
> Scratches head, and other parts. . .
> 
> Hmm... Already known about this chipset/cpu combination; there is
> something about its hardware timing that is a "primary problem" - -
> 
> In addition to the suggested diagnostic and suggest fix - will look
> into finding if that is a problem here, also.
> It may just be a hardware timing issue - the processor is hitting the
> hub before the hub has its act together from the last action.
> 
> Most likely will take most of the day - unless something jumps out
> and says "I'm broke" during the testing.  ;)
> 

But, then again, we might just get lucky:
ehci_hcd 0000:00:10.4: Unlink after no-IRQ?  Controller is probably using the wrong IRQ.
usb 1-5: khubd timed out on ep0in len=18/64

dmesg from start of ehci load (no external devices connected):

ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
ehci_hcd 0000:00:10.4: PCI INT D -> Link[LNKD] -> GSI 9 (level, low) -> IRQ 9
ehci_hcd 0000:00:10.4: setting latency timer to 64
ehci_hcd 0000:00:10.4: EHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:10.4: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
ehci_hcd 0000:00:10.4: reset hcc_params 6872 thresh 7 uframes 256/512/1024
ehci_hcd 0000:00:10.4: reset command 080022 (park)=0 ithresh=8 Async period=1024 Reset HALT
ehci_hcd 0000:00:10.4: debug port 1
ehci_hcd 0000:00:10.4: MWI active
ehci_hcd 0000:00:10.4: supports USB remote wakeup
ehci_hcd 0000:00:10.4: irq 9, io mem 0xd1400000
ehci_hcd 0000:00:10.4: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:10.4: init command 010009 (park)=0 ithresh=1 period=256 RUN
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00
usb usb1: default language 0x0409
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.30-ce1200v-09189 ehci_hcd
usb usb1: SerialNumber: 0000:00:10.4
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
uhci_hcd: USB Universal Host Controller Interface driver
uhci_hcd 0000:00:10.0: PCI INT A -> Link[LNKA] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:10.0: setting latency timer to 64
uhci_hcd 0000:00:10.0: UHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.0: detected 2 ports
uhci_hcd 0000:00:10.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:10.0: Performing full reset
uhci_hcd 0000:00:10.0: supports USB remote wakeup
uhci_hcd 0000:00:10.0: irq 10, io base 0x00004400
usb usb2: default language 0x0409
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.30-ce1200v-09189 uhci_hcd
usb usb2: SerialNumber: 0000:00:10.0
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
uhci_hcd 0000:00:10.1: PCI INT B -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
uhci_hcd 0000:00:10.1: setting latency timer to 64
uhci_hcd 0000:00:10.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '003'
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.1: detected 2 ports
uhci_hcd 0000:00:10.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:10.1: Performing full reset
uhci_hcd 0000:00:10.1: supports USB remote wakeup
uhci_hcd 0000:00:10.1: irq 11, io base 0x00004420
usb usb3: default language 0x0409
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.30-ce1200v-09189 uhci_hcd
usb usb3: SerialNumber: 0000:00:10.1
usb usb3: uevent
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
usb 3-0:1.0: uevent
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: individual port over-current protection
hub 3-0:1.0: power on to power good time: 2ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
uhci_hcd 0000:00:10.2: PCI INT C -> Link[LNKC] -> GSI 10 (level, low) -> IRQ 10
uhci_hcd 0000:00:10.2: setting latency timer to 64
uhci_hcd 0000:00:10.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file '004'
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.2: detected 2 ports
uhci_hcd 0000:00:10.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:10.2: Performing full reset
uhci_hcd 0000:00:10.2: supports USB remote wakeup
uhci_hcd 0000:00:10.2: irq 10, io base 0x00004440
usb usb4: default language 0x0409
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.30-ce1200v-09189 uhci_hcd
usb usb4: SerialNumber: 0000:00:10.2
usb usb4: uevent
usb usb4: usb_probe_device
usb usb4: configuration #1 chosen from 1 choice
usb usb4: adding 4-0:1.0 (config #1, interface 0)
usb 4-0:1.0: uevent
hub 4-0:1.0: usb_probe_interface
hub 4-0:1.0: usb_probe_interface - got id
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
hub 4-0:1.0: standalone hub
hub 4-0:1.0: no power switching (usb 1.0)
hub 4-0:1.0: individual port over-current protection
hub 4-0:1.0: power on to power good time: 2ms
hub 4-0:1.0: local power source is good
hub 4-0:1.0: trying to enable port power on non-switchable hub
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:10.4: GetStatus port 5 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 5: status 0501 change 0001
ehci_hcd 0000:00:10.4: GetStatus port 6 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 6: status 0501 change 0001
usbcore: registered new interface driver rtl8187
uhci_hcd 0000:00:10.0: port 1 portsc 008a,00
uhci_hcd 0000:00:10.0: port 2 portsc 008a,00
uhci_hcd 0000:00:10.1: port 1 portsc 008a,00
uhci_hcd 0000:00:10.1: port 2 portsc 008a,00
uhci_hcd 0000:00:10.2: port 1 portsc 009a,00
uhci_hcd 0000:00:10.2: port 2 portsc 009a,00
hub 1-0:1.0: state 7 ports 6 chg 0060 evt 0000
hub 1-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
ehci_hcd 0000:00:10.4: port 5 high speed
ehci_hcd 0000:00:10.4: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
usb 1-5: new high speed USB device using ehci_hcd and address 2
usb usb2: uevent
usb 2-0:1.0: uevent
usb usb3: uevent
usb 3-0:1.0: uevent
usb usb4: uevent
usb 4-0:1.0: uevent
usb usb1: uevent
usb 1-0:1.0: uevent
usb usb2: suspend_rh (auto-stop)
usb usb3: suspend_rh (auto-stop)
usb usb4: suspend_rh (auto-stop)
PM: Starting manual resume from disk
PM: Resume from partition 8:2
PM: Checking hibernation image.
PM: Resume from disk failed.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with writeback data mode.
ehci_hcd 0000:00:10.4: Unlink after no-IRQ?  Controller is probably using the wrong IRQ.
usb 1-5: khubd timed out on ep0in len=18/64
ehci_hcd 0000:00:10.4: port 5 high speed
ehci_hcd 0000:00:10.4: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
udev: starting version 141
usb usb2: uevent
usb 2-0:1.0: uevent
usb usb3: uevent
usb 3-0:1.0: uevent
udev: starting version 141
usb usb2: uevent
usb 2-0:1.0: uevent
usb usb3: uevent
usb 3-0:1.0: uevent
usb usb4: uevent
usb 4-0:1.0: uevent
usb usb1: uevent
usb 1-0:1.0: uevent
udev: renamed network interface eth0 to eth1
usb 1-5: khubd timed out on ep0out len=0/0
eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
Adding 1004052k swap on /dev/sda2.  Priority:4 extents:1 across:1004052k
usb 1-5: khubd timed out on ep0out len=0/0
usb 1-5: device not accepting address 2, error -110
ehci_hcd 0000:00:10.4: port 5 high speed
ehci_hcd 0000:00:10.4: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
usb 1-5: new high speed USB device using ehci_hcd and address 3
EXT3 FS on sda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda4, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
usb 1-5: khubd timed out on ep0in len=18/64
ehci_hcd 0000:00:10.4: port 5 high speed
ehci_hcd 0000:00:10.4: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
eth1: no IPv6 routers present
usb 1-5: khubd timed out on ep0out len=0/0
usb 1-5: khubd timed out on ep0out len=0/0
usb 1-5: device not accepting address 3, error -110
ehci_hcd 0000:00:10.4: port 5 high speed
ehci_hcd 0000:00:10.4: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
usb 1-5: new high speed USB device using ehci_hcd and address 4
usb usb2: uevent
usb 2-0:1.0: uevent
usb usb3: uevent
usb 3-0:1.0: uevent
usb usb4: uevent
usb 4-0:1.0: uevent
usb usb1: uevent
usb 1-0:1.0: uevent
usb 1-5: khubd timed out on ep0out len=0/0
usb 1-5: khubd timed out on ep0out len=0/0
usb 1-5: device not accepting address 4, error -110
ehci_hcd 0000:00:10.4: port 5 high speed
ehci_hcd 0000:00:10.4: GetStatus port 5 status 001005 POWER sig=se0 PE CONNECT
usb 1-5: new high speed USB device using ehci_hcd and address 5


> Mike
> > For more information enable CONFIG_USB_DEBUG and CONFIG_DEBUG_FS, then 
> > see what's sitting in the usb/uhci/* files in debugfs.
> > 

Anything in particular to look for/at?

Mike
> > > Let me see if I can find it again;
> > > 1106:3038 translates to: PCI_DEVICE_ID_VIA_82C586_2
> > > 1106:3104 translates to: PCI_DEVICE_ID_VIA_8235_USB_2
> > > 
> > > The first appears in (this device is the UHCI hub in the CX700 chipset):
> > > arch/powerpc/platforms/85xx/mpc85xx_cds.c:              case PCI_DEVICE_ID_VIA_82C586_2:
> > > arch/mips/pci/fixup-lm2e.c:DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_82C586_2,
> > > include/linux/pci_ids.h:#define PCI_DEVICE_ID_VIA_82C586_2      0x3038
> > 
> > Those are simple interrupt routing fixups.  Not related.
> > 
> > > The second appears in:
> > > include/linux/pci_ids.h:#define PCI_DEVICE_ID_VIA_8235_USB_2    0x3104
> > > <Hmm... Dead?  Not used?  Never used?  Source padding?>
> > 
> > Probably never used.
> > 
> > Alan Stern
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


