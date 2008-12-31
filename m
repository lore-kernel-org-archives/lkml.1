Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbYLaCZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbYLaCZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 21:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYLaCZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 21:25:04 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:56094 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbYLaCZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 21:25:03 -0500
To: frederik.deweerdt@xprog.eu
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [2.6.28] NULL pointer dereference at get_stats()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200812302153.ECH86976.MFLOQFJHtSOOFV@I-love.SAKURA.ne.jp>
	<20081230155215.GA31531@gambetta>
	<200812310201.GJH43235.OFFLHFMStOJVOQ@I-love.SAKURA.ne.jp>
	<20081230213727.GA2001@gambetta>
In-Reply-To: <20081230213727.GA2001@gambetta>
Message-Id: <200812311125.HBI34373.MFVOtFOSJLOHFQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 31 Dec 2008 11:25:00 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Frederik Deweerdt wrote:
> Thanks for the thourough testing. I've reviewed the code, and the only
> think that looks weird to me is the case where smp_sanity_check() fails.
> The attached patch is an attempt to correct this, Tetsuo, could you
> test it?

That patch breaks driver initialization code
----------------------------------------
SCSI subsystem initialized
Loading sd_mod.ko module
Driver 'sd' needs updating - please use bus_type methods
Loading mptbase.ko module
Fusion MPT base driver 3.04.07
Copyright (c) 1999-2008 LSI Corporation
Loading mptscsih.ko module
Waiting for driver initialization.
Scanning and configuring dmraid supported devices
Creating root device.
Mounting root filesystem.
mount: could not find filesystem '/dev/root'
Setting up other filesystems.
Setting up new root fs
setuproot: moving /dev failed: No such file or directory
no fstab.sys, mounting internal defaults
setuproot: error mounting /proc: No such file or directory
setuproot: error mounting /sys: No such file or directory
Switching to new root and running init.
unmounting old /dev
unmounting old /proc
unmounting old /sys
switchroot: mount failed: No such file or directory
Kernel panic - not syncing: Attempted to kill init!
----------------------------------------
with a popup dialog
"The CPU has been disabled by the guest operating system.
 You will need to power off or reset the virtual machine at this point."

The log without that patch looks like
----------------------------------------
SCSI subsystem initialized
Loading sd_mod.ko module
Driver 'sd' needs updating - please use bus_type methods
Loading scsi_transport_spi.ko module
Loading mptbase.ko module
Fusion MPT base driver 3.04.07
Copyright (c) 1999-2008 LSI Corporation
Loading mptscsih.ko module
Loading mptspi.ko module
Fusion MPT SPI Host driver 3.04.07
mptspi 0000:00:10.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
mptbase: ioc0: Initiating bringup
ioc0: LSI53C1030 B0: Capabilities={Initiator}
scsi0 : ioc0: LSI53C1030 B0, FwRev=00000000h, Ports=1, MaxQ=128, IRQ=17
scsi 0:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
 target0:0:0: Beginning Domain Validation
 target0:0:0: Domain Validation skipping write tests
 target0:0:0: Ending Domain Validation
 target0:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
sd 0:0:0:0: [sda] 12582912 512-byte hardware sectors: (6.44 GB/6.00 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Cache data unavailable
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] 12582912 512-byte hardware sectors: (6.44 GB/6.00 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Cache data unavailable
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
mptspi 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
mptbase: ioc1: Initiating bringup
ioc1: LSI53C1030 B0: Capabilities={Initiator}
scsi1 : ioc1: LSI53C1030 B0, FwRev=00000000h, Ports=1, MaxQ=128, IRQ=18
scsi 1:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
 target1:0:0: Beginning Domain Validation
 target1:0:0: Domain Validation skipping write tests
 target1:0:0: Ending Domain Validation
 target1:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
sd 1:0:0:0: [sdb] 16777216 512-byte hardware sectors: (8.58 GB/8.00 GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Cache data unavailable
sd 1:0:0:0: [sdb] Assuming drive cache: write through
sd 1:0:0:0: [sdb] 16777216 512-byte hardware sectors: (8.58 GB/8.00 GiB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Cache data unavailable
sd 1:0:0:0: [sdb] Assuming drive cache: write through
 sdb: sdb1
sd 1:0:0:0: [sdb] Attached SCSI disk
insmod used greatest stack depth: 1792 bytes left
Waiting for driver initialization.
Scanning and configuring dmraid supported devices
Creating root device.
Mounting root filesystem.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Setting up other filesystems.
Setting up new root fs
no fstab.sys, mounting internal defaults
Switching to new root and running init.
----------------------------------------

Regards.
