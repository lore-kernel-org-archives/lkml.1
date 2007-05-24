Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbXEXVaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbXEXVaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbXEXVaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:30:15 -0400
Received: from web52603.mail.re2.yahoo.com ([206.190.48.206]:43730 "HELO
	web52603.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751144AbXEXVaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:30:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=OBh8KfqyYWthADyQzyV/fA3ZL0ANh96l6ZkjGoTBPY3KYOk1QkSZ4Rx3qDzZI2ln0fJdJmckkHaPHizUZdvMfGOh9cTm5E8aWluw1kcGUibKKxCnnbiD/rX8JL1viQmpAJ6aBVfG6jMLZROvA/3I1sOKaFtOrIIIINj20m/G4pc=;
X-YMail-OSG: h9tiv6oVM1lcLrD2Jh0CEififTFvRdVpRdd8Kl1cUXJPK8zDu6uzIkNawDeMpLFcIjJteOKd0lP_wU.KZ6A.q9lTn5_UzHTIjJZCFVJaRkl9NnIk3Irvvkbf9tVTd9Mz__rNbN_yR_M5Q1_a8zMpJHLQsA--
Date: Fri, 25 May 2007 07:30:11 +1000 (EST)
From: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0705240957430.28086@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-947606011-1180042211=:99748"
Content-Transfer-Encoding: 8bit
Message-ID: <82244.99748.qm@web52603.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--0-947606011-1180042211=:99748
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

--- Christoph Lameter <clameter@sgi.com> wrote:
[...]
> You need to be root to do this. Sorry.

Of course, I tried it as root also.

(Kernel hg commit a4c9979b8d42 is 2.6.22-rc2 + all commits available as of a
few minutes ago)

[root@fedora7 ~]# whoami
root

[root@fedora7 ~]# uname -a
Linux fedora7 2.6.22-rc2-a4c9979b8d42 #1 SMP Fri May 25 06:32:20 EST 2007
x86_64 x86_64 x86_64 GNU/Linux

[root@fedora7 ~]# egrep -i 'slub' /proc/cmdline
/boot/config-2.6.22-rc2-a4c9979b8d42
/proc/cmdline:ro root=LABEL=/1234 slub_debug
/boot/config-2.6.22-rc2-a4c9979b8d42:CONFIG_SLUB_DEBUG=y
/boot/config-2.6.22-rc2-a4c9979b8d42:CONFIG_SLUB=y

[root@fedora7 ~]# md5sum /home/hari/linux-2.6/Documentation/vm/slabinfo.c
07a832596203afba9739c27daa059174 
/home/hari/linux-2.6/Documentation/vm/slabinfo.c

[root@fedora7 ~]# gcc --version
gcc (GCC) 4.1.2 20070502 (Red Hat 4.1.2-12)
...

[root@fedora7 ~]# gcc -o /usr/local/bin/slabinfo
/home/hari/linux-2.6/Documentation/vm/slabinfo.c ; echo $?
0

[root@fedora7 ~]# /usr/local/bin/slabinfo -v > slabinfo.txt; echo $?
0

[root@fedora7 ~]# ll slabinfo.txt
-rw-r--r-- 1 root root 0 2007-05-25 07:11 slabinfo.txt

[root@fedora7 ~]# /usr/local/bin/slabinfo > slabinfo_without_v.txt; echo $?
0

[root@fedora7 ~]# ll slabinfo_without_v.txt
-rw-r--r-- 1 root root 7932 2007-05-25 07:14 slabinfo_without_v.txt

I know slabinfo_without_v might not be good enough for you. For completeness,
I attach it here anyway.

(I couldn't attach the 0 byte slabinfo.txt, otherwise I'd've given you that
also. It's unbearable to lose an enormous 0 byte of information.)

Thanks



      ___________________________________________________________________________________
How would you spend $50,000 to create a more sustainable environment in Australia?  Go to Yahoo!7 Answers and share your idea.
http://advision.webevents.yahoo.com/aunz/lifestyle/answers/y7ans-babp_reg.html

--0-947606011-1180042211=:99748
Content-Type: text/plain; name="slabinfo_without_v.txt"
Content-Description: 244129750-slabinfo_without_v.txt
Content-Disposition: inline; filename="slabinfo_without_v.txt"

Name                   Objects Objsize    Space Slabs/Part/Cpu  O/S O %Fr %Ef Flg
Acpi-Namespace             635      32    69.6K         17/1/0   39 0   5  29 PZFU
Acpi-Operand              1975      64   274.4K         67/4/0   30 0   5  46 PZFU
Acpi-Parse                   0      40     8.1K          2/2/0   36 0 100   0 PZFU
Acpi-ParseExt                0      64     8.1K          2/2/0   30 0 100   0 PZFU
Acpi-State                   0      80     8.1K          2/2/0   26 0 100   0 PZFU
anon_vma                  1714      64   237.5K         58/2/2   30 0   3  46 PZFU
arp_cache                    1     300     4.0K          1/1/0   10 0 100   7 APZFU
avc_node                   498      72    86.0K        21/15/1   28 0  71  41 PZFU
avtab_node              110636      24    10.7M       2635/1/0   42 0   0  24 PZFU
bdev_cache                  36    1344    65.5K          8/1/0    5 1  12  73 APaZFU
bio                          2     104     8.1K          2/0/2   21 0   0   2 APZFU
biovec-1                     2      16     8.1K          2/0/2   46 0   0   0 APZFU
biovec-128                   2    2048    16.3K          2/2/0    3 1 100  25 APZFU
biovec-16                    2     256     8.1K          2/2/0   10 0 100   6 APZFU
biovec-256                   2    4096    16.3K          2/0/0    1 1   0  50 APZFU
biovec-4                     2      64     8.1K          2/2/0   21 0 100   1 APZFU
biovec-64                    2    1024    16.3K          2/2/0    7 1 100  12 APZFU
blkdev_ioc                  50      64    12.2K          3/3/0   30 0 100  26 PZFU
blkdev_queue                21    1752    49.1K          6/1/0    4 1  16  74 PZFU
blkdev_requests             16     280    16.3K          4/2/2   11 0  50  27 PZFU
buffer_head               5420     104   970.7K        237/3/2   23 0   1  58 PaZFU
cfq_io_context              51     152    16.3K          4/3/0   18 0  75  47 PZFU
cfq_queue                   58     144    20.4K          5/4/0   18 0  80  40 PZFU
dentry                   21791     240     6.8M       1677/0/2   13 0   0  76 PaZFU
dnotify_cache                1      40     4.0K          1/1/0   36 0 100   0 PZFU
ext3_inode_cache          8478    1376    13.9M       1697/1/2    5 1   0  83 PaZFU
ext3_xattr                 823      88   139.2K         34/1/1   25 0   2  52 PaZFU
fasync_cache                 2      24     4.0K          1/1/0   42 0 100   1 PZFU
file_lock_cache              7     216     8.1K          2/2/0   14 0 100  18 PZFU
files_cache                 67     768    77.8K         19/3/2    4 0  15  66 APZFU
filp                      2531     328     1.1M        283/0/2    9 0   0  71 APZFU
fs_cache                    66     112    16.3K          4/2/2   21 0  50  45 APZFU
hugetlbfs_inode_cache        1    1008     8.1K          1/1/0    7 1 100  12 PZFU
idr_layer_cache            194     528   135.1K         33/2/0    6 0   6  75 PZFU
inode_cache               5617    1008     6.5M        804/0/2    7 1   0  85 PaZFU
inotify_event_cache          0      40     8.1K          2/2/0   36 0 100   0 PZFU
inotify_watch_cache         81      72    16.3K          4/3/0   28 0  75  35 PZFU
ip_dst_cache                14     320    20.4K          5/5/0    9 0 100  21 APZFU
ip_fib_alias                14      48     8.1K          2/2/0   32 0 100   8 APZFU
ip_fib_hash                 14      40     8.1K          2/2/0   32 0 100   6 APZFU
jbd_4k                       0    4096    16.3K          2/0/2    1 1   0   0 PZFU
journal_handle               0      24     8.1K          2/0/2   42 0   0   0 PZFU
journal_head                12      96     8.1K          2/0/2   24 0   0  14 PZFU
key_jar                     15     216    12.2K          3/2/0   12 0  66  26 APZFU
kmalloc-1024               307    1024   368.6K         45/1/2    7 1   2  85 PZFU
kmalloc-128                108     128    28.6K          7/3/0   20 0  42  48 PZFU
kmalloc-131072               1  131072   262.1K          1/0/0    1 6   0  50 PZFU
kmalloc-16               53888      16     4.8M       1173/3/2   46 0   0  17 PZFU
kmalloc-16384               13   16384   491.5K         15/0/2    1 3   0  43 PZFU
kmalloc-192               1036     192   286.7K         70/0/2   15 0   0  69 PZFU
kmalloc-2048               642    2048     1.7M       218/10/2    3 1   4  73 PZFU
kmalloc-256                245     256    94.2K         23/4/2   12 0  17  66 PZFU
kmalloc-32               11251      32     1.1M        290/2/2   39 0   0  30 PZFU
kmalloc-32768                1   32768   131.0K          2/1/0    1 4  50  25 PZFU
kmalloc-4096                43    4096   368.6K         45/0/2    1 1   0  47 PZFU
kmalloc-512                321     512   204.8K         50/6/2    7 0  12  80 PZFU
kmalloc-64                1885      64   266.2K         65/8/2   30 0  12  45 PZFU
kmalloc-8                 5697       8   458.7K        112/2/2   51 0   1   9 PZFU
kmalloc-8192                11    8192   212.9K         13/0/2    1 2   0  42 PZFU
kmalloc-96                 905      96   159.7K         39/1/2   24 0   2  54 PZFU
kmalloc_dma-512              0     512     8.1K          2/0/2    7 0   0   0 dPZFU
mm_struct                   66    1096   106.4K         13/3/2    6 1  23  67 APZFU
mnt_cache                   27     208    12.2K          3/2/0   12 0  66  45 APZFU
mqueue_inode_cache           1    1376     8.1K          1/1/0    5 1 100  16 APZFU
names_cache                  0    4096    16.3K          2/0/2    1 1   0   0 APZFU
nf_nat:help                  0     360     4.0K          1/0/1    9 0   0   0 PZFU
pid                        198      64    32.7K          8/2/2   30 0  25  38 PZFU
proc_inode_cache           398    1040   475.1K         58/3/1    7 1   5  87 PaZFU
radix_tree_node           4425     552     3.0M        738/3/1    6 0   0  80 PZFU
RAW                          3    1088    16.3K          2/2/0    6 1 100  19 APZFU
revoke_record                0      32     8.1K          2/2/0   39 0 100   0 APZFU
revoke_table                 4      16     8.1K          2/2/0   46 0 100   0 PZFU
scsi_cmd_cache               6     384     8.1K          2/0/2    8 0   0  28 APZFU
selinux_inode_security    15234     168     3.6M        898/3/2   17 0   0  69 PZFU
sgpool-128                   2    4096    24.5K          3/1/0    1 1  33  33 APZFU
sgpool-16                    2     512     8.1K          2/0/2    6 0   0  12 APZFU
sgpool-32                    2    1024    16.3K          2/2/0    7 1 100  12 APZFU
sgpool-64                    2    2048    16.3K          2/2/0    3 1 100  25 APZFU
sgpool-8                     2     256     8.1K          2/0/2   10 0   0   6 APZFU
shmem_inode_cache          525    1256   720.8K         88/3/0    6 1   3  91 PZFU
sighand_cache              114    2120   327.6K         40/4/2    3 1  10  73 APZFU
signal_cache               114     784   126.9K         31/4/2    4 0  12  70 APZFU
sigqueue                     0     160     8.1K          2/0/2   17 0   0   0 PZFU
skbuff_fclone_cache          1     452     8.1K          2/2/0    7 0 100   5 APZFU
skbuff_head_cache          257     224    98.3K        24/10/2   12 0  41  58 APZFU
sock_inode_cache           178    1128   270.3K         33/6/1    6 1  18  74 APaZFU
sysfs_dir_cache           8919      80     1.4M        344/1/1   26 0   0  50 PZFU
task_struct                195    3600   827.3K        101/6/2    2 1   5  84 PZFU
TCP                          5    2032    24.5K          3/2/0    3 1  66  41 APZFU
tcp_bind_bucket              4      32     8.1K          2/2/0   39 0 100   1 APZFU
UDP                          3    1104    16.3K          2/1/1    6 1  50  20 APZFU
uid_cache                    6      80     8.1K          2/2/0   21 0 100   5 APZFU
UNIX                       149    1216   212.9K         26/2/1    6 1   7  85 APZFU
vm_area_struct            5621     168     1.3M        334/9/2   17 0   2  69 PZFU

--0-947606011-1180042211=:99748--
