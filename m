Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbYI2JBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbYI2JBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 05:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbYI2JBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 05:01:06 -0400
Received: from rayleigh.systella.fr ([213.41.184.253]:44211 "EHLO
	rayleigh.systella.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYI2JBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 05:01:05 -0400
From: BERTRAND Joel <bertrand@rayleigh.systella.fr>
Message-Id: <200809290900.m8T90wHw008792@rayleigh.systella.fr>
To: linux-kernel@vger.kernel.org
Subject: Fwd: 2.6.26.x hangs on amd64/smp
Reply-To: wilhelm-siegfried.knatschke-koenigsberg@chezmoi.com
Date: Mon, 29 Sep 2008 11:00:58 +0200
User-Agent: slrn/pre0.9.9-111 (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.8 (rayleigh.systella.fr [127.0.0.1]); Mon, 29 Sep 2008 11:01:01 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: BERTRAND Joel <joel.bertrand@systella.fr>
Newsgroups: linux.kernel
Subject: 2.6.26.x hangs on amd64/smp
Reply-To: mt1@systella.fr

>	Hello,
>
>System : debian/testing, tested kernels 2.6.26, 2.6.26.3, 2.6.26.5.
>Hardware : core2duo, 4 GB, raid1 software, CFQ scheduler.
>
>	I have written a program that work on cartographic data. This program 
>is started as a daemon and does some fork() (and pthread_create()). I 
>have seen that it requires 6 GB to work, each process takes 1,5 GB. The 
>same program works fine under FreeBSD or Solaris (on of course the same 
>hardware).
>
>	When it starts, I can see disk activity (swap), and after 2 or 3 
>minutes, kernel crashes without any trace (no more disk activity, sysrq 
>does nothing...). I have reproduced this bug when I was logged on 
>console. There was no messsage.
>
>	If I introduce some nanosleep() syscalls in my code, crash is more 
>difficult to reproduce.
>
>cauchy:[~] > cat /proc/mdstat
>Personalities : [raid1]
>md1 : active raid1 sdb2[1] sda2[0]
>       5855616 blocks [2/2] [UU]
>
>md2 : active raid1 sdb3[1] sda3[0]
>       48829440 blocks [2/2] [UU]
>
>md3 : active raid1 sdb4[1] sda4[0]
>       101474496 blocks [2/2] [UU]
>
>md0 : active raid1 sdb1[1] sda1[0]
>       128384 blocks [2/2] [UU]
>
>unused devices: <none>
>
>	swap in on /dev/md1.
>
>cauchy:[~] > df -h
>Sys. de fich.         Tail. Occ. Disp. %Occ. Monté sur
>/dev/md2               46G   28G   16G  64% /
>tmpfs                 2,0G     0  2,0G   0% /lib/init/rw
>udev                   10M  124K  9,9M   2% /dev
>tmpfs                 2,0G     0  2,0G   0% /dev/shm
>/dev/md0              122M   60M   56M  52% /boot
>/dev/md3               96G   56G   35G  62% /home
>cauchy:[~] >
>
>dmesg :
>Linux version 2.6.26.5 (root@cauchy) (gcc version 4.3.1 (Debian 4.3.1-9) 
>) #16 SMP PREEMPT Tue Sep 23 15:54:59 CEST 2008
>...
>ACPI: BIOS bug: multiple APIC/MADT found, using 0
>ACPI: If "acpi_apic_instance=2" works better, notify 
>linux-acpi@vger.kernel.org
>ACPI: DMI detected: Toshiba
>...
>
>.config: see http://www.systella.fr/~bertrand/config.2.6.26.5

	Some bad news... I'm now able to reproduce this bug _without_ X.
	Test configuration :

	debian/testing up to date (minimal system with 2.6.26.5 kernel from
	ftp.kernel.org build with gcc-4.3).

	I have started my test program on a ssh connection. Console enters
	in DPMS mode (power off). When system crashes, screen can be switch on
	when I press on a key. But, there is not information on console.
	Sysrq key doesn't work anymore. Any disc activities. It is
	impossible to log on and I have to reboot with power button...

	Regards,

	JKB
