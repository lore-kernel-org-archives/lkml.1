Return-Path: <linux-kernel-owner+w=401wt.eu-S1754976AbYAQGg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbYAQGg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 01:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYAQGgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 01:36:19 -0500
Received: from nessie.weebeastie.net ([220.233.7.36]:35072 "EHLO
	bunyip.lochness.weebeastie.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751349AbYAQGgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 01:36:17 -0500
Date: Thu, 17 Jan 2008 17:34:10 +1100
From: CaT <cat@zip.com.au>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24-rc7: memory leak?
Message-ID: <20080117063410.GQ3940@zip.com.au>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
Organisation: Furball Inc.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Not sure where to begin so here goes anway. Today I did an rsync backup
of a server with 2million+ files. Before doing so the used memory on the
server this was initiated from was under 200meg (excluding buffers and
cache). During the rsync the memory used grew to just shy of 1.6gig and
now, about 2 hours after the rsync has well and truly finished, the used
memory is at 1.23gig. This is what free reports:

             total       used       free     shared    buffers cached
Mem:       2058128    1994468      63660          0     688604 11432
-/+ buffers/cache:    1294432     763696
Swap:      1048568          0    1048568

There are 75 processes on the box of which almost 47 are kernel
processes + init. Of the rest, the top 3 have an RSS of 9.4meg, 6.2meg
and 4.8meg, 7 are at around 2meg and the rest are below 2meg with the
majority below 1. So unless I'm misunderstanding something, processess
alone do not account for the amount of used memory.

The destination of the rsync was an ext3 filesystem over raid5 over ahci
sata.

I've included /proc/meminfo, /proc/slabinfo and config.gz. If there's
anything else please shout.

-- 
    "To the extent that we overreact, we proffer the terrorists the
    greatest tribute."
    	- High Court Judge Michael Kirby

--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=slabinfo

slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
ip_fib_alias          10     59     64   59    1 : tunables  120   60    8 : slabdata      1      1      0
ip_fib_hash           10     59     64   59    1 : tunables  120   60    8 : slabdata      1      1      0
raid5-md3            256    261    824    9    2 : tunables   54   27    8 : slabdata     29     29      0
UNIX                   5     22    704   11    2 : tunables   54   27    8 : slabdata      2      2      0
xt_hashlimit           0      0     88   44    1 : tunables  120   60    8 : slabdata      0      0      0
flow_cache             0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
dm_snap_pending_exception    128    136    112   34    1 : tunables  120   60    8 : slabdata      4      4      0
dm_snap_exception      0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
dm_crypt_io            0      0     56   67    1 : tunables  120   60    8 : slabdata      0      0      0
dm_uevent              0      0   2608    3    2 : tunables   24   12    8 : slabdata      0      0      0
dm_target_io         827    864     24  144    1 : tunables  120   60    8 : slabdata      6      6      0
dm_io                826    828     40   92    1 : tunables  120   60    8 : slabdata      9      9      0
scsi_cmd_cache        50     50    384   10    1 : tunables   54   27    8 : slabdata      5      5      0
cfq_io_context        92    225    152   25    1 : tunables  120   60    8 : slabdata      9      9      0
cfq_queue             98    224    136   28    1 : tunables  120   60    8 : slabdata      8      8      0
bsg_cmd                0      0    312   12    1 : tunables   54   27    8 : slabdata      0      0      0
mqueue_inode_cache      1      4    896    4    1 : tunables   54   27    8 : slabdata      1      1      0
udf_inode_cache        0      0    656    6    1 : tunables   54   27    8 : slabdata      0      0      0
isofs_inode_cache      0      0    632    6    1 : tunables   54   27    8 : slabdata      0      0      0
fat_inode_cache        0      0    664    6    1 : tunables   54   27    8 : slabdata      0      0      0
fat_cache              0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
ext2_inode_cache       0      0    752    5    1 : tunables   54   27    8 : slabdata      0      0      0
journal_handle        32    144     24  144    1 : tunables  120   60    8 : slabdata      1      1      0
journal_head         129    200     96   40    1 : tunables  120   60    8 : slabdata      5      5      0
revoke_table          10    202     16  202    1 : tunables  120   60    8 : slabdata      1      1      0
revoke_record          0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
ext3_inode_cache  1235577 1240565    768    5    1 : tunables   54   27    8 : slabdata 248113 248113      0
dnotify_cache          0      0     40   92    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_event_cache      0      0     40   92    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_watch_cache      0      0     72   53    1 : tunables  120   60    8 : slabdata      0      0      0
kioctx                 0      0    320   12    1 : tunables   54   27    8 : slabdata      0      0      0
kiocb                  0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
fasync_cache           0      0     24  144    1 : tunables  120   60    8 : slabdata      0      0      0
shmem_inode_cache      6     15    776    5    1 : tunables   54   27    8 : slabdata      3      3      0
nsproxy                0      0     56   67    1 : tunables  120   60    8 : slabdata      0      0      0
posix_timers_cache      0      0    160   24    1 : tunables  120   60    8 : slabdata      0      0      0
uid_cache              1     15    256   15    1 : tunables  120   60    8 : slabdata      1      1      0
UDP-Lite               0      0    768    5    1 : tunables   54   27    8 : slabdata      0      0      0
tcp_bind_bucket        4    112     32  112    1 : tunables  120   60    8 : slabdata      1      1      0
inet_peer_cache        3     59     64   59    1 : tunables  120   60    8 : slabdata      1      1      0
secpath_cache          0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
xfrm_dst_cache         0      0    384   10    1 : tunables   54   27    8 : slabdata      0      0      0
ip_dst_cache          19     20    384   10    1 : tunables   54   27    8 : slabdata      2      2      0
arp_cache              5     15    256   15    1 : tunables  120   60    8 : slabdata      1      1      0
RAW                    3     11    704   11    2 : tunables   54   27    8 : slabdata      1      1      0
UDP                    3      5    768    5    1 : tunables   54   27    8 : slabdata      1      1      0
tw_sock_TCP            1     20    192   20    1 : tunables  120   60    8 : slabdata      1      1      0
request_sock_TCP       0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
TCP                    5     10   1536    5    2 : tunables   24   12    8 : slabdata      2      2      0
eventpoll_pwq          0      0     72   53    1 : tunables  120   60    8 : slabdata      0      0      0
eventpoll_epi          0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
sgpool-128             2      2   4096    1    1 : tunables   24   12    8 : slabdata      2      2      0
sgpool-64              2      2   2048    2    1 : tunables   24   12    8 : slabdata      1      1      0
sgpool-32              2      4   1024    4    1 : tunables   54   27    8 : slabdata      1      1      0
sgpool-16              2      8    512    8    1 : tunables   54   27    8 : slabdata      1      1      0
sgpool-8              45     45    256   15    1 : tunables  120   60    8 : slabdata      3      3      0
scsi_io_context        0      0    112   34    1 : tunables  120   60    8 : slabdata      0      0      0
blkdev_ioc            47    177     64   59    1 : tunables  120   60    8 : slabdata      3      3      0
blkdev_queue          22     25   1624    5    2 : tunables   24   12    8 : slabdata      5      5      0
blkdev_requests       42     78    288   13    1 : tunables   54   27    8 : slabdata      5      6      0
biovec-256            50     50   4096    1    1 : tunables   24   12    8 : slabdata     50     50      0
biovec-128            50     50   2048    2    1 : tunables   24   12    8 : slabdata     25     25      0
biovec-64             50     56   1024    4    1 : tunables   54   27    8 : slabdata     14     14      0
biovec-16             50     75    256   15    1 : tunables  120   60    8 : slabdata      5      5      0
biovec-4              66    118     64   59    1 : tunables  120   60    8 : slabdata      2      2      0
biovec-1             126    202     16  202    1 : tunables  120   60    8 : slabdata      1      1      0
bio                  180    180    128   30    1 : tunables  120   60    8 : slabdata      6      6      0
sock_inode_cache      25     40    704    5    1 : tunables   54   27    8 : slabdata      8      8      0
skbuff_fclone_cache     16     16    448    8    1 : tunables   54   27    8 : slabdata      2      2      0
skbuff_head_cache    345    435    256   15    1 : tunables  120   60    8 : slabdata     29     29      0
file_lock_cache        2     22    176   22    1 : tunables  120   60    8 : slabdata      1      1      0
Acpi-Operand        1406   1534     64   59    1 : tunables  120   60    8 : slabdata     26     26      0
Acpi-ParseExt          0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Parse             0      0     40   92    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-State             0      0     80   48    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Namespace       614    672     32  112    1 : tunables  120   60    8 : slabdata      6      6      0
proc_inode_cache     414    414    616    6    1 : tunables   54   27    8 : slabdata     69     69      0
sigqueue              33     48    160   24    1 : tunables  120   60    8 : slabdata      2      2      0
radix_tree_node    20128  24703    552    7    1 : tunables   54   27    8 : slabdata   3529   3529      0
bdev_cache            24     28    832    4    1 : tunables   54   27    8 : slabdata      7      7      0
sysfs_dir_cache     4446   4512     80   48    1 : tunables  120   60    8 : slabdata     94     94      0
mnt_cache             24     45    256   15    1 : tunables  120   60    8 : slabdata      3      3      0
inode_cache           64     77    584    7    1 : tunables   54   27    8 : slabdata     11     11      0
dentry            703661 749797    200   19    1 : tunables  120   60    8 : slabdata  39463  39463      0
filp                 330    600    192   20    1 : tunables  120   60    8 : slabdata     30     30      0
names_cache            1      1   4096    1    1 : tunables   24   12    8 : slabdata      1      1      0
idr_layer_cache      121    126    528    7    1 : tunables   54   27    8 : slabdata     18     18      0
buffer_head       174535 209087    104   37    1 : tunables  120   60    8 : slabdata   5651   5651      0
mm_struct             54     54    832    9    2 : tunables   54   27    8 : slabdata      6      6      0
vm_area_struct       913   1081    168   23    1 : tunables  120   60    8 : slabdata     47     47      0
fs_cache              45    177     64   59    1 : tunables  120   60    8 : slabdata      3      3      0
files_cache           46     77    704   11    2 : tunables   54   27    8 : slabdata      7      7      0
signal_cache          93     95    768    5    1 : tunables   54   27    8 : slabdata     19     19      0
sighand_cache         87     87   2112    3    2 : tunables   24   12    8 : slabdata     29     29      0
task_struct           89     92   1824    2    1 : tunables   24   12    8 : slabdata     46     46      0
anon_vma             358    576     24  144    1 : tunables  120   60    8 : slabdata      4      4      0
pid_namespace          0      0   2104    3    2 : tunables   24   12    8 : slabdata      0      0      0
pid_1                 95    180    128   30    1 : tunables  120   60    8 : slabdata      6      6      0
size-4194304(DMA)      0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-4194304           0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0
size-2097152(DMA)      0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-2097152           0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-1048576(DMA)      0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-1048576           0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-524288(DMA)       0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-524288            0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-262144(DMA)       0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-262144            0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-131072            0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-65536             0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-32768             0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-16384             9      9  16384    1    4 : tunables    8    4    0 : slabdata      9      9      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
size-8192              5      5   8192    1    2 : tunables    8    4    0 : slabdata      5      5      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    8 : slabdata      0      0      0
size-4096            121    121   4096    1    1 : tunables   24   12    8 : slabdata    121    121      0
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    8 : slabdata      0      0      0
size-2048            482    488   2048    2    1 : tunables   24   12    8 : slabdata    244    244      6
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
size-1024            364    384   1024    4    1 : tunables   54   27    8 : slabdata     96     96      0
size-512(DMA)          0      0    512    8    1 : tunables   54   27    8 : slabdata      0      0      0
size-512             213    224    512    8    1 : tunables   54   27    8 : slabdata     28     28      0
size-256(DMA)          0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
size-256              75     75    256   15    1 : tunables  120   60    8 : slabdata      5      5      0
size-192(DMA)          0      0    192   20    1 : tunables  120   60    8 : slabdata      0      0      0
size-192             279    320    192   20    1 : tunables  120   60    8 : slabdata     16     16      0
size-128(DMA)          0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
size-64(DMA)           0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
size-64           537590 850249     64   59    1 : tunables  120   60    8 : slabdata  14411  14411      0
size-32(DMA)           0      0     32  112    1 : tunables  120   60    8 : slabdata      0      0      0
size-128           46918  52140    128   30    1 : tunables  120   60    8 : slabdata   1738   1738      0
size-32             4756   4816     32  112    1 : tunables  120   60    8 : slabdata     43     43      0
kmem_cache           136    150    128   30    1 : tunables  120   60    8 : slabdata      5      5      0

--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=meminfo

MemTotal:      2058128 kB
MemFree:         56080 kB
Buffers:        689768 kB
Cached:          14240 kB
SwapCached:          0 kB
Active:         464176 kB
Inactive:       265096 kB
SwapTotal:     1048568 kB
SwapFree:      1048568 kB
Dirty:              48 kB
Writeback:           0 kB
AnonPages:       25432 kB
Mapped:           6820 kB
Slab:          1257136 kB
SReclaimable:  1173316 kB
SUnreclaim:      83820 kB
PageTables:        924 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   2077632 kB
Committed_AS:    50976 kB
VmallocTotal: 34359738367 kB
VmallocUsed:     66284 kB
VmallocChunk: 34359671799 kB

--dTy3Mrz/UPE2dbVg
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="config.gz"
Content-Transfer-Encoding: base64

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

--dTy3Mrz/UPE2dbVg--
