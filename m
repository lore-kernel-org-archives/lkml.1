Return-Path: <linux-kernel-owner+w=401wt.eu-S934566AbYDVOQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934566AbYDVOQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 10:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934098AbYDVOMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 10:12:19 -0400
Received: from styx.suse.cz ([82.119.242.94]:52085 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763677AbYDVOMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 10:12:16 -0400
Date: Tue, 22 Apr 2008 16:12:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: davej@codemonkey.org.uk, lenb@kernel.org
cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       cpufreq@lists.linux.org.uk, Greg KH <greg@kroah.com>
Subject: WARNING: at drivers/base/sys.c:183 sysdev_driver_register+0x75/0x12e()
Message-ID: <Pine.LNX.4.64.0804221609130.12972@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am getting the acpi-cpufreq-drivercore warning below when booting 
current git (807501475)

powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3000+ processors (1 cpu 
cores) (version 2.20.00)
powernow-k8: BIOS error - no PSB or ACPI _PSS objects
sysdev: class cpu: driver (ffffffff8057fd10) has already been registered 
to a class, something is wrong, but will forge on!
------------[ cut here ]------------
WARNING: at drivers/base/sys.c:183 sysdev_driver_register+0x75/0x12e()
Modules linked in: acpi_cpufreq(+) snd_mixer_oss freq_table snd_seq loop 
dm_mod snd_via82xx gameport snd_ac97_codec ac97_bus snd_pcm snd_timer 
snd_page_alloc snd_mpu401_uart snd_rawmidi parport_pc snd_seq_device 
parport snd shpchp floppy i2c_viapro i2c_core soundcore pci_hotplug sr_mod 
r8169 cdrom button sg usbhid hid sd_mod edd ext3 mbcache jbd fan pata_via 
sata_via libata scsi_mod dock thermal processor
Pid: 2284, comm: modprobe Not tainted 2.6.25-default-03410-g8075014 #27

Call Trace:
 [<ffffffff8022dcc7>] warn_on_slowpath+0x58/0x6b
 [<ffffffff8022eba7>] ? printk+0x67/0x69
 [<ffffffff8042777a>] ? __mutex_unlock_slowpath+0xf9/0x105
 [<ffffffff8042778f>] ? mutex_unlock+0x9/0xb
 [<ffffffff8042927d>] ? _spin_unlock_irqrestore+0x3f/0x47
 [<ffffffff80368b33>] sysdev_driver_register+0x75/0x12e
 [<ffffffff803a9fb3>] cpufreq_register_driver+0x95/0x12f
 [<ffffffffa00f503f>] :acpi_cpufreq:acpi_cpufreq_init+0x3f/0x41
 [<ffffffff80252b4b>] sys_init_module+0x19d1/0x1b02
 [<ffffffff80285eda>] ? __kmalloc+0x0/0xea
 [<ffffffff8024a87b>] ? trace_hardirqs_on+0xf1/0x115
 [<ffffffff80428afc>] ? trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff8020bf7b>] system_call_after_swapgs+0x7b/0x80

---[ end trace 21ad653327c7db6f ]---

-- 
Jiri Kosina
