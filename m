Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbYGaMuG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbYGaMuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 08:50:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYGaMty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 08:49:54 -0400
Received: from mk-outboundfilter-4.mail.uk.tiscali.com ([212.74.114.32]:26485
	"EHLO mk-outboundfilter-4.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752860AbYGaMtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 08:49:53 -0400
X-Trace: 117492137/mk-outboundfilter-2.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkkFANhRkUjDlSwG/2dsb2JhbACBW4lDpks
X-IronPort-AV: E=Sophos;i="4.31,286,1215385200"; 
   d="scan'208";a="117492137"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: Oops in microcode sysfs registration,
Date: Thu, 31 Jul 2008 13:49:30 +0100
User-Agent: KMail/1.10.0 (Linux/2.6.27-rc1-damocles; KDE/4.1.0; x86_64; ; )
Cc: "Pekka Paalanen" <pq@iki.fi>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       shaohua.li@intel.com, tigran@aivazian.fsnet.co.uk,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Max Krasnyansky" <maxk@qualcomm.com>
References: <alpine.LFD.1.10.0807281956030.3334@nehalem.linux-foundation.org> <b647ffbd0807300207s1ba47899j7220f83ed60d98a8@mail.gmail.com> <b647ffbd0807300335w1bedfe73m4959fba1e5c93401@mail.gmail.com>
In-Reply-To: <b647ffbd0807300335w1bedfe73m4959fba1e5c93401@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807311349.31033.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2008 11:35:54 Dmitry Adamushko wrote:
> 2008/7/30 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
> > 2008/7/29 Alistair John Strachan <alistair@devzero.co.uk>:
> >> On Tuesday 29 July 2008 17:22:14 Pekka Paalanen wrote:
> >>> > Also, I'm sure this is reproducible without the NVIDIA garbage, but I
> >>> > was too lazy to test it. If you want me to repeat the experiment
> >>> > without the driver I would be more than happy to do so.
> >>>
> >>> I'm not sure people are willing to look into this without a clean
> >>> report, so this would be cool. There's even a test module for mmiotrace
> >>> in the kernel, but I doubt it would make difference to use it or not,
> >>> when trying to reproduce the crash without the blob.
> >>
> >> Of course, and I should have attempted to reproduce without the driver.
> >> Fortunately that was easy: it is not an NVIDIA driver bug.
> >>
> >> Steps to reproduce: have CONFIG_MICROCODE=y and a suitable Intel
> >> processor, then do:
> >>
> >> echo mmiotrace >/debug/tracing/current_tracer
> >> echo none >/debug/tracing/current_tracer
> >>
> >> And you get this (snipped) oops:
> >>
> >> in mmio_trace_init
> >> mmiotrace: Disabling non-boot CPUs...
> >> kvm: disabling virtualization on CPU1
> >> CPU 1 is now offline
> >> SMP alternatives: switching to UP code
> >> CPU0 attaching NULL sched-domain.
> >> CPU1 attaching NULL sched-domain.
> >> CPU0 attaching NULL sched-domain.
> >> mmiotrace: CPU1 is down.
> >> mmiotrace: enabled.
> >> in mmio_trace_reset
> >> mmiotrace: Re-enabling CPUs...
> >> SMP alternatives: switching to SMP code
> >> Booting processor 1/1 ip 6000
> >> Initializing CPU#1
> >> Calibrating delay using timer specific routine.. <6>7204.76 BogoMIPS
> >> (lpj=3602381) CPU: L1 I cache: 32K, L1 D cache: 32K
> >> CPU: L2 cache: 4096K
> >> CPU: Physical Processor ID: 0
> >> CPU: Processor Core ID: 1
> >> x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
> >> CPU1: Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz stepping 06
> >> checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> >> kvm: enabling virtualization on CPU1
> >> CPU0 attaching NULL sched-domain.
> >> Switched to high resolution mode on CPU 1
> >> CPU0 attaching sched-domain:
> >>  domain 0: span 0-1 level MC
> >>  groups: 0 1
> >> CPU1 attaching sched-domain:
> >>  domain 0: span 0-1 level MC
> >>  groups: 1 0
> >> ------------[ cut here ]------------
> >> Kernel BUG at ffffffff8021a31d [verbose debug info unavailable]
> >> invalid opcode: 0000 [1] PREEMPT SMP
> >> CPU 0
> >> Modules linked in: rfcomm l2cap kvm_intel kvm ipt_MASQUERADE iptable_nat
> >> nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables x_tables bridge stp llc
> >> acpi_cpufreq freq_table coretemp hwmon snd_pcm_oss snd_mixer_oss
> >> firewire_sbp2 hci_usb bluetooth arc4 ecb crypto_blkcipher cryptomgr
> >> crypto_algapi usbhid zd1211rw mac80211 crypto cfg80211 snd_emu10k1
> >> snd_rawmidi snd_ac97_codec ac97_bus sg snd_seq_device snd_hda_intel
> >> snd_pcm snd_util_mem snd_timer sr_mod snd_hwdep i2c_i801 ehci_hcd
> >> firewire_ohci uhci_hcd snd snd_page_alloc firewire_core soundcore r8169
> >> cdrom usbcore i2c_core crc_itu_t
> >> Pid: 2757, comm: bash Tainted: G       A  2.6.27-rc1-damocles #3
> >> RIP: 0010:[<ffffffff8021a31d>]  [<ffffffff8021a31d>]
> >> __mc_sysdev_add+0xc3/0x1f1 RSP: 0018:ffff8800b8905ce8  EFLAGS: 00010297
> >> RAX: 0000000000000000 RBX: 0000000000000001 RCX: ffff880080a04000
> >> RDX: ffffffff8062c680 RSI: 0000000000000003 RDI: ffffffff8059e830
> >> RBP: ffff8800b8905d48 R08: ffff8800b8904000 R09: ffffffff80229ca4
> >> R10: ffff8800010247b0 R11: ffff8800bf879de0 R12: 0000000000000018
> >> R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
> >> FS:  00007f8ddc78f6e0(0000) GS:ffffffff805da200(0000)
> >> knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> >> CR2: 00007f57cb9b2098 CR3: 00000000b8985000 CR4: 00000000000026e0
> >> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> >> Process bash (pid: 2757, threadinfo ffff8800b8904000, task
> >> ffff8800bd125640) Stack:  ffffffff80627040 0000000000000000
> >> 0000000000000008 ffffffff8048bb28 0000000000000003 ffffffff802ce910
> >> ffff8800b8905d28 0000000000000002 00000000ffffffe8 0000000000000001
> >> 0000000000000001 ffff880001028418 Call Trace:
> >>  [<ffffffff802ce910>] ? sysfs_add_file+0xc/0xe
> >>  [<ffffffff8021a456>] mc_sysdev_add+0xb/0xd
> >>  [<ffffffff8047baaf>] mc_cpu_callback+0x4b/0x208
> >>  [<ffffffff8047b772>] ? mce_cpu_callback+0x3e/0xbc
> >>  [<ffffffff8024b787>] notifier_call_chain+0x33/0x5b
> >>  [<ffffffff8024b81f>] raw_notifier_call_chain+0xf/0x11
> >>  [<ffffffff8047e1dc>] _cpu_up+0xce/0x119
> >>  [<ffffffff8047e285>] cpu_up+0x5e/0x8a
> >>  [<ffffffff80224967>] disable_mmiotrace+0xfe/0x173
> >>  [<ffffffff80265279>] mmio_trace_reset+0x2d/0x44
> >>  [<ffffffff80262c4d>] tracing_set_trace_write+0xd3/0x10f
> >>  [<ffffffff80289cab>] ? filp_close+0x67/0x72
> >>  [<ffffffff8028bee3>] vfs_write+0xa7/0xe1
> >>  [<ffffffff8028bfe1>] sys_write+0x47/0x6f
> >>  [<ffffffff8020b6db>] system_call_fastpath+0x16/0x1b
> >> [   68.405002]
> >> [   68.405002]
> >> Code: e8 59 80 e8 fd 69 26 00 48 c7 c2 80 c6 62 80 48 8b 05 c0 00 3c 00
> >> 48 8b 04 d8 48 8b 48 08 65 8b 04 25 24 00 00 00 44 39 e8 74 04 <0f> 0b
> >> eb fe 4c 8d 04 0a 41 c7 84 24 7c 36 64 80 00 00 00 00 41
> >> RIP  [<ffffffff8021a31d>] __mc_sysdev_add+0xc3/0x1f1
> >>  RSP <ffff8800b8905ce8>
> >> ---[ end trace ee9c9240024cb48c ]---
> >>
> >> I've replaced the originally tainted dmesg with this new clean one, so
> >> there's no proprietary smell about it :-)
> >
> > Yes, it's kind of a known issue. Take a look at this explanation:
> > http://lkml.org/lkml/2008/7/24/260
> >
> > There were a few related discussions in other threads (mainly, Max
> > Krasnyansky and I were asking for additional info on possible
> > requirements from the 'microcode' driver...) heh, I think, we'd be
> > better off just fixing it one way or another.
>
> does a patch below fix it for you?

Well, if this patch is all that can be done about the issue, it gets my tested 
seal of approval. The CPUs online/offline properly without upsetting the mc 
driver. Thanks.

-- 
Cheers,
Alistair.
