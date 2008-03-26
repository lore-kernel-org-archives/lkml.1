Return-Path: <linux-kernel-owner+w=401wt.eu-S1763659AbYCZUTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763659AbYCZUTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 16:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762168AbYCZUPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 16:15:17 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:13734 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760199AbYCZUPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:15:13 -0400
Date: Wed, 26 Mar 2008 13:13:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: devzero@web.de
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, alan@lxorguk.ukuu.org.uk,
       david-b@pacbell.net, greg@kroah.com, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: some minor issues with 2.6.25-rc6-git7-default
Message-Id: <20080326131346.39efee07.randy.dunlap@oracle.com>
In-Reply-To: <213294492@web.de>
References: <213294492@web.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Mar 2008 20:48:52 +0100 devzero@web.de wrote:

> > > > ACPI: ACPI0007:00 is registered as cooling_device0
> > > > ACPI: Processor [CPU0] (supports 8 throttling states)
> > > > BUG: unable to handle kernel paging request at 1b563b0c
> > > > IP: [<c020000f>] acpi_ps_execute_method+0xc4/0x1f9
> > > > *pde = 00000000
> > > > Oops: 0002 [#1] SMP
> > > > Modules linked in: ac(+) sg ahci libata dock sha1_generic michael_mic xcbc crc32c deflate zlib_deflate
> > > > tgr192 wp512 sha512 seed camellia fcrypt pcbc khazad tea arc4 cast6 cast5 xts gf128mul serpent blowfish
> > > > sha256_generic md4 cbc des_generic ecb crypto_blkcipher snd_seq_dummy snd_seq snd_timer snd_seq_device
> > > > snd soundcore parkbd eni suni zatm uPD98402 atm lm70 hwmon ip2 ip2main parport_pc parport 8250_exar_st16c554
> > > > 8250_accent 8250_hub6 8250_boca 8250_fourport ide_generic hpt366 alim15x3 jmicron pdc202xx_new cs5535 aec62xx
> > > > atiixp cs5520 it821x cs5530 hpt34x opti621 trm290 amd74xx ns87415 rz1000 pdc202xx_old via82cxxx triflex cmd64x
> > > > it8213 cy82c693 slc90e66 sc1200 serverworks sis5513 siimage ide_cd_mod cdrom mdacon capifs sctp libcrc32c
> > > > 9pnet_fd 9pnet sunrpc decnet dccp_ipv6 dccp_ipv4 dccp ipv6 fuse ide_pci_generic pcnet32 piix mii intel_agp
> > > > ide_core agpgart ext3 mbcache jbd mptspi mptscsih mptbase scsi_transport_spi sd_mod scsi_mod [last unloaded: sbshc]
> > > > 
> > > > Pid: 14520, comm: modprobe Tainted: P         (2.6.25-rc6-git7-default #1)
> > 
> > What caused the taint?
> 
> i don`t know. it`s completely fresh compiled kernel, vanilla source. no binary modules .
> can module-init tools be a reason? i upgraded that package because of depmod memory issue (https://bugzilla.novell.com/show_bug.cgi?id=371966 ). depmod was using >500mb on my system.

Can you post the full kernel log up to this BUG?
It should show that causes the Taint.

> oh - and i didn`t tell that i`m in vmware, so this my trigger bugs which doesn`t easily happen on real hardware due to timing.
> 
> 
> > > > EIP: 0060:[<c020000f>] EFLAGS: 00010206 CPU: 0
> > > > EIP is at acpi_ps_execute_method+0xc4/0x1f9
> > > > EAX: 1b563b0c EBX: 00000000 ECX: 0000ffff EDX: 00000093
> > > > ESI: d41a6240 EDI: c032c726 EBP: 00000000 ESP: df881d98
> > > >  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > > > Process modprobe (pid: 14520, ti=df880000 task=ddb458f0 task.ti=df880000)
> > > > Stack: ffffffff c032d513 df020c8c df020c84 df021844 d41a6250 d41a6240 c032c726
> > > >        00000000 c01fc910 00001001 d41a6240 e085f44c 00000000 c01fc44b e085f44c
> > > >        df020ce8 d41a6a20 d41a6a20 00000004 e085f44c df020ce8 c01ec145 df881dfc
> > > > Call Trace:
> > > >  [<c01fc910>] acpi_ns_evaluate+0x104/0x1a0
> > > >  [<c01fc44b>] acpi_evaluate_object+0x16f/0x244
> > > >  [<c01ec145>] acpi_evaluate_integer+0x84/0x104
> > > >  [<e085f038>] acpi_ac_get_state+0x22/0x53 [ac]
> > > >  [<e085f20e>] acpi_ac_add+0x63/0x15a [ac]
> > > >  [<c0207f4d>] acpi_device_probe+0x37/0xcd
> > > >  [<c022dd2b>] driver_probe_device+0x9d/0x114
> > > >  [<c022de86>] __driver_attach+0x52/0x87
> > > >  [<c022d36b>] bus_for_each_dev+0x31/0x52
> > > >  [<c022dbde>] driver_attach+0x11/0x13
> > > >  [<c022de34>] __driver_attach+0x0/0x87
> > > >  [<c022da1e>] bus_add_driver+0x91/0x193
> > > >  [<c022e039>] driver_register+0x45/0x9a
> > > >  [<e0863021>] acpi_ac_init+0x21/0x39 [ac]
> > > >  [<c013c1de>] sys_init_module+0x16b6/0x17c9
> > > >  [<c0208280>] acpi_bus_register_driver+0x0/0x38
> > > >  [<c0108a6a>] sys_mmap2+0x62/0x77
> > > >  [<c01059c4>] sysenter_past_esp+0x6d/0xa9
> > > >  =======================
> > > > Code: c0 b8 01 00 00 00 e8 f9 53 00 00 ff 76 08 8b 46 10 50 83 c0 08 50 68 13 d5 32 c0 6a ff 00 00 00 c2 2d 
> > > > c0 68 b0 c2 2d c0 68 fb 00 <00> 00 6a 40 e8 82 2a 00 00 83 c4 24 e8 93 fe ff ff 85 c0 89 c5
> > > > EIP: [<c020000f>] acpi_ps_execute_method+0xc4/0x1f9 SS:ESP 0068:df881d98
> > 
> > This is the serious one.
> 
> unfortunately i wasn`t yet able to reproduce :(

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

> > > CCing Dave Brownell.
> > > 
> > > > Mar 23 09:14:23 opensuse103 kernel: Generic RTC Driver v1.07
> > > > Mar 23 09:14:23 opensuse103 kernel: proc_dir_entry 'rtc' already registered
> > > > Mar 23 09:14:23 opensuse103 kernel: Pid: 3994, comm: modprobe Tainted: P         2.6.25-rc6-git7-default #1
> > > > Mar 23 09:14:23 opensuse103 kernel:  [<c019a602>] proc_register+0xf3/0x11f
> > > > Mar 23 09:14:23 opensuse103 kernel:  [<c019a719>] create_proc_entry+0x69/0x7b
> > > > Mar 23 09:14:23 opensuse103 kernel:  [<e0c5f02d>] rtc_generic_init+0x2d/0x54 [genrtc]
> > > > Mar 23 09:14:23 opensuse103 kernel:  [<c013c1de>] sys_init_module+0x16b6/0x17c9
> > > > Mar 23 09:14:23 opensuse103 kernel:  [<c0108a6a>] sys_mmap2+0x62/0x77
> > > > Mar 23 09:14:23 opensuse103 kernel:  [<c01059c4>] sysenter_past_esp+0x6d/0xa9
> > > > Mar 23 09:14:23 opensuse103 kernel:  =======================
> > 
> > uh, "known problem": multiple rtc drivers are being run.
> > 
> > I don't really understand why we haven't been able to fix this - there have
> > been numerous reports..
> 
> i will take a closer look to determine how/when this happens.

I thought that David B. sent a (Kconfig ?) patch for this...

---
~Randy
