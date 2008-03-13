Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbYCMT6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbYCMT6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 15:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbYCMT6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 15:58:05 -0400
Received: from testure.choralone.org ([194.9.77.134]:53552 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbYCMT6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 15:58:04 -0400
Date: Thu, 13 Mar 2008 15:57:54 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Greg KH <gregkh@suse.de>
Cc: Tilman Schmidt <tilman@imap.cc>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [2.6.25-rc5-mm1] WARNING: at drivers/base/sys.c:173
Message-ID: <20080313195754.GB32463@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Greg KH <gregkh@suse.de>, Tilman Schmidt <tilman@imap.cc>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <47D87238.8080305@imap.cc> <20080313183439.GA12798@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080313183439.GA12798@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2008 at 11:34:39AM -0700, Greg KH wrote:
 > On Thu, Mar 13, 2008 at 01:15:52AM +0100, Tilman Schmidt wrote:
 > > Am 11.03.2008 09:14 schrieb Andrew Morton:
 > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc5/2.6.25-rc5-mm1/
 > > 
 > > Late during boot, this issues the following warning on my Pentium D,
 > > apparently when trying to load an appropriate CPU frequency driver:
 > > 
 > > [   56.759128] ------------[ cut here ]------------
 > > [   56.765058] WARNING: at drivers/base/sys.c:173 sysdev_driver_register+0x34/0xce()
 > > [   56.776027] Modules linked in: acpi_cpufreq(+) speedstep_lib ip6table_filter ip6_tables x_tables ipv6 microcode firmware_class loop osst st sr_mod cdrom pata_acpi bas_gigaset snd_hda_intel gigaset isdn snd_pcm ata_generic<6>ip_tables: (C) 2000-2006 Netfilter Core Team
 > > [   56.785293]  snd_timer aic7xxx slhc snd ohci1394 rtc_cmos ieee1394 shpchp crc_ccitt iTCO_wdt e1000e rtc_core iTCO_vendor_support soundcore scsi_transport_spi watchdog_core pci_hotplug intel_agp button thermal agpgart rtc_lib processor i2c_i801 watchdog_dev parport_pc i2c_core snd_page_alloc parport pata_marvell sg ext3 jbd mbcache linear sd_mod usbhid hid ff_memless ahci libata scsi_mod ehci_hcd uhci_hcd usbcore dm_snapshot dm_mod
 > > [   56.805358] Pid: 2856, comm: modprobe Not tainted 2.6.25-rc5-mm1-testing #1
 > > [   56.810766]  [<c01272e9>] warn_on_slowpath+0x41/0x6d
 > > [   56.820628]  [<c0230065>] ? acpi_ns_lookup+0x2b5/0x497
 > > [   56.830455]  [<c0230e25>] ? acpi_evaluate_object+0x23e/0x249
 > > [   56.840414]  [<c02ff809>] ? mutex_unlock+0x8/0xa
 > > [   56.848380]  [<fa9fec1d>] ? acpi_processor_preregister_performance+0x4e6/0x4f1 [processor]
 > > [   56.858297]  [<c0286438>] ? cpufreq_register_driver+0x42/0xfc
 > > [   56.868263]  [<c026423d>] sysdev_driver_register+0x34/0xce
 > > [   56.877974]  [<c0286476>] cpufreq_register_driver+0x80/0xfc
 > > [   56.887327]  [<facde034>] acpi_cpufreq_init+0x34/0x3a [acpi_cpufreq]
 > > [   56.897290]  [<c014ad7a>] sys_init_module+0x1816/0x1943
 > > [   56.907304]  [<facb5000>] ? icmp_checkentry+0x0/0x14 [ip_tables]
 > > [   56.917255]  [<c0183cd2>] ? sys_read+0x3b/0x60
 > > [   56.925094]  [<c0106aec>] sysenter_past_esp+0x6d/0xc5
 > > [   56.935071]  =======================
 > > [   56.945016] ---[ end trace 9ade9adb26b6da0a ]---
 > > 
 > > Looking back, -rc3-mm1 did that too.
 > > Mainline (-rc3 through -rc5) never did.
 > > Let me know if you need more information.
 > > CCing Dave Jones for cpufreq and Greg KH for sysdev.
 > 
 > This implys that a cpufreq module is getting registered twice in the
 > sysdev code :(

I'm wondering if the processor driver has registered something
that acpi_cpufreq is also trying to do.  Cc'ing linux-acpi

	Dave

-- 
http://www.codemonkey.org.uk
