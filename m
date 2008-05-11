Return-Path: <linux-kernel-owner+w=401wt.eu-S1758645AbYEKUYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645AbYEKUYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 16:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYEKUYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 16:24:44 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:43637 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbYEKUYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 16:24:43 -0400
Date: Sun, 11 May 2008 17:24:17 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, yakui.zhao@intel.com,
       davej@codemonkey.org.uk
Subject: Re: [2.6.26-rc1] WARNING: at drivers/base/sys.c:183
Message-ID: <20080511202416.GA5771@beyonder.ift.unesp.br>
Mail-Followup-To: Tilman Schmidt <tilman@imap.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-acpi@vger.kernel.org, yakui.zhao@intel.com,
	davej@codemonkey.org.uk
References: <48273860.1000103@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48273860.1000103@imap.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 11.May'08 at 20:18:08 +0200, Tilman Schmidt wrote:
> This warning, first reported for 2.6.25-rc5-mm1
> (see http://lkml.org/lkml/2008/3/12/444)
> has now made it into mainline:
> 
> May 11 19:32:44 xenon kernel: [   29.017148] powernow: This module only works with AMD K7 CPUs
> May 11 19:32:44 xenon kernel: [   29.607563] sysdev: class cpu: driver (c0439804) has already been registered to a class, something is wrong, but will forge on!
> May 11 19:32:44 xenon kernel: [   29.611835] ------------[ cut here ]------------
> May 11 19:32:44 xenon kernel: [   29.616182] WARNING: at drivers/base/sys.c:183 sysdev_driver_register+0x59/0xf2()
> May 11 19:32:44 xenon kernel: [   29.622037] Modules linked in: acpi_cpufreq(+) speedstep_lib microcode firmware_class loop osst st sr_mod cdrom pata_acpi bas_gigaset snd_hda_intel gigaset isdn snd_pcm rtc_cmos ata_generic aic7xxx snd_timer rtc_core usblp snd slhc ohci1394 pata_marvell thermal ieee1394 rtc_lib i2c_i801 parport_pc intel_agp processor soundcore crc_ccitt iTCO_wdt button scsi_transport_spi iTCO_vendor_support parport snd_page_alloc agpgart i2c_core sg ext3 jbd mbcache linear usbhid hid sd_mod ahci libata uhci_hcd ehci_hcd scsi_mod dock usbcore dm_snapshot dm_mod
> May 11 19:32:44 xenon kernel: [   29.648305] Pid: 2860, comm: modprobe Not tainted 2.6.26-rc1-testing #1
> May 11 19:32:44 xenon kernel: [   29.653156]  [<c0129d09>] warn_on_slowpath+0x41/0x6d
> May 11 19:32:44 xenon kernel: [   29.658026]  [<c0120032>] ? push_rt_task+0xb1/0x1ab
> May 11 19:32:44 xenon kernel: [   29.664013]  [<c012a75a>] ? vprintk+0x3a5/0x3c5
> May 11 19:32:44 xenon kernel: [   29.670995]  [<c010b7a4>] ? native_sched_clock+0xe0/0xff
> May 11 19:32:44 xenon kernel: [   29.675849]  [<c010b7a4>] ? native_sched_clock+0xe0/0xff
> May 11 19:32:44 xenon kernel: [   29.680678]  [<c0143881>] ? put_lock_stats+0xd/0x21
> May 11 19:32:44 xenon kernel: [   29.685465]  [<c012a78f>] ? printk+0x15/0x17
> May 11 19:32:44 xenon kernel: [   29.690406]  [<c026a57a>] sysdev_driver_register+0x59/0xf2
> May 11 19:32:44 xenon kernel: [   29.696845]  [<c02a8fe3>] cpufreq_register_driver+0x80/0xfc
> May 11 19:32:44 xenon kernel: [   29.701892]  [<faafe034>] acpi_cpufreq_init+0x34/0x3a [acpi_cpufreq]
> May 11 19:32:44 xenon kernel: [   29.708279]  [<c014d441>] sys_init_module+0x1883/0x1a34
> May 11 19:32:44 xenon kernel: [   29.713176]  [<c0106b63>] sysenter_past_esp+0x78/0xd1
> May 11 19:32:44 xenon kernel: [   29.718586]  =======================
> May 11 19:32:44 xenon kernel: [   29.723414] ---[ end trace da2515dc0122d0b1 ]---
> 
> ts@xenon:~> uname -a
> Linux xenon 2.6.26-rc1-testing #1 SMP PREEMPT Tue May 6 19:52:43 CEST 2008 i686 i686 i386 GNU/Linux

Isn't it fixed by db176c6ed8974fae94328ad5ac9e70b094ff22fd 
("Fix bogus warning in sysdev_driver_register()") ?

This commit is post-rc1: v2.6.26-rc1-165-gdb176c6

