Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944Ab0BYQna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:43:30 -0500
Received: from perec.tyrell.hu ([66.197.149.104]:55561 "EHLO perec.tyrell.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932906Ab0BYQn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:43:28 -0500
Message-ID: <4B86A8AB.2050604@maroy.hu>
Date: Thu, 25 Feb 2010 17:43:23 +0100
From: =?ISO-8859-1?Q?=C1kos_Mar=F3y?= <akos@maroy.hu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: pm_op(): usb_dev_suspend+0x0/0x10 returns -2 on USB device 8087:0020
References: <Pine.LNX.4.44L0.1002251020100.1686-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1002251020100.1686-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

> You should not be looking at the system log file; you should use the 
> output from dmesg.

indeed. I'm sorry about that.

looking at dmesg, its a long line of output. points of interest look
like the following:

[   12.216797] hub 2-0:1.0: hub_suspend
[   12.216811] usb usb2: bus auto-suspend
[   12.216816] usb usb2: bus suspend fail, err -2
[   12.216820] hub 2-0:1.0: hub_resume
[   12.216864] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0000
[   15.214004] hub 2-0:1.0: hub_suspend
[   15.214015] usb usb2: bus auto-suspend
[   15.214020] usb usb2: bus suspend fail, err -2
[   15.214024] hub 2-0:1.0: hub_resume
[   15.214055] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0000
[   18.211195] hub 2-0:1.0: hub_suspend
[   18.211206] usb usb2: bus auto-suspend
[   18.211211] usb usb2: bus suspend fail, err -2
[   18.211215] hub 2-0:1.0: hub_resume
[   18.211254] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0000
[   21.208379] hub 2-0:1.0: hub_suspend
[   21.208389] usb usb2: bus auto-suspend
[   21.208394] usb usb2: bus suspend fail, err -2
[   21.208398] hub 2-0:1.0: hub_resume
[   21.208432] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0000
[   24.205564] hub 2-0:1.0: hub_suspend
[   24.205578] usb usb2: bus auto-suspend
[   24.205583] usb usb2: bus suspend fail, err -2
[   24.205587] hub 2-0:1.0: hub_resume
[   24.205624] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0000

...

[   27.202742] hub 2-0:1.0: hub_suspend
[   27.202755] usb usb2: bus auto-suspend
[   27.202760] usb usb2: bus suspend fail, err -2
[   27.202764] hub 2-0:1.0: hub_resume
[   27.202807] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0000
[   29.851255] usb usb2: uevent
[   29.851420] usb 2-0:1.0: uevent

...

[   30.209824] usb usb2: bus auto-suspend
[   30.209828] usb usb2: bus suspend fail, err -2
[   30.209833] hub 2-0:1.0: hub_resume
[   30.209881] hub 2-0:1.0: state 7 ports 4 chg 0000 evt 0000

and a lot of the same, repeated all over. and then:

[  407.210004] PM: Entering mem sleep
[  407.210022] Suspending console(s) (use no_console_suspend to debug)
[  407.368716] hub 2-0:1.0: hub_suspend
[  407.368726] usb usb2: bus suspend
[  407.368731] usb usb2: bus suspend fail, err -2
[  407.368734] hub 2-0:1.0: hub_resume
[  407.368768] pm_op(): usb_dev_suspend+0x0/0x10 returns -2
[  407.368773] PM: Device usb2 failed to suspend: error -2
[  407.368776] PM: Some devices failed to suspend
[  407.371952] PM: resume devices took 0.000 seconds
[  407.372122] PM: Finishing wakeup.


> By the way, I noticed above that you have xhci-hcd installed.  As far 
> as I know, that driver does not yet support system suspend.  You should 
> try unloading xhci-hcd before doing the suspend (both with and without 
> CONFIG_USB_DEBUG).

wow, rmmod xhci - and the suspend goes through fine!

what is this xhci thing anyway?

> These separate issues deserve to be investigated more closely.  The USB 
> stack is not supposed to be that fragile.  Describe your environment 
> more fully and provide the dmesg log from a kernel with 
> CONFIG_USB_DEBUG enabled showing what happens during the experiments.

indeed. interestingly, xhci may be the culprit, as without xhci, the
external DVD doesn't even register at all.

loadind xhci, I get:

Feb 25 17:33:50 tonkachi kernel: [  168.203418] xhci_hcd 0000:02:00.0:
PCI INT A -> GSI 16 (level, low) -> IRQ 16
Feb 25 17:33:50 tonkachi kernel: [  168.203568] xhci_hcd 0000:02:00.0:
xHCI Host Controller
Feb 25 17:33:50 tonkachi kernel: [  168.203689] xhci_hcd 0000:02:00.0:
new USB bus registered, assigned bus number 2
Feb 25 17:33:50 tonkachi kernel: [  168.203832] xhci_hcd 0000:02:00.0:
irq 16, io mem 0xd4000000
Feb 25 17:33:50 tonkachi kernel: [  168.203875] usb usb2: config 1
interface 0 altsetting 0 endpoint 0x81 has no SuperSpeed companion
descriptor
Feb 25 17:33:50 tonkachi kernel: [  168.203912] usb usb2: New USB device
found, idVendor=1d6b, idProduct=0002
Feb 25 17:33:50 tonkachi kernel: [  168.203919] usb usb2: New USB device
strings: Mfr=3, Product=2, SerialNumber=1
Feb 25 17:33:50 tonkachi kernel: [  168.203925] usb usb2: Product: xHCI
Host Controller
Feb 25 17:33:50 tonkachi kernel: [  168.203931] usb usb2: Manufacturer:
Linux 2.6.32.8-usb-debug xhci_hcd
Feb 25 17:33:50 tonkachi kernel: [  168.203937] usb usb2: SerialNumber:
0000:02:00.0
Feb 25 17:33:50 tonkachi kernel: [  168.204089] usb usb2: configuration
#1 chosen from 1 choice
Feb 25 17:33:50 tonkachi kernel: [  168.204198] hub 2-0:1.0: USB hub found
Feb 25 17:33:50 tonkachi kernel: [  168.204213] hub 2-0:1.0: 4 ports
detected


plugging in the USB DVD drive, there's a system 'freeze' for about 5
seconds (nothing is responding, not even caps lock), then I get in syslog:

Feb 25 17:34:39 tonkachi kernel: [  217.433960] Registered led device:
iwl-phy0::radio
Feb 25 17:34:39 tonkachi kernel: [  217.433990] Registered led device:
iwl-phy0::assoc
Feb 25 17:34:39 tonkachi kernel: [  217.434020] Registered led device:
iwl-phy0::RX
Feb 25 17:34:39 tonkachi kernel: [  217.434045] Registered led device:
iwl-phy0::TX
Feb 25 17:34:39 tonkachi kernel: [  217.463366] usb 2-4: new high speed
USB device using xhci_hcd and address 0
Feb 25 17:34:39 tonkachi kernel: [  217.485828] usb 2-4: New USB device
found, idVendor=058f, idProduct=6254
Feb 25 17:34:39 tonkachi kernel: [  217.485834] usb 2-4: New USB device
strings: Mfr=0, Product=0, SerialNumber=0
Feb 25 17:34:39 tonkachi kernel: [  217.485949] usb 2-4: configuration
#1 chosen from 1 choice
Feb 25 17:34:39 tonkachi kernel: [  217.485963] usb 2-4: ep 0x81 -
rounding interval to 2048 microframes
Feb 25 17:34:39 tonkachi kernel: [  217.487002] hub 2-4:1.0: USB hub found
Feb 25 17:34:39 tonkachi kernel: [  217.487502] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 17:34:39 tonkachi kernel: [  217.487533] hub 2-4:1.0: 3 ports
detected
Feb 25 17:34:40 tonkachi kernel: [  217.782947] usb 2-4.1: new high
speed USB device using xhci_hcd and address 0
Feb 25 17:34:40 tonkachi kernel: [  217.806372] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 17:34:40 tonkachi kernel: [  217.807238] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 17:34:40 tonkachi kernel: [  217.808106] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 17:34:40 tonkachi kernel: [  217.808996] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 17:34:40 tonkachi kernel: [  217.809420] usb 2-4.1: New USB
device found, idVendor=152d, idProduct=2339
Feb 25 17:34:40 tonkachi kernel: [  217.809425] usb 2-4.1: New USB
device strings: Mfr=1, Product=2, SerialNumber=5
Feb 25 17:34:40 tonkachi kernel: [  217.809430] usb 2-4.1: Product: USB
to ATA/ATAPI Bridge
Feb 25 17:34:40 tonkachi kernel: [  217.809434] usb 2-4.1: Manufacturer:
JMicron
Feb 25 17:34:40 tonkachi kernel: [  217.809437] usb 2-4.1: SerialNumber:
6A1713351FFF
Feb 25 17:34:40 tonkachi kernel: [  217.809574] usb 2-4.1: configuration
#1 chosen from 1 choice
Feb 25 17:34:40 tonkachi kernel: [  217.811213] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 17:34:40 tonkachi kernel: [  217.812078] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 17:34:40 tonkachi kernel: [  217.840485] Initializing USB Mass
Storage driver...
Feb 25 17:34:40 tonkachi kernel: [  217.840664] scsi6 : SCSI emulation
for USB Mass Storage devices
Feb 25 17:34:40 tonkachi kernel: [  217.840795] usbcore: registered new
interface driver usb-storage
Feb 25 17:34:40 tonkachi kernel: [  217.840800] USB Mass Storage support
registered.
Feb 25 17:34:45 tonkachi kernel: [  222.833493] scsi 6:0:0:0: CD-ROM
        hp       DVDRAM GT20L     DC05 PQ: 0 ANSI: 0
Feb 25 17:34:45 tonkachi kernel: [  222.846361] xhci_hcd 0000:02:00.0:
WARN: Stalled endpoint
Feb 25 17:34:45 tonkachi kernel: [  222.847589] sr0: scsi3-mmc drive:
24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Feb 25 17:34:45 tonkachi kernel: [  222.847597] Uniform CD-ROM driver
Revision: 3.20
Feb 25 17:34:45 tonkachi kernel: [  222.849281] sr 6:0:0:0: Attached
scsi generic sg2 type 5
Feb 25 17:34:45 tonkachi kernel: [  222.958589] xhci_hcd 0000:02:00.0:
WARN: Stalled endpoint


now, I unplug the USB DVD drive:

Feb 25 17:35:38 tonkachi kernel: [  276.374282] xhci_hcd 0000:02:00.0:
WARN: transfer error on endpoint
Feb 25 17:35:39 tonkachi kernel: [  276.728151] xhci_hcd 0000:02:00.0:
WARN: transfer error on endpoint
Feb 25 17:35:39 tonkachi kernel: [  276.728819] xhci_hcd 0000:02:00.0:
WARN: transfer error on endpoint


I plug it back in, with a DVD in the drive:

Feb 25 17:41:21 tonkachi kernel: [  618.701586] Registered led device:
iwl-phy0::radio
Feb 25 17:41:21 tonkachi kernel: [  618.701619] Registered led device:
iwl-phy0::assoc
Feb 25 17:41:21 tonkachi kernel: [  618.701649] Registered led device:
iwl-phy0::RX
Feb 25 17:41:21 tonkachi kernel: [  618.701674] Registered led device:
iwl-phy0::TX
Feb 25 17:41:21 tonkachi kernel: [  618.719536] usb 2-3: new high speed
USB device using xhci_hcd and address 0
Feb 25 17:41:21 tonkachi kernel: [  618.742028] usb 2-3: New USB device
found, idVendor=058f, idProduct=6254
Feb 25 17:41:21 tonkachi kernel: [  618.742034] usb 2-3: New USB device
strings: Mfr=0, Product=0, SerialNumber=0
Feb 25 17:41:21 tonkachi kernel: [  618.742155] usb 2-3: configuration
#1 chosen from 1 choice
Feb 25 17:41:21 tonkachi kernel: [  618.742168] usb 2-3: ep 0x81 -
rounding interval to 2048 microframes
Feb 25 17:41:21 tonkachi kernel: [  618.743316] hub 2-3:1.0: USB hub found
Feb 25 17:41:21 tonkachi kernel: [  618.743794] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 17:41:21 tonkachi kernel: [  618.743830] hub 2-3:1.0: 3 ports
detected
Feb 25 17:41:21 tonkachi kernel: [  619.045944] usb 2-3.1: new high
speed USB device using xhci_hcd and address 0
Feb 25 17:41:21 tonkachi kernel: [  619.069424] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 17:41:21 tonkachi kernel: [  619.070295] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 17:41:21 tonkachi kernel: [  619.071173] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 17:41:21 tonkachi kernel: [  619.072042] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 17:41:21 tonkachi kernel: [  619.072398] usb 2-3.1: New USB
device found, idVendor=152d, idProduct=2339
Feb 25 17:41:21 tonkachi kernel: [  619.072404] usb 2-3.1: New USB
device strings: Mfr=1, Product=2, SerialNumber=5
Feb 25 17:41:21 tonkachi kernel: [  619.072408] usb 2-3.1: Product: USB
to ATA/ATAPI Bridge
Feb 25 17:41:21 tonkachi kernel: [  619.072412] usb 2-3.1: Manufacturer:
JMicron
Feb 25 17:41:21 tonkachi kernel: [  619.072416] usb 2-3.1: SerialNumber:
6A1713351FFF
Feb 25 17:41:21 tonkachi kernel: [  619.072530] usb 2-3.1: configuration
#1 chosen from 1 choice
Feb 25 17:41:21 tonkachi kernel: [  619.074124] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 17:41:21 tonkachi kernel: [  619.074999] xhci_hcd 0000:02:00.0:
WARN: short transfer on control ep
Feb 25 17:41:21 tonkachi kernel: [  619.075559] scsi7 : SCSI emulation
for USB Mass Storage devices



Feb 25 17:41:26 tonkachi kernel: [  624.073472] scsi 7:0:0:0: CD-ROM
        hp       DVDRAM GT20L     DC05 PQ: 0 ANSI: 0
Feb 25 17:41:26 tonkachi kernel: [  624.086041] xhci_hcd 0000:02:00.0:
WARN: Stalled endpoint
Feb 25 17:41:26 tonkachi kernel: [  624.087393] sr0: scsi3-mmc drive:
62x/62x writer dvd-ram cd/rw xa/form2 cdda tray
Feb 25 17:41:26 tonkachi kernel: [  624.088377] sr 7:0:0:0: Attached
scsi generic sg2 type 5
Feb 25 17:41:26 tonkachi kernel: [  624.118679] xhci_hcd 0000:02:00.0:
WARN: Stalled endpoint
Feb 25 17:41:29 tonkachi kernel: [  626.883451] xhci_hcd 0000:02:00.0:
WARN: Stalled endpoint
Feb 25 17:41:29 tonkachi kernel: [  626.915739] xhci_hcd 0000:02:00.0:
WARN: Stalled endpoint
Feb 25 17:41:29 tonkachi kernel: [  627.147000] xhci_hcd 0000:02:00.0:
WARN: Stalled endpoint
Feb 25 17:41:29 tonkachi kernel: [  627.270741] xhci_hcd 0000:02:00.0:
WARN: Stalled endpoint


unplug:

Feb 25 17:42:05 tonkachi kernel: [  663.327552] xhci_hcd 0000:02:00.0:
WARN: transfer error on endpoint
Feb 25 17:42:06 tonkachi kernel: [  663.364546] xhci_hcd 0000:02:00.0:
WARN: transfer error on endpoint
Feb 25 17:42:06 tonkachi kernel: [  663.365228] xhci_hcd 0000:02:00.0:
WARN: transfer error on endpoint
Feb 25 17:42:10 tonkachi kernel: [  667.360714] VFS: busy inodes on
changed media or resized disk sr0
Feb 25 17:42:10 tonkachi kernel: [  667.360956] VFS: busy inodes on
changed media or resized disk sr0
Feb 25 17:42:10 tonkachi kernel: [  667.361101] VFS: busy inodes on
changed media or resized disk sr0
Feb 25 17:42:10 tonkachi kernel: [  667.362264] VFS: busy inodes on
changed media or resized disk sr0
Feb 25 17:42:10 tonkachi kernel: [  667.363730] VFS: busy inodes on
changed media or resized disk sr0
Feb 25 17:42:10 tonkachi kernel: [  667.377669] VFS: busy inodes on
changed media or resized disk sr0
Feb 25 17:42:10 tonkachi kernel: [  667.377910] VFS: busy inodes on
changed media or resized disk sr0
Feb 25 17:42:10 tonkachi kernel: [  667.378158] VFS: busy inodes on
changed media or resized disk sr0



plug back in:

Feb 25 17:42:50 tonkachi kernel: [  707.759089] Registered led device:
iwl-phy0::radio
Feb 25 17:42:50 tonkachi kernel: [  707.759179] Registered led device:
iwl-phy0::assoc
Feb 25 17:42:50 tonkachi kernel: [  707.759412] Registered led device:
iwl-phy0::RX
Feb 25 17:42:50 tonkachi kernel: [  707.759572] Registered led device:
iwl-phy0::TX



but the disk does not register anymore :(


Akos

