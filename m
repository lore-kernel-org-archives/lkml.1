Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbYBQNVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbYBQNVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 08:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYBQNVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 08:21:04 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:38381 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbYBQNVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 08:21:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Uo409xkUqGVGyjNwGLEHLsW0iJp4wUm15PRbOZjEQxemZL4bgp1r08HtEAvxgiyIc1TyfPMmwikFr/nyp10N8QjYbTYa5FwnlpPeW8ZYYo2lnTBWuO12oi06nprIte03MVv3Zpp+htFn1QikJyiXO4hU64mJEEkC08Otpw5x6T0=
Message-ID: <6278d2220802170520k2ddf9072x386e4a9e3062f4da@mail.gmail.com>
Date: Sun, 17 Feb 2008 13:20:59 +0000
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.25-rc2, 2.6.24-rc8] page allocation failure...
In-Reply-To: <6278d2220802141240g6ee2421ew94e57669ef930be6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220802141240g6ee2421ew94e57669ef930be6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm still hitting this with e1000e on 2.6.25-rc2, 10 times again.

It's clearly non-fatal, but then do we expect it to occur?

Daniel

--- [dmesg]

[ 1250.822786] swapper: page allocation failure. order:3, mode:0x4020
[ 1250.822786] Pid: 0, comm: swapper Not tainted 2.6.25-rc2-119 #2
[ 1250.822786]
[ 1250.822786] Call Trace:
[ 1250.822786]  <IRQ>  [<ffffffff8025fe9e>] __alloc_pages+0x34e/0x3a0
[ 1250.822786]  [<ffffffff8048c6df>] ? __netdev_alloc_skb+0x1f/0x40
[ 1250.822786]  [<ffffffff8027acc2>] __slab_alloc+0x102/0x3d0
[ 1250.822786]  [<ffffffff8048c6df>] ? __netdev_alloc_skb+0x1f/0x40
[ 1250.822786]  [<ffffffff8027b8cb>] __kmalloc_track_caller+0x7b/0xc0
[ 1250.822786]  [<ffffffff8048b74f>] __alloc_skb+0x6f/0x160
[ 1250.822786]  [<ffffffff8048c6df>] __netdev_alloc_skb+0x1f/0x40
[ 1250.822786]  [<ffffffff8042652d>] e1000_alloc_rx_buffers+0x1ed/0x260
[ 1250.822786]  [<ffffffff80426b5a>] e1000_clean_rx_irq+0x22a/0x330
[ 1250.822786]  [<ffffffff80422981>] e1000_clean+0x1e1/0x540
[ 1250.822786]  [<ffffffff8024b7a5>] ? tick_program_event+0x45/0x70
[ 1250.822786]  [<ffffffff804930ba>] net_rx_action+0x9a/0x150
[ 1250.822786]  [<ffffffff802336b4>] __do_softirq+0x74/0xf0
[ 1250.822786]  [<ffffffff8020c5fc>] call_softirq+0x1c/0x30
[ 1250.822786]  [<ffffffff8020eaad>] do_softirq+0x3d/0x80
[ 1250.822786]  [<ffffffff80233635>] irq_exit+0x85/0x90
[ 1250.822786]  [<ffffffff8020eba5>] do_IRQ+0x85/0x100
[ 1250.822786]  [<ffffffff8020a5b0>] ? mwait_idle+0x0/0x50
[ 1250.822786]  [<ffffffff8020b981>] ret_from_intr+0x0/0xa
[ 1250.822786]  <EOI>  [<ffffffff8020a5f5>] ? mwait_idle+0x45/0x50
[ 1250.822786]  [<ffffffff80209a92>] ? enter_idle+0x22/0x30
[ 1250.822786]  [<ffffffff8020a534>] ? cpu_idle+0x74/0xa0
[ 1250.822786]  [<ffffffff80527825>] ? rest_init+0x55/0x60
[ 1250.822786]
[ 1250.822786] Mem-info:
[ 1250.822786] DMA per-cpu:
[ 1250.822786] CPU    0: hi:    0, btch:   1 usd:   0
[ 1250.822786] CPU    1: hi:    0, btch:   1 usd:   0
[ 1250.822786] DMA32 per-cpu:
[ 1250.822786] CPU    0: hi:  186, btch:  31 usd: 179
[ 1250.822786] CPU    1: hi:  186, btch:  31 usd: 159
[ 1250.822786] Active:59792 inactive:67236 dirty:4775 writeback:4779 unstable:0
[ 1250.822786]  free:2232 slab:122927 mapped:3846 pagetables:715 bounce:0
[ 1250.822786] DMA free:3984kB min:36kB low:44kB high:52kB active:4kB
inactive:560kB present:10076kB pages_scanned:0 all_unreclaimable? no
[ 1250.822786] lowmem_reserve[]: 0 992 992 992
[ 1250.822786] DMA32 free:4944kB min:4008kB low:5008kB high:6012kB
active:239164kB inactive:268384kB present:1015936kB pages_scanned:0
all_unreclaimable? no
[ 1250.822786] lowmem_reserve[]: 0 0 0 0
[ 1250.822786] DMA: 6*4kB 1*8kB 1*16kB 1*32kB 1*64kB 0*128kB 1*256kB
1*512kB 1*1024kB 1*2048kB 0*4096kB = 3984kB
[ 1250.822786] DMA32: 836*4kB 148*8kB 18*16kB 0*32kB 1*64kB 1*128kB
0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 5008kB
[ 1250.822786] 88530 total pagecache pages
[ 1250.822786] Swap cache: add 33, delete 32, find 0/0
[ 1250.822786] Free swap  = 248872kB
[ 1250.822786] Total swap = 248996kB
[ 1250.822786] Free swap:       248872kB
[ 1250.822786] 261600 pages of RAM
[ 1250.822786] 5448 reserved pages
[ 1250.822786] 55715 pages shared
[ 1250.822786] 1 pages swap cached

On Feb 14, 2008 8:40 PM, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
> One of my x86-64 (1GB) systems experienced order 1 page alloc failure
> after ~4 days of uptime and 9 times again in the hours since.
>
> I understand the behaviour is that the reclaim kthread should have had
> a couple of free pages around for this type allocation, but obviously
> didn't (a number of times).
>
> What other information may help with this?
>
> Daniel
>
> --- dmesg
> swapper: page allocation failure. order:1, mode:0x4020
> Pid: 0, comm: swapper Not tainted 2.6.24-rc8-117 #1
>
> Call Trace:
> <IRQ>  [<ffffffff80258696>] __alloc_pages+0x336/0x390
> [<ffffffff8047e677>] __netdev_alloc_skb+0x17/0x40
> [<ffffffff80272825>] __slab_alloc+0x145/0x3d0
> [<ffffffff8047e677>] __netdev_alloc_skb+0x17/0x40
> [<ffffffff80273526>] __kmalloc_track_caller+0xf6/0x100
> [<ffffffff8047d8cf>] __alloc_skb+0x6f/0x150
> [<ffffffff8047e677>] __netdev_alloc_skb+0x17/0x40
> [<ffffffff8040b3aa>] e1000_alloc_rx_buffers+0x17a/0x3a0
> [<ffffffff804b2643>] ip_local_deliver_finish+0x83/0x1a0
> [<ffffffff8040c00d>] e1000_clean_rx_irq+0x34d/0x550
> [<ffffffff8040b031>] e1000_intr_msi+0x81/0x110
> [<ffffffff8024e5f4>] handle_IRQ_event+0x34/0x70
> [<ffffffff80250229>] handle_edge_irq+0xc9/0x150
> [<ffffffff8020eeab>] do_IRQ+0x7b/0x100
> [<ffffffff8020ad80>] mwait_idle+0x0/0x50
> [<ffffffff8020c011>] ret_from_intr+0x0/0xa
> <EOI>  [<ffffffff802197a0>] lapic_next_event+0x0/0x10
> [<ffffffff8020adc2>] mwait_idle+0x42/0x50
> [<ffffffff8020ad05>] cpu_idle+0x75/0xa0
> [<ffffffff806a8b3a>] start_kernel+0x25a/0x2e0
> [<ffffffff806a8117>] _sinittext+0x117/0x120
>
> Mem-info:
> DMA per-cpu:
> CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
> CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
> DMA32 per-cpu:
> CPU    0: Hot: hi:  186, btch:  31 usd: 155   Cold: hi:   62, btch:  15 usd:  60
> CPU    1: Hot: hi:  186, btch:  31 usd:  14   Cold: hi:   62, btch:  15 usd:  42
> Active:114794 inactive:53917 dirty:8137 writeback:5025 unstable:0
>  free:3549 slab:79629 mapped:4643 pagetables:1017 bounce:0
> DMA free:3968kB min:40kB low:48kB high:60kB active:72kB inactive:120kB
> present:10236kB pages_scanned:0 all_unreclaimable? no
> lowmem_reserve[]: 0 992 992 992
> DMA32 free:10228kB min:4008kB low:5008kB high:6012kB active:459104kB
> inactive:215548kB present:1015936kB pages_scanned:0 all_unreclaimable?
> no
> lowmem_reserve[]: 0 0 0 0
> DMA: 324*4kB 0*8kB 1*16kB 1*32kB 1*64kB 0*128kB 0*256kB 1*512kB
> 0*1024kB 1*2048kB 0*4096kB = 3968kB
> DMA32: 2378*4kB 1*8kB 1*16kB 1*32kB 0*64kB 1*128kB 0*256kB 1*512kB
> 0*1024kB 0*2048kB 0*4096kB = 10208kB
> Swap cache: add 750, delete 488, find 196/269, race 0+0
> Free swap  = 247720kB
> Total swap = 248996kB
> Free swap:       247720kB
> 261600 pages of RAM
> 5401 reserved pages
> 55912 pages shared
> 262 pages swap cached
>
> --- /proc/slabinfo
> slabinfo - version: 2.1
> # name            <active_objs> <num_objs> <objsize> <objperslab>
> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> :
> slabdata <active_slabs> <num_slabs> <sharedavail>
> rpc_inode_cache       10     10    768    5    1 : tunables    0    0
>   0 : slabdata      2      2      0
> xt_hashlimit           0      0     88   46    1 : tunables    0    0
>   0 : slabdata      0      0      0
> nf_conntrack_expect     18     18    224   18    1 : tunables    0
> 0    0 : slabdata      1      1      0
> nf_conntrack          63     70    280   14    1 : tunables    0    0
>   0 : slabdata      5      5      0
> cfq_io_context        77     78    152   26    1 : tunables    0    0
>   0 : slabdata      3      3      0
> cfq_queue             89     90    136   30    1 : tunables    0    0
>   0 : slabdata      3      3      0
> bsg_cmd                0      0    312   13    1 : tunables    0    0
>   0 : slabdata      0      0      0
> mqueue_inode_cache      9      9    832    9    2 : tunables    0    0
>    0 : slabdata      1      1      0
> xfs_inode         186190 186984    512    8    1 : tunables    0    0
>   0 : slabdata  23373  23373      0
> xfs_efi_item          22     22    352   11    1 : tunables    0    0
>   0 : slabdata      2      2      0
> xfs_efd_item          22     22    360   11    1 : tunables    0    0
>   0 : slabdata      2      2      0
> xfs_buf_item          58     66    184   22    1 : tunables    0    0
>   0 : slabdata      3      3      0
> xfs_da_state          16     16    488    8    1 : tunables    0    0
>   0 : slabdata      2      2      0
> xfs_vnode         186180 186865    576    7    1 : tunables    0    0
>   0 : slabdata  26695  26695      0
> nfsd4_delegations    461    465    272   15    1 : tunables    0    0
>   0 : slabdata     31     31      0
> nfsd4_stateowners     45     45    424    9    1 : tunables    0    0
>   0 : slabdata      5      5      0
> isofs_inode_cache      0      0    576    7    1 : tunables    0    0
>   0 : slabdata      0      0      0
> ext2_inode_cache       0      0    672    6    1 : tunables    0    0
>   0 : slabdata      0      0      0
> journal_handle       340    340     24  170    1 : tunables    0    0
>   0 : slabdata      2      2      0
> journal_head          85    126     96   42    1 : tunables    0    0
>   0 : slabdata      3      3      0
> revoke_table         512    512     16  256    1 : tunables    0    0
>   0 : slabdata      2      2      0
> revoke_record        256    256     32  128    1 : tunables    0    0
>   0 : slabdata      2      2      0
> ext4_inode_cache       0      0    736    5    1 : tunables    0    0
>   0 : slabdata      0      0      0
> ext3_inode_cache    5322   5940    688   11    2 : tunables    0    0
>   0 : slabdata    540    540      0
> kioctx                50     60    384   10    1 : tunables    0    0
>   0 : slabdata      6      6      0
> fasync_cache         340    340     24  170    1 : tunables    0    0
>   0 : slabdata      2      2      0
> shmem_inode_cache    831    835    720    5    1 : tunables    0    0
>   0 : slabdata    167    167      0
> nsproxy              146    146     56   73    1 : tunables    0    0
>   0 : slabdata      2      2      0
> ip_dst_cache         132    132    320   12    1 : tunables    0    0
>   0 : slabdata     11     11      0
> TCP                   26     30   1600    5    2 : tunables    0    0
>   0 : slabdata      6      6      0
> eventpoll_pwq        544    560     72   56    1 : tunables    0    0
>   0 : slabdata     10     10      0
> scsi_io_context        0      0    112   36    1 : tunables    0    0
>   0 : slabdata      0      0      0
> blkdev_queue          12     12   1648    4    2 : tunables    0    0
>   0 : slabdata      3      3      0
> blkdev_requests       36     42    288   14    1 : tunables    0    0
>   0 : slabdata      3      3      0
> sock_inode_cache      84     90    640    6    1 : tunables    0    0
>   0 : slabdata     15     15      0
> skbuff_fclone_cache     20     27    448    9    1 : tunables    0
> 0    0 : slabdata      3      3      0
> file_lock_cache      501    506    184   22    1 : tunables    0    0
>   0 : slabdata     23     23      0
> Acpi-Parse           204    204     40  102    1 : tunables    0    0
>   0 : slabdata      2      2      0
> proc_inode_cache     385    392    560    7    1 : tunables    0    0
>   0 : slabdata     56     56      0
> sigqueue              50     50    160   25    1 : tunables    0    0
>   0 : slabdata      2      2      0
> radix_tree_node    13307  16590    560    7    1 : tunables    0    0
>   0 : slabdata   2370   2370      0
> bdev_cache            12     15    768    5    1 : tunables    0    0
>   0 : slabdata      3      3      0
> sysfs_dir_cache     4641   4641     80   51    1 : tunables    0    0
>   0 : slabdata     91     91      0
> inode_cache           71     91    528    7    1 : tunables    0    0
>   0 : slabdata     13     13      0
> dentry             95161  97780    200   20    1 : tunables    0    0
>   0 : slabdata   4889   4889      0
> names_cache            8      8   4096    2    2 : tunables    0    0
>   0 : slabdata      4      4      0
> idr_layer_cache      137    140    536    7    1 : tunables    0    0
>   0 : slabdata     20     20      0
> buffer_head        58093  59748    104   39    1 : tunables    0    0
>   0 : slabdata   1532   1532      0
> mm_struct             64     70    768    5    1 : tunables    0    0
>   0 : slabdata     14     14      0
> vm_area_struct      2462   2592    168   24    1 : tunables    0    0
>   0 : slabdata    108    108      0
> files_cache           75     88    704   11    2 : tunables    0    0
>   0 : slabdata      8      8      0
> signal_cache         109    117    832    9    2 : tunables    0    0
>   0 : slabdata     13     13      0
> sighand_cache         88     90   2112    3    2 : tunables    0    0
>   0 : slabdata     30     30      0
> task_struct          102    108   1808    4    2 : tunables    0    0
>   0 : slabdata     27     27      0
> anon_vma             806    896     32  128    1 : tunables    0    0
>   0 : slabdata      7      7      0
> pid_namespace          0      0   2104    3    2 : tunables    0    0
>   0 : slabdata      0      0      0
> kmalloc-2048         592    624   2048    4    2 : tunables    0    0
>   0 : slabdata    156    156      0
> kmalloc-1024         267    276   1024    4    1 : tunables    0    0
>   0 : slabdata     69     69      0
> kmalloc-512          213    232    512    8    1 : tunables    0    0
>   0 : slabdata     29     29      0
> kmalloc-256          524    656    256   16    1 : tunables    0    0
>   0 : slabdata     41     41      0
> kmalloc-128          932   1152    128   32    1 : tunables    0    0
>   0 : slabdata     36     36      0
> kmalloc-64         27166  31104     64   64    1 : tunables    0    0
>   0 : slabdata    486    486      0
> kmalloc-32          7180  10880     32  128    1 : tunables    0    0
>   0 : slabdata     85     85      0
> kmalloc-16          1886   2816     16  256    1 : tunables    0    0
>   0 : slabdata     11     11      0
> kmalloc-8           2538   2560      8  512    1 : tunables    0    0
>   0 : slabdata      5      5      0
> kmalloc-192         2205   2667    192   21    1 : tunables    0    0
>   0 : slabdata    127    127      0
> kmalloc-96          3024   3192     96   42    1 : tunables    0    0
>   0 : slabdata     76     76      0
>
> --- /proc/meminfo
> MemTotal:      1024796 kB
> MemFree:         55160 kB
> Buffers:         12856 kB
> Cached:         315856 kB
> SwapCached:       1052 kB
> Active:         461848 kB
> Inactive:       242108 kB
> SwapTotal:      248996 kB
> SwapFree:       247724 kB
> Dirty:              28 kB
> Writeback:           0 kB
> AnonPages:      375348 kB
> Mapped:          18200 kB
> Slab:           248164 kB
> SReclaimable:   230716 kB
> SUnreclaim:      17448 kB
> PageTables:       4032 kB
> NFS_Unstable:        0 kB
> Bounce:              0 kB
> CommitLimit:    761392 kB
> Committed_AS:   541628 kB
> VmallocTotal: 34359738367 kB
> VmallocUsed:    264820 kB
> VmallocChunk: 34359473499 kB
>
> --- /proc/zoneinfo
> Node 0, zone      DMA
>   pages free     1259
>         min      10
>         low      12
>         high     15
>         scanned  0 (a: 2 i: 16)
>         spanned  4096
>         present  2559
>     nr_free_pages 1259
>     nr_inactive  66
>     nr_active    7
>     nr_anon_pages 0
>     nr_mapped    0
>     nr_file_pages 73
>     nr_dirty     0
>     nr_writeback 0
>     nr_slab_reclaimable 1296
>     nr_slab_unreclaimable 65
>     nr_page_table_pages 0
>     nr_unstable  0
>     nr_bounce    0
>     nr_vmscan_write 787
>         protection: (0, 992, 992, 992)
>   pagesets
>     cpu: 0 pcp: 0
>               count: 0
>               high:  0
>               batch: 1
>     cpu: 0 pcp: 1
>               count: 0
>               high:  0
>               batch: 1
>   vm stats threshold: 4
>     cpu: 1 pcp: 0
>               count: 0
>               high:  0
>               batch: 1
>     cpu: 1 pcp: 1
>               count: 0
>               high:  0
>               batch: 1
>   vm stats threshold: 4
>   all_unreclaimable: 0
>   prev_priority:     12
>   start_pfn:         0
> Node 0, zone    DMA32
>   pages free     12514
>         min      1002
>         low      1252
>         high     1503
>         scanned  0 (a: 0 i: 0)
>         spanned  257504
>         present  253984
>     nr_free_pages 12514
>     nr_inactive  60499
>     nr_active    115446
>     nr_anon_pages 93837
>     nr_mapped    4550
>     nr_file_pages 82403
>     nr_dirty     7
>     nr_writeback 0
>     nr_slab_reclaimable 56383
>     nr_slab_unreclaimable 4290
>     nr_page_table_pages 1008
>     nr_unstable  0
>     nr_bounce    0
>     nr_vmscan_write 7348
>         protection: (0, 0, 0, 0)
>   pagesets
>     cpu: 0 pcp: 0
>               count: 102
>               high:  186
>               batch: 31
>     cpu: 0 pcp: 1
>               count: 64
>               high:  62
>               batch: 15
>   vm stats threshold: 16
>     cpu: 1 pcp: 0
>               count: 102
>               high:  186
>               batch: 31
>     cpu: 1 pcp: 1
>               count: 65
>               high:  62
>               batch: 15
>   vm stats threshold: 16
>   all_unreclaimable: 0
>   prev_priority:     12
>   start_pfn:         4096
> --
> Daniel J Blueman
>



-- 
Daniel J Blueman
