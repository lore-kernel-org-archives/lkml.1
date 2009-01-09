Return-Path: <linux-kernel-owner+w=401wt.eu-S1756386AbZAIUoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbZAIUoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 15:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbZAIUoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 15:44:14 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:34712 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088AbZAIUoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 15:44:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=T31PieLuZcd49xQVU5pqKZiQH7gUE4DItBOi2Oaalj+9UMTXEY3pN1heqSz2dnijBL
         Hzk8Cwr0SxdFzmAo3D52sqi0fu0F6bZQybC2Rm2odM+N6IFJeyCWrfiDE1D/ae81xPwW
         xreKGbnRwdkrc5pJEf9njY3GUsthwuWe1/FCo=
Message-ID: <4967B6DD.9050705@googlemail.com>
Date: Fri, 09 Jan 2009 21:43:09 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081122)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: [usb-storage]: WARNING: at drivers/usb/storage/transport.c:584 last_sector_hacks+0x11d/0x190()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo,

Since commit 25ff1c316f6a763f1eefe7f8984b2d8c03888432 I get the following trace on my logs:

..

[   12.352477] usb-storage: device scan complete
[   12.353583] scsi 6:0:0:0: Direct-Access     Ut163    USB2FlashStorage 0.00 PQ: 0 ANSI: 2
[   12.360519] sd 6:0:0:0: Attached scsi generic sg4 type 0
[   12.361066] sd 6:0:0:0: [sdd] 1974271 512-byte hardware sectors: (1.01 GB/963 MiB)
[   12.371194] sd 6:0:0:0: [sdd] Write Protect is off
[   12.376659] sd 6:0:0:0: [sdd] Mode Sense: 00 00 00 00
[   12.376661] sd 6:0:0:0: [sdd] Assuming drive cache: write through
[   12.385072] sd 6:0:0:0: [sdd] 1974271 512-byte hardware sectors: (1.01 GB/963 MiB)
[   12.391068] sd 6:0:0:0: [sdd] Write Protect is off
[   12.396175] sd 6:0:0:0: [sdd] Mode Sense: 00 00 00 00
[   12.396177] sd 6:0:0:0: [sdd] Assuming drive cache: write through
[   12.401288]  sdd: sdd1
[   12.503047] sd 6:0:0:0: [sdd] Attached SCSI removable disk
[   12.640809] ------------[ cut here ]------------
[   12.646035] WARNING: at drivers/usb/storage/transport.c:584 last_sector_hacks+0x11d/0x190()
[   12.651323] Hardware name: P5E-VM DO
[   12.656585] sdd: Successful last sector success at 1974270, device 1307:0163:0100
[   12.661952] Modules linked in: fuse loop lp ppdev parport_pc joydev parport processor button pcspkr i2c_i801 evdev sg intel_agp
[   12.673052] Pid: 1194, comm: usb-storage Not tainted 2.6.28-07939-g2150edc #34
[   12.678627] Call Trace:
[   12.684040]  [<ffffffff8024c260>] warn_slowpath+0xd0/0x130
[   12.689408]  [<ffffffff80621e45>] ? schedule_timeout+0xb5/0xf0
[   12.694635]  [<ffffffff804d512e>] ? sg_clean+0x3e/0x80
[   12.699737]  [<ffffffff80623e19>] ? _spin_unlock_irq+0x9/0x50
[   12.704714]  [<ffffffff80620e5a>] ? wait_for_common+0xfa/0x170
[   12.709536]  [<ffffffff80247c80>] ? default_wake_function+0x0/0x10
[   12.714366]  [<ffffffff804f3136>] ? usb_stor_msg_common+0x126/0x180
[   12.719171]  [<ffffffff804f362c>] ? usb_stor_bulk_transfer_buf+0x8c/0xb0
[   12.719174]  [<ffffffff804f2f9d>] last_sector_hacks+0x11d/0x190
[   12.719176]  [<ffffffff804f3974>] usb_stor_invoke_transport+0x1e4/0x390
[   12.719178]  [<ffffffff80623e19>] ? _spin_unlock_irq+0x9/0x50
[   12.719181]  [<ffffffff80620e5a>] ? wait_for_common+0xfa/0x170
[   12.719183]  [<ffffffff80247c80>] ? default_wake_function+0x0/0x10
[   12.719186]  [<ffffffff804f2d19>] usb_stor_transparent_scsi_command+0x9/0x10
[   12.719188]  [<ffffffff804f51ef>] usb_stor_control_thread+0x13f/0x230
[   12.719191]  [<ffffffff804f50b0>] ? usb_stor_control_thread+0x0/0x230
[   12.719194]  [<ffffffff80263a19>] kthread+0x49/0x90
[   12.719196]  [<ffffffff8020da1a>] child_rip+0xa/0x20
[   12.719199]  [<ffffffff802639d0>] ? kthread+0x0/0x90
[   12.719200]  [<ffffffff8020da10>] ? child_rip+0x0/0x20
[   12.719202] ---[ end trace 1b5f08c07bcaea59 ]---


....


>From the commit log I see this is indeed but personally I think the WARN() is really not needed here
since is spamming the console for no reason. A friendly user message should do it here no ?

Something like :

$dev: Successful last sector success at xxxx, device xxxx
$dev: Your device may need an an unusual_devs entry , please contact <some mailing list>

( Also why don't you guys introduce some CONFIG_KERNELOOPS_ORG_REALLY_SPAM_ME and 
let the user or distros which are using kerneloops.org to decide whatever to enable or disable these warnings ? )


However while trying to add  an unusual_devs entry for my device I got the following error message when running lsusb -v -d the_device :

...

can't get device qualifier: Connection timed out
can't get debug descriptor: Connection timed out
cannot read device status, Connection timed out (110)
...

And in dmesg :

...

 1317.433117] usb 1-4: usbfs: USBDEVFS_CONTROL failed cmd lsusb rqt 128 rq 6 len 4 ret -110
[ 1322.433130] usb 1-4: usbfs: USBDEVFS_CONTROL failed cmd lsusb rqt 128 rq 0 len 2 ret -110
[ 2310.219145] usb 1-4: usbfs: USBDEVFS_CONTROL failed cmd lsusb rqt 128 rq 6 len 255 ret -110
[ 2311.219149] usb 1-4: usbfs: USBDEVFS_CONTROL failed cmd lsusb rqt 128 rq 6 len 255 ret -110
[ 2312.219144] usb 1-4: usbfs: USBDEVFS_CONTROL failed cmd lsusb rqt 128 rq 6 len 255 ret -110
[ 2317.219161] usb 1-4: usbfs: USBDEVFS_CONTROL failed cmd lsusb rqt 128 rq 6 len 10 ret -110
[ 2322.219047] usb 1-4: usbfs: USBDEVFS_CONTROL failed cmd lsusb rqt 128 rq 6 len 4 ret -110
[ 2327.219066] usb 1-4: usbfs: USBDEVFS_CONTROL failed cmd lsusb rqt 128 rq 0 len 2 ret -110
[ 2340.806018] usb 1-4: reset high speed USB device using ehci_hcd and address 2
[ 2340.920348] usb 1-4: device firmware changed
[ 2340.920368] usb 1-4: USB disconnect, address 2
[ 2340.920376] sd 6:0:0:0: Device offlined - not ready after error recovery
[ 2341.036024] usb 1-4: new high speed USB device using ehci_hcd and address 3
[ 2341.153472] usb 1-4: configuration #1 chosen from 1 choice
[ 2341.153730] scsi7 : SCSI emulation for USB Mass Storage devices
[ 2341.153808] usb-storage: device found at 3
[ 2341.153811] usb-storage: waiting for device to settle before scanning
[ 2346.153159] usb-storage: device scan complete
[ 2346.154269] scsi 7:0:0:0: Direct-Access     Ut163    USB2FlashStorage 0.00 PQ: 0 ANSI: 2
[ 2346.155235] sd 7:0:0:0: Attached scsi generic sg4 type 0
[ 2346.156002] sd 7:0:0:0: [sdd] 1974271 512-byte hardware sectors: (1.01 GB/963 MiB)
[ 2346.162519] sd 7:0:0:0: [sdd] Write Protect is off
[ 2346.162522] sd 7:0:0:0: [sdd] Mode Sense: 00 00 00 00
[ 2346.162524] sd 7:0:0:0: [sdd] Assuming drive cache: write through
[ 2346.165502] sd 7:0:0:0: [sdd] 1974271 512-byte hardware sectors: (1.01 GB/963 MiB)
[ 2346.166499] sd 7:0:0:0: [sdd] Write Protect is off
[ 2346.166501] sd 7:0:0:0: [sdd] Mode Sense: 00 00 00 00
[ 2346.166503] sd 7:0:0:0: [sdd] Assuming drive cache: write through
[ 2346.166506]  sdd: sdd1
[ 2346.268072] sd 7:0:0:0: [sdd] Attached SCSI removable disk
[ 2346.407115] ------------[ cut here ]------------
[ 2346.407119] WARNING: at drivers/usb/storage/transport.c:584 last_sector_hacks+0x11d/0x190()
[ 2346.407121] Hardware name: P5E-VM DO
[ 2346.407123] sdd: Successful last sector success at 1974270, device 1307:0163:0100
[ 2346.407124] Modules linked in: i915 binfmt_misc acpi_cpufreq freq_table w83627ehf hwmon_vid fuse loop lp ppdev parport_pc joydev parport processor button pcspkr i2c_i801 evdev sg intel_agp
[ 2346.407187] Pid: 13084, comm: usb-storage Tainted: G        W  2.6.28-07939-g2150edc #34
[ 2346.407195] Call Trace:
[ 2346.407206]  [<ffffffff8024c260>] warn_slowpath+0xd0/0x130
[ 2346.407216]  [<ffffffff80621e45>] ? schedule_timeout+0xb5/0xf0
[ 2346.407225]  [<ffffffff804d4693>] ? urb_destroy+0x23/0x30
[ 2346.407234]  [<ffffffff80623e19>] ? _spin_unlock_irq+0x9/0x50
[ 2346.407242]  [<ffffffff80620e5a>] ? wait_for_common+0xfa/0x170
[ 2346.407251]  [<ffffffff80247c80>] ? default_wake_function+0x0/0x10
[ 2346.407260]  [<ffffffff804f3136>] ? usb_stor_msg_common+0x126/0x180
[ 2346.407269]  [<ffffffff804f362c>] ? usb_stor_bulk_transfer_buf+0x8c/0xb0
[ 2346.407278]  [<ffffffff804f2f9d>] last_sector_hacks+0x11d/0x190
[ 2346.407288]  [<ffffffff804f3974>] usb_stor_invoke_transport+0x1e4/0x390
[ 2346.407298]  [<ffffffff80623e19>] ? _spin_unlock_irq+0x9/0x50
[ 2346.407307]  [<ffffffff80620e5a>] ? wait_for_common+0xfa/0x170
[ 2346.407317]  [<ffffffff80247c80>] ? default_wake_function+0x0/0x10
[ 2346.407326]  [<ffffffff804f2d19>] usb_stor_transparent_scsi_command+0x9/0x10
[ 2346.407336]  [<ffffffff804f51ef>] usb_stor_control_thread+0x13f/0x230
[ 2346.407346]  [<ffffffff804f50b0>] ? usb_stor_control_thread+0x0/0x230
[ 2346.407355]  [<ffffffff80263a19>] kthread+0x49/0x90
[ 2346.407364]  [<ffffffff8020da1a>] child_rip+0xa/0x20
[ 2346.407373]  [<ffffffff802639d0>] ? kthread+0x0/0x90
[ 2346.407379]  [<ffffffff8020da10>] ? child_rip+0x0/0x20
[ 2346.407381] ---[ end trace 1b5f08c07bcaea5a ]---
[ 2412.896338] FAT: utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[ 2422.169223] usb 1-4: usbfs: USBDEVFS_CONTROL failed cmd lsusb rqt 128 rq 6 len 4 ret -110
[ 2427.169483] usb 1-4: usbfs: USBDEVFS_CONTROL failed cmd lsusb rqt 128 rq 0 len 2 ret -110

...


This is probably some different bug / feature ? :)

Since I get now a bit confused about all this warnings , it is OK to add any entry for that device or it is broken ?


Best Regards,

Gabriel C


