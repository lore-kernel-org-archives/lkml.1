Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbYCYXL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbYCYXL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760534AbYCYXLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:11:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35391 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760682AbYCYXLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:11:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: devzero@web.de
Subject: Re: some minor issues with 2.6.25-rc6-git7-default
Date: Wed, 26 Mar 2008 00:10:23 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, Greg KH <greg@kroah.com>,
       David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>
References: <212011377@web.de>
In-Reply-To: <212011377@web.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803260010.25327.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 26 of March 2008, devzero@web.de wrote:
> here are some (probably more or less minor) issues i have found in
> /var/log/messages & dmesg after some bigger module load/unload
> session - maybe someone wants to take a closer look.  
> 
> this one looks more serious (happened with modprobe -r ac), because
> kernel has problems afterwards (cannot load/anload any other module
> afterwards)

CCing ACPI people.

> ACPI: ACPI0007:00 is registered as cooling_device0
> ACPI: Processor [CPU0] (supports 8 throttling states)
> BUG: unable to handle kernel paging request at 1b563b0c
> IP: [<c020000f>] acpi_ps_execute_method+0xc4/0x1f9
> *pde = 00000000
> Oops: 0002 [#1] SMP
> Modules linked in: ac(+) sg ahci libata dock sha1_generic michael_mic xcbc crc32c deflate zlib_deflate
> tgr192 wp512 sha512 seed camellia fcrypt pcbc khazad tea arc4 cast6 cast5 xts gf128mul serpent blowfish
> sha256_generic md4 cbc des_generic ecb crypto_blkcipher snd_seq_dummy snd_seq snd_timer snd_seq_device
> snd soundcore parkbd eni suni zatm uPD98402 atm lm70 hwmon ip2 ip2main parport_pc parport 8250_exar_st16c554
> 8250_accent 8250_hub6 8250_boca 8250_fourport ide_generic hpt366 alim15x3 jmicron pdc202xx_new cs5535 aec62xx
> atiixp cs5520 it821x cs5530 hpt34x opti621 trm290 amd74xx ns87415 rz1000 pdc202xx_old via82cxxx triflex cmd64x
> it8213 cy82c693 slc90e66 sc1200 serverworks sis5513 siimage ide_cd_mod cdrom mdacon capifs sctp libcrc32c
> 9pnet_fd 9pnet sunrpc decnet dccp_ipv6 dccp_ipv4 dccp ipv6 fuse ide_pci_generic pcnet32 piix mii intel_agp
> ide_core agpgart ext3 mbcache jbd mptspi mptscsih mptbase scsi_transport_spi sd_mod scsi_mod [last unloaded: sbshc]
> 
> Pid: 14520, comm: modprobe Tainted: P         (2.6.25-rc6-git7-default #1)
> EIP: 0060:[<c020000f>] EFLAGS: 00010206 CPU: 0
> EIP is at acpi_ps_execute_method+0xc4/0x1f9
> EAX: 1b563b0c EBX: 00000000 ECX: 0000ffff EDX: 00000093
> ESI: d41a6240 EDI: c032c726 EBP: 00000000 ESP: df881d98
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process modprobe (pid: 14520, ti=df880000 task=ddb458f0 task.ti=df880000)
> Stack: ffffffff c032d513 df020c8c df020c84 df021844 d41a6250 d41a6240 c032c726
>        00000000 c01fc910 00001001 d41a6240 e085f44c 00000000 c01fc44b e085f44c
>        df020ce8 d41a6a20 d41a6a20 00000004 e085f44c df020ce8 c01ec145 df881dfc
> Call Trace:
>  [<c01fc910>] acpi_ns_evaluate+0x104/0x1a0
>  [<c01fc44b>] acpi_evaluate_object+0x16f/0x244
>  [<c01ec145>] acpi_evaluate_integer+0x84/0x104
>  [<e085f038>] acpi_ac_get_state+0x22/0x53 [ac]
>  [<e085f20e>] acpi_ac_add+0x63/0x15a [ac]
>  [<c0207f4d>] acpi_device_probe+0x37/0xcd
>  [<c022dd2b>] driver_probe_device+0x9d/0x114
>  [<c022de86>] __driver_attach+0x52/0x87
>  [<c022d36b>] bus_for_each_dev+0x31/0x52
>  [<c022dbde>] driver_attach+0x11/0x13
>  [<c022de34>] __driver_attach+0x0/0x87
>  [<c022da1e>] bus_add_driver+0x91/0x193
>  [<c022e039>] driver_register+0x45/0x9a
>  [<e0863021>] acpi_ac_init+0x21/0x39 [ac]
>  [<c013c1de>] sys_init_module+0x16b6/0x17c9
>  [<c0208280>] acpi_bus_register_driver+0x0/0x38
>  [<c0108a6a>] sys_mmap2+0x62/0x77
>  [<c01059c4>] sysenter_past_esp+0x6d/0xa9
>  =======================
> Code: c0 b8 01 00 00 00 e8 f9 53 00 00 ff 76 08 8b 46 10 50 83 c0 08 50 68 13 d5 32 c0 6a ff 00 00 00 c2 2d 
> c0 68 b0 c2 2d c0 68 fb 00 <00> 00 6a 40 e8 82 2a 00 00 83 c4 24 e8 93 fe ff ff 85 c0 89 c5
> EIP: [<c020000f>] acpi_ps_execute_method+0xc4/0x1f9 SS:ESP 0068:df881d98
> ---[ end trace f8c13e074fc8ef52 ]---
> 
> 
> these are probably minor:

CCing Greg.

> Mar 23 09:17:02 opensuse103 kernel: physmap-flash: probe of physmap-flash.0 failed with error -12
> Mar 23 09:17:03 opensuse103 kernel: Device 'physmap-flash.0' does not have a release() function, it is broken and must be fixed.
> Mar 23 09:17:03 opensuse103 kernel: ------------[ cut here ]------------
> Mar 23 09:17:03 opensuse103 kernel: WARNING: at drivers/base/core.c:114 kobject_release+0x3d/0x4f()
> Mar 23 09:17:03 opensuse103 kernel: Modules linked in: physmap(-) mtd map_funcs cfi_probe jedec_probe gen_probe chipreg parkbd eni
> suni zatm uPD98402 atm lm70 hwmon ip2 ip2main parport_pc parport 8250_exar_st16c554 8250_accent 8250_hub6 8250_boca 8250_fourport
> ide_generic hpt366 alim15x3 jmicron pdc202xx_new cs5535 aec62xx ati ixp cs5520 it821x cs5530 hpt34x opti621 trm290 amd74xx ns87415
> rz1000 pdc202xx_old via82cxxx triflex cmd64x it8213 cy82c693 slc90e66 sc1200 serverworks sis5513 siim age ide_cd_mod cdrom mdacon
> sg capifs sha1_generic michael_mic xcbc crc32c deflate zlib_deflate tgr192 wp512 sha512 seed camellia fcrypt pcbc khazad tea arc4
> cast6 cast5 xts gf128mul serpent blowfish sha256_generic md4 cbc des_generic ecb crypto_blkcipher snd_seq_dummy snd_seq snd_timer
> snd_seq_device snd soundcore sctp libcrc 32c 9pnet_fd 9pnet sunrpc decnet dccp_ipv6 dccp_ipv4 dccp ipv6 fuse ide_pci_generic pcnet32
> piix mii intel_agp ide_core agpgart ext3 mbcache jbd mptspi mptscsih mpt base scsi_transport_spi sd_mod scsi_mod [last unloaded: mtd]
> Mar 23 09:17:03 opensuse103 kernel: Pid: 19992, comm: modprobe Tainted: P         2.6.25-rc6-git7-default #1
> Mar 23 09:17:03 opensuse103 kernel:  [<c011f61f>] warn_on_slowpath+0x40/0x4f
> Mar 23 09:17:03 opensuse103 kernel:  [<c0123d20>] irq_exit+0x50/0x67
> Mar 23 09:17:03 opensuse103 kernel:  [<c0111a4f>] smp_apic_timer_interrupt+0x6b/0x78
> Mar 23 09:17:03 opensuse103 kernel:  [<c0106ad8>] apic_timer_interrupt+0x28/0x30
> Mar 23 09:17:03 opensuse103 kernel:  [<c0120192>] vprintk+0x2b9/0x2ed
> Mar 23 09:17:03 opensuse103 kernel:  [<c01a3565>] sysfs_addrm_finish+0x171/0x19d
> Mar 23 09:17:03 opensuse103 kernel:  [<c01a35b2>] remove_dir+0x21/0x27
> Mar 23 09:17:03 opensuse103 kernel:  [<c01a3613>] sysfs_remove_dir+0x5b/0x62
> Mar 23 09:17:03 opensuse103 kernel:  [<c01201da>] printk+0x14/0x18
> Mar 23 09:17:03 opensuse103 kernel:  [<c01c7f64>] kobject_release+0x3d/0x4f
> Mar 23 09:17:03 opensuse103 kernel:  [<c01c7f27>] kobject_release+0x0/0x4f
> Mar 23 09:17:03 opensuse103 kernel:  [<c01c89f2>] kref_put+0x36/0x40
> Mar 23 09:17:03 opensuse103 kernel:  [<e0cb83ba>] physmap_exit+0xa/0x14 [physmap]
> Mar 23 09:17:03 opensuse103 kernel:  [<c013c8b1>] sys_delete_module+0x187/0x1c6
> Mar 23 09:17:03 opensuse103 kernel:  [<c015d5b5>] remove_vma+0x36/0x3b
> Mar 23 09:17:03 opensuse103 kernel:  [<c015decb>] do_munmap+0x18a/0x1a4
> Mar 23 09:17:03 opensuse103 kernel:  [<c01059c4>] sysenter_past_esp+0x6d/0xa9
> Mar 23 09:17:03 opensuse103 kernel:  =======================
> Mar 23 09:17:03 opensuse103 kernel: ---[ end trace f8c13e074fc8ef52 ]---

CCing Dave Brownell.

> Mar 23 09:14:23 opensuse103 kernel: Generic RTC Driver v1.07
> Mar 23 09:14:23 opensuse103 kernel: proc_dir_entry 'rtc' already registered
> Mar 23 09:14:23 opensuse103 kernel: Pid: 3994, comm: modprobe Tainted: P         2.6.25-rc6-git7-default #1
> Mar 23 09:14:23 opensuse103 kernel:  [<c019a602>] proc_register+0xf3/0x11f
> Mar 23 09:14:23 opensuse103 kernel:  [<c019a719>] create_proc_entry+0x69/0x7b
> Mar 23 09:14:23 opensuse103 kernel:  [<e0c5f02d>] rtc_generic_init+0x2d/0x54 [genrtc]
> Mar 23 09:14:23 opensuse103 kernel:  [<c013c1de>] sys_init_module+0x16b6/0x17c9
> Mar 23 09:14:23 opensuse103 kernel:  [<c0108a6a>] sys_mmap2+0x62/0x77
> Mar 23 09:14:23 opensuse103 kernel:  [<c01059c4>] sysenter_past_esp+0x6d/0xa9
> Mar 23 09:14:23 opensuse103 kernel:  =======================
> 
> 
> 
> Mar 23 09:13:09 opensuse103 kernel: hgafb: probe of hgafb.0 failed with error -22
> Mar 23 09:13:09 opensuse103 kernel: Device 'hgafb.0' does not have a release() function, it is broken and must be fixed.
> Mar 23 09:13:09 opensuse103 kernel: ------------[ cut here ]------------
> Mar 23 09:13:09 opensuse103 kernel: WARNING: at drivers/base/core.c:114 kobject_release+0x3d/0x4f()
> Mar 23 09:13:09 opensuse103 kernel: Modules linked in: hgafb(-) mdacon sg capifs sha1_generic michael_mic xcbc crc32c deflate 
> zlib_deflate tgr192 wp512 sha512 seed camellia fcrypt pcbc khazad tea arc4 cast6 cast5 xts gf128mul serpent blowfish sha256_generic 
> md4 cbc des_generic ecb crypto_blkcipher snd_seq_dummy snd_seq snd_timer snd_seq_device snd soundcore sctp libcrc32c 9pnet_fd 9pnet 
> sunrpc decnet dccp_ipv6 dccp_ipv4 dccp ipv6 fuse loop ide_cd_mod cdrom ide_pci_generic rtc_cmos rtc_core pcnet32 piix i2c_piix4 
> parport_pc mii rtc_lib parport shpchp intel_agp ide_core i2c_core pci_hotplug agpgart uhci_hcd usbcore edd ext3 mbcache jbd mptsas 
> scsi_transport_sas mptfc scsi_transport_fc scsi_tgt mptspi mptscsih mptbase scsi_transport_spi sd_mod scsi_mod [last unloaded: lcd]
> Mar 23 09:13:09 opensuse103 kernel: Pid: 30783, comm: modprobe Tainted: P         2.6.25-rc6-git7-default #1
> Mar 23 09:13:09 opensuse103 kernel:  [<c011f61f>] warn_on_slowpath+0x40/0x4f
> Mar 23 09:13:09 opensuse103 kernel:  [<c0123d20>] irq_exit+0x50/0x67
> Mar 23 09:13:09 opensuse103 kernel:  [<c0111a4f>] smp_apic_timer_interrupt+0x6b/0x78
> Mar 23 09:13:09 opensuse103 kernel:  [<c0106ad8>] apic_timer_interrupt+0x28/0x30
> Mar 23 09:13:09 opensuse103 kernel:  [<c0120192>] vprintk+0x2b9/0x2ed
> Mar 23 09:13:09 opensuse103 kernel:  [<c01a3565>] sysfs_addrm_finish+0x171/0x19d
> Mar 23 09:13:09 opensuse103 kernel:  [<c01a35b2>] remove_dir+0x21/0x27
> Mar 23 09:13:09 opensuse103 kernel:  [<c01a3613>] sysfs_remove_dir+0x5b/0x62
> Mar 23 09:13:09 opensuse103 kernel:  [<c01201da>] printk+0x14/0x18
> Mar 23 09:13:09 opensuse103 kernel:  [<c01c7f64>] kobject_release+0x3d/0x4f
> Mar 23 09:13:09 opensuse103 kernel:  [<c01c7f27>] kobject_release+0x0/0x4f
> Mar 23 09:13:09 opensuse103 kernel:  [<c01c89f2>] kref_put+0x36/0x40
> Mar 23 09:13:09 opensuse103 kernel:  [<e08224f2>] hgafb_exit+0xa/0x14 [hgafb]
> Mar 23 09:13:09 opensuse103 kernel:  [<c013c8b1>] sys_delete_module+0x187/0x1c6
> Mar 23 09:13:09 opensuse103 kernel:  [<c015d5b5>] remove_vma+0x36/0x3b
> Mar 23 09:13:09 opensuse103 kernel:  [<c015decb>] do_munmap+0x18a/0x1a4
> Mar 23 09:13:09 opensuse103 kernel:  [<c01059c4>] sysenter_past_esp+0x6d/0xa9
> Mar 23 09:13:09 opensuse103 kernel:  =======================
> Mar 23 09:13:09 opensuse103 kernel: ---[ end trace f8c13e074fc8ef52 ]---
> 
> 
> 
> Mar 23 09:06:31 opensuse103 kernel: Installing 9P2000 support
> Mar 23 09:06:31 opensuse103 kernel: sys_init_module: '9pnet_fd'->init suspiciously returned 1, it should follow 0/-E convention
> Mar 23 09:06:31 opensuse103 kernel: sys_init_module: loading module anyway...
> Mar 23 09:06:31 opensuse103 kernel: Pid: 5323, comm: modprobe Not tainted 2.6.25-rc6-git7-default #1
> Mar 23 09:06:31 opensuse103 kernel:  [<c013c253>] sys_init_module+0x172b/0x17c9
> Mar 23 09:06:31 opensuse103 kernel:  [<c0108a6a>] sys_mmap2+0x62/0x77
> Mar 23 09:06:31 opensuse103 kernel:  [<c01059c4>] sysenter_past_esp+0x6d/0xa9
> Mar 23 09:06:31 opensuse103 kernel:  =======================
> 
> 
> 
> Mar 23 09:31:43 opensuse103 kernel: sysfs: duplicate filename 'pata_winbond.0' can not be created
> Mar 23 09:31:43 opensuse103 kernel: ------------[ cut here ]------------
> Mar 23 09:31:43 opensuse103 kernel: WARNING: at fs/sysfs/dir.c:424 sysfs_add_one+0x31/0x7a()
> Mar 23 09:31:43 opensuse103 kernel: Modules linked in: pata_winbond(+) ahci libata dock sha1_generic michael_mic xcbc crc32c 
> deflate zlib_deflate tgr192 wp512 sha512 seed camellia fcrypt pcbc khazad tea arc4 cast6 cast5 xts gf128mul serpent blowfish 
> sha256_generic md4 cbc des_generic ecb crypto_blkcipher snd_seq_dummy snd_seq snd_timer snd_seq_device snd soundcore parkbd eni 
> suni zatm uPD98402 atm lm70 hwmon ip2 ip2main parport_pc parport 8250_exar_st16c554 8250_accent 8250_hub6 8250_boca 8250_fourport 
> ide_generic hpt366 alim15x3 jmicron pdc202xx_new cs5535 aec62xx atiixp cs5520 it821x cs5530 hpt34x opti621 trm290 amd74xx ns87415 
> rz1000 pdc202xx_old via82cxxx triflex cmd64x it8213 cy82c693 slc90e66 sc1200 serverworks sis5513 siimage ide_cd_mod cdrom mdacon 
> sg capifs sctp libcrc32c 9pnet_fd 9pnet sunrpc decnet dccp_ipv6 dccp_ipv4 dccp ipv6 fuse ide_pci_generic pcnet32 piix mii intel_agp 
> ide_core agpgart ext3 mbcache jbd mptspi mptscsih mptbase scsi_transport_spi sd_mod scsi_mod [last unloaded: pata_serverworks]
> Mar 23 09:31:43 opensuse103 kernel: Pid: 12964, comm: modprobe Tainted: P         2.6.25-rc6-git7-default #1
> Mar 23 09:31:43 opensuse103 kernel:  [<c011f61f>] warn_on_slowpath+0x40/0x4f
> Mar 23 09:31:43 opensuse103 kernel:  [<c0109e22>] sched_clock+0x8/0x20
> Mar 23 09:31:43 opensuse103 kernel:  [<c01319f3>] hrtimer_run_pending+0x27/0xac
> Mar 23 09:31:43 opensuse103 kernel:  [<c0126911>] run_timer_softirq+0x30/0x1a1
> Mar 23 09:31:43 opensuse103 kernel:  [<c01239a0>] __do_softirq+0x75/0xe1
> Mar 23 09:31:43 opensuse103 kernel:  [<c0123d20>] irq_exit+0x50/0x67
> Mar 23 09:31:43 opensuse103 kernel:  [<c0111a4f>] smp_apic_timer_interrupt+0x6b/0x78
> Mar 23 09:31:43 opensuse103 kernel:  [<c0106ad8>] apic_timer_interrupt+0x28/0x30
> Mar 23 09:31:43 opensuse103 kernel:  [<c01a31e1>] sysfs_add_one+0x31/0x7a
> Mar 23 09:31:43 opensuse103 kernel:  [<c01a365b>] create_dir+0x3c/0x6c
> Mar 23 09:31:43 opensuse103 kernel:  [<c01a36b4>] sysfs_create_dir+0x29/0x3b
> Mar 23 09:31:43 opensuse103 kernel:  [<c01c7f85>] kobject_get+0xf/0x13
> Mar 23 09:31:43 opensuse103 kernel:  [<c01c8078>] kobject_add_internal+0xa6/0x13f
> Mar 23 09:31:43 opensuse103 kernel:  [<c01c81a8>] kobject_add_varg+0x39/0x42
> Mar 23 09:31:43 opensuse103 kernel:  [<c01c83fb>] kobject_add+0x4a/0x4e
> Mar 23 09:31:43 opensuse103 kernel:  [<c022c181>] device_add+0x62/0x44d
> Mar 23 09:31:43 opensuse103 kernel:  [<c022f197>] platform_device_add+0x48/0xfa
> Mar 23 09:31:43 opensuse103 kernel:  [<c022f21e>] platform_device_add+0xcf/0xfa
> Mar 23 09:31:43 opensuse103 kernel:  [<c022f3b6>] platform_device_register_simple+0x34/0x4a
> Mar 23 09:31:43 opensuse103 kernel:  [<e0c5310b>] winbond_init+0x10b/0x283 [pata_winbond]
> Mar 23 09:31:43 opensuse103 kernel:  [<c013c1de>] sys_init_module+0x16b6/0x17c9
> Mar 23 09:31:43 opensuse103 kernel:  [<c01243b1>] __request_region+0x0/0x74
> Mar 23 09:31:43 opensuse103 kernel:  [<c0108a6a>] sys_mmap2+0x62/0x77
> Mar 23 09:31:43 opensuse103 kernel:  [<c01059c4>] sysenter_past_esp+0x6d/0xa9
> Mar 23 09:31:43 opensuse103 kernel:  =======================
> Mar 23 09:31:43 opensuse103 kernel: ---[ end trace f8c13e074fc8ef52 ]---
> Mar 23 09:31:43 opensuse103 kernel: kobject_add_internal failed for pata_winbond.0 with -EEXIST, don't try to register things with the same name in the same directory.
> Mar 23 09:31:43 opensuse103 kernel: Pid: 12964, comm: modprobe Tainted: P         2.6.25-rc6-git7-default #1
> Mar 23 09:31:43 opensuse103 kernel:  [<c01c80db>] kobject_add_internal+0x109/0x13f
> Mar 23 09:31:43 opensuse103 kernel:  [<c01c81a8>] kobject_add_varg+0x39/0x42
> Mar 23 09:31:43 opensuse103 kernel:  [<c01c83fb>] kobject_add+0x4a/0x4e
> Mar 23 09:31:43 opensuse103 kernel:  [<c022c181>] device_add+0x62/0x44d
> Mar 23 09:31:43 opensuse103 kernel:  [<c022f197>] platform_device_add+0x48/0xfa
> Mar 23 09:31:43 opensuse103 kernel:  [<c022f21e>] platform_device_add+0xcf/0xfa
> Mar 23 09:31:43 opensuse103 kernel:  [<c022f3b6>] platform_device_register_simple+0x34/0x4a
> Mar 23 09:31:43 opensuse103 kernel:  [<e0c5310b>] winbond_init+0x10b/0x283 [pata_winbond]
> Mar 23 09:31:43 opensuse103 kernel:  [<c013c1de>] sys_init_module+0x16b6/0x17c9
> Mar 23 09:31:43 opensuse103 kernel:  [<c01243b1>] __request_region+0x0/0x74
> Mar 23 09:31:43 opensuse103 kernel:  [<c0108a6a>] sys_mmap2+0x62/0x77
> Mar 23 09:31:43 opensuse103 kernel:  [<c01059c4>] sysenter_past_esp+0x6d/0xa9
> Mar 23 09:31:43 opensuse103 kernel:  =======================

Well, Andrew should be CCed too ...

Thanks,
Rafael

