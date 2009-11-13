Return-Path: <linux-kernel-owner+w=401wt.eu-S932451AbZKMXEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbZKMXEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932407AbZKMXEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:04:14 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:42300 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406AbZKMXEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:04:13 -0500
X-Greylist: delayed 2035 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Nov 2009 18:04:12 EST
Message-ID: <4AFDDDF6.4050907@ahsoftware.de>
Date: Fri, 13 Nov 2009 23:30:14 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problems with p55-express and sleeping usb-hds
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm having a problem with kernels (x86_64) <=2.6.32-rc7 (that means all 
kernels I tried, including the latest stable 2.6.31.6) on a Gigabyte 
P55M-UD4 mb (Bios F4l) with an Intel Core i7 860 and sleeping usb-hds.

I don't have the problems when using the same usb-drives on a laptop 
with a core2duo (ICH8), so it seems to be a problem with the chipset 
(p55-express).

The problem seems to occur when the usb-drive goes to sleep (because of 
inactivity) and the kernel tries to access them afterwards.

Here are the excerpts from the log:

-------------------------------------------------------------------------
Nov 13 19:03:34 krabat kernel: [    0.000000] Linux version 2.6.32-rc7 
(root@krabat.ahsoftware) (gcc version 4.4.1 20090725 (Red Hat 4.4.1-2) 
(GCC) ) #1 SMP Fri Nov 13 19:01:02 CET 2009

...

(This warning seems to be unrelated, but I'm getting this too with every 
kernel I've tried, so I'm including it here)

Nov 13 19:03:34 krabat kernel: [    1.259269] cpuidle: using governor menu
Nov 13 19:03:34 krabat kernel: [    1.259274] ------------[ cut here 
]------------
Nov 13 19:03:34 krabat kernel: [    1.259278] WARNING: at 
arch/x86/kernel/hpet.c:390 hpet_next_event+0x68/0x80()
Nov 13 19:03:34 krabat kernel: [    1.259279] Hardware name: P55M-UD4
Nov 13 19:03:34 krabat kernel: [    1.259280] Modules linked in:
Nov 13 19:03:34 krabat kernel: [    1.259282] Pid: 0, comm: swapper Not 
tainted 2.6.32-rc7 #1
Nov 13 19:03:34 krabat kernel: [    1.259283] Call Trace:
Nov 13 19:03:34 krabat kernel: [    1.259287]  [<ffffffff8103b0a3>] ? 
warn_slowpath_common+0x73/0xb0
Nov 13 19:03:34 krabat kernel: [    1.259289]  [<ffffffff81025648>] ? 
hpet_next_event+0x68/0x80
Nov 13 19:03:34 krabat kernel: [    1.259292]  [<ffffffff8105de28>] ? 
tick_dev_program_event+0x38/0xc0
Nov 13 19:03:34 krabat kernel: [    1.259293]  [<ffffffff8105d7cd>] ? 
tick_broadcast_oneshot_control+0x10d/0x110
Nov 13 19:03:34 krabat kernel: [    1.259295]  [<ffffffff8105d05d>] ? 
tick_notify+0x31d/0x440
Nov 13 19:03:34 krabat kernel: [    1.259298]  [<ffffffff81055a37>] ? 
notifier_call_chain+0x37/0x70
Nov 13 19:03:34 krabat kernel: [    1.259299]  [<ffffffff8105c86b>] ? 
clockevents_notify+0x2b/0x90
Nov 13 19:03:34 krabat kernel: [    1.259303]  [<ffffffff812086b2>] ? 
acpi_idle_enter_bm+0x15e/0x2cc
Nov 13 19:03:34 krabat kernel: [    1.259306]  [<ffffffff8129727b>] ? 
cpuidle_idle_call+0x9b/0x110
Nov 13 19:03:34 krabat kernel: [    1.259308]  [<ffffffff8100a4dc>] ? 
cpu_idle+0x5c/0xb0
Nov 13 19:03:34 krabat kernel: [    1.259312] ---[ end trace 
a8b94b9411d73a80 ]---

...

(Here I have plugged in one of those discs)

Nov 13 19:04:07 krabat kernel: [   55.344953] usb 9-7: new high speed 
USB device using ehci_hcd and address 3
Nov 13 19:04:07 krabat kernel: [   55.491513] usb 9-7: New USB device 
found, idVendor=0bc2, idProduct=2100
Nov 13 19:04:07 krabat kernel: [   55.491517] usb 9-7: New USB device 
strings: Mfr=1, Product=2, SerialNumber=3
Nov 13 19:04:07 krabat kernel: [   55.491521] usb 9-7: Product: FreeAgent Go
Nov 13 19:04:07 krabat kernel: [   55.491523] usb 9-7: Manufacturer: Seagate
Nov 13 19:04:07 krabat kernel: [   55.491525] usb 9-7: SerialNumber: 
2GE1IXJ9
Nov 13 19:04:07 krabat kernel: [   55.491661] usb 9-7: configuration #1 
chosen from 1 choice
Nov 13 19:04:07 krabat kernel: [   55.544762] Initializing USB Mass 
Storage driver...
Nov 13 19:04:07 krabat kernel: [   55.545011] scsi6 : SCSI emulation for 
USB Mass Storage devices
Nov 13 19:04:07 krabat kernel: [   55.545348] usbcore: registered new 
interface driver usb-storage
Nov 13 19:04:07 krabat kernel: [   55.545520] USB Mass Storage support 
registered.
Nov 13 19:04:12 krabat kernel: [   60.533824] scsi 6:0:0:0: 
Direct-Access     Seagate  FreeAgent Go     102D PQ: 0 ANSI: 4
Nov 13 19:04:12 krabat kernel: [   60.534036] sd 6:0:0:0: Attached scsi 
generic sg1 type 0
Nov 13 19:04:12 krabat kernel: [   60.535901] sd 6:0:0:0: [sdb] 
976773168 512-byte logical blocks: (500 GB/465 GiB)
Nov 13 19:04:12 krabat kernel: [   60.537208] sd 6:0:0:0: [sdb] Write 
Protect is off
Nov 13 19:04:12 krabat kernel: [   60.537216] sd 6:0:0:0: [sdb] Assuming 
drive cache: write through
Nov 13 19:04:12 krabat kernel: [   60.540517] sd 6:0:0:0: [sdb] Assuming 
drive cache: write through
Nov 13 19:04:12 krabat kernel: [   60.540521]  sdb:
Nov 13 19:04:12 krabat kernel: [   60.778284]  sdb1 sdb2 sdb3
Nov 13 19:04:12 krabat kernel: [   60.781552] sd 6:0:0:0: [sdb] Assuming 
drive cache: write through
Nov 13 19:04:12 krabat kernel: [   60.781557] sd 6:0:0:0: [sdb] Attached 
SCSI disk

...

(And here comes the problem)

Nov 13 19:47:34 krabat kernel: [ 2655.981980] usb 9-7: reset high speed 
USB device using ehci_hcd and address 3
Nov 13 19:47:39 krabat kernel: [ 2661.120397] usb 9-7: device firmware 
changed
Nov 13 19:47:39 krabat kernel: [ 2661.120489] usb 9-7: USB disconnect, 
address 3
Nov 13 19:47:39 krabat kernel: [ 2661.120521] sd 6:0:0:0: Device 
offlined - not ready after error recovery
Nov 13 19:47:39 krabat kernel: [ 2661.120528] sd 6:0:0:0: [sdb] 
Unhandled error code
Nov 13 19:47:39 krabat kernel: [ 2661.120531] sd 6:0:0:0: [sdb] Result: 
hostbyte=DID_ABORT driverbyte=DRIVER_OK
Nov 13 19:47:39 krabat kernel: [ 2661.120536] sd 6:0:0:0: [sdb] CDB: 
Read(10): 28 00 03 04 7b da 00 00 10 00
Nov 13 19:47:39 krabat kernel: [ 2661.120546] end_request: I/O error, 
dev sdb, sector 50625498
Nov 13 19:47:39 krabat kernel: [ 2661.120555] sd 6:0:0:0: rejecting I/O 
to offline device
Nov 13 19:47:39 krabat kernel: [ 2661.120584] sd 6:0:0:0: [sdb] 
Unhandled error code
Nov 13 19:47:39 krabat kernel: [ 2661.120587] sd 6:0:0:0: [sdb] Result: 
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Nov 13 19:47:39 krabat kernel: [ 2661.120593] sd 6:0:0:0: [sdb] CDB: 
Read(10): 28 00 03 04 7b ea 00 00 f0 00
Nov 13 19:47:39 krabat kernel: [ 2661.120641] end_request: I/O error, 
dev sdb, sector 50625514
Nov 13 19:47:40 krabat kernel: [ 2661.371696] usb 9-7: new high speed 
USB device using ehci_hcd and address 5
Nov 13 19:47:41 krabat kernel: [ 2662.329564] EXT4-fs error (device 
dm-0): __ext4_get_inode_loc: unable to read inode block - inode=3250, 
block=1260
Nov 13 19:47:43 krabat kernel: [ 2664.658446] EXT4-fs error (device 
dm-0): __ext4_get_inode_loc: unable to read inode block - inode=7078109, 
block=28311597
Nov 13 19:47:44 krabat kernel: [ 2665.259794] __ratelimit: 126 callbacks 
suppressed
...
-------------------------------------------------------------------------

If someone needs a full log, logs with some debugging options turned on, 
or has some patches for me to test, just send me a mail.

Kind regards,

Alexander Holler
