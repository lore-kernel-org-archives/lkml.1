Return-Path: <linux-kernel-owner+w=401wt.eu-S1761589AbZE1FdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761589AbZE1FdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 01:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbZE1FdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 01:33:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753459AbZE1FdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 01:33:09 -0400
Date: Wed, 27 May 2009 22:32:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: "linux.kernel" <linux-kernel@vger.kernel.org>, gregkh@suse.de,
       Miklos Szeredi <miklos@szeredi.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.29.4: hibernation fails with large kernel trace
Message-Id: <20090527223241.c6fb2caf.akpm@linux-foundation.org>
In-Reply-To: <4A1C36FF.4080000@gmail.com>
References: <4A1C36FF.4080000@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 20:37:51 +0200 Niel Lambrechts <niel.lambrechts@gmail.com> wrote:

> Hi there,
> 
> I was busy testing something for Tejun during which I booted 2.6.29.4, 
> hibernated (using s2disk) and resumed from a console session, then 
> switched to run-level 5 and repeated the hibernation in X.
> 
> The first X hibernate attempt just blanked the screen for about 10 
> seconds then X returned, and my kernel log contained a large kernel 
> trace which I attach.
> 
> I was able to hibernate directly after that, and did not notice and 
> other kernel messages or resulting issues. I also did several tests for 
> 2.6.30-rc6/7 and I also tested 2.6.28.10, none of which produced a trace 
> like this.
> 

> May 25 20:23:13 linux-7vph init: Switching to runlevel: 5
> May 25 20:23:14 linux-7vph kernel: Kernel logging (proc) stopped.
> May 25 20:23:14 linux-7vph kernel: Kernel log daemon terminating.
> May 25 20:23:14 linux-7vph syslog-ng[3184]: Termination requested via signal, terminating;
> May 25 20:23:14 linux-7vph syslog-ng[3184]: syslog-ng shutting down; version='2.0.9'
> May 25 20:23:14 linux-7vph syslog-ng[11049]: syslog-ng starting up; version='2.0.9'
> May 25 20:23:17 linux-7vph kdm_config[11088]: Multiple occurrences of key 'UseTheme' in section [X-*-Greeter] of /usr/share/kde4/config/kdm/kdmrc
> May 25 20:23:19 linux-7vph kernel: klogd 1.4.1, log source = /proc/kmsg started.
> May 25 20:23:30 linux-7vph kernel: CPU0 attaching NULL sched-domain.
> May 25 20:23:30 linux-7vph kernel: CPU1 attaching NULL sched-domain.
> May 25 20:23:30 linux-7vph kernel: CPU0 attaching sched-domain:
> May 25 20:23:30 linux-7vph kernel:  domain 0: span 0-1 level MC
> May 25 20:23:30 linux-7vph kernel:   groups: 0 1
> May 25 20:23:30 linux-7vph kernel:   domain 1: span 0-1 level CPU
> May 25 20:23:30 linux-7vph kernel:    groups: 0-1
> May 25 20:23:30 linux-7vph kernel: CPU1 attaching sched-domain:
> May 25 20:23:30 linux-7vph kernel:  domain 0: span 0-1 level MC
> May 25 20:23:30 linux-7vph kernel:   groups: 1 0
> May 25 20:23:30 linux-7vph kernel:   domain 1: span 0-1 level CPU
> May 25 20:23:30 linux-7vph kernel:    groups: 0-1
> May 25 20:23:42 linux-7vph pulseaudio[11429]: pid.c: Stale PID file, overwriting.
> May 25 20:23:44 linux-7vph pulseaudio[11455]: pid.c: Daemon already running.
> May 25 20:23:45 linux-7vph python: hp-systray(init)[11405]: warning: No hp: or hpfax: devices found in any installed CUPS queue. Exiting.
> May 25 20:23:56 linux-7vph pulseaudio[11429]: alsa-sink.c: ALSA woke us up to write new data to the device, but there was actually nothing to write!
> May 25 20:23:56 linux-7vph pulseaudio[11429]: alsa-sink.c: Most likely this is a bug in the ALSA driver 'snd_hda_intel'. Please report this issue to the ALSA developers.
> May 25 20:23:56 linux-7vph pulseaudio[11429]: alsa-sink.c: We were woken up with POLLOUT set -- however a subsequent snd_pcm_avail() returned 0 or another value < min_avail.
> May 25 20:24:04 linux-7vph sudo:   niella : TTY=pts/2 ; PWD=/home/niella ; USER=root ; COMMAND=/bin/su -
> May 25 20:24:04 linux-7vph su: (to root) niella on /dev/pts/2
> May 25 20:24:10 linux-7vph kernel: [drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 0
> May 25 20:24:30 linux-7vph kernel: Syncing filesystems ... done.
> May 25 20:24:30 linux-7vph kernel: Freezing user space processes ... 0
> May 25 20:24:30 linux-7vph kernel:  a4965f60 00001e8c f5dd6570 c01200d9 00100100 00200200 00005607 f555de44
> May 25 20:24:30 linux-7vph kernel: Call Trace:
> May 25 20:24:30 linux-7vph kernel:  [<c0115c04>] ? default_spin_lock_flags+0x8/0xc
> May 25 20:24:30 linux-7vph kernel:  [<c01200d9>] ? default_wake_function+0x0/0xd
> May 25 20:24:30 linux-7vph kernel:  [<c02f93ba>] ? unlock_kernel+0x29/0x2c
> May 25 20:24:30 linux-7vph kernel:  [<c013bdf4>] refrigerator+0xc8/0xd0
> May 25 20:24:30 linux-7vph kernel:  [<c0131331>] get_signal_to_deliver+0x49/0x330
> May 25 20:24:30 linux-7vph kernel:  [<c01021fa>] do_notify_resume+0x69/0x77f
> May 25 20:24:30 linux-7vph kernel:  [<c024325a>] ? tty_ioctl+0x0/0x71d
> May 25 20:24:30 linux-7vph kernel:  [<c01900ef>] ? vfs_ioctl+0x22/0x69
> May 25 20:24:30 linux-7vph kernel:  [<c019095f>] ? do_vfs_ioctl+0x45d/0x496
> May 25 20:24:30 linux-7vph kernel:  [<c02fac6a>] ? do_page_fault+0x0/0x722
> May 25 20:24:30 linux-7vph kernel:  [<c02f9472>] ? error_code+0x72/0x78
> May 25 20:24:30 linux-7vph kernel:  [<c01909e8>] ? sys_ioctl+0x50/0x5a
> May 25 20:24:30 linux-7vph kernel:  [<c0103094>] work_notifysig+0x13/0x1b
>
> ...
>
> May 25 20:24:37 linux-7vph kernel: s2disk        R running      0 11583  11519
> May 25 20:24:37 linux-7vph kernel:  00000000 00000004 00000000 00000000 00200286 00000000 00000013 00000007
> May 25 20:24:37 linux-7vph kernel:  e3efde0b f3e105f0 e3efde20 c02f6e28 c03a3753 0000000d e3efde44 c01047da
> May 25 20:24:37 linux-7vph kernel:  c03a374f c03a374f 00000000 e3efdde8 00000000 f3e105f0 00000000 e3efde54
> May 25 20:24:37 linux-7vph kernel: Call Trace:
> May 25 20:24:37 linux-7vph kernel:  [<c010529e>] show_trace_log_lvl+0x33/0x3e
> May 25 20:24:37 linux-7vph kernel:  [<c0104801>] show_stack_log_lvl+0x8c/0x97
> May 25 20:24:37 linux-7vph kernel:  [<c0105267>] show_stack+0x13/0x17
> May 25 20:24:37 linux-7vph kernel:  [<c0122134>] sched_show_task+0x89/0x93
> May 25 20:24:37 linux-7vph kernel:  [<c012217a>] show_state_filter+0x3c/0x7a
> May 25 20:24:37 linux-7vph kernel:  [<c0148a35>] try_to_freeze_tasks+0x15f/0x222
> May 25 20:24:37 linux-7vph kernel:  [<c0148b10>] freeze_processes+0x18/0x74
> May 25 20:24:37 linux-7vph kernel:  [<c014c180>] snapshot_ioctl+0x1a4/0x49e
> May 25 20:24:37 linux-7vph kernel:  [<c014bfdc>] ? snapshot_ioctl+0x0/0x49e
> May 25 20:24:37 linux-7vph kernel:  [<c01900ef>] vfs_ioctl+0x22/0x69
> May 25 20:24:37 linux-7vph kernel:  [<c019095f>] do_vfs_ioctl+0x45d/0x496
> May 25 20:24:37 linux-7vph kernel:  [<c019c535>] ? sync_inodes_sb+0x6e/0x76
> May 25 20:24:37 linux-7vph kernel:  [<c02f91e6>] ? _spin_lock+0x8/0xb
> May 25 20:24:37 linux-7vph kernel:  [<c01f6ae9>] ? copy_from_user+0x2a/0x111
> May 25 20:24:37 linux-7vph kernel:  [<c01909d8>] sys_ioctl+0x40/0x5a
> May 25 20:24:37 linux-7vph kernel:  [<c0102edb>] sysenter_do_call+0x12/0x2f
> May 25 20:24:37 linux-7vph kernel:  [<c02f0000>] ? i8042_probe+0x4d6/0x5b1

This is kernel/power/process.c:try_to_freeze_tasks() reporting that
"Freezing of tasks failed after %d.%02d seconds".

Unfortunately the loglevels were mucked up, so the prinks didn't
actually come out, and the show_state() output is also only partial,
because it doesn't use a consistent facility level for all its printks.

IOW, it's mucked up all over the place.

Why did the freezing fail?

Going through the task dump, the process "hid_compat" isn't
refrigerated.  But it's a kernel thread and it appears that kernel
threads aren't supposed to be refrigerated.

One of the "ksmserver" processes is stuck in do_exit() somewhere.

The process "fuser" is stuck down in the fuse code awaiting a response
or something.  I'd suspect that this is the cause of the freezing
failure:


May 25 20:24:36 linux-7vph kernel: fuser         D 00001e8c     0 11517  11516
> May 25 20:24:36 linux-7vph kernel:  e3231e10 00200086 a49c204d 00001e8c 00001e8a c01200ce 00000000 c04eb818
> May 25 20:24:36 linux-7vph kernel:  c04ee600 c04ee600 c04ee600 00200082 f3dcb150 f3dcb3b0 c1fb4600 00000001
> May 25 20:24:36 linux-7vph kernel:  a49c3ac0 00001e8c e3231dc8 00200286 00000003 00000003 efb1a430 e3231ddc
> May 25 20:24:36 linux-7vph kernel: Call Trace:
> May 25 20:24:36 linux-7vph kernel:  [<c01200ce>] ? try_to_wake_up+0x237/0x242
> May 25 20:24:36 linux-7vph kernel:  [<c011b861>] ? __wake_up+0x31/0x3b
> May 25 20:24:36 linux-7vph kernel:  [<c0115c04>] ? default_spin_lock_flags+0x8/0xc
> May 25 20:24:36 linux-7vph kernel:  [<c0136d86>] ? prepare_to_wait+0x43/0x48
> May 25 20:24:36 linux-7vph kernel:  [<f7f9b825>] fuse_request_send+0x172/0x219 [fuse]
> May 25 20:24:36 linux-7vph kernel:  [<c0136bc7>] ? autoremove_wake_function+0x0/0x33
> May 25 20:24:36 linux-7vph kernel:  [<f7f9d1b5>] fuse_do_getattr+0x137/0x248 [fuse]
> May 25 20:24:36 linux-7vph kernel:  [<f7f9e91d>] fuse_update_attributes+0x3b/0x6c [fuse]
> May 25 20:24:36 linux-7vph kernel:  [<f7f9e94e>] ? fuse_getattr+0x0/0x44 [fuse]
> May 25 20:24:36 linux-7vph kernel:  [<f7f9e986>] fuse_getattr+0x38/0x44 [fuse]
> May 25 20:24:36 linux-7vph kernel:  [<c0188786>] vfs_getattr+0x3f/0x58
> May 25 20:24:36 linux-7vph kernel:  [<c018894b>] vfs_stat_fd+0x2d/0x40
> May 25 20:24:36 linux-7vph kernel:  [<c0188a0d>] vfs_stat+0x11/0x13
> May 25 20:24:36 linux-7vph kernel:  [<c0188a23>] sys_stat64+0x14/0x29
> May 25 20:24:36 linux-7vph kernel:  [<c01841ed>] ? __dentry_open+0x16d/0x207
> May 25 20:24:36 linux-7vph kernel:  [<c0102edb>] sysenter_do_call+0x12/0x2f
> May 25 20:24:36 linux-7vph kernel:  [<c02f0000>] ? i8042_probe+0x4d6/0x5b1
> 


