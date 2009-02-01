Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbZBAUA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbZBAUA7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 15:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837AbZBAUAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 15:00:51 -0500
Received: from relay1.ptmail.sapo.pt ([212.55.154.21]:41099 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752064AbZBAUAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 15:00:50 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Feb 2009 15:00:50 EST
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Sun, 1 Feb 2009 19:52:59 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUG -rt] scheduling while atomic in -rt git tree
Message-ID: <20090201195259.GB5383@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am using an x86_64 and getting the following log while executing the master in
the -rt git tree:

[   28.182621] BUG: scheduling while atomic: sirq-net-rx/0/8/0x00000101, CPU#0
[   28.182744] Modules linked in: parport_pc ppdev parport ipv6 powernow_k8
cpufreq_stats cpufreq_conservative cpufreq_ondemand freq_table cpufreq_powersave
cpufreq_userspace af_packet sbp2 loop joydev arc4 snd_hda_intel ecb snd_pcm
snd_page_alloc uvcvideo snd_hwdep ath5k snd_seq compat_ioctl32 mac80211 psmouse
snd_timer videodev snd_seq_device k8temp v4l1_compat led_class snd soundcore
cfg80211 rfkill input_polldev battery video output ac button evdev ext3 jbd
mbcache sg sr_mod cdrom ide_pci_generic ide_core ata_generic sd_mod pata_acpi
ohci1394 ahci ehci_hcd pata_atiixp ohci_hcd ieee1394 libata usbcore scsi_mod
r8169 mii thermal processor fan
[   28.186632] Pid: 8, comm: sirq-net-rx/0 Tainted: G        W
2.6.28-rt-00209-g82e0a07 #1
[   28.186747] Call Trace:
[   28.186831]  [<ffffffff80455cb4>] ? netif_receive_skb+0x2c4/0x590
[   28.186938]  [<ffffffff80242795>] __schedule_bug+0x85/0x90
[   28.187033]  [<ffffffff804ead38>] thread_return+0x142/0x70a
[   28.187127]  [<ffffffff8020c3c8>] ? ftrace_call+0x5/0x2b
[   28.187218]  [<ffffffff8024f42f>] ksoftirqd+0x1df/0x270
[   28.187306]  [<ffffffff8024f250>] ? ksoftirqd+0x0/0x270
[   28.187395]  [<ffffffff802621de>] kthread+0x4e/0x90
[   28.187481]  [<ffffffff8020d639>] child_rip+0xa/0x11
[   28.187569]  [<ffffffff802408d9>] ? finish_task_switch+0x59/0x130
[   28.187663]  [<ffffffff804ed1ab>] ? _spin_unlock_irq+0x1b/0x40
[   28.187753]  [<ffffffff8020cb25>] ? restore_args+0x0/0x30
[   28.187842]  [<ffffffff80262190>] ? kthread+0x0/0x90
[   28.187929]  [<ffffffff8020d62f>] ? child_rip+0x0/0x11
[   28.188034] ---------------------------
[   28.188111] | preempt count: 00000101 ]
[   28.188189] | 2-level deep critical section nesting:
[   28.188272] ----------------------------------------
[   28.188356] .. [<ffffffff804a9c16>] .... icmp_send+0xc6/0x6a0
[   28.188497] .....[<ffffffff804a9c16>] ..   ( <= icmp_send+0xc6/0x6a0)
[   28.188639] .. [<ffffffff804ea7ac>] .... schedule+0x2c/0x476
[   28.188777] .....[<ffffffff8024f42f>] ..   ( <= ksoftirqd+0x1df/0x270)
[   28.188918] 

Can also provide my config file if needed.

-- 
Luis Henriques
