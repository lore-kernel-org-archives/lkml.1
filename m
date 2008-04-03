Return-Path: <linux-kernel-owner+w=401wt.eu-S1758639AbYDCJ2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639AbYDCJ2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 05:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757037AbYDCJ1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 05:27:53 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:14840 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722AbYDCJ1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 05:27:52 -0400
X-Spam-Flag: NO
X-Spam-Score: -8.379
Date: Thu, 3 Apr 2008 11:27:42 +0200 (CEST)
From: "Andreas K. Huettel" <A.K.Huettel@tudelft.nl>
X-X-Sender: huettel@localhost
Reply-To: "Andreas K. Huettel" <mail@akhuettel.de>
To: linux-kernel@vger.kernel.org
Subject: [tainted,fglrx] page allocation failure: basic meaning of log
 messages?
Message-ID: <alpine.LNX.1.00.0804031117030.10277@localhost>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
X-Information: My public GPG key can be obtained at http://www.akhuettel.de/
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: RIPEMD160


Dear developers, 

I've found the following messages in my syslog after a suspend2ram cycle, 
(And similar repeated a few times, all between "freezing userspace" and 
"back to C".) 

I know the system is tainted / running the fglrx module, and (to me) it 
even looks like this might be causing the problem.

So - I'm not asking for a solution, but could cou please please give me a 
rough hint what the error message means???

TIA, best, Andreas 

(Of course I'd be happy to provide more info.)


Apr  3 09:01:30 bellini hal-system-powe: page allocation failure. order:10, mode:0x4020
Apr  3 09:01:30 bellini Pid: 327, comm: hal-system-powe Tainted: PF       2.6.24-gentoo-r3 #1
Apr  3 09:01:30 bellini [<c0140c48>] __alloc_pages+0x2bd/0x2ce
Apr  3 09:01:30 bellini [<c0140c92>] __get_free_pages+0x39/0x47
Apr  3 09:01:30 bellini [<f8adcd9e>] firegl_cmmqs_save_fb+0x8e/0x200 [fglrx]
Apr  3 09:01:30 bellini [<f8ad34d6>] firegl_pm_save_framebuffer+0x66/0x70 [fglrx]
Apr  3 09:01:30 bellini [<f8add198>] firegl_cmmqs_recoverable_surface_info+0x38/0x90 [fglrx]
Apr  3 09:01:30 bellini [<f8ad4be3>] firegl_cail_powerdown+0x93/0x120 [fglrx]
Apr  3 09:01:30 bellini [<f8ac3101>] __ke_remove_wait_queue+0x117/0x2be [fglrx]
Apr  3 09:01:30 bellini [<c01d92a2>] pci_device_suspend+0x18/0x47
Apr  3 09:01:30 bellini [<c023747d>] device_suspend+0xf4/0x1df
Apr  3 09:01:30 bellini [<c011bbae>] printk+0x1b/0x1f
Apr  3 09:01:30 bellini [<c013584b>] suspend_devices_and_enter+0x3d/0xd1
Apr  3 09:01:30 bellini [<c0136092>] freeze_processes+0x71/0x76
Apr  3 09:01:30 bellini [<c01359d7>] enter_state+0xf8/0x162
Apr  3 09:01:30 bellini [<c0135acf>] state_store+0x8e/0xa2
Apr  3 09:01:30 bellini [<c0135a41>] state_store+0x0/0xa2
Apr  3 09:01:30 bellini [<c01851e4>] subsys_attr_store+0x24/0x28
Apr  3 09:01:30 bellini [<c01854bf>] sysfs_write_file+0xa8/0xdb
Apr  3 09:01:30 bellini [<c0185417>] sysfs_write_file+0x0/0xdb
Apr  3 09:01:30 bellini [<c015827e>] vfs_write+0x8a/0x10c
Apr  3 09:01:30 bellini [<c015871d>] sys_write+0x41/0x67
Apr  3 09:01:30 bellini [<c0103b7a>] sysenter_past_esp+0x5f/0x85
Apr  3 09:01:30 bellini =======================
Apr  3 09:01:30 bellini Mem-info:
Apr  3 09:01:30 bellini DMA per-cpu:
Apr  3 09:01:30 bellini CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
Apr  3 09:01:30 bellini Normal per-cpu:
Apr  3 09:01:30 bellini CPU    0: Hot: hi:  186, btch:  31 usd:  72   Cold: hi:   62, btch:  15 usd:  18
Apr  3 09:01:30 bellini HighMem per-cpu:
Apr  3 09:01:30 bellini CPU    0: Hot: hi:  186, btch:  31 usd:  70   Cold: hi:   62, btch:  15 usd:  14
Apr  3 09:01:30 bellini Active:247556 inactive:48481 dirty:27 writeback:0 unstable:0
Apr  3 09:01:30 bellini free:47336 slab:5849 mapped:108336 pagetables:1018 bounce:0
Apr  3 09:01:30 bellini DMA free:5772kB min:68kB low:84kB high:100kB active:2224kB inactive:64kB present:16256kB pages_scanned:0 all_unreclaimable? no
Apr  3 09:01:30 bellini lowmem_reserve[]: 0 873 1507 1507
Apr  3 09:01:30 bellini Normal free:182420kB min:3744kB low:4680kB high:5616kB active:449244kB inactive:99460kB present:894080kB pages_scanned:0 all_unreclaimable? no
Apr  3 09:01:30 bellini lowmem_reserve[]: 0 0 5071 5071
Apr  3 09:01:30 bellini HighMem free:1152kB min:512kB low:1192kB high:1872kB active:538756kB inactive:94400kB present:649100kB pages_scanned:0 all_unreclaimable? no
Apr  3 09:01:30 bellini lowmem_reserve[]: 0 0 0 0
Apr  3 09:01:30 bellini DMA: 431*4kB 242*8kB 84*16kB 20*32kB 2*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 5772kB
Apr  3 09:01:30 bellini Normal: 26655*4kB 5841*8kB 949*16kB 94*32kB 68*64kB 43*128kB 2*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 182420kB
Apr  3 09:01:30 bellini HighMem: 0*4kB 0*8kB 0*16kB 4*32kB 6*64kB 1*128kB 2*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1152kB
Apr  3 09:01:30 bellini Swap cache: add 142720, delete 108392, find 40471/51544, race 0+0
Apr  3 09:01:30 bellini Free swap  = 3748932kB
Apr  3 09:01:30 bellini Total swap = 4008176kB
Apr  3 09:01:30 bellini Free swap:       3748932kB
Apr  3 09:01:30 bellini 392928 pages of RAM
Apr  3 09:01:30 bellini 163552 pages of HIGHMEM



- --
This message is transmitted using 100% recycled electrons.
- --
- ---------------------------------------------------------------------
Dr. Andreas K. Huettel                  tel. +31 15 27 88102  (univ.)
Molecular Electronics and Devices            +31 6 42527466  (mobile)
Kavli Institute of Nanoscience Delft
Delft University of Technology                 A.K.Huettel@tudelft.nl
PO Box 5046, 2600 GA Delft                          mail@akhuettel.de
The Netherlands                     http://www.akhuettel.de/research/
- ---------------------------------------------------------------------
Please use GNUPG or PGP for signed and encrypted email. My public key
can be found at  http://www.akhuettel.de/pgp_key.php

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFH9KMU3ao2Zwy3NWoRA0fdAKCfum8VwjSpfkfmfHNCW+bpG5wImwCdFRFL
40gzgzSaMzy6NqrxMDpWXy4=
=+miJ
-----END PGP SIGNATURE-----
