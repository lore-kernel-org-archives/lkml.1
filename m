Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbXJXT3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbXJXT3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 15:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbXJXT3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 15:29:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:33914 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbXJXT3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 15:29:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=h+k37VuKWrwfWR40ldE9i0C/SbB8slcA+6ZeUsgqKRQ+WsufM0cblyRAyGMFFyHe2CjwpOGn5pRZ5e13U45daWKWay9dlDDSzRBSVywczZRT51riOvfPersva1bOYDQEjTcAxidedbkaaWDZKEtqQqfUnfxoc2mkpXwjE2YBHSg=
Date: Wed, 24 Oct 2007 23:28:49 +0400
To: Mel Gorman <mel@skynet.ie>
Cc: Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
Subject: Re: SLUB 0:1 SLAB (OOM during massive parallel kernel builds)
Message-ID: <20071024192849.GA3206@martell.zuzino.mipt.ru>
References: <20071023181615.GA10377@martell.zuzino.mipt.ru> <Pine.LNX.4.64.0710231227590.19626@schroedinger.engr.sgi.com> <471E5021.8090300@cs.helsinki.fi> <Pine.LNX.4.64.0710231250130.19904@schroedinger.engr.sgi.com> <20071024080937.GA10785@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024080937.GA10785@skynet.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 09:09:38AM +0100, Mel Gorman wrote:
> On (23/10/07 12:57), Christoph Lameter didst pronounce:
> > On Tue, 23 Oct 2007, Pekka Enberg wrote:
> > 
> > > > > cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=0
> > > 
> > > Christoph Lameter wrote:
> > > > Regular Order 0 alloc .... but why is there no memory available , reclaimed?

Thanks, guys for suggestions.

I redid workload with slub_debug=F and collected /proc/meminfo, slabinfo
-S and /proc/pagetyinfo. It OOMed. Here are first few messages from OOM
killer and few last messages from proc files. During run collecting
script managed to wakeup once in 1-3 minutes. There are 12 minutes between
last and second-to-last messages which is I assume when X happened.
If needed, I can send complete writeout.

I'm going to add more swap now and make timings.




[   36.146064] Adding 987956k swap on /dev/sda1.  Priority:-1 extents:1 across:987956k
[12728.699150] cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=-17
[12728.699299] 
[12728.699299] Call Trace:
[12728.699422]  [<ffffffff8024d176>] oom_kill_process+0xf6/0x110
[12728.699505]  [<ffffffff8024d62d>] out_of_memory+0x1ad/0x1f0
[12728.699587]  [<ffffffff8024f92e>] __alloc_pages+0x28e/0x3a0
[12728.699669]  [<ffffffff80251a61>] __do_page_cache_readahead+0x101/0x270
[12728.699757]  [<ffffffff8024c5ca>] filemap_fault+0x28a/0x3c0
[12728.699839]  [<ffffffff802575bc>] __do_fault+0x6c/0x430
[12728.699920]  [<ffffffff8025946b>] handle_mm_fault+0x3bb/0x700
[12728.700004]  [<ffffffff8021c1ff>] do_page_fault+0x1bf/0x830
[12728.700086]  [<ffffffff8025e94c>] do_mmap_pgoff+0x2fc/0x360
[12728.700168]  [<ffffffff8025d426>] do_munmap+0x296/0x2f0
[12728.700249]  [<ffffffff802e2d11>] __up_write+0x21/0x130
[12728.700331]  [<ffffffff803d3c99>] error_exit+0x0/0x51
[12728.700409] 
[12728.700465] Mem-info:
[12728.700526] DMA per-cpu:
[12728.700589] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[12728.700732] CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[12728.700874] DMA32 per-cpu:
[12728.700938] CPU    0: Hot: hi:  186, btch:  31 usd:  94   Cold: hi:   62, btch:  15 usd:  30
[12728.701081] CPU    1: Hot: hi:  186, btch:  31 usd: 115   Cold: hi:   62, btch:  15 usd:  57
[12728.701224] Active:433892 inactive:22010 dirty:0 writeback:0 unstable:0
[12728.701225]  free:3433 slab:10898 mapped:9 pagetables:14315 bounce:0
[12728.701398] DMA free:8032kB min:32kB low:40kB high:48kB active:2716kB inactive:2208kB present:12744kB pages_scanned:9299 all_unreclaimable? yes
[12728.701567] lowmem_reserve[]: 0 2003 2003 2003
[12728.701654] DMA32 free:5700kB min:5708kB low:7132kB high:8560kB active:1732852kB inactive:85720kB present:2051880kB pages_scanned:18914517 all_unreclaimable? yes
[12728.701877] lowmem_reserve[]: 0 0 0 0
[12728.701961] DMA: 8*4kB 2*8kB 11*16kB 12*32kB 12*64kB 12*128kB 4*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8032kB
[12728.702139] DMA32: 49*4kB 14*8kB 9*16kB 2*32kB 1*64kB 2*128kB 1*256kB 1*512kB 0*1024kB 0*2048kB 1*4096kB = 5700kB
[12728.702319] Swap cache: add 5538322, delete 5538322, find 910933/1354692, race 80+107
[12728.702458] Free swap  = 0kB
[12728.702522] Total swap = 987956kB
[12728.702590] Free swap:            0kB
[12728.709794] 524176 pages of RAM
[12728.709866] 8772 reserved pages
[12728.709931] 8761 pages shared
[12728.709996] 0 pages swap cached
[12728.710063] Out of memory: kill process 2951 (sshd) score 276 or a child
[12728.710380] Killed process 2951 (sshd)
[12735.176084] cc1 invoked oom-killer: gfp_mask=0x1201d2, order=0, oomkilladj=-17
[12735.176230] 
[12735.176230] Call Trace:
[12735.176359]  [<ffffffff8024d176>] oom_kill_process+0xf6/0x110
[12735.176444]  [<ffffffff8024d62d>] out_of_memory+0x1ad/0x1f0
[12735.176526]  [<ffffffff8024f92e>] __alloc_pages+0x28e/0x3a0
[12735.176608]  [<ffffffff80251a61>] __do_page_cache_readahead+0x101/0x270
[12735.176697]  [<ffffffff8024c5ca>] filemap_fault+0x28a/0x3c0
[12735.176779]  [<ffffffff802575bc>] __do_fault+0x6c/0x430
[12735.176862]  [<ffffffff8025946b>] handle_mm_fault+0x3bb/0x700
[12735.176946]  [<ffffffff8021c1ff>] do_page_fault+0x1bf/0x830
[12735.177027]  [<ffffffff8021e6bd>] __dequeue_entity+0x3d/0x50
[12735.177113]  [<ffffffff803d1b90>] thread_return+0x3d/0x54d
[12735.177194]  [<ffffffff8025e94c>] do_mmap_pgoff+0x2fc/0x360
[12735.177278]  [<ffffffff8025d426>] do_munmap+0x296/0x2f0
[12735.177358]  [<ffffffff803d3c99>] error_exit+0x0/0x51
[12735.177436] 
[12735.177493] Mem-info:
[12735.177555] DMA per-cpu:
[12735.177617] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[12735.177763] CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
[12735.177918] DMA32 per-cpu:
[12735.177983] CPU    0: Hot: hi:  186, btch:  31 usd:  94   Cold: hi:   62, btch:  15 usd:  45
[12735.178128] CPU    1: Hot: hi:  186, btch:  31 usd: 133   Cold: hi:   62, btch:  15 usd:  47
[12735.178271] Active:129449 inactive:326076 dirty:0 writeback:0 unstable:0
[12735.178272]  free:3433 slab:10896 mapped:10 pagetables:14304 bounce:0
[12735.178446] DMA free:8032kB min:32kB low:40kB high:48kB active:2588kB inactive:2336kB present:12744kB pages_scanned:9363 all_unreclaimable? yes
[12735.178618] lowmem_reserve[]: 0 2003 2003 2003
[12735.178706] DMA32 free:5700kB min:5708kB low:7132kB high:8560kB active:512264kB inactive:1304912kB present:2051880kB pages_scanned:3251584 all_unreclaimable? yes
[12735.178933] lowmem_reserve[]: 0 0 0 0
[12735.179014] DMA: 8*4kB 2*8kB 11*16kB 12*32kB 12*64kB 12*128kB 4*256kB 0*512kB 0*1024kB 0*2048kB 1*4096kB = 8032kB
[12735.179195] DMA32: 33*4kB 22*8kB 9*16kB 2*32kB 1*64kB 2*128kB 1*256kB 1*512kB 0*1024kB 0*2048kB 1*4096kB = 5700kB
[12735.179382] Swap cache: add 5538428, delete 5538396, find 910933/1354692, race 80+107
[12735.179530] Free swap  = 0kB
[12735.179594] Total swap = 987956kB
[12735.179661] Free swap:            0kB
[12735.186929] 524176 pages of RAM
[12735.186999] 8772 reserved pages
[12735.187069] 8986 pages shared
[12735.187134] 32 pages swap cached
[12735.187201] Out of memory: kill process 3007 (cron) score 272 or a child
[12735.187524] Killed process 5528 (cron)



---------------------------------------------------------
Wed Oct 24 11:54:31 MSD 2007
MemTotal:      2061616 kB
MemFree:        881376 kB
Buffers:          8092 kB
Cached:         260672 kB
SwapCached:      71364 kB
Active:         768928 kB
Inactive:       216452 kB
SwapTotal:      987956 kB
SwapFree:       260064 kB
Dirty:          101652 kB
Writeback:        1740 kB
AnonPages:      648864 kB
Mapped:          26252 kB
Slab:            67316 kB
SReclaimable:    26600 kB
SUnreclaim:      40716 kB
PageTables:      46800 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   2018764 kB
Committed_AS:  1855552 kB
VmallocTotal: 34359738367 kB
VmallocUsed:       896 kB
VmallocChunk: 34359737107 kB
Name                   Objects Objsize    Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
dentry                   56820     200    11.6M       2841/0/0   20 0   0  97 aF
ext2_inode_cache         13823     624     9.4M       2304/1/0    6 0   0  91 aF
vm_area_struct           38861     168     7.3M     1794/716/0   24 0  39  88 F
sighand_cache             2062    2088     6.2M      764/184/0    3 1  24  68 AF
radix_tree_node           9463     552     5.5M      1357/10/0    7 0   0  93 F
task_struct               2068    1776     4.7M      580/178/0    4 1  30  77 F
buffer_head              43228     104     4.5M       1109/9/0   39 0   0  98 aF
:F-0000768                4082     744     3.7M      917/300/0    5 0  32  80 *AF
:F-0000192               15205     192     3.5M      863/534/0   21 0  61  82 *F
:F-0002048                1578    2048     3.2M        397/9/0    4 1   2  99 *F
:F-0000704                2035     704     1.7M       211/92/0   11 1  43  82 *AF
:F-0000064               15489      64     1.6M      403/191/0   64 0  47  60 *F
:F-0001024                1207    1024     1.3M       322/64/0    4 0  19  93 *F
inode_cache               2122     480     1.1M       272/27/0    8 0   9  91 aF
anon_vma                 18342      24   655.3K       160/98/0  128 0  61  67 F
:F-0000128                2455     128   561.1K      137/112/0   32 0  81  55 *F
ext3_inode_cache           570     640   499.7K       122/48/0    6 0  39  73 aF
:F-0000080                3825      80   307.2K         75/0/0   51 0   0  99 *F
cfq_io_context            1292     152   225.2K        55/20/0   26 0  36  87 F
cfq_queue                 1281     136   180.2K        44/16/0   30 0  36  96 F
shmem_inode_cache          244     672   167.9K         41/2/0    6 0   4  97 F
blkdev_requests            203     288    69.6K        17/11/0   14 0  64  83 F
:F-0000512                  63     512    53.2K         13/9/0    8 0  69  60 *F
:F-0000032                1398      32    49.1K         12/3/0  128 0  25  91 *F
idr_layer_cache             77     528    45.0K         11/0/0    7 0   0  90 F
:F-0004096                   9    4096    40.9K          5/1/0    2 1  20  90 *AF
:F-0000256                 105     256    32.7K          8/3/0   16 0  37  82 *F
kmalloc-96                 196      96    28.6K          7/3/0   42 0  42  65 F
file_lock_cache            130     176    24.5K          6/2/0   22 0  33  93 F
:F-0000016                1458      16    24.5K          6/1/0  256 0  16  94 *F
bdev_cache                  22     680    16.3K          2/0/0   11 1   0  91 AaF
sock_inode_cache            27     560    16.3K          4/1/0    7 0  25  92 AaF
journal_head                91      96    16.3K          4/2/0   42 0  50  53 aF
proc_inode_cache            15     512    12.2K          3/1/0    7 0  33  62 aF
:F-0000320                  24     320     8.1K          2/0/0   12 0   0  93 *AF
:F-0000160                  50     160     8.1K          2/0/0   25 0   0  97 *F
revoke_record              256      32     8.1K          2/0/0  128 0   0 100 AaF
TCP                          5    1464     8.1K          1/0/0    5 1   0  89 AF
journal_handle             340      24     8.1K          2/0/0  170 0   0  99 aF
skbuff_fclone_cache         18     388     8.1K          2/0/0    9 0   0  85 AF
kmalloc-8                 1024       8     8.1K          2/0/0  512 0   0 100 F
blkdev_queue                 5    1552     8.1K          1/0/0    5 1   0  94 F
scsi_cmd_cache              20     368     8.1K          2/0/0   10 0   0  89 AF
Acpi-Parse                 102      40     4.0K          1/0/0  102 0   0  99 F
revoke_table               256      16     4.0K          1/0/0  256 0   0 100 aF
Page block order: 10
Pages per block:  1024

Free pages count per migrate type at order       0      1      2      3      4      5      6      7      8      9     10 
Node    0, zone      DMA, type    Unmovable     12     11      5      9     11     10      3      0      0      0      0 
Node    0, zone      DMA, type  Reclaimable      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone      DMA, type      Movable    100     69     43     17     16     10      3      0      0      0      0 
Node    0, zone      DMA, type      Reserve      0      0      0      0      0      0      0      0      0      0      1 
Node    0, zone      DMA, type       <NULL>      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone    DMA32, type    Unmovable   3522    912     37      0      0      0      0      0      0      0      0 
Node    0, zone    DMA32, type  Reclaimable   4185   2320    514     43      1      0      0      0      0      0      0 
Node    0, zone    DMA32, type      Movable  31785  40871  15256   2709    140      0      0      0      0      0      0 
Node    0, zone    DMA32, type      Reserve     16     59     50     17      3      2      1      1      0      0      1 
Node    0, zone    DMA32, type       <NULL>      0      0      0      0      0      0      0      0      0      0      0 

Number of blocks type     Unmovable  Reclaimable      Movable      Reserve       <NULL> 
Node 0, zone      DMA            1            0            2            1            0 
Node 0, zone    DMA32           46           21          439            2            0 
---------------------------------------------------------
Wed Oct 24 11:55:31 MSD 2007
MemTotal:      2061616 kB
MemFree:        241412 kB
Buffers:         10580 kB
Cached:         293072 kB
SwapCached:      94344 kB
Active:        1415064 kB
Inactive:       201048 kB
SwapTotal:      987956 kB
SwapFree:       403872 kB
Dirty:          112412 kB
Writeback:        6144 kB
AnonPages:     1222908 kB
Mapped:          42924 kB
Slab:            72848 kB
SReclaimable:    31252 kB
SUnreclaim:      41596 kB
PageTables:      48832 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   2018764 kB
Committed_AS:  2313396 kB
VmallocTotal: 34359738367 kB
VmallocUsed:       896 kB
VmallocChunk: 34359737107 kB
Name                   Objects Objsize    Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
dentry                   70457     200    14.4M       3523/1/0   20 0   0  97 aF
ext2_inode_cache         16272     624    11.1M      2730/89/0    6 0   3  90 aF
vm_area_struct           39679     168     7.3M     1790/355/0   24 0  19  90 F
radix_tree_node          11207     552     6.5M       1601/0/0    7 0   0  94 F
sighand_cache             2111    2088     6.0M       744/84/0    3 1  11  72 AF
buffer_head              49069     104     5.1M      1261/29/0   39 0   2  98 aF
task_struct               2118    1776     4.7M      578/113/0    4 1  19  79 F
:F-0000768                4182     744     3.7M      910/158/0    5 0  17  83 *AF
:F-0000192               15377     192     3.5M      865/558/0   21 0  64  83 *F
:F-0002048                1614    2048     3.3M       411/19/0    4 1   4  98 *F
:F-0000704                2084     704     1.7M       211/53/0   11 1  25  84 *AF
:F-0000064               17173      64     1.6M      403/199/0   64 0  49  66 *F
:F-0001024                1232    1024     1.3M       322/44/0    4 0  13  95 *F
inode_cache               2143     480     1.1M       272/11/0    8 0   4  92 aF
anon_vma                 18747      24   655.3K       160/47/0  128 0  29  68 F
:F-0000128                2652     128   540.6K       132/88/0   32 0  66  62 *F
ext3_inode_cache           596     640   499.7K       122/34/0    6 0  27  76 aF
:F-0000080                3825      80   307.2K         75/0/0   51 0   0  99 *F
cfq_io_context            1228     152   225.2K        55/22/0   26 0  40  82 F
cfq_queue                 1211     136   180.2K        44/17/0   30 0  38  91 F
shmem_inode_cache          244     672   167.9K         41/2/0    6 0   4  97 F
:F-0004096                  16    4096    73.7K          9/2/0    2 1  22  88 *AF
blkdev_requests            188     288    61.4K         15/6/0   14 0  40  88 F
:F-0000512                  63     512    53.2K         13/9/0    8 0  69  60 *F
:F-0000032                1398      32    49.1K         12/3/0  128 0  25  91 *F
idr_layer_cache             77     528    45.0K         11/0/0    7 0   0  90 F
file_lock_cache            125     176    32.7K          8/6/0   22 0  75  67 F
:F-0000256                 109     256    32.7K          8/2/0   16 0  25  85 *F
kmalloc-96                 196      96    28.6K          7/3/0   42 0  42  65 F
:F-0000016                1458      16    24.5K          6/1/0  256 0  16  94 *F
bdev_cache                  22     680    16.3K          2/0/0   11 1   0  91 AaF
sock_inode_cache            27     560    16.3K          4/1/0    7 0  25  92 AaF
journal_head               143      96    16.3K          4/1/0   42 0  25  83 aF
proc_inode_cache            15     512    12.2K          3/1/0    7 0  33  62 aF
:F-0000320                  24     320     8.1K          2/0/0   12 0   0  93 *AF
:F-0000160                  50     160     8.1K          2/0/0   25 0   0  97 *F
revoke_record              256      32     8.1K          2/0/0  128 0   0 100 AaF
TCP                          5    1464     8.1K          1/0/0    5 1   0  89 AF
journal_handle             340      24     8.1K          2/0/0  170 0   0  99 aF
skbuff_fclone_cache         18     388     8.1K          2/0/0    9 0   0  85 AF
kmalloc-8                 1024       8     8.1K          2/0/0  512 0   0 100 F
blkdev_queue                 5    1552     8.1K          1/0/0    5 1   0  94 F
scsi_cmd_cache              20     368     8.1K          2/0/0   10 0   0  89 AF
Acpi-Parse                 102      40     4.0K          1/0/0  102 0   0  99 F
revoke_table               256      16     4.0K          1/0/0  256 0   0 100 aF
Page block order: 10
Pages per block:  1024

Free pages count per migrate type at order       0      1      2      3      4      5      6      7      8      9     10 
Node    0, zone      DMA, type    Unmovable     10      9      9     10     12     11      2      0      0      0      0 
Node    0, zone      DMA, type  Reclaimable      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone      DMA, type      Movable      1      0      2      0      0      1      2      0      0      0      0 
Node    0, zone      DMA, type      Reserve      0      0      0      0      0      0      0      0      0      0      1 
Node    0, zone      DMA, type       <NULL>      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone    DMA32, type    Unmovable    129     10      0      0      0      0      0      0      0      0      0 
Node    0, zone    DMA32, type  Reclaimable    135      0      0      0      0      0      0      0      0      0      0 
Node    0, zone    DMA32, type      Movable   2850   1272    395     58      0      0      0      0      0      0      0 
Node    0, zone    DMA32, type      Reserve      3      1      2      4      3      2      1      1      0      0      1 
Node    0, zone    DMA32, type       <NULL>      0      0      0      0      0      0      0      0      0      0      0 

Number of blocks type     Unmovable  Reclaimable      Movable      Reserve       <NULL> 
Node 0, zone      DMA            1            0            2            1            0 
Node 0, zone    DMA32           46           21          439            2            0 
---------------------------------------------------------
Wed Oct 24 11:56:57 MSD 2007
MemTotal:      2061616 kB
MemFree:         14188 kB
Buffers:          2836 kB
Cached:         194004 kB
SwapCached:      42244 kB
Active:        1437864 kB
Inactive:       359544 kB
SwapTotal:      987956 kB
SwapFree:       223988 kB
Dirty:          133824 kB
Writeback:        4200 kB
AnonPages:     1590604 kB
Mapped:          39624 kB
Slab:            72556 kB
SReclaimable:    30180 kB
SUnreclaim:      42376 kB
PageTables:      56664 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   2018764 kB
Committed_AS:  3018888 kB
VmallocTotal: 34359738367 kB
VmallocUsed:       896 kB
VmallocChunk: 34359737107 kB
Name                   Objects Objsize    Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
dentry                   44251     200    12.5M    3059/1512/0   20 0  49  70 aF
ext2_inode_cache         12586     624    11.3M    2771/1644/0    6 0  59  69 aF
vm_area_struct           43961     168     7.5M      1833/17/0   24 0   0  98 F
sighand_cache             2396    2088     6.5M        799/1/0    3 1   0  76 AF
radix_tree_node           6130     552     6.4M    1571/1264/0    7 0  80  52 F
buffer_head              33796     104     5.3M     1296/982/0   39 0  75  66 aF
task_struct               2399    1776     4.9M        600/1/0    4 1   0  86 F
:F-0000768                4750     744     3.8M        951/5/0    5 0   0  90 *AF
:F-0000192               16629     192     3.5M      865/264/0   21 0  30  90 *F
:F-0002048                1513    2048     3.1M       385/17/0    4 1   4  98 *F
:F-0000704                2362     704     1.7M        215/3/0   11 1   1  94 *AF
:F-0000064               13948      64     1.6M      403/309/0   64 0  76  54 *F
:F-0001024                1337    1024     1.3M        337/9/0    4 0   2  99 *F
inode_cache               1533     480     1.0M      263/123/0    8 0  46  68 aF
anon_vma                 20885      24   671.7K       164/14/0  128 0   8  74 F
:F-0000128                3461     128   557.0K       136/70/0   32 0  51  79 *F
ext3_inode_cache           599     640   499.7K       122/56/0    6 0  45  76 aF
:F-0000080                3825      80   307.2K         75/0/0   51 0   0  99 *F
cfq_io_context            1415     152   225.2K         55/3/0   26 0   5  95 F
cfq_queue                 1241     136   180.2K         44/5/0   30 0  11  93 F
shmem_inode_cache          244     672   167.9K         41/2/0    6 0   4  97 F
:F-0004096                  22    4096    90.1K         11/0/0    2 1   0 100 *AF
:F-0000016                2281      16    57.3K         14/8/0  256 0  57  63 *F
blkdev_requests            157     288    57.3K         14/9/0   14 0  64  78 F
:F-0000512                  64     512    53.2K         13/9/0    8 0  69  61 *F
:F-0000032                1398      32    49.1K         12/3/0  128 0  25  91 *F
idr_layer_cache             77     528    45.0K         11/0/0    7 0   0  90 F
:F-0000256                 105     256    32.7K          8/3/0   16 0  37  82 *F
kmalloc-96                 196      96    28.6K          7/3/0   42 0  42  65 F
bdev_cache                  22     680    16.3K          2/0/0   11 1   0  91 AaF
sock_inode_cache            27     560    16.3K          4/1/0    7 0  25  92 AaF
journal_head                91      96    16.3K          4/2/0   42 0  50  53 aF
proc_inode_cache            15     512    12.2K          3/1/0    7 0  33  62 aF
file_lock_cache             45     176    12.2K          3/1/0   22 0  33  64 F
:F-0000320                  24     320     8.1K          2/0/0   12 0   0  93 *AF
:F-0000160                  50     160     8.1K          2/0/0   25 0   0  97 *F
revoke_record              256      32     8.1K          2/0/0  128 0   0 100 AaF
TCP                          5    1464     8.1K          1/0/0    5 1   0  89 AF
journal_handle             340      24     8.1K          2/0/0  170 0   0  99 aF
skbuff_fclone_cache         18     388     8.1K          2/0/0    9 0   0  85 AF
kmalloc-8                 1024       8     8.1K          2/0/0  512 0   0 100 F
blkdev_queue                 5    1552     8.1K          1/0/0    5 1   0  94 F
scsi_cmd_cache              20     368     8.1K          2/0/0   10 0   0  89 AF
Acpi-Parse                 102      40     4.0K          1/0/0  102 0   0  99 F
revoke_table               256      16     4.0K          1/0/0  256 0   0 100 aF
Page block order: 10
Pages per block:  1024

Free pages count per migrate type at order       0      1      2      3      4      5      6      7      8      9     10 
Node    0, zone      DMA, type    Unmovable      1      2      8     10     12     11      2      0      0      0      0 
Node    0, zone      DMA, type  Reclaimable      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone      DMA, type      Movable      1      4      1      3      0      1      2      0      0      0      0 
Node    0, zone      DMA, type      Reserve      0      0      0      0      0      0      0      0      0      0      1 
Node    0, zone      DMA, type       <NULL>      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone    DMA32, type    Unmovable     11      0      0      0      0      0      0      0      0      0      0 
Node    0, zone    DMA32, type  Reclaimable    110      0      0      0      0      0      0      0      0      0      0 
Node    0, zone    DMA32, type      Movable     10     31      0      0      0      0      0      0      0      0      0 
Node    0, zone    DMA32, type      Reserve      9      1      0      0      3      2      1      1      0      0      1 
Node    0, zone    DMA32, type       <NULL>      0      0      0      0      0      0      0      0      0      0      0 

Number of blocks type     Unmovable  Reclaimable      Movable      Reserve       <NULL> 
Node 0, zone      DMA            1            0            2            1            0 
Node 0, zone    DMA32           46           21          439            2            0 
---------------------------------------------------------
Wed Oct 24 12:08:52 MSD 2007
MemTotal:      2061616 kB
MemFree:         13808 kB
Buffers:          2952 kB
Cached:          34332 kB
SwapCached:        872 kB
Active:         904352 kB
Inactive:       923296 kB
SwapTotal:      987956 kB
SwapFree:           24 kB
Dirty:           24576 kB
Writeback:        1540 kB
AnonPages:     1805896 kB
Mapped:           1692 kB
Slab:            51532 kB
SReclaimable:    12584 kB
SUnreclaim:      38948 kB
PageTables:      57952 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   2018764 kB
Committed_AS:  3473824 kB
VmallocTotal: 34359738367 kB
VmallocUsed:       896 kB
VmallocChunk: 34359737107 kB
Name                   Objects Objsize    Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
vm_area_struct           44135     168     7.5M     1851/109/0   24 0   5  97 F
sighand_cache             2392    2088     6.5M       804/19/0    3 1   2  75 AF
task_struct               2396    1776     4.9M       604/19/0    4 1   3  86 F
:F-0000768                4745     744     3.9M       957/36/0    5 0   3  90 *AF
dentry                    3364     200     3.8M      936/896/0   20 0  95  17 aF
:F-0000192               16630     192     3.5M      865/263/0   21 0  30  90 *F
:F-0002048                1448    2048     3.1M       386/42/0    4 1  10  93 *F
ext2_inode_cache          1367     624     2.3M      582/483/0    6 0  82  35 aF
:F-0000704                2365     704     1.7M       217/21/0   11 1   9  93 *AF
:F-0000064                8905      64     1.6M      403/337/0   64 0  83  34 *F
:F-0001024                1344    1024     1.4M       343/19/0    4 0   5  97 *F
inode_cache               1518     480     1.0M      263/126/0    8 0  47  67 aF
anon_vma                 20856      24   675.8K       165/46/0  128 0  27  74 F
:F-0000128                2922     128   577.5K      141/106/0   32 0  75  64 *F
radix_tree_node            861     552   544.7K       133/24/0    7 0  18  87 F
ext3_inode_cache           317     640   421.8K       103/87/0    6 0  84  48 aF
:F-0000080                3825      80   307.2K         75/0/0   51 0   0  99 *F
:F-0004096                  51    4096   229.3K         28/5/0    2 1  17  91 *AF
cfq_io_context            1447     152   229.3K         56/6/0   26 0  10  95 F
cfq_queue                 1426     136   196.6K         48/5/0   30 0  10  98 F
buffer_head                232     104   167.9K        41/38/0   39 0  92  14 aF
shmem_inode_cache          244     672   167.9K         41/2/0    6 0   4  97 F
blkdev_requests            168     288    86.0K        21/19/0   14 0  90  56 F
:F-0000512                  64     512    53.2K         13/9/0    8 0  69  61 *F
:F-0000032                1398      32    49.1K         12/3/0  128 0  25  91 *F
idr_layer_cache             77     528    45.0K         11/0/0    7 0   0  90 F
:F-0000016                1657      16    32.7K          8/3/0  256 0  37  80 *F
:F-0000256                 106     256    32.7K          8/3/0   16 0  37  82 *F
kmalloc-96                 196      96    28.6K          7/3/0   42 0  42  65 F
sock_inode_cache            27     560    16.3K          4/1/0    7 0  25  92 AaF
bdev_cache                  22     680    16.3K          2/0/0   11 1   0  91 AaF
proc_inode_cache            15     512    12.2K          3/1/0    7 0  33  62 aF
file_lock_cache             45     176    12.2K          3/1/0   22 0  33  64 F
journal_head                85      96    12.2K          3/1/0   42 0  33  66 aF
:F-0000320                  24     320     8.1K          2/0/0   12 0   0  93 *AF
:F-0000160                  50     160     8.1K          2/0/0   25 0   0  97 *F
revoke_record              256      32     8.1K          2/0/0  128 0   0 100 AaF
TCP                          5    1464     8.1K          1/0/0    5 1   0  89 AF
journal_handle             340      24     8.1K          2/0/0  170 0   0  99 aF
skbuff_fclone_cache         18     388     8.1K          2/0/0    9 0   0  85 AF
kmalloc-8                 1024       8     8.1K          2/0/0  512 0   0 100 F
blkdev_queue                 5    1552     8.1K          1/0/0    5 1   0  94 F
scsi_cmd_cache              20     368     8.1K          2/0/0   10 0   0  89 AF
Acpi-Parse                 102      40     4.0K          1/0/0  102 0   0  99 F
revoke_table               256      16     4.0K          1/0/0  256 0   0 100 aF
Page block order: 10
Pages per block:  1024

Free pages count per migrate type at order       0      1      2      3      4      5      6      7      8      9     10 
Node    0, zone      DMA, type    Unmovable      9      1     10     10     12     11      2      0      0      0      0 
Node    0, zone      DMA, type  Reclaimable      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone      DMA, type      Movable      2      0      1      2      0      1      2      0      0      0      0 
Node    0, zone      DMA, type      Reserve      0      0      0      0      0      0      0      0      0      0      1 
Node    0, zone      DMA, type       <NULL>      0      0      0      0      0      0      0      0      0      0      0 
Node    0, zone    DMA32, type    Unmovable     73      0      0      0      0      0      0      0      0      0      0 
Node    0, zone    DMA32, type  Reclaimable     57      1      0      0      0      0      0      0      0      0      0 
Node    0, zone    DMA32, type      Movable      1     39      0      0      0      0      0      0      0      0      0 
Node    0, zone    DMA32, type      Reserve     26      9      9      2      1      2      1      1      0      0      1 
Node    0, zone    DMA32, type       <NULL>      0      0      0      0      0      0      0      0      0      0      0 

Number of blocks type     Unmovable  Reclaimable      Movable      Reserve       <NULL> 
Node 0, zone      DMA            1            0            2            1            0 
Node 0, zone    DMA32           46           21          439            2            0 
---------------------------------------------------------
