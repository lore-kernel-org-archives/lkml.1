Return-Path: <linux-kernel-owner+w=401wt.eu-S1759043AbYG2N6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043AbYG2N6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 09:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbYG2N6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 09:58:07 -0400
Received: from mk-outboundfilter-5.mail.uk.tiscali.com ([212.74.114.1]:2176
	"EHLO mk-outboundfilter-5.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754972AbYG2N6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 09:58:05 -0400
X-Trace: 63099468/mk-outboundfilter-5.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAE++jkjDlSwG/2dsb2JhbACBWolFpUU
X-IronPort-AV: E=Sophos;i="4.31,272,1215385200"; 
   d="scan'208";a="63099468"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Oops in microcode sysfs registration,
Date: Tue, 29 Jul 2008 14:57:58 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       shaohua.li@intel.com, tigran@aivazian.fsnet.co.uk,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Pekka Paalanen <pq@iki.fi>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291457.58408.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(Sorry for the CC frenzy. If you don't have or want anything to do with the
tracing framework in 2.6.27 or the microcode driver, you can stop reading
now.)

Noticing pq's mmiotrace was merged I tried to get a trace of the proprietary
NVIDIA blob. Normally I wouldn't waste your time posting a tainted oops,
however in this case it doesn't look related to the proprietary garbage and I
think there's a real bug somewhere.

As I understand it, the mmiotrace tracing framework requires only one logical
CPU to be active, automatically offlining the other CPUs. When mmiotrace is
disabled, it automatically re-enables the CPUs it offlined. If I offline the
spare CPUs myself, prior to enabling mmiotrace, I do not see the issue I'm
about to describe. That's why tracing people have been CCed, even though that
could be a red herring.

The full dmesg and kernel config are available from
http://devzero.co.uk/~alistair/2.6.27-rc1-mc-oops/

nvidia: module license 'NVIDIA' taints kernel.
Symbol init_mm is marked as UNUSED, however this module is using it.
This symbol will go away in the future.
Please evalute if this is the right api to use and if it really is, submit a report the linux kernel mailinglist together with submitting your code for inclusion.
nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
nvidia 0000:01:00.0: setting latency timer to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  173.14.09  Wed Jun  4 23:40:50 PDT 2008
in mmio_trace_init
mmiotrace: Disabling non-boot CPUs...
kvm: disabling virtualization on CPU1
CPU 1 is now offline
SMP alternatives: switching to UP code
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching NULL sched-domain.
mmiotrace: CPU1 is down.
mmiotrace: enabled.
Symbol init_mm is marked as UNUSED, however this module is using it.
This symbol will go away in the future.
Please evalute if this is the right api to use and if it really is, submit a report the linux kernel mailinglist together with submitting your code for inclusion.
nvidia 0000:01:00.0: setting latency timer to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  173.14.09  Wed Jun  4 23:40:50 PDT 2008
mmiotrace: ioremap_*(0xfa000000, 0x1000000) = ffffc20010b80000
mmiotrace: ioremap_*(0xd0000000, 0x6000) = ffffc20010578000
mmiotrace: ioremap_*(0xe0000000, 0x1000) = ffffc200104fe000
mmiotrace: Unmapping ffffc200104fe000.
mmiotrace: ioremap_*(0xe0008000, 0x1000) = ffffc200104fe000
mmiotrace: ioremap_*(0xe0100000, 0x1000) = ffffc20010500000
mmiotrace: Unmapping ffffc20010500000.
mmiotrace: ioremap_*(0xf8000000, 0x1000000) = ffffc20011c00000
mmiotrace: ioremap_*(0xe0100000, 0x1000) = ffffc20010500000
mmiotrace: Unmapping ffffc20010500000.
mmiotrace: ioremap_*(0xd0504000, 0x1000) = ffffc20010500000
mmiotrace: ioremap_*(0xd0519000, 0x1000) = ffffc20010502000
mmiotrace: ioremap_*(0xd051a000, 0x1000) = ffffc20010572000
mmiotrace: Unmapping ffffc20010502000.
mmiotrace: Unmapping ffffc20010572000.
mmiotrace: Unmapping ffffc20010500000.
mmiotrace: Unmapping ffffc200104fe000.
mmiotrace: Unmapping ffffc20011c00000.
mmiotrace: Unmapping ffffc20010578000.
mmiotrace: Unmapping ffffc20010b80000.
in mmio_trace_reset
mmiotrace: Re-enabling CPUs...
SMP alternatives: switching to SMP code
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. <6>7200.61 BogoMIPS (lpj=3600306)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
kvm: enabling virtualization on CPU1
CPU0 attaching NULL sched-domain.
Switched to high resolution mode on CPU 1
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
------------[ cut here ]------------
Kernel BUG at ffffffff8021a31d [verbose debug info unavailable]
invalid opcode: 0000 [1] PREEMPT SMP
CPU 0
Modules linked in: nvidia(P) rfcomm l2cap kvm_intel kvm ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables x_tables bridge stp llc acpi_cpufreq freq_table coretemp 
hwmon snd_pcm_oss snd_mixer_oss firewire_sbp2 hci_usb bluetooth arc4 ecb crypto_blkcipher cryptomgr crypto_algapi usbhid zd1211rw mac80211 crypto cfg80211 snd_emu10k1 snd_rawmidi 
snd_ac97_codec ac97_bus snd_seq_device sg snd_util_mem snd_hda_intel snd_pcm snd_timer snd_hwdep snd i2c_i801 sr_mod firewire_ohci firewire_core soundcore r8169 ehci_hcd uhci_hcd 
snd_page_alloc crc_itu_t i2c_core usbcore cdrom [last unloaded: nvidia]
Pid: 2733, comm: bash Tainted: P       A  2.6.27-rc1-damocles #3
RIP: 0010:[<ffffffff8021a31d>]  [<ffffffff8021a31d>] __mc_sysdev_add+0xc3/0x1f1
RSP: 0018:ffff8800b7c1dce8  EFLAGS: 00010297
RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffff880080a04000
RDX: ffffffff8062c680 RSI: 0000000000000003 RDI: ffffffff8059e830
RBP: ffff8800b7c1dd48 R08: ffff8800b7c1c000 R09: ffffffff80229ca4
R10: ffff8800010247b0 R11: ffff8800bf879de0 R12: 0000000000000018
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fa4bf6176e0(0000) GS:ffffffff805da200(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f3a6cf05098 CR3: 00000000b7d64000 CR4: 00000000000026e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
Process bash (pid: 2733, threadinfo ffff8800b7c1c000, task ffff8800bd06ab20)
Stack:  ffffffff80627040 0000000000000000 0000000000000008 ffffffff8048bb28
 0000000000000003 ffffffff802ce910 ffff8800b7c1dd28 0000000000000002
 00000000ffffffe8 0000000000000001 0000000000000001 ffff880001028418
Call Trace:
 [<ffffffff802ce910>] ? sysfs_add_file+0xc/0xe
 [<ffffffff8021a456>] mc_sysdev_add+0xb/0xd
 [<ffffffff8047baaf>] mc_cpu_callback+0x4b/0x208
 [<ffffffff8047b772>] ? mce_cpu_callback+0x3e/0xbc
 [<ffffffff8024b787>] notifier_call_chain+0x33/0x5b
 [<ffffffff8024b81f>] raw_notifier_call_chain+0xf/0x11
 [<ffffffff8047e1dc>] _cpu_up+0xce/0x119
 [<ffffffff8047e285>] cpu_up+0x5e/0x8a
 [<ffffffff80224967>] disable_mmiotrace+0xfe/0x173
 [<ffffffff80265279>] mmio_trace_reset+0x2d/0x44
 [<ffffffff80262c4d>] tracing_set_trace_write+0xd3/0x10f
 [<ffffffff80289cab>] ? filp_close+0x67/0x72
 [<ffffffff8028bee3>] vfs_write+0xa7/0xe1
 [<ffffffff8028bfe1>] sys_write+0x47/0x6f
 [<ffffffff8020b6db>] system_call_fastpath+0x16/0x1b
[  903.144002]
[  903.144002]
Code: e8 59 80 e8 fd 69 26 00 48 c7 c2 80 c6 62 80 48 8b 05 c0 00 3c 00 48 8b 04 d8 48 8b 48 08 65 8b 04 25 24 00 00 00 44 39 e8 74 04 <0f> 0b eb fe 4c 8d 04 0a 41 c7 84 24 7c 36 64 80 00 
00 00 00 41
RIP  [<ffffffff8021a31d>] __mc_sysdev_add+0xc3/0x1f1
 RSP <ffff8800b7c1dce8>
---[ end trace 39a5700403aca092 ]---

The box was vaguely usable and then choked to death a few minutes later. I was
initially confused by the multi-core stuff chiming in, but the functions
mc_cpu_callback and mc_sysdev_add are from the microcode driver. At a guess,
something is being done in a context it shouldn't be. I've not tested it
enough to say whether or not it will always crash.

Also, I'm sure this is reproducible without the NVIDIA garbage, but I was too lazy
to test it. If you want me to repeat the experiment without the driver I would be
more than happy to do so.

-- 
Cheers,
Alistair.
