Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYHMKs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYHMKs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 06:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbYHMKsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 06:48:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56669 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbYHMKso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 06:48:44 -0400
Date: Wed, 13 Aug 2008 19:46:58 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: No, really, stop trying to delete slab until you've finished making slub perform as well
Cc: kosaki.motohiro@jp.fujitsu.com, KOSAKI Motohiro <m-kosaki@ceres.dti.ne.jp>,
       Matthew Wilcox <matthew@wil.cx>, Pekka Enberg <penberg@cs.helsinki.fi>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       andi@firstfloor.org, Rik van Riel <riel@redhat.com>
In-Reply-To: <48986AC6.5030406@linux-foundation.org>
References: <20080805210125.A897.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48986AC6.5030406@linux-foundation.org>
Message-Id: <20080813194222.E77F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well not sure if that tells us much. Please show us the output of
> /proc/meminfo after each run. The slab counters indicate how much memory is
> used by the slabs.
> 
> It would also be interesting to see the output of the slabinfo command after
> the slub run?

sorry for late responce.

slab use 123M vs slub use 1.5G

Thought?


<slab>

% cat /proc/meminfo
MemTotal:        7701760 kB
MemFree:         5940096 kB
Buffers:            6400 kB
Cached:            27712 kB
SwapCached:        52544 kB
Active:            51520 kB
Inactive:          53248 kB
Active(anon):      26752 kB
Inactive(anon):    41792 kB
Active(file):      24768 kB
Inactive(file):    11456 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       2031488 kB
SwapFree:        1958400 kB
Dirty:               192 kB
Writeback:             0 kB
AnonPages:         38400 kB
Mapped:            23232 kB
Slab:             123840 kB
SReclaimable:      30272 kB
SUnreclaim:        93568 kB
PageTables:        10688 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     5882368 kB
Committed_AS:     397568 kB
VmallocTotal:   17592177655808 kB
VmallocUsed:       29184 kB
VmallocChunk:   17592177626240 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:    262144 kB

% cat /proc/slabinfo
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
dm_mpath_io            0      0     40 1488    1 : tunables  120   60    8 : slabdata      0      0      0
dm_snap_tracked_chunk      0      0     24 2338    1 : tunables  120   60    8 : slabdata      0      0      0
dm_snap_pending_exception      0      0    112  564    1 : tunables  120   60    8 : slabdata      0      0      0
dm_snap_exception      0      0     32 1818    1 : tunables  120   60    8 : slabdata      0      0      0
kcopyd_job             0      0    408  158    1 : tunables   54   27    8 : slabdata      0      0      0
dm_target_io         515   2338     24 2338    1 : tunables  120   60    8 : slabdata      1      1      0
dm_io                515   1818     32 1818    1 : tunables  120   60    8 : slabdata      1      1      0
scsi_sense_cache      26    496    128  496    1 : tunables  120   60    8 : slabdata      1      1      0
scsi_cmd_cache        26    168    384  168    1 : tunables   54   27    8 : slabdata      1      1      0
uhci_urb_priv          0      0     56 1091    1 : tunables  120   60    8 : slabdata      0      0      0
flow_cache             0      0     96  654    1 : tunables  120   60    8 : slabdata      0      0      0
cfq_io_context        48    760    168  380    1 : tunables  120   60    8 : slabdata      2      2      0
cfq_queue             41    934    136  467    1 : tunables  120   60    8 : slabdata      2      2      0
mqueue_inode_cache      1     56   1152   56    1 : tunables   24   12    8 : slabdata      1      1      0
fat_inode_cache        1     77    840   77    1 : tunables   54   27    8 : slabdata      1      1      0
fat_cache              0      0     32 1818    1 : tunables  120   60    8 : slabdata      0      0      0
hugetlbfs_inode_cache      1     83    776   83    1 : tunables   54   27    8 : slabdata      1      1      0
ext2_inode_cache       0      0   1024   63    1 : tunables   54   27    8 : slabdata      0      0      0
ext2_xattr             0      0     88  711    1 : tunables  120   60    8 : slabdata      0      0      0
jbd2_journal_handle      0      0     24 2338    1 : tunables  120   60    8 : slabdata      0      0      0
jbd2_journal_head      0      0     96  654    1 : tunables  120   60    8 : slabdata      0      0      0
jbd2_revoke_table      0      0     16 3274    1 : tunables  120   60    8 : slabdata      0      0      0
jbd2_revoke_record      0      0     32 1818    1 : tunables  120   60    8 : slabdata      0      0      0
journal_handle        48   4676     24 2338    1 : tunables  120   60    8 : slabdata      2      2      0
journal_head          41   1308     96  654    1 : tunables  120   60    8 : slabdata      2      2      0
revoke_table           4   3274     16 3274    1 : tunables  120   60    8 : slabdata      1      1      0
revoke_record          0      0     32 1818    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_inode_cache       0      0   1192   54    1 : tunables   24   12    8 : slabdata      0      0      0
ext4_xattr             0      0     88  711    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_alloc_context      0      0    168  380    1 : tunables  120   60    8 : slabdata      0      0      0
ext4_prealloc_space      0      0    120  528    1 : tunables  120   60    8 : slabdata      0      0      0
ext3_inode_cache     367   5696   1016   64    1 : tunables   54   27    8 : slabdata     89     89      0
ext3_xattr            99   1422     88  711    1 : tunables  120   60    8 : slabdata      2      2      0
dnotify_cache          1   1488     40 1488    1 : tunables  120   60    8 : slabdata      1      1      0
kioctx                 0      0    384  168    1 : tunables   54   27    8 : slabdata      0      0      0
kiocb                  0      0    256  251    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_event_cache      0      0     40 1488    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_watch_cache      1    861     72  861    1 : tunables  120   60    8 : slabdata      1      1      0
fasync_cache           0      0     24 2338    1 : tunables  120   60    8 : slabdata      0      0      0
shmem_inode_cache    864   1105   1000   65    1 : tunables   54   27    8 : slabdata     17     17      0
pid_namespace          0      0    184  348    1 : tunables  120   60    8 : slabdata      0      0      0
nsproxy                0      0     56 1091    1 : tunables  120   60    8 : slabdata      0      0      0
posix_timers_cache      0      0    184  348    1 : tunables  120   60    8 : slabdata      0      0      0
uid_cache              6    502    256  251    1 : tunables  120   60    8 : slabdata      2      2      0
ia64_partial_page_cache      0      0     48 1259    1 : tunables  120   60    8 : slabdata      0      0      0
UNIX                  32    126   1024   63    1 : tunables   54   27    8 : slabdata      2      2      0
UDP-Lite               0      0   1024   63    1 : tunables   54   27    8 : slabdata      0      0      0
tcp_bind_bucket        4   1924     64  962    1 : tunables  120   60    8 : slabdata      2      2      0
inet_peer_cache        0      0     64  962    1 : tunables  120   60    8 : slabdata      0      0      0
secpath_cache          0      0     64  962    1 : tunables  120   60    8 : slabdata      0      0      0
xfrm_dst_cache         0      0    384  168    1 : tunables   54   27    8 : slabdata      0      0      0
ip_fib_alias           3   1818     32 1818    1 : tunables  120   60    8 : slabdata      1      1      0
ip_fib_hash           15   1722     72  861    1 : tunables  120   60    8 : slabdata      2      2      0
ip_dst_cache          50    336    384  168    1 : tunables   54   27    8 : slabdata      2      2      0
arp_cache              1    251    256  251    1 : tunables  120   60    8 : slabdata      1      1      0
RAW                  129    216    896   72    1 : tunables   54   27    8 : slabdata      3      3      0
UDP                    9    126   1024   63    1 : tunables   54   27    8 : slabdata      2      2      0
tw_sock_TCP            0      0    256  251    1 : tunables  120   60    8 : slabdata      0      0      0
request_sock_TCP       0      0    128  496    1 : tunables  120   60    8 : slabdata      0      0      0
TCP                    5     72   1792   36    1 : tunables   24   12    8 : slabdata      2      2      0
eventpoll_pwq          0      0     72  861    1 : tunables  120   60    8 : slabdata      0      0      0
eventpoll_epi          0      0    128  496    1 : tunables  120   60    8 : slabdata      0      0      0
sgpool-128             2     30   4096   15    1 : tunables   24   12    8 : slabdata      2      2      0
sgpool-64              2     62   2048   31    1 : tunables   24   12    8 : slabdata      2      2      0
sgpool-32              2    126   1024   63    1 : tunables   54   27    8 : slabdata      2      2      0
sgpool-16              2    252    512  126    1 : tunables   54   27    8 : slabdata      2      2      0
sgpool-8              18    502    256  251    1 : tunables  120   60    8 : slabdata      2      2      0
scsi_data_buffer       0      0     24 2338    1 : tunables  120   60    8 : slabdata      0      0      0
scsi_io_context        0      0    112  564    1 : tunables  120   60    8 : slabdata      0      0      0
blkdev_queue          26     70   1864   35    1 : tunables   24   12    8 : slabdata      2      2      0
blkdev_requests       44    212    304  212    1 : tunables   54   27    8 : slabdata      1      1      0
blkdev_ioc            38   1308     96  654    1 : tunables  120   60    8 : slabdata      2      2      0
biovec-256            34     60   4096   15    1 : tunables   24   12    8 : slabdata      4      4      0
biovec-128            34     93   2048   31    1 : tunables   24   12    8 : slabdata      3      3      0
biovec-64             34    126   1024   63    1 : tunables   54   27    8 : slabdata      2      2      0
biovec-16             34    502    256  251    1 : tunables  120   60    8 : slabdata      2      2      0
biovec-4              34   1924     64  962    1 : tunables  120   60    8 : slabdata      2      2      0
biovec-1              37   6548     16 3274    1 : tunables  120   60    8 : slabdata      2      2      0
bio                   37    992    128  496    1 : tunables  120   60    8 : slabdata      2      2      0
sock_inode_cache     188    288    896   72    1 : tunables   54   27    8 : slabdata      4      4      0
skbuff_fclone_cache     16    126    512  126    1 : tunables   54   27    8 : slabdata      1      1      0
skbuff_head_cache   1812  11546    256  251    1 : tunables  120   60    8 : slabdata     46     46      0
file_lock_cache        4    668    192  334    1 : tunables  120   60    8 : slabdata      2      2      0
Acpi-Operand       24947  26691     72  861    1 : tunables  120   60    8 : slabdata     31     31      0
Acpi-ParseExt          0      0     72  861    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Parse             0      0     48 1259    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-State             0      0     80  779    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Namespace     18877  21816     32 1818    1 : tunables  120   60    8 : slabdata     12     12      0
page_cgroup         1183 142848     40 1488    1 : tunables  120   60    8 : slabdata     96     96      0
proc_inode_cache     197    902    792   82    1 : tunables   54   27    8 : slabdata     11     11      0
sigqueue               0      0    160  399    1 : tunables  120   60    8 : slabdata      0      0      0
radix_tree_node      719   7254    552  117    1 : tunables   54   27    8 : slabdata     62     62      0
bdev_cache            30    126   1024   63    1 : tunables   54   27    8 : slabdata      2      2      0
sysfs_dir_cache    11089  12464     80  779    1 : tunables  120   60    8 : slabdata     16     16      0
mnt_cache             24    502    256  251    1 : tunables  120   60    8 : slabdata      2      2      0
inode_cache           54    696    744   87    1 : tunables   54   27    8 : slabdata      8      8      0
dentry              1577  17794    224  287    1 : tunables  120   60    8 : slabdata     62     62      0
filp                 706   3765    256  251    1 : tunables  120   60    8 : slabdata     15     15      0
names_cache           46    105   4096   15    1 : tunables   24   12    8 : slabdata      7      7      0
buffer_head         3557 125442    104  606    1 : tunables  120   60    8 : slabdata    207    207      0
mm_struct             76    288    896   72    1 : tunables   54   27    8 : slabdata      4      4      0
vm_area_struct      1340   2178    176  363    1 : tunables  120   60    8 : slabdata      6      6     36
fs_cache              61    992    128  496    1 : tunables  120   60    8 : slabdata      2      2      0
files_cache           62    336    768   84    1 : tunables   54   27    8 : slabdata      4      4      0
signal_cache         161    588    768   84    1 : tunables   54   27    8 : slabdata      7      7      0
sighand_cache        157    390   1664   39    1 : tunables   24   12    8 : slabdata     10     10      0
anon_vma             657   2976     40 1488    1 : tunables  120   60    8 : slabdata      2      2      0
pid                  160    992    128  496    1 : tunables  120   60    8 : slabdata      2      2      0
shared_policy_node      0      0     48 1259    1 : tunables  120   60    8 : slabdata      0      0      0
numa_policy            7    244    264  244    1 : tunables   54   27    8 : slabdata      1      1      0
idr_layer_cache      150    476    544  119    1 : tunables   54   27    8 : slabdata      4      4      0
size-33554432(DMA)      0      0 33554432    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-33554432          0      0 33554432    1  512 : tunables    1    1    0 : slabdata      0      0      0
size-16777216(DMA)      0      0 16777216    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-16777216          0      0 16777216    1  256 : tunables    1    1    0 : slabdata      0      0      0
size-8388608(DMA)      0      0 8388608    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-8388608           0      0 8388608    1  128 : tunables    1    1    0 : slabdata      0      0      0
size-4194304(DMA)      0      0 4194304    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-4194304           0      0 4194304    1   64 : tunables    1    1    0 : slabdata      0      0      0
size-2097152(DMA)      0      0 2097152    1   32 : tunables    1    1    0 : slabdata      0      0      0
size-2097152           0      0 2097152    1   32 : tunables    1    1    0 : slabdata      0      0      0
size-1048576(DMA)      0      0 1048576    1   16 : tunables    1    1    0 : slabdata      0      0      0
size-1048576           0      0 1048576    1   16 : tunables    1    1    0 : slabdata      0      0      0
size-524288(DMA)       0      0 524288    1    8 : tunables    1    1    0 : slabdata      0      0      0
size-524288            0      0 524288    1    8 : tunables    1    1    0 : slabdata      0      0      0
size-262144(DMA)       0      0 262144    1    4 : tunables    1    1    0 : slabdata      0      0      0
size-262144            0      0 262144    1    4 : tunables    1    1    0 : slabdata      0      0      0
size-131072(DMA)       0      0 131072    1    2 : tunables    8    4    0 : slabdata      0      0      0
size-131072            1      1 131072    1    2 : tunables    8    4    0 : slabdata      1      1      0
size-65536(DMA)        0      0  65536    1    1 : tunables   24   12    8 : slabdata      0      0      0
size-65536             4      4  65536    1    1 : tunables   24   12    8 : slabdata      4      4      0
size-32768(DMA)        0      0  32768    2    1 : tunables   24   12    8 : slabdata      0      0      0
size-32768            12     14  32768    2    1 : tunables   24   12    8 : slabdata      7      7      0
size-16384(DMA)        0      0  16384    4    1 : tunables   24   12    8 : slabdata      0      0      0
size-16384            15     28  16384    4    1 : tunables   24   12    8 : slabdata      7      7      0
size-8192(DMA)         0      0   8192    8    1 : tunables   24   12    8 : slabdata      0      0      0
size-8192           2455   2472   8192    8    1 : tunables   24   12    8 : slabdata    309    309      0
size-4096(DMA)         0      0   4096   15    1 : tunables   24   12    8 : slabdata      0      0      0
size-4096           1607   1665   4096   15    1 : tunables   24   12    8 : slabdata    111    111      0
size-2048(DMA)         0      0   2048   31    1 : tunables   24   12    8 : slabdata      0      0      0
size-2048           2706   2914   2048   31    1 : tunables   24   12    8 : slabdata     94     94      0
size-1024(DMA)         0      0   1024   63    1 : tunables   54   27    8 : slabdata      0      0      0
size-1024           2414   2583   1024   63    1 : tunables   54   27    8 : slabdata     41     41      0
size-512(DMA)          0      0    512  126    1 : tunables   54   27    8 : slabdata      0      0      0
size-512            1805   2142    512  126    1 : tunables   54   27    8 : slabdata     17     17      0
size-256(DMA)          0      0    256  251    1 : tunables  120   60    8 : slabdata      0      0      0
size-256           44889  48945    256  251    1 : tunables  120   60    8 : slabdata    195    195      0
size-128(DMA)          0      0    128  496    1 : tunables  120   60    8 : slabdata      0      0      0
size-64(DMA)           0      0     64  962    1 : tunables  120   60    8 : slabdata      0      0      0
size-128           28119  30256    128  496    1 : tunables  120   60    8 : slabdata     61     61      0
size-64            14597  22126     64  962    1 : tunables  120   60    8 : slabdata     23     23      0
kmem_cache           151    155  12416    5    1 : tunables   24   12    8 : slabdata     31     31      0


<SLUB>

% cat /proc/meminfo
MemTotal:        7701376 kB
MemFree:         4740928 kB
Buffers:            4544 kB
Cached:            35584 kB
SwapCached:            0 kB
Active:           119104 kB
Inactive:           9920 kB
Active(anon):      90240 kB
Inactive(anon):        0 kB
Active(file):      28864 kB
Inactive(file):     9920 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       2031488 kB
SwapFree:        2031488 kB
Dirty:                64 kB
Writeback:             0 kB
AnonPages:         89152 kB
Mapped:            31232 kB
Slab:            1591680 kB
SReclaimable:      12608 kB
SUnreclaim:      1579072 kB
PageTables:        11904 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     5882176 kB
Committed_AS:     446848 kB
VmallocTotal:   17592177655808 kB
VmallocUsed:       29056 kB
VmallocChunk:   17592177626432 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:    262144 kB

% cat /proc/slabinfo
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
kcopyd_job             0      0    408  160    1 : tunables    0    0    0 : slabdata      0      0      0
cfq_io_context      3120   3120    168  390    1 : tunables    0    0    0 : slabdata      8      8      0
cfq_queue           3848   3848    136  481    1 : tunables    0    0    0 : slabdata      8      8      0
mqueue_inode_cache     56     56   1152   56    1 : tunables    0    0    0 : slabdata      1      1      0
fat_inode_cache       77     77    848   77    1 : tunables    0    0    0 : slabdata      1      1      0
fat_cache              0      0     40 1638    1 : tunables    0    0    0 : slabdata      0      0      0
hugetlbfs_inode_cache     83     83    784   83    1 : tunables    0    0    0 : slabdata      1      1      0
ext2_inode_cache       0      0   1032   63    1 : tunables    0    0    0 : slabdata      0      0      0
journal_handle     21840  21840     24 2730    1 : tunables    0    0    0 : slabdata      8      8      0
journal_head        4774   4774     96  682    1 : tunables    0    0    0 : slabdata      7      7      0
revoke_table        4096   4096     16 4096    1 : tunables    0    0    0 : slabdata      1      1      0
revoke_record       2048   2048     32 2048    1 : tunables    0    0    0 : slabdata      1      1      0
ext4_inode_cache       0      0   1200   54    1 : tunables    0    0    0 : slabdata      0      0      0
ext4_alloc_context      0      0    168  390    1 : tunables    0    0    0 : slabdata      0      0      0
ext4_prealloc_space      0      0    120  546    1 : tunables    0    0    0 : slabdata      0      0      0
ext3_inode_cache     750   2624   1024   64    1 : tunables    0    0    0 : slabdata     41     41      0
ext3_xattr          4464   4464     88  744    1 : tunables    0    0    0 : slabdata      6      6      0
shmem_inode_cache   1256   1365   1008   65    1 : tunables    0    0    0 : slabdata     21     21      0
nsproxy                0      0     56 1170    1 : tunables    0    0    0 : slabdata      0      0      0
posix_timers_cache      0      0    184  356    1 : tunables    0    0    0 : slabdata      0      0      0
ip_dst_cache        1360   1360    384  170    1 : tunables    0    0    0 : slabdata      8      8      0
TCP                  180    180   1792   36    1 : tunables    0    0    0 : slabdata      5      5      0
scsi_data_buffer   21840  21840     24 2730    1 : tunables    0    0    0 : slabdata      8      8      0
scsi_io_context        0      0    112  585    1 : tunables    0    0    0 : slabdata      0      0      0
blkdev_queue         140    140   1864   70    2 : tunables    0    0    0 : slabdata      2      2      0
blkdev_requests     1720   1720    304  215    1 : tunables    0    0    0 : slabdata      8      8      0
sock_inode_cache     758    949    896   73    1 : tunables    0    0    0 : slabdata     13     13      0
file_lock_cache     2289   2289    200  327    1 : tunables    0    0    0 : slabdata      7      7      0
Acpi-ParseExt      29117  29120     72  910    1 : tunables    0    0    0 : slabdata     32     32      0
page_cgroup        14660  24570     40 1638    1 : tunables    0    0    0 : slabdata     15     15      0
proc_inode_cache     732    810    800   81    1 : tunables    0    0    0 : slabdata     10     10      0
sigqueue            3272   3272    160  409    1 : tunables    0    0    0 : slabdata      8      8      0
radix_tree_node     1200   1755    560  117    1 : tunables    0    0    0 : slabdata     15     15      0
bdev_cache           256    256   1024   64    1 : tunables    0    0    0 : slabdata      4      4      0
sysfs_dir_cache    16376  16380     80  819    1 : tunables    0    0    0 : slabdata     20     20      0
inode_cache          707    957    752   87    1 : tunables    0    0    0 : slabdata     11     11      0
dentry              3503  11096    224  292    1 : tunables    0    0    0 : slabdata     38     38      0
buffer_head         6920  23985    112  585    1 : tunables    0    0    0 : slabdata     41     41      0
mm_struct            741   1022    896   73    1 : tunables    0    0    0 : slabdata     14     14      0
vm_area_struct      4015   5208    176  372    1 : tunables    0    0    0 : slabdata     14     14      0
signal_cache         801   1020    768   85    1 : tunables    0    0    0 : slabdata     12     12      0
sighand_cache        433    546   1664   39    1 : tunables    0    0    0 : slabdata     14     14      0
anon_vma           10920  10920     48 1365    1 : tunables    0    0    0 : slabdata      8      8      0
shared_policy_node   5460   5460     48 1365    1 : tunables    0    0    0 : slabdata      4      4      0
numa_policy          248    248    264  248    1 : tunables    0    0    0 : slabdata      1      1      0
idr_layer_cache      944    944    552  118    1 : tunables    0    0    0 : slabdata      8      8      0
kmalloc-65536         32     32  65536    4    4 : tunables    0    0    0 : slabdata      8      8      0
kmalloc-32768        128    128  32768   16    8 : tunables    0    0    0 : slabdata      8      8      0
kmalloc-16384        160    160  16384   32    8 : tunables    0    0    0 : slabdata      5      5      0
kmalloc-8192         448    448   8192   64    8 : tunables    0    0    0 : slabdata      7      7      0
kmalloc-4096         819  14336   4096   64    4 : tunables    0    0    0 : slabdata    224    224      0
kmalloc-2048        2409   8384   2048   64    2 : tunables    0    0    0 : slabdata    131    131      0
kmalloc-1024        1848  14912   1024   64    1 : tunables    0    0    0 : slabdata    233    233      0
kmalloc-512         2306   2432    512  128    1 : tunables    0    0    0 : slabdata     19     19      0
kmalloc-256        13919 123904    256  256    1 : tunables    0    0    0 : slabdata    484    484      0
kmalloc-128        28739 10747904    128  512    1 : tunables    0    0    0 : slabdata  20992  20992      0
kmalloc-64         10224  10240     64 1024    1 : tunables    0    0    0 : slabdata     10     10      0
kmalloc-32         34806  34816     32 2048    1 : tunables    0    0    0 : slabdata     17     17      0
kmalloc-16         32768  32768     16 4096    1 : tunables    0    0    0 : slabdata      8      8      0
kmalloc-8          65536  65536      8 8192    1 : tunables    0    0    0 : slabdata      8      8      0
kmalloc-192         4609 447051    192  341    1 : tunables    0    0    0 : slabdata   1311   1311      0
kmalloc-96          5456   5456     96  682    1 : tunables    0    0    0 : slabdata      8      8      0
kmem_cache_node     3276   3276     80  819    1 : tunables    0    0    0 : slabdata      4      4      0

% slabinfo
Name                   Objects Objsize    Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
:at-0000016               4096      16    65.5K          0/0/1 4096 0   0 100 *a
:at-0000024              21840      24   524.2K          0/0/8 2730 0   0  99 *a
:at-0000032               2048      32    65.5K          0/0/1 2048 0   0 100 *Aa
:at-0000088               4464      88   393.2K          0/0/6  744 0   0  99 *a
:at-0000096               4774      96   458.7K          0/0/7  682 0   0  99 *a
:t-0000016               32768      16   524.2K          0/0/8 4096 0   0 100 *
:t-0000024               21840      24   524.2K          0/0/8 2730 0   0  99 *
:t-0000032               34806      32     1.1M          9/1/8 2048 0   5  99 *
:t-0000040               14660      40   983.0K          7/7/8 1638 0  46  59 *
:t-0000048                5460      48   262.1K          0/0/4 1365 0   0  99 *
:t-0000064               10224      64   655.3K          2/1/8 1024 0  10  99 *
:t-0000072               29117      72     2.0M         26/2/6  910 0   6  99 *
:t-0000080               16376      80     1.3M         12/1/8  819 0   5  99 *
:t-0000096                5456      96   524.2K          0/0/8  682 0   0  99 *
:t-0000128               28739     128     1.3G  20984/20984/8  512 0  99   0 *
:t-0000256               15285     256    31.7M      476/438/8  256 0  90  12 *
:t-0000384                1360     352   524.2K          0/0/8  170 0   0  91 *A
:t-0000512                2306     512     1.2M         11/3/8  128 0  15  94 *
:t-0000768                 801     768   786.4K          4/4/8   85 0  33  78 *A
:t-0000896                 741     880   917.5K          6/5/8   73 0  35  71 *A
:t-0001024                1848    1024    15.2M      225/214/8   64 0  91  12 *
:t-0002048                2406    2048    17.1M      123/115/8   64 1  87  28 *
:t-0004096                 819    4096    58.7M      216/216/8   64 2  96   5 *
anon_vma                 10920      40   524.2K          0/0/8 1365 0   0  83
bdev_cache                 256    1008   262.1K          0/0/4   64 0   0  98 Aa
blkdev_queue               140    1864   262.1K          0/0/2   70 1   0  99
blkdev_requests           1720     304   524.2K          0/0/8  215 0   0  99
buffer_head               7493     104     2.6M        33/32/8  585 0  78  29 a
cfq_io_context            3120     168   524.2K          0/0/8  390 0   0  99
cfq_queue                 3848     136   524.2K          0/0/8  481 0   0  99
dentry                    3793     224     2.4M        30/29/8  292 0  76  34 a
ext3_inode_cache           750    1016     2.6M        33/33/8   64 0  80  28 a
fat_inode_cache             77     840    65.5K          0/0/1   77 0   0  98 a
file_lock_cache           2289     192   458.7K          0/0/7  327 0   0  95
hugetlbfs_inode_cache       83     776    65.5K          0/0/1   83 0   0  98
idr_layer_cache            944     544   524.2K          0/0/8  118 0   0  97
inode_cache               1044     744   786.4K          4/0/8   87 0   0  98 a
kmalloc-16384              160   16384     2.6M          0/0/5   32 3   0 100
kmalloc-192               4609     192    85.9M    1303/1303/8  341 0  99   1
kmalloc-32768              128   32768     4.1M          0/0/8   16 3   0 100
kmalloc-65536               32   65536     2.0M          0/0/8    4 2   0 100
kmalloc-8                65536       8   524.2K          0/0/8 8192 0   0 100
kmalloc-8192               448    8192     3.6M          0/0/7   64 3   0 100
kmem_cache_node           3276      80   262.1K          0/0/4  819 0   0  99 *
mqueue_inode_cache          56    1064    65.5K          0/0/1   56 0   0  90 A
numa_policy                248     264    65.5K          0/0/1  248 0   0  99
proc_inode_cache           732     792   655.3K          2/1/8   81 0  10  88 a
radix_tree_node           1200     552   983.0K          7/7/8  117 0  46  67 a
shmem_inode_cache         1256    1000     1.3M         13/4/8   65 0  19  91
sighand_cache              433    1608   917.5K          6/4/8   39 0  28  75 A
sigqueue                  3272     160   524.2K          0/0/8  409 0   0  99
sock_inode_cache           758     832   851.9K          5/4/8   73 0  30  74 Aa
TCP                        180    1712   327.6K          0/0/5   36 0   0  94 A
vm_area_struct            4015     176   917.5K          6/6/8  372 0  42  77







