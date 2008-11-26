Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbYKZX1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbYKZX1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 18:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbYKZX1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 18:27:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52627 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752311AbYKZX1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 18:27:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Miles Lane" <miles.lane@gmail.com>
Subject: Re: 2.6.28-rc6-git1 -- BUG: unable to handle kernel paging request at ffff8800be8b0019
Date: Thu, 27 Nov 2008 00:26:37 +0100
User-Agent: KMail/1.9.9
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <htejun@gmail.com>
References: <a44ae5cd0811250850g725a5a5nd7d93a23ffd2fce6@mail.gmail.com>
In-Reply-To: <a44ae5cd0811250850g725a5a5nd7d93a23ffd2fce6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811270026.37941.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 25 of November 2008, Miles Lane wrote:
> # find /sys -name "*" | xargs tail
> 
> [ 3866.840809] BUG: unable to handle kernel paging request at ffff8800be8b0019
> [ 3866.840819] IP: [<ffffffff80262f07>] kallsyms_lookup+0x20/0x120
> [ 3866.840828] PGD 202063 PUD 117f067 PMD 1374067 PTE 80000000be8b0160
> [ 3866.840835] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [ 3866.840842] last sysfs file: /sys/kernel/slab/kmalloc-64/alloc_calls
> [ 3866.840846] CPU 1
> [ 3866.840849] Modules linked in: hci_uart serport ipv6 af_packet
> binfmt_misc sco bridge stp llc rfcomm bnep l2cap bluetooth
> acpi_cpufreq cpufreq_performance cpufreq_powersave iptable_filter
> ip_tables sbp2 parport_pc lp parport snd_hda_intel pcmcia snd_pcm_oss
> snd_mixer_oss snd_pcm snd_page_alloc snd_hwdep snd_seq_dummy
> snd_seq_oss snd_seq_midi tifm_7xx1 iwl3945 evdev snd_rawmidi tifm_core
> psmouse rfkill rng_core yenta_socket rsrc_nonstatic iTCO_wdt
> iTCO_vendor_support mac80211 snd_seq_midi_event snd_seq snd_timer
> snd_seq_device snd battery ac shpchp button soundcore loop sd_mod
> sr_mod cdrom sg ohci1394 ieee1394 ehci_hcd uhci_hcd sky2 usbcore
> thermal processor fan unix
> [ 3866.840943] Pid: 7717, comm: tail Not tainted 2.6.28-rc6-git1 #6
> [ 3866.840946] RIP: 0010:[<ffffffff80262f07>]  [<ffffffff80262f07>]
> kallsyms_lookup+0x20/0x120
> [ 3866.840953] RSP: 0018:ffff880073d63da8  EFLAGS: 00010292
> [ 3866.840956] RAX: 0000000000000f9a RBX: ffffffff80695c45 RCX: ffff880073d63e00
> [ 3866.840959] RDX: ffff880073d63df8 RSI: ffff880073d63df0 RDI: ffffffff80695c45
> [ 3866.840962] RBP: ffff880073d63dd8 R08: ffff8800be8aff9a R09: 0000000000000000
> [ 3866.840965] R10: ffff88013e8aff91 R11: 000000000000000a R12: ffff8800be8aff9a
> [ 3866.840968] R13: ffff880073d63df8 R14: ffff880073d63df0 R15: ffff880073d63e00
> [ 3866.840972] FS:  00007f707c7996e0(0000) GS:ffff8800bf002898(0000)
> knlGS:0000000000000000
> [ 3866.840975] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 3866.840978] CR2: ffff8800be8b0019 CR3: 0000000090844000 CR4: 00000000000006e0
> [ 3866.840982] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 3866.840985] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 3866.840989] Process tail (pid: 7717, threadinfo ffff880073d62000,
> task ffff880088e3dd00)
> [ 3866.840992] Stack:
> [ 3866.840994]  ffffffff806638f8 ffff8800be8aff9a ffffffff80695c45
> ffff8800be8af000
> [ 3866.841000]  0000000000000037 0000000000000fce ffff880073d63e18
> ffffffff8026302f
> [ 3866.841008]  0000000000000002 0000000000000f90 ffff880052574f30
> ffff8800be8af000
> [ 3866.841017] Call Trace:
> [ 3866.841020]  [<ffffffff8026302f>] sprint_symbol+0x28/0xaa
> [ 3866.841025]  [<ffffffff8029e972>] list_locations+0x170/0x2ef
> [ 3866.841031]  [<ffffffff8029eb34>] alloc_calls_show+0x1c/0x24
> [ 3866.841036]  [<ffffffff8029cbbc>] slab_attr_show+0x23/0x27
> [ 3866.841041]  [<ffffffff802efdff>] sysfs_read_file+0xba/0x13c
> [ 3866.841046]  [<ffffffff802a4795>] vfs_read+0xa4/0xde
> [ 3866.841052]  [<ffffffff802a4893>] sys_read+0x47/0x6e
> [ 3866.841056]  [<ffffffff8020b6fb>] system_call_fastpath+0x16/0x1b
> [ 3866.841062] Code: df e8 39 d2 ff ff 5b 41 5c c9 c3 55 48 89 e5 41
> 57 49 89 cf 41 56 49 89 f6 41 55 49 89 d5 41 54 4d 89 c4 53 48 89 fb
> 48 83 ec 08 <41> c6 40 7f 00 41 c6 00 00 48 81 ff 00 90 20 80 72 09 48
> 81 ff
> [ 3866.841128] RIP  [<ffffffff80262f07>] kallsyms_lookup+0x20/0x120
> [ 3866.841134]  RSP <ffff880073d63da8>
> [ 3866.841136] CR2: ffff8800be8b0019
> [ 3866.841140] ---[ end trace ebccc2f1a2509fb0 ]---

Did that happen after a resume from suspend to RAM, by chance?

Rafael
