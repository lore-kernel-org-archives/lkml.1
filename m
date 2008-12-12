Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbYLLJmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbYLLJmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 04:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758407AbYLLJmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 04:42:17 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:42773 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118AbYLLJmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 04:42:14 -0500
Date: Fri, 12 Dec 2008 10:42:12 +0100
From: Andreas Mohr <andi@lisas.de>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.28-rc7: oldish top core dumps (in its meminfo() function)
Message-ID: <20081212094212.GA14641@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

just wanted to report that top (at least the one of an older procps 2.0.17,
as shipped by RHEL3) acted up on a system here.

It's somewhat likely that this problem occured after S2R resume only,
since I most likely have been running top before already
(I'm doing this all the time...).

No issues whatsoever on 2.6.27.7 which I've been running before
(until I upgraded to -rc7 last week and suspended
and then resumed it today).

...BUT it could perhaps be cosmic S2R corruption within this week,
who knows (although this system has been rock stable all the time before).



!!! NOTE: unusual environment - a full 4GB RAM on x86_32 (P4 2.4GHz) here !!!



Will try -rc8 next.


Oh, dito vmstat (but exactly at the same address in /lib/libproc.so.2.0.17):

procs                      memory      swap          io     system
cpu
 r  b   swpd   free   buff  cache   si   so    bi    bo   in    cs us sy
wa id

Program received signal SIGSEGV, Segmentation fault.
0xb7f4e7b7 in meminfo () from /lib/libproc.so.2.0.17
(gdb) bt
#0  0xb7f4e7b7 in meminfo () from /lib/libproc.so.2.0.17
#1  0x08048d61 in ?? ()
#2  0xbfb86ad0 in ?? ()
#3  0xbfb86c84 in ?? ()
#4  0x080498dc in _IO_stdin_used ()
#5  0xbfb86a40 in ?? ()
#6  0x00000000 in ?? ()





gdb top:
 10:26:08  up 6 days, 20:13, 14 users,  load average: 3.78, 3.80, 2.65
124 processes: 115 sleeping, 9 running, 0 zombie, 0 stopped
CPU states:  cpu    user    nice  system    irq  softirq  iowait    idle
           total   94.6%    0.0%    5.3%   0.0%     0.0%    0.0%    0.0%
           cpu00   95.1%    0.0%    4.8%   0.0%     0.0%    0.0%    0.0%
           cpu01   93.2%    0.0%    6.7%   0.0%     0.0%    0.0%    0.0%

Program received signal SIGSEGV, Segmentation fault.
0xb80c27b7 in meminfo () from /lib/libproc.so.2.0.17
(gdb) bt
#0  0xb80c27b7 in meminfo () from /lib/libproc.so.2.0.17
#1  0x0804d3b8 in ?? ()
#2  0xbfbfca10 in ?? ()
#3  0xb806c003 in __libc_ptyname2 () from /lib/tls/libc.so.6
#4  0x00000000 in ?? ()
(gdb) inf loc
No symbol table info available.




top[8063]: segfault at b7edb000 ip b7ed47b7 sp bfe0d380 error 4 in
libproc.so.2.0.17[b7ece000+9000]





# cat /proc/meminfo
MemTotal:        3854752 kB
MemFree:         2736664 kB
Buffers:           88324 kB
Cached:           391328 kB
SwapCached:        11724 kB
Active:           395092 kB
Inactive:         411004 kB
Active(anon):     171388 kB
Inactive(anon):   159460 kB
Active(file):     223704 kB
Inactive(file):   251544 kB
Unevictable:        2612 kB
Mlocked:            2612 kB
HighTotal:       2990024 kB
HighFree:        2290060 kB
LowTotal:         864728 kB
LowFree:          446604 kB
SwapTotal:       1465120 kB
SwapFree:        1426960 kB
Dirty:              1708 kB
Writeback:             0 kB
AnonPages:        321408 kB
Mapped:            43200 kB
Slab:             299256 kB
SReclaimable:     269684 kB
SUnreclaim:        29572 kB
PageTables:         2284 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     3392496 kB
Committed_AS:     506384 kB
VmallocTotal:     122880 kB
VmallocUsed:        2180 kB
VmallocChunk:     118452 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       4096 kB
DirectMap4k:       20472 kB
DirectMap4M:      888832 kB




# cat /proc/slabinfo
slabinfo - version: 2.1
# name            <active_objs> <num_objs> <objsize> <objperslab> <pagesperslab> : tunables <limit> <batchcount> <sharedfactor> : slabdata <active_slabs> <num_slabs> <sharedavail>
smb_inode_cache       19     34    472   17    2 : tunables    0    0    0 : slabdata      2      2      0
cifs_request           7      7  16512    1    8 : tunables    0    0    0 : slabdata      7      7      0
cifs_inode_cache   39552  39632    488   16    2 : tunables    0    0    0 : slabdata   2477   2477      0
flow_cache             0      0     80   51    1 : tunables    0    0    0 : slabdata      0      0      0
mqueue_inode_cache      1     21    768   21    4 : tunables    0    0    0 : slabdata      1      1      0
romfs_inode_cache      0      0    456   17    2 : tunables    0    0    0 : slabdata      0      0      0
isofs_inode_cache      0      0    480   17    2 : tunables    0    0    0 : slabdata      0      0      0
hugetlbfs_inode_cache      1     18    448   18    2 : tunables    0    0    0 : slabdata      1      1      0
ext2_inode_cache       0      0    648   12    2 : tunables    0    0    0 : slabdata      0      0      0
journal_handle       340    340     24  170    1 : tunables    0    0    0 : slabdata      2      2      0
journal_head         172    657     56   73    1 : tunables    0    0    0 : slabdata      9      9      0
revoke_record        512    512     16  256    1 : tunables    0    0    0 : slabdata      2      2      0
ext3_inode_cache  319620 319620    640   12    2 : tunables    0    0    0 : slabdata  26635  26635      0
ext3_xattr             0      0     48   85    1 : tunables    0    0    0 : slabdata      0      0      0
dquot                  0      0    256   16    1 : tunables    0    0    0 : slabdata      0      0      0
shmem_inode_cache     28     28    560   14    2 : tunables    0    0    0 : slabdata      2      2      0
UDP                  202    204    640   12    2 : tunables    0    0    0 : slabdata     17     17      0
TCP                   69     69   1408   23    8 : tunables    0    0    0 : slabdata      3      3      0
blkdev_queue          18     22   1464   22    8 : tunables    0    0    0 : slabdata      1      1      0
blkdev_requests       44     54    224   18    1 : tunables    0    0    0 : slabdata      3      3      0
biovec-256            10     10   3072   10    8 : tunables    0    0    0 : slabdata      1      1      0
biovec-128            42     42   1536   21    8 : tunables    0    0    0 : slabdata      2      2      0
biovec-64             49     63    768   21    4 : tunables    0    0    0 : slabdata      3      3      0
sock_inode_cache     257    272    512   16    2 : tunables    0    0    0 : slabdata     17     17      0
file_lock_cache       68     68    120   34    1 : tunables    0    0    0 : slabdata      2      2      0
Acpi-Operand         612    612     40  102    1 : tunables    0    0    0 : slabdata      6      6      0
Acpi-Namespace       847    850     24  170    1 : tunables    0    0    0 : slabdata      5      5      0
proc_inode_cache     635    663    472   17    2 : tunables    0    0    0 : slabdata     39     39      0
sigqueue              56     56    144   28    1 : tunables    0    0    0 : slabdata      2      2      0
radix_tree_node    13220  19604    296   13    1 : tunables    0    0    0 : slabdata   1508   1508      0
bdev_cache            13     24    640   12    2 : tunables    0    0    0 : slabdata      2      2      0
sysfs_dir_cache     5777   5780     48   85    1 : tunables    0    0    0 : slabdata     68     68      0
inode_cache         1080   1098    448   18    2 : tunables    0    0    0 : slabdata     61     61      0
dentry            159325 159348    144   28    1 : tunables    0    0    0 : slabdata   5691   5691      0
avc_node              78    146     56   73    1 : tunables    0    0    0 : slabdata      2      2      0
buffer_head        74206 116800     64   64    1 : tunables    0    0    0 : slabdata   1825   1825      0
vm_area_struct      4735   4876     88   46    1 : tunables    0    0    0 : slabdata    106    106      0
files_cache          113    147    384   21    2 : tunables    0    0    0 : slabdata      7      7      0
sighand_cache        141    161   1408   23    8 : tunables    0    0    0 : slabdata      7      7      0
task_struct          143    160   3120   10    8 : tunables    0    0    0 : slabdata     16     16      0
anon_vma            2169   2304     32  128    1 : tunables    0    0    0 : slabdata     18     18      0
idr_layer_cache      130    130    152   26    1 : tunables    0    0    0 : slabdata      5      5      0
kmalloc-4096          42     56   4096    8    8 : tunables    0    0    0 : slabdata      7      7      0
kmalloc-2048         308    368   2048   16    8 : tunables    0    0    0 : slabdata     23     23      0
kmalloc-1024         238    272   1024   16    4 : tunables    0    0    0 : slabdata     17     17      0
kmalloc-512          652    688    512   16    2 : tunables    0    0    0 : slabdata     43     43      0
kmalloc-256         2780   3120    256   16    1 : tunables    0    0    0 : slabdata    195    195      0
kmalloc-128         1062   1344    128   32    1 : tunables    0    0    0 : slabdata     42     42      0
kmalloc-64        369191 391872     64   64    1 : tunables    0    0    0 : slabdata   6123   6123      0
kmalloc-32          1109   1152     32  128    1 : tunables    0    0    0 : slabdata      9      9      0
kmalloc-16          4077   5376     16  256    1 : tunables    0    0    0 : slabdata     21     21      0
kmalloc-8           2039   2048      8  512    1 : tunables    0    0    0 : slabdata      4      4      0
kmalloc-192          124    126    192   21    1 : tunables    0    0    0 : slabdata      6      6      0
kmalloc-96           487    546     96   42    1 : tunables    0    0    0 : slabdata     13     13      0





# cat /proc/mtrr
reg00: base=0x000000000 (    0MB), size= 2048MB, count=1: write-back
reg01: base=0x080000000 ( 2048MB), size= 1024MB, count=1: write-back
reg02: base=0x0c0000000 ( 3072MB), size=  512MB, count=1: write-back
reg03: base=0x0e0000000 ( 3584MB), size=  128MB, count=1: write-back
reg04: base=0x0e8000000 ( 3712MB), size=   64MB, count=1: write-back
reg05: base=0x0ec000000 ( 3776MB), size=   32MB, count=1: write-back
reg06: base=0x0feda0000 ( 4077MB), size=  128KB, count=1: write-back
reg07: base=0x0f0000000 ( 3840MB), size=  128MB, count=1:
write-combining



Thanks,

Andreas Mohr
