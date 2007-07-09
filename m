Return-Path: <linux-kernel-owner+w=401wt.eu-S1759298AbXGIFFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbXGIFFS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 01:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751581AbXGIFFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 01:05:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:28552 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbXGIFFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 01:05:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=p/6FajFW6gMiYDBwp8fnlIptGATn4vbeltxtuiS+DGeUJIPjmtBFYuN/GHC9w81NoZskeXpg2AqOGyxGSgA0qj6zoy6/wPD8NSljgzzRSDuYurzNP2dv26szZuo0fwDUDSJ/L/g1RXqsQHuNV1v02Pmuc61hqdggibCbnz/MtVM=
Message-ID: <787b0d920707082205w4ba729dbnc3885f57042a349@mail.gmail.com>
Date: Mon, 9 Jul 2007 01:05:03 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: partially mounted cifs filesystem
Cc: linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
In-Reply-To: <a781481a0707071108u7bedb6cfkc63067663ae619ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <787b0d920707061845o6cf314dakf45c839c4fc0e600@mail.gmail.com>
	 <a781481a0707071108u7bedb6cfkc63067663ae619ca@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/7/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 7/7/07, Albert Cahalan <acahalan@gmail.com> wrote:

>> I had one share mounted, from XP to Linux, and wanted another.
>> At first I had an incorrect setting on the XP box, almost
>> certainly related to permissions. The mount failed of course.
>> Running "mount" showed that the filesystem was not mounted,
>> but apparently it didn't remain fully unmounted either.
>> There was also nothing under the mount point, and the "ls -l"
>> data (directory size and link count) looked like ext3.
>
> That means nothing was mounted there ...
>
>> I changed settings on the XP box numerous times. After many
>> frustrating attempts, I ran "umount" on the mount point and
>> then successfully mounted the filesystem.
>
> ... but still umount succeeded? Didn't it complain about nothing
> being mounted there in the first place? Surprising that it actually
> resolved the problem ...

It complained, and it resolved the problem.

>> I'll guess that the kernel returned an error for my early
>> attempts at mounting, but left open a CIFS connection.
>>
>> I suppose the cifs error handling is buggy.
>
> Yes, that could be the case. Could you please:
>
> 1. Tell us which kernel version was it? .config?
> 2. Was there some dmesg output from the failed mount(2) attempt?
> 3. What was the mount command line / options?

Server: Windows XP service pack 2, recently updated
Client: Fedora kernel 2.6.20-1.3094.fc7, mount.cifs version 1.10

My xterm still had the commands in the scrollback buffer.
I added a few, grepping dmesg and /etc/fstab, and chopped
out the unrelated stuff. Note that the number in my command
prompt is the exit code of the previous command; these are
all correct despite editing out the unrelated commands.

There are some interesting error messages, plus a lock order
warning that mentions cifs. Note that I have numerous cifs
shares mounted, so not every log message relates to this one.

> Then:
>
> 1. Rebuild kernel with CIFS_DEBUG2.
> 2. Revert back (on the XP share export side) to the buggy / incorrect
> settings -- so that you can try and reproduce the problem.
> 3. Let us know if you could reproduce, if so, any debug ouput / etc?

I probably spent a week messing with Windows settings. I switched
back and forth between simple file sharing and not, adjusted many
registry settings related to anonymous/guest treatment, redid the
ACLs more times than I care to think about... There really isn't
any hope I could get back to the original settings. My best guess
would be something related to an ACL for guest, everybody, SYSTEM,
or anonymous, or something related to the checkboxes for client
permissions in the file sharing dialog. At one time I had a deny ACL.

Here you go. The fstab lines will be word wrapped in this email,
but are not word wrapped in the file.

------------------
proc 0 # mount /mnt/vm/sc
Password:
mount error 11 = Resource temporarily unavailable
Refer to the mount.cifs(8) manual page (e.g.man mount.cifs)
proc 255 # smbclient -L //192.168.1.141
Password:
Domain=[ALBERTXP] OS=[Windows 5.1] Server=[Windows 2000 LAN Manager]

        Sharename       Type      Comment
        ---------       ----      -------
        IPC$            IPC       Remote IPC
        sourcecode      Disk
        ADMIN$          Disk      Remote Admin
        C$              Disk      Default share
        homedir         Disk
session request to 192.168.1.141 failed (Called name not present)
session request to 192 failed (Called name not present)
Domain=[ALBERTXP] OS=[Windows 5.1] Server=[Windows 2000 LAN Manager]

        Server               Comment
        ---------            -------

        Workgroup            Master
        ---------            -------
proc 0 # smbclient  //192.168.1.141/sourcecode
Password:
Domain=[ALBERTXP] OS=[Windows 5.1] Server=[Windows 2000 LAN Manager]
smb: \> ls
  .                                   D        0  Wed Dec  6 18:12:30 2006
  ..                                  D        0  Wed Dec  6 18:12:30 2006
  development                         D        0  Mon Jul  2 15:10:15 2007
  legacy                              D        0  Wed Dec  6 22:29:42 2006
  libraries                           D        0  Mon Jul  2 16:03:25 2007
  mmmmmmm                             D        0  Mon Jul  2 16:53:27 2007
  re                                  D        0  Mon Jul  2 17:39:34 2007
  sssssssss                           D        0  Mon Jul  2 17:46:23 2007
  thirdparty                          D        0  Mon Jul  2 18:05:05 2007

                40931 blocks of size 524288. 18955 blocks available
smb: \> q
proc 0 # mount /mnt/vm/sc
Password:
mount error 11 = Resource temporarily unavailable
Refer to the mount.cifs(8) manual page (e.g.man mount.cifs)
proc 255 # ls -l /mnt/vm/sc
total 0
proc 0 # ls -l /mnt/vm
total 2
drwxr-xr-x 1 root root    0 2007-07-03 17:43 homedir
drwxr-xr-x 2 root root 1024 2007-07-03 13:30 sc
proc 0 # ls -al /mnt/vm/sc
total 4
drwxr-xr-x 2 root root 1024 2007-07-03 13:30 .
drwxr-xr-x 4 root root 1024 2007-07-03 13:30 ..
proc 0 # ls -al /mnt/vm/
total 6
drwxr-xr-x  4 root root 1024 2007-07-03 13:30 .
drwxr-xr-x 12 root root 1024 2007-04-17 08:46 ..
drwxr-xr-x  1 root root    0 2007-07-03 17:43 homedir
drwxr-xr-x  2 root root 1024 2007-07-03 13:30 sc
proc 0 # umount /mnt/vm//sc/
umount: /mnt/vm//sc/: not mounted
proc 1 # mount /mnt/vm/sc
Password:
proc 0 # ls /mnt/vm/sc
development  legacy  libraries  mmmmmmm  re  sssssssss  thirdparty
proc 0 # egrep 'vm.*cifs' /etc/fstab
//192.168.1.141/homedir    /mnt/vm/homedir cifs
noauto,defaults,noperm,file_mode=0664,dir_mode=0755 0 0
//192.168.1.141/sourcecode /mnt/vm/sc      cifs
noauto,defaults,noperm,file_mode=0664,dir_mode=0755 0 0
proc 0 # dmesg | egrep -i cifs
SELinux: initialized (dev cifs, type cifs), uses genfs_contexts
       [<ffffffff88305d00>] smb_send+0xa5/0x140 [cifs]
       [<ffffffff88305f3e>] SendReceive+0x1a3/0x40d [cifs]
       [<ffffffff882ef34f>] CIFSSMBSetEOF+0x1f1/0x23d [cifs]
       [<ffffffff88301125>] cifs_setattr+0x241/0x86a [cifs]
 [<ffffffff88305d00>] :cifs:smb_send+0xa5/0x140
 [<ffffffff88305f3e>] :cifs:SendReceive+0x1a3/0x40d
 [<ffffffff882ef34f>] :cifs:CIFSSMBSetEOF+0x1f1/0x23d
 [<ffffffff88301125>] :cifs:cifs_setattr+0x241/0x86a
SELinux: initialized (dev cifs, type cifs), uses genfs_contexts
SELinux: initialized (dev cifs, type cifs), uses genfs_contexts
 CIFS VFS: close with pending writes
 CIFS VFS: Send error in Close = -9
 CIFS VFS: Send error in FindClose = -9
 CIFS VFS: Send error in FindClose = -9
SELinux: initialized (dev cifs, type cifs), uses genfs_contexts
SELinux: initialized (dev cifs, type cifs), uses genfs_contexts
 CIFS VFS: Send error in Close = -9
SELinux: initialized (dev cifs, type cifs), uses genfs_contexts
 CIFS VFS: close with pending writes
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: No response for cmd 114 mid 47519
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
 CIFS VFS: cifs_mount failed w/return code = -11
SELinux: initialized (dev cifs, type cifs), uses genfs_contexts
proc 0 # dmesg | egrep -i -A15 -B99 --color '[a-f0-9]{16}.*cifs'
SELinux: initialized (dev cifs, type cifs), uses genfs_contexts

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.20-1.3094.fc7 #1
-------------------------------------------------------
joe/4051 is trying to acquire lock:
 (sk_lock-AF_INET){--..}, at: [<ffffffff80226aa4>] tcp_sendmsg+0x21/0xb19

but task is already holding lock:
 (&inode->i_alloc_sem){--..}, at: [<ffffffff8022d6f0>] notify_change+0x110/0x305

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&inode->i_alloc_sem){--..}:
       [<ffffffff802a372f>] __lock_acquire+0xa27/0xbd1
       [<ffffffff802a3ccf>] lock_acquire+0x4c/0x65
       [<ffffffff8022d6f0>] notify_change+0x110/0x305
       [<ffffffff8029e96f>] down_write+0x3b/0x47
       [<ffffffff8022d6f0>] notify_change+0x110/0x305
       [<ffffffff802dddcf>] do_truncate+0x53/0x72
       [<ffffffff8024e200>] get_write_access+0x40/0x47
       [<ffffffff80211f16>] may_open+0x1d9/0x22e
       [<ffffffff8021af30>] open_namei+0x2bd/0x654
       [<ffffffff802281cf>] do_filp_open+0x28/0x46
       [<ffffffff802639f3>] _spin_unlock+0x26/0x2a
       [<ffffffff802158d5>] get_unused_fd+0xfb/0x10c
       [<ffffffff802198e2>] do_sys_open+0x4f/0xd0
       [<ffffffff8023220f>] sys_open+0x1b/0x1d
       [<ffffffff8025c11e>] system_call+0x7e/0x83
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #2 (&sysfs_inode_imutex_key){--..}:
       [<ffffffff802a372f>] __lock_acquire+0xa27/0xbd1
       [<ffffffff802a3ccf>] lock_acquire+0x4c/0x65
       [<ffffffff802622fe>] mutex_lock+0x2a/0x2e
       [<ffffffff8026213a>] __mutex_lock_slowpath+0xff/0x299
       [<ffffffff802622fe>] mutex_lock+0x2a/0x2e
       [<ffffffff8030d1aa>] create_dir+0x2d/0x1e2
       [<ffffffff8030d3b8>] sysfs_create_dir+0x59/0x77
       [<ffffffff802639f3>] _spin_unlock+0x26/0x2a
       [<ffffffff80349d27>] kobject_shadow_add+0xf2/0x1ad
       [<ffffffff80349ded>] kobject_add+0xb/0xd
       [<ffffffff803b94ad>] device_add+0xba/0x769
       [<ffffffff8034d11c>] __spin_lock_init+0x31/0x52
       [<ffffffff80419466>] netdev_register_sysfs+0x8f/0x98
       [<ffffffff8041048e>] register_netdevice+0x287/0x366
       [<ffffffff804105a7>] register_netdev+0x3a/0x48
       [<ffffffff806a2f1c>] loopback_init+0x10/0x12
       [<ffffffff80686ab9>] init+0x219/0x316
       [<ffffffff802a2885>] trace_hardirqs_on+0x136/0x15a
       [<ffffffff8025cfa8>] child_rip+0xa/0x12
       [<ffffffff80263d40>] _spin_unlock_irq+0x2b/0x31
       [<ffffffff8025c6bc>] restore_args+0x0/0x30
       [<ffffffff806868a0>] init+0x0/0x316
       [<ffffffff8025cf9e>] child_rip+0x0/0x12
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #1 (rtnl_mutex){--..}:
       [<ffffffff802a372f>] __lock_acquire+0xa27/0xbd1
       [<ffffffff802a3ccf>] lock_acquire+0x4c/0x65
       [<ffffffff802622fe>] mutex_lock+0x2a/0x2e
       [<ffffffff8026213a>] __mutex_lock_slowpath+0xff/0x299
       [<ffffffff802622fe>] mutex_lock+0x2a/0x2e
       [<ffffffff80417109>] rtnl_lock+0x10/0x12
       [<ffffffff80447bd5>] ip_mc_leave_group+0x28/0xc3
       [<ffffffff8042fd2e>] do_ip_setsockopt+0x6af/0x9b6
       [<ffffffff80263d71>] _read_unlock_irq+0x2b/0x31
       [<ffffffff80222a02>] __up_read+0x7a/0x83
       [<ffffffff8029e8ce>] up_read+0x26/0x2a
       [<ffffffff80323b41>] socket_has_perm+0x68/0x77
       [<ffffffff80430667>] ip_setsockopt+0x2b/0x86
       [<ffffffff8043fb2e>] udp_setsockopt+0x2a/0x2c
       [<ffffffff80408af9>] sock_common_setsockopt+0xf/0x11
       [<ffffffff80407a93>] sys_setsockopt+0x8f/0xb4
       [<ffffffff8025c2b5>] tracesys+0xdc/0xe1
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (sk_lock-AF_INET){--..}:
       [<ffffffff802a12ff>] print_circular_bug_entry+0x48/0x4f
       [<ffffffff802a3627>] __lock_acquire+0x91f/0xbd1
       [<ffffffff802a3ccf>] lock_acquire+0x4c/0x65
       [<ffffffff80226aa4>] tcp_sendmsg+0x21/0xb19
       [<ffffffff80409191>] lock_sock_nested+0xdb/0xef
       [<ffffffff802a2885>] trace_hardirqs_on+0x136/0x15a
       [<ffffffff80226aa4>] tcp_sendmsg+0x21/0xb19
       [<ffffffff802a208d>] find_usage_backwards+0xc2/0xed
       [<ffffffff802a208d>] find_usage_backwards+0xc2/0xed
       [<ffffffff80244d04>] inet_sendmsg+0x46/0x53
       [<ffffffff802539ee>] sock_sendmsg+0x105/0x124
       [<ffffffff8034c684>] random32+0x1c/0x20
       [<ffffffff8029c457>] autoremove_wake_function+0x0/0x38
       [<ffffffff802701c0>] save_stack_trace+0x22/0x40
       [<ffffffff8020c998>] cache_alloc_debugcheck_after+0xf8/0x1db
       [<ffffffff802c5654>] mempool_alloc_slab+0x11/0x13
       [<ffffffff804088f0>] kernel_sendmsg+0x34/0x49
       [<ffffffff88305d00>] smb_send+0xa5/0x140 [cifs]
       [<ffffffff802639f3>] _spin_unlock+0x26/0x2a
       [<ffffffff88305f3e>] SendReceive+0x1a3/0x40d [cifs]
       [<ffffffff882ef34f>] CIFSSMBSetEOF+0x1f1/0x23d [cifs]
       [<ffffffff88301125>] cifs_setattr+0x241/0x86a [cifs]
       [<ffffffff80328b13>] selinux_inode_setattr+0xc5/0xd5
       [<ffffffff802632f8>] __down_write_nested+0x3d/0xa1
       [<ffffffff8022d740>] notify_change+0x160/0x305
       [<ffffffff802dddcf>] do_truncate+0x53/0x72
       [<ffffffff8024e200>] get_write_access+0x40/0x47
       [<ffffffff80211f16>] may_open+0x1d9/0x22e
       [<ffffffff8021af30>] open_namei+0x2bd/0x654
       [<ffffffff802281cf>] do_filp_open+0x28/0x46
       [<ffffffff802639f3>] _spin_unlock+0x26/0x2a
       [<ffffffff802158d5>] get_unused_fd+0xfb/0x10c
       [<ffffffff802198e2>] do_sys_open+0x4f/0xd0
       [<ffffffff8023220f>] sys_open+0x1b/0x1d
       [<ffffffff8025c2b5>] tracesys+0xdc/0xe1
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

2 locks held by joe/4051:
 #0:  (&inode->i_mutex){--..}, at: [<ffffffff802622fe>] mutex_lock+0x2a/0x2e
 #1:  (&inode->i_alloc_sem){--..}, at: [<ffffffff8022d6f0>]
notify_change+0x110/0x305

stack backtrace:

Call Trace:
 [<ffffffff802a1cca>] print_circular_bug_tail+0x70/0x7b
 [<ffffffff802a12ff>] print_circular_bug_entry+0x48/0x4f
 [<ffffffff802a3627>] __lock_acquire+0x91f/0xbd1
 [<ffffffff802a3ccf>] lock_acquire+0x4c/0x65
 [<ffffffff80226aa4>] tcp_sendmsg+0x21/0xb19
 [<ffffffff80409191>] lock_sock_nested+0xdb/0xef
 [<ffffffff802a2885>] trace_hardirqs_on+0x136/0x15a
 [<ffffffff80226aa4>] tcp_sendmsg+0x21/0xb19
 [<ffffffff802a208d>] find_usage_backwards+0xc2/0xed
 [<ffffffff802a208d>] find_usage_backwards+0xc2/0xed
 [<ffffffff80244d04>] inet_sendmsg+0x46/0x53
 [<ffffffff802539ee>] sock_sendmsg+0x105/0x124
 [<ffffffff8034c684>] random32+0x1c/0x20
 [<ffffffff8029c457>] autoremove_wake_function+0x0/0x38
 [<ffffffff802701c0>] save_stack_trace+0x22/0x40
 [<ffffffff8020c998>] cache_alloc_debugcheck_after+0xf8/0x1db
 [<ffffffff802c5654>] mempool_alloc_slab+0x11/0x13
 [<ffffffff804088f0>] kernel_sendmsg+0x34/0x49
 [<ffffffff88305d00>] :cifs:smb_send+0xa5/0x140
 [<ffffffff802639f3>] _spin_unlock+0x26/0x2a
 [<ffffffff88305f3e>] :cifs:SendReceive+0x1a3/0x40d
 [<ffffffff882ef34f>] :cifs:CIFSSMBSetEOF+0x1f1/0x23d
 [<ffffffff88301125>] :cifs:cifs_setattr+0x241/0x86a
 [<ffffffff80328b13>] selinux_inode_setattr+0xc5/0xd5
 [<ffffffff802632f8>] __down_write_nested+0x3d/0xa1
 [<ffffffff8022d740>] notify_change+0x160/0x305
 [<ffffffff802dddcf>] do_truncate+0x53/0x72
 [<ffffffff8024e200>] get_write_access+0x40/0x47
 [<ffffffff80211f16>] may_open+0x1d9/0x22e
 [<ffffffff8021af30>] open_namei+0x2bd/0x654
 [<ffffffff802281cf>] do_filp_open+0x28/0x46
 [<ffffffff802639f3>] _spin_unlock+0x26/0x2a
 [<ffffffff802158d5>] get_unused_fd+0xfb/0x10c
 [<ffffffff802198e2>] do_sys_open+0x4f/0xd0
 [<ffffffff8023220f>] sys_open+0x1b/0x1d
 [<ffffffff8025c2b5>] tracesys+0xdc/0xe1

SELinux: initialized (dev cifs, type cifs), uses genfs_contexts
proc 0 #
--------------------------
