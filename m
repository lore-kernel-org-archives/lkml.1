Return-Path: <linux-kernel-owner+w=401wt.eu-S1761573AbXGONNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761573AbXGONNX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 09:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755084AbXGONM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 09:12:56 -0400
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:42944 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752197AbXGONMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 09:12:53 -0400
X-Greylist: delayed 4166 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Jul 2007 09:12:53 EDT
Date: Sun, 15 Jul 2007 15:03:21 +0300
From: Sami Farin <safari-kernel@safari.iki.fi>
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.22: had to reboot after OOM
Message-ID: <20070715120321.kyvbw5wjx6mwviu6@m.safari.iki.fi>
Mail-Followup-To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="benwmrrnutdfs7k5"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--benwmrrnutdfs7k5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

After I got this error [1], system got real slow, like 386 having 32 MB of RAM
and swapping constantly.
My system is P4 SMP with 1GB of RAM.

I got this same behavior with 2.6.19, too, but then I used GNU cp v6.9
which had micro-optimization which did not bother doing read() for regular
files, like /proc/vmstat , instead, it generated 0-byte destination file
(I noticed that only after rebooting).
So I do not have useful debug info for 2.6.19.

And now my version of cp does not have that micro-optimization.

I also attached vmstat and slabinfo , in case somebody can figure out
something out of them.
I also now use --probes=5 for ipset nethash... uses less mem but is slower.

procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa st
 0  2 762376 748392      0  17104   11    8    52    65   64    53 10  3 85  3  0
 0  3 762376 748664      0  17144  456   12   908    24  237  3044  2  3 26 70  0
 0  2 762376 749544      0  16492  464  284  1440   288  248  3633  2  5 14 79  0
 0  3 762376 749916      0  16392  432    0  1368    16  239  3360  1  2  5 93  0
 0  3 762376 751108      0  15740  512  432  1656   460  214  3751  1  3 28 69  0
 0  7 762376 751740      0  15512  532  104  1920   131  237  4014  2  4  5 90  0
 0 10 762436 755064      0  15652  200 3172   992  3264  274  5086  1  3  1 96  0
 0 11 762504 757208      0  15156  144  836   624   926  204  2602  1  2  0 98  0
 0 13 762680 766384      0  12740   36 7284    96  7308  252  8643  0  5  0 95  0
 0 14 762772 771312      0  11696   12 3908   132  3912  253  5153  0  3  0 97  0
 0 13 763044 778536      0  10356  184 8088   572  8088  249  6889  1  3  0 97  0
 0 15 763092 781380      0  10284    0 2136   532  2160  176  2387  1  2  0 98  0
 0 16 763360 785428      0  10008   60 4884  1312  4985  281  4798  0  5  0 96  0
 0 19 763636 791192      0   8548   24 6264   476  6268  219  6732  0  3  0 97  0
 0 18 763824 799184      0   6240    0 7500    52  7504  217  7080  1  6  0 94  0
 0 18 763872 802196      0   5816    0 2628   552  2640  194  3851  0  4  0 96  0
 0 28 764048 805072      0   5168   92 1760  1180  1772  185  2703  0  5  0 94  0
 0 30 764048 806032      0   5256   36  164   364   234  126  1448  0  1  0 99  0
 0 31 764048 807728      0   4732   32   40    92    84  152  1824  0  3  0 97  0
 0 35 764056 809372      0   4332 1100  532  9084   804  194  1986  0  7  0 94  0
 0 74 764012 839544      0   8100 1604    0  5660    12 4216 46853  0  8  0 92  0

procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free  inact active   si   so    bi    bo   in    cs us sy id wa st
 0 14 762504 757108   4004  90724   11    8    52    65   64    53 10  3 85  3  0
 0 13 762676 764608   8768  78084   44 6324   288  6370  251  7697  0  4  0 95  0
 0 14 762772 770832  12404  68328   12 4868   128  4880  243  6161  0  4  0 96  0
 0 13 763044 778536  24248  48736  180 7908   548  7912  296  7208  0  3  0 97  0
 0 16 763092 781380  21196  49004    4 2312   560  2336  185  2524  1  1  0 98  0
 0 16 763360 784584  40040  27048   60 4088  1312  4189  267  3964  0  4  0 96  0
 0 19 763636 791192  36552  23804   24 7064   392  7068  227  7600  0  4  0 96  0
 0 18 763824 798896  36928  15568    0 7352   136  7356  219  6902  0  5  0 94  0
 0 19 763872 802088  41372   7876    0 2776   548  2788  195  3917  0  4  0 96  0
 0 25 764048 804636  39896   6932   56 1760   920  1772  170  2602  0  4  0 95  0
 0 30 764048 806032  39308   6272   72  164   628   234  131  1579  0  2  0 98  0
 0 30 764048 807500  38316   5768   32   40    84    68  149  1630  0  2  0 98  0
 1 34 764056 808476  37900   5444   20  192   660   242  184  1883  0  6  0 94  0
 1 37 764056 811148  38772   1740   20  100   388   104  168  2409  0  5  0 95  0
 0 38 764056 813056  34164   4536    0    0   124    47  227  2590  0  6  0 94  0
 0 38 764056 815500  32924   3308   40    0   608     5  228  2448  0  4  0 96  0
10 37 764056 817764  30404   3800    0   16   260    20  323  3795  0 10  0 90  0
 1 37 764056 819548  28552   3744    0   20   148    56  207  2275  0  6  0 94  0
 1 38 764056 820828  27004   4028   20    8   496    21  216  1703  0  3  0 97  0
 0 71 764056 820064  28228   3508  600    0  1424     4  140   826  0  2  0 99  0
 0 73 764028 822568  25928   3404   68   36   332    48  205  2223  0  5  0 95  0



As a comparison, these are stats after booting, with similar workload:

procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy id wa st
 2  0 290544  12728      0 444216    2   13   213   285  144   922  7  2 82  9  0
 0  0 290544  12672      0 444264    0    0    16  1616  270  1881  2  2 96  0  0
 0  0 290544  12752      0 444280    0    0    16    56  245  1687  2  2 96  1  0
 0  0 290544  12876      0 444280    0    0     0    31  243  1604  2  1 97  0  0
 0  0 290544  12520      0 444260   48    0    80    50  333  1708  2  2 94  2  0
 0  0 290544  12656      0 444424    0    0   136   114  269  1817  3  2 95  1  0
 0  0 290544  12672      0 444448    0    0    12  1687  330  1822  2  2 97  0  0

procs -----------memory---------- ---swap-- -----io---- --system-- -----cpu------
 r  b   swpd   free  inact active   si   so    bi    bo   in    cs us sy id wa st
 2  0 290544  18756 316324 420928    2   13   212   284  144   922  7  2 82  9  0
 0  0 290544  18716 316360 421112    0    0    32    72  273  1979  2  2 96  0  0
 0  0 290544  18472 316504 421152    0    0   144    51  256  1644  3  1 97  0  0
 0  0 290544  18256 316520 421144    0    0    16    63  240  1768  2  3 96  1  0
 0  0 290544  18264 316520 421160    0    0     0   121  243  1770  2  1 97  0  0
 0  0 290544  18312 316520 421168    0    0     8    51  235  1789  2  1 97  0  0
 0  0 290544  18252 316544 421168    0    0    24   204  296  2017  2  1 96  1  0

...

and the rest are after the mem allocation failure.

2007-07-15 10:43:02.271042500 <6>[246964.992391] SysRq : Show Memory
2007-07-15 10:43:02.271082500 <6>[246964.992399] Mem-info:
2007-07-15 10:43:02.271103500 <4>[246964.992401] DMA per-cpu:
2007-07-15 10:43:02.271123500 <4>[246964.992405] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
2007-07-15 10:43:02.271144500 <4>[246964.992409] CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
2007-07-15 10:43:02.271164500 <4>[246964.992412] Normal per-cpu:
2007-07-15 10:43:02.271185500 <4>[246964.992415] CPU    0: Hot: hi:  186, btch:  31 usd:  31   Cold: hi:   62, btch:  15 usd:  50
2007-07-15 10:43:02.271205500 <4>[246964.992419] CPU    1: Hot: hi:  186, btch:  31 usd:  21   Cold: hi:   62, btch:  15 usd:  59
2007-07-15 10:43:02.271225500 <4>[246964.992422] HighMem per-cpu:
2007-07-15 10:43:02.271245500 <4>[246964.992425] CPU    0: Hot: hi:   42, btch:   7 usd:   6   Cold: hi:   14, btch:   3 usd:   1
2007-07-15 10:43:02.271266500 <4>[246964.992429] CPU    1: Hot: hi:   42, btch:   7 usd:   4   Cold: hi:   14, btch:   3 usd:   1
2007-07-15 10:43:02.271287500 <4>[246964.992434] Active:23152 inactive:648 dirty:8 writeback:50 unstable:0
2007-07-15 10:43:02.271307500 <4>[246964.992436]  free:189843 slab:8987 mapped:3892 pagetables:1960 bounce:0
2007-07-15 10:43:02.271329500 <4>[246964.992440] DMA free:10384kB min:68kB low:84kB high:100kB active:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? yes
2007-07-15 10:43:02.271349500 <4>[246964.992444] lowmem_reserve[]: 0 873 975
2007-07-15 10:43:02.271371500 <4>[246964.992451] Normal free:742488kB min:3744kB low:4680kB high:5616kB active:2860kB inactive:212kB present:894080kB pages_scanned:0 all_unreclaimable? no
2007-07-15 10:43:02.271391500 <4>[246964.992454] lowmem_reserve[]: 0 0 817
2007-07-15 10:43:02.271413500 <4>[246964.992461] HighMem free:6500kB min:128kB low:236kB high:344kB active:89748kB inactive:2380kB present:104648kB pages_scanned:346 all_unreclaimable? no
2007-07-15 10:43:02.271433500 <4>[246964.992464] lowmem_reserve[]: 0 0 0
2007-07-15 10:43:02.271454500 <4>[246964.992468] DMA: 14*4kB 15*8kB 14*16kB 12*32kB 10*64kB 10*128kB 8*256kB 1*512kB 1*1024kB 0*2048kB 1*4096kB = 10384kB
2007-07-15 10:43:02.271476500 <4>[246964.992481] Normal: 23450*4kB 19190*8kB 12331*16kB 5473*32kB 1389*64kB 200*128kB 12*256kB 2*512kB 2*1024kB 1*2048kB 0*4096kB = 742440kB
2007-07-15 10:43:02.271498500 <4>[246964.992495] HighMem: 1*4kB 0*8kB 133*16kB 34*32kB 3*64kB 0*128kB 0*256kB 6*512kB 0*1024kB 0*2048kB 0*4096kB = 6484kB
2007-07-15 10:43:02.271519500 <4>[246964.992509] Swap cache: add 1800223, delete 1781495, find 1255162/1452648, race 0+116
2007-07-15 10:43:02.271539500 <4>[246964.992512] Free swap  = 3149924kB
2007-07-15 10:43:02.271558500 <4>[246964.992514] Total swap = 3911784kB
2007-07-15 10:43:02.271578500 <6>[246964.992516] Free swap:       3149924kB
2007-07-15 10:43:02.273952500 <6>[246964.995940] 255744 pages of RAM
2007-07-15 10:43:02.273972500 <6>[246964.995946] 26368 pages of HIGHMEM
2007-07-15 10:43:02.273992500 <6>[246964.995953] 4035 reserved pages
2007-07-15 10:43:02.274011500 <6>[246964.995960] 42603 pages shared
2007-07-15 10:43:02.274030500 <6>[246964.995967] 18736 pages swap cached
2007-07-15 10:43:02.274049500 <6>[246964.995972] 8 pages dirty
2007-07-15 10:43:02.274068500 <6>[246964.995977] 50 pages writeback
2007-07-15 10:43:02.274087500 <6>[246964.995985] 3892 pages mapped
2007-07-15 10:43:02.274106500 <6>[246964.995989] 8987 pages slab
2007-07-15 10:43:02.274184500 <6>[246964.995995] 1960 pages pagetables


-------------------------------------------------------------------------------------

[1]

2007-07-15 10:12:40.640668500 <4>[245143.816358] net/ipv4/netfilter/ip_set_nethash.c: retry: rehashing of set blockedp2pnew triggered: hashsize grows from 262144 to 348651
2007-07-15 10:12:40.640672500 <4>[245143.816379] ipset: page allocation failure. order:9, mode:0x20
2007-07-15 10:12:40.640674500 <4>[245143.816384]  [<c010385b>] show_trace_log_lvl+0x1a/0x30
2007-07-15 10:12:40.640675500 <4>[245143.816395]  [<c0104459>] show_trace+0x12/0x14
2007-07-15 10:12:40.640677500 <4>[245143.816399]  [<c01044b5>] dump_stack+0x16/0x18
2007-07-15 10:12:40.640678500 <4>[245143.816404]  [<c0150dd0>] __alloc_pages+0x2d7/0x2ed
2007-07-15 10:12:40.640700500 <4>[245143.816410]  [<c016803a>] cache_alloc_refill+0x2b4/0x4dc
2007-07-15 10:12:40.640701500 <4>[245143.816417]  [<c01682ec>] __kmalloc+0x8a/0x8c
2007-07-15 10:12:40.640703500 <4>[245143.816421]  [<f8e47ff0>] retry+0x51/0x455 [ip_set_nethash]
2007-07-15 10:12:40.640704500 <4>[245143.816431]  [<f8dc55e0>] __ip_set_addip+0x55/0x65 [ip_set]
2007-07-15 10:12:40.640705500 <4>[245143.816446]  [<f8dc679e>] ip_set_sockfn_get+0x8c9/0xc70 [ip_set]
2007-07-15 10:12:40.640711500 <4>[245143.816454]  [<c043b567>] nf_sockopt+0x77/0xf5
2007-07-15 10:12:40.640712500 <4>[245143.816461]  [<c043b606>] nf_getsockopt+0x21/0x27
2007-07-15 10:12:40.640714500 <4>[245143.816465]  [<c0446423>] ip_getsockopt+0x1b3/0x69c
2007-07-15 10:12:40.640715500 <4>[245143.816470]  [<c045f3b5>] raw_getsockopt+0x26/0x96
2007-07-15 10:12:40.640717500 <4>[245143.816475]  [<c041ce17>] sock_common_getsockopt+0x1e/0x25
2007-07-15 10:12:40.640728500 <4>[245143.816482]  [<c041b25e>] sys_getsockopt+0x6c/0x99
2007-07-15 10:12:40.640730500 <4>[245143.816486]  [<c041cb42>] sys_socketcall+0x23c/0x277
2007-07-15 10:12:40.640731500 <4>[245143.816490]  [<c01028e2>] syscall_call+0x7/0xb
2007-07-15 10:12:40.640732500 <4>[245143.816494]  =======================
2007-07-15 10:12:40.640734500 <6>[245143.816497] Mem-info:
2007-07-15 10:12:40.640735500 <4>[245143.816499] DMA per-cpu:
2007-07-15 10:12:40.640740500 <4>[245143.816503] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
2007-07-15 10:12:40.640742500 <4>[245143.816507] CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
2007-07-15 10:12:40.640744500 <4>[245143.816510] Normal per-cpu:
2007-07-15 10:12:40.640745500 <4>[245143.816513] CPU    0: Hot: hi:  186, btch:  31 usd:  19   Cold: hi:   62, btch:  15 usd:   0
2007-07-15 10:12:40.640747500 <4>[245143.816517] CPU    1: Hot: hi:  186, btch:  31 usd: 141   Cold: hi:   62, btch:  15 usd:  10
2007-07-15 10:12:40.640752500 <4>[245143.816520] HighMem per-cpu:
2007-07-15 10:12:40.640753500 <4>[245143.816523] CPU    0: Hot: hi:   42, btch:   7 usd:  19   Cold: hi:   14, btch:   3 usd:   2
2007-07-15 10:12:40.640755500 <4>[245143.816527] CPU    1: Hot: hi:   42, btch:   7 usd:  41   Cold: hi:   14, btch:   3 usd:   1
2007-07-15 10:12:40.640801500 <4>[245143.816532] Active:135613 inactive:63608 dirty:155 writeback:0 unstable:0
2007-07-15 10:12:40.640803500 <4>[245143.816533]  free:3497 slab:20685 mapped:12285 pagetables:2011 bounce:0
2007-07-15 10:12:40.640804500 <4>[245143.816538] DMA free:3980kB min:68kB low:84kB high:100kB active:2960kB inactive:0kB present:16256kB pages_scanned:256 all_unreclaimable? no
2007-07-15 10:12:40.640806500 <4>[245143.816541] lowmem_reserve[]: 0 873 975
2007-07-15 10:12:40.640808500 <4>[245143.816548] Normal free:9772kB min:3744kB low:4680kB high:5616kB active:465640kB inactive:228696kB present:894080kB pages_scanned:32 all_unreclaimable? no
2007-07-15 10:12:40.640822500 <4>[245143.816552] lowmem_reserve[]: 0 0 817
2007-07-15 10:12:40.640870500 <4>[245143.816558] HighMem free:236kB min:128kB low:236kB high:344kB active:73852kB inactive:25736kB present:104648kB pages_scanned:0 all_unreclaimable? no
2007-07-15 10:12:40.640872500 <4>[245143.816561] lowmem_reserve[]: 0 0 0
2007-07-15 10:12:40.640874500 <4>[245143.816565] DMA: 251*4kB 140*8kB 20*16kB 0*32kB 2*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 0*2048kB 0*4096kB = 3980kB
2007-07-15 10:12:40.640875500 <4>[245143.816578] Normal: 907*4kB 313*8kB 21*16kB 2*32kB 5*64kB 7*128kB 0*256kB 0*512kB 0*1024kB 1*2048kB 0*4096kB = 9796kB
2007-07-15 10:12:40.640886500 <4>[245143.816591] HighMem: 8*4kB 13*8kB 2*16kB 0*32kB 1*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 232kB
2007-07-15 10:12:40.640888500 <4>[245143.816605] Swap cache: add 1125622, delete 1090250, find 1139372/1240799, race 0+15
2007-07-15 10:12:40.640890500 <4>[245143.816608] Free swap  = 3397536kB
2007-07-15 10:12:40.640891500 <4>[245143.816610] Total swap = 3911784kB
2007-07-15 10:12:40.640918500 <6>[245143.816612] Free swap:       3397536kB
2007-07-15 10:12:40.640920500 <6>[245143.820364] 255744 pages of RAM
2007-07-15 10:12:40.640945500 <6>[245143.820366] 26368 pages of HIGHMEM
2007-07-15 10:12:40.640978500 <6>[245143.820368] 4035 reserved pages
2007-07-15 10:12:40.640980500 <6>[245143.820370] 74789 pages shared
2007-07-15 10:12:40.640981500 <6>[245143.820372] 35371 pages swap cached
2007-07-15 10:12:40.641014500 <6>[245143.820374] 155 pages dirty
2007-07-15 10:12:40.641016500 <6>[245143.820376] 0 pages writeback
2007-07-15 10:12:40.641017500 <6>[245143.820378] 12285 pages mapped
2007-07-15 10:12:40.641019500 <6>[245143.820380] 20685 pages slab
2007-07-15 10:12:40.641020500 <6>[245143.820381] 2011 pages pagetables


-- 
Do what you love because life is too short for anything else.


--benwmrrnutdfs7k5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="vmstat-20070715T074733Z.txt"

nr_free_pages 190000
nr_inactive 2028
nr_active 21203
nr_anon_pages 16499
nr_mapped 3889
nr_file_pages 22921
nr_dirty 13
nr_writeback 0
nr_slab_reclaimable 1972
nr_slab_unreclaimable 7261
nr_page_table_pages 1967
nr_unstable 0
nr_bounce 0
nr_vmscan_write 958619
pgpgin 67510827
pgpgout 74869527
pswpin 1215297
pswpout 949615
pgalloc_dma 3291769
pgalloc_normal 243652482
pgalloc_high 25351727
pgfree 272486155
pgactivate 7179040
pgdeactivate 8228589
pgfault 485606000
pgmajfault 307312
pgrefill_dma 847037
pgrefill_normal 38935434
pgrefill_high 16927321
pgsteal_dma 506292
pgsteal_normal 24484792
pgsteal_high 4252144
pgscan_kswapd_dma 695428
pgscan_kswapd_normal 27634410
pgscan_kswapd_high 10487360
pgscan_direct_dma 8387
pgscan_direct_normal 399264
pgscan_direct_high 64736
pginodesteal 0
slabs_scanned 2819712
kswapd_steal 29058160
kswapd_inodesteal 664
pageoutrun 470778
allocstall 2518
pgrotated 896664

--benwmrrnutdfs7k5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="vmstat-20070715T074806Z.txt"

nr_free_pages 192105
nr_inactive 2874
nr_active 18314
nr_anon_pages 16682
nr_mapped 3633
nr_file_pages 20886
nr_dirty 6
nr_writeback 239
nr_slab_reclaimable 1962
nr_slab_unreclaimable 7258
nr_page_table_pages 1935
nr_unstable 0
nr_bounce 0
nr_vmscan_write 959609
pgpgin 67561599
pgpgout 74875374
pswpin 1220875
pswpout 950560
pgalloc_dma 3291769
pgalloc_normal 243660524
pgalloc_high 25367848
pgfree 272512426
pgactivate 7182825
pgdeactivate 8240868
pgfault 485626514
pgmajfault 308835
pgrefill_dma 847037
pgrefill_normal 38976801
pgrefill_high 17464078
pgsteal_dma 506292
pgsteal_normal 24486162
pgsteal_high 4265632
pgscan_kswapd_dma 695428
pgscan_kswapd_normal 27637893
pgscan_kswapd_high 10504512
pgscan_direct_dma 8387
pgscan_direct_normal 399264
pgscan_direct_high 64736
pginodesteal 0
slabs_scanned 2820736
kswapd_steal 29073018
kswapd_inodesteal 664
pageoutrun 471021
allocstall 2518
pgrotated 897414

--benwmrrnutdfs7k5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="slabinfo-20070715T073220Z.txt"

slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
xt_hashlimit         225    472     64   59    1 : tunables  120   60    8 : slabdata      8      8      0
nf_conntrack_expect      0      0    136   29    1 : tunables  120   60    8 : slabdata      0      0      0
nf_conntrack:basic    487   1620    212   18    1 : tunables  120   60    8 : slabdata     90     90      0
dccp_ackvec_record      0      0     32  113    1 : tunables  120   60    8 : slabdata      0      0      0
dccp_ackvec            0      0    640    6    1 : tunables   54   27    8 : slabdata      0      0      0
dccp_bind_bucket       0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
ip_fib_alias           9    113     32  113    1 : tunables  120   60    8 : slabdata      1      1      0
ip_fib_hash            9    113     32  113    1 : tunables  120   60    8 : slabdata      1      1      0
dm_tio                 0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
dm_io                  0      0     20  169    1 : tunables  120   60    8 : slabdata      0      0      0
uhci_urb_priv          4    127     28  127    1 : tunables  120   60    8 : slabdata      1      1      0
avtab_node         78730  78764     16  203    1 : tunables  120   60    8 : slabdata    388    388      0
fib6_nodes            24    113     32  113    1 : tunables  120   60    8 : slabdata      1      1      0
ip6_dst_cache         18     30    256   15    1 : tunables  120   60    8 : slabdata      2      2      0
ndisc_cache            3     30    256   15    1 : tunables  120   60    8 : slabdata      2      2      0
RAWv6                  5      6    640    6    1 : tunables   54   27    8 : slabdata      1      1      0
UDPLITEv6              0      0    640    6    1 : tunables   54   27    8 : slabdata      0      0      0
UDPv6                  7     12    640    6    1 : tunables   54   27    8 : slabdata      2      2      0
tw_sock_TCPv6          0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
request_sock_TCPv6      0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
TCPv6                 23     30   1280    3    1 : tunables   24   12    8 : slabdata     10     10      0
UNIX                 116    140    512    7    1 : tunables   54   27    8 : slabdata     20     20      0
flow_cache             0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
scsi_cmd_cache        60     90    384   10    1 : tunables   54   27    8 : slabdata      9      9     13
aic94xx_ascb           0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
aic94xx_dma_token      0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
sas_task               0      0    384   10    1 : tunables   54   27    8 : slabdata      0      0      0
cfq_io_context       297    396     88   44    1 : tunables  120   60    8 : slabdata      9      9      0
cfq_queue            417    504     92   42    1 : tunables  120   60    8 : slabdata     12     12      0
mqueue_inode_cache      1      6    640    6    1 : tunables   54   27    8 : slabdata      1      1      0
xfs_chashlist        892   5655     24  145    1 : tunables  120   60    8 : slabdata     39     39      0
xfs_ili              328   2520    140   28    1 : tunables  120   60    8 : slabdata     90     90      0
xfs_inode           2045   4790    384   10    1 : tunables   54   27    8 : slabdata    479    479      0
xfs_efi_item           0      0    260   15    1 : tunables   54   27    8 : slabdata      0      0      0
xfs_efd_item           0      0    260   15    1 : tunables   54   27    8 : slabdata      0      0      0
xfs_buf_item          42     52    148   26    1 : tunables  120   60    8 : slabdata      2      2      0
xfs_acl               41     65    304   13    1 : tunables   54   27    8 : slabdata      5      5      0
xfs_ifork           2048  12864     56   67    1 : tunables  120   60    8 : slabdata    192    192      0
xfs_dabuf             46    203     16  203    1 : tunables  120   60    8 : slabdata      1      1      0
xfs_da_state          11     11    336   11    1 : tunables   54   27    8 : slabdata      1      1      0
xfs_trans             24     24    632    6    1 : tunables   54   27    8 : slabdata      4      4      0
xfs_btree_cur         24     28    140   28    1 : tunables  120   60    8 : slabdata      1      1      0
xfs_bmap_free_item      0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
xfs_buf              240    240    256   15    1 : tunables  120   60    8 : slabdata     16     16      0
xfs_ioend             39    134     56   67    1 : tunables  120   60    8 : slabdata      2      2      0
xfs_vnode           2046   4144    512    7    1 : tunables   54   27    8 : slabdata    592    592      0
isofs_inode_cache      0      0    388   10    1 : tunables   54   27    8 : slabdata      0      0      0
hugetlbfs_inode_cache      1     11    360   11    1 : tunables   54   27    8 : slabdata      1      1      0
ext2_inode_cache       0      0    496    8    1 : tunables   54   27    8 : slabdata      0      0      0
ext2_xattr             0      0     48   78    1 : tunables  120   60    8 : slabdata      0      0      0
journal_handle         0      0     20  169    1 : tunables  120   60    8 : slabdata      0      0      0
journal_head           0      0     52   72    1 : tunables  120   60    8 : slabdata      0      0      0
revoke_table           0      0     12  254    1 : tunables  120   60    8 : slabdata      0      0      0
revoke_record          0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
ext3_inode_cache       0      0    524    7    1 : tunables   54   27    8 : slabdata      0      0      0
ext3_xattr             0      0     48   78    1 : tunables  120   60    8 : slabdata      0      0      0
reiser_inode_cache      0      0    468    8    1 : tunables   54   27    8 : slabdata      0      0      0
dnotify_cache          1    169     20  169    1 : tunables  120   60    8 : slabdata      1      1      0
dquot                  0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_event_cache      0      0     28  127    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_watch_cache     12     92     40   92    1 : tunables  120   60    8 : slabdata      1      1      0
kioctx                 0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
kiocb                  0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
fasync_cache           4    203     16  203    1 : tunables  120   60    8 : slabdata      1      1      0
shmem_inode_cache   1116   1136    464    8    1 : tunables   54   27    8 : slabdata    142    142      0
posix_timers_cache      0      0    104   37    1 : tunables  120   60    8 : slabdata      0      0      0
uid_cache             35    118     64   59    1 : tunables  120   60    8 : slabdata      2      2      0
ip_mrt_cache           0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
UDP-Lite               0      0    512    7    1 : tunables   54   27    8 : slabdata      0      0      0
tcp_bind_bucket      113    406     16  203    1 : tunables  120   60    8 : slabdata      2      2      0
inet_peer_cache      394   5310     64   59    1 : tunables  120   60    8 : slabdata     90     90      0
secpath_cache          0      0     32  113    1 : tunables  120   60    8 : slabdata      0      0      0
xfrm_dst_cache         0      0    384   10    1 : tunables   54   27    8 : slabdata      0      0      0
ip_dst_cache         642   1950    256   15    1 : tunables  120   60    8 : slabdata    130    130     72
arp_cache              2     15    256   15    1 : tunables  120   60    8 : slabdata      1      1      0
RAW                    3      7    512    7    1 : tunables   54   27    8 : slabdata      1      1      0
UDP                   12     28    512    7    1 : tunables   54   27    8 : slabdata      4      4      0
tw_sock_TCP            0     15    256   15    1 : tunables  120   60    8 : slabdata      0      1      0
request_sock_TCP       4     30    128   30    1 : tunables  120   60    8 : slabdata      1      1      0
TCP                  145    217   1152    7    2 : tunables   24   12    8 : slabdata     31     31      0
eventpoll_pwq        166   1010     36  101    1 : tunables  120   60    8 : slabdata     10     10      0
eventpoll_epi        166    480    128   30    1 : tunables  120   60    8 : slabdata     16     16      0
sgpool-128             2      3   2560    3    2 : tunables   24   12    8 : slabdata      1      1      0
sgpool-64              2      3   1280    3    1 : tunables   24   12    8 : slabdata      1      1      0
sgpool-32             10     18    640    6    1 : tunables   54   27    8 : slabdata      3      3      0
sgpool-16             10     20    384   10    1 : tunables   54   27    8 : slabdata      2      2      0
sgpool-8             120    150    256   15    1 : tunables  120   60    8 : slabdata     10     10     30
scsi_io_context        0      0    104   37    1 : tunables  120   60    8 : slabdata      0      0      0
blkdev_ioc           302    452     32  113    1 : tunables  120   60    8 : slabdata      4      4      0
blkdev_queue          28     28    952    4    1 : tunables   54   27    8 : slabdata      7      7      0
blkdev_requests      169    252    184   21    1 : tunables  120   60    8 : slabdata     12     12     60
biovec-256             2      2   3072    2    2 : tunables   24   12    8 : slabdata      1      1      0
biovec-128             8     10   1536    5    2 : tunables   24   12    8 : slabdata      2      2      0
biovec-64             19     20    768    5    1 : tunables   54   27    8 : slabdata      4      4      0
biovec-16             90     90    256   15    1 : tunables  120   60    8 : slabdata      6      6      0
biovec-4             118    118     64   59    1 : tunables  120   60    8 : slabdata      2      2      0
biovec-1             918   4060     16  203    1 : tunables  120   60    8 : slabdata     20     20      7
bio                  915   1740    128   30    1 : tunables  120   60    8 : slabdata     58     58      0
sock_inode_cache     324    525    512    7    1 : tunables   54   27    8 : slabdata     75     75      0
skbuff_fclone_cache    133    350    384   10    1 : tunables   54   27    8 : slabdata     35     35     53
skbuff_head_cache   1000   1485    256   15    1 : tunables  120   60    8 : slabdata     99     99      0
file_lock_cache       95    160     96   40    1 : tunables  120   60    8 : slabdata      4      4      0
Acpi-Operand         759    920     40   92    1 : tunables  120   60    8 : slabdata     10     10      0
Acpi-ParseExt          0      0     44   84    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Parse             0      0     28  127    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-State             0      0     44   84    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Namespace       591    676     20  169    1 : tunables  120   60    8 : slabdata      4      4      0
proc_inode_cache     850    850    376   10    1 : tunables   54   27    8 : slabdata     85     85      0
sigqueue              27     27    144   27    1 : tunables  120   60    8 : slabdata      1      1      0
radix_tree_node     2223   2223    288   13    1 : tunables   54   27    8 : slabdata    171    171      0
bdev_cache            50     56    512    7    1 : tunables   54   27    8 : slabdata      8      8      0
sysfs_dir_cache     7404   7410     48   78    1 : tunables  120   60    8 : slabdata     95     95      0
mnt_cache            265    330    128   30    1 : tunables  120   60    8 : slabdata     11     11      0
inode_cache         1947   2167    360   11    1 : tunables   54   27    8 : slabdata    197    197      0
dentry              6007  19140    132   29    1 : tunables  120   60    8 : slabdata    660    660      0
filp                3862   4280    192   20    1 : tunables  120   60    8 : slabdata    214    214    300
names_cache           28     28   4096    1    1 : tunables   24   12    8 : slabdata     28     28      0
avc_node             572    648     52   72    1 : tunables  120   60    8 : slabdata      9      9      0
selinux_inode_security   6390  28944     56   67    1 : tunables  120   60    8 : slabdata    432    432      0
idr_layer_cache      175    203    136   29    1 : tunables  120   60    8 : slabdata      7      7      0
buffer_head           36    402     56   67    1 : tunables  120   60    8 : slabdata      6      6      0
mm_struct            213    297    448    9    1 : tunables   54   27    8 : slabdata     33     33      0
vm_area_struct      6440   7700     88   44    1 : tunables  120   60    8 : slabdata    175    175     60
fs_cache             268    413     64   59    1 : tunables  120   60    8 : slabdata      7      7      0
files_cache          237    300    384   10    1 : tunables   54   27    8 : slabdata     30     30      0
signal_cache         299    342    448    9    1 : tunables   54   27    8 : slabdata     38     38      0
sighand_cache        282    294   1344    3    1 : tunables   24   12    8 : slabdata     98     98      0
task_struct          458    490   1424    5    2 : tunables   24   12    8 : slabdata     98     98      0
anon_vma            2864   3810     12  254    1 : tunables  120   60    8 : slabdata     15     15      0
pmd                  641    646   4096    1    1 : tunables   24   12    8 : slabdata    641    646      0
pid                  525    707     36  101    1 : tunables  120   60    8 : slabdata      7      7      0
size-4194304(DMA)      0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-4194304           0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-2097152(DMA)      0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-2097152           0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-1048576(DMA)      0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-1048576           1      1 1048576    1  256 : tunables    1    1    0 : slabdata      1      1      0
size-524288(DMA)       0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-524288            0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-262144(DMA)       0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-262144            0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-131072            3      3 131072    1   32 : tunables    8    4    0 : slabdata      3      3      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-65536             5      5  65536    1   16 : tunables    8    4    0 : slabdata      5      5      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-32768            74     74  32768    1    8 : tunables    8    4    0 : slabdata     74     74      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-16384            36     40  16384    1    4 : tunables    8    4    0 : slabdata     36     40      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
size-8192             35     40   8192    1    2 : tunables    8    4    0 : slabdata     35     40      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    8 : slabdata      0      0      0
size-4096            615    640   4096    1    1 : tunables   24   12    8 : slabdata    615    640     56
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    8 : slabdata      0      0      0
size-2048            274    292   2048    2    1 : tunables   24   12    8 : slabdata    146    146      0
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
size-1024            825    920   1024    4    1 : tunables   54   27    8 : slabdata    230    230     27
size-512(DMA)          0      0    512    8    1 : tunables   54   27    8 : slabdata      0      0      0
size-512            1554   1680    512    8    1 : tunables   54   27    8 : slabdata    210    210      0
size-256(DMA)          0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
size-256             525    615    256   15    1 : tunables  120   60    8 : slabdata     41     41      0
size-128(DMA)          0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
size-128            1726   3150    128   30    1 : tunables  120   60    8 : slabdata    105    105      0
size-64(DMA)           0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
size-32(DMA)           0      0     32  113    1 : tunables  120   60    8 : slabdata      0      0      0
size-64             2932  11564     64   59    1 : tunables  120   60    8 : slabdata    196    196      0
size-32            57164  60568     32  113    1 : tunables  120   60    8 : slabdata    536    536     67
kmem_cache           167    180    128   30    1 : tunables  120   60    8 : slabdata      6      6      0

--benwmrrnutdfs7k5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="slabinfo-20070715T075017Z.txt"

slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
xt_hashlimit         267    649     64   59    1 : tunables  120   60    8 : slabdata     11     11      0
nf_conntrack_expect      0      0    136   29    1 : tunables  120   60    8 : slabdata      0      0      0
nf_conntrack:basic    480   1584    212   18    1 : tunables  120   60    8 : slabdata     88     88      0
dccp_ackvec_record      0      0     32  113    1 : tunables  120   60    8 : slabdata      0      0      0
dccp_ackvec            0      0    640    6    1 : tunables   54   27    8 : slabdata      0      0      0
dccp_bind_bucket       0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
ip_fib_alias           9    113     32  113    1 : tunables  120   60    8 : slabdata      1      1      0
ip_fib_hash            9    113     32  113    1 : tunables  120   60    8 : slabdata      1      1      0
dm_tio                 0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
dm_io                  0      0     20  169    1 : tunables  120   60    8 : slabdata      0      0      0
uhci_urb_priv          4    127     28  127    1 : tunables  120   60    8 : slabdata      1      1      0
avtab_node         78730  78764     16  203    1 : tunables  120   60    8 : slabdata    388    388      0
fib6_nodes            24    113     32  113    1 : tunables  120   60    8 : slabdata      1      1      0
ip6_dst_cache         18     30    256   15    1 : tunables  120   60    8 : slabdata      2      2      0
ndisc_cache            3     30    256   15    1 : tunables  120   60    8 : slabdata      2      2      0
RAWv6                  5      6    640    6    1 : tunables   54   27    8 : slabdata      1      1      0
UDPLITEv6              0      0    640    6    1 : tunables   54   27    8 : slabdata      0      0      0
UDPv6                  7     12    640    6    1 : tunables   54   27    8 : slabdata      2      2      0
tw_sock_TCPv6          0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
request_sock_TCPv6      0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
TCPv6                 18     27   1280    3    1 : tunables   24   12    8 : slabdata      9      9      0
UNIX                 124    140    512    7    1 : tunables   54   27    8 : slabdata     20     20      0
flow_cache             0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
scsi_cmd_cache        76     90    384   10    1 : tunables   54   27    8 : slabdata      9      9      0
aic94xx_ascb           0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
aic94xx_dma_token      0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
sas_task               0      0    384   10    1 : tunables   54   27    8 : slabdata      0      0      0
cfq_io_context       396    396     88   44    1 : tunables  120   60    8 : slabdata      9      9      0
cfq_queue            545    546     92   42    1 : tunables  120   60    8 : slabdata     13     13      0
mqueue_inode_cache      1      6    640    6    1 : tunables   54   27    8 : slabdata      1      1      0
xfs_chashlist        851   5075     24  145    1 : tunables  120   60    8 : slabdata     35     35      0
xfs_ili              382   2520    140   28    1 : tunables  120   60    8 : slabdata     90     90      0
xfs_inode           1609   4510    384   10    1 : tunables   54   27    8 : slabdata    451    451     10
xfs_efi_item          16     30    260   15    1 : tunables   54   27    8 : slabdata      2      2      0
xfs_efd_item          16     30    260   15    1 : tunables   54   27    8 : slabdata      2      2      0
xfs_buf_item          93    104    148   26    1 : tunables  120   60    8 : slabdata      4      4      0
xfs_acl               65     65    304   13    1 : tunables   54   27    8 : slabdata      5      5      0
xfs_ifork           1649  11792     56   67    1 : tunables  120   60    8 : slabdata    176    176     30
xfs_dabuf             41    203     16  203    1 : tunables  120   60    8 : slabdata      1      1      0
xfs_da_state          19     22    336   11    1 : tunables   54   27    8 : slabdata      2      2      0
xfs_trans             39     48    632    6    1 : tunables   54   27    8 : slabdata      8      8      0
xfs_btree_cur         28     28    140   28    1 : tunables  120   60    8 : slabdata      1      1      0
xfs_bmap_free_item     11    203     16  203    1 : tunables  120   60    8 : slabdata      1      1      0
xfs_buf              210    240    256   15    1 : tunables  120   60    8 : slabdata     16     16      0
xfs_ioend             36     67     56   67    1 : tunables  120   60    8 : slabdata      1      1      0
xfs_vnode           1613   3885    512    7    1 : tunables   54   27    8 : slabdata    555    555     10
isofs_inode_cache      0      0    388   10    1 : tunables   54   27    8 : slabdata      0      0      0
hugetlbfs_inode_cache      1     11    360   11    1 : tunables   54   27    8 : slabdata      1      1      0
ext2_inode_cache       0      0    496    8    1 : tunables   54   27    8 : slabdata      0      0      0
ext2_xattr             0      0     48   78    1 : tunables  120   60    8 : slabdata      0      0      0
journal_handle         0      0     20  169    1 : tunables  120   60    8 : slabdata      0      0      0
journal_head           0      0     52   72    1 : tunables  120   60    8 : slabdata      0      0      0
revoke_table           0      0     12  254    1 : tunables  120   60    8 : slabdata      0      0      0
revoke_record          0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
ext3_inode_cache       0      0    524    7    1 : tunables   54   27    8 : slabdata      0      0      0
ext3_xattr             0      0     48   78    1 : tunables  120   60    8 : slabdata      0      0      0
reiser_inode_cache      0      0    468    8    1 : tunables   54   27    8 : slabdata      0      0      0
dnotify_cache          1    169     20  169    1 : tunables  120   60    8 : slabdata      1      1      0
dquot                  0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_event_cache      0      0     28  127    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_watch_cache     12     92     40   92    1 : tunables  120   60    8 : slabdata      1      1      0
kioctx                 0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
kiocb                  0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
fasync_cache           4    203     16  203    1 : tunables  120   60    8 : slabdata      1      1      0
shmem_inode_cache   1116   1136    464    8    1 : tunables   54   27    8 : slabdata    142    142      0
posix_timers_cache      0      0    104   37    1 : tunables  120   60    8 : slabdata      0      0      0
uid_cache             35    118     64   59    1 : tunables  120   60    8 : slabdata      2      2      0
ip_mrt_cache           0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
UDP-Lite               0      0    512    7    1 : tunables   54   27    8 : slabdata      0      0      0
tcp_bind_bucket      121    406     16  203    1 : tunables  120   60    8 : slabdata      2      2      0
inet_peer_cache     1522   4661     64   59    1 : tunables  120   60    8 : slabdata     79     79      0
secpath_cache          0      0     32  113    1 : tunables  120   60    8 : slabdata      0      0      0
xfrm_dst_cache         0      0    384   10    1 : tunables   54   27    8 : slabdata      0      0      0
ip_dst_cache        2070   2070    256   15    1 : tunables  120   60    8 : slabdata    138    138      0
arp_cache              2     15    256   15    1 : tunables  120   60    8 : slabdata      1      1      0
RAW                    3      7    512    7    1 : tunables   54   27    8 : slabdata      1      1      0
UDP                   12     28    512    7    1 : tunables   54   27    8 : slabdata      4      4      0
tw_sock_TCP            7     15    256   15    1 : tunables  120   60    8 : slabdata      1      1      0
request_sock_TCP       4     30    128   30    1 : tunables  120   60    8 : slabdata      1      1      0
TCP                  159    217   1152    7    2 : tunables   24   12    8 : slabdata     31     31      0
eventpoll_pwq        195   1010     36  101    1 : tunables  120   60    8 : slabdata     10     10      0
eventpoll_epi        195    480    128   30    1 : tunables  120   60    8 : slabdata     16     16      0
sgpool-128             2      3   2560    3    2 : tunables   24   12    8 : slabdata      1      1      0
sgpool-64              2      3   1280    3    1 : tunables   24   12    8 : slabdata      1      1      0
sgpool-32             30     30    640    6    1 : tunables   54   27    8 : slabdata      5      5      0
sgpool-16             50     50    384   10    1 : tunables   54   27    8 : slabdata      5      5      0
sgpool-8             135    165    256   15    1 : tunables  120   60    8 : slabdata     11     11      0
scsi_io_context        0      0    104   37    1 : tunables  120   60    8 : slabdata      0      0      0
blkdev_ioc           430    452     32  113    1 : tunables  120   60    8 : slabdata      4      4      0
blkdev_queue          28     28    952    4    1 : tunables   54   27    8 : slabdata      7      7      0
blkdev_requests      172    252    184   21    1 : tunables  120   60    8 : slabdata     12     12      0
biovec-256             2      2   3072    2    2 : tunables   24   12    8 : slabdata      1      1      0
biovec-128            15     15   1536    5    2 : tunables   24   12    8 : slabdata      3      3      0
biovec-64             51     65    768    5    1 : tunables   54   27    8 : slabdata     13     13      0
biovec-16            105    135    256   15    1 : tunables  120   60    8 : slabdata      9      9      0
biovec-4             124    177     64   59    1 : tunables  120   60    8 : slabdata      3      3      7
biovec-1             913   3248     16  203    1 : tunables  120   60    8 : slabdata     16     16     60
bio                  919   1470    128   30    1 : tunables  120   60    8 : slabdata     49     49     60
sock_inode_cache     353    518    512    7    1 : tunables   54   27    8 : slabdata     74     74      0
skbuff_fclone_cache    115    140    384   10    1 : tunables   54   27    8 : slabdata     14     14     40
skbuff_head_cache    606   1080    256   15    1 : tunables  120   60    8 : slabdata     72     72     12
file_lock_cache       94    120     96   40    1 : tunables  120   60    8 : slabdata      3      3      0
Acpi-Operand         759    920     40   92    1 : tunables  120   60    8 : slabdata     10     10      0
Acpi-ParseExt          0      0     44   84    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Parse             0      0     28  127    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-State             0      0     44   84    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Namespace       591    676     20  169    1 : tunables  120   60    8 : slabdata      4      4      0
proc_inode_cache     359    370    376   10    1 : tunables   54   27    8 : slabdata     37     37      0
sigqueue              54     54    144   27    1 : tunables  120   60    8 : slabdata      2      2      0
radix_tree_node     2054   2054    288   13    1 : tunables   54   27    8 : slabdata    158    158      0
bdev_cache            50     56    512    7    1 : tunables   54   27    8 : slabdata      8      8      0
sysfs_dir_cache     7404   7410     48   78    1 : tunables  120   60    8 : slabdata     95     95      0
mnt_cache            265    330    128   30    1 : tunables  120   60    8 : slabdata     11     11      0
inode_cache         1950   2167    360   11    1 : tunables   54   27    8 : slabdata    197    197      0
dentry              5244  18502    132   29    1 : tunables  120   60    8 : slabdata    638    638     30
filp                3425   4280    192   20    1 : tunables  120   60    8 : slabdata    214    214      0
names_cache           22     22   4096    1    1 : tunables   24   12    8 : slabdata     22     22      0
avc_node             507    648     52   72    1 : tunables  120   60    8 : slabdata      9      9      0
selinux_inode_security   5418  27537     56   67    1 : tunables  120   60    8 : slabdata    411    411      0
idr_layer_cache      175    203    136   29    1 : tunables  120   60    8 : slabdata      7      7      0
buffer_head          133    134     56   67    1 : tunables  120   60    8 : slabdata      2      2      0
mm_struct            252    297    448    9    1 : tunables   54   27    8 : slabdata     33     33      0
vm_area_struct      6482   7700     88   44    1 : tunables  120   60    8 : slabdata    175    175     60
fs_cache             265    413     64   59    1 : tunables  120   60    8 : slabdata      7      7      0
files_cache          232    300    384   10    1 : tunables   54   27    8 : slabdata     30     30      0
signal_cache         274    342    448    9    1 : tunables   54   27    8 : slabdata     38     38      0
sighand_cache        283    294   1344    3    1 : tunables   24   12    8 : slabdata     98     98      0
task_struct          487    505   1424    5    2 : tunables   24   12    8 : slabdata    101    101      0
anon_vma            2862   3810     12  254    1 : tunables  120   60    8 : slabdata     15     15      0
pmd                  651    651   4096    1    1 : tunables   24   12    8 : slabdata    651    651      0
pid                  545    707     36  101    1 : tunables  120   60    8 : slabdata      7      7      0
size-4194304(DMA)      0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-4194304           0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-2097152(DMA)      0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-2097152           0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-1048576(DMA)      0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-1048576           1      1 1048576    1  256 : tunables    1    1    0 : slabdata      1      1      0
size-524288(DMA)       0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-524288            0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-262144(DMA)       0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-262144            0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-131072            3      3 131072    1   32 : tunables    8    4    0 : slabdata      3      3      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-65536             5      5  65536    1   16 : tunables    8    4    0 : slabdata      5      5      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-32768            74     74  32768    1    8 : tunables    8    4    0 : slabdata     74     74      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-16384            28     32  16384    1    4 : tunables    8    4    0 : slabdata     28     32      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
size-8192             19     20   8192    1    2 : tunables    8    4    0 : slabdata     19     20      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    8 : slabdata      0      0      0
size-4096            623    623   4096    1    1 : tunables   24   12    8 : slabdata    623    623     60
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    8 : slabdata      0      0      0
size-2048            284    292   2048    2    1 : tunables   24   12    8 : slabdata    146    146     12
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
size-1024            858    916   1024    4    1 : tunables   54   27    8 : slabdata    229    229     27
size-512(DMA)          0      0    512    8    1 : tunables   54   27    8 : slabdata      0      0      0
size-512            1184   1272    512    8    1 : tunables   54   27    8 : slabdata    159    159     47
size-256(DMA)          0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
size-256             606    615    256   15    1 : tunables  120   60    8 : slabdata     41     41      0
size-128(DMA)          0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
size-128            1763   3120    128   30    1 : tunables  120   60    8 : slabdata    104    104      0
size-64(DMA)           0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
size-32(DMA)           0      0     32  113    1 : tunables  120   60    8 : slabdata      0      0      0
size-64             3069  10856     64   59    1 : tunables  120   60    8 : slabdata    184    184      0
size-32            57028  60568     32  113    1 : tunables  120   60    8 : slabdata    536    536      0
kmem_cache           167    180    128   30    1 : tunables  120   60    8 : slabdata      6      6      0

--benwmrrnutdfs7k5--
