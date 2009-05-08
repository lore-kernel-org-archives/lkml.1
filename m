Return-Path: <linux-kernel-owner+w=401wt.eu-S1765068AbZEHAor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765068AbZEHAor (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:44:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932441AbZEHAgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:36:53 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:48135 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425AbZEHAgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:36:51 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: linux-kernel@vger.kernel.org
Subject: rocket tty BUG in 2.6.29 (regression)
Date: Fri, 08 May 2009 02:36:45 +0200
Message-ID: <8763gcsa5e.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2.6.26 works fine in our terminal server machine, but after rebooting
it into 2.6.29 I got the following Oops when starting screen for a
ttyR serial device (after unloading and reloading the rocket module
while trying to get some udev rename rules right):

May  8 01:56:09 noc2b kernel: [  505.450289] RocketPort device driver module, version 2.09, 12-June-2003
May  8 01:56:09 noc2b kernel: [  505.463680] pci 0000:02:06.0: comtrol PCI controller #0 found at address c800, 1 AIOP(s) (RocketPort UPCI 8 port w/external I/F), creating ttyR0 - 7
May  8 01:56:09 noc2b kernel: [  505.491741] pci 0000:01:08.0: comtrol PCI controller #1 found at address d800, 1 AIOP(s) (RocketPort UPCI 8 port w/external I/F), creating ttyR8 - 15
May  8 01:56:32 noc2b kernel: [  528.486680] BUG: unable to handle kernel paging request at 06bd0c30
May  8 01:56:32 noc2b kernel: [  528.499538] IP: [<fbdf4f6a>] rp_open+0xc1/0x349 [rocket]
May  8 01:56:32 noc2b kernel: [  528.510352] *pde = 00000000
May  8 01:56:33 noc2b kernel: [  528.516286] Oops: 0000 [#1] SMP
May  8 01:56:33 noc2b kernel: [  528.521023] last sysfs file: /sys/devices/virtual/block/md1/md/dev-sdb2/state
May  8 01:56:33 noc2b kernel: [  528.537022] Modules linked in: rocket 8021q garp stp bonding nf_conntrack_tftp xt_recent xt_multiport ip6t_REJECT ipt_REJECT nf_conntrack_ipv6 nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_tcpudp xt_comment ip6t_LOG ipt_LOG xt_limit ip6table_filter iptable_filter ip6table_raw ip6_tables iptable_raw ip_tables x_tables ext3 jbd mbcache ipmi_devintf ipmi_si ipmi_msghandler ipv6 evdev snd_pcm snd_timer snd soundcore snd_page_alloc psmouse serio_raw dcdbas button pcspkr shpchp pci_hotplug i2c_piix4 i2c_core sworks_agp agpgart xfs exportfs dm_mirror dm_region_hash dm_log dm_snapshot dm_mod raid1 md_mod sg sd_mod crc_t10dif ide_cd_mod cdrom ata_generic libata aic7xxx scsi_transport_spi ohci_hcd tg3 scsi_mod floppy libphy usbcore serverworks ide_pci_generic ide_core thermal processor fan thermal_sys [last unloaded: rocket]
May  8 01:56:33 noc2b kernel: [  528.689023]
May  8 01:56:33 noc2b kernel: [  528.693024] Pid: 6174, comm: stty Not tainted (2.6.29-2-686 #1) PowerEdge 2650
May  8 01:56:33 noc2b kernel: [  528.709022] EIP: 0060:[<fbdf4f6a>] EFLAGS: 00010202 CPU: 0
May  8 01:56:33 noc2b kernel: [  528.721022] EIP is at rp_open+0xc1/0x349 [rocket]
May  8 01:56:33 noc2b kernel: [  528.732509] EAX: 00000001 EBX: fffffff4 ECX: f5a1fc00 EDX: 00000000
May  8 01:56:33 noc2b kernel: [  528.745026] ESI: f55d6000 EDI: f5a1fc00 EBP: f6bd0c00 ESP: f57ede54
May  8 01:56:33 noc2b kernel: [  528.757023]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
May  8 01:56:33 noc2b kernel: [  528.768508] Process stty (pid: 6174, ti=f57ec000 task=f671f7f0 task.ti=f57ec000)
May  8 01:56:33 noc2b kernel: [  528.781022] Stack:
May  8 01:56:33 noc2b kernel: [  528.785022]  f6b3d880 f6bd0c04 f6ac1380 f5a1fc00 ffffffed f6b3d880 c0245690 00008800
May  8 01:56:33 noc2b kernel: [  528.801022]  f6346cc4 02e00004 00000000 00000004 00000000 f6ac1388 f6ac1388 00000000
May  8 01:56:33 noc2b kernel: [  528.817022]  c0189958 f6b3d880 f6346cc4 00000004 f6b3d880 00000000 f6346cc4 c0189827
May  8 01:56:33 noc2b kernel: [  528.833022] Call Trace:
May  8 01:56:33 noc2b kernel: [  528.841022]  [<c0245690>] tty_open+0x287/0x393
May  8 01:56:33 noc2b kernel: [  528.849021]  [<c0189958>] chrdev_open+0x131/0x148
May  8 01:56:33 noc2b kernel: [  528.857023]  [<c0189827>] chrdev_open+0x0/0x148
May  8 01:56:33 noc2b kernel: [  528.869043]  [<c0185f40>] __dentry_open+0x119/0x208
May  8 01:56:33 noc2b kernel: [  528.877022]  [<c01860c0>] nameidata_to_filp+0x29/0x3c
May  8 01:56:33 noc2b kernel: [  528.889022]  [<c018fa92>] do_filp_open+0x385/0x6f7
May  8 01:56:33 noc2b kernel: [  528.897023]  [<c0172296>] vma_prio_tree_insert+0x17/0x7f
May  8 01:56:33 noc2b kernel: [  528.909022]  [<c01792e8>] vma_link+0x69/0x72
May  8 01:56:33 noc2b kernel: [  528.917022]  [<c017a584>] mmap_region+0x318/0x41c
May  8 01:56:33 noc2b kernel: [  528.925022]  [<c01973d7>] alloc_fd+0xb9/0xc5
May  8 01:56:33 noc2b kernel: [  528.936509]  [<c0185d55>] do_sys_open+0x3f/0xb2
May  8 01:56:33 noc2b kernel: [  528.945021]  [<c0185e0c>] sys_open+0x1e/0x23
May  8 01:56:33 noc2b kernel: [  528.953022]  [<c010341b>] sysenter_do_call+0x12/0x2f
May  8 01:56:33 noc2b kernel: [  528.964509]  [<c02e0000>] cpuid4_cache_lookup+0x2d4/0x2e2
May  8 01:56:33 noc2b kernel: [  528.973022] Code: 01 00 00 8d 45 04 89 fa 89 44 24 04 89 af 28 01 00 00 e8 92 4c 45 c4 8b 55 14 8d 42 01 85 d2 89 45 14 75 07 f0 ff 05 68 89 df fb <f6> 85 30 00 00 10 01 0f 85 46 02 00 00 8a 85 f2 00 00 00 8d 75
May  8 01:56:33 noc2b kernel: [  529.017023] EIP: [<fbdf4f6a>] rp_open+0xc1/0x349 [rocket] SS:ESP 0068:f57ede54
May  8 01:56:33 noc2b kernel: [  529.033342] ---[ end trace 206e0bf40f2c2211 ]---

This is a stock Debian unstable kernel, I can provide its config if needed.
Please ask if any other information is missing.
Please Cc me, I'm not subscribed.
-- 
Thanks,
Feri.
