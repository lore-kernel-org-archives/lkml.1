Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbYKVM3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbYKVM3M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 07:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbYKVM24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 07:28:56 -0500
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:1924 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045AbYKVM2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 07:28:52 -0500
Message-ID: <4927FB01.3050007@shikadi.net>
Date: Sat, 22 Nov 2008 22:28:49 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.8.1.16) Gecko/20080727 Thunderbird/2.0.0.16 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: WARNING: at drivers/ata/libata-eh.c:3247 ata_eh_finish+0x7c/0x8b()
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Just hotplugged a suspect SATA hard drive into my system.  I guess it is 
suspect as there were media errors being logged, but I'm guessing this isn't 
supposed to happen:

------------[ cut here ]------------
WARNING: at drivers/ata/libata-eh.c:3247 ata_eh_finish+0x7c/0x8b()
Modules linked in: isofs zlib_inflate ntfs vfat fat xt_tcpudp gbt_odin 
iptable_filter ip_tables x_tables nfs nfsd lockd nfs_acl sunrpc exportfs 
uinput snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event 
snd_seq snd_seq_device coretemp it87 hwmon_vid vboxdrv nvidiafb fb fb_ddc 
i2c_algo_bit cfbcopyarea vgastate cfbimgblt cfbfillrect r8169 i2c_i801 
snd_hda_intel nvidia(P) snd_pcm snd_timer snd_page_alloc snd_hwdep iTCO_wdt 
psmouse snd serio_raw joydev usbhid hid [last unloaded: xt_LED]
Pid: 1001, comm: scsi_eh_3 Tainted: P           2.6.28-rc2 #4
Call Trace:
  [<ffffffff802327db>] warn_on_slowpath+0x51/0x6d
  [<ffffffff803eef7e>] ahci_postreset+0x0/0x66
  [<ffffffff803ef0b6>] ahci_hardreset+0x0/0xe6
  [<ffffffff803eed39>] ahci_softreset+0x0/0x37
  [<ffffffff803df29f>] ata_std_prereset+0x0/0xb7
  [<ffffffff803e6e12>] ata_eh_finish+0x7c/0x8b
  [<ffffffff803eb3b3>] sata_pmp_error_handler+0x9f8/0xa92
  [<ffffffff80241674>] __cancel_work_timer+0x2f/0x158
  [<ffffffff80500e0d>] _spin_lock_irqsave+0x18/0x34
  [<ffffffff8023b12d>] lock_timer_base+0x26/0x4b
  [<ffffffff803da2c5>] ata_wait_register+0x34/0x70
  [<ffffffff803e7960>] ata_scsi_error+0x2d7/0x57f
  [<ffffffff803c443f>] scsi_error_handler+0x5d/0x2b1
  [<ffffffff803c43e2>] scsi_error_handler+0x0/0x2b1
  [<ffffffff80244380>] kthread+0x47/0x73
  [<ffffffff8020c189>] child_rip+0xa/0x11
  [<ffffffff80244339>] kthread+0x0/0x73
  [<ffffffff8020c17f>] child_rip+0x0/0x11
---[ end trace 066d358fba7ac325 ]---

I doubt the nvidia module has anything to do with this, but if you want me to 
reproduce this on a clean kernel let me know.  I can't reproduce it now as 
that SATA port appears to be dead...

Please let me know if you need any further info.

Cheers,
Adam.
