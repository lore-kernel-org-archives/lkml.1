Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbZHLSnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbZHLSnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 14:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbZHLSnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 14:43:31 -0400
Received: from radon.netxsys.com ([204.16.202.162]:41712 "EHLO
	radon.netxsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbZHLSnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 14:43:31 -0400
X-Greylist: delayed 1282 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Aug 2009 14:43:30 EDT
Message-ID: <48078.205.189.93.240.1250101329.squirrel@webmail.netxsys.com>
Date: Wed, 12 Aug 2009 14:22:09 -0400 (EDT)
Subject: WARNING: at drivers/ata/libata-core.c:5090 
     ata_qc_issue+0x105/0x2f3 [libata](), kernel 2.6.30.4
From: "Krzysztof Adamski" <k@adamski.org>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20090812142209_89889"
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20090812142209_89889
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

I'm not sure if this the right place to post this stack trace, if there is
a better place, please let me know.

I was doing an rsync when I got this trace.
This is in a 2.6.30.4 self compiled 64 bit kernel, running on a Phenon
945, the file system is XFS on a RAID5 MD array.

K
------=_20090812142209_89889
Content-Type: text/plain; name="stack-trace.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="stack-trace.txt"

Aug 12 10:53:38 Nitrogen kernel: [66623.989645] ------------[ cut here ]------------
Aug 12 10:53:38 Nitrogen kernel: [66623.989725] WARNING: at drivers/ata/libata-core.c:5090 ata_qc_issue+0x105/0x2f3 [libata]()
Aug 12 10:53:38 Nitrogen kernel: [66623.989833] Hardware name: GA-MA790FXT-UD5P
Aug 12 10:53:38 Nitrogen kernel: [66623.989887] Modules linked in: sg ipv6 xfs exportfs cpufreq_ondemand freq_table sbp2 loop snd_hda_c
odec_realtek mvsas libsas firmware_class snd_hda_intel snd_hda_codec i2c_piix4 scsi_transport_sas snd_hwdep i2c_core processor snd_pcm snd_timer snd soundcore snd_page_alloc pcspkr evdev button ext3 jbd mbcache dm_mirror dm_region_hash dm_log dm_snapshot dm_mod raid456 raid6_pq async_xor async_memcpy async_tx xor raid1 md_mod sd_mod crc_t10dif ata_generic jmicron ohci1394 ieee1394 atiixp ahci ehci_hcd ide_pci_generic libata ide_core ohci_hcd scsi_mod r8169 mii floppy thermal fan thermal_sys
Aug 12 10:53:38 Nitrogen kernel: [66623.990480] Pid: 30596, comm: ssh Not tainted 2.6.30.4-KAA #2
Aug 12 10:53:38 Nitrogen kernel: [66623.990535] Call Trace:
Aug 12 10:53:38 Nitrogen kernel: [66623.990576]  <IRQ>  [<ffffffffa0099fd6>] ? ata_qc_issue+0x105/0x2f3 [libata]
Aug 12 10:53:38 Nitrogen kernel: [66623.990653]  [<ffffffffa0099fd6>] ? ata_qc_issue+0x105/0x2f3 [libata]
Aug 12 10:53:38 Nitrogen kernel: [66623.990713]  [<ffffffff8023a9bd>] ? warn_slowpath_common+0x77/0xa3
Aug 12 10:53:38 Nitrogen kernel: [66623.990780]  [<ffffffffa003f701>] ? scsi_finish_command+0x3f/0xf0 [scsi_mod]
Aug 12 10:53:38 Nitrogen kernel: [66623.990850]  [<ffffffffa0099fd6>] ? ata_qc_issue+0x105/0x2f3 [libata]
Aug 12 10:53:38 Nitrogen kernel: [66623.990917]  [<ffffffffa003f7b2>] ? scsi_done+0x0/0xc [scsi_mod]
Aug 12 10:53:38 Nitrogen kernel: [66623.990984]  [<ffffffffa009e91e>] ? ata_scsi_translate+0xf1/0x127 [libata]
Aug 12 10:53:38 Nitrogen kernel: [66623.991057]  [<ffffffffa003f7b2>] ? scsi_done+0x0/0xc [scsi_mod]
Aug 12 10:53:38 Nitrogen kernel: [66623.991121]  [<ffffffffa02af33f>] ? sas_queuecommand+0x82/0x26b [libsas]
Aug 12 10:53:38 Nitrogen kernel: [66623.991194]  [<ffffffffa003fa8e>] ? scsi_dispatch_cmd+0x1ca/0x245 [scsi_mod]
Aug 12 10:53:38 Nitrogen kernel: [66623.991275]  [<ffffffffa004507e>] ? scsi_request_fn+0x3a4/0x4f0 [scsi_mod]
Aug 12 10:53:38 Nitrogen kernel: [66623.991335]  [<ffffffff8022df0e>] ? __wake_up+0x38/0x4f
Aug 12 10:53:38 Nitrogen kernel: [66623.991390]  [<ffffffff8033be66>] ? blk_invoke_request_fn+0x70/0x139
Aug 12 10:53:38 Nitrogen kernel: [66623.991452]  [<ffffffff8033c8ce>] ? blk_run_queue+0x21/0x35
Aug 12 10:53:38 Nitrogen kernel: [66623.991518]  [<ffffffffa00445df>] ? scsi_run_queue+0x2df/0x379 [scsi_mod]
Aug 12 10:53:38 Nitrogen kernel: [66623.991587]  [<ffffffffa00453bc>] ? scsi_next_command+0x2d/0x39 [scsi_mod]
Aug 12 10:53:38 Nitrogen kernel: [66623.991657]  [<ffffffffa0045f46>] ? scsi_io_completion+0x421/0x467 [scsi_mod]
Aug 12 10:53:38 Nitrogen kernel: [66623.991719]  [<ffffffff803404b6>] ? blk_done_softirq+0x62/0x6f
Aug 12 10:53:38 Nitrogen kernel: [66623.991776]  [<ffffffff8023f602>] ? __do_softirq+0xa6/0x168
Aug 12 10:53:38 Nitrogen kernel: [66623.991832]  [<ffffffff8020ca7c>] ? call_softirq+0x1c/0x28
Aug 12 10:53:38 Nitrogen kernel: [66623.991886]  [<ffffffff8020e254>] ? do_softirq+0x2c/0x68
Aug 12 10:53:38 Nitrogen kernel: [66623.991942]  [<ffffffff8023f314>] ? irq_exit+0x3f/0x7c
Aug 12 10:53:38 Nitrogen kernel: [66623.991995]  [<ffffffff8020db36>] ? do_IRQ+0xa9/0xbf
Aug 12 10:53:38 Nitrogen kernel: [66623.992057]  [<ffffffff8020c353>] ? ret_from_intr+0x0/0xa
Aug 12 10:53:38 Nitrogen kernel: [66623.992121]  <EOI>  [<ffffffff8042b87c>] ? tcp_recvmsg+0x1e7/0xa28
Aug 12 10:53:38 Nitrogen kernel: [66623.992190]  [<ffffffff8042bd91>] ? tcp_recvmsg+0x6fc/0xa28
Aug 12 10:53:38 Nitrogen kernel: [66623.992256]  [<ffffffff803f5534>] ? sock_common_recvmsg+0x30/0x45
Aug 12 10:53:38 Nitrogen kernel: [66623.992323]  [<ffffffff803f3523>] ? sock_aio_read+0x103/0x117
Aug 12 10:53:38 Nitrogen kernel: [66623.992390]  [<ffffffff802bce59>] ? do_sync_read+0xce/0x113
Aug 12 10:53:38 Nitrogen kernel: [66623.992454]  [<ffffffff8024cdf2>] ? autoremove_wake_function+0x0/0x2e
Aug 12 10:53:38 Nitrogen kernel: [66623.992524]  [<ffffffff804708e8>] ? thread_return+0x3e/0xaa
Aug 12 10:53:38 Nitrogen kernel: [66623.992587]  [<ffffffff802bd9a4>] ? vfs_read+0xbd/0x153
Aug 12 10:53:38 Nitrogen kernel: [66623.992649]  [<ffffffff802bdaf6>] ? sys_read+0x45/0x6e
Aug 12 10:53:38 Nitrogen kernel: [66623.992709]  [<ffffffff8020b9ab>] ? system_call_fastpath+0x16/0x1b
Aug 12 10:53:38 Nitrogen kernel: [66623.992773] ---[ end trace 659503649685d5b5 ]---
------=_20090812142209_89889--

