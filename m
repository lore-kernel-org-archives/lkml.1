Return-Path: <linux-kernel-owner+w=401wt.eu-S1757770AbZLERFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbZLERFH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 12:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757269AbZLERFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 12:05:04 -0500
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:58248 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194AbZLERFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 12:05:02 -0500
Date: Sat, 05 Dec 2009 12:04:43 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: Oops: Sky2 2.6.32 dma-debug.c check_sync
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <4B1A92AB.1030006@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre)
 Gecko/20091109 Fedora/3.0-3.10.b4.fc12 Thunderbird/3.0b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This morning, rebooted with VT-D off, nomodeset, and during boot 
received a kerneloops (warning) that sky2 is trying to deallocate dma 
memory that it has not allocated. I've attached relevant details below.

Brief background:

Asus p6t D v2; i7 920 - been working around broken bios. Have had 
spurious DMAR errors against both my Nvidia graphics card and sky2 
ethernet depending on whether vt-d is on or off and whether KMS is or 
isn't on. I've been starting to think that occasionally with vt-d 
enabled that maybe once in a while an interrupt was being incorrectly 
directed to the wrong driver. Now I'm thinking that whatever's going on 
just manifests differently depending on whether or not VT-D is enabled 
and whether or not KMS is enabled. I had thought the issue was with 
intel_iommu, now am not so sure.

On to the oops:


Dec  5 11:27:41 mail kernel: ------------[ cut here ]------------
Dec  5 11:27:41 mail kernel: WARNING: at lib/dma-debug.c:898 
check_sync+0xbd/0x426()
Dec  5 11:27:41 mail kernel: Hardware name: System Product Name
Dec  5 11:27:41 mail kernel: sky2 0000:06:00.0: DMA-API: device driver 
tries to sync DMA memory it has not allocated [device 
address=0x000000031a57e022] [size=66 bytes]
Dec  5 11:27:41 mail kernel: Modules linked in: bridge stp appletalk 
psnap llc nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc hwmon_vid 
coretemp acpi_cpufreq sit tunnel4 ipt_LOG ipt_MASQUERADE iptable_nat 
nf_nat iptable_mangle iptable_raw nf_conntrack_netbios_ns 
nf_conntrack_ftp nf_conntrack_ipv6 xt_multiport ip6table_filter xt_DSCP 
xt_dscp xt_MARK ip6table_mangle ip6_tables ipv6 dm_multipath kvm_intel 
kvm snd_hda_codec_analog snd_ens1371 gameport snd_rawmidi snd_ac97_codec 
snd_hda_intel snd_hda_codec ac97_bus gspca_spca505 snd_hwdep snd_seq 
snd_seq_device firewire_ohci gspca_main snd_pcm videodev firewire_core 
sky2 snd_timer v4l1_compat wmi snd v4l2_compat_ioctl32 soundcore 
crc_itu_t snd_page_alloc asus_atk0110 i2c_i801 iTCO_wdt 
iTCO_vendor_support pcspkr hwmon raid456 async_raid6_recov async_pq 
raid6_pq async_xor xor async_memcpy async_tx raid1 ata_generic pata_acpi 
pata_marvell nouveau ttm drm_kms_helper drm agpgart fb i2c_algo_bit 
cfbcopyarea i2c_core cfbimgblt cfbfillrect [last unloaded: scsi_wait_scan]
Dec  5 11:27:41 mail kernel: Pid: 0, comm: swapper Not tainted 
2.6.32-00573-g6cf4d67 #2
Dec  5 11:27:41 mail kernel: Call Trace:
Dec  5 11:27:41 mail kernel: <IRQ>  [<ffffffff8105365a>] 
warn_slowpath_common+0x7c/0x94
Dec  5 11:27:41 mail kernel: [<ffffffff810536c9>] 
warn_slowpath_fmt+0x41/0x43
Dec  5 11:27:41 mail kernel: [<ffffffff8127b1fd>] check_sync+0xbd/0x426
Dec  5 11:27:41 mail kernel: [<ffffffff813ca254>] ? 
__netdev_alloc_skb+0x34/0x50
Dec  5 11:27:41 mail kernel: [<ffffffff8127b8b9>] 
debug_dma_sync_single_for_cpu+0x42/0x44
Dec  5 11:27:41 mail kernel: [<ffffffff81278c5f>] ? 
swiotlb_sync_single+0x2a/0xb6
Dec  5 11:27:41 mail kernel: [<ffffffff81278dbb>] ? 
swiotlb_sync_single_for_cpu+0xc/0xe
Dec  5 11:27:41 mail kernel: [<ffffffffa01cee83>] sky2_poll+0x4c6/0xae1 
[sky2]
Dec  5 11:27:41 mail kernel: [<ffffffff8146bb1a>] ? 
_spin_unlock_irqrestore+0x29/0x41
Dec  5 11:27:41 mail kernel: [<ffffffff813d0ef2>] net_rx_action+0xb5/0x1f3
Dec  5 11:27:41 mail kernel: [<ffffffff8105ae3b>] __do_softirq+0xf8/0x1cd
Dec  5 11:27:41 mail kernel: [<ffffffff810a2dea>] ? 
handle_IRQ_event+0x119/0x12b
Dec  5 11:27:41 mail kernel: [<ffffffff81012e1c>] call_softirq+0x1c/0x30
Dec  5 11:27:41 mail kernel: [<ffffffff810143a3>] do_softirq+0x4b/0xa6
Dec  5 11:27:41 mail kernel: [<ffffffff8105aa1b>] irq_exit+0x4a/0x8c
Dec  5 11:27:41 mail kernel: [<ffffffff8146fb75>] do_IRQ+0xa5/0xbc
Dec  5 11:27:41 mail kernel: [<ffffffff81012613>] ret_from_intr+0x0/0x16
Dec  5 11:27:41 mail kernel: <EOI>  [<ffffffff812c6b3e>] ? 
acpi_idle_enter_bm+0x256/0x28a
Dec  5 11:27:41 mail kernel: [<ffffffff812c6b37>] ? 
acpi_idle_enter_bm+0x24f/0x28a
Dec  5 11:27:41 mail kernel: [<ffffffff813a6280>] ? 
cpuidle_idle_call+0x9e/0xfa
Dec  5 11:27:41 mail kernel: [<ffffffff81010c90>] ? cpu_idle+0xb4/0xf6
Dec  5 11:27:41 mail kernel: [<ffffffff814651f2>] ? 
start_secondary+0x201/0x242
Dec  5 11:27:41 mail kernel: ---[ end trace ff8485ac82013a8d ]---

dmesg extract:
CPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with ACPI region 
SMRG [0x400-0x40f]
ACPI: If an ACPI driver is available for this device, you should use it 
instead of the native driver
ACPI: WMI: Mapper loaded
sky2 driver version 1.25
sky2 0000:06:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
sky2 0000:06:00.0: setting latency timer to 64
sky2 0000:06:00.0: Yukon-2 EC Ultra chip revision 3
   alloc irq_desc for 56 on node -1
   alloc kstat_irqs on node -1
sky2 0000:06:00.0: irq 56 for MSI/MSI-X
sky2 eth0: addr 00:26:18:00:1c:3b
sky2 0000:04:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
sky2 0000:04:00.0: setting latency timer to 64
sky2 0000:04:00.0: Yukon-2 EC Ultra chip revision 3
   alloc irq_desc for 57 on node -1
   alloc kstat_irqs on node -1
sky2 0000:04:00.0: irq 57 for MSI/MSI-X
sky2 eth1: addr 00:26:18:00:1c:3a
Linux video capture interface: v2.00
gspca: main v2.7.0 registered
firewire_ohci 0000:08:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
gspca: probing 0733:0430
gspca: probe ok
usbcore: registered new interface driver spca505
spca505: registered
firewire_ohci: Added fw-ohci device 0000:08:02.0, OHCI version 1.10
   alloc irq_desc for 22 on node -1
   alloc kstat_irqs on node -1
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
ENS1371 0000:08:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17







