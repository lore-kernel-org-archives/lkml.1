Return-Path: <linux-kernel-owner+w=401wt.eu-S1764029AbZAUKnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764029AbZAUKnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbZAUKnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:43:21 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:58710 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbZAUKnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:43:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=C5PupzSj72QPmAnwaDm6FTgy4UyakfWanYQvJ15CTpFcioZmGPU5KIRDq/yGCMLgcL
         oh893fKXUK6VIhYf5Y1a6ljTuYddCsATd1Z4wkXvpMNRkvgUEeW2LNgQiKm5Uyl75dD0
         +rBbg6AptJq9LyNvOHHSn5ZOH5X7xR3MVUU64=
MIME-Version: 1.0
Date: Wed, 21 Jan 2009 11:43:17 +0100
Message-ID: <c4e36d110901210243t5d12016bwc20153afd4828fcd@mail.gmail.com>
Subject: lock_stat and ext3 journal
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm noticing some 'throughput' problems - generally when I download
something via wget from a gigabit network or I do some highly disk
intensive operation my system becomes mostly unresponsive (well might
be the fault of Xorg, Firefox or a lot of other apps & daemons running
on my system).  But I'm trying to find the reason for this.

For the  beginning I've noticed that my '/proc/lock_stat' contains
couple of entries which I'd like to get explained.

I've selected just those,  where the timing is IMHO too high - or
where the elements are negative ?? hmm going back in time ?
Some 'waittime-max' looks quite big?


Also - these numbers are from the system which was not yet stress
tested - otherwise especially those journal_locks are getting much
bigger.

- So there anyone who could enlighten me here a bit ?

(also note - it's note a recent change, but rather I'm noticing that
my system subjectively becomes slowly slower and slower - which is
kind of strange, when I read threads, where some very detailed and
tiny optimization are being solved)

# grep : /proc/lock_stat | head
                                 c3_lock:       1709597        1709597
          1.19        1245.64    12885278.26        5820167
9155808           0.27        1733.95    60164545.88
                        clockevents_lock:        816733         817012
          0.38         751.27    10615922.86        4226885
9195109           1.64        1494.77    64062913.50
                     tick_broadcast_lock:        587278         587278
          0.52         892.29     7050297.72        5715681
11181397           0.61        1343.49    58798444.67
                  acpi_gbl_hardware_lock:        117319         117319
          0.33         613.60      272137.81        5842265
10908941           2.65        1729.96    61582451.70
                              xtime_lock:         15117          15117
          6.15          15.05       75883.63         508189
1350624           0.45         972.84     7759418.54
                          tty_ldisc_lock:          4964           4964
          0.36           5.70        5277.87          78064
2683986           0.24         938.09     3503162.47
                  &journal->j_state_lock:          4507           4507
          0.35        1062.04        6572.39          17718
1823191           0.40        4792.38     4013870.91
                &dev_priv->user_irq_lock:          3327           3327
          0.39           3.88        2105.70         179501
688166           0.82          53.12      794627.78
                             dcache_lock:          3204           3204
          0.32        2474.09        8392.87          95852
2346603           0.24       32470.17     3402534.92
                                &q->lock:          2994           2994
          0.38         100.69        4207.32        1981225
67538708           0.24        1068.14    76577594.63



class name    con-bounces    contentions   waittime-min   waittime-max
waittime-total    acq-bounces   acquisitions   holdtime-min
holdtime-max holdtime-total

&journal->j_state_lock:          4500           4500           0.35
    1062.04        6447.36          17419        1811911
0.45        4792.38     3982424.30
                  ----------------------
                  &journal->j_state_lock           2578
[<ffffffff80350bb3>] start_this_handle+0x73/0x410
                  &journal->j_state_lock           1886
[<ffffffff8034fa22>] journal_stop+0xd2/0x2a0
                  &journal->j_state_lock              4
[<ffffffff8035143b>] journal_commit_transaction+0x14b/0x1340
                  &journal->j_state_lock              3
[<ffffffff803518b8>] journal_commit_transaction+0x5c8/0x1340
                  ----------------------
                  &journal->j_state_lock           1805
[<ffffffff80350bb3>] start_this_handle+0x73/0x410
                  &journal->j_state_lock           2646
[<ffffffff8034fa22>] journal_stop+0xd2/0x2a0
                  &journal->j_state_lock              1
[<ffffffff8034f4df>] journal_invalidatepage+0xef/0x360
                  &journal->j_state_lock             26
[<ffffffff8035137e>] journal_commit_transaction+0x8e/0x1340


dcache_lock:          3204           3204           0.32
2474.09        8392.87          92503        2302424           0.24
   32470.17     3286691.04
                             -----------
                             dcache_lock            425
[<ffffffff802ee9d2>] d_alloc+0x152/0x200
                             dcache_lock            396
[<ffffffff802eda29>] d_instantiate+0x29/0x60
                             dcache_lock             32
[<ffffffff802f94d6>] dcache_readdir+0xd6/0x230
                             dcache_lock              4
[<ffffffff802ee14c>] d_splice_alias+0x6c/0x100
                             -----------
                             dcache_lock            399
[<ffffffff802eda29>] d_instantiate+0x29/0x60
                             dcache_lock            319
[<ffffffff802ec4f5>] d_rehash+0x25/0x60
                             dcache_lock           1897
[<ffffffff803a0830>] _atomic_dec_and_lock+0x60/0x80
                             dcache_lock            125
[<ffffffff802ed812>] d_path+0xc2/

sysfs_mutex:           184            184       -541.-53
4753.53       30083.11           3366         151246           0.84
     934.33      351254.19
                             -----------
                             sysfs_mutex             93
[<ffffffff80335fa7>] sysfs_lookup+0x37/0xf0
                             sysfs_mutex             77
[<ffffffff80336247>] sysfs_addrm_start+0x37/0xc0
                             sysfs_mutex             12
[<ffffffff803370ec>] sysfs_follow_link+0x6c/0x1b0
                             sysfs_mutex              1
[<ffffffff803362b4>] sysfs_addrm_start+0xa4/0xc0
                             -----------
                             sysfs_mutex             63
[<ffffffff80336247>] sysfs_addrm_start+0x37/0xc0
                             sysfs_mutex            112
[<ffffffff80335fa7>] sysfs_lookup+0x37/0xf0
                             sysfs_mutex              1
[<ffffffff80335dce>] sysfs_readdir+0x6e/0x1d0
                             sysfs_mutex              8
[<ffffffff803370ec>] sysfs_follow_link+0x6c/0x1b0


   &dev->struct_mutex:           123            142           6.57
  25418.65       49579.76          22904       15884626       -539.-45
      69493.31    56218443.89
                      ------------------
                      &dev->struct_mutex             67
[<ffffffffa02b97ca>] i915_gem_retire_work_handler+0x3a/0x90 [i915]
                      &dev->struct_mutex             31
[<ffffffffa02ba84f>] i915_gem_set_domain_ioctl+0x9f/0x110 [i915]
                      &dev->struct_mutex             12
[<ffffffffa02ba542>] i915_gem_busy_ioctl+0x32/0xd0 [i915]
                      &dev->struct_mutex             30
[<ffffffffa02ba74e>] i915_gem_sw_finish_ioctl+0x5e/0xc0 [i915]
                      ------------------
                      &dev->struct_mutex              8
[<ffffffffa02ba74e>] i915_gem_sw_finish_ioctl+0x5e/0xc0 [i915]
                      &dev->struct_mutex             75
[<ffffffffa02b97ca>] i915_gem_retire_work_handler+0x3a/0x90 [i915]
                      &dev->struct_mutex              7
[<ffffffffa02b9e4c>] i915_gem_throttle_ioctl+0x2c/0x60 [i915]
                      &dev->struct_mutex             10
[<ffffffffa02ba84f>] i915_gem_set_domain_ioctl+0x9f/0x110 [i915]

&inode->inotify_mutex:           115            115           7.36
 475339.29     7306472.15          35790         157494           0.74
      34968.21      258578.07
                   ---------------------
                   &inode->inotify_mutex            115
[<ffffffff8030b26b>] inotify_inode_queue_event+0x4b/0x100
                   ---------------------
                   &inode->inotify_mutex            115
[<ffffffff8030b26b>] inotify_inode_queue_event+0x4b/0x100


&journal->j_list_lock:           556            556           0.38
  18912.40       53134.73          10535         985281           0.26
      37684.47     1794213.35
                   ---------------------
                   &journal->j_list_lock            513
[<ffffffff8034fe7c>] journal_dirty_data+0x8c/0x240
                   &journal->j_list_lock              2
[<ffffffff8034f511>] journal_invalidatepage+0x121/0x360
                   &journal->j_list_lock              5
[<ffffffff8034f122>] journal_dirty_metadata+0xf2/0x150
                   &journal->j_list_lock             16
[<ffffffff803520f9>] journal_commit_transaction+0xe09/0x1340
                   ---------------------
                   &journal->j_list_lock              3
[<ffffffff80350639>] do_get_write_access+0x4a9/0x590
                   &journal->j_list_lock              5
[<ffffffff803519c6>] journal_commit_transaction+0x6d6/0x1340
                   &journal->j_list_lock             53
[<ffffffff803515eb>] journal_commit_transaction+0x2fb/0x1340
                   &journal->j_list_lock              1
[<ffffffff803517dd>] journal_commit_transaction+0x4ed/0x1340


&type->i_mutex_dir_key#4:            87            208       -554.-66
   1184994.39     7934645.57          11754         115329
-322.-9     1273619.56    58923253.04
                ------------------------
                &type->i_mutex_dir_key#4            144
[<ffffffff802e3c71>] do_lookup+0xd1/0x260
                &type->i_mutex_dir_key#4             64
[<ffffffff802ea3b4>] vfs_readdir+0x84/0xd0
                ------------------------
                &type->i_mutex_dir_key#4            147
[<ffffffff802e3c71>] do_lookup+0xd1/0x260
                &type->i_mutex_dir_key#4             61
[<ffffffff802ea3b4>] vfs_readdir+0x84/0xd0


Zdenek
