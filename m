Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbZFHNeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbZFHNeq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbZFHNei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:34:38 -0400
Received: from fmailhost06.isp.att.net ([207.115.11.56]:55152 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbZFHNeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:34:37 -0400
X-Originating-IP: [65.28.94.183]
Message-ID: <4A2D1369.5070308@lwfinger.net>
Date: Mon, 08 Jun 2009 08:34:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net> <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com> <4A2BCC6F.8090004@redhat.com> <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com> <20090608101739.GA15377@csn.ul.ie>
In-Reply-To: <20090608101739.GA15377@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:
>
> Larry, can you post the contents of /proc/slabinfo so we can see
> what size pages are being used for the kmalloc() buckets please?

The system is not generating the failures at the moment, but here is
the current state:

finger@larrylap:~/wireless-testing> cat /proc/slabinfo
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab>
<pagesperslab> : tunables <limit> <batchcount> <sharedfactor> :
slabdata <active_slabs> <num_slabs> <sharedavail>
nfs_direct_cache       0      0    288   14    1 : tunables    0    0
   0 : slabdata      0      0      0
nfs_write_data        42     42    768   21    4 : tunables    0    0
   0 : slabdata      2      2      0
nfs_read_data         42     42    768   21    4 : tunables    0    0
   0 : slabdata      2      2      0
nfs_inode_cache       20     20   1568   20    8 : tunables    0    0
   0 : slabdata      1      1      0
nfs_page               0      0    192   21    1 : tunables    0    0
   0 : slabdata      0      0      0
rpc_buffers           30     30   2176   15    8 : tunables    0    0
   0 : slabdata      2      2      0
rpc_tasks             42     42    384   21    2 : tunables    0    0
   0 : slabdata      2      2      0
rpc_inode_cache       23     23   1408   23    8 : tunables    0    0
   0 : slabdata      1      1      0
fuse_request         351    352    720   22    4 : tunables    0    0
   0 : slabdata     16     16      0
fuse_inode           325    325   1216   13    4 : tunables    0    0
   0 : slabdata     25     25      0
ext4_inode_cache   17180  17180   1568   20    8 : tunables    0    0
   0 : slabdata    859    859      0
ext4_xattr             0      0    160   25    1 : tunables    0    0
   0 : slabdata      0      0      0
ext4_free_block_extents      0      0    128   32    1 : tunables    0
   0    0 : slabdata      0      0      0
ext4_alloc_context      0      0    216   18    1 : tunables    0    0
   0 : slabdata      0      0      0
ext4_prealloc_space      0      0    216   18    1 : tunables    0
0    0 : slabdata      0      0      0
jbd2_journal_handle     68     68    120   34    1 : tunables    0
0    0 : slabdata      2      2      0
jbd2_journal_head   3734   3784    184   22    1 : tunables    0    0
   0 : slabdata    172    172      0
jbd2_revoke_table     46     46     88   46    1 : tunables    0    0
   0 : slabdata      1      1      0
jbd2_revoke_record      0      0    128   32    1 : tunables    0    0
   0 : slabdata      0      0      0
kcopyd_job             0      0    528   15    2 : tunables    0    0
   0 : slabdata      0      0      0
dm_rq_clone_bio_info      0      0     88   46    1 : tunables    0
 0    0 : slabdata      0      0      0
dm_rq_target_io        0      0    480   17    2 : tunables    0    0
   0 : slabdata      0      0      0
dm_target_io           0      0     96   42    1 : tunables    0    0
   0 : slabdata      0      0      0
dm_io                  0      0    104   39    1 : tunables    0    0
   0 : slabdata      0      0      0
uhci_urb_priv          0      0    128   32    1 : tunables    0    0
   0 : slabdata      0      0      0
ext3_inode_cache   69341  69345   1408   23    8 : tunables    0    0
   0 : slabdata   3015   3015      0
ext3_xattr           325    325    160   25    1 : tunables    0    0
   0 : slabdata     13     13      0
journal_handle        68     68    120   34    1 : tunables    0    0
   0 : slabdata      2      2      0
journal_head        2473   4642    184   22    1 : tunables    0    0
   0 : slabdata    211    211      0
revoke_table          46     46     88   46    1 : tunables    0    0
   0 : slabdata      1      1      0
revoke_record         64     64    128   32    1 : tunables    0    0
   0 : slabdata      2      2      0
scsi_sense_cache      46     63    192   21    1 : tunables    0    0
   0 : slabdata      3      3      0
scsi_cmd_cache        28     36    320   12    1 : tunables    0    0
   0 : slabdata      3      3      0
sgpool-128            16     21   4224    7    8 : tunables    0    0
   0 : slabdata      3      3      0
sgpool-64             30     30   2176   15    8 : tunables    0    0
   0 : slabdata      2      2      0
sgpool-32             28     28   1152   14    4 : tunables    0    0
   0 : slabdata      2      2      0
sgpool-16             24     24    640   12    2 : tunables    0    0
   0 : slabdata      2      2      0
sgpool-8              44     63    384   21    2 : tunables    0    0
   0 : slabdata      3      3      0
scsi_data_buffer       0      0     96   42    1 : tunables    0    0
   0 : slabdata      0      0      0
flow_cache             0      0    168   24    1 : tunables    0    0
   0 : slabdata      0      0      0
cfq_io_context        93    102    240   17    1 : tunables    0    0
   0 : slabdata      6      6      0
cfq_queue             97    102    240   17    1 : tunables    0    0
   0 : slabdata      6      6      0
mqueue_inode_cache     23     23   1408   23    8 : tunables    0    0
   0 : slabdata      1      1      0
isofs_inode_cache      0      0   1088   15    4 : tunables    0    0
   0 : slabdata      0      0      0
kioctx                 0      0    640   12    2 : tunables    0    0
   0 : slabdata      0      0      0
kiocb                  0      0    320   12    1 : tunables    0    0
   0 : slabdata      0      0      0
inotify_event_cache     72     72    112   36    1 : tunables    0
0    0 : slabdata      2      2      0
inotify_watch_cache    224    224    144   28    1 : tunables    0
0    0 : slabdata      8      8      0
fasync_cache          42     42     96   42    1 : tunables    0    0
   0 : slabdata      1      1      0
shmem_inode_cache   1485   1488   1344   12    4 : tunables    0    0
   0 : slabdata    124    124      0
nsproxy                0      0    120   34    1 : tunables    0    0
   0 : slabdata      0      0      0
posix_timers_cache     26     26    304   13    1 : tunables    0    0
   0 : slabdata      2      2      0
uid_cache             24     24    320   12    1 : tunables    0    0
   0 : slabdata      2      2      0
UNIX                 354    360   1344   12    4 : tunables    0    0
   0 : slabdata     30     30      0
ip_mrt_cache           0      0    192   21    1 : tunables    0    0
   0 : slabdata      0      0      0
UDP-Lite               0      0   1216   13    4 : tunables    0    0
   0 : slabdata      0      0      0
tcp_bind_bucket       64     64    128   32    1 : tunables    0    0
   0 : slabdata      2      2      0
inet_peer_cache       21     21    192   21    1 : tunables    0    0
   0 : slabdata      1      1      0
secpath_cache          0      0    128   32    1 : tunables    0    0
   0 : slabdata      0      0      0
xfrm_dst_cache         0      0    448   18    2 : tunables    0    0
   0 : slabdata      0      0      0
ip_fib_alias           0      0    104   39    1 : tunables    0    0
   0 : slabdata      0      0      0
ip_fib_hash           56     56    144   28    1 : tunables    0    0
   0 : slabdata      2      2      0
ip_dst_cache          36     36    448   18    2 : tunables    0    0
   0 : slabdata      2      2      0
arp_cache             36     36    448   18    2 : tunables    0    0
   0 : slabdata      2      2      0
RAW                   14     14   1152   14    4 : tunables    0    0
   0 : slabdata      1      1      0
UDP                   26     26   1216   13    4 : tunables    0    0
   0 : slabdata      2      2      0
tw_sock_TCP           32     32    256   16    1 : tunables    0    0
   0 : slabdata      2      2      0
request_sock_TCP      21     21    192   21    1 : tunables    0    0
   0 : slabdata      1      1      0
TCP                   34     45   2176   15    8 : tunables    0    0
   0 : slabdata      3      3      0
eventpoll_pwq        110    112    144   28    1 : tunables    0    0
   0 : slabdata      4      4      0
eventpoll_epi         94     96    256   16    1 : tunables    0    0
   0 : slabdata      6      6      0
blkdev_queue          22     22   2736   11    8 : tunables    0    0
   0 : slabdata      2      2      0
blkdev_requests       40     54    440   18    2 : tunables    0    0
   0 : slabdata      3      3      0
blkdev_ioc           101    105    192   21    1 : tunables    0    0
   0 : slabdata      5      5      0
bio-0                 32     32    256   16    1 : tunables    0    0
   0 : slabdata      2      2      0
biovec-256             7      7   4224    7    8 : tunables    0    0
   0 : slabdata      1      1      0
biovec-128            30     30   2176   15    8 : tunables    0    0
   0 : slabdata      2      2      0
biovec-64             28     28   1152   14    4 : tunables    0    0
   0 : slabdata      2      2      0
biovec-16             42     42    384   21    2 : tunables    0    0
   0 : slabdata      2      2      0
sock_inode_cache     397    406   1152   14    4 : tunables    0    0
   0 : slabdata     29     29      0
skbuff_fclone_cache     32     32    512   16    2 : tunables    0
0    0 : slabdata      2      2      0
skbuff_head_cache    593    600    320   12    1 : tunables    0    0
   0 : slabdata     50     50      0
file_lock_cache       39     42    288   14    1 : tunables    0    0
   0 : slabdata      3      3      0
Acpi-Operand        1301   1316    144   28    1 : tunables    0    0
   0 : slabdata     47     47      0
Acpi-ParseExt         56     56    144   28    1 : tunables    0    0
   0 : slabdata      2      2      0
Acpi-Parse            68     68    120   34    1 : tunables    0    0
   0 : slabdata      2      2      0
Acpi-State            52     52    152   26    1 : tunables    0    0
   0 : slabdata      2      2      0
Acpi-Namespace       897    897    104   39    1 : tunables    0    0
   0 : slabdata     23     23      0
task_delay_info      247    255    232   17    1 : tunables    0    0
   0 : slabdata     15     15      0
taskstats             40     40    400   20    2 : tunables    0    0
   0 : slabdata      2      2      0
proc_inode_cache    1709   1725   1088   15    4 : tunables    0    0
   0 : slabdata    115    115      0
sigqueue              34     34    232   17    1 : tunables    0    0
   0 : slabdata      2      2      0
radix_tree_node    22109  22126    624   13    2 : tunables    0    0
   0 : slabdata   1702   1702      0
bdev_cache            42     42   1536   21    8 : tunables    0    0
   0 : slabdata      2      2      0
sysfs_dir_cache    12246  12246    152   26    1 : tunables    0    0
   0 : slabdata    471    471      0
mnt_cache             47     48    320   12    1 : tunables    0    0
   0 : slabdata      4      4      0
filp                2971   3150    384   21    2 : tunables    0    0
   0 : slabdata    150    150      0
inode_cache         3185   3195   1040   15    4 : tunables    0    0
   0 : slabdata    213    213      0
dentry            274295 274300    312   13    1 : tunables    0    0
   0 : slabdata  21100  21100      0
names_cache           14     14   4224    7    8 : tunables    0    0
   0 : slabdata      2      2      0
key_jar                0      0    320   12    1 : tunables    0    0
   0 : slabdata      0      0      0
buffer_head       120232 120244    176   23    1 : tunables    0    0
   0 : slabdata   5228   5228      0
vm_area_struct     10385  10768    248   16    1 : tunables    0    0
   0 : slabdata    673    673      0
mm_struct            111    140   1152   14    4 : tunables    0    0
   0 : slabdata     10     10      0
fs_cache             125    147    192   21    1 : tunables    0    0
   0 : slabdata      7      7      0
files_cache          122    144    896   18    4 : tunables    0    0
   0 : slabdata      8      8      0
signal_cache         164    192   1024   16    4 : tunables    0    0
   0 : slabdata     12     12      0
sighand_cache        161    182   2240   14    8 : tunables    0    0
   0 : slabdata     13     13      0
task_xstate           66     72    640   12    2 : tunables    0    0
   0 : slabdata      6      6      0
task_struct          241    256   3872    8    8 : tunables    0    0
   0 : slabdata     32     32      0
cred_jar             366    560    256   16    1 : tunables    0    0
   0 : slabdata     35     35      0
anon_vma            2206   2310    136   30    1 : tunables    0    0
   0 : slabdata     77     77      0
pid                  257    273    192   21    1 : tunables    0    0
   0 : slabdata     13     13      0
shared_policy_node      0      0    120   34    1 : tunables    0    0
   0 : slabdata      0      0      0
numa_policy           42     42     96   42    1 : tunables    0    0
   0 : slabdata      1      1      0
idr_layer_cache      403    403    616   13    2 : tunables    0    0
   0 : slabdata     31     31      0
kmalloc-8192          28     30   8264    3    8 : tunables    0    0
   0 : slabdata     10     10      0
kmalloc-4096         661    665   4168    7    8 : tunables    0    0
   0 : slabdata     95     95      0
kmalloc-2048         335    360   2120   15    8 : tunables    0    0
   0 : slabdata     24     24      0
kmalloc-1024         479    609   1096   29    8 : tunables    0    0
   0 : slabdata     21     21      0
kmalloc-512          783    784    584   14    2 : tunables    0    0
   0 : slabdata     56     56      0
kmalloc-256          535    552    328   12    1 : tunables    0    0
   0 : slabdata     46     46      0
kmalloc-128          309    360    200   20    1 : tunables    0    0
   0 : slabdata     18     18      0
kmalloc-64          2430   2520    136   30    1 : tunables    0    0
   0 : slabdata     84     84      0
kmalloc-32           656    663    104   39    1 : tunables    0    0
   0 : slabdata     17     17      0
kmalloc-16          2250   2254     88   46    1 : tunables    0    0
   0 : slabdata     49     49      0
kmalloc-8           3619   3621     80   51    1 : tunables    0    0
   0 : slabdata     71     71      0
kmalloc-192         1449   1455    264   15    1 : tunables    0    0
   0 : slabdata     97     97      0
kmalloc-96           726    816    168   24    1 : tunables    0    0
   0 : slabdata     34     34      0
kmem_cache_node        0      0    176   23    1 : tunables    0    0
   0 : slabdata      0      0      0

>
> Larry, you say the buffer is 700-800 bytes. Can you confirm that 800
bytes
> is roughly the request size being made by ieee80211_skb_resize()?

For some of the failures, the size was in the 700-800 range, but the
ones I found in my logs called pskb_expand_head() with skb->data_len
of 1962. For those calls, head_need and tail_need were both 0.

Larry
