Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758241Ab0BMX63 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 18:58:29 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:3161 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220Ab0BMX61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 18:58:27 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=chw1dnkIMtMA:10 a=w4iE+TBsmj5y1WloLYF40w==:17
 a=HXMzIM6Ly5ngi4Gx6HYA:9 a=cE9Z8BVwg-xQulFUZ6gA:7
 a=IKrFtHJiIauNHlNY5EbY43ckf2UA:4 a=m3UJEd1SJmbefhOm:21 a=nIRF1I6GBvpOm6Ki:21
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
To: linux-kernel@vger.kernel.org
Subject: oom killing kde erroneously (still)
Date: Sat, 13 Feb 2010 16:58:24 -0700
User-Agent: KMail/1.12.4 (Linux/2.6.32-trunk-amd64; KDE/4.3.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002131658.24842.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the past couple days I've been getting improper OOM Kills. It decides to 
kill ksmserver, klauncher and kdeinit which takes down all of kde, instead 
of whatever is having the actual problem.

What I've been doing is copying files with rsync from my LAN's NFS share, to 
a USB External HDD, and all the while I have things like konversation (irc), 
kontact (email, rss, news), and firefox open doing normal things with them. 
Without the rsync, I don't see these OOM problems. But once I start a 
somewhat long running rsync process (tens to hundreds of GB @ 40MB/s ish), 
kde will be killed after a while (not usually very long, tens of minutes to 
a couple hours).

This machine has 4 gigs of ram, runs 64bit kernel+apps, and while its doing 
the rsync I have a CRAP load of free ram (minus file/disk cache, at least 
half of my ram is free at the time it decides to oom kill kde).

here's my last log:

[316981.060054] __ratelimit: 18 callbacks suppressed                                                                                                                                
[316981.060057] Xorg invoked oom-killer: gfp_mask=0x0, order=0, oom_adj=0                                                                                                           
[316981.060061] Xorg cpuset=/ mems_allowed=0                                                                                                                                        
[316981.060063] Pid: 30074, comm: Xorg Not tainted 2.6.32-trunk-amd64 #1                                                                                                            
[316981.060065] Call Trace:                                                                                                                                                         
[316981.060071]  [<ffffffff810b4cf0>] ? oom_kill_process+0x7f/0x23f                                                                                                                 
[316981.060074]  [<ffffffff810b5214>] ? __out_of_memory+0x12a/0x141                                                                                                                 
[316981.060077]  [<ffffffff810b53f1>] ? pagefault_out_of_memory+0x54/0x7f                                                                                                           
[316981.060080]  [<ffffffff81032532>] ? mm_fault_error+0x39/0xe6                                                                                                                    
[316981.060084]  [<ffffffff810f8004>] ? do_vfs_ioctl+0x48d/0x4cb                                                                                                                    
[316981.060086]  [<ffffffff81032845>] ? do_page_fault+0x266/0x282                                                                                                                   
[316981.060090]  [<ffffffff812e6f25>] ? page_fault+0x25/0x30                                                                                                                        
[316981.060091] Mem-Info:                                                                                                                                                           
[316981.060092] Node 0 DMA per-cpu:                                                                                                                                                 
[316981.060095] CPU    0: hi:    0, btch:   1 usd:   0                                                                                                                              
[316981.060096] CPU    1: hi:    0, btch:   1 usd:   0                                                                                                                              
[316981.060098] Node 0 DMA32 per-cpu:                                                                                                                                               
[316981.060100] CPU    0: hi:  186, btch:  31 usd: 159                                                                                                                              
[316981.060101] CPU    1: hi:  186, btch:  31 usd: 162                                                                                                                              
[316981.060102] Node 0 Normal per-cpu:                                                                                                                                              
[316981.060104] CPU    0: hi:  186, btch:  31 usd:  60                                                                                                                              
[316981.060106] CPU    1: hi:  186, btch:  31 usd: 164                                                                                                                              
[316981.060110] active_anon:180462 inactive_anon:101690 isolated_anon:0                                                                                                             
[316981.060111]  active_file:206232 inactive_file:445534 isolated_file:64                                                                                                           
[316981.060112]  unevictable:0 dirty:186738 writeback:1223 unstable:0                                                                                                               
[316981.060113]  free:6946 slab_reclaimable:40205 slab_unreclaimable:8208                                                                                                           
[316981.060114]  mapped:38427 shmem:56362 pagetables:7406 bounce:0                                                                                                                  
[316981.060116] Node 0 DMA free:15892kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB 
unevictable:0kB isolated(anon):0kB isolated (file):0kB present:15352kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB 
unstable:0kB bounc e:0kB writeback_tmp:0kB pages_scanned:0 
all_unreclaimable? yes                                                                                                                      
[316981.060124] lowmem_reserve[]: 0 2965 3975 3975                                                                                                                                  
[316981.060127] Node 0 DMA32 free:9964kB min:6004kB low:7504kB high:9004kB 
active_anon:431344kB inactive_anon:113788kB active_file:686048kB 
inactive_file:1564488kB unevictable:0kB  isolated(anon):0kB 
isolated(file):0kB present:3037088kB mlocked:0kB dirty:628636kB 
writeback:4008kB mapped:80352kB shmem:70752kB slab_reclaimable:134140kB 
slab_unreclaimable:1280 8kB kernel_stack:496kB pagetables:7560kB 
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:96 
all_unreclaimable? no                                                           
[316981.060136] lowmem_reserve[]: 0 0 1010 1010                                                                                                                                     
[316981.060139] Node 0 Normal free:1928kB min:2044kB low:2552kB high:3064kB 
active_anon:290504kB inactive_anon:292972kB active_file:138880kB 
inactive_file:217648kB unevictable:0kB  isolated(anon):0kB 
isolated(file):256kB present:1034240kB mlocked:0kB dirty:118316kB 
writeback:884kB mapped:73356kB shmem:154696kB slab_reclaimable:26680kB 
slab_unreclaimable:200 08kB kernel_stack:2096kB pagetables:22064kB 
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:592 
all_unreclaimable? no                                                       
[316981.060148] lowmem_reserve[]: 0 0 0 0                                                                                                                                           
[316981.060150] Node 0 DMA: 1*4kB 2*8kB 4*16kB 4*32kB 3*64kB 1*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15892kB                                                           
[316981.060158] Node 0 DMA32: 1701*4kB 21*8kB 1*16kB 3*32kB 3*64kB 1*128kB 
2*256kB 2*512kB 1*1024kB 0*2048kB 0*4096kB = 9964kB                                                      
[316981.060165] Node 0 Normal: 484*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1936kB                                                       
[316981.060172] 710740 total pagecache pages                                                                                                                                        
[316981.060173] 2547 pages in swap cache                                                                                                                                            
[316981.060174] Swap cache stats: add 67296, delete 64749, find 
2122770/2126222                                                                                                     
[316981.060176] Free swap  = 3875884kB                                                                                                                                              
[316981.060177] Total swap = 3903784kB                                                                                                                                              
[316981.078061] 1048576 pages RAM                                                                                                                                                   
[316981.078064] 41362 pages reserved                                                                                                                                                
[316981.078065] 666128 pages shared                                                                                                                                                 
[316981.078066] 504328 pages non-shared                                                                                                                                             
[316981.078069] Out of memory: kill process 30291 (kdeinit4) score 689601 or 
a child                                                                                                
[316981.078073] Killed process 30292 (klauncher)                                                                                                                                    
[317303.788931] Xorg invoked oom-killer: gfp_mask=0x0, order=0, oom_adj=0                                                                                                           
[317303.788935] Xorg cpuset=/ mems_allowed=0                                                                                                                                        
[317303.788938] Pid: 30074, comm: Xorg Not tainted 2.6.32-trunk-amd64 #1                                                                                                            
[317303.788940] Call Trace:                                                                                                                                                         
[317303.788947]  [<ffffffff810b4cf0>] ? oom_kill_process+0x7f/0x23f                                                                                                                 
[317303.788949]  [<ffffffff810b5214>] ? __out_of_memory+0x12a/0x141                                                                                                                 
[317303.788952]  [<ffffffff810b53f1>] ? pagefault_out_of_memory+0x54/0x7f                                                                                                           
[317303.788956]  [<ffffffff81032532>] ? mm_fault_error+0x39/0xe6                                                                                                                    
[317303.788960]  [<ffffffff810f8004>] ? do_vfs_ioctl+0x48d/0x4cb                                                                                                                    
[317303.788962]  [<ffffffff81032845>] ? do_page_fault+0x266/0x282                                                                                                                   
[317303.788966]  [<ffffffff812e6f25>] ? page_fault+0x25/0x30                                                                                                                        
[317303.788967] Mem-Info:                                                                                                                                                           
[317303.788969] Node 0 DMA per-cpu:                                                                                                                                                 
[317303.788971] CPU    0: hi:    0, btch:   1 usd:   0
[317303.788973] CPU    1: hi:    0, btch:   1 usd:   0
[317303.788974] Node 0 DMA32 per-cpu:
[317303.788976] CPU    0: hi:  186, btch:  31 usd: 165
[317303.788978] CPU    1: hi:  186, btch:  31 usd: 195
[317303.788980] Node 0 Normal per-cpu:
[317303.788981] CPU    0: hi:  186, btch:  31 usd:  85
[317303.788983] CPU    1: hi:  186, btch:  31 usd: 219
[317303.788987] active_anon:182223 inactive_anon:103051 isolated_anon:0
[317303.788989]  active_file:208172 inactive_file:439621 isolated_file:64
[317303.788989]  unevictable:0 dirty:183303 writeback:1739 unstable:0
[317303.788990]  free:6949 slab_reclaimable:40788 slab_unreclaimable:8282
[317303.788991]  mapped:38410 shmem:58896 pagetables:7321 bounce:0
[317303.788993] Node 0 DMA free:15892kB min:28kB low:32kB high:40kB 
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB 
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15352kB 
mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB 
slab_reclaimable:0kB slab_unreclaimable:16kB kernel_stack:0kB pagetables:0kB 
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? 
yes
[317303.789005] lowmem_reserve[]: 0 2965 3975 3975
[317303.789008] Node 0 DMA32 free:10032kB min:6004kB low:7504kB high:9004kB 
active_anon:439052kB inactive_anon:117508kB active_file:693604kB 
inactive_file:1542836kB unevictable:0kB isolated(anon):0kB 
isolated(file):0kB present:3037088kB mlocked:0kB dirty:627748kB 
writeback:5956kB mapped:80736kB shmem:80276kB slab_reclaimable:136248kB 
slab_unreclaimable:13036kB kernel_stack:520kB pagetables:7268kB unstable:0kB 
bounce:0kB writeback_tmp:0kB pages_scanned:96 all_unreclaimable? no
[317303.789018] lowmem_reserve[]: 0 0 1010 1010
[317303.789020] Node 0 Normal free:1872kB min:2044kB low:2552kB high:3064kB 
active_anon:289840kB inactive_anon:294696kB active_file:139084kB 
inactive_file:215648kB unevictable:0kB isolated(anon):0kB 
isolated(file):256kB present:1034240kB mlocked:0kB dirty:105464kB 
writeback:1000kB mapped:72904kB shmem:155308kB slab_reclaimable:26904kB 
slab_unreclaimable:20076kB kernel_stack:2088kB pagetables:22016kB 
unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:32 
all_unreclaimable? no
[317303.789030] lowmem_reserve[]: 0 0 0 0
[317303.789033] Node 0 DMA: 1*4kB 2*8kB 4*16kB 4*32kB 3*64kB 1*128kB 2*256kB 
1*512kB 2*1024kB 2*2048kB 2*4096kB = 15892kB
[317303.789040] Node 0 DMA32: 446*4kB 171*8kB 17*16kB 116*32kB 3*64kB 
1*128kB 2*256kB 2*512kB 1*1024kB 0*2048kB 0*4096kB = 10016kB
[317303.789047] Node 0 Normal: 470*4kB 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1880kB
[317303.789055] 709621 total pagecache pages
[317303.789056] 2829 pages in swap cache
[317303.789058] Swap cache stats: add 67587, delete 64758, find 
2127187/2130640
[317303.789059] Free swap  = 3874732kB
[317303.789061] Total swap = 3903784kB
[317303.807036] 1048576 pages RAM
[317303.807039] 41362 pages reserved
[317303.807040] 655519 pages shared
[317303.807041] 512828 pages non-shared
[317303.807044] Out of memory: kill process 30291 (kdeinit4) score 817786 or 
a child
[317303.807048] Killed process 30345 (ksmserver)

I think the only reason it stops there is that the rsync job is running in a 
konsole tab, so that dies along with KDE.

I'm running 2.6.32 from debian sid, on a dual core intel based laptop.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
