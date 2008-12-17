Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1761367AbYLQMi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbYLQMi5 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751728AbYLQMcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:32:52 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:32828 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760293AbYLQMcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:32:51 -0500
Date: Wed, 17 Dec 2008 13:33:07 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bill Davidsen <davidsen@tmr.com>
Subject: Re: 2.6.28-rc8 big regression in VM
Message-ID: <20081217123307.GF4480@ics.muni.cz>
References: <20081212183810.GA4390@ics.muni.cz> <20081213012115.GA6250@localhost> <20081213095815.GA7143@ics.muni.cz> <20081215011645.GA9707@localhost> <20081215094409.GA4422@ics.muni.cz> <20081216045938.GA1000@localhost> <20081216195219.GA4480@ics.muni.cz> <20081217122726.GA21356@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6sX45UoQRIJXqkqR"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081217122726.GA21356@localhost>
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Muni-Spam-TestIP: 147.251.3.109
X-Muni-Envelope-From: xhejtman@anubis.ics.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Wed, 17 Dec 2008 13:32:43 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Dec 17, 2008 at 08:27:26PM +0800, Wu Fengguang wrote:
> It looks like most of cached pages were successfully freed:
> 
>         247788 => 69856 pages
> 
> To get more concrete numbers, could you send more info by running the
> following commands?
> 
> cp /proc/meminfo meminfo-1
> cp /proc/vmstat vmstat-1
> sync
> echo 3 > /proc/sys/vm/drop_caches
> cp /proc/meminfo meminfo-2
> cp /proc/vmstat vmstat-2

attached.

-- 
Luká¹ Hejtmánek

--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename=meminfo-1

MemTotal:        2016688 kB
MemFree:           22680 kB
Buffers:          238592 kB
Cached:          1087428 kB
SwapCached:            0 kB
Active:          1016536 kB
Inactive:         798812 kB
Active(anon):     412044 kB
Inactive(anon):   150708 kB
Active(file):     604492 kB
Inactive(file):   648104 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       1542232 kB
SwapFree:        1542232 kB
Dirty:               108 kB
Writeback:             0 kB
AnonPages:        489448 kB
Mapped:            73380 kB
Slab:             114192 kB
SReclaimable:      97304 kB
SUnreclaim:        16888 kB
PageTables:        11304 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     2550576 kB
Committed_AS:     818488 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      332160 kB
VmallocChunk:   34359375355 kB
DirectMap4k:       49856 kB
DirectMap2M:     2004992 kB

--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename=meminfo-2

MemTotal:        2016688 kB
MemFree:         1306652 kB
Buffers:             360 kB
Cached:           129516 kB
SwapCached:            0 kB
Active:           428240 kB
Inactive:         190976 kB
Active(anon):     411084 kB
Inactive(anon):   150708 kB
Active(file):      17156 kB
Inactive(file):    40268 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       1542232 kB
SwapFree:        1542232 kB
Dirty:                48 kB
Writeback:             0 kB
AnonPages:        489452 kB
Mapped:            73384 kB
Slab:              26188 kB
SReclaimable:       9576 kB
SUnreclaim:        16612 kB
PageTables:        11368 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     2550576 kB
Committed_AS:     818488 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      332160 kB
VmallocChunk:   34359375355 kB
DirectMap4k:       49856 kB
DirectMap2M:     2004992 kB

--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename=vmstat-1

nr_free_pages 5641
nr_inactive_anon 37677
nr_active_anon 103027
nr_inactive_file 162028
nr_active_file 151124
nr_unevictable 0
nr_mlock 0
nr_anon_pages 122347
nr_mapped 18345
nr_file_pages 331510
nr_dirty 28
nr_writeback 0
nr_slab_reclaimable 24326
nr_slab_unreclaimable 4222
nr_page_table_pages 2842
nr_unstable 0
nr_bounce 0
nr_vmscan_write 40
nr_writeback_temp 0
pgpgin 5916295
pgpgout 1320556
pswpin 0
pswpout 0
pgalloc_dma 22382
pgalloc_dma32 12834037
pgalloc_normal 0
pgalloc_movable 0
pgfree 12862318
pgactivate 347671
pgdeactivate 164209
pgfault 14972192
pgmajfault 30587
pgrefill_dma 1054
pgrefill_dma32 163155
pgrefill_normal 0
pgrefill_movable 0
pgsteal_dma 32
pgsteal_dma32 885851
pgsteal_normal 0
pgsteal_movable 0
pgscan_kswapd_dma 32
pgscan_kswapd_dma32 905956
pgscan_kswapd_normal 0
pgscan_kswapd_movable 0
pgscan_direct_dma 0
pgscan_direct_dma32 3104
pgscan_direct_normal 0
pgscan_direct_movable 0
pginodesteal 0
slabs_scanned 126976
kswapd_steal 885060
kswapd_inodesteal 10067
pageoutrun 12199
allocstall 11
pgrotated 3
unevictable_pgs_culled 21
unevictable_pgs_scanned 0
unevictable_pgs_rescued 22
unevictable_pgs_mlocked 22
unevictable_pgs_munlocked 22
unevictable_pgs_cleared 0
unevictable_pgs_stranded 0
unevictable_pgs_mlockfreed 0

--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename=vmstat-2

nr_free_pages 326668
nr_inactive_anon 37677
nr_active_anon 102771
nr_inactive_file 10041
nr_active_file 4345
nr_unevictable 0
nr_mlock 0
nr_anon_pages 122363
nr_mapped 18346
nr_file_pages 32505
nr_dirty 20
nr_writeback 0
nr_slab_reclaimable 2392
nr_slab_unreclaimable 4153
nr_page_table_pages 2842
nr_unstable 0
nr_bounce 0
nr_vmscan_write 40
nr_writeback_temp 0
pgpgin 5916963
pgpgout 1320888
pswpin 0
pswpout 0
pgalloc_dma 22397
pgalloc_dma32 12843648
pgalloc_normal 0
pgalloc_movable 0
pgfree 13192960
pgactivate 347736
pgdeactivate 164209
pgfault 14973258
pgmajfault 30595
pgrefill_dma 1054
pgrefill_dma32 163155
pgrefill_normal 0
pgrefill_movable 0
pgsteal_dma 32
pgsteal_dma32 885851
pgsteal_normal 0
pgsteal_movable 0
pgscan_kswapd_dma 32
pgscan_kswapd_dma32 905956
pgscan_kswapd_normal 0
pgscan_kswapd_movable 0
pgscan_direct_dma 0
pgscan_direct_dma32 3104
pgscan_direct_normal 0
pgscan_direct_movable 0
pginodesteal 0
slabs_scanned 374272
kswapd_steal 885060
kswapd_inodesteal 10067
pageoutrun 12199
allocstall 11
pgrotated 3
unevictable_pgs_culled 21
unevictable_pgs_scanned 0
unevictable_pgs_rescued 22
unevictable_pgs_mlocked 22
unevictable_pgs_munlocked 22
unevictable_pgs_cleared 0
unevictable_pgs_stranded 0
unevictable_pgs_mlockfreed 0

--6sX45UoQRIJXqkqR--
