Return-Path: <linux-kernel-owner+w=401wt.eu-S1755930AbYJHUP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930AbYJHUP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 16:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbYJHUPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 16:15:51 -0400
Received: from main.gmane.org ([80.91.229.2]:55962 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbYJHUPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 16:15:50 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frederik Himpe <fhimpe@telenet.be>
Subject: 2.6.27-rc8-git8: oops in process hald-addon-dell-backlight (intel
 iommu related?)
Date: Wed, 8 Oct 2008 20:15:37 +0000 (UTC)
Message-ID: <pan.2008.10.08.20.15.37@telenet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 78-21-61-244.access.telenet.be
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my Dell Latitude E6400 system with Intel chipset and graphics, I get 
this oops in my 2.6.27-rc8-git8 based kernel, which probably happens when 
hald-addon-dell-backlight is started. 

Complete dmesg and lspci info:
https://qa.mandriva.com/show_bug.cgi?id=44711

iwlagn 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:0c:00.0: restoring config space at offset 0x1 (was 0x100102, 
writing 0x100106)
firmware: requesting iwlwifi-5000-1.ucode
iwlagn: Radio disabled by HW RF Kill switch
ADDRCONF(NETDEV_UP): wlan0: link is not ready
wlan0: Failed to config new SSID to the low-level driver
BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
IP: [<ffffffff8037cf1f>] pci_find_upstream_pcie_bridge+0x1f/0xa0
PGD 11addf067 PUD 11b1c1067 PMD 0 
Oops: 0000 [1] SMP 
CPU 1 
Modules linked in: ipv6 binfmt_misc fuse nls_utf8 nls_cp437 vfat fat ext3 
jbd loop cpufreq_ondemand cpufreq_conservative cpufreq_powersave 
acpi_cpufreq freq_table nvram i8k ohci1394 ieee1394 pcmcia snd_hda_intel 
snd_hwdep firewire_ohci firewire_core arc4 sdhci_pci crc_itu_t sdhci ecb 
video output crypto_blkcipher snd_seq_dummy mmc_core snd_seq_oss 
snd_seq_midi_event snd_seq yenta_socket rsrc_nonstatic pcmcia_core 
snd_seq_device snd_pcm_oss snd_pcm snd_timer iwlagn snd_page_alloc 
snd_mixer_oss iwlcore i2c_i801 thermal wmi button battery ac snd e1000e 
rfkill led_class i2c_core processor soundcore evdev sr_mod rtc_cmos sg 
dcdbas mac80211 cfg80211 dm_snapshot dm_zero dm_mirror dm_log dm_mod 
ata_piix ahci libata dock sd_mod scsi_mod crc_t10dif xfs uhci_hcd ohci_hcd 
ehci_hcd usbcore [last unloaded: scsi_wait_scan]
Pid: 2685, comm: hald-addon-dell Not tainted 2.6.27-tmb-
desktop-0.rc8.8.2mdv #1
RIP: 0010:[<ffffffff8037cf1f>]  [<ffffffff8037cf1f>] 
pci_find_upstream_pcie_bridge+0x1f/0xa0
RSP: 0018:ffff88011b453c98  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000030 RDI: ffff88011b7e4f80
RBP: ffff88011b453c98 R08: 0000000000000000 R09: ffff88011cc5f000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000001000
R13: 0000000000000030 R14: ffff88011b7e4f80 R15: ffff88011b7e5010
FS:  00007f574f1ca700(0000) GS:ffff88011fc02980(0000) 
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000038 CR3: 000000011b1b4000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process hald-addon-dell (pid: 2685, threadinfo ffff88011b452000, task 
ffff88011adfd700)
Stack:  ffff88011b453d28 ffffffff80386808 ffff88011adfd700 0000000000000000
 0000000000000000 ffff88011b453e70 ffff88011b453d68 ffffffff8029574d
 0000000000000000 80ff880000000000 0000000000000000 ffff880000002a00
Call Trace:
 [<ffffffff80386808>] get_domain_for_dev+0x58/0x620
 [<ffffffff8029574d>] ? __alloc_pages_internal+0xed/0x4f0
 [<ffffffff803870f8>] get_valid_domain_for_dev+0x18/0x150
 [<ffffffff803875e7>] intel_map_single+0x47/0x160
 [<ffffffff802b8726>] ? alloc_pages_current+0x76/0xf0
 [<ffffffff8038777f>] intel_alloc_coherent+0x7f/0xb0
 [<ffffffff80212dfa>] dma_alloc_coherent+0x28a/0x310
 [<ffffffffa01a258a>] smi_data_buf_realloc+0x5a/0xf0 [dcdbas]
 [<ffffffff804da2b1>] ? mutex_lock+0x11/0x30
 [<ffffffffa01a26ca>] smi_data_buf_size_store+0x3a/0x60 [dcdbas]
 [<ffffffff803eefee>] dev_attr_store+0x1e/0x20
 [<ffffffff80325d85>] sysfs_write_file+0xc5/0x140
 [<ffffffff802c7a0b>] vfs_write+0xcb/0x170
 [<ffffffff802c7ba0>] sys_write+0x50/0x90
 [<ffffffff8020c69a>] system_call_fastpath+0x16/0x1b


Code: 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 f6 87 89 05 00 00 04 48 89 e5 
75 3b 31 d2 eb 0a 0f 1f 80 00 00 00 00 48 89 fa 48 8b 47 10 <48> 8b 78 38 
48 85 ff 74 30 f6 87 89 05 00 00 04 74 e7 80 7f 4a 
RIP  [<ffffffff8037cf1f>] pci_find_upstream_pcie_bridge+0x1f/0xa0
 RSP <ffff88011b453c98>
CR2: 0000000000000038
---[ end trace 200eed5d7163b4d1 ]---
NET: Registered protocol family 17
0000:00:19.0: eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
0000:00:19.0: eth0: 10/100 speed: disabling TSO
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

