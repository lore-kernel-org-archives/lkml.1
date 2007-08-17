Return-Path: <linux-kernel-owner+w=401wt.eu-S932866AbXHQCdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbXHQCdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 22:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762817AbXHQCdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 22:33:42 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:49016 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476AbXHQCdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 22:33:41 -0400
Message-ID: <46C50902.4000502@lwfinger.net>
Date: Thu, 16 Aug 2007 21:33:38 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Need help with modules loading
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A new driver for the Broadcom BCM43xx devices has been written that uses mac80211, rather than 
softmac. The newest versions of the Broadcom firmware does not support all the BCM devices. 
Accordingly, a separate driver is being prepared that will use an older version of the firmware and 
support these legacy devices. Unfortunately, there is not a clean separation based on PCI id's; 
however, the revision level of the 802.11 wireless core can be used to determine which driver should 
be used. The scheme works on most systems, but not mine and I need some help to discover why.

The ssb driver handles the interaction between an internal bus in the device and the PCIe interface 
in my HP dv2125nr notebook. When this driver is loaded, the output of 'udevmonitor --env' is as follows:

UEVENT[1187314028.568540] add      /module/ssb (module)
ACTION=add
DEVPATH=/module/ssb
SUBSYSTEM=module
SEQNUM=1749

UEVENT[1187314028.571360] add      /bus/ssb (bus)
ACTION=add
DEVPATH=/bus/ssb
SUBSYSTEM=bus
SEQNUM=1750

UEVENT[1187314028.571635] add      /bus/pci/drivers/b43-pci-bridge (drivers)
ACTION=add
DEVPATH=/bus/pci/drivers/b43-pci-bridge
SUBSYSTEM=drivers
SEQNUM=1751

UDEV  [1187314028.579067] add      /module/ssb (module)
UDEV_LOG=3
ACTION=add
DEVPATH=/module/ssb
SUBSYSTEM=module
SEQNUM=1749
UDEVD_EVENT=1

UDEV  [1187314028.583959] add      /bus/pci/drivers/b43-pci-bridge (drivers)
UDEV_LOG=3
ACTION=add
DEVPATH=/bus/pci/drivers/b43-pci-bridge
SUBSYSTEM=drivers
SEQNUM=1751
UDEVD_EVENT=1

UDEV  [1187314028.584452] add      /bus/ssb (bus)
UDEV_LOG=3
ACTION=add
DEVPATH=/bus/ssb
SUBSYSTEM=bus
SEQNUM=1750
UDEVD_EVENT=1

UEVENT[1187314028.644176] add      /devices/pci0000:00/0000:00:02.0/0000:01:00.0/ssb0:0 (ssb)
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:02.0/0000:01:00.0/ssb0:0
SUBSYSTEM=ssb
SEQNUM=1752
PHYSDEVBUS=ssb
MODALIAS=ssb:v4243id0812rev0A

UEVENT[1187314028.645471] add      /devices/pci0000:00/0000:00:02.0/0000:01:00.0/ssb0:1 (ssb)
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:02.0/0000:01:00.0/ssb0:1
SUBSYSTEM=ssb
SEQNUM=1753
PHYSDEVBUS=ssb
MODALIAS=ssb:v4243id0817rev03

UDEV  [1187314028.656957] add      /devices/pci0000:00/0000:00:02.0/0000:01:00.0/ssb0:1 (ssb)
UDEV_LOG=3
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:02.0/0000:01:00.0/ssb0:1
SUBSYSTEM=ssb
SEQNUM=1753
PHYSDEVBUS=ssb
MODALIAS=ssb:v4243id0817rev03
UDEVD_EVENT=1

UDEV  [1187314028.662723] add      /devices/pci0000:00/0000:00:02.0/0000:01:00.0/ssb0:0 (ssb)
UDEV_LOG=3
ACTION=add
DEVPATH=/devices/pci0000:00/0000:00:02.0/0000:01:00.0/ssb0:0
SUBSYSTEM=ssb
SEQNUM=1752
PHYSDEVBUS=ssb
MODALIAS=ssb:v4243id0812rev0A
UDEVD_EVENT=1

The 'MODALIAS=ssb:v4243id0812rev0A' line is correct for my device. In fact issuing a modprobe 
"ssb:v4243id0812rev0A" command results in the loading of the module. For some reason, this does not 
happen automatically.

Initially, I suspected that my version of udev (103-13) was too old; however, upgrading to version 
114 did not help. My module-init-tools are V 3.2.2 and my distro is the x86_64 version of openSUSE 10.2.

I would appreciate any suggestions on how to chase down this problem.

Thanks,

Larry



