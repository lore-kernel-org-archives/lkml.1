Return-Path: <linux-kernel-owner+w=401wt.eu-S1762596AbYDVJEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762596AbYDVJEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 05:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756872AbYDVJEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 05:04:31 -0400
Received: from mail.gmx.net ([213.165.64.20]:50741 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754392AbYDVJE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 05:04:29 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/IhHM49kDIMKLDPLQ5FzklDrXw+xiGbysjDAGl+l
	jBmp8VUUfYH1Yr
Subject: Re: WARNING: at drivers/base/sys.c:183 sysdev_driver_register+0x7a
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080422075357.GA15651@elte.hu>
References: <20080422075357.GA15651@elte.hu>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 11:04:26 +0200
Message-Id: <1208855066.4695.17.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-22 at 09:53 +0200, Ingo Molnar wrote:
> hi Len,
> 
> randconfig boot testing found this new debug warning message in the 
> syslog:

Ditto with Q6600 and v2.6.25-3410-g8075014.

[   28.360968] sysdev: class cpu: driver (ffffffff80542a70) has already been registered to a class, something is wrong, but will forge on!
[   28.379718] ------------[ cut here ]------------
[   28.387748] WARNING: at drivers/base/sys.c:183 sysdev_driver_register+0x75/0x12c()
[   28.398816] Modules linked in: acpi_cpufreq(+) snd_pcm_oss snd_mixer_oss snd_seq microcode snd_seq_device nls_iso8859_1 nls_cp437 vfat fat fuse loop dm_mod tda1004x saa7134_dvb videobuf_dvb dvb_core tuner tea5767 tda8290 tda827x tuner_xc2028 tda9887 tuner_simple mt20xx tea5761 snd_hda_intel saa7134 firewire_ohci snd_pcm firewire_core compat_ioctl32 crc_itu_t videodev snd_timer v4l1_compat snd_page_alloc snd_hwdep v4l2_common snd videobuf_dma_sg ohci1394 videobuf_core usbhid usb_storage e1000e rtc_cmos ieee1394 rtc_core ir_kbd_i2c hid iTCO_wdt sr_mod soundcore ir_common rtc_lib tveeprom button i2c_i801 serio_raw cdrom intel_agp ff_memless sg i2c_core iTCO_vendor_support ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ahci libata scsi_mod dock thermal processor
[   28.514728] Pid: 2910, comm: modprobe Not tainted 2.6.26-smp #4
[   28.525112] 
[   28.525113] Call Trace:
[   28.537784]  [<ffffffff802327b3>] warn_on_slowpath+0x58/0x6b
[   28.547864]  [<ffffffff80233595>] ? printk+0x67/0x69
[   28.557169]  [<ffffffffa000387a>] ? :processor:acpi_processor_preregister_performance+0x40f/0x421
[   28.570438]  [<ffffffff803701ff>] sysdev_driver_register+0x75/0x12c
[   28.581048]  [<ffffffff80392ab0>] cpufreq_register_driver+0x95/0x12c
[   28.591770]  [<ffffffffa00ea03f>] :acpi_cpufreq:acpi_cpufreq_init+0x3f/0x41
[   28.603226]  [<ffffffff802543a0>] sys_init_module+0x19db/0x1b08
[   28.614176]  [<ffffffff8028dec3>] ? vfs_read+0xab/0x154
[   28.624319]  [<ffffffff8020c01b>] system_call_after_swapgs+0x7b/0x80
[   28.624326] 
[   28.624328] ---[ end trace a40285f696d317dc ]---


