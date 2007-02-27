Return-Path: <linux-kernel-owner+w=401wt.eu-S1161110AbXB0JjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161110AbXB0JjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 04:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161111AbXB0JjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 04:39:22 -0500
Received: from mail.mwutah.com ([208.186.255.2]:60400 "EHLO mail.mwutah.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161110AbXB0JjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 04:39:21 -0500
X-Greylist: delayed 1846 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Feb 2007 04:39:20 EST
Message-ID: <45E3E199.1020804@mwutah.com>
Date: Tue, 27 Feb 2007 00:45:29 -0700
From: Lou Langholtz <ldl@mwutah.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060501 Fedora/1.7.13-1.1.fc4
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: page allocation failures through twa_chrdec_ioctl with x86_64 2.6.18+?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hoping someone can help with some insight...

A couple of 2.6.18 x86_64 systems that I'm working on have been getting 
page allocation failures under heavy load with call traces that go 
through the 3ware twa_chrdev_ioctl function.  The systems have 2 gig of 
physical RAM though. Seems like page allocation failures were occurring 
with the Intel e1000 driver for a few kernel releases but then went away 
- presumably the page allocation strategy was changed to work away from 
the failure. Now the page allocation failures are happening through this 
3ware driver ioctl function. Is this a bug in the 3ware driver? The 
problem never occurs on 32 bit x86 systems, just 64 bit systems.

Please CC me directly on any replies since I'm not subscribed to the 
list anymore. Thanks!

Here's what the traces look like:

smartctl: page allocation failure. order:0, mode:0x10d4

Call Trace:
 [<ffffffff80157009>] __alloc_pages+0x2a9/0x2c2
 [<ffffffff8011061f>] dma_alloc_pages+0x37/0x73
 [<ffffffff80123b94>] __activate_task+0x27/0x3a
 [<ffffffff801106d4>] dma_alloc_coherent+0x79/0x245
 [<ffffffff80328592>] *twa_chrdev_ioctl*+0xb6/0x7db
 [<ffffffff80123f16>] __wake_up+0x38/0x51
 [<ffffffff80189d7c>] file_update_time+0x30/0xbc
 [<ffffffff8018314e>] do_ioctl+0x5e/0x79
 [<ffffffff801833dd>] vfs_ioctl+0x274/0x28d
 [<ffffffff801720e1>] vfs_write+0x10e/0x146
 [<ffffffff80183431>] sys_ioctl+0x3b/0x5e
 [<ffffffff8010995a>] system_call+0x7e/0x83

Mem-info:
DMA per-cpu:
cpu 0 hot: high 0, batch 1 used:0
cpu 0 cold: high 0, batch 1 used:0
cpu 1 hot: high 0, batch 1 used:0
cpu 1 cold: high 0, batch 1 used:0
DMA32 per-cpu:
cpu 0 hot: high 186, batch 31 used:17
cpu 0 cold: high 62, batch 15 used:47
cpu 1 hot: high 186, batch 31 used:26
cpu 1 cold: high 62, batch 15 used:52
Normal per-cpu: empty
HighMem per-cpu: empty
Free pages:      127408kB (0kB HighMem)
Active:58356 inactive:146246 dirty:98517 writeback:4291 unstable:0 free:31852
slab:11052 mapped:8536 pagetables:427
DMA free:5368kB min:1396kB low:1744kB high:2092kB active:1648kB inactive:2284kB
present:10976kB pages_scanned:64 all_unreclaimable? no
lowmem_reserve[]: 0 993 993 993
DMA32 free:120552kB min:129672kB low:162088kB high:194508kB active:231776kB
inactive:582700kB present:1016944kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
Normal free:0kB min:0kB low:0kB high:0kB active:0kB inactive:0kB present:0kB
pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
HighMem free:0kB min:128kB low:128kB high:128kB active:0kB inactive:0kB
present:0kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0 0
DMA: 4*4kB 1*8kB 1*16kB 1*32kB 1*64kB 1*128kB 0*256kB 0*512kB 1*1024kB 0*2048kB
1*4096kB = 5384kB
DMA32: 17*4kB 670*8kB 597*16kB 93*32kB 3*64kB 1*128kB 0*256kB 0*512kB 0*1024kB
0*2048kB 25*4096kB = 120676kB
Normal: empty
HighMem: empty
Swap cache: add 147, delete 147, find 44/71, race 0+0
Free swap  = 3145568kB
Total swap = 3145720kB
Free swap:       3145568kB
261856 pages of RAM
5239 reserved pages
176405 pages shared
0 pages swap cached

