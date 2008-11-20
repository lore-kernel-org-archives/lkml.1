Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbYKTGJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbYKTGJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 01:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYKTGJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 01:09:45 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:50072 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbYKTGJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 01:09:43 -0500
Message-Id: <200811200609.mAK69ZbZ053438@www262.sakura.ne.jp>
Subject: Random freeze (Re: mmotm 2008-11-19-02-19 uploaded)
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Thu, 20 Nov 2008 15:09:35 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> The mm-of-the-moment snapshot 2008-11-19-02-19 has been uploaded to
Recent mmotm randomly freezes on /sbin/modprobe and read(). 2.6.28-rc2-mm1 was OK.

Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.28-rc5-mm1

----- Quoting from http://I-love.SAKURA.ne.jp/tmp/messages4.txt (2008-11-19-02-19) -----

kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: checktime reached, running e2fsck is recommended
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
/dev/sdb1 on /usr/src/vanilla type ext3 (rw,noatime,nodiratime)
/dev/sdc1 on /usr/src/distro type ext3 (rw,noatime,nodiratime)
Cleaning /tmp /var/run /var/lock.
Detecting hardware: open_sock(): No such device
agpgart pcnet32 piix BusLogic
Skipping unavailable/built-in agpgart module.
pcnet32 disabled in configuration.
Skipping unavailable/built-in piix module.
Skipping already loaded module BusLogic.
Running 0dns-down to make sure resolv.conf is ok...done.
Setting up networking...done.
Starting hotplug subsystem:
   pci     
     ignoring pci display device 00:0f.0
     BusLogic: already loaded
SysRq : Changing Loglevel
Loglevel set to 8
CPA self-test:
 4k 227326 large 0 gb 0 x 227326[c0000000-f77fd000] miss 0
 4k 227326 large 0 gb 0 x 227326[c0000000-f77fd000] miss 0
 4k 227326 large 0 gb 0 x 227326[c0000000-f77fd000] miss 0
ok.
SysRq : Show Blocked State
  task                PC stack   pid father
kjournald     D f6a43a40  5944   807      2
 f6359e3c 00000046 c0207ff6 f6a43a40 c21a4740 f6a229c0 00201488 00000000
 f6688a00 00000000 f6358000 c21a4740 f65e4108 f65e3ea0 f6a43a40 000047bc
 c1f0525c f6359e34 c023e48b c21a4740 c21a4740 00000000 c1f0525c f6359e48
Call Trace:
 [<c0207ff6>] ? read_tsc+0x9/0x26
 [<c023e48b>] ? ktime_get_ts+0x43/0x47
 [<c05b5a3e>] io_schedule+0x47/0x79
 [<c02ba64e>] sync_buffer+0x37/0x3b
 [<c05b5c0d>] __wait_on_bit+0x30/0x56
 [<c02ba617>] ? sync_buffer+0x0/0x3b
 [<c05b5c9a>] out_of_line_wait_on_bit+0x67/0x6f
 [<c02ba617>] ? sync_buffer+0x0/0x3b
 [<c023c3f3>] ? wake_bit_function+0x0/0x42
 [<c023c3f3>] ? wake_bit_function+0x0/0x42
 [<c02ba6a9>] __wait_on_buffer+0x19/0x1c
 [<c02f6a14>] journal_commit_transaction+0x6e4/0xbf4
 [<c0247f75>] ? lock_release_holdtime+0x91/0x97
 [<c024ab0b>] ? trace_hardirqs_on_caller+0x120/0x148
 [<c024ab3e>] ? trace_hardirqs_on+0xb/0xd
 [<c0233247>] ? try_to_del_timer_sync+0x54/0x5c
 [<c02f8972>] kjournald+0xb8/0x229
 [<c023c3c0>] ? autoremove_wake_function+0x0/0x33
 [<c023c3c0>] ? autoremove_wake_function+0x0/0x33
 [<c02252d2>] ? complete+0x36/0x3e
 [<c02f88ba>] ? kjournald+0x0/0x229
 [<c023bf0a>] kthread+0x37/0x59
 [<c023bed3>] ? kthread+0x0/0x59
 [<c0203d23>] kernel_thread_helper+0x7/0x10
modprobe      D f6a43ca0  6104  1403   1401
 f6765d48 00000046 c0207ff6 f6a43ca0 c2059740 c079cba0 00201488 00000000
 f6652500 00000000 f6764000 c2059740 f6a3eac8 f6a3e860 f6a43ca0 00004792
 c1f0e2bc f6765d40 c023e48b c2059740 c2059740 00000000 c1f0e2bc f6765d54
Call Trace:
 [<c0207ff6>] ? read_tsc+0x9/0x26
 [<c023e48b>] ? ktime_get_ts+0x43/0x47
 [<c05b5a3e>] io_schedule+0x47/0x79
 [<c0279c46>] sync_page+0x45/0x49
 [<c05b5cd2>] __wait_on_bit_lock+0x30/0x57
 [<c0279c01>] ? sync_page+0x0/0x49
 [<c027a2f6>] __lock_page+0x62/0x6a
 [<c023c3f3>] ? wake_bit_function+0x0/0x42
 [<c027a4a4>] ? find_get_page+0xcf/0xd9
 [<c023c3f3>] ? wake_bit_function+0x0/0x42
 [<c027a4d9>] find_lock_page+0x2b/0x50
 [<c027b1ab>] filemap_fault+0x86/0x29d
 [<c028ab8b>] ? __do_fault+0x2df/0x325
 [<c028a8fc>] __do_fault+0x50/0x325
 [<c024bd04>] ? __lock_acquire+0x72a/0x77c
 [<c028abfd>] do_linear_fault+0x2c/0x33
 [<c028ad66>] handle_mm_fault+0xf9/0x1d9
 [<c05b9586>] do_page_fault+0x1b6/0x427
 [<c05b93d0>] ? do_page_fault+0x0/0x427
 [<c05b7b17>] error_code+0x77/0x7c
 [<c033e62a>] ? __copy_from_user_ll+0x35/0x4c
 [<c033e787>] copy_from_user+0x31/0x56
 [<c0253bec>] load_module+0x72/0x9d7
 [<c0254577>] ? sys_init_module+0x26/0x18c
 [<c03181c0>] ? security_capable+0x12/0x15
 [<c0254592>] sys_init_module+0x41/0x18c
 [<c0202fae>] syscall_call+0x7/0xb
Sched Debug Version: v0.07, 2.6.28-rc5-mm1 #1
now at 31572.891772 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 24191

----- Quoting from http://I-love.SAKURA.ne.jp/tmp/messages5.txt (2008-11-19-02-19 + TOMOYO)-----

kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
umount: devfs: not mounted
Calling /sbin/tomoyo-init to load policy. Please wait.
SysRq : Changing Loglevel
Loglevel set to 8
SysRq : Show Blocked State
  task                PC stack   pid father
chroot        D 0000004d  5904     1      0
 f704fe38 00000046 00000000 0000004d c21a4740 f6a229c0 7d2e883b 0000000c
 f65ee500 00000000 f704e000 c21a4740 f7050268 f7050000 c0247f75 f70504f0
 00000063 00000000 00000063 00000001 7fffffff f704fea0 f704fec0 f704fe78
Call Trace:
 [<c0247f75>] ? lock_release_holdtime+0x91/0x97
 [<c05ba9dc>] schedule_timeout+0x16/0x92
 [<c024a9ae>] ? mark_held_locks+0x4d/0x6c
 [<c05bc739>] ? _spin_unlock_irq+0x22/0x26
 [<c024ab0b>] ? trace_hardirqs_on_caller+0x120/0x148
 [<c024ab3e>] ? trace_hardirqs_on+0xb/0xd
 [<c05ba699>] wait_for_common+0xcd/0x121
 [<c022518f>] ? default_wake_function+0x0/0xd
 [<c022518f>] ? default_wake_function+0x0/0xd
 [<c0239034>] ? queue_work_on+0x35/0x41
 [<c05ba6ff>] wait_for_completion+0x12/0x14
 [<c0238ed5>] call_usermodehelper_exec+0x76/0x8f
 [<c05ba5fc>] ? wait_for_common+0x30/0x121
 [<c031c1cf>] tomoyo_load_policy+0x9a/0x100
 [<c031cca0>] tomoyo_bprm_set_creds+0x23/0x35
 [<c03184a7>] security_bprm_set_creds+0xc/0xe
 [<c02a4d47>] prepare_binprm+0xac/0xe1
 [<c02a5180>] do_execve+0x10f/0x232
 [<c0201f61>] sys_execve+0x29/0x4c
 [<c0202fae>] syscall_call+0x7/0xb
cat           D f6b463b8  6124   823    815
 f6741da8 00000046 c0207ff6 f6b463b8 c2059740 c07a3ba0 00201487 00000000
 f6726500 00000000 f6740000 c2059740 f62a1748 f62a14e0 f6b463b8 000021f2
 c1f0edbc f6741da0 c023e48b c2059740 c2059740 00000000 c1f0edbc f6741db4
Call Trace:
 [<c0207ff6>] ? read_tsc+0x9/0x26
 [<c023e48b>] ? ktime_get_ts+0x43/0x47
 [<c05ba8fe>] io_schedule+0x47/0x79
 [<c0279c46>] sync_page+0x45/0x49
 [<c0279c52>] sync_page_killable+0x8/0x30
 [<c05bab92>] __wait_on_bit_lock+0x30/0x57
 [<c0279c4a>] ? sync_page_killable+0x0/0x30
 [<c027a363>] __lock_page_killable+0x65/0x6d
 [<c023c3f3>] ? wake_bit_function+0x0/0x42
 [<c027a4a4>] ? find_get_page+0xcf/0xd9
 [<c023c3f3>] ? wake_bit_function+0x0/0x42
 [<c027ab96>] do_generic_file_read+0x244/0x3c6
 [<c027afa3>] generic_file_aio_read+0x132/0x15a
 [<c027ad18>] ? file_read_actor+0x0/0xe8
 [<c02a04d2>] do_sync_read+0xb7/0xf5
 [<c020777a>] ? native_sched_clock+0x42/0x92
 [<c023c3c0>] ? autoremove_wake_function+0x0/0x33
 [<c024c6d7>] ? __lock_release+0x4b/0x51
 [<c02d4b47>] ? dnotify_parent+0x64/0x6d
 [<c0318b51>] ? security_file_permission+0xf/0x11
 [<c02a03cc>] ? rw_verify_area+0x96/0xb2
 [<c02a059c>] vfs_read+0x8c/0x12e
 [<c02a089f>] sys_read+0x3b/0x60
 [<c0202fae>] syscall_call+0x7/0xb
Sched Debug Version: v0.07, 2.6.28-rc5-mm1 #2
now at 25613.058324 msecs
  .sysctl_sched_latency                    : 40.000000
  .sysctl_sched_min_granularity            : 8.000000
  .sysctl_sched_wakeup_granularity         : 10.000000
  .sysctl_sched_child_runs_first           : 0.000001
  .sysctl_sched_features                   : 24191
