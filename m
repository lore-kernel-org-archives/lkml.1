Return-Path: <linux-kernel-owner+w=401wt.eu-S964973AbZKYXN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964973AbZKYXN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 18:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759924AbZKYXN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 18:13:28 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:49052 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759917AbZKYXN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 18:13:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Vr+XpaQYXNy/9WPGhAMIZUeXqrDnQPazHQE8ZTR3jY2ZUoCUxwFBGlOZ8aOCqrG75w
         Z10zTFdtuj+B5e3K03WqNLqTFqG5f1sxP+4J9lxeMta3CEBcaOGL4vY6x+6LiYY/LEne
         8M3FulnPzcKh9IyjmEaXqQG44RJWJ33P5PKnE=
MIME-Version: 1.0
In-Reply-To: <2f11576a0911190636vd21069bv2fe4f22a57b3d333@mail.gmail.com>
References: <c0c067900911172356n2717ce9dn8a4231345903fde6@mail.gmail.com>
	 <2f11576a0911190636vd21069bv2fe4f22a57b3d333@mail.gmail.com>
Date: Wed, 25 Nov 2009 18:13:32 -0500
X-Google-Sender-Auth: 6e1485e7c340445c
Message-ID: <c0c067900911251513v48a34b18k73fb48f0e8d43c30@mail.gmail.com>
Subject: Re: Linux 2.6.31 - very swap-happy with plenty of free RAM
From: Dan Merillat <dan.merillat@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
       Norbert Preining <preining@logic.at>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       Sven-Haegar Koch <haegar@sdinet.de>, Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 9:36 AM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
> Hi Dan,
>
> Umm, very strange.
> I made two debug patch. can you please apply it and post following
> command output?
>
> % cat /proc/meminfo
> % cat /proc/vmstat
> % cat /proc/zoneinfo
> # cat /proc/filecache | sort -nr -k3 |head -30

As I said I can't give you the filecache info, but here's two  datasets

The  amount of cache is due to 1.5gb of mmaped vmware guest backing files.

First, 400mb ram "free" but still swapping out - usable with a few
pauses as apps swap back in.
meminfo
MemTotal:        3929040 kB
MemFree:          417748 kB
Buffers:           98348 kB
Cached:          2243696 kB
SwapCached:       149480 kB
Active:          1687316 kB
Inactive:        1527104 kB
Active(anon):    1042292 kB
Inactive(anon):   477736 kB
Active(file):     645024 kB
Inactive(file):  1049368 kB
Unevictable:          20 kB
Mlocked:              20 kB
SwapTotal:       3903480 kB
SwapFree:        3249496 kB
Dirty:               224 kB
Writeback:             0 kB
AnonPages:        759152 kB
Mapped:           398180 kB
Slab:             101844 kB
SReclaimable:      60864 kB
SUnreclaim:        40980 kB
PageTables:        38656 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     5868000 kB
Committed_AS:    3989292 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      302588 kB
VmallocChunk:   34359432695 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       40832 kB
DirectMap2M:     4020224 kB

vmstat
nr_free_pages 104437
nr_inactive_anon 119434
nr_active_anon 260573
nr_inactive_file 262342
nr_active_file 161256
nr_unevictable 5
nr_mlock 5
nr_anon_pages 189788
nr_mapped 99545
nr_file_pages 622881
nr_dirty 56
nr_writeback 0
nr_slab_reclaimable 15216
nr_slab_unreclaimable 10245
nr_page_table_pages 9664
nr_unstable 0
nr_bounce 0
nr_vmscan_write 13542637
nr_writeback_temp 0
numa_hit 378246197
numa_miss 0
numa_foreign 0
numa_interleave 8130
numa_local 378246197
numa_other 0
pgpgin 134039596
pgpgout 83142977
pswpin 168794
pswpout 282875
pgalloc_dma 28902
pgalloc_dma32 244979577
pgalloc_normal 135020061
pgalloc_movable 0
pgfree 380133342
pgactivate 2301807
pgdeactivate 1966072
pgfault 123713739
pgmajfault 168717
pgrefill_dma 447
pgrefill_dma32 818890
pgrefill_normal 263325
pgrefill_movable 0
pgsteal_dma 62
pgsteal_dma32 41972665
pgsteal_normal 8076187
pgsteal_movable 0
pgscan_kswapd_dma 192
pgscan_kswapd_dma32 100342332
pgscan_kswapd_normal 19655823
pgscan_kswapd_movable 0
pgscan_direct_dma 0
pgscan_direct_dma32 9364278
pgscan_direct_normal 2242788
pgscan_direct_movable 0
zone_reclaim_failed 0
pginodesteal 6375
slabs_scanned 1234816
kswapd_steal 47729503
kswapd_inodesteal 242151
pageoutrun 409691
allocstall 26919
pgrotated 283193
htlb_buddy_alloc_success 0
htlb_buddy_alloc_fail 0
unevictable_pgs_culled 9875
unevictable_pgs_scanned 0
unevictable_pgs_rescued 40104
unevictable_pgs_mlocked 42144
unevictable_pgs_munlocked 41486
unevictable_pgs_cleared 0
unevictable_pgs_stranded 0
unevictable_pgs_mlockfreed 0

zoneinfo
Node 0, zone      DMA
  pages free     3887
        min      7
        low      8
        high     10
        scanned  0
        spanned  4096
        present  3839
    nr_free_pages 3887
    nr_inactive_anon 15
    nr_active_anon 0
    nr_inactive_file 18
    nr_active_file 56
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 7
    nr_mapped    2
    nr_file_pages 82
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 5
    nr_slab_unreclaimable 2
    nr_page_table_pages 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    numa_hit     21161
    numa_miss    0
    numa_foreign 0
    numa_interleave 0
    numa_local   21161
    numa_other   0
        protection: (0, 3126, 3883, 3883)
  pagesets
    cpu: 0
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
    cpu: 1
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         0
  inactive_ratio:    1
  recent_rotated_anon: 0
  recent_scanned_anon: 2
  recent_rotated_file: 3
  recent_scanned_file: 12
Node 0, zone    DMA32
  pages free     100087
        min      1602
        low      2002
        high     2403
        scanned  0
        spanned  1044480
        present  800280
    nr_free_pages 100087
    nr_inactive_anon 62741
    nr_active_anon 217794
    nr_inactive_file 226981
    nr_active_file 136874
    nr_unevictable 5
    nr_mlock     5
    nr_anon_pages 130228
    nr_mapped    83692
    nr_file_pages 519311
    nr_dirty     39
    nr_writeback 0
    nr_slab_reclaimable 10649
    nr_slab_unreclaimable 5709
    nr_page_table_pages 4812
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 10954292
    nr_writeback_temp 0
    numa_hit     243347959
    numa_miss    0
    numa_foreign 0
    numa_interleave 0
    numa_local   243347959
    numa_other   0
        protection: (0, 0, 757, 757)
  pagesets
    cpu: 0
              count: 134
              high:  186
              batch: 31
  vm stats threshold: 24
    cpu: 1
              count: 11
              high:  186
              batch: 31
  vm stats threshold: 24
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         4096
  inactive_ratio:    5
  recent_rotated_anon: 33921
  recent_scanned_anon: 77920
  recent_rotated_file: 459
  recent_scanned_file: 80092
Node 0, zone   Normal
  pages free     463
        min      388
        low      485
        high     582
        scanned  0
        spanned  196608
        present  193920
    nr_free_pages 463
    nr_inactive_anon 56678
    nr_active_anon 42779
    nr_inactive_file 35343
    nr_active_file 24326
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 59553
    nr_mapped    15851
    nr_file_pages 103488
    nr_dirty     17
    nr_writeback 0
    nr_slab_reclaimable 4562
    nr_slab_unreclaimable 4534
    nr_page_table_pages 4852
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 2588345
    nr_writeback_temp 0
    numa_hit     134877151
    numa_miss    0
    numa_foreign 0
    numa_interleave 8130
    numa_local   134877151
    numa_other   0
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 149
              high:  186
              batch: 31
  vm stats threshold: 16
    cpu: 1
              count: 77
              high:  186
              batch: 31
  vm stats threshold: 16
  all_unreclaimable: 0
  prev_priority:     12
  start_pfn:         1048576
  inactive_ratio:    1
  recent_rotated_anon: 6122
  recent_scanned_anon: 14889
  recent_rotated_file: 491
  recent_scanned_file: 9600


Second one was during a thrash storm (I think, it may not have dumped
until the end of it)
Note the kernel claims it has over 500mb free RAM that's not being
used while we swap
meminfo
MemTotal:        3929040 kB
MemFree:          544676 kB
Buffers:          123256 kB
Cached:          2097536 kB
SwapCached:       184016 kB
Active:          1703160 kB
Inactive:        1376904 kB
Active(anon):     990688 kB
Inactive(anon):   400420 kB
Active(file):     712472 kB
Inactive(file):   976484 kB
Unevictable:          20 kB
Mlocked:              20 kB
SwapTotal:       3903480 kB
SwapFree:        3023160 kB
Dirty:              6844 kB
Writeback:           112 kB
AnonPages:        740368 kB
Mapped:           455792 kB
Slab:             109176 kB
SReclaimable:      63088 kB
SUnreclaim:        46088 kB
PageTables:        39540 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     5868000 kB
Committed_AS:    4134332 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      302588 kB
VmallocChunk:   34359432695 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       40832 kB
DirectMap2M:     4020224 kB

vmstat
nr_free_pages 136138
nr_inactive_anon 100105
nr_active_anon 247672
nr_inactive_file 244146
nr_active_file 178118
nr_unevictable 5
nr_mlock 5
nr_anon_pages 185092
nr_mapped 113948
nr_file_pages 601227
nr_dirty 1711
nr_writeback 28
nr_slab_reclaimable 15772
nr_slab_unreclaimable 11522
nr_page_table_pages 9885
nr_unstable 0
nr_bounce 0
nr_vmscan_write 14020410
nr_writeback_temp 0
numa_hit 438013705
numa_miss 0
numa_foreign 0
numa_interleave 8130
numa_local 438013705
numa_other 0
pgpgin 137757163
pgpgout 89200634
pswpin 410261
pswpout 464160
pgalloc_dma 28902
pgalloc_dma32 291710526
pgalloc_normal 149182097
pgalloc_movable 0
pgfree 441058114
pgactivate 3112124
pgdeactivate 2717995
pgfault 185871068
pgmajfault 254976
pgrefill_dma 447
pgrefill_dma32 839061
pgrefill_normal 263472
pgrefill_movable 0
pgsteal_dma 62
pgsteal_dma32 42581791
pgsteal_normal 8623195
pgsteal_movable 0
pgscan_kswapd_dma 192
pgscan_kswapd_dma32 115131371
pgscan_kswapd_normal 24244847
pgscan_kswapd_movable 0
pgscan_direct_dma 0
pgscan_direct_dma32 9390346
pgscan_direct_normal 2249551
pgscan_direct_movable 0
zone_reclaim_failed 0
pginodesteal 6375
slabs_scanned 2123520
kswapd_steal 48883166
kswapd_inodesteal 310652
pageoutrun 426393
allocstall 26962
pgrotated 464504
htlb_buddy_alloc_success 0
htlb_buddy_alloc_fail 0
unevictable_pgs_culled 9875
unevictable_pgs_scanned 0
unevictable_pgs_rescued 40104
unevictable_pgs_mlocked 42211
unevictable_pgs_munlocked 41486
unevictable_pgs_cleared 0
unevictable_pgs_stranded 0
unevictable_pgs_mlockfreed 0

zoneinfo
Node 0, zone      DMA
  pages free     3888
        min      7
        low      8
        high     10
        scanned  0
        spanned  4096
        present  3839
    nr_free_pages 3888
    nr_inactive_anon 14
    nr_active_anon 0
    nr_inactive_file 18
    nr_active_file 56
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 6
    nr_mapped    3
    nr_file_pages 82
    nr_dirty     0
    nr_writeback 0
    nr_slab_reclaimable 5
    nr_slab_unreclaimable 2
    nr_page_table_pages 0
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 0
    nr_writeback_temp 0
    numa_hit     21161
    numa_miss    0
    numa_foreign 0
    numa_interleave 0
    numa_local   21161
    numa_other   0
        protection: (0, 3126, 3883, 3883)
  pagesets
    cpu: 0
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
    cpu: 1
              count: 0
              high:  0
              batch: 1
  vm stats threshold: 4
  all_unreclaimable: 0
  prev_priority:     7
  start_pfn:         0
  inactive_ratio:    1
  recent_rotated_anon: 0
  recent_scanned_anon: 2
  recent_rotated_file: 3
  recent_scanned_file: 12
Node 0, zone    DMA32
  pages free     117449
        min      1602
        low      2002
        high     2403
        scanned  0
        spanned  1044480
        present  800280
    nr_free_pages 117449
    nr_inactive_anon 51601
    nr_active_anon 208680
    nr_inactive_file 210820
    nr_active_file 154607
    nr_unevictable 5
    nr_mlock     5
    nr_anon_pages 128789
    nr_mapped    98197
    nr_file_pages 508828
    nr_dirty     1501
    nr_writeback 0
    nr_slab_reclaimable 11187
    nr_slab_unreclaimable 6932
    nr_page_table_pages 4798
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 11175938
    nr_writeback_temp 0
    numa_hit     288976607
    numa_miss    0
    numa_foreign 0
    numa_interleave 0
    numa_local   288976607
    numa_other   0
        protection: (0, 0, 757, 757)
  pagesets
    cpu: 0
              count: 182
              high:  186
              batch: 31
  vm stats threshold: 24
    cpu: 1
              count: 166
              high:  186
              batch: 31
  vm stats threshold: 24
  all_unreclaimable: 0
  prev_priority:     7
  start_pfn:         4096
  inactive_ratio:    5
  recent_rotated_anon: 34440
  recent_scanned_anon: 39630
  recent_rotated_file: 416
  recent_scanned_file: 59261
Node 0, zone   Normal
  pages free     14801
        min      388
        low      485
        high     582
        scanned  0
        spanned  196608
        present  193920
    nr_free_pages 14801
    nr_inactive_anon 48490
    nr_active_anon 38992
    nr_inactive_file 33308
    nr_active_file 23455
    nr_unevictable 0
    nr_mlock     0
    nr_anon_pages 56297
    nr_mapped    15748
    nr_file_pages 92317
    nr_dirty     210
    nr_writeback 28
    nr_slab_reclaimable 4580
    nr_slab_unreclaimable 4588
    nr_page_table_pages 5087
    nr_unstable  0
    nr_bounce    0
    nr_vmscan_write 2844472
    nr_writeback_temp 0
    numa_hit     149016012
    numa_miss    0
    numa_foreign 0
    numa_interleave 8130
    numa_local   149016012
    numa_other   0
        protection: (0, 0, 0, 0)
  pagesets
    cpu: 0
              count: 28
              high:  186
              batch: 31
  vm stats threshold: 16
    cpu: 1
              count: 61
              high:  186
              batch: 31
  vm stats threshold: 16
  all_unreclaimable: 0
  prev_priority:     7
  start_pfn:         1048576
  inactive_ratio:    1
  recent_rotated_anon: 8094
  recent_scanned_anon: 17955
  recent_rotated_file: 229
  recent_scanned_file: 14296
