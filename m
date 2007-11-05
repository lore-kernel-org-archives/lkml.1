Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbXKEAji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbXKEAji (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 19:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbXKEAja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 19:39:30 -0500
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:58670 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751480AbXKEAj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 19:39:29 -0500
Message-ID: <472E663F.9040501@lwfinger.net>
Date: Sun, 04 Nov 2007 18:39:27 -0600
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: b43 on HP nx6325 w/ openSUSE 10.3 (x86_64)
References: <200711050113.55591.rjw@sisk.pl>
In-Reply-To: <200711050113.55591.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Hi,
> 
> I'm trying to make the b43 driver work on an HP nx6325 with openSUSE 10.3
> (64-bit).  In short, it sort of works, but some things are a bit ugly.
> 
> The kernel is the current -git (approx. 2.6.24-rc1-git13) with the following
> extra patches applied:
> 
> b43: Fix rfkill callback deadlock
> b43: debugfs SHM read buffer overrun fix
> b43: Rewrite and fix rfkill init
> 
> and I'm using the firmware from
> http://downloads.openwrt.org/sources/broadcom-wl-4.80.53.0.tar.bz2
> 
> Here's the debug info from dmesg:
> 
> b43-phy1: Broadcom 4311 WLAN found
> b43-phy1 debug: Found PHY: Analog 4, Type 2, Revision 8
> b43-phy1 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
> b43-phy1 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
> Registered led device: b43-phy1:tx
> Registered led device: b43-phy1:rx
> b43-phy1 debug: Chip initialized
> b43-phy1 debug: 32-bit DMA initialized
> b43-phy1 debug: Wireless interface started
> b43-phy1 debug: Adding Interface type 2
> 
> Now, the first problem is that the card seems to lose frames from time to
> time.  This is visible in the output of mtr and while trying to transfer large
> files using scp.  With scp the transfer just stalls and stays this way although
> the other end is pingable etc. (eg. attempting to transfer more than 400 MB at
> once triggers this 100% of the time).
> 
> If you can suggest some more specific tests to me, I'll run them and report
> back.
> 
> The second problem is that YaST is apparently unable to detect the device,
> which sort of sucks, because it leads to configuration problems (basically, you
> need to set up everything manually).  Evidently, udev manages to handle it, so
> this may be related to HAL.  Anyway, it looks like the problem is related to
> the fact that the device is not present under /sys/bus/pci/devices/ directly,
> but you need to go through the ssb0:0 subdirectory to get to it.
> 
> Do you have any ideas how to tell the user space stuff where the devices is
> in sysfs?

Your configuration is exactly like mine - openSUSE 10.3, x86_64 with Linus's latest git, and a 4311.
 I have not used mtr or scp and cannot comment on your transfer problems. I have had 0 problems
configuring the device with YaST. On the x86_64 laptop, I let NetworkManager control the wireless
connection, but I have also used the traditional ifup/ifdown method. On an i386 system, I use
ifup/ifdown as I don't run X on that machine. Both make fast connections.

Larry
