Return-Path: <linux-kernel-owner+w=401wt.eu-S932961AbXCOTRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbXCOTRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932980AbXCOTRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:17:54 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:53920 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932961AbXCOTRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:17:52 -0400
Date: Thu, 15 Mar 2007 20:17:50 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Neil Brown <neilb@suse.de>
Subject: Re: [2.6.20] BUG: workqueue leaked lock
Message-ID: <20070315191749.GS31960@vanheusden.com>
References: <20070313165014.GE31960@vanheusden.com> <20070315110628.8bd2c07b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315110628.8bd2c07b.akpm@linux-foundation.org>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Wed Mar 14 17:22:53 CET 2007
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Tue, 13 Mar 2007 17:50:14 +0100 Folkert van Heusden <folkert@vanheusden.com> wrote:
> > ...
> > [ 1756.728209] BUG: workqueue leaked lock or atomic: nfsd4/0x00000000/3577
...
> > [ 1846.684023]  [<c1003bdb>] kernel_thread_helper+0x7/0x10
> Oleg, that's a fairly incomprehensible message we have in there.  Can you
> please explain what it means?

Haha ok :-)

Good, since I run 2.6.20 with these debugging switches switched on, I
get occasionally errors like these. I get ALWAYS the following error
when the system first boots when the TOR executable is started:

[  137.324255] =======================================================
[  137.324359] [ INFO: possible circular locking dependency detected ]
[  137.324412] 2.6.20 #2
[  137.324457] -------------------------------------------------------
[  137.324510] tor/4857 is trying to acquire lock:
[  137.324559]  (tty_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
[  137.324765]
[  137.324766] but task is already holding lock:
[  137.324859]  (&s->s_dquot.dqptr_sem){----}, at: [<c1099403>] dquot_alloc_space+0x50/0x189
[  137.325067]
[  137.325069] which lock already depends on the new lock.
[  137.325071]
[  137.325206]
[  137.325208] the existing dependency chain (in reverse order) is:
[  137.325300]
[  137.325301] -> #4 (&s->s_dquot.dqptr_sem){----}:
[  137.325501]        [<c10354b8>] check_prev_add+0x154/0x206
[  137.325852]        [<c10355d4>] check_prevs_add+0x6a/0xd5
[  137.326197]        [<c1036dd2>] __lock_acquire+0x61c/0xa05
[  137.326538]        [<c1037624>] lock_acquire+0x62/0x81
[  137.326887]        [<c1032b5f>] down_read+0x2b/0x3d
[  137.327241]        [<c1099403>] dquot_alloc_space+0x50/0x189
[  137.327588]        [<c10a98e6>] ext3_new_blocks+0x44b/0x5a2
[  137.327935]        [<c10abe78>] ext3_alloc_blocks+0x40/0xdf
[  137.328280]        [<c10abf67>] ext3_alloc_branch+0x50/0x21b
[  137.328622]        [<c10ac445>] ext3_get_blocks_handle+0x1b8/0x367
[  137.328980]        [<c10ac76e>] ext3_getblk+0x97/0x228
[  137.329330]        [<c10ac919>] ext3_bread+0x1a/0x78
[  137.329672]        [<c10b1bc2>] ext3_mkdir+0xf4/0x270
[  137.330022]        [<c1072a6a>] vfs_mkdir+0xb3/0x161
[  137.330368]        [<c1072ba4>] sys_mkdirat+0x8c/0xc4
[  137.330714]        [<c1072bfc>] sys_mkdir+0x20/0x22
[  137.331063]        [<c1002f78>] syscall_call+0x7/0xb
[  137.331406]        [<ffffffff>] 0xffffffff
[  137.331771]
[  137.331772] -> #3 (&ei->truncate_mutex){--..}:
[  137.331979]        [<c10354b8>] check_prev_add+0x154/0x206
[  137.332332]        [<c10355d4>] check_prevs_add+0x6a/0xd5
[  137.332676]        [<c1036dd2>] __lock_acquire+0x61c/0xa05
[  137.333025]        [<c1037624>] lock_acquire+0x62/0x81
[  137.333370]        [<c1205c09>] __mutex_lock_slowpath+0x75/0x28c
[  137.333930]        [<c1205b88>] mutex_lock+0x8/0xa
[  137.334271]        [<c10ae14f>] ext3_truncate+0x170/0x468
[  137.334613]        [<c1058e72>] vmtruncate+0xa6/0x116
[  137.334949]        [<c107d587>] inode_setattr+0x145/0x16c
[  137.335286]        [<c10af071>] ext3_setattr+0x150/0x22f
[  137.335627]        [<c107d909>] notify_change+0x35b/0x392
[  137.335968]        [<c10679d2>] do_truncate+0x52/0x75
[  137.336305]        [<c1071f5e>] may_open+0x1ec/0x231
[  137.336642]        [<c107211c>] open_namei+0xda/0x59b
[  137.336975]        [<c106863a>] do_filp_open+0x2c/0x53
[  137.337310]        [<c106896f>] do_sys_open+0x52/0xd8
[  137.337645]        [<c1068a11>] sys_open+0x1c/0x1e
[  137.337980]        [<c1002f78>] syscall_call+0x7/0xb
[  137.338315]        [<ffffffff>] 0xffffffff
[  137.338665]
[  137.338666] -> #2 (&inode->i_alloc_sem){--..}:
[  137.338864]        [<c10354b8>] check_prev_add+0x154/0x206
[  137.339200]        [<c10355d4>] check_prevs_add+0x6a/0xd5
[  137.339535]        [<c1036dd2>] __lock_acquire+0x61c/0xa05
[  137.339200]        [<c10355d4>] check_prevs_add+0x6a/0xd5
[  137.339535]        [<c1036dd2>] __lock_acquire+0x61c/0xa05
[  137.339874]        [<c1037624>] lock_acquire+0x62/0x81
[  137.340207]        [<c1032bf5>] down_write+0x2b/0x45
[  137.340545]        [<c107d890>] notify_change+0x2e2/0x392
[  137.340886]        [<c10679d2>] do_truncate+0x52/0x75
[  137.341222]        [<c1071f5e>] may_open+0x1ec/0x231
[  137.341557]        [<c107211c>] open_namei+0xda/0x59b
[  137.341898]          [<c1068a11>] sys_open+0x1c/0x1e
[  137.343109]        [<c1002f78>] syscall_call+0x7/0xb
[  137.343444]        [<ffffffff>] 0xffffffff
[  137.343792]
[  137.343793] -> #1 (&sysfs_inode_imutex_key){--..}:
[  137.343988]        [<c10354b8>] check_prev_add+0x154/0x206
[  137.344320]        [<c10355d4>] check_prevs_add+0x6a/0xd5
[  137.344655]        [<c1036dd2>] __lock_acquire+0x61c/0xa05
[  137.344986]        [<c1037624>] lock_acquire+0x62/0x81
[  137.345321]        [<c1205c09>] __mutex_lock_slowpath+0x75/0x28c
[  137.345658]        [<c1205b88>] mutex_lock+0x8/0xa
[  137.345991]        [<c10a5447>] sysfs_hash_and_remove+0x43/0x11c
[  137.346328]        [<c10a5ef7>] sysfs_remove_file+0xd/0x12
[  137.346660]        [<c114b00c>] device_remove_file+0x32/0x44
[  137.346992]        [<c114b6d9>] device_del+0x174/0x1d2
[  137.347325]        [<c114b742>] device_unregister+0xb/0x15
[  137.347661]        [<c114b93d>] device_destroy+0x8d/0x9a
[  137.347994]        [<c1137a38>] vcs_remove_sysfs+0x1c/0x38
[  137.348328]        [<c113e0d8>] con_close+0x5e/0x6b
[  137.348661]        [<c1130103>] release_dev+0x4c4/0x6ce
[  137.348999]        [<c113077b>] tty_release+0x12/0x1c
[  137.349332]         [<c10aa723>] ext3_file_write+0x2d/0xba
[  137.358495]        [<c1069441>] do_sync_write+0xc7/0x116
[  137.358838]        [<c1069612>] vfs_write+0x182/0x187
[  137.359176]        [<c10696b8>] sys_write+0x3d/0x64
[  137.359513]        [<c1002f78>] syscall_call+0x7/0xb
[  137.359848]        [<ffffffff>] 0xffffffff
[  137.360200]
[  137.360202] other info that might help us debug this:
[  137.360204]
[  137.360335] 3 locks held by tor/4857:
[  137.360382]  #0:  (&inode->i_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
[  137.360625]  #1:  (&ei->truncate_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
[  137.361072]  #2:  (&s->s_dquot.dqptr_sem){----}, at: [<c1099403>] dquot_alloc_space+0x50/0x189
[  137.361313]
[  137.361314] stack backtrace:
[  137.361401]  [<c1003d57>] show_trace_log_lvl+0x1a/0x30
[  137.361488]  [<c1003d7f>] show_trace+0x12/0x14
[  137.361571]  [<c1003e79>] dump_stack+0x16/0x18
[  137.361663]  [<c1034d6d>] print_circular_bug_tail+0x6f/0x71
[  137.361752]  [<c1035398>] check_prev_add+0x34/0x206
[  137.361838]  [<c10355d4>] check_prevs_add+0x6a/0xd5
[  137.362786]  [<c1036dd2>] __lock_acquire+0x61c/0xa05
[  137.362877]  [<c1037624>] lock_acquire+0x62/0x81
[  137.362960]  [<c1205c09>] __mutex_lock_slowpath+0x75/0x28c
[  137.363047]  [<c1205b88>] mutex_lock+0x8/0xa
[  137.363132]  [<c1098d79>] print_warning+0x8c/0x15d
[  137.363217]  [<c1099537>] dquot_alloc_space+0x184/0x189
[  137.363302]  [<c10a98e6>] ext3_new_blocks+0x44b/0x5a2
[  137.363391]  [<c10abe78>] ext3_alloc_blocks+0x40/0xdf
[  137.363476]  [<c10abf67>] ext3_alloc_branch+0x50/0x21b
[  137.363561]  [<c10ac445>] ext3_get_blocks_handle+0x1b8/0x367
[  137.363650]  [<c10ac66c>] ext3_get_block+0x78/0xe3
[  137.363735]  [<c108a239>] __block_prepare_write+0x168/0x3fd
[  137.363822]  [<c108ad10>] block_prepare_write+0x28/0x3b
[  137.363908]  [<c10acbcd>] ext3_prepare_write+0x3f/0x18d
[  137.363996]  [<c104dbe5>] generic_file_buffered_write+0x197/0x5e6
[  137.364084]  [<c104e2e2>] __generic_file_aio_write_nolock+0x2ae/0x5ad
[  137.364171]  [<c104e6ea>] generic_file_aio_write+0x58/0xc4
[  137.364254]  [<c10aa723>] ext3_file_write+0x2d/0xba
[  137.364340]  [<c1069441>] do_sync_write+0xc7/0x116
[  137.364425]  [<c1069612>] vfs_write+0x182/0x187
[  137.364511]  [<c10696b8>] sys_write+0x3d/0x64
[  137.364595]  [<c1002f78>] syscall_call+0x7/0xb
[  137.364682]  =======================


Now apart from this reproducable problem, I suddenly also get these errors in dmesg:

[  137.471738] BUG: workqueue leaked lock or atomic: nfsd4/0x00000000/3577
[  137.471812]     last function: laundromat_main+0x0/0x69 [nfsd]
[  137.471923] 2 locks held by nfsd4/3577:
[  137.471971]  #0:  (client_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
[  137.472209]  #1:  (&inode->i_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
[  137.472445]  [<c1003d57>] show_trace_log_lvl+0x1a/0x30
[  137.472528]  [<c1003d7f>] show_trace+0x12/0x14
[  137.472613]  [<c1003e79>] dump_stack+0x16/0x18
[  137.472695]  [<c102c2e8>] run_workqueue+0x167/0x170
[  137.472779]  [<c102c437>] worker_thread+0x146/0x165
[  137.472861]  [<c102f797>] kthread+0x97/0xc4
[  137.472943]  [<c1003bdb>] kernel_thread_helper+0x7/0x10

These happen on 2 times per minute and then once in 2 minutes.

The last one (while writing this message) is:

[182932.590394] BUG: workqueue leaked lock or atomic: nfsd4/0x00000000/3577
[182932.590450]     last function: laundromat_main+0x0/0x69 [nfsd]
[182932.590557] 2 locks held by nfsd4/3577:
[182932.590600]  #0:  (client_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
[182932.590830]  #1:  (&inode->i_mutex){--..}, at: [<c1205b88>] mutex_lock+0x8/0xa
[182932.591061]  [<c1003d57>] show_trace_log_lvl+0x1a/0x30
[182932.591145]  [<c1003d7f>] show_trace+0x12/0x14
[182932.591234]  [<c1003e79>] dump_stack+0x16/0x18
[182932.591316]  [<c102c2e8>] run_workqueue+0x167/0x170
[182932.591399]  [<c102c437>] worker_thread+0x146/0x165
[182932.591482]  [<c102f797>] kthread+0x97/0xc4
[182932.591564]  [<c1003bdb>] kernel_thread_helper+0x7/0x10

Config can be found here:
http://keetweej.vanheusden.com/~folkert/config-2.6.20.txt

System is a P4 @ 3.2GHz with 2GB of ram. IDE harddisks, 5 mounts mounted
on a server connected via a 1Gb lan. The other end (the server) runs
2.6.19.1.

On the problem-system this is the output of nfsstat:

Server rpc stats:
calls      badcalls   badauth    badclnt    xdrcall
1833       611        611        0          0

Server nfs v2:
null         getattr      setattr      root         lookup       readlink
611     100% 0         0% 0         0% 0         0% 0         0% 0         0%
read         wrcache      write        create       remove       rename
0         0% 0         0% 0         0% 0         0% 0         0% 0         0%
link         symlink      mkdir        rmdir        readdir      fsstat
0         0% 0         0% 0         0% 0         0% 0         0% 0         0%

Server nfs v3:
null         getattr      setattr      lookup       access       readlink
611     100% 0         0% 0         0% 0         0% 0         0% 0         0%
read         write        create       mkdir        symlink      mknod
0         0% 0         0% 0         0% 0         0% 0         0% 0         0%
remove       rmdir        rename       link         readdir      readdirplus
0         0% 0         0% 0         0% 0         0% 0         0% 0         0%
fsstat       fsinfo       pathconf     commit
0         0% 0         0% 0         0% 0         0%

Server nfs v4:
null         compound
611     100% 0         0%

Server nfs v4 operations:
op0-unused   op1-unused   op2-future   access       close        commit
0         0% 0         0% 0         0% 0         0% 0         0% 0         0%
create       delegpurge   delegreturn  getattr      getfh        link
0         0% 0         0% 0         0% 0         0% 0         0% 0         0%
lock         lockt        locku        lookup       lookup_root  nverify
0         0% 0         0% 0         0% 0         0% 0         0% 0         0%
open         openattr     open_conf    open_dgrd    putfh        putpubfh
0         0% 0         0% 0         0% 0         0% 0         0% 0         0%
putrootfh    read         readdir      readlink     remove       rename
0         0% 0         0% 0         0% 0         0% 0         0% 0         0%
renew        restorefh    savefh       secinfo      setattr      setcltid
0         0% 0         0% 0         0% 0         0% 0         0% 0         0%
setcltidconf verify       write        rellockowner
0         0% 0         0% 0         0% 0         0%

Client rpc stats:
calls      retrans    authrefrsh
1404874    5502       0

Client nfs v2:
null         getattr      setattr      root         lookup       readlink
0         0% 157240   11% 11360     0% 0         0% 707396   50% 20434     1%
read         wrcache      write        create       remove       rename
18        0% 0         0% 471048   33% 2900      0% 323       0% 2888      0%
link         symlink      mkdir        rmdir        readdir      fsstat
0         0% 2         0% 60        0% 32        0% 27463     1% 3709      0%

Client nfs v4:
null         read         write        commit       open         open_conf
0         0% 0         0% 0         0% 0         0% 0         0% 0         0%
open_noat    open_dgrd    close        setattr      fsinfo       renew
0         0% 0         0% 0         0% 0         0% 0         0% 0         0%
setclntid    confirm      lock         lockt        locku        access
0         0% 0         0% 0         0% 0         0% 0         0% 0         0%
getattr      lookup       lookup_root  remove       rename       link
0         0% 0         0% 0         0% 0         0% 0         0% 0         0%
symlink      create       pathconf     statfs       readlink     readdir
0         0% 0         0% 0         0% 0         0% 0         0% 0         0%
server_caps  delegreturn
0         0% 0         0%


Folkert van Heusden

-- 
www.biglumber.com <- site where one can exchange PGP key signatures 
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
