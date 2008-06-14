Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbYFNKNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbYFNKNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 06:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYFNKNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 06:13:09 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:58004 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbYFNKNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 06:13:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=ZjH4sAkIsZJ73Ku1FrZPCXQ8iThIPcXf0Gg7fEhVUsgWVBMw+My1FCC3DA5lIEUUO5
         ywW2OQB+SqHkAigYzRlrDHkw+LfXpxBHyYoN3sJ+NFf2H4AWKdEKVso6gNmW/SZ8u852
         3onGp7Qd77Mro5bKAN3qGW7YH77+9fI0j9q54=
Message-ID: <e1aa27e00806140313o5a62c618kb41b892b7b29e235@mail.gmail.com>
Date: Sat, 14 Jun 2008 12:13:06 +0200
From: "Marco Barbero" <marco.barbero@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: OOM killer invoked on 2.6.24.4
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list

ProLiant DL360 G5, Dual Xeon E5345  @ 2.33GHz, 4Gb RAM
kernel 2.6.24.4
samba/slapd/heartbeat/drbd/mon

Last night mon trigger failover because slapd died.
This was in messages:


Jun 14 01:00:17 pippo kernel: sendmail-mta invoked oom-killer:
gfp_mask=0x800d0, order=0, oomkilladj=0
Jun 14 01:00:17 pippo kernel: Pid: 4520, comm: sendmail-mta Not
tainted 2.6.24.4 #2
Jun 14 01:00:17 pippo kernel:  [<c014a819>] oom_kill_process+0x54/0xf8
Jun 14 01:00:17 pippo kernel:  [<c014ac00>] out_of_memory+0x15c/0x190
Jun 14 01:00:17 pippo kernel:  [<c014c7b2>] __alloc_pages+0x239/0x2c7
Jun 14 01:00:17 pippo kernel:  [<c01661d5>] cp_new_stat64+0xfc/0x10e
Jun 14 01:00:17 pippo kernel:  [<c014c879>] __get_free_pages+0x39/0x47
Jun 14 01:00:17 pippo kernel:  [<c018f8cd>] proc_file_read+0x78/0x237
Jun 14 01:00:17 pippo kernel:  [<c018f855>] proc_file_read+0x0/0x237
Jun 14 01:00:17 pippo kernel:  [<c018c3c1>] proc_reg_read+0x5c/0x6f
Jun 14 01:00:17 pippo kernel:  [<c018c365>] proc_reg_read+0x0/0x6f
Jun 14 01:00:17 pippo kernel:  [<c0163f99>] vfs_read+0x9f/0x121
Jun 14 01:00:17 pippo kernel:  [<c0164396>] sys_read+0x41/0x67
Jun 14 01:00:17 pippo kernel:  [<c0103d56>] sysenter_past_esp+0x5f/0x85
Jun 14 01:00:17 pippo kernel:  =======================
Jun 14 01:00:17 pippo kernel: Mem-info:
Jun 14 01:00:17 pippo kernel: DMA per-cpu:
Jun 14 01:00:17 pippo kernel: CPU    0: Hot: hi:    0, btch:   1 usd:
 0   Cold: hi:    0, btch:   1 usd:   0
Jun 14 01:00:17 pippo kernel: CPU    1: Hot: hi:    0, btch:   1 usd:
 0   Cold: hi:    0, btch:   1 usd:   0
Jun 14 01:00:17 pippo kernel: CPU    2: Hot: hi:    0, btch:   1 usd:
 0   Cold: hi:    0, btch:   1 usd:   0
Jun 14 01:00:17 pippo kernel: CPU    3: Hot: hi:    0, btch:   1 usd:
 0   Cold: hi:    0, btch:   1 usd:   0
Jun 14 01:00:17 pippo kernel: CPU    4: Hot: hi:    0, btch:   1 usd:
 0   Cold: hi:    0, btch:   1 usd:   0
Jun 14 01:00:17 pippo kernel: CPU    5: Hot: hi:    0, btch:   1 usd:
 0   Cold: hi:    0, btch:   1 usd:   0
Jun 14 01:00:17 pippo kernel: CPU    6: Hot: hi:    0, btch:   1 usd:
 0   Cold: hi:    0, btch:   1 usd:   0
Jun 14 01:00:17 pippo kernel: CPU    7: Hot: hi:    0, btch:   1 usd:
 0   Cold: hi:    0, btch:   1 usd:   0
Jun 14 01:00:17 pippo kernel: Normal per-cpu:
Jun 14 01:00:17 pippo kernel: CPU    0: Hot: hi:  186, btch:  31 usd:
116   Cold: hi:   62, btch:  15 usd:  61
Jun 14 01:00:17 pippo kernel: CPU    1: Hot: hi:  186, btch:  31 usd:
37   Cold: hi:   62, btch:  15 usd:  49
Jun 14 01:00:17 pippo kernel: CPU    2: Hot: hi:  186, btch:  31 usd:
107   Cold: hi:   62, btch:  15 usd:  61
Jun 14 01:00:17 pippo kernel: CPU    3: Hot: hi:  186, btch:  31 usd:
41   Cold: hi:   62, btch:  15 usd:  56
Jun 14 01:00:17 pippo kernel: CPU    4: Hot: hi:  186, btch:  31 usd:
13   Cold: hi:   62, btch:  15 usd:   0
Jun 14 01:00:17 pippo kernel: CPU    5: Hot: hi:  186, btch:  31 usd:
167   Cold: hi:   62, btch:  15 usd:  59
Jun 14 01:00:17 pippo kernel: CPU    6: Hot: hi:  186, btch:  31 usd:
61   Cold: hi:   62, btch:  15 usd:   0
Jun 14 01:00:17 pippo kernel: CPU    7: Hot: hi:  186, btch:  31 usd:
102   Cold: hi:   62, btch:  15 usd:   0
Jun 14 01:00:17 pippo kernel: HighMem per-cpu:
Jun 14 01:00:17 pippo kernel: CPU    0: Hot: hi:  186, btch:  31 usd:
 2   Cold: hi:   62, btch:  15 usd:   0
Jun 14 01:00:17 pippo kernel: CPU    1: Hot: hi:  186, btch:  31 usd:
33   Cold: hi:   62, btch:  15 usd:   0
Jun 14 01:00:17 pippo kernel: CPU    2: Hot: hi:  186, btch:  31 usd:
91   Cold: hi:   62, btch:  15 usd:  12
Jun 14 01:00:17 pippo kernel: CPU    3: Hot: hi:  186, btch:  31 usd:
172   Cold: hi:   62, btch:  15 usd:   7
Jun 14 01:00:17 pippo kernel: CPU    4: Hot: hi:  186, btch:  31 usd:
16   Cold: hi:   62, btch:  15 usd:   0
Jun 14 01:00:17 pippo kernel: CPU    5: Hot: hi:  186, btch:  31 usd:
63   Cold: hi:   62, btch:  15 usd:  11
Jun 14 01:00:17 pippo kernel: CPU    6: Hot: hi:  186, btch:  31 usd:
83   Cold: hi:   62, btch:  15 usd:   0
Jun 14 01:00:17 pippo kernel: CPU    7: Hot: hi:  186, btch:  31 usd:
41   Cold: hi:   62, btch:  15 usd:   0
Jun 14 01:00:17 pippo kernel: Active:63299 inactive:6580 dirty:93
writeback:0 unstable:0
Jun 14 01:00:17 pippo kernel:  free:745742 slab:211387 mapped:4303
pagetables:412 bounce:0
Jun 14 01:00:17 pippo kernel: DMA free:3548kB min:68kB low:84kB
high:100kB active:0kB inactive:4kB present:16256kB pages_scanned:25
all_unreclaimable? yes
Jun 14 01:00:17 pippo kernel: lowmem_reserve[]: 0 873 4810 4810
Jun 14 01:00:17 pippo kernel: Normal free:3736kB min:3744kB low:4680kB
high:5616kB active:4616kB inactive:4672kB present:894080kB
pages_scanned:14277 all_unreclaimable? yes
Jun 14 01:00:17 pippo kernel: lowmem_reserve[]: 0 0 31496 31496
Jun 14 01:00:17 pippo kernel: HighMem free:2975684kB min:512kB
low:4736kB high:8960kB active:248580kB inactive:21644kB
present:4031488kB pages_scanned:0 all_unreclaimable? no
Jun 14 01:00:17 pippo kernel: lowmem_reserve[]: 0 0 0 0
Jun 14 01:00:17 pippo kernel: DMA: 7*4kB 2*8kB 1*16kB 1*32kB 2*64kB
0*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3548kB
Jun 14 01:00:17 pippo kernel: Normal: 58*4kB 5*8kB 2*16kB 2*32kB
5*64kB 2*128kB 1*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 3760kB
Jun 14 01:00:17 pippo kernel: HighMem: 7371*4kB 5859*8kB 7946*16kB
6213*32kB 4077*64kB 3064*128kB 1859*256kB 889*512kB 452*1024kB
161*2048kB 48*4096kB = 2975684kB
Jun 14 01:00:17 pippo kernel: Swap cache: add 32, delete 32, find
16/19, race 0+0
Jun 14 01:00:17 pippo kernel: Free swap  = 3903752kB
Jun 14 01:00:17 pippo kernel: Total swap = 3903752kB
Jun 14 01:00:17 pippo kernel: Free swap:       3903752kB
Jun 14 01:00:17 pippo kernel: 1245183 pages of RAM
Jun 14 01:00:17 pippo kernel: 1015807 pages of HIGHMEM
Jun 14 01:00:17 pippo kernel: 207787 reserved pages
Jun 14 01:00:17 pippo kernel: 19533 pages shared
Jun 14 01:00:17 pippo kernel: 0 pages swap cached
Jun 14 01:00:17 pippo kernel: 93 pages dirty
Jun 14 01:00:17 pippo kernel: 0 pages writeback
Jun 14 01:00:17 pippo kernel: 4303 pages mapped
Jun 14 01:00:17 pippo kernel: 211387 pages slab
Jun 14 01:00:17 pippo kernel: 412 pages pagetables
Jun 14 01:00:17 pippo kernel: Out of memory: kill process 6873 (slapd)
score 5003 or a child
Jun 14 01:00:17 pippo kernel: Killed process 6873 (slapd)



Anyone can help me in understanding what went wrong? And if I need to
upgrade to last kernel version?
Thanks in advance
