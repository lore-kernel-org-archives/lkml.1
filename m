Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbZCZAqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbZCZAqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 20:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbZCZAqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 20:46:46 -0400
Received: from rotring.dds.nl ([85.17.178.138]:47251 "EHLO rotring.dds.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbZCZAqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 20:46:45 -0400
X-Greylist: delayed 1619 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Mar 2009 20:46:45 EDT
Message-ID: <49CACA17.3020805@skku.edu>
Date: Thu, 26 Mar 2009 09:19:35 +0900
From: Rob Lahaye <lahaye@skku.edu>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.27.19-170.2.35.fc10.i686 freezes Intel PC
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[1.]
At certain moment the PC become totally unresponsive.

[2.]
I have no idea what has gone wrong; the computer was
running on its own in my office while I was home.
Local time was about 9pm.

All I have is the kernel trace from the /var/log/messages
file:

Mar 25 20:23:20 skku kernel: ------------[ cut here ]------------
Mar 25 20:23:20 skku kernel: WARNING: at lib/list_debug.c:48 
list_del+0x22/0x60()
Mar 25 20:23:20 skku kernel: Hardware name: System Product Name
Mar 25 20:23:20 skku kernel: list_del corruption. prev->next should be 
c136a258, but was 00000000
Mar 25 20:23:20 skku kernel: Modules linked in: fuse i915 drm sco bridge 
stp bnep l2cap bluetooth coretemp w83627ehf hwmon_vid hwmon 
ipt_MASQUERADE iptable_nat nf_nat ip6t_REJECT nf_conntrack_ipv6 
ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq 
dm_multipath uinput snd_hda_intel snd_seq_dummy snd_seq_oss 
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss 
snd_pcm i2c_i801 i2c_core snd_timer snd_page_alloc snd_hwdep snd 
soundcore pata_jmicron firewire_ohci skge 8139cp iTCO_wdt 
iTCO_vendor_support pcspkr firewire_core crc_itu_t 8139too mii 
ata_generic pata_acpi [last unloaded: microcode]
Mar 25 20:23:20 skku kernel: Pid: 696, comm: kjournald Not tainted 
2.6.27.19-170.2.35.fc10.i686 #1
Mar 25 20:23:20 skku kernel: [<c042db04>] warn_slowpath+0x69/0x89
Mar 25 20:23:20 skku kernel: [<c0422674>] ? dequeue_entity+0x15/0x13a
Mar 25 20:23:20 skku kernel: [<c0422b78>] ? dequeue_task_fair+0x3d/0x42
Mar 25 20:23:20 skku kernel: [<c04d5639>] ? ext3_get_block+0x9d/0xd2
Mar 25 20:23:20 skku kernel: [<c046f9a6>] ? find_get_page+0x1d/0x81
Mar 25 20:23:20 skku kernel: [<c05231fa>] list_del+0x22/0x60
Mar 25 20:23:20 skku kernel: [<c0476eed>] activate_page+0x4e/0xad
Mar 25 20:23:20 skku kernel: [<c0476f86>] mark_page_accessed+0x3a/0x57
Mar 25 20:23:20 skku kernel: [<c04af54b>] __find_get_block+0x1ab/0x1b5
Mar 25 20:23:20 skku kernel: [<c04af56f>] __getblk+0x1a/0x264
Mar 25 20:23:20 skku kernel: [<c04aff62>] ? sync_buffer+0x0/0x37
Mar 25 20:23:20 skku kernel: [<c048ce19>] ? virt_to_head_page+0x22/0x2e
Mar 25 20:23:20 skku kernel: [<c04e6137>] ? journal_next_log_block+0x5f/0x65
Mar 25 20:23:20 skku kernel: [<c04e616e>] 
journal_get_descriptor_buffer+0x31/0x72
Mar 25 20:23:20 skku kernel: [<c04e311e>] 
journal_commit_transaction+0x930/0xc72
Mar 25 20:23:20 skku kernel: [<c043692e>] ? lock_timer_base+0x1f/0x3e
Mar 25 20:23:20 skku kernel: [<c0436995>] ? try_to_del_timer_sync+0x48/0x4f
Mar 25 20:23:20 skku kernel: [<c04e5b5a>] kjournald+0xbb/0x1ee
Mar 25 20:23:20 skku kernel: [<c043ef62>] ? 
autoremove_wake_function+0x0/0x33
Mar 25 20:23:20 skku kernel: [<c04e5a9f>] ? kjournald+0x0/0x1ee
Mar 25 20:23:20 skku kernel: [<c043ecbf>] kthread+0x3b/0x61
Mar 25 20:23:20 skku kernel: [<c043ec84>] ? kthread+0x0/0x61
Mar 25 20:23:20 skku kernel: [<c040590b>] kernel_thread_helper+0x7/0x10
Mar 25 20:23:20 skku kernel: =======================
Mar 25 20:23:20 skku kernel: ---[ end trace ac8e1bdd82694409 ]---

R.L.
