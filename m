Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYKKOeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYKKOeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 09:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbYKKOeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 09:34:11 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:43579 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755992AbYKKOeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 09:34:09 -0500
Date: Tue, 11 Nov 2008 15:34:10 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: ipw3945-devel@lists.sourceforge.net
Subject: iwlagn driver segfault in 2.6.28-rc3
Message-ID: <20081111143410.GA4401@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 195.113.238.83
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 11 Nov 2008 15:34:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I accidentaly got the following oops:

[54644.622141] wlan0: association with AP 00:13:80:43:9d:d0 timed out
[54655.006025] iwlagn 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[54655.006444] iwlagn 0000:03:00.0: irq 40 for MSI/MSI-X
[54655.006715] general protection fault: 0000 [#1] SMP 
[54655.006723] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.1/host3/target3:0:0/3:0:0:0/block/sr0/stat
[54655.006728] Dumping ftrace buffer:
[54655.006733]    (ftrace buffer empty)
[54655.006737] CPU 0 
[54655.006740] Modules linked in: aes_x86_64 aes_generic arc4 ecb iwlagn iwlcore mac80211 cfg80211 i915 drm rfcomm bri
dge stp llc bnep sco l2cap tp_smapi thinkpad_ec btusb bluetooth fuse thinkpad_acpi rfkill e1000e wmi intel_agp snd_hda_intel [last unloaded: ehci_hcd]
[54655.006785] Pid: 13515, comm: wpa_supplicant Not tainted 2.6.28-rc3 #27
[54655.006789] RIP: 0010:[<ffffffffa0149db7>]  [<ffffffffa0149db7>] iwl_eeprom_query16+0x7/0x20 [iwlcore]
[54655.006813] RSP: 0018:ffff8800618f5b40  EFLAGS: 00010092
[54655.006817] RAX: 7fff880074655400 RBX: ffff88007c02d000 RCX: 00000000800300f0
[54655.006822] RDX: 0000000000000cfc RSI: 0000000000000090 RDI: ffff880061801940
[54655.006826] RBP: ffff880061801940 R08: 0000000000000002 R09: ffff8800618f5b0c
[54655.006831] R10: 0000000000000000 R11: ffffffff804a1010 R12: 0000000000080006
[54655.006835] R13: ffff880061802a60 R14: ffff880061802390 R15: 0000000000000296
[54655.006841] FS:  00007f27c48fb6f0(0000) GS:ffffffff806ed240(0000) knlGS:0000000000000000
[54655.006846] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[54655.006850] CR2: 0000000000446f50 CR3: 0000000055115000 CR4: 00000000000006e0
[54655.006855] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[54655.006859] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[54655.006865] Process wpa_supplicant (pid: 13515, threadinfo ffff8800618f4000, task ffff8800614142c0)
[54655.006869] Stack:
[54655.006872]  ffffffffa01cd782 ffffffff806d6148 0000000000000000 0000000000000296
[54655.006880]  0000000000000000 0143000000000000 ffff88007c02d000 ffff880061801940
[54655.006888]  ffff880061802390 ffff880061802a60 0000000000000292 ffff8800618f5d3c
[54655.006898] Call Trace:
[54655.006901]  [<ffffffffa01cd782>] ? iwl4965_nic_config+0xb2/0x3b0 [iwlagn]
[54655.006921]  [<ffffffffa0147619>] ? iwl_hw_nic_init+0xa9/0x1f0 [iwlcore]
[54655.006939]  [<ffffffffa01c1110>] ? __iwl4965_up+0xd0/0x740 [iwlagn]
[54655.006953]  [<ffffffffa01c1ee8>] ? iwl4965_mac_start+0x3c8/0x1190 [iwlagn]
[54655.006968]  [<ffffffff80282a10>] ? find_lock_page+0x30/0x80
[54655.006978]  [<ffffffff80284260>] ? filemap_fault+0x1c0/0x430
[54655.006986]  [<ffffffffa01271e9>] ? ieee80211_open+0x309/0x850 [mac80211]
[54655.007010]  [<ffffffff804b4e5a>] ? dev_open+0xba/0x100
[54655.007018]  [<ffffffff804b42e4>] ? dev_change_flags+0x94/0x1e0
[54655.007025]  [<ffffffff804fa1b3>] ? devinet_ioctl+0x683/0x6e0
[54655.007034]  [<ffffffff804a41d6>] ? sock_ioctl+0x66/0x270
[54655.007042]  [<ffffffff802bdf2f>] ? vfs_ioctl+0x2f/0xb0
[54655.007049]  [<ffffffff802be02c>] ? do_vfs_ioctl+0x7c/0x470
[54655.007055]  [<ffffffff802ae26e>] ? fd_install+0x2e/0x60
[54655.007063]  [<ffffffff802be469>] ? sys_ioctl+0x49/0x80
[54655.007069]  [<ffffffff80530ef9>] ? error_exit+0x0/0x51
[54655.007076]  [<ffffffff8020c4cb>] ? system_call_fastpath+0x16/0x1b
[54655.007085] Code: 00 00 00 00 48 8b 47 18 48 8b 40 18 48 8b 00 4c 8b 98 00 01 00 00 41 ff e3 66 66 2e 0f 1f 84 00 00 00 00 00 48 8b 87 00 23 01 00 <0f> b6 54 30 01 0f b6 04 30 c1 e2 08 09 d0 c3 66 2e 0f 1f 84 00 
[54655.007151] RIP  [<ffffffffa0149db7>] iwl_eeprom_query16+0x7/0x20 [iwlcore]
[54655.007169]  RSP <ffff8800618f5b40>
[54655.007174] ---[ end trace d9d4018bdc964b95 ]---

-- 
Luká¹ Hejtmánek
