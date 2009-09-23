Return-Path: <linux-kernel-owner+w=401wt.eu-S1752412AbZIWWpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbZIWWpy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 18:45:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbZIWWpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 18:45:52 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:48759 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbZIWWpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 18:45:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=giYtzmbr+Khx8TSL3E3uqFIq66O3wHhXSVly/vk6qSU6IUT+6L33rRj9n2BSqZEUfw
         riHnZvbCVqt11Z/15ygQHt3romN/L1+EUshpGgF2ksoxRSam0wSe47N0GGk28xSwT1nq
         qESEheWGjF/QTbiXI3n2TYVGYIfC02PeJE/OA=
MIME-Version: 1.0
Date: Wed, 23 Sep 2009 23:45:54 +0100
Message-ID: <6278d2220909231545x217e1100k496bbdd44d0704de@mail.gmail.com>
Subject: [2.6.31] NFS + suspend to ram hang...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without the NFS4 homedir mount, suspend to ram works perfectly. With
NFS4 homedir, suspend is started, but doesn't complete. Invoking
kernel crashdump, all messages and backtrace looks entirely expected
[1].

Anyone else find the same? Expected to work or not? What information
would help with this?

Thanks,
  Daniel

--- [1]

[   49.865732] CPU1 attaching NULL sched-domain.
[   49.884215] CPU0 attaching sched-domain:
[   49.884222]  domain 0: span 0-1 level MC
[   49.884228]   groups: 0 1
[   49.884240] CPU1 attaching sched-domain:
[   49.884245]  domain 0: span 0-1 level MC
[   49.884250]   groups: 1 0
[   57.286986] SysRq : Trigger a crash
[   57.287009] BUG: unable to handle kernel NULL pointer dereference at (null)
[   57.287014] IP: [<ffffffff81305b21>] sysrq_handle_crash+0x11/0x20
[   57.287024] PGD 0
[   57.287028] Oops: 0002 [#1] SMP
[   57.287031] last sysfs file:
/sys/devices/pci0000:00/0000:00:02.0/graphics/fb0/state
[   57.287035] CPU 1
[   57.287038] Modules linked in: binfmt_misc ppdev kvm_intel kvm
microcode nfsd exportfs nfs lockd nfs_acl auth_rpcgss sunrpc joydev
dm_crypt snd_hda_codec_conexant arc4 snd_hda_intel ecb pcmcia
snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy
snd_seq_oss snd_seq_midi iptable_filter iwlagn snd_rawmidi iwlcore
psmouse snd_seq_midi_event serio_raw ip_tables mac80211 x_tables
snd_seq snd_timer snd_seq_device ricoh_mmc thinkpad_acpi sdhci_pci
nvram sdhci lp yenta_socket led_class rsrc_nonstatic pcmcia_core
cfg80211 parport snd heci(C) soundcore snd_page_alloc e1000e fbcon
tileblit font bitblit softcursor i915 drm i2c_algo_bit video output
intel_agp
[   57.287100] Pid: 0, comm: swapper Tainted: G         C
2.6.31-10-generic #35-Ubuntu 276521G
[   57.287103] RIP: 0010:[<ffffffff81305b21>]  [<ffffffff81305b21>]
sysrq_handle_crash+0x11/0x20
[   57.287109] RSP: 0018:ffff880028043c18  EFLAGS: 00010096
[   57.287111] RAX: 0000000000000010 RBX: 0000000000000063 RCX: 000000000000001e
[   57.287114] RDX: 0000000000000000 RSI: ffff880131ca5800 RDI: 0000000000000063
[   57.287118] RBP: ffff880028043c18 R08: 0000000000000073 R09: 000000000000edff
[   57.287121] R10: 0000000000000005 R11: 0000000000000000 R12: ffff880131ca5800
[   57.287123] R13: ffffffff817c99c0 R14: 0000000000000082 R15: 0000000000000004
[   57.287127] FS:  0000000000000000(0000) GS:ffff880028040000(0000)
knlGS:0000000000000000
[   57.287130] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[   57.287138] CR2: 0000000000000000 CR3: 0000000001001000 CR4: 00000000000026a0
[   57.287140] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   57.287142] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   57.287144] Process swapper (pid: 0, threadinfo ffff880137ac6000,
task ffff880137a9c410)
[   57.287146] Stack:
[   57.287147]  ffff880028043c68 ffffffff81305daa ffff880028043c38
2e00880100000001
[   57.287150] <0> ffff88012193ca00 000000000000002e 0000000000000001
ffff88012193ca00
[   57.287153] <0> ffff880131ca5800 0000000000000001 ffff880028043c78
ffffffff81305e86
[   57.287157] Call Trace:
[   57.287158]  <IRQ>
[   57.287161]  [<ffffffff81305daa>] __handle_sysrq+0x12a/0x190
[   57.287164]  [<ffffffff81305e86>] handle_sysrq+0x26/0x30
[   57.287167]  [<ffffffff812fd20d>] kbd_keycode+0x39d/0x5c0
[   57.287170]  [<ffffffff812eb093>] ? mix_pool_bytes_extract+0x163/0x180
[   57.287173]  [<ffffffff812fd48b>] kbd_event+0x5b/0x110
[   57.287177]  [<ffffffff813bed7e>] input_pass_event+0x9e/0xa0
[   57.287179]  [<ffffffff813c0653>] input_handle_event+0x93/0x470
[   57.287182]  [<ffffffff813c0f74>] input_event+0x84/0xa0
[   57.287184]  [<ffffffff813c64ff>] atkbd_interrupt+0x60f/0x6c0
[   57.287188]  [<ffffffff81050404>] ? enqueue_entity+0xb4/0x140
[   57.287191]  [<ffffffff813bc5ad>] serio_interrupt+0x4d/0xa0
[   57.287193]  [<ffffffff813bd31e>] i8042_interrupt+0xce/0x290
[   57.287197]  [<ffffffff810aea48>] handle_IRQ_event+0x58/0x160
[   57.287200]  [<ffffffff810b0a7f>] handle_edge_irq+0xcf/0x170
[   57.287203]  [<ffffffff8101499d>] handle_irq+0x1d/0x30
[   57.287205]  [<ffffffff81014077>] do_IRQ+0x67/0xe0
[   57.287209]  [<ffffffff810129d3>] ret_from_intr+0x0/0x11
[   57.287210]  <EOI>
[   57.287214]  [<ffffffff812d2e19>] ? acpi_idle_enter_bm+0x28b/0x2bf
[   57.287217]  [<ffffffff812d2e12>] ? acpi_idle_enter_bm+0x284/0x2bf
[   57.287221]  [<ffffffff813f8fcb>] ? cpuidle_idle_call+0x9b/0xf0
[   57.287223]  [<ffffffff81010e12>] ? cpu_idle+0xb2/0x100
[   57.287227]  [<ffffffff8151daa9>] ? start_secondary+0xa9/0xab
[   57.287228] Code: 9a 81 19 d2 83 e0 cf f7 d2 83 e2 03 c1 e2 04 09
d0 88 81 03 5b 9a 81 c9 c3 90 55 c7 05 01 dd 5f 00 01 00 00 00 48 89
e5 0f ae f8 <c6> 04 25 00 00 00 00 01 c9 c3 0f 1f 44 00 00 8d 47 d0 55
83 f8
[   57.287255] RIP  [<ffffffff81305b21>] sysrq_handle_crash+0x11/0x20
[   57.287259]  RSP <ffff880028043c18>
[   57.287260] CR2: 0000000000000000
-- 
Daniel J Blueman
