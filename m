Return-Path: <linux-kernel-owner+w=401wt.eu-S1759114AbYAJIyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114AbYAJIyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 03:54:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbYAJIx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 03:53:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:44280 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbYAJIx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 03:53:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,265,1196668800"; 
   d="scan'208";a="282646419"
Subject: Re: [PATCH] ACPI: Add sysfs interface for acpi device wakeup
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
       acpi-bugzilla@lists.sourceforge.net
In-Reply-To: <200801100943.08780.maximlevitsky@gmail.com>
References: <1198738022.8950.3.camel@yangyi-dev.bj.intel.com>
	 <1199688961.3551.19.camel@yangyi-dev.bj.intel.com>
	 <1199917306.9596.3.camel@yangyi-dev.bj.intel.com>
	 <200801100943.08780.maximlevitsky@gmail.com>
Content-Type: text/plain
Organization: Intel
Date: Thu, 10 Jan 2008 07:59:36 +0800
Message-Id: <1199923176.3827.13.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-01-10 at 09:43 +0200, Maxim Levitsky wrote:
> On Thursday, 10 January 2008 00:21:46 Yi Yang wrote:
> > Subject: ACPI: convert procfs to sysfs for /proc/acpi/wakeup
> > From: Yi Yang <yi.y.yang@intel.com>
> > 
> > /proc/acpi/wakeup is deprecated but it has to exist because
> > we haven't a sysfs interface to replace it yet, this patch
> > converts /proc/acpi/wakeup to sysfs interface, under every
> > acpi device sysfs node, a user can see a directory "wakeup"
> > if the acpi device can support wakeup, there are six files
> > under this directory:
> > 
> > acpi_bus_id  bus_id  pci_id  run_wakeup  sleep_state  status
> > 
> > All the files are read-only exclude "status" which is used
> > to enable or disable wakeup of the acpi device.
> > 
> > "acpi_bus_id" is acpi bus ID of the acpi device.
> > 
> > "bus_id" is pci bus id of the device associated to the acpi
> > device, it will be empty if there isn't any device associated
> > to it.
> > 
> > "pci_id" is PCI ID of the pci device associated to the acpi
> > device, it will be empty if there isn't any device associated
> > to it.
> > 
> > "run_wake" is a flag indicating if a wakeup process is being
> > handled.
> > 
> > "sleep_state" is sleep state of the acpi device such as "S0".
> > 
> > "status" is wakeup status of the acpi device, it is enabled
> > or disabled, a user can change it be echoing "0", "1",
> > "disabled" or "enabled" to /sys/devices/.../wakeup/status. 
> > 
> > Here is the test result:
> > 
> > [root@localhost ~]# cat /proc/acpi/wakeup
> > Device  S-state   Status   Sysfs node           PCI ID
> > C093      S5     disabled  pci:0000:00:1e.0     0x2448
> > C0E8      S3     disabled  pci:0000:00:1d.0     0x27c8
> > C0EF      S3     disabled  pci:0000:00:1d.1     0x27c9
> > C0F0      S3     disabled  pci:0000:00:1d.2     0x27ca
> > C0F1      S3     disabled  pci:0000:00:1d.3     0x27cb
> > C0F2      S3     disabled  pci:0000:00:1d.7     0x27cc
> > C0F9      S0     disabled  pci:0000:00:1c.0     0x27d0
> > C21D      S0     disabled  pci:0000:08:00.0     0x16fd
> > C109      S5     disabled  pci:0000:00:1c.1     0x27d2
> > C228      S5     disabled  pci:0000:10:00.0     0x4222
> > C10F      S5     disabled  pci:0000:00:1c.3     0x27d6
> > C229      S5     disabled
> > [root@localhost ~]# find /sys -name "*" | grep sleep_state
> > /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:05/wakeup/sleep_state
> > /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0d/wakeup/sleep_state
> > /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:11/wakeup/sleep_state
> > /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:15/wakeup/sleep_state
> > /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:19/wakeup/sleep_state
> > /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:1d/wakeup/sleep_state
> > /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2b/wakeup/sleep_state
> > /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2b/device:2c/wakeup/sleep_state
> > /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2d/wakeup/sleep_state
> > /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2d/device:2e/wakeup/sleep_state
> > /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/wakeup/sleep_state
> > /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/wakeup/sleep_state
> > [root@localhost ~]# ls /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/wakeup
> > acpi_bus_id  bus_id  pci_id  run_wakeup  sleep_state  status
> > [root@localhost ~]# cat /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/acpi_bus_id
> > cat: /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/acpi_bus_id: No such file or directory
> > [root@localhost ~]# cat /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/wakeup/acpi_bus_id
> > C229
> > [root@localhost ~]# cat /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/wakeup/sleep_state
> > S5
> > [root@localhost ~]# cat /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/wakeup/status
> > disabled
> > [root@localhost ~]# cat /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/wakeup/bus_id
> > 
> > [root@localhost ~]# cat /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/wakeup/pci_id
> > 
> > [root@localhost ~]# echo 1 > /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/wakeup/status
> > [root@localhost ~]# cat /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:2f/device:30/wakeup/status
> > enabled
> > [root@localhost ~]# cat /proc/acpi/wakeup
> > Device  S-state   Status   Sysfs node           PCI ID
> > C093      S5     disabled  pci:0000:00:1e.0     0x2448
> > C0E8      S3     disabled  pci:0000:00:1d.0     0x27c8
> > C0EF      S3     disabled  pci:0000:00:1d.1     0x27c9
> > C0F0      S3     disabled  pci:0000:00:1d.2     0x27ca
> > C0F1      S3     disabled  pci:0000:00:1d.3     0x27cb
> > C0F2      S3     disabled  pci:0000:00:1d.7     0x27cc
> > C0F9      S0     enabled   pci:0000:00:1c.0     0x27d0
> > C21D      S0     enabled   pci:0000:08:00.0     0x16fd
> > C109      S5     enabled   pci:0000:00:1c.1     0x27d2
> > C228      S5     enabled   pci:0000:10:00.0     0x4222
> > C10F      S5     enabled   pci:0000:00:1c.3     0x27d6
> > C229      S5     enabled
> > [root@localhost ~]# vi /var/log/dmesg
> > [root@localhost ~]# dmesg | grep "same GPE"
> > ACPI: 'C0F9' and 'C229' have the same GPE, can't disable/enable one seperately
> > ACPI: 'C21D' and 'C229' have the same GPE, can't disable/enable one seperately
> > ACPI: 'C109' and 'C229' have the same GPE, can't disable/enable one seperately
> > ACPI: 'C228' and 'C229' have the same GPE, can't disable/enable one seperately
> > ACPI: 'C10F' and 'C229' have the same GPE, can't disable/enable one seperately
> > [root@localhost ~]# cat /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/*/wakeup/status
> > disabled
> > disabled
> > disabled
> > disabled
> > disabled
> > disabled
> > enabled
> > enabled
> > enabled
> > [root@localhost ~]# cat /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/*/*/wakeup/status
> > enabled
> > enabled
> > enabled
> > [root@localhost ~]#
> 
> 
> I think that it would be much much better to place wake-up attributes under
> corresponding PCI and PNP devices.
Currently, all devices have had an wakeup attribute, it
is /sys/.../power/wakeup, for example:

/sys/devices/pci0000\:00/0000\:00\:00.0/power/wakeup
/sys/class/tty/console/power/wakeup

But it isn't the same as acpi device's, you can get all acpi devices
with wakeup features from /proc/acpi/wakeup, you can also get all the
"power/wakeup" from /sys, they aren't 1:1.

[yangyi@yangyi-dev ~]$ cat /proc/acpi/wakeup 
Device  S-state   Status   Sysfs node           PCI ID
SLPB      S4    *enabled   
P32       S4     disabled  pci:0000:00:1e.0     0x244e
UAR1      S4     disabled  pnp:00:09            0x0000
ILAN      S4     disabled  pci:0000:00:19.0     0x104b
PEGP      S4     disabled  pci:0000:00:01.0     0x29a1
PEX0      S4     disabled  pci:0000:00:1c.0     0x283f
PEX1      S4     disabled  pci:0000:00:1c.1     0x2841
PEX2      S4     disabled  pci:0000:00:1c.2     0x2843
PEX3      S4     disabled  pci:0000:00:1c.3     0x2845
PEX4      S4     disabled  pci:0000:00:1c.4     0x2847
PEX5      S4     disabled  
UHC1      S3     disabled  pci:0000:00:1d.0     0x2830
UHC2      S3     disabled  pci:0000:00:1d.1     0x2831
UHC3      S3     disabled  pci:0000:00:1d.2     0x2832
UHC4      S3     disabled  
EHCI      S3     disabled  pci:0000:00:1d.7     0x2836
EHC2      S3     disabled  pci:0000:00:1a.7     0x283a
UH42      S3     disabled  pci:0000:00:1a.0     0x2834
UHC5      S3     disabled  pci:0000:00:1a.1     0x2835
AZAL      S3     disabled  pci:0000:00:1b.0     0x284b
[yangyi@yangyi-dev ~]$ /home/yangyi/wakeup.sh 
/sys/devices/pci0000:00/0000:00:1a.0/usb1/power/wakeup
enabled
/sys/devices/pci0000:00/0000:00:1a.0/usb1/1-1/power/wakeup
enabled
/sys/devices/pci0000:00/0000:00:1a.1/usb2/power/wakeup
enabled
/sys/devices/pci0000:00/0000:00:1a.7/power/wakeup
enabled
/sys/devices/pci0000:00/0000:00:1a.7/usb6/power/wakeup
enabled
/sys/devices/pci0000:00/0000:00:1d.0/usb3/power/wakeup
enabled
/sys/devices/pci0000:00/0000:00:1d.0/usb3/3-2/power/wakeup
enabled
/sys/devices/pci0000:00/0000:00:1d.1/usb4/power/wakeup
enabled
/sys/devices/pci0000:00/0000:00:1d.2/usb5/power/wakeup
enabled
/sys/devices/pci0000:00/0000:00:1d.7/power/wakeup
enabled
/sys/devices/pci0000:00/0000:00:1d.7/usb7/power/wakeup
enabled
/sys/class/tty/ttyS0/power/wakeup
disabled
/sys/class/tty/ttyS1/power/wakeup
disabled
/sys/class/tty/ttyS2/power/wakeup
disabled
/sys/class/tty/ttyS3/power/wakeup
disabled
[yangyi@yangyi-dev ~]$

>From source code, it seems they are different things.

> 
> Probably it is even better to link this code to PCI code, so PCI drivers will be aware of ACPI.
> For example it will fix the 'EHCI instantly wakes up the system from S4' on my system, since here USB doesn't wake
> up anything from S4, and ACPI tables correctly show that.
> 
> If ehci driver was aware of that it could disable #PME on entrance to S4.
> And we even can reuse its 'wakeup' attribute, thus enabling wakeup automatically.
> 
> Going ever further, I think that it will be great to get rid of ACPI device tree, since
> most acpi devices are ether PCI of PNP ones.
> 
> Or, even better have a small ACPI tree, that will contain 'true' ACPI devices, like cpus
> thermal sensors, buttons, etc. 
Maybe this is a good idea, but i don't know the relationships between
acpi devices, devices, pci devices and pnp devices. If we can merge all
these things together, that will be a great job.
> 
> Best regards,
> 	Maxim Levitsky

