Return-Path: <linux-kernel-owner+w=401wt.eu-S1757426AbYBSQ5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426AbYBSQ5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 11:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYBSQ5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 11:57:22 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:46678 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbYBSQ5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 11:57:21 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, wferi@niif.hu
Subject: Re: inode leak in 2.6.24?
References: <87hcg9hkpp.fsf@szonett.ki.iif.hu>
	<20080218215344.GM155407@sgi.com>
Date: Tue, 19 Feb 2008 17:57:08 +0100
In-Reply-To: <20080218215344.GM155407@sgi.com> (David Chinner's message of
	"Tue, 19 Feb 2008 08:53:44 +1100")
Message-ID: <87skzoanq3.fsf@szonett.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

David Chinner <dgc@sgi.com> writes:

> On Sat, Feb 16, 2008 at 12:18:58AM +0100, Ferenc Wagner wrote:
>
>> 5 days ago I pulled the git tree (HEAD was
>> 25f666300625d894ebe04bac2b4b3aadb907c861), added two minor patches
>> (the vmsplice fix and the GFS1 exports), compiled and booted the
>> kernel.  Things are working OK, but I noticed that inode usage has
>> been steadily rising since then (see attached graph, unless lost in
>> transit).  The real filesystems used by the machine are XFS.  I wonder
>> if it may be some kind of bug and if yes, whether it has been fixed
>> already.  Feel free to ask for any missing information.
>
> Output of /proc/slabinfo, please. If you could get a sample when the
> machine has just booted, one at the typical post-boot steady state
> as well as one after it has increased well past normal, it would
> help identify what type of inode is increasing differently.
>
> Also, can you tell us what metrics you are graphing (i.e. where
> in /proc or /sys you are getting them from)?

So, I loaded the same kernel on a different machine, but that seems to
exhibit a very similar behaviour.  The machine is absolutely idle,
nobody logged in during this period, though an updatedb ran during
this period.  However, the increase seems steady, not correlated to
cron.daily.

The contents of /proc/sys/fs/inode-nr after reboot was:
4421	95

and now, 13h35m later it's:
146182	0

Find the two slabinfo outputs attached.

--=-=-=
Content-Disposition: inline; filename=slabinfo_reboot
Content-Description: slabinfo output immediately after reboot

slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
fib6_nodes             9    113     32  113    1 : tunables  120   60    8 : slabdata      1      1      0
ip6_dst_cache         11     30    256   15    1 : tunables  120   60    8 : slabdata      2      2      0
ndisc_cache            5     30    256   15    1 : tunables  120   60    8 : slabdata      2      2      0
RAWv6                  7     10    768    5    1 : tunables   54   27    8 : slabdata      2      2      0
UDPLITEv6              0      0    768    5    1 : tunables   54   27    8 : slabdata      0      0      0
UDPv6                  3     10    768    5    1 : tunables   54   27    8 : slabdata      2      2      0
tw_sock_TCPv6          0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
request_sock_TCPv6      0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
TCPv6                  5     10   1408    5    2 : tunables   24   12    8 : slabdata      2      2      0
dm_crypt_io            0      0     92   42    1 : tunables  120   60    8 : slabdata      0      0      0
gfs2_bufdata           0      0     48   78    1 : tunables  120   60    8 : slabdata      0      0      0
gfs2_inode             0      0    524    7    1 : tunables   54   27    8 : slabdata      0      0      0
gfs2_glock             0      0    220   18    1 : tunables  120   60    8 : slabdata      0      0      0
dlm_lkb                0      0    132   29    1 : tunables  120   60    8 : slabdata      0      0      0
configfs_dir_cache      1     72     52   72    1 : tunables  120   60    8 : slabdata      1      1      0
xfs_icluster         291    338     20  169    1 : tunables  120   60    8 : slabdata      2      2      0
xfs_ili               72    112    140   28    1 : tunables  120   60    8 : slabdata      4      4      0
xfs_inode            791    800    384   10    1 : tunables   54   27    8 : slabdata     80     80      0
xfs_efi_item           0      0    260   15    1 : tunables   54   27    8 : slabdata      0      0      0
xfs_efd_item           0      0    260   15    1 : tunables   54   27    8 : slabdata      0      0      0
xfs_buf_item          23     78    148   26    1 : tunables  120   60    8 : slabdata      2      3      0
fstrm_item             0      0     12  254    1 : tunables  120   60    8 : slabdata      0      0      0
xfs_mru_cache_elem      0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
xfs_acl                0      0    304   13    1 : tunables   54   27    8 : slabdata      0      0      0
xfs_ifork              0      0     56   67    1 : tunables  120   60    8 : slabdata      0      0      0
xfs_dabuf             16    203     16  203    1 : tunables  120   60    8 : slabdata      1      1      0
xfs_da_state           0      0    336   11    1 : tunables   54   27    8 : slabdata      0      0      0
xfs_trans             17     66    632    6    1 : tunables   54   27    8 : slabdata      3     11      0
xfs_btree_cur         16     28    140   28    1 : tunables  120   60    8 : slabdata      1      1      0
xfs_bmap_free_item      0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
xfs_buf               32     60    256   15    1 : tunables  120   60    8 : slabdata      4      4      0
xfs_ioend             32     67     56   67    1 : tunables  120   60    8 : slabdata      1      1      0
xfs_vnode            790    790    384   10    1 : tunables   54   27    8 : slabdata     79     79      0
dm_snap_pending_exception    128    177     64   59    1 : tunables  120   60    8 : slabdata      3      3      0
dm_snap_exception      0      0     24  145    1 : tunables  120   60    8 : slabdata      0      0      0
dm_mpath_io         1024   1143     28  127    1 : tunables  120   60    8 : slabdata      9      9      0
dm_uevent              0      0   2460    3    2 : tunables   24   12    8 : slabdata      0      0      0
dm_target_io        1600   1827     16  203    1 : tunables  120   60    8 : slabdata      9      9      0
dm_io               1544   1859     20  169    1 : tunables  120   60    8 : slabdata     11     11      0
scsi_sense_cache      29    180    128   30    1 : tunables  120   60    8 : slabdata      6      6      0
scsi_cmd_cache        27    150    256   15    1 : tunables  120   60    8 : slabdata     10     10      0
qla2xxx_srbs         319    565     32  113    1 : tunables  120   60    8 : slabdata      5      5      0
scsi_tgt_cmd           0      0     48   78    1 : tunables  120   60    8 : slabdata      0      0      0
sgpool-128             2      2   2048    2    1 : tunables   24   12    8 : slabdata      1      1      0
sgpool-64              2      4   1024    4    1 : tunables   54   27    8 : slabdata      1      1      0
sgpool-32              2      8    512    8    1 : tunables   54   27    8 : slabdata      1      1      0
sgpool-16              2     15    256   15    1 : tunables  120   60    8 : slabdata      1      1      0
sgpool-8              33    210    128   30    1 : tunables  120   60    8 : slabdata      6      7      0
scsi_bidi_sdb          0      0     20  169    1 : tunables  120   60    8 : slabdata      0      0      0
scsi_io_context        0      0    104   37    1 : tunables  120   60    8 : slabdata      0      0      0
clip_arp_cache         0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
UNIX                  18     28    512    7    1 : tunables   54   27    8 : slabdata      4      4      0
flow_cache             0      0     80   48    1 : tunables  120   60    8 : slabdata      0      0      0
cfq_io_context       115    288     80   48    1 : tunables  120   60    8 : slabdata      6      6      0
cfq_queue            116    276     84   46    1 : tunables  120   60    8 : slabdata      6      6      0
mqueue_inode_cache      1      6    640    6    1 : tunables   54   27    8 : slabdata      1      1      0
hugetlbfs_inode_cache      1     11    340   11    1 : tunables   54   27    8 : slabdata      1      1      0
dnotify_cache          0      0     20  169    1 : tunables  120   60    8 : slabdata      0      0      0
dquot                  0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_event_cache      0      0     28  127    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_watch_cache      1     92     40   92    1 : tunables  120   60    8 : slabdata      1      1      0
kioctx                 0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
kiocb                  0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
fasync_cache           0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
shmem_inode_cache    631    657    444    9    1 : tunables   54   27    8 : slabdata     73     73      0
nsproxy                0      0     28  127    1 : tunables  120   60    8 : slabdata      0      0      0
posix_timers_cache      0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
uid_cache              5     60    128   30    1 : tunables  120   60    8 : slabdata      2      2      0
ip_mrt_cache           0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
UDP-Lite               0      0    640    6    1 : tunables   54   27    8 : slabdata      0      0      0
tcp_bind_bucket        8    113     32  113    1 : tunables  120   60    8 : slabdata      1      1      0
inet_peer_cache        0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
secpath_cache          0      0     32  113    1 : tunables  120   60    8 : slabdata      0      0      0
xfrm_dst_cache         0      0    384   10    1 : tunables   54   27    8 : slabdata      0      0      0
ip_fib_alias           0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
ip_fib_hash            9    101     36  101    1 : tunables  120   60    8 : slabdata      1      1      0
ip_dst_cache          43     60    256   15    1 : tunables  120   60    8 : slabdata      4      4      0
arp_cache              5     15    256   15    1 : tunables  120   60    8 : slabdata      1      1      0
RAW                    5      8    512    8    1 : tunables   54   27    8 : slabdata      1      1      0
UDP                    7     24    640    6    1 : tunables   54   27    8 : slabdata      4      4      0
tw_sock_TCP            0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
request_sock_TCP       0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
TCP                    5      9   1280    3    1 : tunables   24   12    8 : slabdata      3      3      0
eventpoll_pwq          0      0     36  101    1 : tunables  120   60    8 : slabdata      0      0      0
eventpoll_epi          0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
blkdev_queue          64     77   1044    7    2 : tunables   24   12    8 : slabdata     11     11      0
blkdev_requests      202    252    188   21    1 : tunables  120   60    8 : slabdata     11     12      0
blkdev_ioc            23    168     44   84    1 : tunables  120   60    8 : slabdata      2      2      0
biovec-256            98     98   3072    2    2 : tunables   24   12    8 : slabdata     49     49      0
biovec-128            98    100   1536    5    2 : tunables   24   12    8 : slabdata     20     20      0
biovec-64             98    105    768    5    1 : tunables   54   27    8 : slabdata     21     21      0
biovec-16             99    135    256   15    1 : tunables  120   60    8 : slabdata      9      9      0
biovec-4             104    295     64   59    1 : tunables  120   60    8 : slabdata      4      5      0
biovec-1             123    406     16  203    1 : tunables  120   60    8 : slabdata      2      2      0
bio                  189    300    128   30    1 : tunables  120   60    8 : slabdata     10     10      0
sock_inode_cache      62     80    384   10    1 : tunables   54   27    8 : slabdata      8      8      0
skbuff_fclone_cache      8     20    384   10    1 : tunables   54   27    8 : slabdata      1      2      0
skbuff_head_cache    226    345    256   15    1 : tunables  120   60    8 : slabdata     22     23      0
file_lock_cache        4     78    100   39    1 : tunables  120   60    8 : slabdata      2      2      0
Acpi-Operand         433    460     40   92    1 : tunables  120   60    8 : slabdata      5      5      0
Acpi-ParseExt          0      0     44   84    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Parse             0      0     28  127    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-State             0      0     44   84    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Namespace       335    338     20  169    1 : tunables  120   60    8 : slabdata      2      2      0
task_delay_info      151    468     48   78    1 : tunables  120   60    8 : slabdata      6      6      0
taskstats              0      0    312   12    1 : tunables   54   27    8 : slabdata      0      0      0
proc_inode_cache     548    726    356   11    1 : tunables   54   27    8 : slabdata     66     66      0
sigqueue              42     81    144   27    1 : tunables  120   60    8 : slabdata      2      3      0
radix_tree_node     1156   1183    288   13    1 : tunables   54   27    8 : slabdata     91     91      0
bdev_cache            53     63    512    7    1 : tunables   54   27    8 : slabdata      9      9      0
sysfs_dir_cache     8186   8316     44   84    1 : tunables  120   60    8 : slabdata     99     99      0
mnt_cache             26     60    128   30    1 : tunables  120   60    8 : slabdata      2      2      0
inode_cache         2319   2354    340   11    1 : tunables   54   27    8 : slabdata    214    214      0
dentry              5133   5133    132   29    1 : tunables  120   60    8 : slabdata    177    177      0
filp                 441   1125    256   15    1 : tunables  120   60    8 : slabdata     75     75      0
names_cache           15     35   4096    1    1 : tunables   24   12    8 : slabdata     15     35      0
key_jar               10     60    128   30    1 : tunables  120   60    8 : slabdata      2      2      0
idr_layer_cache      159    203    136   29    1 : tunables  120   60    8 : slabdata      7      7      0
buffer_head          143    201     56   67    1 : tunables  120   60    8 : slabdata      3      3      0
mm_struct             31    105    512    7    1 : tunables   54   27    8 : slabdata     15     15      0
vm_area_struct       821   2484     84   46    1 : tunables  120   60    8 : slabdata     54     54      0
fs_cache              33    354     64   59    1 : tunables  120   60    8 : slabdata      6      6      0
files_cache           39    195    256   15    1 : tunables  120   60    8 : slabdata     12     13      0
signal_cache         133    189    512    7    1 : tunables   54   27    8 : slabdata     27     27      0
sighand_cache        130    170   1408    5    2 : tunables   24   12    8 : slabdata     34     34      0
task_struct          140    162   3696    1    1 : tunables   24   12    8 : slabdata    140    162      0
anon_vma             433    762     12  254    1 : tunables  120   60    8 : slabdata      3      3      0
pid                  155    413     64   59    1 : tunables  120   60    8 : slabdata      7      7      0
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
size-16384             0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
size-8192              8      8   8192    1    2 : tunables    8    4    0 : slabdata      8      8      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    8 : slabdata      0      0      0
size-4096             27     27   4096    1    1 : tunables   24   12    8 : slabdata     27     27      0
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    8 : slabdata      0      0      0
size-2048            398    398   2048    2    1 : tunables   24   12    8 : slabdata    199    199      0
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
size-1024            283    312   1024    4    1 : tunables   54   27    8 : slabdata     78     78      0
size-512(DMA)          0      0    512    8    1 : tunables   54   27    8 : slabdata      0      0      0
size-512             862    944    512    8    1 : tunables   54   27    8 : slabdata    118    118      0
size-256(DMA)          0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
size-256             300    450    256   15    1 : tunables  120   60    8 : slabdata     30     30      0
size-192(DMA)          0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
size-192             160    195    256   15    1 : tunables  120   60    8 : slabdata     13     13      0
size-128(DMA)          0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
size-128             492    540    128   30    1 : tunables  120   60    8 : slabdata     18     18      0
size-96(DMA)           0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
size-96              239    360    128   30    1 : tunables  120   60    8 : slabdata     12     12      0
size-64(DMA)           0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
size-32(DMA)           0      0     32  113    1 : tunables  120   60    8 : slabdata      0      0      0
size-64             2170   2360     64   59    1 : tunables  120   60    8 : slabdata     40     40      0
size-32             7567   7797     32  113    1 : tunables  120   60    8 : slabdata     69     69      0
kmem_cache           168    180    128   30    1 : tunables  120   60    8 : slabdata      6      6      0

--=-=-=
Content-Disposition: inline; filename=slabinfo_13h
Content-Description: slabinfo output 13h35m after reboot

slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
fib6_nodes             8    113     32  113    1 : tunables  120   60    8 : slabdata      1      1      0
ip6_dst_cache          7     30    256   15    1 : tunables  120   60    8 : slabdata      2      2      0
ndisc_cache            2     30    256   15    1 : tunables  120   60    8 : slabdata      2      2      0
RAWv6                  7     10    768    5    1 : tunables   54   27    8 : slabdata      2      2      0
UDPLITEv6              0      0    768    5    1 : tunables   54   27    8 : slabdata      0      0      0
UDPv6                  3     10    768    5    1 : tunables   54   27    8 : slabdata      2      2      0
tw_sock_TCPv6          0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
request_sock_TCPv6      0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
TCPv6                  5      5   1408    5    2 : tunables   24   12    8 : slabdata      1      1      0
dm_crypt_io            0      0     92   42    1 : tunables  120   60    8 : slabdata      0      0      0
gfs2_bufdata           0      0     48   78    1 : tunables  120   60    8 : slabdata      0      0      0
gfs2_inode             0      0    524    7    1 : tunables   54   27    8 : slabdata      0      0      0
gfs2_glock             0      0    220   18    1 : tunables  120   60    8 : slabdata      0      0      0
dlm_lkb                0      0    132   29    1 : tunables  120   60    8 : slabdata      0      0      0
configfs_dir_cache      1     72     52   72    1 : tunables  120   60    8 : slabdata      1      1      0
xfs_icluster        4499   4563     20  169    1 : tunables  120   60    8 : slabdata     27     27      0
xfs_ili              139    168    140   28    1 : tunables  120   60    8 : slabdata      6      6      0
xfs_inode         142548 142550    384   10    1 : tunables   54   27    8 : slabdata  14255  14255      0
xfs_efi_item           0      0    260   15    1 : tunables   54   27    8 : slabdata      0      0      0
xfs_efd_item           0      0    260   15    1 : tunables   54   27    8 : slabdata      0      0      0
xfs_buf_item          16     26    148   26    1 : tunables  120   60    8 : slabdata      1      1      0
fstrm_item             0      0     12  254    1 : tunables  120   60    8 : slabdata      0      0      0
xfs_mru_cache_elem      0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
xfs_acl                0      0    304   13    1 : tunables   54   27    8 : slabdata      0      0      0
xfs_ifork              0      0     56   67    1 : tunables  120   60    8 : slabdata      0      0      0
xfs_dabuf             16    203     16  203    1 : tunables  120   60    8 : slabdata      1      1      0
xfs_da_state           0      0    336   11    1 : tunables   54   27    8 : slabdata      0      0      0
xfs_trans              6      6    632    6    1 : tunables   54   27    8 : slabdata      1      1      0
xfs_btree_cur         16     28    140   28    1 : tunables  120   60    8 : slabdata      1      1      0
xfs_bmap_free_item      0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
xfs_buf               26     30    256   15    1 : tunables  120   60    8 : slabdata      2      2      0
xfs_ioend             32     67     56   67    1 : tunables  120   60    8 : slabdata      1      1      0
xfs_vnode         142548 142550    384   10    1 : tunables   54   27    8 : slabdata  14255  14255      0
dm_snap_pending_exception    128    177     64   59    1 : tunables  120   60    8 : slabdata      3      3      0
dm_snap_exception      0      0     24  145    1 : tunables  120   60    8 : slabdata      0      0      0
dm_mpath_io         1024   1143     28  127    1 : tunables  120   60    8 : slabdata      9      9      0
dm_uevent              0      0   2460    3    2 : tunables   24   12    8 : slabdata      0      0      0
dm_target_io        1536   1827     16  203    1 : tunables  120   60    8 : slabdata      9      9      0
dm_io               1536   1690     20  169    1 : tunables  120   60    8 : slabdata     10     10      0
scsi_sense_cache       7     60    128   30    1 : tunables  120   60    8 : slabdata      2      2      0
scsi_cmd_cache         7     45    256   15    1 : tunables  120   60    8 : slabdata      3      3      0
qla2xxx_srbs         259    339     32  113    1 : tunables  120   60    8 : slabdata      3      3      0
scsi_tgt_cmd           0      0     48   78    1 : tunables  120   60    8 : slabdata      0      0      0
sgpool-128             2      2   2048    2    1 : tunables   24   12    8 : slabdata      1      1      0
sgpool-64              2      4   1024    4    1 : tunables   54   27    8 : slabdata      1      1      0
sgpool-32              2      8    512    8    1 : tunables   54   27    8 : slabdata      1      1      0
sgpool-16              2     15    256   15    1 : tunables  120   60    8 : slabdata      1      1      0
sgpool-8               5     60    128   30    1 : tunables  120   60    8 : slabdata      2      2      0
scsi_bidi_sdb          0      0     20  169    1 : tunables  120   60    8 : slabdata      0      0      0
scsi_io_context        0      0    104   37    1 : tunables  120   60    8 : slabdata      0      0      0
clip_arp_cache         0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
UNIX                  30     42    512    7    1 : tunables   54   27    8 : slabdata      6      6      0
flow_cache             0      0     80   48    1 : tunables  120   60    8 : slabdata      0      0      0
cfq_io_context       115    288     80   48    1 : tunables  120   60    8 : slabdata      6      6      0
cfq_queue            115    276     84   46    1 : tunables  120   60    8 : slabdata      6      6      0
mqueue_inode_cache      1      6    640    6    1 : tunables   54   27    8 : slabdata      1      1      0
hugetlbfs_inode_cache      1     11    340   11    1 : tunables   54   27    8 : slabdata      1      1      0
dnotify_cache          0      0     20  169    1 : tunables  120   60    8 : slabdata      0      0      0
dquot                  0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_event_cache      0      0     28  127    1 : tunables  120   60    8 : slabdata      0      0      0
inotify_watch_cache      1     92     40   92    1 : tunables  120   60    8 : slabdata      1      1      0
kioctx                 0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
kiocb                  0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
fasync_cache           0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
shmem_inode_cache    631    657    444    9    1 : tunables   54   27    8 : slabdata     73     73      0
nsproxy                0      0     28  127    1 : tunables  120   60    8 : slabdata      0      0      0
posix_timers_cache      0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
uid_cache              5     60    128   30    1 : tunables  120   60    8 : slabdata      2      2      0
ip_mrt_cache           0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
UDP-Lite               0      0    640    6    1 : tunables   54   27    8 : slabdata      0      0      0
tcp_bind_bucket        8    113     32  113    1 : tunables  120   60    8 : slabdata      1      1      0
inet_peer_cache        0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
secpath_cache          0      0     32  113    1 : tunables  120   60    8 : slabdata      0      0      0
xfrm_dst_cache         0      0    384   10    1 : tunables   54   27    8 : slabdata      0      0      0
ip_fib_alias           0      0     16  203    1 : tunables  120   60    8 : slabdata      0      0      0
ip_fib_hash            9    101     36  101    1 : tunables  120   60    8 : slabdata      1      1      0
ip_dst_cache          23     45    256   15    1 : tunables  120   60    8 : slabdata      3      3      0
arp_cache              5     30    256   15    1 : tunables  120   60    8 : slabdata      2      2      0
RAW                    5      8    512    8    1 : tunables   54   27    8 : slabdata      1      1      0
UDP                    7     24    640    6    1 : tunables   54   27    8 : slabdata      4      4      0
tw_sock_TCP            0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
request_sock_TCP       0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
TCP                    5      9   1280    3    1 : tunables   24   12    8 : slabdata      3      3      0
eventpoll_pwq          0      0     36  101    1 : tunables  120   60    8 : slabdata      0      0      0
eventpoll_epi          0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
blkdev_queue          64     77   1044    7    2 : tunables   24   12    8 : slabdata     11     11      0
blkdev_requests      139    168    188   21    1 : tunables  120   60    8 : slabdata      8      8      0
blkdev_ioc            22    168     44   84    1 : tunables  120   60    8 : slabdata      2      2      0
biovec-256            98     98   3072    2    2 : tunables   24   12    8 : slabdata     49     49      0
biovec-128            98    100   1536    5    2 : tunables   24   12    8 : slabdata     20     20      0
biovec-64             98    105    768    5    1 : tunables   54   27    8 : slabdata     21     21      0
biovec-16             98    120    256   15    1 : tunables  120   60    8 : slabdata      8      8      0
biovec-4             100    177     64   59    1 : tunables  120   60    8 : slabdata      3      3      0
biovec-1             102    406     16  203    1 : tunables  120   60    8 : slabdata      2      2      0
bio                  102    210    128   30    1 : tunables  120   60    8 : slabdata      7      7      0
sock_inode_cache      71     90    384   10    1 : tunables   54   27    8 : slabdata      9      9      0
skbuff_fclone_cache     10     10    384   10    1 : tunables   54   27    8 : slabdata      1      1      0
skbuff_head_cache    274    300    256   15    1 : tunables  120   60    8 : slabdata     20     20      0
file_lock_cache        4     78    100   39    1 : tunables  120   60    8 : slabdata      2      2      0
Acpi-Operand         433    460     40   92    1 : tunables  120   60    8 : slabdata      5      5      0
Acpi-ParseExt          0      0     44   84    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Parse             0      0     28  127    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-State             0      0     44   84    1 : tunables  120   60    8 : slabdata      0      0      0
Acpi-Namespace       335    338     20  169    1 : tunables  120   60    8 : slabdata      2      2      0
task_delay_info      133    468     48   78    1 : tunables  120   60    8 : slabdata      6      6      0
taskstats              0      0    312   12    1 : tunables   54   27    8 : slabdata      0      0      0
proc_inode_cache     609    726    356   11    1 : tunables   54   27    8 : slabdata     66     66      0
sigqueue               2     27    144   27    1 : tunables  120   60    8 : slabdata      1      1      0
radix_tree_node     7188   7241    288   13    1 : tunables   54   27    8 : slabdata    557    557      0
bdev_cache            53     63    512    7    1 : tunables   54   27    8 : slabdata      9      9      0
sysfs_dir_cache     8186   8316     44   84    1 : tunables  120   60    8 : slabdata     99     99      0
mnt_cache             26     60    128   30    1 : tunables  120   60    8 : slabdata      2      2      0
inode_cache         2333   2354    340   11    1 : tunables   54   27    8 : slabdata    214    214      0
dentry            148003 148074    132   29    1 : tunables  120   60    8 : slabdata   5106   5106      0
filp                 532   1110    256   15    1 : tunables  120   60    8 : slabdata     74     74      0
names_cache            3     27   4096    1    1 : tunables   24   12    8 : slabdata      3     27      0
key_jar               10     60    128   30    1 : tunables  120   60    8 : slabdata      2      2      0
idr_layer_cache      159    203    136   29    1 : tunables  120   60    8 : slabdata      7      7      0
buffer_head         2325   2345     56   67    1 : tunables  120   60    8 : slabdata     35     35      0
mm_struct             43     98    512    7    1 : tunables   54   27    8 : slabdata     14     14      0
vm_area_struct       840   2484     84   46    1 : tunables  120   60    8 : slabdata     54     54      0
fs_cache              32    354     64   59    1 : tunables  120   60    8 : slabdata      6      6      0
files_cache           33    135    256   15    1 : tunables  120   60    8 : slabdata      9      9      0
signal_cache         119    189    512    7    1 : tunables   54   27    8 : slabdata     27     27      0
sighand_cache        119    170   1408    5    2 : tunables   24   12    8 : slabdata     34     34      0
task_struct          128    128   3696    1    1 : tunables   24   12    8 : slabdata    128    128      0
anon_vma             394    762     12  254    1 : tunables  120   60    8 : slabdata      3      3      0
pid                  137    413     64   59    1 : tunables  120   60    8 : slabdata      7      7      0
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
size-16384             0      0  16384    1    4 : tunables    8    4    0 : slabdata      0      0      0
size-8192(DMA)         0      0   8192    1    2 : tunables    8    4    0 : slabdata      0      0      0
size-8192              8      8   8192    1    2 : tunables    8    4    0 : slabdata      8      8      0
size-4096(DMA)         0      0   4096    1    1 : tunables   24   12    8 : slabdata      0      0      0
size-4096             27     27   4096    1    1 : tunables   24   12    8 : slabdata     27     27      0
size-2048(DMA)         0      0   2048    2    1 : tunables   24   12    8 : slabdata      0      0      0
size-2048            403    406   2048    2    1 : tunables   24   12    8 : slabdata    202    203      0
size-1024(DMA)         0      0   1024    4    1 : tunables   54   27    8 : slabdata      0      0      0
size-1024            289    312   1024    4    1 : tunables   54   27    8 : slabdata     77     78      0
size-512(DMA)          0      0    512    8    1 : tunables   54   27    8 : slabdata      0      0      0
size-512             904    944    512    8    1 : tunables   54   27    8 : slabdata    118    118      0
size-256(DMA)          0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
size-256             301    435    256   15    1 : tunables  120   60    8 : slabdata     29     29      0
size-192(DMA)          0      0    256   15    1 : tunables  120   60    8 : slabdata      0      0      0
size-192             509    540    256   15    1 : tunables  120   60    8 : slabdata     35     36      0
size-128(DMA)          0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
size-128             982    990    128   30    1 : tunables  120   60    8 : slabdata     33     33      0
size-96(DMA)           0      0    128   30    1 : tunables  120   60    8 : slabdata      0      0      0
size-96             1002   1020    128   30    1 : tunables  120   60    8 : slabdata     34     34      0
size-64(DMA)           0      0     64   59    1 : tunables  120   60    8 : slabdata      0      0      0
size-32(DMA)           0      0     32  113    1 : tunables  120   60    8 : slabdata      0      0      0
size-64             4003   4071     64   59    1 : tunables  120   60    8 : slabdata     69     69      0
size-32             7545   7797     32  113    1 : tunables  120   60    8 : slabdata     69     69      0
kmem_cache           168    180    128   30    1 : tunables  120   60    8 : slabdata      6      6      0

--=-=-=


The xfs_inode, xfs_vnode and dentry lines show significant increase.
The machine indeed uses XFS as its root filesystem.  Hope this gives
enough clues to narrow down the problem.  I can try other kernels if
needed.
-- 
Regards,
Feri.

--=-=-=--
