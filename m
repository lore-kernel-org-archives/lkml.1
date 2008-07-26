Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbYGZNPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbYGZNPh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYGZNP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:15:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49025 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808AbYGZNP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:15:28 -0400
Date: Sat, 26 Jul 2008 15:15:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [bug] PCI hotplug, ibmphp_access_ebda: WARNING: at
	arch/x86/mm/ioremap.c:182 __ioremap_caller+0x2d1/0x340()
Message-ID: <20080726131512.GA29472@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FYI, -tip testing triggered the new warning below on a testbox. I 
suspect it's related to recent commits in drivers/pci/hotplug/.
I'm wondering, why does a driver map the EBDA? That's a really lowlevel 
thing.

	Ingo

---------------->
calling  pci_hotplug_init+0x0/0x60
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
initcall pci_hotplug_init+0x0/0x60 returned 0 after 4 msecs
calling  ibmphp_init+0x0/0x6d0
ibmphpd: IBM Hot Plug PCI Controller Driver version: 0.6
------------[ cut here ]------------
WARNING: at arch/x86/mm/ioremap.c:182 __ioremap_caller+0x2d1/0x340()
Pid: 1, comm: swapper Not tainted 2.6.26-tip #6
 [<c1028acf>] warn_on_slowpath+0x4f/0x80
 [<c1048ae0>] ? mark_held_locks+0x40/0x80
 [<c100fa64>] ? xapic_wait_icr_idle+0x14/0x20
 [<c100f47e>] ? __send_IPI_shortcut+0x3e/0x50
 [<c1001723>] ? send_IPI_allbutself+0x33/0x70
 [<c1048d0b>] ? trace_hardirqs_on+0xb/0x10
 [<c100f26e>] ? native_send_call_func_ipi+0x4e/0x60
 [<c104d1d4>] ? smp_call_function_mask+0xd4/0x150
 [<c100f730>] ? do_flush_tlb_all+0x0/0x60
 [<c100f730>] ? do_flush_tlb_all+0x0/0x60
 [<c1048ae0>] ? mark_held_locks+0x40/0x80
 [<c1048d0b>] ? trace_hardirqs_on+0xb/0x10
 [<c100f730>] ? do_flush_tlb_all+0x0/0x60
 [<c10145b1>] __ioremap_caller+0x2d1/0x340
 [<c1048d0b>] ? trace_hardirqs_on+0xb/0x10
 [<c1048c7d>] ? trace_hardirqs_on_caller+0xbd/0x140
 [<c16fa84d>] ? _write_unlock+0x1d/0x20
 [<c1a9f016>] ? ibmphp_access_ebda+0x66/0xc70
 [<c101475a>] ioremap_nocache+0x1a/0x20
 [<c1a9f016>] ? ibmphp_access_ebda+0x66/0xc70
 [<c1a9f016>] ibmphp_access_ebda+0x66/0xc70
 [<c1044392>] ? debug_mutex_init+0x32/0x50
 [<c1047005>] ? lockdep_init_map+0x35/0x100
 [<c103d4f3>] ? __mutex_init+0x43/0x60
 [<c1aa0fe9>] ? ibmphp_hpc_initvars+0x139/0x1a0
 [<c1a9d4f9>] ibmphp_init+0x99/0x6d0
 [<c103df39>] ? ktime_get+0x19/0x40
 [<c1001190>] do_one_initcall+0x30/0x170
 [<c1a9d460>] ? ibmphp_init+0x0/0x6d0
 [<c1048d0b>] ? trace_hardirqs_on+0xb/0x10
 [<c1037ab1>] ? __queue_work+0x31/0x40
 [<c1037b28>] ? queue_work_on+0x38/0x50
 [<c1a82cd8>] kernel_init+0x138/0x210
 [<c1a82ba0>] ? kernel_init+0x0/0x210
 [<c100474f>] kernel_thread_helper+0x7/0x18
 =======================
---[ end trace a7919e7f17c0a725 ]---
initcall ibmphp_init+0x0/0x6d0 returned -12 after 179 msecs
initcall ibmphp_init+0x0/0x6d0 returned with error code -12 
calling  zt5550_init+0x0/0xa0
cpcihp_zt5550: ZT5550 CompactPCI Hot Plug Driver version: 0.2
initcall zt5550_init+0x0/0xa0 returned 0 after 32 msecs
calling  shpcd_init+0x0/0x60
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
initcall shpcd_init+0x0/0x60 returned 0 after 6 msecs
calling  dummyphp_init+0x0/0xb0
fakephp: Fake PCI Hot Plug Controller Driver
pci_create_slot: created pci_slot on 0000:00:00
pci_create_slot: created pci_slot on 0000:00:01
pci_create_slot: created pci_slot on 0000:00:02
pci_create_slot: created pci_slot on 0000:00:1e
pci_create_slot: created pci_slot on 0000:00:1f
pci_create_slot: created pci_slot on 0000:01:00
pci_create_slot: created pci_slot on 0000:02:1f
pci_create_slot: created pci_slot on 0000:03:00
pci_create_slot: created pci_slot on 0000:03:04
pci_create_slot: created pci_slot on 0000:04:03
pci_create_slot: created pci_slot on 0000:04:04
pci_create_slot: created pci_slot on 0000:04:07
initcall dummyphp_init+0x0/0xb0 returned 0 after 144 msecs
calling  platform_lcd_init+0x0/0x10
initcall platform_lcd_init+0x0/0x10 returned 0 after 2 msecs
calling  mbp_init+0x0/0x10
initcall mbp_init+0x0/0x10 returned -19 after 0 msecs
calling  cyber2000fb_init+0x0/0xc0
initcall cyber2000fb_init+0x0/0xc0 returned 0 after 2 msecs
