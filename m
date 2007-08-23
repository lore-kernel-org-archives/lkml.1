Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbXHWAvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbXHWAvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 20:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbXHWAuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 20:50:55 -0400
Received: from mail.spacing-guild.net ([72.29.67.242]:37155 "EHLO
	mail.spacing-guild.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbXHWAuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 20:50:54 -0400
X-Greylist: delayed 1545 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Aug 2007 20:50:54 EDT
Message-ID: <46CCD3DF.4080303@fuster.org>
Date: Wed, 22 Aug 2007 20:25:03 -0400
From: Joel Fuster <j@fuster.org>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070621)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Joel Fuster <j@fuster.org>
Subject: sysfs_dir_cache growing out of control
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am running 2.6.22.3.  For reasons that escape me, over time (days) the 
sysfs_dir_cache, dentry, and inode_cache SLUB entries grow until they 
consume all the memory on my system, requiring a reboot.

Although I did not record objective evidence of this at the time, I 
suspect I had the same problem with 2.6.18 and 2.6.20...I certainly had 
the same symptoms.

Here is some hopefully useful information.  Let me know what else would 
be helpful.

Thanks.

P.S. Please keep me CC'd as I do not subscribe to the list.

Linux periphas 2.6.22.3 #1 SMP Mon Aug 20 21:47:51 EDT 2007 x86_64 GNU/Linux

*************************************
  18:30:02 up 21:27,  4 users,  load average: 0.22, 0.36, 0.35
MemTotal:      1026056 kB
MemFree:          8996 kB
Buffers:           176 kB
Cached:         209524 kB
SwapCached:      32308 kB
Active:         610448 kB
Inactive:       170004 kB
SwapTotal:     1048568 kB
SwapFree:       710260 kB
Dirty:            2444 kB
Writeback:           0 kB
AnonPages:      568988 kB
Mapped:          34360 kB
Slab:           210664 kB
SReclaimable:   179460 kB
SUnreclaim:      31204 kB
PageTables:      10008 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   1561596 kB
Committed_AS:  1184628 kB
VmallocTotal: 34359738367 kB
VmallocUsed:      1032 kB
VmallocChunk: 34359737307 kB
Name                   Objects Objsize    Space Slabs/Part/Cpu  O/S O 
%Fr %Ef Flg
:0000016                  2937      16    65.5K         16/5/2  256 0 
31  71 *
:0000024                  1222      24    32.7K          8/0/2  170 0 
0  89 *
:0000032                  2095      32    73.7K         18/3/2  128 0 
16  90 *
:0000040                  1862      40   172.0K        42/31/2  102 0 
73  43 *
:0000064                  4651      64   434.1K       106/46/2   64 0 
43  68 *
:0000072                    81      72     8.1K          2/0/2   56 0 
0  71 *
:0000096                   937      96   135.1K        33/14/2   42 0 
42  66 *
:0000112                   144     112    16.3K          4/0/1   36 0 
0  98 *
:0000128                   595     128   118.7K        29/19/2   32 0 
65  64 *
:0000192                   807     192   262.1K        64/36/2   21 0 
56  59 *
:0000256                  3504     256   897.0K        219/0/2   16 0 
0 100 *
:0000320                    47     320    16.3K          4/1/2   12 0 
25  91 *A
:0000384                    56     384    28.6K          7/1/2   10 0 
14  75 *A
:0000512                   238     512   135.1K         33/7/2    8 0 
21  90 *
:0000704                   133     704   114.6K         14/7/2   11 1 
50  81 *A
:0000768                   180     744   159.7K         39/9/2    5 0 
23  83 *A
:0000832                    90     832   114.6K        14/11/2    9 1 
78  65 *A
:0001024                   370    1024   393.2K         96/9/2    4 0 
9  96 *
:0002048                   474    2048   974.8K        119/1/2    4 1 
0  99 *
:0004096                   114    4096   483.3K         59/2/2    2 1 
3  96 *
Acpi-State                 102      80     8.1K          2/0/2   51 0 
0  99
anon_vma                  2561      24    90.1K        22/10/2  128 0 
45  68
bdev_cache                  53     736    45.0K         11/0/2    5 0 
0  86 Aa
blkdev_queue                45    1480    73.7K          9/0/2    5 1 
0  90
blkdev_requests             42     280    16.3K          4/0/2   14 0 
0  71
buffer_head               2695     104   327.6K        80/25/2   39 0 
31  85 a
cfq_io_context             189     152    32.7K          8/3/2   26 0 
37  87
cfq_queue                  203     144    32.7K          8/4/2   28 0 
50  89
dentry                  228340     200    46.7M      11418/0/2   20 0 
0  97 a
ext3_inode_cache            16     736    24.5K          6/4/2    5 0 
66  47 a
file_lock_cache             46     176    16.3K          4/2/2   22 0 
50  49
idr_layer_cache            135     528    81.9K         20/1/2    7 0 
5  87
inode_cache             224448     536   131.3M      32065/0/2    7 0 
0  91 a
kmalloc-16384                8   16384   163.8K         10/0/2    1 2 
0  80
kmalloc-32768               34   32768     1.1M         34/0/1    1 3 
0 100
kmalloc-65536                3   65536   196.6K          3/0/2    1 4 
0 100
kmalloc-8                  893       8     8.1K          2/0/2  512 0 
0  87
kmalloc-8192                14    8192   131.0K         16/0/2    1 1 
0  87
kmalloc_dma-512              8     512     4.0K          1/0/1    8 0 
0 100 d
mqueue_inode_cache           9     824     8.1K          1/0/1    9 1 
0  90 A
proc_inode_cache            28     568    40.9K         10/8/2    7 0 
80  38 a
radix_tree_node           2759     552     2.2M      544/243/2    7 0 
44  68
raid5-md2                  259     584   151.5K         37/0/1    7 0 
0  99
shmem_inode_cache          524     728   434.1K        106/5/2    5 0 
4  87
sighand_cache              135    2080   376.8K         46/2/2    3 1 
4  74 A
sigqueue                     8     160     8.1K          2/0/2   25 0 
0  15
sock_inode_cache           261     616   192.5K         47/8/2    6 0 
17  83 Aa
sysfs_dir_cache         229196      88    20.4M       4984/2/2   46 0 
0  98
task_struct                152    1696   327.6K         40/6/2    4 1 
15  78
TCP                         27    1496    57.3K          7/2/2    5 1 
28  70 A
UNIX                       218     640   155.6K         38/5/2    6 0 
13  89 A
vm_area_struct            7107     168     1.2M       300/19/2   24 0 
6  97
xfs_acl                     14     304     8.1K          2/0/2   13 0 
0  51
xfs_buf_item                30     184     8.1K          2/0/2   22 0 
0  67
xfs_da_state                 8     488     8.1K          2/0/2    8 0 
0  47
xfs_efd_item                11     360     8.1K          2/0/2   11 0 
0  48
xfs_efi_item                12     352     8.1K          2/0/2   11 0 
0  51
xfs_inode                 4634     544     2.7M        662/0/2    7 0 
0  92 Aa
xfs_vnode                 4638     576     3.1M        773/0/2    6 0 
0  84 Aa




