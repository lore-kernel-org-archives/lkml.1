Return-Path: <linux-kernel-owner+w=401wt.eu-S1763480AbZEOSSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763480AbZEOSSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761897AbZEOSRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:17:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55625 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762959AbZEOSRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:17:21 -0400
Date: Fri, 15 May 2009 20:21:31 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 1/2] mac80211: minstrel, fix memory corruption
Message-ID: <20090515182131.GA6439@fancy-poultry.org>
Reply-To: linux-kernel@vger.kernel.org
References: <1241453096-8517-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241453096-8517-1-git-send-email-jirislaby@gmail.com>
Organization: private site
User-Agent: Mutt/1.5.19+20090508 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX1+d0fDgnVc4SsCZsdHE5Xrpz+ZEjE50aZZcUIt
 chXmTrdsVxpTOutO7rdwmFnzFEqsWytK4kMmNUxsSY4Rdgcnir
 hszpySWREoteh/B9Dyei+ageox8sFka
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.05.2009, Jiri Slaby wrote: 

> minstrel doesn't count max rate count in fact, since it doesn't use
> a loop variable `i' and hence allocs space only for bitrates found in
> the first band.
[....]

This patchset crashes my WLAN. Reverting it does fix this:

[....]
wlan0: associated
BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
IP: [<ffffffffa0273b0f>] minstrel_alloc_sta+0x6f/0xf0 [mac80211]
PGD 229da2067 PUD 229d07067 PMD 0 
Oops: 0000 [#1] PREEMPT SMP 
last sysfs file:/sys/devices/pci0000:00/0000:00:02.1/usb1/1-7/1-7:1.0/firmware/1-7:1.0/loading CPU 3 

Modules linked in: af_packet
cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave
powernow_k8 freq_table xt_NOTRACK ipt_REJECT xt_state iptable_raw
iptable_filter nf_conntrack_netbios_ns nf_conntrack_ipv4 nf_conntrack
nf_defrag_ipv4 ip_tables ip6_tables uhci_hcd snd_hda_codec_realtek rt73usb
rt2x00usb rt2x00lib snd_hda_intel ohci1394 snd_hda_codec led_class
ieee1394 input_polldev snd_pcm mac80211 snd_timer rtc_cmos snd ppdev
button forcedeth pcspkr firewire_ohci soundcore i2c_nforce2 rtc_core
rtc_lib parport_pc cfg80211 parport sr_mod snd_page_alloc i2c_core cdrom
sg usbhid ohci_hcd ehci_hcd sd_mod usbcore hmac loop ecb arc4 fuse
edd ext3 jbd fan pata_amd sata_nv libata scsi_mod thermal processor

Pid: 2362, comm: phy0 Not tainted 2.6.30-rc5-git5 #1  
 RIP: 0010:[<ffffffffa0273b0f>][<ffffffffa0273b0f>] minstrel_alloc_sta+0x6f/0xf0 [mac80211]
 RSP: 0018:ffff88022ddc7b90  EFLAGS: 00010206
 RAX: 000000000000000c RBX: ffff88022c150260 RCX: ffff88022c1500c0
 RDX: 0000000000000000 RSI: 0000000000008020 RDI: ffff88022b528740
 RBP: ffff88022b5286c0 R08: 0000000000000000 R09: 0000000000000058
 R10: 000000000000000c R11: ffff88022ddc7cd0 R12: 0000000000008020
 R13: 0000000000000020 R14: 0000000000000020 R15: 0000000000000000
 FS:  00007f6fc24ec6f0(0000) GS:ffff88002807f000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
 CR2: 0000000000000018 CR3: 0000000229dff000 CR4: 00000000000006e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Process phy0 (pid: 2362, threadinfo ffff88022ddc6000, task ffff88022c512cd0)
 Stack: May 15 19:48:40 liesel kernel:0000000000000000 ffff88022c555000 ffff88022c150260 ffff88022f126880
  ffff88022f126600 ffffffffa025c62b ffff88022f126600 ffff88022c150260
  0000000000000053 ffff880229e18044 ffff88022f126880 ffffffffa0264670
 Call Trace:
  [<ffffffffa025c62b>] ? sta_info_alloc+0x8b/0x140 [mac80211]
  [<ffffffffa0264670>] ? ieee80211_rx_mgmt_assoc_resp+0xa20/0xb90 [mac80211]
  [<ffffffffa026f1d1>] ? __ieee80211_tx+0x61/0xd0 [mac80211]
  [<ffffffffa026f34d>] ? ieee80211_tx+0x10d/0x270 [mac80211]
  [<ffffffff8055d25a>] ? thread_return+0x3e/0x6a4
  [<ffffffffa02651f2>] ? ieee80211_sta_work+0xe2/0xab0 [mac80211]
  [<ffffffff80254246>] ? queue_work+0x26/0x60
  [<ffffffffa0265110>] ? ieee80211_sta_work+0x0/0xab0 [mac80211]
  [<ffffffff80253631>] ? worker_thread+0x141/0x230
  [<ffffffff80257c00>] ? autoremove_wake_function+0x0/0x30
  [<ffffffff802534f0>] ? worker_thread+0x0/0x230
  [<ffffffff802534f0>] ? worker_thread+0x0/0x230
  [<ffffffff802577e4>] ? kthread+0x54/0x90
  [<ffffffff8020ce2a>] ? child_rip+0xa/0x20
  [<ffffffff80257790>] ? kthread+0x0/0x90
  [<ffffffff8020ce20>] ? child_rip+0x0/0x20
 Code: 89 c5 31 c0 48 85 ed 74 6c 48 8b 4b
28 31 c0 41 b9 58 00 00 00 44 89 e6 48 8b 51 20 44 8b 52 18 45 85 d2 0f 49
42 18 48 8b 51 28 <39> 42 18 89 c3 0f 4d 5a 18 48 63 fb 49 0f af f9 e8 dc
4e 04 e0 
 RIP  [<ffffffffa0273b0f>] minstrel_alloc_sta+0x6f/0xf0 [mac80211]
 RSP <ffff88022ddc7b90>
 CR2: 0000000000000018
 ---[ end trace 7489e902c4428832 ]---
ifup-dhcp: . 
syslog-ng[3073]: last message repeated 11 times
ifup-dhcp: no IP address yet... backgrounding. 
[....]

Regards,
Heinz.
