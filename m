Return-Path: <linux-kernel-owner+w=401wt.eu-S1759221AbYATBJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221AbYATBJP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 20:09:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755348AbYATBI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 20:08:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45500 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417AbYATBI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 20:08:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc8-mm1: WARN_ON() in clockevents_register_device() on HP nx6325
Date: Sun, 20 Jan 2008 02:10:37 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801200210.38412.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 17 of January 2008, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/
> 
> - selinux is busted on one of my two selinux-enabled test machines.
> 
> - suspend-to-ram and suspend-to-disk are totally hosed on one of my test
>   machines.  I guess I get to bisect this.

Something goes wrong in the timers land.  I get this on boot:

..MP-BIOS bug: 8254 timer not connected to IO-APIC
Disabling APIC timer
------------[ cut here ]------------
WARNING: at /home/rafael/src/mm/linux-2.6.24-rc8-mm1/kernel/time/clockevents.c:1
65 clockevents_register_device+0x36/0xc4()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.24-rc8-mm1-rjw #7

Call Trace:
 [<ffffffff8023874b>] warn_on_slowpath+0x58/0x6b
 [<ffffffff80213a3c>] ? native_read_tsc+0x18/0x22
 [<ffffffff80239527>] ? printk+0x67/0x69
 [<ffffffff802528ee>] clockevents_register_device+0x36/0xc4
 [<ffffffff80220812>] setup_APIC_timer+0x61/0x68
 [<ffffffff806c838f>] setup_boot_APIC_clock+0x1ba/0x1c5
 [<ffffffff806c7450>] smp_prepare_cpus+0x521/0x542
 [<ffffffff806bc56e>] kernel_init+0x64/0x2ef
 [<ffffffff8020ce78>] child_rip+0xa/0x12
 [<ffffffff806bc50a>] ? kernel_init+0x0/0x2ef
 [<ffffffff8020ce6e>] ? child_rip+0x0/0x12

---[ end trace ca143223eefdc828 ]---
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3990.34 BogoMIPS (lpj=7980687)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Turion(tm) 64 X2 Mobile Technology TL-60 stepping 02
------------[ cut here ]------------
Brought up 2 CPUs
WARNING: at /home/rafael/src/mm/linux-2.6.24-rc8-mm1/kernel/time/clockevents.c:1
65 clockevents_register_device+0x36/0xc4()
Modules linked in:
Pid: 0, comm: swapper Not tainted 2.6.24-rc8-mm1-rjw #7

Call Trace:
CPU0 attaching sched-domain:
 [<ffffffff8023874b>] warn_on_slowpath+0x58/0x6b
 domain 0: span 00000000,00000000,00000000,00000003
  groups: 00000000,00000000,00000000,00000001 00000000,00000000,00000000,0000000
2
 [<ffffffff80239527>] ? printk+0x67/0x69
CPU1 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000003
  groups: 00000000,00000000,00000000,00000002 00000000,00000000,00000000,0000000
1
 [<ffffffff8021b133>] ? post_set+0x20/0x3d
 [<ffffffff802528ee>] clockevents_register_device+0x36/0xc4
 [<ffffffff80220812>] setup_APIC_timer+0x61/0x68
 [<ffffffff80220867>] setup_secondary_APIC_clock+0xe/0x10
 [<ffffffff8021fd03>] start_secondary+0x3e1/0x3f5

---[ end trace ca143223eefdc828 ]---

and this on resume from RAM:

Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 1596.25 BogoMIPS (lpj=3192500)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Turion(tm) 64 X2 Mobile Technology TL-60 stepping 02
------------[ cut here ]------------
CPU0 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000003
  groups: 00000000,00000000,00000000,00000001 00000000,00000000,00000000,0000000
2
CPU1 attaching sched-domain:
 domain 0: span 00000000,00000000,00000000,00000003
  groups: 00000000,00000000,00000000,00000002 00000000,00000000,00000000,0000000
1
WARNING: at /home/rafael/src/mm/linux-2.6.24-rc8-mm1/kernel/time/clockevents.c:1
65 clockevents_register_device+0x36/0xc4()
Modules linked in: ip6t_LOG nf_conntrack_ipv6 xt_pkttype ipt_LOG xt_limit af_pac
ket snd_pcm_oss rfkill_input snd_mixer_oss snd_seq snd_seq_device ip6t_REJECT xt
_tcpudp ipt_REJECT xt_state iptable_mangle iptable_nat nf_nat iptable_filter ip6
table_mangle nf_conntrack_ipv4 nf_conntrack ip_tables ip6table_filter ip6_tables
 cpufreq_conservative cpufreq_ondemand cpufreq_userspace x_tables cpufreq_powers
ave ipv6 powernow_k8 freq_table fuse dm_crypt loop dm_mod arc4 ecb crypto_blkcip
her b43 rfkill mac80211 rfcomm snd_hda_intel l2cap cfg80211 snd_pcm snd_timer in
put_polldev led_class yenta_socket snd_page_alloc sdhci ohci1394 fan ssb pcmcia
snd_hwdep rsrc_nonstatic mmc_core tg3 snd usbhid pcmcia_core rtc_cmos battery th
ermal tifm_7xx1 ieee1394 ide_cd_mod button cdrom processor ff_memless joydev hci
_usb rtc_core bluetooth shpchp pci_hotplug k8temp hwmon i2c_piix4 i2c_core tifm_
core ac rtc_lib firmware_class psmouse serio_raw soundcore sg ehci_hcd ohci_hcd
usbcore edd ext3 jbd atiixp ide_core
Pid: 0, comm: swapper Not tainted 2.6.24-rc8-mm1-rjw #7

Call Trace:
 [<ffffffff8023874b>] warn_on_slowpath+0x58/0x6b
 [<ffffffff80239527>] ? printk+0x67/0x69
 [<ffffffff8021b133>] ? post_set+0x20/0x3d
 [<ffffffff802528ee>] clockevents_register_device+0x36/0xc4
 [<ffffffff80220812>] setup_APIC_timer+0x61/0x68
 [<ffffffff80220867>] setup_secondary_APIC_clock+0xe/0x10
 [<ffffffff8021fd03>] start_secondary+0x3e1/0x3f5

---[ end trace ca143223eefdc828 ]---
CPU1 is up
