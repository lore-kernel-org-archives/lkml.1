Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768Ab0AUTRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab0AUTRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 14:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953Ab0AUTRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 14:17:10 -0500
Received: from mail.gmx.net ([213.165.64.20]:55419 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753957Ab0AUTRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 14:17:09 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+mF+tRz1GmJ3828gVDUWHFJhzaP4xQ2AzOzgOgyS
	/5zmNtFl+X/bMR
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: kernel error : 'find /proc/ -type f | xargs -n 1 head -c 10 >/dev/null'
Date: Thu, 21 Jan 2010 20:16:59 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32.4; KDE/4.3.3; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001212017.00160.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55000000000000004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was inspired by http://article.gmane.org/gmane.linux.kernel/941115 .

Running the command (se subject) as a normal user at a 2.6.32.4 kernel
gives this in /var/log/messages:

2010-01-21T20:11:39.171+01:00 n22 kernel: head: page allocation failure. order:9, mode:0xd0                                  
2010-01-21T20:11:39.171+01:00 n22 kernel: Pid: 2324, comm: head Not tainted 2.6.32.4 #1                                      
2010-01-21T20:11:39.171+01:00 n22 kernel: Call Trace:                                                                        
2010-01-21T20:11:39.171+01:00 n22 kernel: [<c106e2cc>] ? __alloc_pages_nodemask+0x4bc/0x5a0                                  
2010-01-21T20:11:39.171+01:00 n22 kernel: [<c108cf5a>] ? cache_alloc_refill+0x2ba/0x510                                      
2010-01-21T20:11:39.171+01:00 n22 kernel: [<c108d299>] ? __kmalloc+0xe9/0xf0                                                 
2010-01-21T20:11:39.171+01:00 n22 kernel: [<c10aa755>] ? seq_read+0x195/0x370                                                
2010-01-21T20:11:39.171+01:00 n22 kernel: [<c10aa5c0>] ? seq_read+0x0/0x370                                                  
2010-01-21T20:11:39.171+01:00 n22 kernel: [<c10cbb6f>] ? proc_reg_read+0x5f/0x90                                             
2010-01-21T20:11:39.171+01:00 n22 kernel: [<c10cbb10>] ? proc_reg_read+0x0/0x90                                              
2010-01-21T20:11:39.171+01:00 n22 kernel: [<c10927c5>] ? vfs_read+0xa5/0x190                                                 
2010-01-21T20:11:39.171+01:00 n22 kernel: [<c1092981>] ? sys_read+0x41/0x80                                                  
2010-01-21T20:11:39.171+01:00 n22 kernel: [<c100300f>] ? sysenter_do_call+0x12/0x26                                          
2010-01-21T20:11:39.171+01:00 n22 kernel: Mem-Info:                                                                          
2010-01-21T20:11:39.171+01:00 n22 kernel: DMA per-cpu:                                                                       
2010-01-21T20:11:39.172+01:00 n22 kernel: CPU    0: hi:    0, btch:   1 usd:   0                                             
2010-01-21T20:11:39.172+01:00 n22 kernel: CPU    1: hi:    0, btch:   1 usd:   0                                             
2010-01-21T20:11:39.172+01:00 n22 kernel: Normal per-cpu:                                                                    
2010-01-21T20:11:39.172+01:00 n22 kernel: CPU    0: hi:  186, btch:  31 usd:   0                                             
2010-01-21T20:11:39.172+01:00 n22 kernel: CPU    1: hi:  186, btch:  31 usd:   0                                             
2010-01-21T20:11:39.172+01:00 n22 kernel: HighMem per-cpu:                                                                   
2010-01-21T20:11:39.172+01:00 n22 kernel: CPU    0: hi:  186, btch:  31 usd:   0                                             
2010-01-21T20:11:39.172+01:00 n22 kernel: CPU    1: hi:  186, btch:  31 usd:   0                                             
2010-01-21T20:11:39.172+01:00 n22 kernel: active_anon:77374 inactive_anon:26716 isolated_anon:0                              
2010-01-21T20:11:39.172+01:00 n22 kernel: active_file:154367 inactive_file:77664 isolated_file:0                             
2010-01-21T20:11:39.172+01:00 n22 kernel: unevictable:0 dirty:74 writeback:432 unstable:0                                    
2010-01-21T20:11:39.172+01:00 n22 kernel: free:107209 slab_reclaimable:41314 slab_unreclaimable:3995                         
2010-01-21T20:11:39.172+01:00 n22 kernel: mapped:23759 shmem:19312 pagetables:882 bounce:0                                   
2010-01-21T20:11:39.172+01:00 n22 kernel: DMA free:12296kB min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB active_file:772kB inactive_file:372kB unevictable:0kB 
isolated(anon):0kB isolated(file):0kB present:15864kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB slab_reclaimable:2520kB slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB 
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
2010-01-21T20:11:39.172+01:00 n22 kernel: lowmem_reserve[]: 0 865 1911 1911
2010-01-21T20:11:39.172+01:00 n22 kernel: Normal free:282076kB min:3728kB low:4660kB high:5592kB active_anon:8kB inactive_anon:3320kB active_file:279600kB inactive_file:121612kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:885944kB mlocked:0kB dirty:140kB writeback:0kB mapped:276kB shmem:16kB slab_reclaimable:162736kB slab_unreclaimable:15980kB 
kernel_stack:900kB pagetables:3528kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
2010-01-21T20:11:39.172+01:00 n22 kernel: lowmem_reserve[]: 0 0 8369 8369
2010-01-21T20:11:39.172+01:00 n22 kernel: HighMem free:134464kB min:512kB low:1636kB high:2764kB active_anon:309488kB inactive_anon:103544kB active_file:337096kB 
inactive_file:188672kB unevictable:0kB isolated(anon):0kB isolated(file):0kB present:1071256kB mlocked:0kB dirty:156kB writeback:1728kB mapped:94760kB shmem:77232kB slab_reclaimable:0kB 
slab_unreclaimable:0kB kernel_stack:0kB pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
2010-01-21T20:11:39.172+01:00 n22 kernel: lowmem_reserve[]: 0 0 0 0
2010-01-21T20:11:39.172+01:00 n22 kernel: DMA: 288*4kB 121*8kB 80*16kB 62*32kB 48*64kB 22*128kB 4*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 12296kB
2010-01-21T20:11:39.172+01:00 n22 kernel: Normal: 19101*4kB 8755*8kB 3545*16kB 1846*32kB 186*64kB 34*128kB 2*256kB 2*512kB 0*1024kB 1*2048kB 0*4096kB = 282076kB
2010-01-21T20:11:39.172+01:00 n22 kernel: HighMem: 304*4kB 260*8kB 1594*16kB 1644*32kB 571*64kB 89*128kB 18*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 134464kB
2010-01-21T20:11:39.172+01:00 n22 kernel: 251864 total pagecache pages
2010-01-21T20:11:39.172+01:00 n22 kernel: 505 pages in swap cache
2010-01-21T20:11:39.172+01:00 n22 kernel: Swap cache stats: add 587, delete 82, find 189/195
2010-01-21T20:11:39.172+01:00 n22 kernel: Free swap  = 2001148kB
2010-01-21T20:11:39.172+01:00 n22 kernel: Total swap = 2003360kB
2010-01-21T20:11:39.172+01:00 n22 kernel: 498176 pages RAM
2010-01-21T20:11:39.172+01:00 n22 kernel: 270850 pages HighMem
2010-01-21T20:11:39.172+01:00 n22 kernel: 5979 pages reserved
2010-01-21T20:11:39.172+01:00 n22 kernel: 251238 pages shared
2010-01-21T20:11:39.172+01:00 n22 kernel: 209073 pages non-shared
2010-01-21T20:11:39.480+01:00 n22 kernel: ACPI: Please implement acpi_video_bus_ROM_seq_show


-- 
MfG/Sincerely
Toralf Förster
