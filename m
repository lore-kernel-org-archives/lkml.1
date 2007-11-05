Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbXKEU4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbXKEU4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 15:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbXKEUz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 15:55:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36773 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbXKEUz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 15:55:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: b43 on HP nx6325 w/ openSUSE 10.3 (x86_64)
Date: Mon, 5 Nov 2007 22:13:02 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Stefano Brivio <stefano.brivio@polimi.it>
References: <200711050113.55591.rjw@sisk.pl> <472E663F.9040501@lwfinger.net>
In-Reply-To: <472E663F.9040501@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711052213.03362.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 5 of November 2007, Larry Finger wrote:
> Rafael J. Wysocki wrote:
> > Hi,
> > 
> > I'm trying to make the b43 driver work on an HP nx6325 with openSUSE 10.3
> > (64-bit).  In short, it sort of works, but some things are a bit ugly.
> > 
> > The kernel is the current -git (approx. 2.6.24-rc1-git13) with the following
> > extra patches applied:
> > 
> > b43: Fix rfkill callback deadlock
> > b43: debugfs SHM read buffer overrun fix
> > b43: Rewrite and fix rfkill init
> > 
> > and I'm using the firmware from
> > http://downloads.openwrt.org/sources/broadcom-wl-4.80.53.0.tar.bz2
> > 
> > Here's the debug info from dmesg:
> > 
> > b43-phy1: Broadcom 4311 WLAN found
> > b43-phy1 debug: Found PHY: Analog 4, Type 2, Revision 8
> > b43-phy1 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2
> > b43-phy1 debug: Loading firmware version 351.126 (2006-07-29 05:54:02)
> > Registered led device: b43-phy1:tx
> > Registered led device: b43-phy1:rx
> > b43-phy1 debug: Chip initialized
> > b43-phy1 debug: 32-bit DMA initialized
> > b43-phy1 debug: Wireless interface started
> > b43-phy1 debug: Adding Interface type 2
> > 
> > Now, the first problem is that the card seems to lose frames from time to
> > time.  This is visible in the output of mtr and while trying to transfer large
> > files using scp.  With scp the transfer just stalls and stays this way although
> > the other end is pingable etc. (eg. attempting to transfer more than 400 MB at
> > once triggers this 100% of the time).
> > 
> > If you can suggest some more specific tests to me, I'll run them and report
> > back.
> > 
> > The second problem is that YaST is apparently unable to detect the device,
> > which sort of sucks, because it leads to configuration problems (basically, you
> > need to set up everything manually).  Evidently, udev manages to handle it, so
> > this may be related to HAL.  Anyway, it looks like the problem is related to
> > the fact that the device is not present under /sys/bus/pci/devices/ directly,
> > but you need to go through the ssb0:0 subdirectory to get to it.
> > 
> > Do you have any ideas how to tell the user space stuff where the devices is
> > in sysfs?
> 
> Your configuration is exactly like mine - openSUSE 10.3, x86_64 with Linus's latest git, and a 4311.
>  I have not used mtr or scp and cannot comment on your transfer problems.

That may be AP-related, but I had no such problems with the bcm43xx used
previously on the same hardware w/ the same AP.

> I have had 0 problems configuring the device with YaST.

Hm, I wonder what I've done wrong, then. :-)

Can you send me /etc/sysconfig/network/ifcfg-wlan0 (or whatever the card is
visible as on your system) from the x86_64 laptop?

> On the x86_64 laptop, I let NetworkManager control the wireless 
> connection, but I have also used the traditional ifup/ifdown method. On an i386 system, I use
> ifup/ifdown as I don't run X on that machine. Both make fast connections.

Well, finally I did configure the card with YaST, but I had to manually add it
to the list.  ifup/ifdown works, but I haven't tried NetworkManager yet.

Greetings,
Rafael
