Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbXEWCfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbXEWCfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 22:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbXEWCfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 22:35:10 -0400
Received: from relay01.pair.com ([209.68.5.15]:2595 "HELO relay01.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754397AbXEWCfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 22:35:09 -0400
X-pair-Authenticated: 24.241.238.207
Message-ID: <4653A85A.3030305@cybsft.com>
Date: Tue, 22 May 2007 21:35:06 -0500
From: "K.R. Foley" <kr@cybsft.com>
Organization: Cybersoft Solutions, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: roland <devzero@web.de>
CC: linux-kernel@vger.kernel.org, tilman@imap.cc, mailinglist@promodata.de
Subject: Re: Problem with 2.6.20 based kernels on SUSE 9.3
References: <003701c76e14$e68007a0$eeeea8c0@aldipc>
In-Reply-To: <003701c76e14$e68007a0$eeeea8c0@aldipc>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry it has taken me so long to get back to this. I did finally make
some time to dig into this more.

roland wrote:
>> Waiting for mandatory devices:  eth-id-00:01:6c:ad:2b:c9
>> 19 18 17 16 15 14 13 12 11 10 9 8 7 6 5 4 3 1 0
>>    eth-id-00:01:6c:ad:2b:c9            No interface found
>> failedSetting up service network  .  .  .  .  .  .  .
> 
> I had such issues when using suse 9.3  inside vmware very often -
> typically removing network configuration completely in yast and
> re-adding it fixed it for me - but sometimes it re-appeared, though -
> and i never knew, why.
> 
> Due to lack of time, i never dug into the device detection routines in
> depth, but i assume there must be some issue in older suse with that
> routines around "Waiting for mandatory devices" .....
> It seems, that this has gone better in more recent distros, but i see
> that problem from time to time.
> 
> You may also try setting MODULE_LOADED_ON_BOOT in /etc/sysconfig/kernel
> , please report if this helps

It does resolve the issue to add the modules to MODULES_LOADED_ON_BOOT.
It also works to add hal and dbus to the dependencies of
/etc/init.d/network like they are in SUSE 10.1. Thanks again.

> 
> ## Path:                System/Kernel
> ## Description:         Modules to load after initial boot
> ## Type:                string
> ## ServiceRestart:      boot.loadmodules
> #
> # This variable contains the list of modules to be loaded
> # once the main filesystem is active
> #
> MODULES_LOADED_ON_BOOT=""
> 
> 
> Just came across this one - maybe it`s worth taking a look:
> http://en.opensuse.org/SDB:Waiting_for_Mandatory_Device
> 
> regards
> roland
> 
> 
> 
> 
> 
> 
> List:       linux-kernel
> Subject:    Problem with 2.6.20 based kernels on SUSE 9.3
> From:       "K.R. Foley" <kr () cybsft ! com>
> Date:       2007-02-12 15:51:51
> Message-ID: 45D08D17.8050808 () cybsft ! com
> [Download message RAW]
> 
> I am having a problem with 2.6.20 based kernels on SUSE 9.3. It boots
> fine except that the network card is not detected at boot time. After
> the system boots I can "modprobe <nic module>" and the network comes up
> fine.
> 
> I am having this same problem on two different Suse 9.3 systems, one is
> a a dual Xeon the other is an AMD Athlon. I have no such problems on
> Suse 10.1 systems on similar hardware. Kernels prior to 2.6.20-rc? work
> fine on these systems.
> 
> The dual Xeon is using a 3Com card with the sk98lin driver.
> 0000:06:00.0 Ethernet controller: 3Com Corporation 3c940
> 10/100/1000Base-T [Marvell] (rev 10)
> 
> The Athlon is using a SIS900 with the sis900 driver.
> 0000:00:04.0 Ethernet controller: Silicon Integrated Systems [SiS]
> SiS900 PCI Fast Ethernet (rev 91)
> 
> I get the following when the system is booting:
> 
> Setting up network interfaces:
>    lo
>    lo        IP address: 127.0.0.1/8
> doneWaiting for mandatory devices:  eth-id-00:01:6c:ad:2b:c9
> 19 18 17 <notice>startproc: execve (/opt/kde3/bin/kdm) [
> /opt/kde3/bin/kdm ], [ LC_MONETARY= CONSOLE=/dev/console
> ROOTFS_FSTYPE=reiserfs SHELL=/bin/sh TERM=linux ROOTFS_FSCK=0
> LC_NUMERIC= QTDIR=/usr/lib/qt3 LC_ALL= INIT_VERSION=sysvinit-2.85
> INIT=/sbin/init KDEROOTHOME=/root/.kdm REDIRECT=/dev/tty1 COLUMNS=128
> PATH=/sbin:/usr/sbin:/bin:/usr/bin:/lib/klibc/bin LC_MESSAGES= vga=0x317
> RUNLEVEL=5 LC_COLLATE= SPLASHCFG= PWD=/ LANG=en_US.UTF-8
> ROOTFS_REALDEV=/lib/klibc//dev/hda2 PREVLEVEL=N LINES=48 SHLVL=2 HOME=/
> XCURSOR_THEME=crystalwhite WINDOWMANAGER=/usr/X11R6/bin/kde
> LC_CTYPE=en_US.UTF-8 SPLASH=no splash=silent LC_TIME=
> ROOTFS_BLKDEV=/dev/hda2 _=/sbin/startproc DAEMON=/opt/kde3/bin/kdm ]
> <notice>checkproc: /opt/kde3/bin/kdm 4094
> 16 15 14 13 12 11 10 9 8 7 6 5 4 3 1 0
>    eth-id-00:01:6c:ad:2b:c9            No interface found
> failedSetting up service network  .  .  .  .  .  .  .  .  .  .  .  .  .
> .  .  .failed
> 
> 
> I am attaching my config for the SMP system. Any ideas? Pointers?
> 
> Thanks,
> 


-- 
	kr
