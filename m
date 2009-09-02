Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbZIBN3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbZIBN3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 09:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbZIBN3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 09:29:48 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:42529 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZIBN3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:29:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=AM6i+ZQbnB8PbhwOz2x+Je4XIJ0y6P/Ieqq94gbfyHoHbvaWEdeogqoEqYQoqcMZEv
         dMiv7tUZywGNn4KuisWjOvOqXpmbIInUPD8yTs2u03IKEJS1qK2bVZ2e1Mn4GgL1gtbg
         +F+c4AYqgyAvfnHJr39qSa/mqhJZWMH7qUZfI=
MIME-Version: 1.0
Date: Wed, 2 Sep 2009 15:29:48 +0200
Message-ID: <8db1092f0909020629v5aab79d8lbfcc8c214622787c@mail.gmail.com>
Subject: [2.6.31-rc8] Problem with detect USB devices
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bad version: 2.6.31-rc8
Last known good: 2.6.31-rc7

Observed on two different machines. Upgraded Debian Testing.
udev 0.141-2
hal 0.5.12~git20090406.46dc48-2
usbutils 0.84-1

==============================

Descriptions:
1. When plug usb flash drive and turn on computer, device manager in
KDE4 show it, and I can mount. When remove device very often icon
doesn't dissapear - KDE doesn't refresh informaton about connected
devices. When connect again, I can't mount it.

2. Sometimes when I remove and connect device again, then is listed twice:
http://unixy.pl/maciek/download/kernel/2.6.31-rc8/zlom/snap1.jpg
http://unixy.pl/maciek/download/kernel/2.6.31-rc8/zlom/snap2.jpg

3. Plug in flash drive (a), then flash drive (b), remove (a or b),
remove (b or a), KDE still shows icons of flash drive (a/b)

4. Similar with USB printer

5. I this cases (1-4) lsusb doesn't show connected devices

6. VirtualBox also has similar problem connect with USB devices.

==============================

For example:
a) Connect flash drive, turn on computer (similar when plug device after boot):

maciek@zlom:~/Desktop$ lsusb
[...]
Bus 001 Device 002: ID 3538:0054 Power Quotient International Co., Ltd
Flash Drive (2GB)
[...]

b) Mount:

lshal:
15:12:56.866: volume_uuid_599D_1168 property volume.mount_point = '/media/pqi'
15:12:56.867: volume_uuid_599D_1168 property volume.is_mounted = true

c) Unmount:

lshal:
15:13:46.528: volume_uuid_599D_1168 property volume.mount_point = ''
15:13:46.529: volume_uuid_599D_1168 property volume.is_mounted = false

maciek@zlom:~/Desktop$ lsusb
[...]
Bus 001 Device 002: ID 3538:0054 Power Quotient International Co., Ltd
Flash Drive (2GB)
[...]

d) Remove device:

lshal:
<doesn't show anything>

KDE4 device manager still shows icon of flash drive

maciek@zlom:~/Desktop$ lsusb
Bus 005 Device 003: ID 062a:0201 Creative Labs Defender Office
Keyboard (K7310) S Zodiak KM-9010
Bus 005 Device 002: ID 1020:0206 Labtec
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

dmesg:
[  385.848532] usb 1-1: USB disconnect, address 2


e) Connect device:

lshal:
<doesn't show anything>

maciek@zlom:~/Desktop$ lsusb
Bus 005 Device 003: ID 062a:0201 Creative Labs Defender Office
Keyboard (K7310) S Zodiak KM-9010
Bus 005 Device 002: ID 1020:0206 Labtec
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
(can't see flash drive)

dmesg:
[  483.727044] usb 1-1: new high speed USB device using ehci_hcd and address 5
[  483.843749] usb 1-1: configuration #1 chosen from 1 choice
[  483.844012] scsi5 : SCSI emulation for USB Mass Storage devices
[  483.844222] usb-storage: device found at 5
[  483.844225] usb-storage: waiting for device to settle before scanning
[  488.845138] scsi 5:0:0:0: Direct-Access     pqi
IntelligentStick 0.00 PQ: 0 ANSI: 2
[  488.845354] sd 5:0:0:0: Attached scsi generic sg2 type 0
[  488.846588] usb-storage: device scan complete
[  488.846621] sd 5:0:0:0: [sdb] 2015231 512-byte logical blocks:
(1.03 GB/983 MiB)
[  488.847350] sd 5:0:0:0: [sdb] Write Protect is off
[  488.847355] sd 5:0:0:0: [sdb] Mode Sense: 00 00 00 00
[  488.847359] sd 5:0:0:0: [sdb] Assuming drive cache: write through
[  488.850727] sd 5:0:0:0: [sdb] Assuming drive cache: write through
[  488.850733]  sdb: sdb1
[  488.960371] sd 5:0:0:0: [sdb] Assuming drive cache: write through
[  488.960377] sd 5:0:0:0: [sdb] Attached SCSI removable disk

==============================

I try bisect, but I'm not sure that results is good:

root@zlom:/usr/src/git/linux-2.6# git bisect good
1e23502cc57cef33455ac7cb9111e3c6d991a894 is first bad commit
root@zlom:/usr/src/git/linux-2.6# git show
1e23502cc57cef33455ac7cb9111e3c6d991a894
commit 1e23502cc57cef33455ac7cb9111e3c6d991a894
Merge: e99b1f2 3161e45
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Aug 26 20:54:48 2009 -0700

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6

    * git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6:
      virtio: net refill on out-of-memory
      smc91x: fix compilation on SMP

Config:
http://unixy.pl/maciek/download/kernel/2.6.31-rc8/zlom/config-2.6.31-rc8
dmesg:
http://unixy.pl/maciek/download/kernel/2.6.31-rc8/zlom/dmesg-2.6.31-rc8.txt

I have no idea, how debug it. Any help?

Regards

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
