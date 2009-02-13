Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbZBMLph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbZBMLph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 06:45:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbZBMLp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 06:45:27 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:58369 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbZBMLpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 06:45:25 -0500
To: linux-kernel@vger.kernel.org
Subject: [2.6.27.16] NULL pointer dereference at show_docked()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200902132045.FFG87556.OFSFOMHFVJQtLO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Fri, 13 Feb 2009 20:45:21 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I encountered this on Ubuntu 8.04 on ThinkPad X60 with a dockable station
docked. The dockable station's removable slot holds a HDD.

Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.27.16 .
Full log is at http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.27.16-native.txt .

----------------------------------------
BUG: unable to handle kernel NULL pointer dereference at 00000000
IP: [<c051f9e3>] show_docked+0xe/0x37
Oops: 0000 [#1] SMP 
Modules linked in: uinput acpi_cpufreq cpufreq_conservative cpufreq_ondemand cpufreq_powersave cpufreq_stats sbs sbshc iptable_filter ip_tables x_tables firewire_sbp2 ipv6 lp snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi battery snd_seq_midi_event snd_seq ac snd_timer serio_raw snd_seq_device e1000e snd soundcore button parport_pc parport snd_page_alloc pcspkr ext3 jbd sg sd_mod ahci ata_piix libata firewire_ohci firewire_core crc_itu_t scsi_mod ehci_hcd uhci_hcd

Pid: 4135, comm: hald Not tainted (2.6.27.16 #1)
EIP: 0060:[<c051f9e3>] EFLAGS: 00010286 CPU: 0
EIP is at show_docked+0xe/0x37
EAX: 00000000 EBX: f6d06000 ECX: f6d06000 EDX: f7b5cf44
ESI: fffffffb EDI: c051f9d5 EBP: c06e0ec4 ESP: f7b5cf44
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process hald (pid: 4135, ti=f7b5c000 task=f7b756c0 task.ti=f7b5c000)
Stack: f6ca4200 c06d9930 c054dd1e f6ca4200 ffffffed f742479c c04a474f 00001000 
       b7be6000 f6ca4214 f7474080 f7517840 b7be6000 c04a46c5 00001000 c046ccfd 
       f7b5cfa0 f7517840 fffffff7 00000000 f7b5c000 c046cfd7 f7b5cfa0 00000000 
Call Trace:
 [<c054dd1e>] dev_attr_show+0x16/0x32
 [<c04a474f>] sysfs_read_file+0x8a/0xe9
 [<c04a46c5>] sysfs_read_file+0x0/0xe9
 [<c046ccfd>] vfs_read+0x81/0xf4
 [<c046cfd7>] sys_read+0x3c/0x63
 [<c0403755>] sysenter_do_call+0x12/0x21
 =======================
Code: fc ff ba 02 00 00 00 59 58 8d 83 80 00 00 00 8d 4c 24 10 e8 2a 14 fc ff 83 c4 18 5b c3 53 89 cb 83 ec 04 8b 80 d8 00 00 00 89 e2 <8b> 00 8b 00 e8 2b d0 ff ff 85 c0 75 07 68 4a 9e 67 c0 eb 05 68 
EIP: [<c051f9e3>] show_docked+0xe/0x37 SS:ESP 0068:f7b5cf44
---[ end trace dd5996939b747ef2 ]---

So far I haven't encountered this regarding 2.6.26.8 and 2.6.28.5 .

Regards.
