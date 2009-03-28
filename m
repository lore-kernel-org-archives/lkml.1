Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbZC1JPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbZC1JPq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 05:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZC1JP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 05:15:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:55295 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753340AbZC1JPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 05:15:22 -0400
X-Authenticated: #5610759
X-Provags-ID: V01U2FsdGVkX194nVBl8rN4IRhVOPLMqW4ZenKR0U4DxcKIadfsV9
	7gf/aPNbgKd8hD
Message-ID: <49CDEAA4.9070001@gmx.de>
Date: Sat, 28 Mar 2009 10:15:16 +0100
From: Veit Guna <veit.guna@gmx.de>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Veit Guna <veit.guna@gmx.de>
Subject: yet another NETDEV WATCHDOG: eth0 (r8169): transmit timed out
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I've setup a Ubuntu-Box with a plain vanilla 2.6.28.7 kernel.
NIC is a:

02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)

onboard on a Gigabyte MA78GM-S2H mainboard with latest bios.

When I transmit large files (>4GB) over my gigabit network it often
happens that the following message occurs in the logs:

Mar 28 09:26:38 nas kernel: [89600.000035] ------------[ cut here
]------------
Mar 28 09:26:38 nas kernel: [89600.000044] WARNING: at
net/sched/sch_generic.c:226 dev_watchdog+0x255/0x270()
Mar 28 09:26:38 nas kernel: [89600.000049] NETDEV WATCHDOG: eth0
(r8169): transmit timed out
Mar 28 09:26:38 nas kernel: [89600.000053] Modules linked in:
powernow_k8 cpufreq_stats cpufreq_userspace cpufreq_ondemand
cpufreq_powersave cpufreq_conservative freq_table video output container
rfkill input_polldev sbs sbshc pci_slot battery ipv6 iptable_filter
ip_tables x_tables xfs ac sbp2 parport_pc lp parport loop r8168
i2c_piix4 snd_hda_intel serio_raw wmi button pcspkr evdev k8temp shpchp
pci_hotplug i2c_core snd_pcm snd_timer snd soundcore snd_page_alloc ext3
jbd mbcache pata_acpi ata_generic sd_mod crc_t10dif sg ohci1394 ieee1394
pata_atiixp ehci_hcd ohci_hcd usbcore ahci r8169 mii libata scsi_mod
thermal processor fan fuse
Mar 28 09:26:38 nas kernel: [89600.000143] Pid: 0, comm: swapper Not
tainted 2.6.28.7 #3
Mar 28 09:26:38 nas kernel: [89600.000147] Call Trace:
Mar 28 09:26:38 nas kernel: [89600.000159]  [<c01343e0>]
warn_slowpath+0x60/0x80
Mar 28 09:26:38 nas kernel: [89600.000167]  [<c012753c>] ?
enqueue_entity+0x13c/0x360
Mar 28 09:26:38 nas kernel: [89600.000176]  [<c0150a33>] ?
getnstimeofday+0x53/0x110
Mar 28 09:26:38 nas kernel: [89600.000185]  [<c025074d>] ? strlcpy+0x1d/0x60
Mar 28 09:26:38 nas kernel: [89600.000193]  [<c02ec4e2>] ?
netdev_drivername+0x32/0x40
Mar 28 09:26:38 nas kernel: [89600.000199]  [<c0300dc5>]
dev_watchdog+0x255/0x270
Mar 28 09:26:38 nas kernel: [89600.000206]  [<c0154fb3>] ?
tick_dev_program_event+0x33/0xc0
Mar 28 09:26:38 nas kernel: [89600.000213]  [<c013dfad>] ? cascade+0x5d/0x80
Mar 28 09:26:38 nas kernel: [89600.000220]  [<c013e1c0>]
run_timer_softirq+0x130/0x200
Mar 28 09:26:38 nas kernel: [89600.000225]  [<c0300b70>] ?
dev_watchdog+0x0/0x270
Mar 28 09:26:38 nas kernel: [89600.000231]  [<c0300b70>] ?
dev_watchdog+0x0/0x270
Mar 28 09:26:38 nas kernel: [89600.000236]  [<c0139987>]
__do_softirq+0x97/0x170
Mar 28 09:26:38 nas kernel: [89600.000244]  [<c011a3e1>] ?
hpet_interrupt_handler+0x11/0x30
Mar 28 09:26:38 nas kernel: [89600.000250]  [<c0139abd>]
do_softirq+0x5d/0x60
Mar 28 09:26:38 nas kernel: [89600.000255]  [<c0139c35>] irq_exit+0x55/0x90
Mar 28 09:26:38 nas kernel: [89600.000262]  [<c0106703>] do_IRQ+0x83/0xa0
Mar 28 09:26:38 nas kernel: [89600.000268]  [<c0105173>]
common_interrupt+0x23/0x30
Mar 28 09:26:38 nas kernel: [89600.000276]  [<c011d0b5>] ?
native_safe_halt+0x5/0x10
Mar 28 09:26:38 nas kernel: [89600.000282]  [<c010ac0d>]
default_idle+0x5d/0x60
Mar 28 09:26:38 nas kernel: [89600.000288]  [<c010ad06>] c1e_idle+0x46/0x120
Mar 28 09:26:38 nas kernel: [89600.000294]  [<c010285d>] cpu_idle+0x6d/0xd0
Mar 28 09:26:38 nas kernel: [89600.000299]  [<c0368d5e>] rest_init+0x4e/0x60
Mar 28 09:26:38 nas kernel: [89600.000304] ---[ end trace
d63b027b80ab4519 ]---
Mar 28 09:26:38 nas kernel: [89600.016766] r8169: eth0: link up


The connection gets lost for about a minute or two until it gets up again.

Looking at the mailing list, there're some people having similar
problems. But didn't find a solution to this - so I post myself.

If someone is interested in my dmesg, please give me a short note.

Regards,
Veit
