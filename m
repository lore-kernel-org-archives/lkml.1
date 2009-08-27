Return-Path: <linux-kernel-owner+w=401wt.eu-S1752467AbZH0MaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbZH0MaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbZH0MaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:30:18 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:47939 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbZH0MaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:30:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oSoVgO+AZlixX7e5b9nt8etNt+CS+f1yYyrXKEML5PAPJLtHSXa7/Fdu9uSpVHwZGU
         pnf3PueN+u5trQDG0taGrkuRa6fChJ6skeh0349ztx+zKX2riTrWfgODFaRKV6Xg58uo
         +zM8ExIpxxXyExhT/OFjkNiEw2EbYkcuV4OAk=
MIME-Version: 1.0
Date: Thu, 27 Aug 2009 08:30:18 -0400
Message-ID: <a788e9ca0908270530s50a7e7fdu5c48299403b80d9b@mail.gmail.com>
Subject: Re: [PATCH] allow disabling IMA at runtime
From: David Safford <david.safford@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: zohar@us.ibm.com, Kyle McMartin <kyle@mcmartin.ca>,
       "'David Safford'" <safford@us.ibm.com>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Hey Mimi, I was going to get in touch with you today, I don't really
>think this patch is necessary.  Kyle hacked it together because it was a
>quick and dirty 'fix' for a memory leak that he didn't want to hunt down
>and he knows I won't let him compile IMA out *smile*.  Intended to try
>to track it down this morning, but I'm getting swamped already, maybe
>you can try to figure out what's going on before I get a chance to come
>back to it this afternoon?
>
>nfs_inode_cache       34     34   1824   17    8 : tunables    0    0    0 : slabdata      2      2      0
>fuse_inode            22     22   1472   22    8 : tunables    0    0    0 : slabdata      1      1      0
>rpc_inode_cache       40     40   1600   20    8 : tunables    0    0    0 : slabdata      2      2      0
>btrfs_inode_cache  10622  10668   2328   14    8 : tunables    0    0    0 : slabdata    762    762      0
>iint_cache        369714 369720    312   26    2 : tunables    0    0    0 : slabdata  14220  14220      0
>mqueue_inode_cache     19     19   1664   19    8 : tunables    0    0    0 : slabdata      1      1      0
>isofs_inode_cache      0      0   1288   25    8 : tunables    0    0    0 : slabdata      0      0      0
>hugetlbfs_inode_cache     24     24   1312   24    8 : tunables    0    0    0 : slabdata      1      1      0
>ext4_inode_cache       0      0   1864   17    8 : tunables    0    0    0 : slabdata      0      0      0
>ext3_inode_cache      19     19   1656   19    8 : tunables    0    0    0 : slabdata      1      1      0
>inotify_inode_mark_entry    253    255    240   17    1 : tunables    0    0    0 : slabdata     15     15      0
>shmem_inode_cache   2740   3003   1560   21    8 : tunables    0    0    0 : slabdata    143    143      0
>sock_inode_cache     902    920   1408   23    8 : tunables    0    0    0 : slabdata     40     40      0
>proc_inode_cache    3060   3075   1288   25    8 : tunables    0    0    0 : slabdata    123    123      0
>inode_cache         9943  10192   1240   26    8 : tunables    0    0    0 : slabdata    392    392      0
>selinux_inode_security  27237  27838    264   31    2 : tunables    0    0    0 : slabdata    898    898      0
>
>So the iint_cache is a LOT larger than all of the inode caches put
>together.  This is a 2.6.31-0.167.rc6.git6.fc12.x86_64 kernel without
>any kernel options.
>
>-Eric
>

Sorry about the delay - we had a major fiber cut in Hawthorne yesterday.
I'm running 2.6.30.4, and here are my numbers, which look more reasonable.
I'm guessing there may be a IMA free imbalance in btrfs, which we have
not really tested. Are you getting imbalance messages?

I'll try to look at it today...

dave safford

fat_inode_cache       20     20    408   20    2 : tunables    0    0
  0 : slabdata      1      1      0
fat_cache              0      0     24  170    1 : tunables    0    0
  0 : slabdata      0      0      0
iint_cache         71720  73797     80   51    1 : tunables    0    0
  0 : slabdata   1447   1447      0
mqueue_inode_cache     14     14    576   14    2 : tunables    0    0
   0 : slabdata      1      1      0
isofs_inode_cache      0      0    384   21    2 : tunables    0    0
  0 : slabdata      0      0      0
hugetlbfs_inode_cache     23     23    352   23    2 : tunables    0
 0    0 : slabdata      1      1      0
ext4_inode_cache   53826  53830    584   14    2 : tunables    0    0
  0 : slabdata   3845   3845      0
ext3_inode_cache   13999  14080    512   16    2 : tunables    0    0
  0 : slabdata    880    880      0
shmem_inode_cache   1723   1734    456   17    2 : tunables    0    0
  0 : slabdata    102    102      0
sock_inode_cache     800    846    448   18    2 : tunables    0    0
  0 : slabdata     47     47      0
skbuff_fclone_cache     42     42    384   21    2 : tunables    0
0    0 : slabdata      2      2      0
file_lock_cache       78     78    104   39    1 : tunables    0    0
  0 : slabdata      2      2      0
proc_inode_cache     607    903    376   21    2 : tunables    0    0
  0 : slabdata     43     43      0
bdev_cache            48     48    512   16    2 : tunables    0    0
  0 : slabdata      3      3      0
sysfs_dir_cache    11474  11475     48   85    1 : tunables    0    0
  0 : slabdata    135    135      0
inode_cache          813   1449    352   23    2 : tunables    0    0
  0 : slabdata     63     63      0
signal_cache         190    196    576   14    2 : tunables    0    0
  0 : slabdata     14     14      0
sighand_cache        186    192   1344   12    4 : tunables    0    0
  0 : slabdata     16     16      0
idr_layer_cache      739    780    152   26    1 : tunables    0    0
  0 : slabdata     30     30      0
