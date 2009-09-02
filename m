Return-Path: <linux-kernel-owner+w=401wt.eu-S1752646AbZIBPZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646AbZIBPZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 11:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbZIBPZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 11:25:52 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:55165 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbZIBPZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 11:25:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=tgsyG6iZIrsV6DtnxnZMyLSAEGSfm3Jzf68O1GEgtw/IvRCcuNmjKcdmuxgMxzXsad
         /iah+T7SYCEy68vl8zB7knYXSRxKWgV2YVaK1q5+tWSK1KAxKLblRzahd9ppKabN8XPS
         BZCFQeuA3wwBJnkCW+z9atHpBbrrcusGaiAhw=
Subject: Re: [ANNOUNCE] 2.6.31-rc7-rt8
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Mark Knecht <markknecht@gmail.com>
In-Reply-To: <alpine.LFD.2.00.0908261910460.2888@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0904290036500.4529@localhost.localdomain>
	 <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain>
	 <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>
	 <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain>
	 <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain>
	 <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain>
	 <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>
	 <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain>
	 <alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
	 <alpine.LFD.2.00.0908162207370.2782@localhost.localdomain>
	 <alpine.LFD.2.00.0908182140340.3361@localhost.localdomain>
	 <alpine.LFD.2.00.0908192344500.3361@localhost.localdomain>
	 <alpine.LFD.2.00.0908212319370.1769@localhost.localdomain>
	 <alpine.LFD.2.00.0908261910460.2888@localhost.localdomain>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Wed, 02 Sep 2009 23:25:38 +0800
Message-Id: <1251905138.13369.56.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

When I tried to migrate RT-Preempt/linux-mips from 2.6.29.6-rt23 to
2.6.31-rc8, and compile the kernel without PREEMPT_RT. there is a
"kernel panic" take place:

...
find the frame buffer:start=40000000
input: AT Translated Set 2 keyboard as /class/input/input0
usb 1-1: new high speed USB device using ehci_hcd and address 2
atkbd.c: keyboard reset failed on isa0060/serio1
usb 1-1: configuration #1 chosen from 1 choice
usb 2-1: new high speed USB device using ehci_hcd and address 2
usb 2-1: configuration #1 chosen from 1 choice
scsi0 : SCSI emulation for USB Mass Storage devices
Unhandled kernel unaligned access[#1]:
Cpu 0
$ 0   : 0000000000000000 000000001400c4e0 0000000000000018
0000000000000001
$ 4   : ffffffff806175e8 ffffffff806175f0 ffffffffffffffff
ffffffff803c9f84
$ 8   : 00000000000028db ffffffff806b0d75 0000000000000018
74735f6d69616c63
$12   : 0000000000000000 ffffffff80205dbc 0000000000000000
98000000be128000
$16   : ffffffff80620780 980000000100a192 0000000000000002
ffffffff80650e50
$20   : ffffffff80650e50 0000000000000006 ffffffff806b84f8
0000000000000001
$24   : 0000000000000028 ffffffff803c9598
$28   : 98000000be04c000 98000000be04fa40 0000000000000003
ffffffff8027dc70
Hi    : 000000000000010a
Lo    : 000000003df58000
epc   : ffffffff8027dc70 ____pagevec_lru_add+0x1b4/0x364
    Not tainted
ra    : ffffffff8027dc70 ____pagevec_lru_add+0x1b4/0x364
Status: 1400c4e2    KX SX UX KERNEL EXL
Cause : 00008010
BadVA : 980000000100a192
PrId  : 00006303 (ICT Loongson-2)
Modules linked in:
Process swapper (pid: 1, threadinfo=98000000be04c000,
task=98000000be04b818, tls=0)Stack : 0000000000000498 0000000000000030
0000000000000440 0000000000000000
        980000000100a158 0000000000000000 0000000000020058
0000000000000000
        98000000bd00ae30 0000000000000050 ffffffffffffffef
ffffffff80651980
        0000000000000000 ffffffff80273e2c 0000000000000000
ffffffff80651980
        980000000100a158 ffffffff802746f8 0000000000000000
98000000bd00ae30
        98000000be04faa8 0000000000000000 98000000bd00ac40
0000000000000000
        0000000000001000 0000000000000002 0000000000001000
0000000000000000
        00000000003fff77 ffffffff802bee1c 0000000000000000
98000000be436580
        98000000be425b00 98000000006f8400 98000000bd0242f8
0000000000000000
        0000000000000400 0000000000000001 0000000000001000
ffffffff802c3094
        ...
Call Trace:
[<ffffffff8027dc70>] ____pagevec_lru_add+0x1b4/0x364
[<ffffffff80273e2c>] add_to_page_cache_lru+0x84/0xa8
[<ffffffff802746f8>] find_or_create_page+0x98/0xec
[<ffffffff802bee1c>] __getblk+0x12c/0x3d0
[<ffffffff802c3094>] __bread+0x14/0x120
[<ffffffff8030a834>] ext3_fill_super+0x46c/0x17f4
[<ffffffff8029d780>] get_sb_bdev+0x138/0x1bc
[<ffffffff8029d2e0>] vfs_kern_mount+0xb8/0x158
[<ffffffff8029d3d8>] do_kern_mount+0x48/0xf8
[<ffffffff802b4fdc>] do_mount+0x6e0/0x764
[<ffffffff802b5100>] SyS_mount+0xa0/0x104
[<ffffffff80658de0>] mount_block_root+0x124/0x2f8
[<ffffffff806591c8>] prepare_namespace+0x198/0x1cc
[<ffffffff80658218>] kernel_init+0x120/0x140
[<ffffffff8021233c>] kernel_thread_helper+0x10/0x18


Code: 3c04805b  0c083285  6484f3c8 <d2220000> 34420020  f2220000
10400060  000200
Disabling lock debugging due to kernel taint
Kernel panic - not syncing: Attempted to kill init!

Have traced it basically, seems it stopped on SetPageLRU:

mm/swap.c: 

___pagevec_lru_add (struct pagevec *pvec, enum lru_list lru)
...
       VM_BUG_ON(is_unevictable_lru(lru));

        for (i = 0; i < pagevec_count(pvec); i++) {
                struct page *page = pvec->pages[i];
                struct zone *pagezone = page_zone(page);
                int file;
                int active;

                if (pagezone != zone) {
                        if (zone)
                                spin_unlock_irq(&zone->lru_lock);
                        zone = pagezone;
                        spin_lock_irq(&zone->lru_lock);
                }
                VM_BUG_ON(PageActive(page));
                VM_BUG_ON(PageUnevictable(page));
                VM_BUG_ON(PageLRU(page));
                SetPageLRU(page);                  <---------------
                active = is_active_lru(lru);
                file = is_file_lru(lru);
                if (active)
                        SetPageActive(page);
                update_page_reclaim_stat(zone, page, file, active);
                add_page_to_lru_list(zone, page, lru);
        }
        if (zone)
                spin_unlock_irq(&zone->lru_lock);
        release_pages(pvec->pages, pvec->nr, pvec->cold);
        pagevec_reinit(pvec);
...

mm/swap.s:

void SetPageLRU(struct page *page) { set_bit(PG_lru, &page->flags); }

include/linux/page-flags.h:

enum pageflags {
        PG_locked,              /* Page is locked. Don't touch. */
        ...
        PG_lru,
        ...

Not sure why the page address is invalid here? and when i enable
PREEMPT_RT or use the original linux-2.6.31-rc8, it boot normally. any
good suggestion about it?

Regards,
Zhangjin

