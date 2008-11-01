Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbYKAPCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbYKAPCO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 11:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYKAPB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 11:01:58 -0400
Received: from vena.lwn.net ([206.168.112.25]:35150 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbYKAPB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 11:01:57 -0400
Date: Sat, 1 Nov 2008 09:01:54 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Robert Hancock <hancockr@shaw.ca>, e1000-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: 2.6.28-rc2 hates my e1000e
Message-ID: <20081101090154.3d014f57@bike.lwn.net>
In-Reply-To: <alpine.LFD.2.00.0810310953550.21084@nehalem.linux-foundation.org>
References: <fa.P5jmIAOhSJ192sfWD+qlec07fe8@ifi.uio.no>
 <490A5532.2000704@shaw.ca>
 <20081030205851.3208f52f@bike.lwn.net>
 <86802c440810302108h48046c08x3bbdcd0e35fd31b7@mail.gmail.com>
 <alpine.LFD.2.00.0810310800120.21084@nehalem.linux-foundation.org>
 <alpine.LFD.2.00.0810310839380.21084@nehalem.linux-foundation.org>
 <20081031100040.1f0cf34f@bike.lwn.net>
 <alpine.LFD.2.00.0810310916050.21084@nehalem.linux-foundation.org>
 <20081031105105.092ebad3@bike.lwn.net>
 <alpine.LFD.2.00.0810310953550.21084@nehalem.linux-foundation.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008 09:58:01 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Can you do any reasonable testing at all without NFS? In particular,
> can you boot without NFS and test that the networking still works? 

Networking is fine in the absence of NFS.  I retried things and
stress-tested it in a few ways with no trouble.  I think your last patch
fixes the network card just fine.

Then I tried NFS again, watching more closely this time around.
Everything locks up.  In fact, the soft lockup watchdog starts to
scream:

Oct 31 10:37:53 bike kernel: [   88.046867] BUG: soft lockup - CPU#1 stuck for 61s! [modprobe:2923]
Oct 31 10:37:53 bike kernel: [   88.046867] Modules linked in: fuse sunrpc binfmt_misc msp3400 saa7115 snd_hda_intel tuner snd_seq_oss snd_seq_midi_event snd_seq ivtv compat_ioctl32 snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer 8250_pci cx2341x v4l2_common videodev 8250_pnp snd hid_logitech 8250 e1000e v4l1_compat i2c_i801 tveeprom usbhid evdev thermal soundcore serial_core sr_mod sg processor snd_page_alloc cdrom button [last unloaded: microcode]
Oct 31 10:37:53 bike kernel: [   88.046867] CPU 1:
Oct 31 10:37:53 bike kernel: [   88.046867] Modules linked in: fuse sunrpc binfmt_misc msp3400 saa7115 snd_hda_intel tuner snd_seq_oss snd_seq_midi_event snd_seq ivtv compat_ioctl32 snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer 8250_pci cx2341x v4l2_common videodev 8250_pnp snd hid_logitech 8250 e1000e v4l1_compat i2c_i801 tveeprom usbhid evdev thermal soundcore serial_core sr_mod sg processor snd_page_alloc cdrom button [last unloaded: microcode]
Oct 31 10:37:53 bike kernel: [   88.046867] Pid: 2923, comm: modprobe Not tainted 2.6.28-rc2 #12
Oct 31 10:37:53 bike kernel: [   88.046867] RIP: 0010:[<ffffffff8026fd88>]  [<ffffffff8026fd88>] ftrace_record_ip+0xcb/0x1f5
Oct 31 10:37:53 bike kernel: [   88.046867] RSP: 0018:ffff8800bae33d58  EFLAGS: 00000282
Oct 31 10:37:53 bike kernel: [   88.046867] RAX: ffff8800baef0810 RBX: ffff8800bae33d68 RCX: 9288000000000000
Oct 31 10:37:53 bike kernel: [   88.046867] RDX: ffff8800baef0810 RSI: 00000000000003fe RDI: ffffffffa023f251
Oct 31 10:37:53 bike kernel: [   88.046867] RBP: ffff8800bae33d68 R08: ffffffffa023f251 R09: ffffffff80720ed0
Oct 31 10:37:53 bike kernel: [   88.046867] R10: ffff8800b99c0e10 R11: 0000000000000000 R12: ffffffff8049eb26
Oct 31 10:37:53 bike kernel: [   88.046867] R13: ffff8800bae33d48 R14: ffff8800bae33ce8 R15: ffff8800bae33ce8
Oct 31 10:37:53 bike kernel: [   88.046867] FS:  00007fbe2e5166f0(0000) GS:ffff8800be002d80(0000) knlGS:0000000000000000
Oct 31 10:37:53 bike kernel: [   88.046867] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Oct 31 10:37:53 bike kernel: [   88.046867] CR2: 00007fbe2e51100f CR3: 00000000bc775000 CR4: 00000000000006e0
Oct 31 10:37:53 bike kernel: [   88.046867] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct 31 10:37:53 bike kernel: [   88.046867] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct 31 10:37:53 bike kernel: [   88.046867] Call Trace:
Oct 31 10:37:53 bike kernel: [   88.046867]  [<ffffffff80270325>] ftrace_convert_nops+0x31/0x77
Oct 31 10:37:53 bike kernel: [   88.046867]  [<ffffffff80270382>] ftrace_init_module+0x17/0x19
Oct 31 10:37:53 bike kernel: [   88.046867]  [<ffffffff8025de68>] load_module+0x13b4/0x18ba
Oct 31 10:37:53 bike kernel: [   88.046867]  [<ffffffff8029e875>] ? do_sync_read+0xec/0x132
Oct 31 10:37:53 bike kernel: [   88.046867]  [<ffffffff8023eb4b>] ? proc_dointvec_minmax+0x0/0x52
Oct 31 10:37:53 bike kernel: [   88.046867]  [<ffffffff8025e4bc>] sys_init_module+0x5a/0x1bb
Oct 31 10:37:53 bike kernel: [   88.046867]  [<ffffffff8020c18b>] system_call_fastpath+0x16/0x1b

So methinks I'll add Steven to the Cc on this one :)  Looks like a
different problem for sure.

> Oh, and getting the old (2.6.27) and new
> (2.6.28-rc2+patch) /proc/iomem would be nice.

For completeness, here they are.  2.6.27:

00000000-0009fbff : System RAM
000f0000-000fffff : reserved
00100000-be4ff7ff : System RAM
  00200000-004b4d12 : Kernel code
  004b4d13-0073000f : Kernel data
  011b6000-0127e58f : Kernel bss
be4ff800-be553bff : ACPI Non-volatile Storage
be553c00-be555bff : ACPI Tables
be555c00-beffffff : reserved
c0000000-cfffffff : 0000:00:02.0
d0000000-d3ffffff : PCI Bus 0000:02
  d0000000-d3ffffff : 0000:02:00.0
    d0000000-d07fffff : ivtv encoder
    d2000000-d200ffff : ivtv registers
d4000000-d40fffff : 0000:00:02.0
d4100000-d417ffff : 0000:00:02.0
d4180000-d41fffff : 0000:00:02.1
d4200000-d421ffff : 0000:00:19.0
  d4200000-d421ffff : e1000e
d4220000-d4223fff : 0000:00:1b.0
  d4220000-d4223fff : ICH HD audio
d4224000-d4224fff : 0000:00:03.3
d4225000-d4225fff : 0000:00:19.0
  d4225000-d4225fff : e1000e
d4226000-d42263ff : 0000:00:1a.7
  d4226000-d42263ff : ehci_hcd
d4226400-d42264ff : 0000:00:1f.3
d4227000-d4227fff : Intel Flush Page
e0000000-fed003ff : reserved
  fec00000-fec00fff : IOAPIC 0
  fed00000-fed003ff : HPET 0
fed20000-fed9ffff : reserved
fedad000-fedad00f : 0000:00:03.0
fee00000-feefffff : reserved
  fee00000-fee00fff : Local APIC
ff980800-ff980bff : 0000:00:1d.7
  ff980800-ff980bff : ehci_hcd
ffb00000-ffffffff : reserved


2.6.28-rc2 + second Linus patch:


00000000-0009fbff : System RAM
000f0000-000fffff : reserved
00100000-be4ff7ff : System RAM
  00200000-004a6e45 : Kernel code
  004a6e46-00649b77 : Kernel data
  006c4000-007585ff : Kernel bss
be4ff800-be553bff : ACPI Non-volatile Storage
be553c00-be555bff : ACPI Tables
be555c00-beffffff : reserved
c0000000-cfffffff : 0000:00:02.0
d0000000-d3ffffff : PCI Bus 0000:02
  d0000000-d3ffffff : 0000:02:00.0
    d0000000-d07fffff : ivtv encoder
    d2000000-d200ffff : ivtv registers
d4000000-d4000fff : Intel Flush Page
e0000000-fed003ff : reserved
  fe800000-fe8fffff : PCI Bus 0000:01
  fe9d9b00-fe9d9bff : 0000:00:1f.3
  fe9d9c00-fe9d9fff : 0000:00:1a.7
    fe9d9c00-fe9d9fff : ehci_hcd
  fe9da000-fe9dafff : 0000:00:03.3
  fe9db000-fe9dbfff : 0000:00:19.0
    fe9db000-fe9dbfff : e1000e
  fe9dc000-fe9dffff : 0000:00:1b.0
    fe9dc000-fe9dffff : ICH HD audio
  fe9e0000-fe9fffff : 0000:00:19.0
    fe9e0000-fe9fffff : e1000e
  fea00000-fea7ffff : 0000:00:02.0
  fea80000-feafffff : 0000:00:02.1
  feb00000-febfffff : 0000:00:02.0
  fec00000-fec00fff : IOAPIC 0
  fed00000-fed003ff : HPET 0
fed20000-fed9ffff : reserved
fedad000-fedad00f : 0000:00:03.0
fee00000-feefffff : reserved
  fee00000-fee00fff : Local APIC
ff980800-ff980bff : 0000:00:1d.7
  ff980800-ff980bff : ehci_hcd
ffb00000-ffffffff : reserved

jon
