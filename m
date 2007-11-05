Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbXKDX5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbXKDX5G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 18:57:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbXKDX4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 18:56:55 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33080 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbXKDX4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 18:56:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: bcm43xx-dev@lists.berlios.de
Subject: b43 on HP nx6325 w/ openSUSE 10.3 (x86_64)
Date: Mon, 5 Nov 2007 01:13:54 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Michael Buesch <mb@bu3sch.de>, LKML <linux-kernel@vger.kernel.org>,
       Larry Finger <larry.finger@lwfinger.net>,
       Stefano Brivio <stefano.brivio@polimi.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711050113.55591.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to make the b43 driver work on an HP nx6325 with openSUSE 10.3
(64-bit).  In short, it sort of works, but some things are a bit ugly.

The kernel is the current -git (approx. 2.6.24-rc1-git13) with the following
extra patches applied:

b43: Fix rfkill callback deadlock
b43: debugfs SHM read buffer overrun fix
b43: Rewrite and fix rfkill init

and I'm using the firmware from
http://downloads.openwrt.org/sources/broadcom-wl-4.80.53.0.tar.bz2

Here's the debug info from dmesg:

b43-phy1: Broadcom 4311 WLAN found
b43-phy1 debug: Found PHY: Analog 4, Type 2, Revision 8
b43-phy1 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
b43-phy1 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
Registered led device: b43-phy1:tx
Registered led device: b43-phy1:rx
b43-phy1 debug: Chip initialized
b43-phy1 debug: 32-bit DMA initialized
b43-phy1 debug: Wireless interface started
b43-phy1 debug: Adding Interface type 2

Now, the first problem is that the card seems to lose frames from time to
time.  This is visible in the output of mtr and while trying to transfer large
files using scp.  With scp the transfer just stalls and stays this way although
the other end is pingable etc. (eg. attempting to transfer more than 400 MB at
once triggers this 100% of the time).

If you can suggest some more specific tests to me, I'll run them and report
back.

The second problem is that YaST is apparently unable to detect the device,
which sort of sucks, because it leads to configuration problems (basically, you
need to set up everything manually).  Evidently, udev manages to handle it, so
this may be related to HAL.  Anyway, it looks like the problem is related to
the fact that the device is not present under /sys/bus/pci/devices/ directly,
but you need to go through the ssb0:0 subdirectory to get to it.

Do you have any ideas how to tell the user space stuff where the devices is
in sysfs?

Greetings,
Rafael
