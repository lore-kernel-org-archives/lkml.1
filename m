Return-Path: <linux-kernel-owner+w=401wt.eu-S1759579AbXIXPdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579AbXIXPdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 11:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755813AbXIXPdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 11:33:23 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59639 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798AbXIXPdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 11:33:22 -0400
Date: Mon, 24 Sep 2007 16:33:19 +0100
To: Branislav Bozgai <branislav@bozgai.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel bug
Message-ID: <20070924153319.GA32550@skynet.ie>
References: <46F19806.7080207@bozgai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <46F19806.7080207@bozgai.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (19/09/07 17:43), Branislav Bozgai didst pronounce:
> uname -a
> Linux tweety 2.6.21.3-default #2 Tue Aug 7 17:11:50 EDT 2007 i686 athlon 
> i386 GNU/Linux
> Hello, my system is crashing with following info in /var/log/messages, 
> thought I send it to you.

Does this happen after suspend/resume by any chance? I ask because it
looks vagely similar to
http://groups.google.com/group/linux.kernel/browse_thread/thread/7aa897981d7d440f
.

The first error is interesting, the other ones look like slab lists have
been hosed. Just to rule it out, have you run memtest+ on your machine
to make sure you RAM is healthy?

> Sep 19 17:05:33 tweety kernel: BUG: unable to handle kernel paging request at virtual address 07e07fbc
> Sep 19 17:05:33 tweety kernel:  printing eip:
> Sep 19 17:05:33 tweety kernel: c0154707
> Sep 19 17:05:33 tweety kernel: *pde = 00000000
> Sep 19 17:05:33 tweety kernel: Oops: 0000 [#1]
> Sep 19 17:05:33 tweety kernel: Modules linked in: xt_tcpudp iptable_filter ip_tables x_tables joydev st ide_cd capability commoncap nfsd exportfs lockd nfs_acl sunrpc it87 hwmon_vid i2c_isa i2c_core cpufreq_conservative cpufreq_ondemand cpufreq_powersave powernow_k8 freq_table button battery ac loop dm_mod sg sr_mod cdrom sd_mod generic usbhid ff_memless sis5513 sata_sis 3c59x mii k8temp hwmon ehci_hcd shpchp pata_sis ohci_hcd pci_hotplug libata sis_agp usbcore scsi_mod agpgart e1000 parport_pc lp parport ext3 mbcache jbd linear raid456 xor raid0 edd fan siimage alim15x3 thermal processor ide_disk ide_core
> Sep 19 17:05:33 tweety kernel: CPU:    0
> Sep 19 17:05:33 tweety kernel: EIP:    0060:[<c0154707>]    Not tainted VLI
> Sep 19 17:05:33 tweety kernel: EFLAGS: 00010003   (2.6.21.3-default #2)
> Sep 19 17:05:33 tweety kernel: EIP is at cache_alloc_refill+0xef/0x3f2
> Sep 19 17:05:33 tweety kernel: eax: 0000002a   ebx: 09c123e8   ecx: 00000006   edx: 143baaf4
> Sep 19 17:05:33 tweety kernel: esi: e0dbf000   edi: f7f0dd40   ebp: f7f09000   esp: eb173ed8
> Sep 19 17:05:33 tweety kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Sep 19 17:05:33 tweety kernel: Process sshd (pid: 15749, ti=eb172000 task=f476f030 task.ti=eb172000)
> Sep 19 17:05:33 tweety kernel: Stack: 00000029 000000d0 f7f07c40 00000000 00000035 e74d2200 c945ab7c df03fb7c 
> Sep 19 17:05:33 tweety kernel:        b7d25000 b7d2f000 00000246 000000d0 f7f07c40 cb5cb030 c015460e 00000003 
> Sep 19 17:05:33 tweety kernel:        dc7e2320 00000003 c0117379 c6c9f6d4 00000000 f8c58000 eb173fb8 bf8b9c70 
> Sep 19 17:05:33 tweety kernel: Call Trace:
> Sep 19 17:05:33 tweety kernel:  [<c015460e>] kmem_cache_alloc+0x36/0x40
> Sep 19 17:05:33 tweety kernel:  [<c0117379>] copy_process+0x8e5/0xeea
> Sep 19 17:05:33 tweety kernel:  [<c0117bae>] do_fork+0x9e/0x17d
> Sep 19 17:05:33 tweety kernel:  [<c01031cd>] sys_clone+0x32/0x36
> Sep 19 17:05:33 tweety kernel:  [<c0104aa0>] sysenter_past_esp+0x5d/0x81
> Sep 19 17:05:33 tweety kernel:  =======================
> Sep 19 17:05:33 tweety kernel: Code: 10 c7 47 30 01 00 00 00 39 c6 75 2e e9 8a 00 00 00 8b 44 24 08 8b 5e 14 8b 4d 00 8b 50 10 8b 04 24 0f af d3 40 03 56 0c 89 46 10 <8b> 44 9e 1c 89 46 14 89 54 8d 10 41 89 4d 00 8b 56 10 8b 4c 24 
> Sep 19 17:05:33 tweety kernel: EIP: [<c0154707>] cache_alloc_refill+0xef/0x3f2 SS:ESP 0068:eb173ed8
> Sep 19 17:05:33 tweety kernel: ------------[ cut here ]------------
> Sep 19 17:05:33 tweety kernel: kernel BUG at mm/slab.c:597!
> Sep 19 17:05:33 tweety kernel: invalid opcode: 0000 [#2]
> Sep 19 17:05:33 tweety kernel: Modules linked in: xt_tcpudp iptable_filter ip_tables x_tables joydev st ide_cd capability commoncap nfsd exportfs lockd nfs_acl sunrpc it87 hwmon_vid i2c_isa i2c_core cpufreq_conservative cpufreq_ondemand cpufreq_powersave powernow_k8 freq_table button battery ac loop dm_mod sg sr_mod cdrom sd_mod generic usbhid ff_memless sis5513 sata_sis 3c59x mii k8temp hwmon ehci_hcd shpchp pata_sis ohci_hcd pci_hotplug libata sis_agp usbcore scsi_mod agpgart e1000 parport_pc lp parport ext3 mbcache jbd linear raid456 xor raid0 edd fan siimage alim15x3 thermal processor ide_disk ide_core
> Sep 19 17:05:33 tweety kernel: CPU:    0
> Sep 19 17:05:33 tweety kernel: EIP:    0060:[<c01541d3>]    Not tainted VLI
> Sep 19 17:05:33 tweety kernel: EFLAGS: 00210202   (2.6.21.3-default #2)
> Sep 19 17:05:33 tweety kernel: EIP is at kmem_cache_free+0x29/0x5a
> Sep 19 17:05:33 tweety kernel: eax: 40000868   ebx: e0fbb728   ecx: f7f07c40   edx: c141f760
> Sep 19 17:05:33 tweety kernel: esi: 00000000   edi: e0fbb728   ebp: e973f710   esp: ea173f64
> Sep 19 17:05:33 tweety kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Sep 19 17:05:33 tweety kernel: Process postmaster (pid: 3842, ti=ea172000 task=f09a7030 task.ti=ea172000)
> Sep 19 17:05:33 tweety kernel: Stack: e0fbb728 00000000 e0fbb728 c0149eef f3a00900 e0fbb728 c014a821 ffffffff 
> Sep 19 17:05:33 tweety kernel:        b7f57000 b7f56000 b7f57000 e973f71c e973f710 f3a00900 f3a00934 00000000 
> Sep 19 17:05:33 tweety kernel:        ea172000 c014a86a b7f56000 0835a640 c0104aa0 b7f56000 00001000 b7c7cff4 
> Sep 19 17:05:33 tweety kernel: Call Trace:
> Sep 19 17:05:33 tweety kernel:  [<c0149eef>] remove_vma+0x36/0x3b
> Sep 19 17:05:33 tweety kernel:  [<c014a821>] do_munmap+0x19d/0x1b6
> Sep 19 17:05:33 tweety kernel:  [<c014a86a>] sys_munmap+0x30/0x3e
> Sep 19 17:05:33 tweety kernel:  [<c0104aa0>] sysenter_past_esp+0x5d/0x81
> Sep 19 17:05:33 tweety kernel:  =======================
> Sep 19 17:05:33 tweety kernel: Code: 5f c3 57 89 d7 8d 92 00 00 00 40 89 c1 c1 ea 0c 56 c1 e2 05 03 15 c0 8a 3a c0 53 8b 02 f6 c4 40 74 03 8b 52 0c 8b 02 84 c0 78 04 <0f> 0b eb fe 39 4a 18 74 04 0f 0b eb fe 9c 5e fa 8b 19 8b 03 3b 
> Sep 19 17:05:33 tweety kernel: EIP: [<c01541d3>] kmem_cache_free+0x29/0x5a SS:ESP 0068:ea173f64
> Sep 19 17:05:34 tweety kernel: ------------[ cut here ]------------
> Sep 19 17:05:34 tweety kernel: kernel BUG at mm/slab.c:3751!
> Sep 19 17:05:34 tweety kernel: invalid opcode: 0000 [#3]
> Sep 19 17:05:34 tweety kernel: Modules linked in: xt_tcpudp iptable_filter ip_tables x_tables joydev st ide_cd capability commoncap nfsd exportfs lockd nfs_acl sunrpc it87 hwmon_vid i2c_isa i2c_core cpufreq_conservative cpufreq_ondemand cpufreq_powersave powernow_k8 freq_table button battery ac loop dm_mod sg sr_mod cdrom sd_mod generic usbhid ff_memless sis5513 sata_sis 3c59x mii k8temp hwmon ehci_hcd shpchp pata_sis ohci_hcd pci_hotplug libata sis_agp usbcore scsi_mod agpgart e1000 parport_pc lp parport ext3 mbcache jbd linear raid456 xor raid0 edd fan siimage alim15x3 thermal processor ide_disk ide_core
> Sep 19 17:05:34 tweety kernel: CPU:    0
> Sep 19 17:05:34 tweety kernel: EIP:    0060:[<c01541dc>]    Not tainted VLI
> Sep 19 17:05:34 tweety kernel: EFLAGS: 00010202   (2.6.21.3-default #2)
> Sep 19 17:05:34 tweety kernel: EIP is at kmem_cache_free+0x32/0x5a
> Sep 19 17:05:34 tweety kernel: eax: 40000080   ebx: e0dbe2d4   ecx: f7f07c40   edx: c141b7c0
> Sep 19 17:05:34 tweety kernel: esi: 00000000   edi: e0dbe2d4   ebp: c7e2856c   esp: c7f9ff64
> Sep 19 17:05:34 tweety kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Sep 19 17:05:34 tweety kernel: Process fail2ban-server (pid: 7803, ti=c7f9e000 task=f2325a70 task.ti=c7f9e000)
> Sep 19 17:05:34 tweety kernel: Stack: e0dbe2d4 00000000 e0dbe2d4 c0149eef c815bac0 e0dbe2d4 c014a821 ffffffff 
> Sep 19 17:05:34 tweety kernel:        b7bc3000 b7bc2000 b7bc3000 c7e28578 c7e2856c c815bac0 c815baf4 00000000 
> Sep 19 17:05:34 tweety kernel:        c7f9e000 c014a86a b7bc2000 08136d38 c0104aa0 b7bc2000 00001000 b7ddbff4 
> Sep 19 17:05:34 tweety kernel: Call Trace:
> Sep 19 17:05:34 tweety kernel:  [<c0149eef>] remove_vma+0x36/0x3b
> Sep 19 17:05:34 tweety kernel:  [<c014a821>] do_munmap+0x19d/0x1b6
> Sep 19 17:05:34 tweety kernel:  [<c014a86a>] sys_munmap+0x30/0x3e
> Sep 19 17:05:34 tweety kernel:  [<c0104aa0>] sysenter_past_esp+0x5d/0x81
> Sep 19 17:05:34 tweety kernel:  =======================
> Sep 19 17:05:34 tweety kernel: Code: 00 40 89 c1 c1 ea 0c 56 c1 e2 05 03 15 c0 8a 3a c0 53 8b 02 f6 c4 40 74 03 8b 52 0c 8b 02 84 c0 78 04 0f 0b eb fe 39 4a 18 74 04 <0f> 0b eb fe 9c 5e fa 8b 19 8b 03 3b 43 04 72 0b 89 c8 89 da e8 
> Sep 19 17:05:34 tweety kernel: EIP: [<c01541dc>] kmem_cache_free+0x32/0x5a SS:ESP 0068:c7f9ff64
> Sep 19 17:05:35 tweety kernel: ------------[ cut here ]------------
> Sep 19 17:05:35 tweety kernel: kernel BUG at mm/slab.c:3751!
> Sep 19 17:05:35 tweety kernel: invalid opcode: 0000 [#4]
> Sep 19 17:05:35 tweety kernel: Modules linked in: xt_tcpudp iptable_filter ip_tables x_tables joydev st ide_cd capability commoncap nfsd exportfs lockd nfs_acl sunrpc it87 hwmon_vid i2c_isa i2c_core cpufreq_conservative cpufreq_ondemand cpufreq_powersave powernow_k8 freq_table button battery ac loop dm_mod sg sr_mod cdrom sd_mod generic usbhid ff_memless sis5513 sata_sis 3c59x mii k8temp hwmon ehci_hcd shpchp pata_sis ohci_hcd pci_hotplug libata sis_agp usbcore scsi_mod agpgart e1000 parport_pc lp parport ext3 mbcache jbd linear raid456 xor raid0 edd fan siimage alim15x3 thermal processor ide_disk ide_core
> Sep 19 17:05:35 tweety kernel: CPU:    0
> Sep 19 17:05:35 tweety kernel: EIP:    0060:[<c01541dc>]    Not tainted VLI
> Sep 19 17:05:35 tweety kernel: EFLAGS: 00210287   (2.6.21.3-default #2)
> Sep 19 17:05:35 tweety kernel: EIP is at kmem_cache_free+0x32/0x5a
> Sep 19 17:05:35 tweety kernel: eax: 40000080   ebx: e0edfaa4   ecx: f7f07c40   edx: c141dbe0
> Sep 19 17:05:35 tweety kernel: esi: 00000000   edi: e0edfaa4   ebp: de5ed7b8   esp: def41f64
> Sep 19 17:05:35 tweety kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Sep 19 17:05:35 tweety kernel: Process indexer (pid: 4276, ti=def40000 task=e3ef1550 task.ti=def40000)
> Sep 19 17:05:35 tweety kernel: Stack: e0edfaa4 00000000 e0edfaa4 c0149eef dfa28c80 e0edfaa4 c014a821 ffffffff 
> Sep 19 17:05:35 tweety kernel:        b7ed2000 b7ed1000 b7ed2000 de5ed7c4 de5ed7b8 dfa28c80 dfa28cb4 00000000 
> Sep 19 17:05:35 tweety kernel:        def40000 c014a86a b7ed1000 08051ec8 c0104aa0 b7ed1000 00001000 b7ea1ff4 
> Sep 19 17:05:35 tweety kernel: Call Trace:
> Sep 19 17:05:35 tweety kernel:  [<c0149eef>] remove_vma+0x36/0x3b
> Sep 19 17:05:35 tweety kernel:  [<c014a821>] do_munmap+0x19d/0x1b6
> Sep 19 17:05:35 tweety kernel:  [<c014a86a>] sys_munmap+0x30/0x3e
> Sep 19 17:05:35 tweety kernel:  [<c0104aa0>] sysenter_past_esp+0x5d/0x81
> Sep 19 17:05:35 tweety kernel:  =======================
> Sep 19 17:05:35 tweety kernel: Code: 00 40 89 c1 c1 ea 0c 56 c1 e2 05 03 15 c0 8a 3a c0 53 8b 02 f6 c4 40 74 03 8b 52 0c 8b 02 84 c0 78 04 0f 0b eb fe 39 4a 18 74 04 <0f> 0b eb fe 9c 5e fa 8b 19 8b 03 3b 43 04 72 0b 89 c8 89 da e8 
> Sep 19 17:05:35 tweety kernel: EIP: [<c01541dc>] kmem_cache_free+0x32/0x5a SS:ESP 0068:def41f64
> Sep 19 17:05:36 tweety kernel: BUG: unable to handle kernel paging request at virtual address 07e07fbc
> Sep 19 17:05:36 tweety kernel:  printing eip:
> Sep 19 17:05:36 tweety kernel: c0154707
> Sep 19 17:05:36 tweety kernel: *pde = 00000000
> Sep 19 17:05:36 tweety kernel: Oops: 0000 [#5]
> Sep 19 17:05:36 tweety kernel: Modules linked in: xt_tcpudp iptable_filter ip_tables x_tables joydev st ide_cd capability commoncap nfsd exportfs lockd nfs_acl sunrpc it87 hwmon_vid i2c_isa i2c_core cpufreq_conservative cpufreq_ondemand cpufreq_powersave powernow_k8 freq_table button battery ac loop dm_mod sg sr_mod cdrom sd_mod generic usbhid ff_memless sis5513 sata_sis 3c59x mii k8temp hwmon ehci_hcd shpchp pata_sis ohci_hcd pci_hotplug libata sis_agp usbcore scsi_mod agpgart e1000 parport_pc lp parport ext3 mbcache jbd linear raid456 xor raid0 edd fan siimage alim15x3 thermal processor ide_disk ide_core
> Sep 19 17:05:36 tweety kernel: CPU:    0
> Sep 19 17:05:36 tweety kernel: EIP:    0060:[<c0154707>]    Not tainted VLI
> Sep 19 17:05:36 tweety kernel: EFLAGS: 00010003   (2.6.21.3-default #2)
> Sep 19 17:05:36 tweety kernel: EIP is at cache_alloc_refill+0xef/0x3f2
> Sep 19 17:05:36 tweety kernel: eax: 0000002b   ebx: 09c123e8   ecx: 00000000   edx: 143baaf4
> Sep 19 17:05:36 tweety kernel: esi: e0dbf000   edi: f7f0dd40   ebp: f7f09000   esp: c0e67ed8
> Sep 19 17:05:36 tweety kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Sep 19 17:05:36 tweety kernel: Process stunnel (pid: 19365, ti=c0e66000 task=f2325550 task.ti=c0e66000)
> Sep 19 17:05:36 tweety kernel: Stack: 0000002a 000000d0 f7f07c40 00000000 0000003b dcd5e740 f474a800 f2199800 
> Sep 19 17:05:36 tweety kernel:        8008d000 8008d000 00000246 000000d0 f7f07c40 dd374550 c015460e 00000021 
> Sep 19 17:05:36 tweety kernel:        d03e741c 00000021 c0117379 c46422e4 f7a63a14 f6788180 c0e67fb8 b7ee4e24 
> Sep 19 17:05:36 tweety kernel: Call Trace:
> Sep 19 17:05:36 tweety kernel:  [<c015460e>] kmem_cache_alloc+0x36/0x40
> Sep 19 17:05:36 tweety kernel:  [<c0117379>] copy_process+0x8e5/0xeea
> Sep 19 17:05:36 tweety kernel:  [<c0117bae>] do_fork+0x9e/0x17d
> Sep 19 17:05:36 tweety kernel:  [<c01031cd>] sys_clone+0x32/0x36
> Sep 19 17:05:36 tweety kernel:  [<c0104aa0>] sysenter_past_esp+0x5d/0x81
> Sep 19 17:05:36 tweety kernel:  =======================
> Sep 19 17:05:36 tweety kernel: Code: 10 c7 47 30 01 00 00 00 39 c6 75 2e e9 8a 00 00 00 8b 44 24 08 8b 5e 14 8b 4d 00 8b 50 10 8b 04 24 0f af d3 40 03 56 0c 89 46 10 <8b> 44 9e 1c 89 46 14 89 54 8d 10 41 89 4d 00 8b 56 10 8b 4c 24 
> Sep 19 17:05:36 tweety kernel: EIP: [<c0154707>] cache_alloc_refill+0xef/0x3f2 SS:ESP 0068:c0e67ed8
> Sep 19 17:05:39 tweety kernel: BUG: unable to handle kernel paging request at virtual address 07e07fbc
> Sep 19 17:05:39 tweety kernel:  printing eip:
> Sep 19 17:05:39 tweety kernel: c0154707
> Sep 19 17:05:39 tweety kernel: *pde = 00000000
> Sep 19 17:05:39 tweety kernel: Oops: 0000 [#6]
> Sep 19 17:05:39 tweety kernel: Modules linked in: xt_tcpudp iptable_filter ip_tables x_tables joydev st ide_cd capability commoncap nfsd exportfs lockd nfs_acl sunrpc it87 hwmon_vid i2c_isa i2c_core cpufreq_conservative cpufreq_ondemand cpufreq_powersave powernow_k8 freq_table button battery ac loop dm_mod sg sr_mod cdrom sd_mod generic usbhid ff_memless sis5513 sata_sis 3c59x mii k8temp hwmon ehci_hcd shpchp pata_sis ohci_hcd pci_hotplug libata sis_agp usbcore scsi_mod agpgart e1000 parport_pc lp parport ext3 mbcache jbd linear raid456 xor raid0 edd fan siimage alim15x3 thermal processor ide_disk ide_core
> Sep 19 17:05:39 tweety kernel: CPU:    0
> Sep 19 17:05:39 tweety kernel: EIP:    0060:[<c0154707>]    Not tainted VLI
> Sep 19 17:05:39 tweety kernel: EFLAGS: 00010003   (2.6.21.3-default #2)
> Sep 19 17:05:39 tweety kernel: EIP is at cache_alloc_refill+0xef/0x3f2
> Sep 19 17:05:39 tweety kernel: eax: 0000002c   ebx: 09c123e8   ecx: 00000000   edx: 143baaf4
> Sep 19 17:05:39 tweety kernel: esi: e0dbf000   edi: f7f0dd40   ebp: f7f09000   esp: e92c5ef8
> Sep 19 17:05:39 tweety kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Sep 19 17:05:39 tweety kernel: Process nscd (pid: 4021, ti=e92c4000 task=f0255030 task.ti=e92c4000)
> Sep 19 17:05:39 tweety kernel: Stack: 0000002b 000000d0 f7f07c40 00000000 0000003b 00000000 00000000 00000000 
> Sep 19 17:05:39 tweety kernel:        e63f9374 e518acf8 000000d0 f7f07c40 00000246 00000000 c0154aa7 f8e40e40 
> Sep 19 17:05:39 tweety kernel:        00100073 fffffff4 c014b4f8 b7fa5000 00100073 00000000 00000000 000b7fa4 
> Sep 19 17:05:39 tweety kernel: Call Trace:
> Sep 19 17:05:39 tweety kernel:  [<c0154aa7>] kmem_cache_zalloc+0x36/0x63
> Sep 19 17:05:39 tweety kernel:  [<c014b4f8>] do_mmap_pgoff+0x3a6/0x6e4
> Sep 19 17:05:39 tweety kernel:  [<c010803c>] sys_mmap2+0x66/0xb7
> Sep 19 17:05:39 tweety kernel:  [<c0104aa0>] sysenter_past_esp+0x5d/0x81
> Sep 19 17:05:39 tweety kernel:  =======================
> Sep 19 17:05:39 tweety kernel: Code: 10 c7 47 30 01 00 00 00 39 c6 75 2e e9 8a 00 00 00 8b 44 24 08 8b 5e 14 8b 4d 00 8b 50 10 8b 04 24 0f af d3 40 03 56 0c 89 46 10 <8b> 44 9e 1c 89 46 14 89 54 8d 10 41 89 4d 00 8b 56 10 8b 4c 24 
> Sep 19 17:05:39 tweety kernel: EIP: [<c0154707>] cache_alloc_refill+0xef/0x3f2 SS:ESP 0068:e92c5ef8
> Sep 19 17:05:44 tweety kernel: BUG: unable to handle kernel paging request at virtual address 07e07fbc
> Sep 19 17:05:44 tweety kernel:  printing eip:
> Sep 19 17:05:44 tweety kernel: c0154707
> Sep 19 17:05:44 tweety kernel: *pde = 00000000
> Sep 19 17:05:44 tweety kernel: Oops: 0000 [#7]
> Sep 19 17:05:44 tweety kernel: Modules linked in: xt_tcpudp iptable_filter ip_tables x_tables joydev st ide_cd capability commoncap nfsd exportfs lockd nfs_acl sunrpc it87 hwmon_vid i2c_isa i2c_core cpufreq_conservative cpufreq_ondemand cpufreq_powersave powernow_k8 freq_table button battery ac loop dm_mod sg sr_mod cdrom sd_mod generic usbhid ff_memless sis5513 sata_sis 3c59x mii k8temp hwmon ehci_hcd shpchp pata_sis ohci_hcd pci_hotplug libata sis_agp usbcore scsi_mod agpgart e1000 parport_pc lp parport ext3 mbcache jbd linear raid456 xor raid0 edd fan siimage alim15x3 thermal processor ide_disk ide_core
> Sep 19 17:05:44 tweety kernel: CPU:    0
> Sep 19 17:05:44 tweety kernel: EIP:    0060:[<c0154707>]    Not tainted VLI
> Sep 19 17:05:44 tweety kernel: EFLAGS: 00010003   (2.6.21.3-default #2)
> Sep 19 17:05:44 tweety kernel: EIP is at cache_alloc_refill+0xef/0x3f2
> Sep 19 17:05:44 tweety kernel: eax: 0000002d   ebx: 09c123e8   ecx: 00000000   edx: 143baaf4
> Sep 19 17:05:44 tweety kernel: esi: e0dbf000   edi: f7f0dd40   ebp: f7f09000   esp: ce9a7ed8
> Sep 19 17:05:44 tweety kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Sep 19 17:05:44 tweety kernel: Process bash (pid: 15980, ti=ce9a6000 task=e1840030 task.ti=ce9a6000)
> Sep 19 17:05:44 tweety kernel: Stack: 0000002c 000000d0 f7f07c40 00000000 0000003b f7a2b740 d427bb7c e8511b7c 
> Sep 19 17:05:44 tweety kernel:        b7f04000 b7f07000 00000246 000000d0 f7f07c40 d6299a70 c015460e ca3c1d4c 
> Sep 19 17:05:44 tweety kernel:        c841af98 00000000 c0117379 ca3c10ec 000000d0 f7f0ff40 ce9a7fb8 bfec6418 
> Sep 19 17:05:44 tweety kernel: Call Trace:
> Sep 19 17:05:44 tweety kernel:  [<c015460e>] kmem_cache_alloc+0x36/0x40
> Sep 19 17:05:44 tweety kernel:  [<c0117379>] copy_process+0x8e5/0xeea
> Sep 19 17:05:44 tweety kernel:  [<c0117bae>] do_fork+0x9e/0x17d
> Sep 19 17:05:44 tweety kernel:  [<c01b05f9>] copy_to_user+0x2d/0x44
> Sep 19 17:05:44 tweety kernel:  [<c01031cd>] sys_clone+0x32/0x36
> Sep 19 17:05:44 tweety kernel:  [<c0104aa0>] sysenter_past_esp+0x5d/0x81
> Sep 19 17:05:44 tweety kernel:  =======================
> Sep 19 17:05:44 tweety kernel: Code: 10 c7 47 30 01 00 00 00 39 c6 75 2e e9 8a 00 00 00 8b 44 24 08 8b 5e 14 8b 4d 00 8b 50 10 8b 04 24 0f af d3 40 03 56 0c 89 46 10 <8b> 44 9e 1c 89 46 14 89 54 8d 10 41 89 4d 00 8b 56 10 8b 4c 24 
> Sep 19 17:05:44 tweety kernel: EIP: [<c0154707>] cache_alloc_refill+0xef/0x3f2 SS:ESP 0068:ce9a7ed8
> Sep 19 17:05:45 tweety kernel: BUG: unable to handle kernel paging request at virtual address 07e07fbc
> Sep 19 17:05:45 tweety kernel:  printing eip:
> Sep 19 17:05:45 tweety kernel: c0154707
> Sep 19 17:05:45 tweety kernel: *pde = 00000000
> Sep 19 17:05:45 tweety kernel: Oops: 0000 [#8]
> Sep 19 17:05:45 tweety kernel: Modules linked in: xt_tcpudp iptable_filter ip_tables x_tables joydev st ide_cd capability commoncap nfsd exportfs lockd nfs_acl sunrpc it87 hwmon_vid i2c_isa i2c_core cpufreq_conservative cpufreq_ondemand cpufreq_powersave powernow_k8 freq_table button battery ac loop dm_mod sg sr_mod cdrom sd_mod generic usbhid ff_memless sis5513 sata_sis 3c59x mii k8temp hwmon ehci_hcd shpchp pata_sis ohci_hcd pci_hotplug libata sis_agp usbcore scsi_mod agpgart e1000 parport_pc lp parport ext3 mbcache jbd linear raid456 xor raid0 edd fan siimage alim15x3 thermal processor ide_disk ide_core
> Sep 19 17:05:45 tweety kernel: CPU:    0
> Sep 19 17:05:45 tweety kernel: EIP:    0060:[<c0154707>]    Not tainted VLI
> Sep 19 17:05:45 tweety kernel: EFLAGS: 00210003   (2.6.21.3-default #2)
> Sep 19 17:05:45 tweety kernel: EIP is at cache_alloc_refill+0xef/0x3f2
> Sep 19 17:05:45 tweety kernel: eax: 0000002e   ebx: 09c123e8   ecx: 00000000   edx: 143baaf4
> Sep 19 17:05:45 tweety kernel: esi: e0dbf000   edi: f7f0dd40   ebp: f7f09000   esp: d5803f18
> Sep 19 17:05:45 tweety kernel: ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Sep 19 17:05:45 tweety kernel: Process snmpd (pid: 5184, ti=d5802000 task=dd1cca70 task.ti=d5802000)
> Sep 19 17:05:45 tweety kernel: Stack: 0000002d 000000d0 f7f07c40 00000000 0000003b b7ee1000 dffceac4 c011d19b 
> Sep 19 17:05:45 tweety kernel:        b7ee1000 d5803f64 00200246 000000d0 f7f07c40 00000001 c015460e d29c5e40 
> Sep 19 17:05:45 tweety kernel:        e0fc656c b7ee2000 c014a5fd 00000010 c73d569c d29c5e40 e0fc656c b7ee2000 
> Sep 19 17:05:45 tweety kernel: Call Trace:
> Sep 19 17:05:45 tweety kernel:  [<c011d19b>] proc_dointvec_ms_jiffies+0x30/0x35
> Sep 19 17:05:45 tweety kernel:  [<c015460e>] kmem_cache_alloc+0x36/0x40
> Sep 19 17:05:45 tweety kernel:  [<c014a5fd>] split_vma+0x46/0xcd
> Sep 19 17:05:45 tweety kernel:  [<c014a74e>] do_munmap+0xca/0x1b6
> Sep 19 17:05:45 tweety kernel:  [<c0167e19>] mntput_no_expire+0x11/0x59
> Sep 19 17:05:45 tweety kernel:  [<c01558ec>] filp_close+0x51/0x58
> Sep 19 17:05:45 tweety kernel:  [<c014a86a>] sys_munmap+0x30/0x3e
> Sep 19 17:05:45 tweety kernel:  [<c0104aa0>] sysenter_past_esp+0x5d/0x81
> Sep 19 17:05:45 tweety kernel:  =======================
> Sep 19 17:05:45 tweety kernel: Code: 10 c7 47 30 01 00 00 00 39 c6 75 2e e9 8a 00 00 00 8b 44 24 08 8b 5e 14 8b 4d 00 8b 50 10 8b 04 24 0f af d3 40 03 56 0c 89 46 10 <8b> 44 9e 1c 89 46 14 89 54 8d 10 41 89 4d 00 8b 56 10 8b 4c 24 
> Sep 19 17:05:45 tweety kernel: EIP: [<c0154707>] cache_alloc_refill+0xef/0x3f2 SS:ESP 0068:d5803f18

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
