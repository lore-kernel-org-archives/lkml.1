Return-Path: <linux-kernel-owner+w=401wt.eu-S965232AbXBTIUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965232AbXBTIUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 03:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965234AbXBTIUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 03:20:23 -0500
Received: from diadema.it.sensus.se ([193.13.139.13]:51554 "EHLO
	diadema.it.sensus.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965232AbXBTIUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 03:20:19 -0500
X-Greylist: delayed 2043 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Feb 2007 03:20:19 EST
Date: Tue, 20 Feb 2007 08:45:58 +0100
To: linux-kernel@vger.kernel.org
Subject: swapper: page allocation failure (2.6.19.2/x86_64)
Message-ID: <20070220074558.GB17088@osk.mine.nu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oskar Liljeblad <oskar@osk.mine.nu>
X-Spam-Score: 0.1 (/)
X-Spam-Report: Spam detection software, running on the system "diadema.it.sensus.se", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  This morning I got some oops after heavy disk and
	network I/O on a linux 2.6.19.2 x86_64 machine (Athlon64 3000+). One of
	the NICs is a natsemi. Apparently disk read/write operations were
	affected as some applications would report write/read failure 'Cannot
	allocate memory'. [...] 
	Content analysis details:   (0.1 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.1 FORGED_RCVD_HELO       Received: contains a forged HELO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This morning I got some oops after heavy disk and network I/O on a linux
2.6.19.2 x86_64 machine (Athlon64 3000+). One of the NICs is a natsemi.
Apparently disk read/write operations were affected as some applications
would report write/read failure 'Cannot allocate memory'.

All oops including this one can be found in the attached log file...

Oskar Liljeblad (oskar@osk.mine.nu)

swapper: page allocation failure. order:0, mode:0x20
 [<c013bf3b>] __alloc_pages+0x20b/0x300
 [<c015125e>] cache_alloc_refill+0x29e/0x4c0
 [<c024f9af>] ip_local_deliver+0x10f/0x2c0
 [<c01514d9>] __kmalloc+0x59/0x60
 [<c0234a76>] __alloc_skb+0x66/0x120
 [<f8817ba2>] refill_rx+0x82/0x140 [natsemi]
 [<f8819f68>] natsemi_poll+0x218/0x700 [natsemi]
 [<f881a7bf>] intr_handler+0xbf/0xd0 [natsemi]
 [<c023afbb>] net_rx_action+0x6b/0x160
 [<c011b423>] __do_softirq+0x43/0x90
 [<c011b497>] do_softirq+0x27/0x30
 [<c010555c>] do_IRQ+0x5c/0xa0
 [<c0117e34>] profile_tick+0x54/0x80
 [<c0101aa1>] default_idle+0x31/0x60
 [<c010374a>] common_interrupt+0x1a/0x20
 [<c0101aa1>] default_idle+0x31/0x60
 [<c0101b0c>] cpu_idle+0x3c/0x60
 [<c030e73c>] start_kernel+0x27c/0x300
 [<c030e250>] unknown_bootoption+0x0/0x270
 =======================
Mem-info:
DMA per-cpu:
CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  60
Active:122960 inactive:91186 dirty:22982 writeback:210 unstable:0 free:1220 slab:8584 mapped:26996 pagetables:434
DMA free:3520kB min:68kB low:84kB high:100kB active:5600kB inactive:3992kB present:16256kB pages_scanned:64 all_unreclaimable? no
lowmem_reserve[]: 0 873
Normal free:1360kB min:3744kB low:4680kB high:5616kB active:486240kB inactive:360752kB present:894080kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0
DMA: 0*4kB 0*8kB 4*16kB 0*32kB 0*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3520kB
Normal: 0*4kB 0*8kB 1*16kB 0*32kB 1*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 1360kB
Swap cache: add 432400, delete 432400, find 228753/271338, race 0+0
Free swap  = 1052104kB
Total swap = 1052216kB
Free swap:       1052104kB
229376 pages of RAM
0 pages of HIGHMEM
2676 reserved pages
155180 pages shared
0 pages swap cached
22982 pages dirty
210 pages writeback
26996 pages mapped
8584 pages slab
434 pages pagetables

--lrZ03NoBR/3+SXJZ
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="oops3.gz"
Content-Transfer-Encoding: base64

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
A8bw3y+2O1UqqQAA

--lrZ03NoBR/3+SXJZ--
