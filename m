Return-Path: <linux-kernel-owner+w=401wt.eu-S935285AbXGTUZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935285AbXGTUZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 16:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762992AbXGTUY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 16:24:58 -0400
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1980 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762055AbXGTUY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 16:24:57 -0400
Date: Fri, 20 Jul 2007 21:53:12 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.21.1] totally hanging altough not crashed
Message-ID: <20070720195252.GA25317@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Sat Jul 21 21:41:40 CEST 2007
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

One of my systems running 2.6.21.1 on a P4 with HT and 2GB of ram
occasionally crashes. Not with an oops or panic, it just suddenly stops
doing anything. It still lets you ping and it still forwards ip traffic
but you can't login: not via ssh and not on the console - pressing enter
brings the cursor to the next line and that's it. It is NOT swapping at
all, in fact alt+sysrq+m says that there's still plenty of memory and
swap available:

[783341.404485] SysRq : HELP : loglevel0-8 reBoot Crashdump show-all-locks(D) tErm Full kIll saK showMem Nice powerOff showPc show-all-timers(Q) unRaw Sync showTasks Unmount shoW-blocked-tasks 
[783344.380160] SysRq : Show Memory
[783344.380247] Mem-info:
[783344.380288] DMA per-cpu:
[783344.380331] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[783344.380383] CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[783344.380434] Normal per-cpu:
[783344.380477] CPU    0: Hot: hi:  186, btch:  31 usd:   5   Cold: hi:   62, btch:  15 usd:   0
[783344.380531] CPU    1: Hot: hi:  186, btch:  31 usd:  87   Cold: hi:   62, btch:  15 usd:  60
[783344.380581] HighMem per-cpu:
[783344.380624] CPU    0: Hot: hi:  186, btch:  31 usd: 100   Cold: hi:   62, btch:  15 usd:   3
[783344.380675] CPU    1: Hot: hi:  186, btch:  31 usd: 104   Cold: hi:   62, btch:  15 usd:  61
[783344.380728] Active:283054 inactive:192477 dirty:298 writeback:0 unstable:0
[783344.380730]  free:24391 slab:12716 mapped:14430 pagetables:1464 bounce:3
[783344.380818] DMA free:8604kB min:68kB low:84kB high:100kB active:7172kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? no
[783344.380871] lowmem_reserve[]: 0 873 2015
[783344.381048] Normal free:78776kB min:3744kB low:4680kB high:5616kB active:280560kB inactive:450412kB present:894080kB pages_scanned:0 all_unreclaimable? no
[783344.381104] lowmem_reserve[]: 0 0 9137
[783344.381280] HighMem free:10184kB min:512kB low:1736kB high:2960kB active:844484kB inactive:319496kB present:1169608kB pages_scanned:0 all_unreclaimable? no
[783344.381336] lowmem_reserve[]: 0 0 0
[783344.381510] DMA: 93*4kB 61*8kB 60*16kB 56*32kB 22*64kB 2*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 8604kB
[783344.381965] Normal: 6383*4kB 1501*8kB 2121*16kB 143*32kB 1*64kB 0*128kB 0*256kB 1*512kB 0*1024kB 1*2048kB 0*4096kB = 78676kB
[783344.382420] HighMem: 945*4kB 585*8kB 81*16kB 4*32kB 0*64kB 0*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 10140kB
[783344.382871] Swap cache: add 43, delete 43, find 0/0, race 0+0
[783344.382915] Free swap  = 454496kB
[783344.382956] Total swap = 454600kB
[783344.382998] Free swap:       454496kB
[783344.394272] 524080 pages of RAM
[783344.394323] 294704 pages of HIGHMEM
[783344.394368] 5983 reserved pages
[783344.394410] 134216 pages shared
[783344.394451] 0 pages swap cached
[783344.394493] 298 pages dirty
[783344.394535] 0 pages writeback
[783344.394575] 14430 pages mapped
[783344.394616] 12716 pages slab
[783344.394656] 1464 pages pagetables

The only thing getting it from this is...a hard reboot because even
ctrl+alt+delete is ignored.

alt+srq+p gives:

[783336.561037] SysRq : Show Regs
[783336.561116] 
[783336.561152] Pid: 0, comm:              swapper
[783336.561191] EIP: 0060:[<c100206b>] CPU: 0
[783336.561233] EIP is at default_idle+0x45/0x5a
[783336.561273]  EFLAGS: 00000282    Not tainted  (2.6.21.1test3 #11)
[783336.561313] EAX: 1d91386d EBX: c1336f00 ECX: 00000000 EDX: 00000000
[783336.561355] ESI: c1336e80 EDI: c12f5000 EBP: c1302fcc DS: 007b ES: 007b FS: 00d8
[783336.561432] CR0: 8005003b CR2: b7af3000 CR3: 1dd3c000 CR4: 000006d0
[783336.561473]  =======================

I've put the output of alt+srq+t at
http://keetweej.vanheusden.com/~folkert/ast.txt as it is halve a
megabyte in size.

Anyone can give a suggestion of what is going on? And what to do about
it?


Folkert van Heusden

-- 
www.vanheusden.com/multitail - multitail is tail on steroids. multiple
               windows, filtering, coloring, anything you can think of
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
