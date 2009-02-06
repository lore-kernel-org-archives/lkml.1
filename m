Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbZBFI5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbZBFI5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 03:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbZBFI47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 03:56:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:55656 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752387AbZBFI46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 03:56:58 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18LGYo3YsALrZH3aqfYWTjii5PlBx+fwXteeXqC0R
	ZLoUhmOtr5MELP
Subject: x86-tip.today: flood of WARNING: at include/linux/sched.h:2238
	run_posix_cpu_timers+0xea/0x79f()
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 09:56:54 +0100
Message-Id: <1233910614.23431.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Futzing with kerneltop this morning, I fired up amarok to give it
something light to monitor while I hunt missing events.  Something bad
happened, and when I finally (SysRq-E took minutes) got control of box
back, dmesg was full of a steady stream of the below.

That warning can be kinda unfriendly.


[ 9964.600004] ------------[ cut here ]------------
[ 9964.600006] WARNING: at include/linux/sched.h:2238 run_posix_cpu_timers+0xea/0x79f()
[ 9964.600008] Hardware name: MS-7502
[ 9964.600009] Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq snd_seq_device nfsd lockd nfs_acl auth_rpcgss sunrpc exportfs cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq ip_tables ip6_tables microcode nls_iso8859_1 nls_cp437 vfat fat fuse loop dm_mod hid_pl hid_cypress hid_zpff hid_gyration hid_sony hid_samsung hid_microsoft hid_tmff hid_monterey hid_ezkey snd_hda_codec_realtek hid_a4tech hid_logitech ff_memless hid_cherry snd_hda_intel hid_sunplus snd_hda_codec firewire_ohci hid_petalynx firewire_core snd_hwdep snd_pcm hid_belkin snd_timer usbhid hid_chicony usb_storage snd crc_itu_t soundcore rtc_cmos ohci1394 libusual i2c_i801 hid rtc_core ieee1394 sr_mod rtc_lib e1000e snd_page_alloc cdrom intel_agp i2c_core button sg ehci_hcd uhci_hcd sd_mod usbcore edd ext3 mbcache jbd fan ahci libata scsi_mod thermal processor
[ 9964.600051] Pid: 10057, comm: amarokapp Tainted: G        W  2.6.29-tip-smp #126
[ 9964.600052] Call Trace:
[ 9964.600054]  <IRQ>  [<ffffffff80237ee3>] warn_slowpath+0xd3/0x10f
[ 9964.600060]  [<ffffffff802c1513>] ? bio_free+0x4d/0x52
[ 9964.600063]  [<ffffffff8022dc6a>] ? enqueue_task_fair+0x148/0x198
[ 9964.600067]  [<ffffffff8022be89>] ? enqueue_task+0x64/0x6f
[ 9964.600070]  [<ffffffff8022bf87>] ? activate_task+0x22/0x2a
[ 9964.600073]  [<ffffffff802347fd>] ? try_to_wake_up+0x24b/0x25d
[ 9964.600076]  [<ffffffff8023481c>] ? default_wake_function+0xd/0xf
[ 9964.600079]  [<ffffffff8024ae07>] ? autoremove_wake_function+0x11/0x38
[ 9964.600083]  [<ffffffff8022c51f>] ? __wake_up_common+0x46/0x76
[ 9964.600086]  [<ffffffff8022cce2>] ? __wake_up+0x43/0x50
[ 9964.600089]  [<ffffffff8024bfa7>] run_posix_cpu_timers+0xea/0x79f
[ 9964.600093]  [<ffffffff80279155>] ? perf_counter_task_tick+0x8f/0x94
[ 9964.600096]  [<ffffffff80240ff2>] update_process_times+0x57/0x60
[ 9964.600099]  [<ffffffff80254e22>] tick_sched_timer+0x6b/0x95
[ 9964.600102]  [<ffffffff8024d290>] __run_hrtimer+0x51/0x85
[ 9964.600105]  [<ffffffff8024dc92>] hrtimer_interrupt+0xe7/0x141
[ 9964.600108]  [<ffffffff8021db51>] smp_apic_timer_interrupt+0x80/0x98
[ 9964.600111]  [<ffffffff8020c993>] apic_timer_interrupt+0x13/0x20
[ 9964.600113]  <EOI> <4>---[ end trace 27d069ba1cae7828 ]---
[ 9964.636004] ------------[ cut here ]------------


