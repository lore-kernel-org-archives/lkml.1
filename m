Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbXEQJBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbXEQJBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 05:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbXEQJBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 05:01:05 -0400
Received: from barclay.balt.net ([195.14.162.78]:55313 "EHLO barclay.balt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbXEQJBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 05:01:02 -0400
Subject: Re: Kernel NFS lockd freezes notebook on shutdown (Linux
	2.6.22-rc1 + CFS v12)
From: Zilvinas Valinskas <zilvinas@wilibox.com>
Reply-To: zilvinas@wilibox.com
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1179390065.4760.5.camel@zv.wilibox.com>
References: <1179338441.4265.13.camel@zv.wilibox.com>
	 <20070516121538.7b108c10.akpm@linux-foundation.org>
	 <20070516225543.GA337@tv-sign.ru>  <1179390065.4760.5.camel@zv.wilibox.com>
Content-Type: text/plain
Date: Thu, 17 May 2007 12:00:51 +0300
Message-Id: <1179392451.4351.6.camel@zv.wilibox.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

And another one crash, achieved by running the following in the shell.
Ran several times, as see from dmesg:

$ op=stop; sudo /etc/init.d/nfs-common $op; \
           sudo /etc/init.d/nfs-kernel-server $op; \
  op=start; sudo /etc/init.d/nfs-common $op; \
            sudo /etc/init.d/nfs-kernel-server $op;

Repeat several times ;)

The dmesg output:

May 17 11:36:23 zv kernel: [  613.071050] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
May 17 11:36:23 zv kernel: [  613.071082] NFSD: starting 90-second grace period
May 17 11:36:25 zv kernel: [  615.639312] nfsd: last server has exited
May 17 11:36:25 zv kernel: [  615.639322] nfsd: unexporting all filesystems
May 17 11:36:25 zv kernel: [  615.838746] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
May 17 11:36:25 zv kernel: [  615.838782] NFSD: starting 90-second grace period
May 17 11:36:26 zv kernel: [  616.464554] nfsd: last server has exited
May 17 11:36:26 zv kernel: [  616.464563] nfsd: unexporting all filesystems
May 17 11:36:26 zv kernel: [  616.468219] RPC: failed to contact local rpcbind server (errno 5).
May 17 11:36:26 zv kernel: [  616.669736] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
May 17 11:36:26 zv kernel: [  616.669771] NFSD: starting 90-second grace period
May 17 11:36:27 zv kernel: [  617.200592] nfsd: last server has exited
May 17 11:36:27 zv kernel: [  617.200601] nfsd: unexporting all filesystems
May 17 11:36:27 zv kernel: [  617.202565] RPC: failed to contact local rpcbind server (errno 5).
May 17 11:36:27 zv kernel: [  617.409917] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
May 17 11:36:27 zv kernel: [  617.409948] NFSD: starting 90-second grace period
May 17 11:36:27 zv kernel: [  617.872937] nfsd: last server has exited
May 17 11:36:27 zv kernel: [  617.872945] nfsd: unexporting all filesystems
May 17 11:36:27 zv kernel: [  617.877526] RPC: failed to contact local rpcbind server (errno 5).
May 17 11:36:28 zv kernel: [  618.084212] PGD 21f9e067 PUD 3b8bf067 PMD 0 
May 17 11:36:28 zv kernel: [  618.084224] CPU 0 
May 17 11:36:28 zv kernel: [  618.084227] Modules linked in: fglrx(P) nfs ipv6 nfsd exportfs lockd nfs_acl sunrpc pp
dev lp autofs4 deflate zlib_deflate twofish twofish_common camellia serpent blowfish des cbc ecb blkcipher aes xcbc 
sha256 sha1 crypto_null af_key piix ide_core dm_crypt dm_snapshot dm_mirror dm_mod sbp2 loop coretemp cpufreq_conser
vative cpufreq_stats acpi_cpufreq freq_table pcmcia snd_hda_intel usbhid snd_pcm_oss snd_mixer_oss pl2303 ipw3945 ye
nta_socket snd_pcm ohci1394 ieee1394 tifm_7xx1 joydev snd_timer usbserial tsdev tpm_infineon sdhci rsrc_nonstatic ie
ee80211 ieee80211_crypt parport_pc snd tpm fw_ohci fw_core parport firmware_class iTCO_wdt iTCO_vendor_support sg ps
mouse pcmcia_core tg3 mmc_core crc_itu_t tifm_core pcspkr tpm_bios soundcore snd_page_alloc intel_agp sr_mod serio_r
aw ehci_hcd uhci_hcd cdrom evdev
May 17 11:36:28 zv kernel: [  618.084327] Pid: 5560, comm: rpc.nfsd Tainted: P       2.6.22-rc1-cfs-v12 #2
May 17 11:36:28 zv kernel: [  618.084332] RIP: 0010:[<ffffffff80341ec4>]  [<ffffffff80341ec4>] kobject_cleanup+0x24/
0xa0
May 17 11:36:28 zv kernel: [  618.084342] RSP: 0018:ffff8100210bdd08  EFLAGS: 00010202
May 17 11:36:28 zv kernel: [  618.084347] RAX: 0000000000000001 RBX: ffff810021c7d688 RCX: ffffffff804c4be0
May 17 11:36:28 zv kernel: [  618.084353] RDX: 0000000000000000 RSI: ffffffff80341f40 RDI: ffff810021c7d688
May 17 11:36:28 zv kernel: [  618.084358] RBP: ffffffff80341f40 R08: 0000000000000000 R09: 0000000000000000
May 17 11:36:28 zv kernel: [  618.084362] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000010
May 17 11:36:28 zv kernel: [  618.084367] R13: ffff810001fe6270 R14: ffffffff88382941 R15: 0000000000000000
May 17 11:36:28 zv kernel: [  618.084374] FS:  00002ab11a0db6f0(0000) GS:ffffffff80603000(0000) knlGS:00000000000000
00
May 17 11:36:28 zv kernel: [  618.084379] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
May 17 11:36:28 zv kernel: [  618.084384] CR2: 0000000000000010 CR3: 0000000038d4f000 CR4: 00000000000006e0
May 17 11:36:28 zv kernel: [  618.084390] Process rpc.nfsd (pid: 5560, threadinfo ffff8100210bc000, task ffff8100266
a6000)
May 17 11:36:28 zv kernel: [  618.084394] Stack:  0000000000000287 ffff810021c7d6a4 ffffffff80341f40 ffff81003bf9837
8
May 17 11:36:28 zv kernel: [  618.084405]  ffff810001fe6270 ffffffff80342fff ffff81003bf98378 ffff810038bf0f50
May 17 11:36:28 zv kernel: [  618.084414]  ffff81003bf98370 ffffffff802e59ec ffffffff88382941 ffff810021250100
May 17 11:36:28 zv kernel: [  618.084422] Call Trace:
May 17 11:36:28 zv kernel: [  618.084432]  [<ffffffff80341f40>] kobject_release+0x0/0x10
May 17 11:36:28 zv kernel: [  618.084440]  [<ffffffff80342fff>] kref_put+0x3f/0x80
May 17 11:36:28 zv kernel: [  618.084449]  [<ffffffff802e59ec>] sysfs_hash_and_remove+0x14c/0x160
May 17 11:36:28 zv kernel: [  618.084460]  [<ffffffff80292421>] sysfs_slab_alias+0x71/0xa0
May 17 11:36:28 zv kernel: [  618.084468]  [<ffffffff8029257c>] sysfs_slab_add+0x12c/0x1a0
May 17 11:36:28 zv kernel: [  618.084478]  [<ffffffff80292b48>] kmem_cache_create+0x1e8/0x250
May 17 11:36:28 zv kernel: [  618.084516]  [<ffffffff883789fc>] :nfsd:nfs4_state_start+0xac/0x1b0
May 17 11:36:28 zv kernel: [  618.084537]  [<ffffffff8835e660>] :nfsd:nfsd_svc+0x50/0x150
May 17 11:36:28 zv kernel: [  618.084557]  [<ffffffff8835f360>] :nfsd:write_threads+0x0/0xc0
May 17 11:36:28 zv kernel: [  618.084574]  [<ffffffff8835f3d5>] :nfsd:write_threads+0x75/0xc0
May 17 11:36:28 zv kernel: [  618.084586]  [<ffffffff80274914>] get_zeroed_page+0x34/0x70
May 17 11:36:28 zv kernel: [  618.084592]  [<ffffffff802b6760>] simple_transaction_get+0xc0/0xe0
May 17 11:36:28 zv kernel: [  618.084611]  [<ffffffff8835f360>] :nfsd:write_threads+0x0/0xc0
May 17 11:36:28 zv kernel: [  618.084631]  [<ffffffff8835f0ba>] :nfsd:nfsctl_transaction_write+0x6a/0x90
May 17 11:36:28 zv kernel: [  618.084642]  [<ffffffff80296465>] vfs_write+0xe5/0x190
May 17 11:36:28 zv kernel: [  618.084651]  [<ffffffff80296b73>] sys_write+0x53/0x90
May 17 11:36:28 zv kernel: [  618.084662]  [<ffffffff8020a2ae>] system_call+0x7e/0x83
May 17 11:36:28 zv kernel: [  618.084675] 
May 17 11:36:28 zv kernel: [  618.084677] 
May 17 11:36:28 zv kernel: [  618.084679] Code: 49 8b 2c 24 48 85 ed 74 63 48 8b 3b 48 8d 43 08 4c 8b 6b 30 
May 17 11:36:28 zv kernel: [  618.084705]  RSP <ffff8100210bdd08>
May 17 11:36:40 zv kernel: [  630.638649] PGD 37cd7067 PUD 38a35067 PMD 0 
May 17 11:36:40 zv kernel: [  630.638662] CPU 1 
May 17 11:36:40 zv kernel: [  630.638666] Modules linked in: fglrx(P) nfs ipv6 nfsd exportfs lockd nfs_acl sunrpc pp
dev lp autofs4 deflate zlib_deflate twofish twofish_common camellia serpent blowfish des cbc ecb blkcipher aes xcbc 
sha256 sha1 crypto_null af_key piix ide_core dm_crypt dm_snapshot dm_mirror dm_mod sbp2 loop coretemp cpufreq_conser
vative cpufreq_stats acpi_cpufreq freq_table pcmcia snd_hda_intel usbhid snd_pcm_oss snd_mixer_oss pl2303 ipw3945 ye
nta_socket snd_pcm ohci1394 ieee1394 tifm_7xx1 joydev snd_timer usbserial tsdev tpm_infineon sdhci rsrc_nonstatic ie
ee80211 ieee80211_crypt parport_pc snd tpm fw_ohci fw_core parport firmware_class iTCO_wdt iTCO_vendor_support sg ps
mouse pcmcia_core tg3 mmc_core crc_itu_t tifm_core pcspkr tpm_bios soundcore snd_page_alloc intel_agp sr_mod serio_r
aw ehci_hcd uhci_hcd cdrom evdev
May 17 11:36:40 zv kernel: [  630.638765] Pid: 1712, comm: kjournald Tainted: P       2.6.22-rc1-cfs-v12 #2
May 17 11:36:40 zv kernel: [  630.638770] RIP: 0010:[<ffffffff8029200f>]  [<ffffffff8029200f>] kmem_cache_alloc+0x2f
/0x60
May 17 11:36:40 zv kernel: [  630.638780] RSP: 0018:ffff81003dd99d00  EFLAGS: 00010002
May 17 11:36:40 zv kernel: [  630.638784] RAX: 0000000000000000 RBX: 0000000000000206 RCX: 0000000000000001
May 17 11:36:40 zv kernel: [  630.638790] RDX: ffff810001a269d0 RSI: 0000000000011200 RDI: ffffffff80610070
May 17 11:36:40 zv kernel: [  630.638796] RBP: ffff81003ff9d000 R08: ffff810001000000 R09: ffff810038bf0fe0
May 17 11:36:40 zv kernel: [  630.638801] R10: 0000000000001000 R11: ffffffff80332080 R12: 0000000000011210
May 17 11:36:40 zv kernel: [  630.638806] R13: ffff81003ff9d030 R14: ffff81003dd99d10 R15: 0000000000000010
May 17 11:36:40 zv kernel: [  630.638812] FS:  0000000000000000(0000) GS:ffff810001fbd080(0000) knlGS:00000000000000
00
May 17 11:36:40 zv kernel: [  630.638817] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
May 17 11:36:40 zv kernel: [  630.638822] CR2: 0000000000000001 CR3: 0000000037d23000 CR4: 00000000000006e0
May 17 11:36:40 zv kernel: [  630.638828] Process kjournald (pid: 1712, threadinfo ffff81003dd98000, task ffff81003e
a8e000)
May 17 11:36:40 zv kernel: [  630.638832] Stack:  0000000000000001 ffffffff80272433 ffff81002e676180 000000000000fff
f
May 17 11:36:40 zv kernel: [  630.638843]  0000000000000008 ffff81003ea93000 ffff810020cba174 ffffffff80335156
May 17 11:36:40 zv kernel: [  630.638852]  ffff810038bedba0 0000000000000001 0000000000000001 ffff810035e49d80
May 17 11:36:40 zv kernel: [  630.638860] Call Trace:
May 17 11:36:40 zv kernel: [  630.638869]  [<ffffffff80272433>] mempool_alloc+0x43/0x120
May 17 11:36:40 zv kernel: [  630.638880]  [<ffffffff80335156>] generic_make_request+0x186/0x230
May 17 11:36:40 zv kernel: [  630.638893]  [<ffffffff802bf0f4>] bio_alloc_bioset+0x34/0x120
May 17 11:36:40 zv kernel: [  630.638904]  [<ffffffff802bf240>] bio_alloc+0x10/0x30
May 17 11:36:40 zv kernel: [  630.638910]  [<ffffffff802bb04f>] submit_bh+0x5f/0x130
May 17 11:36:40 zv kernel: [  630.638919]  [<ffffffff80302453>] journal_commit_transaction+0x1013/0x13f0
May 17 11:36:40 zv kernel: [  630.638930]  [<ffffffff804a21fc>] thread_return+0x51/0x675
May 17 11:36:40 zv kernel: [  630.638940]  [<ffffffff80242564>] lock_timer_base+0x34/0x70
May 17 11:36:40 zv kernel: [  630.638955]  [<ffffffff8030686f>] kjournald+0xdf/0x240
May 17 11:36:40 zv kernel: [  630.638965]  [<ffffffff8024e760>] autoremove_wake_function+0x0/0x30
May 17 11:36:40 zv kernel: [  630.638973]  [<ffffffff80306790>] kjournald+0x0/0x240
May 17 11:36:40 zv kernel: [  630.638980]  [<ffffffff80306790>] kjournald+0x0/0x240
May 17 11:36:40 zv kernel: [  630.638988]  [<ffffffff8024e39b>] kthread+0x4b/0x80
May 17 11:36:40 zv kernel: [  630.638996]  [<ffffffff8020b0f8>] child_rip+0xa/0x12
May 17 11:36:40 zv kernel: [  630.639012]  [<ffffffff8024e350>] kthread+0x0/0x80
May 17 11:36:40 zv kernel: [  630.639018]  [<ffffffff8020b0ee>] child_rip+0x0/0x12
May 17 11:36:40 zv kernel: [  630.639024] 
May 17 11:36:40 zv kernel: [  630.639026] 
May 17 11:36:40 zv kernel: [  630.639028] Code: 48 8b 04 c1 48 89 42 10 53 9d 5b 48 89 c8 c3 66 90 49 89 d0 
May 17 11:36:40 zv kernel: [  630.639054]  RSP <ffff81003dd99d00>
May 17 11:36:40 zv kernel: [  630.861705] PGD 3bca7067 PUD 3c317067 PMD 0 
May 17 11:36:40 zv kernel: [  630.861717] CPU 1 
May 17 11:36:40 zv kernel: [  630.861720] Modules linked in: fglrx(P) nfs ipv6 nfsd exportfs lockd nfs_acl sunrpc pp
dev lp autofs4 deflate zlib_deflate twofish twofish_common camellia serpent blowfish des cbc ecb blkcipher aes xcbc 
sha256 sha1 crypto_null af_key piix ide_core dm_crypt dm_snapshot dm_mirror dm_mod sbp2 loop coretemp cpufreq_conser
vative cpufreq_stats acpi_cpufreq freq_table pcmcia snd_hda_intel usbhid snd_pcm_oss snd_mixer_oss pl2303 ipw3945 ye
nta_socket snd_pcm ohci1394 ieee1394 tifm_7xx1 joydev snd_timer usbserial tsdev tpm_infineon sdhci rsrc_nonstatic ie
ee80211 ieee80211_crypt parport_pc snd tpm fw_ohci fw_core parport firmware_class iTCO_wdt iTCO_vendor_support sg ps
mouse pcmcia_core tg3 mmc_core crc_itu_t tifm_core pcspkr tpm_bios soundcore snd_page_alloc intel_agp sr_mod serio_r
aw ehci_hcd uhci_hcd cdrom evdev
May 17 11:36:40 zv kernel: [  630.861816] Pid: 2775, comm: hald-addon-stor Tainted: P       2.6.22-rc1-cfs-v12 #2
May 17 11:36:40 zv kernel: [  630.861821] RIP: 0010:[<ffffffff8029200f>]  [<ffffffff8029200f>] kmem_cache_alloc+0x2f
/0x60
May 17 11:36:40 zv kernel: [  630.861830] RSP: 0018:ffff81003c2d58f8  EFLAGS: 00010002
May 17 11:36:40 zv kernel: [  630.861834] RAX: 0000000000000000 RBX: 0000000000000206 RCX: 0000000000000001
May 17 11:36:40 zv kernel: [  630.861840] RDX: ffff810001a269d0 RSI: 0000000000011200 RDI: ffffffff80610070
May 17 11:36:40 zv kernel: [  630.861845] RBP: ffff81003ff9d000 R08: 0000000000000010 R09: ffff810037790840
May 17 11:36:40 zv kernel: [  630.861851] R10: 00000000ffffffff R11: ffffffff8033f850 R12: 0000000000011210
May 17 11:36:40 zv kernel: [  630.861856] R13: ffff81003ff9d030 R14: ffff81003c2d5908 R15: 0000000000000010
May 17 11:36:40 zv kernel: [  630.861862] FS:  00002b41fb732fd0(0000) GS:ffff810001fbd080(0000) knlGS:00000000000000
00
May 17 11:36:40 zv kernel: [  630.861868] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
May 17 11:36:40 zv kernel: [  630.861872] CR2: 0000000000000001 CR3: 000000003c384000 CR4: 00000000000006e0
May 17 11:36:40 zv kernel: [  630.861879] Process hald-addon-stor (pid: 2775, threadinfo ffff81003c2d4000, task ffff
81003c2deea0)
May 17 11:36:40 zv kernel: [  630.861883] Stack:  0000000000000001 ffffffff80272433 ffff810000010000 000000013f4cc5d
0
May 17 11:36:40 zv kernel: [  630.861894]  ffff81003c2deea0 ffff81003f53f5f0 ffff81003f4cc5d0 ffff81003f4cc5d0
May 17 11:36:40 zv kernel: [  630.861903]  0000000000000000 0000000000000001 ffff8100218898c0 0000000000000000
May 17 11:36:40 zv kernel: [  630.861910] Call Trace:
May 17 11:36:40 zv kernel: [  630.861918]  [<ffffffff80272433>] mempool_alloc+0x43/0x120
May 17 11:36:40 zv kernel: [  630.861934]  [<ffffffff802bf0f4>] bio_alloc_bioset+0x34/0x120
May 17 11:36:40 zv kernel: [  630.861945]  [<ffffffff802bf240>] bio_alloc+0x10/0x30
May 17 11:36:40 zv kernel: [  630.861952]  [<ffffffff802bf29e>] bio_map_kern+0x3e/0x130
May 17 11:36:40 zv kernel: [  630.861965]  [<ffffffff8033597b>] blk_rq_map_kern+0x4b/0xa0
May 17 11:36:40 zv kernel: [  630.861975]  [<ffffffff803cdb11>] scsi_execute+0x71/0x120
May 17 11:36:40 zv kernel: [  630.861991]  [<ffffffff88032352>] :sr_mod:sr_do_ioctl+0xb2/0x250
May 17 11:36:40 zv kernel: [  630.862000]  [<ffffffff803cdb9b>] scsi_execute+0xfb/0x120
May 17 11:36:40 zv kernel: [  630.862017]  [<ffffffff88033160>] :sr_mod:sr_cd_check+0x260/0x4a0
May 17 11:36:40 zv kernel: [  630.862037]  [<ffffffff880311c7>] :sr_mod:sr_media_change+0xa7/0x250
May 17 11:36:40 zv kernel: [  630.862056]  [<ffffffff880040a8>] :cdrom:media_changed+0x68/0xa0
May 17 11:36:40 zv kernel: [  630.862065]  [<ffffffff802c0127>] check_disk_change+0x27/0x90
May 17 11:36:40 zv kernel: [  630.862077]  [<ffffffff88008732>] :cdrom:cdrom_open+0x182/0xb00
May 17 11:36:40 zv kernel: [  630.862086]  [<ffffffff802a8ec1>] dput+0x21/0x140
May 17 11:36:40 zv kernel: [  630.862094]  [<ffffffff802a0cbd>] __link_path_walk+0xa1d/0xf00
May 17 11:36:40 zv kernel: [  630.862110]  [<ffffffff802aef7f>] mntput_no_expire+0x1f/0xa0
May 17 11:36:40 zv kernel: [  630.862118]  [<ffffffff802a1220>] link_path_walk+0x80/0xf0
May 17 11:36:40 zv kernel: [  630.862125]  [<ffffffff802ab8f2>] iput+0x42/0x80
May 17 11:36:40 zv kernel: [  630.862138]  [<ffffffff80341fb2>] kobject_get+0x12/0x20
May 17 11:36:40 zv kernel: [  630.862144]  [<ffffffff80339514>] get_disk+0x34/0xe0
May 17 11:36:40 zv kernel: [  630.862151]  [<ffffffff803395cc>] exact_lock+0xc/0x20
May 17 11:36:40 zv kernel: [  630.862165]  [<ffffffff88031478>] :sr_mod:sr_block_open+0x78/0xd0
May 17 11:36:40 zv kernel: [  630.862172]  [<ffffffff802c0eb0>] blkdev_open+0x0/0x90
May 17 11:36:40 zv kernel: [  630.862180]  [<ffffffff802c0eb0>] blkdev_open+0x0/0x90
May 17 11:36:40 zv kernel: [  630.862186]  [<ffffffff802c09c1>] do_open+0xb1/0x330
May 17 11:36:40 zv kernel: [  630.862192]  [<ffffffff8029faad>] may_open+0x7d/0x2a0
May 17 11:36:40 zv kernel: [  630.862201]  [<ffffffff802c0eb0>] blkdev_open+0x0/0x90
May 17 11:36:40 zv kernel: [  630.862208]  [<ffffffff802c0eec>] blkdev_open+0x3c/0x90
May 17 11:36:40 zv kernel: [  630.862216]  [<ffffffff802940dc>] __dentry_open+0x11c/0x270
May 17 11:36:40 zv kernel: [  630.862227]  [<ffffffff8029433a>] do_filp_open+0x3a/0x50
May 17 11:36:40 zv kernel: [  630.862234]  [<ffffffff802ab8f2>] iput+0x42/0x80
May 17 11:36:40 zv kernel: [  630.862246]  [<ffffffff80293f9c>] get_unused_fd+0xec/0x110
May 17 11:36:40 zv kernel: [  630.862256]  [<ffffffff802943aa>] do_sys_open+0x5a/0x100
May 17 11:36:40 zv kernel: [  630.862266]  [<ffffffff8020a2ae>] system_call+0x7e/0x83
May 17 11:36:40 zv kernel: [  630.862279] 
May 17 11:36:40 zv kernel: [  630.862281] 
May 17 11:36:40 zv kernel: [  630.862283] Code: 48 8b 04 c1 48 89 42 10 53 9d 5b 48 89 c8 c3 66 90 49 89 d0 
May 17 11:36:40 zv kernel: [  630.862309]  RSP <ffff81003c2d58f8>
May 17 11:36:49 zv kernel: [  639.705875] PGD 332b8067 PUD 332b9067 PMD 0 
May 17 11:36:49 zv kernel: [  639.705888] CPU 1 
May 17 11:36:49 zv kernel: [  639.705891] Modules linked in: fglrx(P) nfs ipv6 nfsd exportfs lockd nfs_acl sunrpc pp
dev lp autofs4 deflate zlib_deflate twofish twofish_common camellia serpent blowfish des cbc ecb blkcipher aes xcbc 
sha256 sha1 crypto_null af_key piix ide_core dm_crypt dm_snapshot dm_mirror dm_mod sbp2 loop coretemp cpufreq_conser
vative cpufreq_stats acpi_cpufreq freq_table pcmcia snd_hda_intel usbhid snd_pcm_oss snd_mixer_oss pl2303 ipw3945 ye
nta_socket snd_pcm ohci1394 ieee1394 tifm_7xx1 joydev snd_timer usbserial tsdev tpm_infineon sdhci rsrc_nonstatic ie
ee80211 ieee80211_crypt parport_pc snd tpm fw_ohci fw_core parport firmware_class iTCO_wdt iTCO_vendor_support sg ps
mouse pcmcia_core tg3 mmc_core crc_itu_t tifm_core pcspkr tpm_bios soundcore snd_page_alloc intel_agp sr_mod serio_r
aw ehci_hcd uhci_hcd cdrom evdev
May 17 11:36:49 zv kernel: [  639.705991] Pid: 3616, comm: kded Tainted: P       2.6.22-rc1-cfs-v12 #2
May 17 11:36:49 zv kernel: [  639.705996] RIP: 0010:[<ffffffff80292375>]  [<ffffffff80292375>] __kmalloc+0x45/0x80
May 17 11:36:49 zv kernel: [  639.706005] RSP: 0018:ffff8100332bfdb8  EFLAGS: 00010002
May 17 11:36:49 zv kernel: [  639.706010] RAX: 0000000000000000 RBX: 0000000000000282 RCX: 0000000000000001
May 17 11:36:49 zv kernel: [  639.706015] RDX: ffff810001a269d0 RSI: 00000000000000d0 RDI: ffffffff80610070
May 17 11:36:49 zv kernel: [  639.706020] RBP: 00000000000000d0 R08: 0000000000000000 R09: ffff81003bf981e0
May 17 11:36:49 zv kernel: [  639.706025] R10: 0000000000000000 R11: ffffc200000065d1 R12: 0000000000000000
May 17 11:36:49 zv kernel: [  639.706030] R13: 0000000000000000 R14: ffffffff805829f7 R15: ffff8100332bfe68
May 17 11:36:49 zv kernel: [  639.706037] FS:  00002b94613f8f60(0000) GS:ffff810001fbd080(0000) knlGS:00000000000000
00
May 17 11:36:49 zv kernel: [  639.706042] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
May 17 11:36:49 zv kernel: [  639.706047] CR2: 0000000000000001 CR3: 00000000332b7000 CR4: 00000000000006e0
May 17 11:36:49 zv kernel: [  639.706053] Process kded (pid: 3616, threadinfo ffff8100332be000, task ffff8100337a75f
0)
May 17 11:36:49 zv kernel: [  639.706057] Stack:  ffffffff805829f7 0000000000000078 ffff8100332bfe68 ffffffff80383cf
e
May 17 11:36:49 zv kernel: [  639.706069]  0000000100000000 ffff81002a46fb80 0000000000000000 ffffffff8037e3a2
May 17 11:36:49 zv kernel: [  639.706078]  ffff810001faefc0 0000000000000246 0000000000000078 ffff81003febcd40
May 17 11:36:49 zv kernel: [  639.706085] Call Trace:
May 17 11:36:49 zv kernel: [  639.706097]  [<ffffffff80383cfe>] acpi_ut_initialize_buffer+0x3d/0xa8
May 17 11:36:49 zv kernel: [  639.706106]  [<ffffffff8037e3a2>] acpi_evaluate_object+0x183/0x1d9
May 17 11:36:49 zv kernel: [  639.706119]  [<ffffffff8038ab3e>] acpi_battery_read_state+0xbb/0x2c5
May 17 11:36:49 zv kernel: [  639.706134]  [<ffffffff802b41e3>] seq_read+0x83/0x2e0
May 17 11:36:49 zv kernel: [  639.706150]  [<ffffffff802965f2>] vfs_read+0xe2/0x190
May 17 11:36:49 zv kernel: [  639.706159]  [<ffffffff80296ae3>] sys_read+0x53/0x90
May 17 11:36:49 zv kernel: [  639.706170]  [<ffffffff8020a2ae>] system_call+0x7e/0x83
May 17 11:36:49 zv kernel: [  639.706183] 
May 17 11:36:49 zv kernel: [  639.706185] 
May 17 11:36:49 zv kernel: [  639.706187] Code: 48 8b 04 c1 48 89 42 10 53 9d 48 89 c8 48 83 c4 08 5b 5d c3 
May 17 11:36:49 zv kernel: [  639.706213]  RSP <ffff8100332bfdb8>
May 17 11:36:57 zv kernel: [  647.184399] PGD 2121a067 PUD 21640067 PMD 0 
May 17 11:36:57 zv kernel: [  647.184412] CPU 1 
May 17 11:36:57 zv kernel: [  647.184415] Modules linked in: fglrx(P) nfs ipv6 nfsd exportfs lockd nfs_acl sunrpc pp
dev lp autofs4 deflate zlib_deflate twofish twofish_common camellia serpent blowfish des cbc ecb blkcipher aes xcbc 
sha256 sha1 crypto_null af_key piix ide_core dm_crypt dm_snapshot dm_mirror dm_mod sbp2 loop coretemp cpufreq_conser
vative cpufreq_stats acpi_cpufreq freq_table pcmcia snd_hda_intel usbhid snd_pcm_oss snd_mixer_oss pl2303 ipw3945 ye
nta_socket snd_pcm ohci1394 ieee1394 tifm_7xx1 joydev snd_timer usbserial tsdev tpm_infineon sdhci rsrc_nonstatic ie
ee80211 ieee80211_crypt parport_pc snd tpm fw_ohci fw_core parport firmware_class iTCO_wdt iTCO_vendor_support sg ps
mouse pcmcia_core tg3 mmc_core crc_itu_t tifm_core pcspkr tpm_bios soundcore snd_page_alloc intel_agp sr_mod serio_r
aw ehci_hcd uhci_hcd cdrom evdev
May 17 11:36:57 zv kernel: [  647.184514] Pid: 1716, comm: kjournald Tainted: P       2.6.22-rc1-cfs-v12 #2
May 17 11:36:57 zv kernel: [  647.184519] RIP: 0010:[<ffffffff8029200f>]  [<ffffffff8029200f>] kmem_cache_alloc+0x2f
/0x60
May 17 11:36:57 zv kernel: [  647.184528] RSP: 0018:ffff81003e399d00  EFLAGS: 00010002
May 17 11:36:57 zv kernel: [  647.184533] RAX: 0000000000000000 RBX: 0000000000000206 RCX: 0000000000000001
May 17 11:36:57 zv kernel: [  647.184538] RDX: ffff810001a269d0 RSI: 0000000000011200 RDI: ffffffff80610070
May 17 11:36:57 zv kernel: [  647.184543] RBP: ffff81003ff9d000 R08: 0000000000000003 R09: 0000000000000000
May 17 11:36:57 zv kernel: [  647.184548] R10: 0000000000000000 R11: ffffffff802f00c0 R12: 0000000000011210
May 17 11:36:57 zv kernel: [  647.184554] R13: ffff81003ff9d030 R14: ffff81003e399d10 R15: 0000000000000010
May 17 11:36:57 zv kernel: [  647.184560] FS:  0000000000000000(0000) GS:ffff810001fbd080(0000) knlGS:00000000000000
00
May 17 11:36:57 zv kernel: [  647.184565] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
May 17 11:36:57 zv kernel: [  647.184569] CR2: 0000000000000001 CR3: 0000000021285000 CR4: 00000000000006e0
May 17 11:36:57 zv kernel: [  647.184576] Process kjournald (pid: 1716, threadinfo ffff81003e398000, task ffff81003e
36a000)
May 17 11:36:57 zv kernel: [  647.184580] Stack:  0000000000000001 ffffffff80272433 ffff810035e49180 ffffffff802fe7f
2
May 17 11:36:57 zv kernel: [  647.184591]  ffff810020cc4850 ffff810035e49180 ffff810038bed180 0000000000000004
May 17 11:36:57 zv kernel: [  647.184600]  ffff81003f453420 0000000000000001 0000000000000001 ffff810035e49180
May 17 11:36:57 zv kernel: [  647.184607] Call Trace:
May 17 11:36:57 zv kernel: [  647.184617]  [<ffffffff80272433>] mempool_alloc+0x43/0x120
May 17 11:36:57 zv kernel: [  647.184626]  [<ffffffff802fe7f2>] __journal_file_buffer+0xe2/0x240
May 17 11:36:57 zv kernel: [  647.184640]  [<ffffffff802bf0f4>] bio_alloc_bioset+0x34/0x120
May 17 11:36:57 zv kernel: [  647.184651]  [<ffffffff802bf240>] bio_alloc+0x10/0x30
May 17 11:36:57 zv kernel: [  647.184657]  [<ffffffff802bb04f>] submit_bh+0x5f/0x130
May 17 11:36:57 zv kernel: [  647.184666]  [<ffffffff80302453>] journal_commit_transaction+0x1013/0x13f0
May 17 11:36:57 zv kernel: [  647.184677]  [<ffffffff804a21fc>] thread_return+0x51/0x675
May 17 11:36:57 zv kernel: [  647.184688]  [<ffffffff80242564>] lock_timer_base+0x34/0x70
May 17 11:36:57 zv kernel: [  647.184702]  [<ffffffff8030686f>] kjournald+0xdf/0x240
May 17 11:36:57 zv kernel: [  647.184712]  [<ffffffff8024e760>] autoremove_wake_function+0x0/0x30
May 17 11:36:57 zv kernel: [  647.184720]  [<ffffffff80306790>] kjournald+0x0/0x240
May 17 11:36:57 zv kernel: [  647.184727]  [<ffffffff80306790>] kjournald+0x0/0x240
May 17 11:36:57 zv kernel: [  647.184735]  [<ffffffff8024e39b>] kthread+0x4b/0x80
May 17 11:36:57 zv kernel: [  647.184743]  [<ffffffff8020b0f8>] child_rip+0xa/0x12
May 17 11:36:57 zv kernel: [  647.184765]  [<ffffffff8020b0ee>] child_rip+0x0/0x12
May 17 11:36:57 zv kernel: [  647.184771] 
May 17 11:36:57 zv kernel: [  647.184774] 
May 17 11:36:57 zv kernel: [  647.184775] Code: 48 8b 04 c1 48 89 42 10 53 9d 5b 48 89 c8 c3 66 90 49 89 d0 
May 17 11:36:57 zv kernel: [  647.184801]  RSP <ffff81003e399d00>

:) game over. *sighs*

May 17 11:37:26 zv kernel: [  675.960418] SysRq : Emergency Sync
May 17 11:37:26 zv kernel: [  675.965493] Emergency Sync complete
May 17 11:37:26 zv kernel: [  676.652982] SysRq : Emergency Sync
May 17 11:37:26 zv kernel: [  676.653112] Emergency Sync complete
May 17 11:37:27 zv kernel: [  677.425588] SysRq : Emergency Sync
May 17 11:37:27 zv kernel: [  677.426232] Emergency Sync complete
May 17 11:37:29 zv kernel: [  679.500230] SysRq : Emergency Sync
May 17 11:37:29 zv kernel: [  679.500385] Emergency Sync complete
May 17 11:37:38 zv kernel: [  688.671466] SysRq : Emergency Sync
May 17 11:37:38 zv kernel: [  688.675806] Emergency Sync complete
May 17 11:37:39 zv kernel: [  689.012734] SysRq : Emergency Sync
May 17 11:37:39 zv kernel: [  689.012881] Emergency Sync complete
May 17 11:37:39 zv kernel: [  689.575176] SysRq : Emergency Remount R/O
May 17 11:37:40 zv kernel: [  690.296747] SysRq : Emergency Remount R/O



On Thu, 2007-05-17 at 11:21 +0300, Zilvinas Valinskas wrote:
> Hello Oleg, 
> 
> Patch seems to help and it seems kernel doesn't free anymore. I've
> booted new kernel and did :
> 
> #1 $ sudo /etc/init.d/nfs-kernel-server stop
> #2 $ sudo /etc/init.d/nfs-common stop
> 
> Previously it was enough to run '#1' to freeze the kernel. This time
> with your patch applied #1 and #2 worked fine. So far so good. Don't
> know why , but I've tried to run #1 & #2 several times  - as a result
> OOPS (kernel is tainted). Opps from dmesg:
> 
> [  429.103734] usb 1-5.4: link qh8-0601/ffff81003ebac320 start 7 [1/2 us]
> [  436.009276] nfsd: last server has exited
> [  436.009410] nfsd: unexporting all filesystems
> [  436.011395] RPC: failed to contact local rpcbind server (errno 5).
> [  460.950495] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> [  460.950659] NFSD: starting 90-second grace period
> [  615.796112] nfsd: last server has exited
> [  615.796121] nfsd: unexporting all filesystems
> [  615.800976] RPC: failed to contact local rpcbind server (errno 5).
> [  619.444368] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> [  619.444403] NFSD: starting 90-second grace period
> [  620.576730] nfsd: last server has exited
> [  620.576739] nfsd: unexporting all filesystems
> [  620.581036] RPC: failed to contact local rpcbind server (errno 5).
> [  621.606324] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> [  621.606359] NFSD: starting 90-second grace period
> [  622.561989] nfsd: last server has exited
> [  622.561999] nfsd: unexporting all filesystems
> [  623.639396] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> [  623.639430] NFSD: starting 90-second grace period
> [  623.639487] Unable to handle kernel paging request at ffffffff00000000 RIP: 
> [  623.639492]  [<ffffffff8041c47f>] __kfree_skb+0x9f/0x150
> [  623.639504] PGD 203067 PUD 0 
> [  623.639510] Oops: 0002 [1] PREEMPT SMP 
> [  623.639515] CPU 0 
> [  623.639519] Modules linked in: fglrx(P) nfs nfsd exportfs lockd nfs_acl sunrpc ppdev lp autofs4 ipw3945 ieee80211 ieee80211_crypt ipv6 deflate zlib_deflate twofish twofish_common camellia serpent blowfish des cbc ecb blkcipher aes xcbc sha256 sha1 crypto_null af_key piix ide_core dm_crypt dm_snapshot dm_mirror dm_mod sbp2 loop coretemp cpufreq_conservative cpufreq_stats acpi_cpufreq freq_table usbhid pl2303 ohci1394 ieee1394 usbserial pcmcia firmware_class snd_hda_intel snd_pcm_oss snd_mixer_oss sdhci snd_pcm joydev iTCO_wdt fw_ohci fw_core mmc_core snd_timer tg3 sg snd yenta_socket rsrc_nonstatic pcmcia_core crc_itu_t iTCO_vendor_support tifm_7xx1 tsdev parport_pc parport intel_agp tpm_infineon tpm tpm_bios uhci_hcd sr_mod tifm_core ehci_hcd psmouse soundcore snd_page_alloc pcspkr serio_raw evdev cdrom
> [  623.639616] Pid: 616, comm: udevd Tainted: P       2.6.22-rc1-cfs-v12 #2
> [  623.639622] RIP: 0010:[<ffffffff8041c47f>]  [<ffffffff8041c47f>] __kfree_skb+0x9f/0x150
> [  623.639631] RSP: 0018:ffff81003ed87be8  EFLAGS: 00010286
> [  623.639635] RAX: ffff81003f2144a0 RBX: 0000000000000000 RCX: 0000000000000000
> [  623.639641] RDX: 0000000000000130 RSI: ffff8100285eb400 RDI: ffffffff00000000
> [  623.639646] RBP: ffff8100285eb400 R08: 000000000050eaf0 R09: 0000000000000000
> [  623.639651] R10: 0000000000000000 R11: 0000000000000246 R12: ffff81003f214400
> [  623.639656] R13: ffff81003ed87ee8 R14: ffff8100285eb440 R15: 0000000000000000
> [  623.639662] FS:  00002b0370c18e00(0000) GS:ffffffff80603000(0000) knlGS:0000000000000000
> [  623.639667] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  623.639672] CR2: ffffffff00000000 CR3: 000000003ed6c000 CR4: 00000000000006e0
> [  623.639678] Process udevd (pid: 616, threadinfo ffff81003ed86000, task ffff81003ecd0000)
> [  623.639682] Stack:  ffff81003ed87ee8 ffff81003ed87e68 ffff8100285eb400 ffffffff8043b6a6
> [  623.639694]  0000000100000000 ffff810001ff7b80 0000000000000050 ffff81003ed87db8
> [  623.639702]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
> [  623.639709] Call Trace:
> [  623.639719]  [<ffffffff8043b6a6>] netlink_recvmsg+0x176/0x3a0
> [  623.639739]  [<ffffffff80415b80>] sock_recvmsg+0x150/0x170
> [  623.639754]  [<ffffffff8024e760>] autoremove_wake_function+0x0/0x30
> [  623.639768]  [<ffffffff802a531e>] core_sys_select+0x26e/0x350
> [  623.639785]  [<ffffffff802a9f05>] __d_lookup+0x165/0x180
> [  623.639797]  [<ffffffff80416f8e>] sys_recvfrom+0xfe/0x190
> [  623.639807]  [<ffffffff8024e969>] remove_wait_queue+0x19/0x60
> [  623.639823]  [<ffffffff802a5874>] sys_select+0x44/0x1c0
> [  623.639836]  [<ffffffff8020a2ae>] system_call+0x7e/0x83
> [  623.639849] 
> [  623.639851] 
> [  623.639852] Code: f0 ff 0f 0f 94 c0 84 c0 75 27 66 c7 85 a8 00 00 00 00 00 66 
> [  623.639871] RIP  [<ffffffff8041c47f>] __kfree_skb+0x9f/0x150
> [  623.639878]  RSP <ffff81003ed87be8>
> [  623.639881] CR2: ffffffff00000000
> 
> Hmm, I've got something different now :( - 
> 
> 
> On Thu, 2007-05-17 at 02:55 +0400, Oleg Nesterov wrote:
> > On Wed, 16 May 2007 21:00:41 +0300
> > Zilvinas Valinskas <zilvinas@wilibox.com> wrote:
> > > 
> > > In short, on shutdown my laptop is always freezing now. I was able to
> > > capture the 'sysrq-P' (hit that several times), sysrq-T outputs. Please
> > > see .config and log messages at http://barclay.balt.net/~zilvinas/oops/ 
> > > 
> > > Kernel version I had built according git is :
> > > 
> > > zilvinas@zv:/projects/linux-amd64.git$ git describe HEAD
> > > v2.6.22-rc1-29-gfaa8b6c
> > > 
> > > On top of that I have CFS v12 applied (no other changes otherwise).
> > > Please note that there is ''fglrx.ko'' loaded and kernel is tainted
> > > because of that (feel free to ignore the report ...).
> > > 
> > > Anyway, 'sysrq-P' always show that PC is stuck at (NFS lockd?) and it is
> > > always the same backtrace is shown. 'sysrq-t' output is in
> > > 'kernel-nfs-freeze.log' file (did not want to post it here).
> > > 
> > >  Pid: 3652, comm: lockd Tainted: P       2.6.22-rc1-cfs-v12 #1
> > > 
> > > [<ffffffff8024a5a0>] wq_barrier_func+0x0/0x10
> > > [<ffffffff8024a7e5>] destroy_workqueue+0x75/0xa0
> > > [<ffffffff8833cd34>] :sunrpc:rpciod_down+0xf4/0x170
> > > [<ffffffff8836dd74>] :lockd:lockd+0x244/0x300
> > > [<ffffffff80233e1f>] schedule_tail+0x3f/0xb0
> > > [<ffffffff8020b0f8>] child_rip+0xa/0x12
> > > [<ffffffff8836db30>] :lockd:lockd+0x0/0x300
> > > [<ffffffff8836db30>] :lockd:lockd+0x0/0x300
> > > [<ffffffff8020b0ee>] child_rip+0x0/0x12
> > > 
> > > Hope this helps. Thanks in advance for any advice how to solve problem !
> > > For now I am back to '2.6.21.1-cfs-v10'.
> > > 
> > 
> > Nice, thanks.
> > 
> > Zilvinas, could you try the patch below?
> > 
> > It is a shot in the dark. I hope I'll suggest somethimg better tomorrow.
> > 
> > Oleg.
> > 
> > --- OLD/kernel/workqueue.c~	2007-05-17 00:15:37.000000000 +0400
> > +++ OLD/kernel/workqueue.c	2007-05-17 02:51:15.000000000 +0400
> > @@ -752,16 +752,25 @@ static void cleanup_workqueue_thread(str
> >  	spin_unlock_irq(&cwq->lock);
> >  
> >  	if (alive) {
> > +		int n;
> > +
> >  		wait_for_completion(&barr.done);
> >  
> > -		while (unlikely(cwq->thread != NULL))
> > -			cpu_relax();
> > -		/*
> > -		 * Wait until cwq->thread unlocks cwq->lock,
> > -		 * it won't touch *cwq after that.
> > -		 */
> > -		smp_rmb();
> > -		spin_unlock_wait(&cwq->lock);
> > +		for (n = 0;; ++n) {
> > +			spin_lock_irq(&cwq->lock);
> > +			alive = (cwq->thread != NULL);
> > +			spin_unlock_irq(&cwq->lock);
> > +
> > +			if (!alive)
> > +				break;
> > +
> > +			if (n > 1000) {
> > +				printk(KERN_CRIT "ERR!! wq: %s\n", cwq->wq->name);
> > +				break;
> > +			}
> > +
> > +			yield();
> > +		}
> >  	}
> >  }
> >  
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

