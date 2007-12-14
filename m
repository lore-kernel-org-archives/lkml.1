Return-Path: <linux-kernel-owner+w=401wt.eu-S934093AbXLNQRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934093AbXLNQRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 11:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765661AbXLNQRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 11:17:04 -0500
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:41074 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933978AbXLNQQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 11:16:58 -0500
Date: Fri, 14 Dec 2007 21:46:37 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Greg KH <gregkh@suse.de>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Gautham Shenoy <ego@in.ibm.com>
Subject: Re: 2.6.22-stable causes oomkiller to be invoked
Message-ID: <20071214161637.GA2687@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071213123333.GA16905@linux.vnet.ibm.com> <20071213132326.GC16905@linux.vnet.ibm.com> <20071213151847.GB5676@linux.vnet.ibm.com> <20071213162936.GA7635@suse.de> <20071213164658.GA30865@linux.vnet.ibm.com> <20071213175423.GA2977@linux.vnet.ibm.com> <476295FF.1040202@gmail.com> <20071214154711.GD23670@linux.vnet.ibm.com> <4762A721.7080400@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <4762A721.7080400@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Dec 15, 2007 at 12:54:09AM +0900, Tejun Heo wrote:
> Dhaval Giani wrote:
> > XXX sysfs_page_cnt=1
> 
> Hmm.. so, sysfs r/w buffer wasn't the culprit.  I'm curious what eats up
> all your low memory.  Please do the following.
> 
> 1. Right after boot, record /proc/meminfo and slabinfo.
> 
> 2. After or near OOM, record /proc/meminfo and slabinfo.  This can be
> tricky but if your machine reliably OOMs after 10mins, run it for 9mins
> and capturing the result should show enough.
> 

Attached. The results are after oom, but i think about a min or so after
that. I missed the oom point.

-- 
regards,
Dhaval

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=meminfo-boot

MemTotal:      4733060 kB
MemFree:       4674320 kB
Buffers:          2944 kB
Cached:          17732 kB
SwapCached:          0 kB
Active:          11440 kB
Inactive:        12776 kB
HighTotal:     3956692 kB
HighFree:      3931172 kB
LowTotal:       776368 kB
LowFree:        743148 kB
SwapTotal:     1863532 kB
SwapFree:      1863532 kB
Dirty:             260 kB
Writeback:           0 kB
AnonPages:        3596 kB
Mapped:           3356 kB
Slab:            14032 kB
SReclaimable:     7144 kB
SUnreclaim:       6888 kB
PageTables:        504 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   4230060 kB
Committed_AS:    12312 kB
VmallocTotal:   118776 kB
VmallocUsed:      1120 kB
VmallocChunk:   117652 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:     2048 kB

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=meminfo-oom

MemTotal:      4733060 kB
MemFree:       3948352 kB
Buffers:           464 kB
Cached:           9876 kB
SwapCached:          0 kB
Active:           7084 kB
Inactive:         5520 kB
HighTotal:     3956692 kB
HighFree:      3939884 kB
LowTotal:       776368 kB
LowFree:          8468 kB
SwapTotal:     1863532 kB
SwapFree:      1863532 kB
Dirty:             268 kB
Writeback:           0 kB
AnonPages:        2348 kB
Mapped:           2508 kB
Slab:             8352 kB
SReclaimable:     1548 kB
SUnreclaim:       6804 kB
PageTables:        408 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   4230060 kB
Committed_AS:     7376 kB
VmallocTotal:   118776 kB
VmallocUsed:      1120 kB
VmallocChunk:   117652 kB
HugePages_Total:     0
HugePages_Free:      0
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:     2048 kB

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=slabinfo-boot

slabinfo - version: 2.1 (statistics)
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail> : globalstat <listallocs> <maxobjs> <grown> <reaped> <error> <maxfreeable> <nodeallocs> <remotefrees> <alienoverflow> : cpustat <allochit> <allocmiss> <freehit> <freemiss>
UNIX                  10     25    744    5    1 : tunables   32   16    8 : slabdata      5      5      0 : globalstat     294    100    27   22 				   0    0    0    0    0 : cpustat   5457     45   5487      5
flow_cache             0      0    104   37    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
dm_target_io           0      0     40   92    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
dm_io                  0      0     48   78    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
scsi_cmd_cache        21     39    304   13    1 : tunables   32   16    8 : slabdata      3      3      0 : globalstat     378    104    12    9 				   0    0    0    0    0 : cpustat   1921     42   1946     15
cfq_io_context         0      0    112   35    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
cfq_queue              0      0    112   35    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
mqueue_inode_cache      1      5    800    5    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat       5      5     1    0 				   0    0    0    0    0 : cpustat      0      1      0      0
cifs_small_rq         30     32    472    8    1 : tunables   32   16    8 : slabdata      4      4      0 : globalstat      32     32     4    0 				   0    0    0    0    0 : cpustat     26      4      0      0
cifs_request           4      4  16496    1    8 : tunables    8    4    0 : slabdata      4      4      0 : globalstat       4      4     4    0 				   0    0    0    0    0 : cpustat      0      4      0      0
cifs_oplock_structs      0      0     48   78    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
cifs_mpx_ids           3     59     64   59    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      16     16     1    0 				   0    0    0    0    0 : cpustat      2      1      0      0
cifs_inode_cache       0      0    616    6    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
smb_request            0      0    296   13    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
smb_inode_cache        0      0    600    6    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
isofs_inode_cache      0      0    608    6    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
fat_inode_cache        0      0    656    6    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
fat_cache              0      0     48   78    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
hugetlbfs_inode_cache      1      7    576    7    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat       7      7     1    0 				   0    0    0    0    0 : cpustat      0      1      0      0
ext2_inode_cache       0      0    832    4    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
ext2_xattr             0      0     72   53    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
journal_handle        32     67     56   67    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat     283    115     4    3 				   0    0    0    0    0 : cpustat   1274     19   1293      0
journal_head          73    144     80   48    1 : tunables   32   16    8 : slabdata      2      3      0 : globalstat     579    288     7    4 				   0    0    0    0    0 : cpustat    695     51    655     30
revoke_table           6     92     40   92    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      32     18     1    0 				   0    0    0    0    0 : cpustat      4      2      0      0
revoke_record          0      0     40   92    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat      16     16     1    1 				   0    0    0    0    0 : cpustat      1      1      2      0
ext3_inode_cache    1944   1945    816    5    1 : tunables   32   16    8 : slabdata    389    389      0 : globalstat    2000   1945   389    0 				   0    0    0    0    0 : cpustat   1546    399     16      0
ext3_xattr             0      0     72   53    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
reiser_inode_cache      0      0    760    5    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
configfs_dir_cache      0      0     80   48    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
dnotify_cache          0      0     48   78    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
inotify_event_cache      0      0     56   67    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
inotify_watch_cache      0      0     64   59    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
kioctx                 0      0    272   14    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
kiocb                  0      0    160   24    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
fasync_cache           0      0     40   92    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
shmem_inode_cache    831    913    696   11    2 : tunables   32   16    8 : slabdata     83     83      0 : globalstat    1042    913    83    0 				   0    0    0    0    0 : cpustat    781     94     44      0
nsproxy                0      0     56   67    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
posix_timers_cache      0      0    144   27    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
uid_cache              3     53     72   53    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      32     19     1    0 				   0    0    0    0    0 : cpustat      2      2      1      0
UDP-Lite               0      0    736    5    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
tcp_bind_bucket        4     92     40   92    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      16     16     1    0 				   0    0    0    0    0 : cpustat      3      1      0      0
inet_peer_cache        0      0     72   53    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
secpath_cache          0      0     56   67    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
xfrm_dst_cache         0      0    280   14    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
ip_fib_alias          10     78     48   78    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      32     25     1    0 				   0    0    0    0    0 : cpustat      8      2      0      0
ip_fib_hash           10     78     48   78    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      32     25     1    0 				   0    0    0    0    0 : cpustat      8      2      0      0
ip_dst_cache          13     30    256   15    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat      59     30     2    0 				   0    0    0    0    0 : cpustat     10      5      2      0
arp_cache              4     19    208   19    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      32     19     1    0 				   0    0    0    0    0 : cpustat      2      2      0      0
RAW                    9     11    712   11    2 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      24     22     2    1 				   0    0    0    0    0 : cpustat     11      3      5      0
UDP                    5     10    736    5    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat      43     25     7    5 				   0    0    0    0    0 : cpustat     16      9     20      0
tw_sock_TCP            0      0    128   30    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
request_sock_TCP       0      0     96   40    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat      16     16     1    1 				   0    0    0    0    0 : cpustat      0      1      1      0
TCP                    7     10   1448    5    2 : tunables   24   12    8 : slabdata      2      2      0 : globalstat      39     20     4    2 				   0    0    0    0    0 : cpustat     14      7     14      0
eventpoll_pwq          0      0     64   59    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
eventpoll_epi          0      0     96   40    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
sgpool-128             2      3   2584    3    2 : tunables   24   12    8 : slabdata      1      1      0 : globalstat      11      6     2    1 				   0    0    0    0    0 : cpustat     27      4     29      0
sgpool-64              2      3   1304    3    1 : tunables   24   12    8 : slabdata      1      1      0 : globalstat       6      3     1    0 				   0    0    0    0    0 : cpustat     15      4     17      0
sgpool-32              2      6    664    6    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      46     24     4    3 				   0    0    0    0    0 : cpustat     77      8     83      0
sgpool-16              2     11    344   11    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      74     22     2    1 				   0    0    0    0    0 : cpustat     56      8     62      0
sgpool-8              21     42    184   21    1 : tunables   32   16    8 : slabdata      1      2      0 : globalstat     395    105     7    5 				   0    0    0    0    0 : cpustat   1700     48   1729     17
scsi_io_context        0      0    128   30    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
blkdev_ioc            32    134     56   67    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat     275     85     2    0 				   0    0    0    0    0 : cpustat    186     18    187      0
blkdev_queue          33     33   1256    3    1 : tunables   24   12    8 : slabdata     11     11      0 : globalstat      38     36    12    1 				   0    0    0    0    0 : cpustat     42     14     23      0
blkdev_requests       53     90    216   18    1 : tunables   32   16    8 : slabdata      3      5      0 : globalstat     490    142    12    7 				   0    0    0    0    0 : cpustat   2029     60   2031     22
biovec-256             2      2   3096    2    2 : tunables   24   12    8 : slabdata      1      1      0 : globalstat       2      2     1    0 				   0    0    0    0    0 : cpustat      1      1      0      0
biovec-128             2      5   1560    5    2 : tunables   24   12    8 : slabdata      1      1      0 : globalstat       5      5     1    0 				   0    0    0    0    0 : cpustat      1      1      0      0
biovec-64              2      5    792    5    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      65     35     7    6 				   0    0    0    0    0 : cpustat    299     11    308      0
biovec-16              2     18    216   18    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat     176     70     5    4 				   0    0    0    0    0 : cpustat    448     13    458      1
biovec-4               2     53     72   53    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat     219     85     2    1 				   0    0    0    0    0 : cpustat    548     27    560     13
biovec-1              21     92     40   92    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat    2342    568     7    2 				   0    1    0    0    0 : cpustat   8280    327   8314    291
bio                   17     80     96   40    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat    2331    552    17    6 				   0    2    0    0    0 : cpustat   9594    353   9631    314
sock_inode_cache      40     66    640    6    1 : tunables   32   16    8 : slabdata     10     11      0 : globalstat     257     96    24   13 				   0    0    0    0    0 : cpustat   3420     34   3414      0
skbuff_fclone_cache      5     22    360   11    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat      40     22     2    0 				   0    0    0    0    0 : cpustat     40      4     43      0
skbuff_head_cache    212    260    192   20    1 : tunables   32   16    8 : slabdata     13     13      0 : globalstat     720    316    19    6 				   0    0    0    0    0 : cpustat   5317    101   5175     43
file_lock_cache        2     27    144   27    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat     685    162     8    7 				   0    0    0    0    0 : cpustat  16483     47  16527      1
Acpi-Operand        1396   1475     64   59    1 : tunables   32   16    8 : slabdata     25     25      0 : globalstat    1455   1432    25    0 				   0    0    0    0    0 : cpustat  14553    100  13256      1
Acpi-ParseExt          0      0     72   53    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat     101     69     3    1 				   0    0    0    0    0 : cpustat   5435      9   5441      3
Acpi-Parse             0      0     56   67    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat      96     64     2    1 				   0    0    0    0    0 : cpustat  23403     11  23408      6
Acpi-State             0      0     72   53    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat     117     69     3    2 				   0    0    0    0    0 : cpustat  31506     23  31513     16
Acpi-Namespace       999   1014     48   78    1 : tunables   32   16    8 : slabdata     13     13      0 : globalstat    1014   1014    13    0 				   0    0    0    0    0 : cpustat   1181     65    247      0
proc_inode_cache     497    552    592    6    1 : tunables   32   16    8 : slabdata     92     92      0 : globalstat    1076    630   105    9 				   0    2    0    0    0 : cpustat   3231    142   2891     12
sigqueue               0     23    168   23    1 : tunables   32   16    8 : slabdata      0      1      0 : globalstat     422    138    10    9 				   0    0    0    0    0 : cpustat   1605     43   1637     11
radix_tree_node      659    660    312   12    1 : tunables   32   16    8 : slabdata     55     55      0 : globalstat     902    660    55    0 				   0    0    0    0    0 : cpustat   1331     95    770     20
bdev_cache            46     50    760    5    1 : tunables   32   16    8 : slabdata     10     10      0 : globalstat      61     50    10    0 				   0    0    0    0    0 : cpustat     49     12     15      0
sysfs_dir_cache     7395   7420     72   53    1 : tunables   32   16    8 : slabdata    140    140      0 : globalstat    7556   7415   140    0 				   0    0    0    0    0 : cpustat   7471    569    644      1
mnt_cache             23     58    136   29    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat      93     45     2    0 				   0    0    0    0    0 : cpustat     19      6      2      0
inode_cache         5697   5740    576    7    1 : tunables   32   16    8 : slabdata    819    820      0 : globalstat    9699   5740  1333    3 				   0   14    0    0    0 : cpustat   9072   1371   4519    244
dentry              9319   9387    184   21    1 : tunables   32   16    8 : slabdata    447    447      0 : globalstat   15113   9382   494    0 				   0    5    0    0    0 : cpustat  37212   1623  28893    653
filp                 274    741    208   19    1 : tunables   32   16    8 : slabdata     39     39      0 : globalstat    6616   1479   124    0 				   0    7    0    0    0 : cpustat  63068   1894  63005   1724
names_cache           15     15   4096    1    1 : tunables   24   12    8 : slabdata     15     15      0 : globalstat     498    128   148  133 				   0   55    0    0    0 : cpustat 116688    349 116869    168
idr_layer_cache       83     96    160   24    1 : tunables   32   16    8 : slabdata      4      4      0 : globalstat     216    160     8    4 				   0    0    0    0    0 : cpustat    185     19    121      0
buffer_head          807    816     80   48    1 : tunables   32   16    8 : slabdata     17     17      0 : globalstat    4815   3008    85    1 				   0    2    0    0    0 : cpustat   6943    378   6250    301
mm_struct             59    112    584    7    1 : tunables   32   16    8 : slabdata     15     16      0 : globalstat     642    196    36   18 				   0    0    0    0    0 : cpustat   7543    152   7572     95
vm_area_struct       557   1120    112   35    1 : tunables   32   16    8 : slabdata     32     32     16 : globalstat    4417   1890    54    0 				   0    1    0    0    0 : cpustat 135439   3509 135044   3384
fs_cache              46    220     88   44    1 : tunables   32   16    8 : slabdata      5      5      0 : globalstat     846    218     7    2 				   0    0    0    0    0 : cpustat   4230    158   4252    106
files_cache           47    144    408    9    1 : tunables   32   16    8 : slabdata     16     16      0 : globalstat     804    225    39   14 				   0    0    0    0    0 : cpustat   4213    176   4247    111
signal_cache         130    225    432    9    1 : tunables   32   16    8 : slabdata     25     25      0 : globalstat     777    261    42   17 				   0    0    0    0    0 : cpustat   4383     89   4338     20
sighand_cache        126    185   1376    5    2 : tunables   24   12    8 : slabdata     37     37      0 : globalstat     713    265    67   25 				   0    4    0    0    0 : cpustat   4339    133   4322     36
task_struct          125    156   2720    3    2 : tunables   24   12    8 : slabdata     51     52      0 : globalstat     737    264   133   61 				   0    0    0    0    0 : cpustat   4264    208   4310     48
anon_vma             303    826     64   59    1 : tunables   32   16    8 : slabdata     14     14      0 : globalstat    2118   1003    18    0 				   0    0    0    0    0 : cpustat  36682    336  36467    260
pmd                   84     84   4096    1    1 : tunables   24   12    8 : slabdata     84     84      0 : globalstat     792    378   490  259 				   0   60    0    0    0 : cpustat  22137    948  22548    453
pid                  138    265     72   53    1 : tunables   32   16    8 : slabdata      5      5      0 : globalstat     913    297     9    2 				   0    0    0    0    0 : cpustat   4378     87   4316     28
size-4194304(DMA)      0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-4194304           0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-2097152(DMA)      0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-2097152           0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-1048576(DMA)      0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-1048576           0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-524288(DMA)       0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-524288            0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-262144(DMA)       0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-262144            0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-131072            0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-65536             1      1  65536    1   16 : tunables    8    4    0 : slabdata      1      1      0 : globalstat       1      1     1    0 				   0    0    0    0    0 : cpustat      0      1      0      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-32768             3      3  32768    1    8 : tunables    8    4    0 : slabdata      3      3      0 : globalstat       4      3     4    1 				   0    0    0    0    0 : cpustat      2      4      3      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-16384             2      2  16384    1    4 : tunables    8    4    0 : slabdata      2      2      0 : globalstat       3      2     2    0 				   0    0    0    0    0 : cpustat      2      3      3      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-8192             11     11   8192    1    2 : tunables    8    4    0 : slabdata     11     11      0 : globalstat      15     11    14    3 				   0    0    0    0    0 : cpustat     57     15     61      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-4096             15     15   4096    1    1 : tunables   24   12    8 : slabdata     15     15      0 : globalstat      72     35    55   40 				   0    0    0    0    0 : cpustat   4351     65   4401      0
size-2048(DMA)         0      0   2072    3    2 : tunables   24   12    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-2048            292    300   2072    3    2 : tunables   24   12    8 : slabdata    100    100      0 : globalstat     422    312   110   10 				   0    0    0    0    0 : cpustat   1268    121   1106      0
size-1024(DMA)         0      0   1048    7    2 : tunables   24   12    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-1024            317    371   1048    7    2 : tunables   24   12    8 : slabdata     53     53      0 : globalstat     671    462    67    7 				   0    0    0    0    0 : cpustat   2657     99   2436     14
size-512(DMA)          0      0    536    7    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-512             799    826    536    7    1 : tunables   32   16    8 : slabdata    118    118      0 : globalstat    1205    868   129   11 				   0    1    0    0    0 : cpustat   6954    202   6338     48
size-256(DMA)          0      0    280   14    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-256            1162   1246    280   14    1 : tunables   32   16    8 : slabdata     89     89      0 : globalstat    1875   1288    94    4 				   0    0    0    0    0 : cpustat  16713    265  15724    126
size-128(DMA)          0      0    152   26    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-64(DMA)           0      0     88   44    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-32(DMA)           0      0     56   67    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-32             6918   7437     56   67    1 : tunables   32   16    8 : slabdata    111    111      0 : globalstat    7863   7469   112    0 				   0    0    0    0    0 : cpustat  28260    668  21931     98
size-128             851    962    152   26    1 : tunables   32   16    8 : slabdata     37     37      0 : globalstat    1488    988    38    0 				   0    0    0    0    0 : cpustat  14952    158  14297      8
size-64             1385   1540     88   44    1 : tunables   32   16    8 : slabdata     35     35      0 : globalstat    2146   1528    36    1 				   0    0    0    0    0 : cpustat  31156    928  29935    776
kmem_cache           138    156    320   12    1 : tunables   32   16    8 : slabdata     13     13      0 : globalstat     194    156    13    0 				   0    0    0    0    0 : cpustat     89     49      0      0

--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=slabinfo-oom

slabinfo - version: 2.1 (statistics)
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail> : globalstat <listallocs> <maxobjs> <grown> <reaped> <error> <maxfreeable> <nodeallocs> <remotefrees> <alienoverflow> : cpustat <allochit> <allocmiss> <freehit> <freemiss>
UNIX                   8     20    744    5    1 : tunables   32   16    8 : slabdata      4      4      0 : globalstat     311    100    28   24 				   0    0    0    0    0 : cpustat   5483     47   5517      5
flow_cache             0      0    104   37    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
dm_target_io           0      0     40   92    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
dm_io                  0      0     48   78    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
scsi_cmd_cache         4     39    304   13    1 : tunables   32   16    8 : slabdata      3      3      0 : globalstat    1389    104    20   17 				   0    0    0    0    0 : cpustat   2297    141   2420     16
cfq_io_context         0      0    112   35    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
cfq_queue              0      0    112   35    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
mqueue_inode_cache      1      5    800    5    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat       5      5     1    0 				   0    0    0    0    0 : cpustat      0      1      0      0
cifs_small_rq         30     32    472    8    1 : tunables   32   16    8 : slabdata      4      4      0 : globalstat      32     32     4    0 				   0    0    0    0    0 : cpustat     26      4      0      0
cifs_request           4      4  16496    1    8 : tunables    8    4    0 : slabdata      4      4      0 : globalstat       4      4     4    0 				   0    0    0    0    0 : cpustat      0      4      0      0
cifs_oplock_structs      0      0     48   78    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
cifs_mpx_ids           3     59     64   59    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      16     16     1    0 				   0    0    0    0    0 : cpustat      2      1      0      0
cifs_inode_cache       0      0    616    6    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
smb_request            0      0    296   13    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
smb_inode_cache        0      0    600    6    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
isofs_inode_cache      0      0    608    6    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
fat_inode_cache        0      0    656    6    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
fat_cache              0      0     48   78    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
hugetlbfs_inode_cache      1      7    576    7    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat       7      7     1    0 				   0    0    0    0    0 : cpustat      0      1      0      0
ext2_inode_cache       0      0    832    4    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
ext2_xattr             0      0     72   53    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
journal_handle        32     67     56   67    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat    2037    115     9    8 				   0    0    0    0    0 : cpustat   4690    129   4819      0
journal_head          91     96     80   48    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat    2257    288     8    6 				   0    0    0    0    0 : cpustat   1670    160   1729     36
revoke_table           6     92     40   92    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      32     18     1    0 				   0    0    0    0    0 : cpustat      4      2      0      0
revoke_record          0      0     40   92    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat      16     16     1    1 				   0    0    0    0    0 : cpustat      1      1      2      0
ext3_inode_cache     213    350    816    5    1 : tunables   32   16    8 : slabdata     70     70      0 : globalstat    2176   1945   389   18 				   0   18    0    0    0 : cpustat   1594    413   1699    110
ext3_xattr             0      0     72   53    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
reiser_inode_cache      0      0    760    5    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
configfs_dir_cache      0      0     80   48    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
dnotify_cache          0      0     48   78    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
inotify_event_cache      0      0     56   67    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
inotify_watch_cache      0      0     64   59    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
kioctx                 0      0    272   14    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
kiocb                  0      0    160   24    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
fasync_cache           0      0     40   92    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
shmem_inode_cache    829    913    696   11    2 : tunables   32   16    8 : slabdata     83     83      0 : globalstat    1042    913    83    0 				   0    0    0    0    0 : cpustat    781     94     46      0
nsproxy                0      0     56   67    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
posix_timers_cache      0      0    144   27    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
uid_cache              0      0     72   53    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat      32     19     1    1 				   0    0    0    0    0 : cpustat      2      2      4      0
UDP-Lite               0      0    736    5    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
tcp_bind_bucket        2     92     40   92    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      16     16     1    0 				   0    0    0    0    0 : cpustat      3      1      2      0
inet_peer_cache        0      0     72   53    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
secpath_cache          0      0     56   67    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
xfrm_dst_cache         0      0    280   14    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
ip_fib_alias          10     78     48   78    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      32     25     1    0 				   0    0    0    0    0 : cpustat      8      2      0      0
ip_fib_hash           10     78     48   78    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      32     25     1    0 				   0    0    0    0    0 : cpustat      8      2      0      0
ip_dst_cache          10     15    256   15    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat     268     45     3    2 				   0    0    0    0    0 : cpustat     22     23     35      0
arp_cache              0      0    208   19    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat      48     19     1    1 				   0    0    0    0    0 : cpustat      2      3      5      0
RAW                    9     11    712   11    2 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      24     22     2    1 				   0    0    0    0    0 : cpustat     11      3      5      0
UDP                    0      0    736    5    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat      43     25     7    7 				   0    0    0    0    0 : cpustat     16      9     25      0
tw_sock_TCP            0      0    128   30    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
request_sock_TCP       0      0     96   40    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat      16     16     1    1 				   0    0    0    0    0 : cpustat      0      1      1      0
TCP                    2     10   1448    5    2 : tunables   24   12    8 : slabdata      2      2      0 : globalstat      39     20     4    2 				   0    0    0    0    0 : cpustat     14      7     19      0
eventpoll_pwq          0      0     64   59    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
eventpoll_epi          0      0     96   40    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
sgpool-128             2      3   2584    3    2 : tunables   24   12    8 : slabdata      1      1      0 : globalstat      11      6     2    1 				   0    0    0    0    0 : cpustat     27      4     29      0
sgpool-64              2      3   1304    3    1 : tunables   24   12    8 : slabdata      1      1      0 : globalstat       7      3     1    0 				   0    0    0    0    0 : cpustat     15      5     18      0
sgpool-32              2      6    664    6    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      50     24     4    3 				   0    0    0    0    0 : cpustat     79      9     86      0
sgpool-16              3     11    344   11    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat     119     22     2    1 				   0    0    0    0    0 : cpustat     57     13     68      0
sgpool-8               3     42    184   21    1 : tunables   32   16    8 : slabdata      1      2      0 : globalstat    1735    105    12   10 				   0    0    0    0    0 : cpustat   2071    142   2193     18
scsi_io_context        0      0    128   30    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
blkdev_ioc            15    134     56   67    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat     387     85     2    0 				   0    0    0    0    0 : cpustat    195     25    205      0
blkdev_queue          33     33   1256    3    1 : tunables   24   12    8 : slabdata     11     11      0 : globalstat      38     36    12    1 				   0    0    0    0    0 : cpustat     42     14     23      0
blkdev_requests       38     90    216   18    1 : tunables   32   16    8 : slabdata      4      5      0 : globalstat    1853    142    18   13 				   0    0    0    0    0 : cpustat   2405    159   2504     24
biovec-256             2      2   3096    2    2 : tunables   24   12    8 : slabdata      1      1      0 : globalstat       2      2     1    0 				   0    0    0    0    0 : cpustat      1      1      0      0
biovec-128             2      5   1560    5    2 : tunables   24   12    8 : slabdata      1      1      0 : globalstat       5      5     1    0 				   0    0    0    0    0 : cpustat      1      1      0      0
biovec-64              2      5    792    5    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat      78     35     9    8 				   0    0    0    0    0 : cpustat    310     14    322      0
biovec-16              2     18    216   18    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat     192     70     5    4 				   0    0    0    0    0 : cpustat    466     14    477      1
biovec-4               2     53     72   53    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat     267     85     2    1 				   0    0    0    0    0 : cpustat    578     30    593     13
biovec-1              11    184     40   92    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat    4111    568     8    2 				   0    1    0    0    0 : cpustat   9466    440   9607    297
bio                   20     80     96   40    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat    4085    552    20    9 				   0    2    0    0    0 : cpustat  10843    469  10989    321
sock_inode_cache      28     42    640    6    1 : tunables   32   16    8 : slabdata      7      7      0 : globalstat     293     96    25   18 				   0    0    0    0    0 : cpustat   3438     37   3447      0
skbuff_fclone_cache      0      0    360   11    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat     858     55     7    7 				   0    0    0    0    0 : cpustat  10534    174  10601    107
skbuff_head_cache    216    260    192   20    1 : tunables   32   16    8 : slabdata     13     13      0 : globalstat    1781    316    20    7 				   0    0    0    0    0 : cpustat  16486    185  16411     60
file_lock_cache        2     27    144   27    1 : tunables   32   16    8 : slabdata      1      1      0 : globalstat     749    162     9    8 				   0    0    0    0    0 : cpustat  16619     51  16667      1
Acpi-Operand        1396   1475     64   59    1 : tunables   32   16    8 : slabdata     25     25      0 : globalstat    1455   1432    25    0 				   0    0    0    0    0 : cpustat  14553    100  13256      1
Acpi-ParseExt          0      0     72   53    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat     101     69     3    1 				   0    0    0    0    0 : cpustat   5435      9   5441      3
Acpi-Parse             0      0     56   67    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat      96     64     2    1 				   0    0    0    0    0 : cpustat  23403     11  23408      6
Acpi-State             0      0     72   53    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat     117     69     3    2 				   0    0    0    0    0 : cpustat  31506     23  31513     16
Acpi-Namespace       999   1014     48   78    1 : tunables   32   16    8 : slabdata     13     13      0 : globalstat    1014   1014    13    0 				   0    0    0    0    0 : cpustat   1181     65    247      0
proc_inode_cache     123    126    592    6    1 : tunables   32   16    8 : slabdata     21     21      0 : globalstat    2500    630   122   46 				   0   13    0    0    0 : cpustat   4340    247   4438     41
sigqueue               0      0    168   23    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat    8725    177    28   26 				   0    0    0    0    0 : cpustat 176434  11768 176927  11275
radix_tree_node      282    588    312   12    1 : tunables   32   16    8 : slabdata     49     49      0 : globalstat    1320    660    55    0 				   0    0    0    0    0 : cpustat   1445    128   1258     48
bdev_cache            46     50    760    5    1 : tunables   32   16    8 : slabdata     10     10      0 : globalstat      61     50    10    0 				   0    0    0    0    0 : cpustat     49     12     15      0
sysfs_dir_cache     7395   7420     72   53    1 : tunables   32   16    8 : slabdata    140    140      0 : globalstat    7556   7415   140    0 				   0    0    0    0    0 : cpustat   7471    569    644      1
mnt_cache             23     58    136   29    1 : tunables   32   16    8 : slabdata      2      2      0 : globalstat      93     45     2    0 				   0    0    0    0    0 : cpustat     19      6      2      0
inode_cache           58     70    576    7    1 : tunables   32   16    8 : slabdata     10     10      0 : globalstat   17635   5845  1350   26 				   0   14    0    0    0 : cpustat 183820  13100 185016  11862
dentry              1153   5229    184   21    1 : tunables   32   16    8 : slabdata    249    249      0 : globalstat   23764   9471   498    0 				   0    5    0    0    0 : cpustat 213329  13395 213126  12461
filp                 201    722    208   19    1 : tunables   32   16    8 : slabdata     38     38      0 : globalstat   10264   1479   124    0 				   0    7    0    0    0 : cpustat 1543436  13932 1543552  13641
names_cache            1      4   4096    1    1 : tunables   24   12    8 : slabdata      1      4      0 : globalstat    1538    128   443  439 				   0   55    0    0    0 : cpustat 1236119    964 1236745    338
idr_layer_cache       82     96    160   24    1 : tunables   32   16    8 : slabdata      4      4      0 : globalstat     216    160     8    4 				   0    0    0    0    0 : cpustat    185     19    122      0
buffer_head          165    672     80   48    1 : tunables   32   16    8 : slabdata     14     14      0 : globalstat    6561   3008    89    1 				   0    2    0    0    0 : cpustat   7952    503   7949    361
mm_struct             38     98    584    7    1 : tunables   32   16    8 : slabdata     14     14      0 : globalstat    2781    196    49   31 				   0    1    0    0    0 : cpustat 368800  11864 368920  11721
vm_area_struct       446   1120    112   35    1 : tunables   32   16    8 : slabdata     32     32     16 : globalstat    8305   1890    54    0 				   0    1    0    0    0 : cpustat 7152658 259807 7152494 259562
fs_cache              41    220     88   44    1 : tunables   32   16    8 : slabdata      5      5      0 : globalstat    8702    218     7    2 				   0    0    0    0    0 : cpustat 179014  11866 179465  11389
files_cache           42    126    408    9    1 : tunables   32   16    8 : slabdata     14     14      0 : globalstat    8481    225    45   19 				   0    0    0    0    0 : cpustat 178986  11895 179460  11394
signal_cache         125    216    432    9    1 : tunables   32   16    8 : slabdata     24     24      0 : globalstat     873    261    42   18 				   0    0    0    0    0 : cpustat 190869     95 190834     20
sighand_cache        121    180   1376    5    2 : tunables   24   12    8 : slabdata     36     36      0 : globalstat     785    265    67   26 				   0    4    0    0    0 : cpustat 190825    139 190818     36
task_struct          121    150   2720    3    2 : tunables   24   12    8 : slabdata     50     50      0 : globalstat    1572    264   143   73 				   0    0    0    0    0 : cpustat 190650    314 190806     48
anon_vma             239    826     64   59    1 : tunables   32   16    8 : slabdata     14     14      0 : globalstat    4262   1003    18    0 				   0    0    0    0    0 : cpustat 1342408    471 1342388    262
pmd                   69     69   4096    1    1 : tunables   24   12    8 : slabdata     69     69      0 : globalstat    2450    378   883  667 				   0   60    0    0    0 : cpustat 1094065  47927 1094958  46965
pid                  118    265     72   53    1 : tunables   32   16    8 : slabdata      5      5      0 : globalstat    2369    297     9    2 				   0    0    0    0    0 : cpustat 190779    178 190826     28
size-4194304(DMA)      0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-4194304           0      0 4194304    1 1024 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-2097152(DMA)      0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-2097152           0      0 2097152    1  512 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-1048576(DMA)      0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-1048576           0      0 1048576    1  256 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-524288(DMA)       0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-524288            0      0 524288    1  128 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-262144(DMA)       0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-262144            0      0 262144    1   64 : tunables    1    1    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-131072(DMA)       0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-131072            0      0 131072    1   32 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-65536(DMA)        0      0  65536    1   16 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-65536             1      1  65536    1   16 : tunables    8    4    0 : slabdata      1      1      0 : globalstat       1      1     1    0 				   0    0    0    0    0 : cpustat      0      1      0      0
size-32768(DMA)        0      0  32768    1    8 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-32768             3      3  32768    1    8 : tunables    8    4    0 : slabdata      3      3      0 : globalstat       4      3     4    1 				   0    0    0    0    0 : cpustat      2      4      3      0
size-16384(DMA)        0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-16384             2      2  16384    1    4 : tunables    8    4    0 : slabdata      2      2      0 : globalstat       3      2     2    0 				   0    0    0    0    0 : cpustat      2      3      3      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-8192             11     11   8192    1    2 : tunables    8    4    0 : slabdata     11     11      0 : globalstat      15     11    14    3 				   0    0    0    0    0 : cpustat     57     15     61      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-4096             15     15   4096    1    1 : tunables   24   12    8 : slabdata     15     15      0 : globalstat     157     35   135  120 				   0    0    0    0    0 : cpustat   4355    148   4488      0
size-2048(DMA)         0      0   2072    3    2 : tunables   24   12    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-2048            279    306   2072    3    2 : tunables   24   12    8 : slabdata    102    102      0 : globalstat    1122    327   130   28 				   0    1    0    0    0 : cpustat  11710    354  11642    143
size-1024(DMA)         0      0   1048    7    2 : tunables   24   12    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-1024            316    371   1048    7    2 : tunables   24   12    8 : slabdata     53     53      0 : globalstat    6663    462    78   18 				   0    0    0    0    0 : cpustat 173543  15721 173767  15192
size-512(DMA)          0      0    536    7    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-512             801    826    536    7    1 : tunables   32   16    8 : slabdata    118    118      0 : globalstat    9106    931   144   23 				   0    1    0    0    0 : cpustat 192888  11975 192757  11337
size-256(DMA)          0      0    280   14    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-256            1153   1232    280   14    1 : tunables   32   16    8 : slabdata     88     88      0 : globalstat    4176   1288    95    6 				   0    0    0    0    0 : cpustat 762351    537 761511    256
size-128(DMA)          0      0    152   26    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-64(DMA)           0      0     88   44    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-32(DMA)           0      0     56   67    1 : tunables   32   16    8 : slabdata      0      0      0 : globalstat       0      0     0    0 				   0    0    0    0    0 : cpustat      0      0      0      0
size-32             6900   7437     56   67    1 : tunables   32   16    8 : slabdata    111    111      0 : globalstat   11367   7469   112    0 				   0    0    0    0    0 : cpustat 390225  12451 384045  11759
size-128             831    962    152   26    1 : tunables   32   16    8 : slabdata     37     37      0 : globalstat    4662    988    39    0 				   0    0    0    0    0 : cpustat 376355  11910 375825  11640
size-64             1117   1496     88   44    1 : tunables   32   16    8 : slabdata     34     34     48 : globalstat    3346   1528    36    1 				   0    0    0    0    0 : cpustat 218097   1019 217267    815
kmem_cache           138    156    320   12    1 : tunables   32   16    8 : slabdata     13     13      0 : globalstat     194    156    13    0 				   0    0    0    0    0 : cpustat     89     49      0      0

--ew6BAiZeqk4r7MaW--
