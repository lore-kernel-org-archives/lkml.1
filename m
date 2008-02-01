Return-Path: <linux-kernel-owner+w=401wt.eu-S1762256AbYBAXp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762256AbYBAXp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 18:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758211AbYBAXpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 18:45:51 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:60729 "EHLO
	outbound1-va3-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757722AbYBAXpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 18:45:49 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <47A3AF1E.5040308@am.sony.com>
Date: Fri, 01 Feb 2008 15:45:34 -0800
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>
Subject: [announce] PS3 Linux Distributor's Starter Kit (v1.6) released
References: <4581CA0C.20102@am.sony.com>
In-Reply-To: <4581CA0C.20102@am.sony.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Feb 2008 23:45:34.0757 (UTC) FILETIME=[89F52550:01C8652C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An updated PS3 Linux Distributor's Starter Kit (v1.6) was released.

The CD-ROM iso image is here (171 MiB):

  ftp://ftp.infradead.org/pub/Sony-PS3/CELL-Linux-CL_20080201-ADDON.iso
  http://ftp.uk.linux.org/pub/linux/Sony-PS3/CELL-Linux-CL_20080201-ADDON.iso

I extracted files are here for convenient browsing:

  http://www.kernel.org/pub/linux/kernel/people/geoff/cell/CELL-Linux-CL_20080201-ADDON

An updated kboot binary image is here (2.3 MiB):

 http://www.kernel.org/pub/linux/kernel/people/geoff/cell/kboot-20080201.bld

A Changes List follows. 

-Geoff

---

v1.6 (2008/02/01 version)

 ALL

  o Following specs are changed

    - Update Linux kernel version to 2.6.24. This kernel is build from 
      http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.24.tar.bz2 and
      additional PS3 patches. Please refer 'patches' directory in 
      'src/linux-2.6.24-20080131.tar.bz2' for details.

    - Update perfmon2 to latest version

    - Update PS3 utility to latest version

    - Update kexec tools to latest version

    - Support WPA2 access points. PS3 system software version 2.10
      or later required.


 Kboot

  o Following spec are changed

    - Update Linux kernel version to 2.6.24

    - Update PS3 utility/kexec tools to latest version


 Linux Kernel

 o Following specs are changed

    - Wireless support driver for PS3 reimplemented.  The wireless and 
      wired network can be used simultenously.  The wired ethernet
      surves eth0 and the wireless does eth1.  As both interfaces share
      one MAC address, do not connect them into same network segment.


 Library/Commands

    - Commands for perfmon2 are updated to the latest version

    - Kexec tools is updated to the latest version

    - PS3 utility is updated.  Major changes are as follows:

      * A new helper script ps3-dump-bootloader to dump or check the md5sum of the
        bootloader image in flash memory.
      * A new helper script ps3-rtc-init to set the Linux RTC value to that currently
        used by the Game OS.
      * New or updated man pages for all the utilities.
      * Changed the libps3-utils license of from LGPL to GPL + runtime exceptions.
        See the text in lib/flash.h for details.
      * libps3-utils is now -version-info 2:0:0.
      * Added new ps3-boot-game-os options --no-reboot and --poweroff.
      * Added long option support to ps3-flash-util.
      * Added new ps3-flash-util option --game-time.
      * Changed some ps3-flash-util output for easier text parsing.
      * ps3-video-mode option -v and --video depreciated.  Use option -m or --mode.
      * ps3-video-mode option --full changed to --full-screen.
      * ps3-video-mode option --color changed to --full-range to match Game OS
        nomenclature of rgb full range.
      * ps3-video-mode option -c (rgb full range) changed to -g.
      * Re-worked ps3-utils.spec to support ppc and ppc64 builds of packages
        ps3-utils, ps3-utils-libs, ps3-utils-libs-devel.
   
      Refer the document 'Platform Specific Utilites' for details.

    - The wireless network can be controlled via the wpa_supplicant userland
      tool.  The wpa_suppclicant which this kit contains is configured
      only to support the PS3 wireless.

      The wireless will not be brought up by default after the
      installation of this kit.  To enable, some configurations needed like
      the followings:

        1. Configure /etc/wpa_supplicant/wpa_supplicant.conf for your
           network.  To see whether your configuration can work, do the
           followings.

           # /usr/sbin/wpa_supplicant -D ps3 -i eth1 -c /etc/wpa_supplicant/wpa_supplicant -B
           # /sbin/ifconfig eth1 XXX.XXX.XXX.XXX
           # ping YYY.YYY.YYY.YYY

        2. Enable the startup script if you want to bring up the wireless
           at boot time.
   
           # chkconfig --level 35 wpa_supplicant on

        3. Configure the network setting for eth1.  If you want to get the
           IP address from your DHCP server, like the followings:

           # cat /etc/sysconfig/network-scripts/ifcfg-eth1
           DEVICE=eth1
           ONBOOT=yes
           BOOTPROTO=dhcp
           TYPE=Ethernet

        4. See the wireless network works after reboot.


 Documents

    - "Chapter 4: Advanced Cell Programming" is added to Cell
      Programming Primer

    - Wireless extension for GbE section of Linux Kernel Overview is
      updated

    - The descriptions for ps3-dump-bootloader and ps3-rtc-init command
      are added to Platform Specific Utilities.

    - "How to Use Linux on PS3 Linux" and "How to Enable Your Distro"
       are updated.

-EOF



