Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbYCFVTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbYCFVTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYCFVTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:19:12 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:52359 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbYCFVTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:19:06 -0500
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.2
To: Jens Axboe <jens.axboe@oracle.com>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Anders Eriksson <aeriksson@fastmail.fm>
Subject: Re: Linux 2.6.25-rc4 
In-reply-to: <20080306135532.GG17940@kernel.dk> 
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <200803061438.22205.bzolnier@gmail.com> <20080306133347.GA23495@elte.hu> <200803061506.19449.bzolnier@gmail.com> <20080306135532.GG17940@kernel.dk>
Comments: In-reply-to Jens Axboe <jens.axboe@oracle.com>
   message dated "Thu, 06 Mar 2008 14:55:33 +0100."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Thu, 06 Mar 2008 22:17:25 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20080306211726.2DA8C93C881@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.237.4
X-Scan-Result: No virus found in message 1JXNTg-0001xM-4G.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1JXNTg-0001xM-4G 6f806d9500ce7372b71222914d595ec5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


jens.axboe@oracle.com said:
>> I was a bit unclear on this, the problem is easily reproducible but _only_
>> on Anders' system (I couldn't reproduce it with smartd here either).

> What IO scheduler is Anders using (and does it have an impact, eg does it
> hang with deadline as well)? 

CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_IOSCHED="cfq"

On request here's a sysrq-t from smartd on -rc3, you also see exactly where 
smartd gives up (using the gentoo default smasrtd.conf).

Might a strace of smartd help?

Lest you folks come up with any ideas, I'll try another bisect run on saturday 
between the was_guilty_but_now_sometimes_work and 25-r1, and see what that 
gives.


Mar  6 22:04:27 tracker smartd[6283]: smartd version 5.37 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
Mar  6 22:04:27 tracker smartd[6283]: Home page is http://smartmontools.sourceforge.net/
Mar  6 22:04:27 tracker smartd[6283]: Opened configuration file /etc/smartd.conf
Mar  6 22:04:27 tracker smartd[6283]: Configuration file /etc/smartd.conf parsed.
Mar  6 22:04:27 tracker smartd[6283]: Device: /dev/hda, opened
Mar  6 22:04:28 tracker smartd[6283]: Device: /dev/hda, found in smartd database.
Mar  6 22:04:28 tracker smartd[6283]: Device: /dev/hda, can't monitor Current Pending Sector count - no Attribute 197
Mar  6 22:04:28 tracker smartd[6283]: Device: /dev/hda, can't monitor Offline Uncorrectable Sector count  - no Attribute 198
Mar  6 22:04:28 tracker smartd[6283]: Device: /dev/hda, can't monitor Temperature, ignoring -W Directive
Mar  6 22:04:28 tracker smartd[6283]: Device: /dev/hda, appears to lack SMART Self-Test log; disabling -l selftest (override with -T permissive Directive)
Mar  6 22:04:28 tracker smartd[6283]: Device: /dev/hda, appears to lack SMART Error log; disabling -l error (override with -T permissive Directive)
Mar  6 22:04:28 tracker smartd[6283]: Device: /dev/hda, is SMART capable. Adding to "monitor" list.
Mar  6 22:04:28 tracker smartd[6283]: Device: /dev/hda, opened
Mar  6 22:04:28 tracker smartd[6283]: Device: /dev/hda, found in smartd database.
Mar  6 22:04:32 tracker ======
Mar  6 22:04:32 tracker dnsmasq       S 00000000     0  4181      1
Mar  6 22:04:32 tracker d25bbb10 00000056 00000000 00000000 d247c544 d3f124c0 00000000 00000000 
Mar  6 22:04:32 tracker 00000000 04aa3006 00000057 d2575980 d25bbbc4 0000000e 00002000 00000304 
Mar  6 22:04:32 tracker d25bbb40 c043c555 d25bbb34 c0396e72 0050c2c0 d3fc7e00 c046c0e0 00002000 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:32 tracker [<c0396e72>] ? udp_poll+0x12/0xf0
Mar  6 22:04:32 tracker [<c0176c27>] do_select+0x4c7/0x5c0
Mar  6 22:04:32 tracker [<c0176760>] ? do_select+0x0/0x5c0
Mar  6 22:04:32 tracker [<c035c50c>] ? process_backlog+0x5c/0xb0
Mar  6 22:04:32 tracker [<c0177290>] ? __pollwait+0x0/0xe0
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c039ef64>] ? inet_sendmsg+0x34/0x60
Mar  6 22:04:32 tracker [<c034e664>] ? sock_sendmsg+0xc4/0xf0
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c0176f3a>] core_sys_select+0x21a/0x330
Mar  6 22:04:32 tracker [<c0176d47>] ? core_sys_select+0x27/0x330
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c035b4e5>] ? dev_ioctl+0x95/0x4f0
Mar  6 22:04:32 tracker [<c02344d5>] ? copy_to_user+0x35/0x50
Mar  6 22:04:32 tracker [<c035b4f4>] ? dev_ioctl+0xa4/0x4f0
Mar  6 22:04:32 tracker [<c0398d20>] ? udp_ioctl+0x0/0x90
Mar  6 22:04:32 tracker [<c039ed7d>] ? inet_ioctl+0x3d/0x90
Mar  6 22:04:32 tracker [<c034dbf0>] ? sock_ioctl+0x0/0x230
Mar  6 22:04:32 tracker [<c01773af>] sys_select+0x3f/0x190
Mar  6 22:04:32 tracker [<c034f9c3>] ? sys_socketcall+0x233/0x260
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker cupsd         S c05ffba0     0  4241      1
Mar  6 22:04:32 tracker d253db10 00000056 00000286 c05ffba0 d3d6a964 d3f844c0 d253db20 c05ffba0 
Mar  6 22:04:32 tracker d253db10 c0126e11 00014478 00000000 00000286 d253db20 00014478 00000000 
Mar  6 22:04:32 tracker d253db40 c043c527 d3f5fc80 d253dbc4 c06005f0 c06005f0 00014478 c0126930 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c0126e11>] ? __mod_timer+0x91/0xa0
Mar  6 22:04:32 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:32 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:32 tracker [<c0176c27>] do_select+0x4c7/0x5c0
Mar  6 22:04:32 tracker [<c0176760>] ? do_select+0x0/0x5c0
Mar  6 22:04:32 tracker [<c0177290>] ? __pollwait+0x0/0xe0
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c01b89d6>] ? journal_stop+0x116/0x1e0
Mar  6 22:04:32 tracker [<c0150a2b>] ? balance_dirty_pages_ratelimited_nr+0x4b/0x250
Mar  6 22:04:32 tracker [<c01ae2c7>] ? ext3_ordered_write_end+0xd7/0x130
Mar  6 22:04:32 tracker [<c014b04e>] ? generic_file_buffered_write+0x18e/0x650
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c0176f3a>] core_sys_select+0x21a/0x330
Mar  6 22:04:32 tracker [<c0176d47>] ? core_sys_select+0x27/0x330
Mar  6 22:04:32 tracker [<c043cce8>] ? mutex_unlock+0x8/0x10
Mar  6 22:04:32 tracker [<c043cce8>] ? mutex_unlock+0x8/0x10
Mar  6 22:04:32 tracker [<c014bac5>] ? generic_file_aio_write+0x65/0xd0
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c022de5d>] ? _atomic_dec_and_lock+0x2d/0x40
Mar  6 22:04:32 tracker [<c043ea97>] ? _spin_unlock+0x27/0x50
Mar  6 22:04:32 tracker [<c022de5d>] ? _atomic_dec_and_lock+0x2d/0x40
Mar  6 22:04:32 tracker [<c0177444>] sys_select+0xd4/0x190
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker rpc.mountd    S 00000292     0  4306      1
Mar  6 22:04:32 tracker d25f9b10 00000056 d3a0cd78 00000292 d25f65c4 d245d940 c043eb8c d25f9c48 
Mar  6 22:04:32 tracker d3a0cd78 d25f9b08 c013129b 00000004 00000000 00000008 00000080 00000000 
Mar  6 22:04:32 tracker d25f9b40 c043c555 d25f9bc4 d3f5a640 d2544320 d25f9b34 c03823da c046c080 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043eb8c>] ? _spin_unlock_irqrestore+0x2c/0x50
Mar  6 22:04:32 tracker [<c013129b>] ? add_wait_queue+0x3b/0x50
Mar  6 22:04:32 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:32 tracker [<c03823da>] ? tcp_poll+0x1a/0x160
Mar  6 22:04:32 tracker [<c0176c27>] do_select+0x4c7/0x5c0
Mar  6 22:04:32 tracker [<c0176760>] ? do_select+0x0/0x5c0
Mar  6 22:04:32 tracker [<c0177290>] ? __pollwait+0x0/0xe0
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c03505c1>] ? release_sock+0xc1/0xd0
Mar  6 22:04:32 tracker [<c0123217>] ? local_bh_enable_ip+0x27/0x60
Mar  6 22:04:32 tracker [<c043e26f>] ? _spin_unlock_bh+0x2f/0x40
Mar  6 22:04:32 tracker [<c03505c1>] ? release_sock+0xc1/0xd0
Mar  6 22:04:32 tracker [<c0398531>] ? udp_sendmsg+0x311/0x6c0
Mar  6 22:04:32 tracker [<c039ef64>] ? inet_sendmsg+0x34/0x60
Mar  6 22:04:32 tracker [<c034e664>] ? sock_sendmsg+0xc4/0xf0
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c0176f3a>] core_sys_select+0x21a/0x330
Mar  6 22:04:32 tracker [<c0176d47>] ? core_sys_select+0x27/0x330
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c022de5d>] ? _atomic_dec_and_lock+0x2d/0x40
Mar  6 22:04:32 tracker [<c01773af>] sys_select+0x3f/0x190
Mar  6 22:04:32 tracker [<c034f9c3>] ? sys_socketcall+0x233/0x260
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker lockd         S 0000001d     0  4308      2
Mar  6 22:04:32 tracker d261df08 00000046 a895f0b3 0000001d d3c80464 d252fdc0 00000002 0001b5e3 
Mar  6 22:04:32 tracker 00000000 a897a696 0000001d c013b61d d261df10 d260fd90 d25b6aa4 d261df68 
Mar  6 22:04:32 tracker d261df38 c043c555 d261df2c 00000246 c04198e0 00000246 d25b6aa4 d261df2c 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:32 tracker [<c04198e0>] ? svc_recv+0x1f0/0x780
Mar  6 22:04:32 tracker [<c0123217>] ? local_bh_enable_ip+0x27/0x60
Mar  6 22:04:32 tracker [<c04198e8>] svc_recv+0x1f8/0x780
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c01fb760>] lockd+0xe0/0x230
Mar  6 22:04:32 tracker [<c010301e>] ? syscall_exit+0x8/0x1a
Mar  6 22:04:32 tracker [<c01fb680>] ? lockd+0x0/0x230
Mar  6 22:04:32 tracker [<c01fb680>] ? lockd+0x0/0x230
Mar  6 22:04:32 tracker [<c0103b43>] kernel_thread_helper+0x7/0x14
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker nfsd          S 0000001d     0  4309      2
Mar  6 22:04:32 tracker d262ff2c 00000046 a8ecf244 0000001d d262c5e4 d252fdc0 d262ff3c 0001b2be 
Mar  6 22:04:32 tracker 00000000 a8eea502 0000001d 00000000 00000292 d262ff3c 000d10c6 d262ff8c 
Mar  6 22:04:32 tracker d262ff5c c043c527 d262ff50 00000256 d2651f3c c0600768 000d10c6 c0126930 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:32 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:32 tracker [<c04198e8>] svc_recv+0x1f8/0x780
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c01eb6cc>] nfsd+0xcc/0x2b0
Mar  6 22:04:32 tracker [<c01eb600>] ? nfsd+0x0/0x2b0
Mar  6 22:04:32 tracker [<c01eb600>] ? nfsd+0x0/0x2b0
Mar  6 22:04:32 tracker [<c0103b43>] kernel_thread_helper+0x7/0x14
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker nfsd          S 0000001d     0  4310      2
Mar  6 22:04:32 tracker d2651f2c 00000046 a8eef9af 0000001d d264e604 d252fdc0 d2651f3c 000175af 
Mar  6 22:04:32 tracker 00000000 a8f06f5e 0000001d 00000000 00000292 d2651f3c 000d10c6 d2651f8c 
Mar  6 22:04:32 tracker d2651f5c c043c527 d2651f50 00000256 d2665f3c d262ff3c 000d10c6 c0126930 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:32 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:32 tracker [<c04198e8>] svc_recv+0x1f8/0x780
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c01eb6cc>] nfsd+0xcc/0x2b0
Mar  6 22:04:32 tracker [<c01eb600>] ? nfsd+0x0/0x2b0
Mar  6 22:04:32 tracker [<c01eb600>] ? nfsd+0x0/0x2b0
Mar  6 22:04:32 tracker [<c0103b43>] kernel_thread_helper+0x7/0x14
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker nfsd          S 0000001d     0  4311      2
Mar  6 22:04:32 tracker d2665f2c 00000046 a8f0c254 0000001d d2662624 d252fdc0 d2665f3c 00016ed9 
Mar  6 22:04:32 tracker 00000000 a8f2312d 0000001d 00000000 00000292 d2665f3c 000d10c6 d2665f8c 
Mar  6 22:04:32 tracker d2665f5c c043c527 d2665f50 00000256 d2677f3c d2651f3c 000d10c6 c0126930 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:32 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:32 tracker [<c04198e8>] svc_recv+0x1f8/0x780
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c01eb6cc>] nfsd+0xcc/0x2b0
Mar  6 22:04:32 tracker [<c01eb600>] ? nfsd+0x0/0x2b0
Mar  6 22:04:32 tracker [<c01eb600>] ? nfsd+0x0/0x2b0
Mar  6 22:04:32 tracker [<c0103b43>] kernel_thread_helper+0x7/0x14
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker nfsd          S 0000001d     0  4312      2
Mar  6 22:04:32 tracker d2677f2c 00000046 a8f283c3 0000001d d2674644 d252fdc0 d2677f3c 00016f26 
Mar  6 22:04:32 tracker 00000000 a8f3f2e9 0000001d 00000000 00000292 d2677f3c 000d10c6 d2677f8c 
Mar  6 22:04:32 tracker d2677f5c c043c527 d2677f50 00000256 d2699f3c d2665f3c 000d10c6 c0126930 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:32 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:32 tracker [<c04198e8>] svc_recv+0x1f8/0x780
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c01eb6cc>] nfsd+0xcc/0x2b0
Mar  6 22:04:32 tracker [<c01eb600>] ? nfsd+0x0/0x2b0
Mar  6 22:04:32 tracker [<c01eb600>] ? nfsd+0x0/0x2b0
Mar  6 22:04:32 tracker [<c0103b43>] kernel_thread_helper+0x7/0x14
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker nfsd          S 0000001d     0  4313      2
Mar  6 22:04:32 tracker d2699f2c 00000046 a8f443c4 0000001d d2696664 d252fdc0 d2699f3c 00016e90 
Mar  6 22:04:32 tracker 00000000 a8f5b254 0000001d 00000000 00000292 d2699f3c 000d10c6 d2699f8c 
Mar  6 22:04:32 tracker d2699f5c c043c527 d2699f50 00000256 d26adf3c d2677f3c 000d10c6 c0126930 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:32 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:32 tracker [<c04198e8>] svc_recv+0x1f8/0x780
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c01eb6cc>] nfsd+0xcc/0x2b0
Mar  6 22:04:32 tracker [<c01eb600>] ? nfsd+0x0/0x2b0
Mar  6 22:04:32 tracker [<c01eb600>] ? nfsd+0x0/0x2b0
Mar  6 22:04:32 tracker [<c0103b43>] kernel_thread_helper+0x7/0x14
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker nfsd          S 0000001d     0  4314      2
Mar  6 22:04:32 tracker d26adf2c 00000046 a8f60530 0000001d d26aa684 d252fdc0 d26adf3c 00016e76 
Mar  6 22:04:32 tracker 00000000 a8f773a6 0000001d 00000000 00000292 d26adf3c 000d10c6 d26adf8c 
Mar  6 22:04:32 tracker d26adf5c c043c527 d26adf50 00000256 c0600768 d2699f3c 000d10c6 c0126930 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:32 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:32 tracker [<c04198e8>] svc_recv+0x1f8/0x780
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c01eb6cc>] nfsd+0xcc/0x2b0
Mar  6 22:04:32 tracker [<c01eb600>] ? nfsd+0x0/0x2b0
Mar  6 22:04:32 tracker [<c01eb600>] ? nfsd+0x0/0x2b0
Mar  6 22:04:32 tracker [<c0103b43>] kernel_thread_helper+0x7/0x14
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker nfsd          S c05ffba0     0  4315      2
Mar  6 22:04:32 tracker d26bff2c 00000046 00000292 c05ffba0 d26bc6a4 d3f84280 d26bff3c c05ffba0 
Mar  6 22:04:32 tracker d26bff2c c0126e11 000def6d 00000000 00000292 d26bff3c 000def6d d26bff8c 
Mar  6 22:04:32 tracker d26bff5c c043c527 d26bff50 00000256 c0600780 d26d3f3c 000def6d c0126930 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c0126e11>] ? __mod_timer+0x91/0xa0
Mar  6 22:04:32 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:32 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:32 tracker [<c04198e8>] svc_recv+0x1f8/0x780
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c01eb6cc>] nfsd+0xcc/0x2b0
Mar  6 22:04:32 tracker [<c01eb600>] ? nfsd+0x0/0x2b0
Mar  6 22:04:32 tracker [<c01eb600>] ? nfsd+0x0/0x2b0
Mar  6 22:04:32 tracker [<c0103b43>] kernel_thread_helper+0x7/0x14
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker nfsd          S 00000058     0  4316      2
Mar  6 22:04:32 tracker d26d3f2c 00000046 572d4ef6 00000058 d26d06c4 d3f84280 d26d3f3c 0005e5df 
Mar  6 22:04:32 tracker 00000000 573334d5 00000058 00000000 00000292 d26d3f3c 000def6d d26d3f8c 
Mar  6 22:04:32 tracker d26d3f5c c043c527 d26d3f50 00000256 d26bff3c c0600780 000def6d c0126930 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:32 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:32 tracker [<c04198e8>] svc_recv+0x1f8/0x780
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c01eb6cc>] nfsd+0xcc/0x2b0
Mar  6 22:04:32 tracker [<c01eb600>] ? nfsd+0x0/0x2b0
Mar  6 22:04:32 tracker [<c01eb600>] ? nfsd+0x0/0x2b0
Mar  6 22:04:32 tracker [<c0103b43>] kernel_thread_helper+0x7/0x14
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker automount     S d3f0de00     0  4386      1
Mar  6 22:04:32 tracker d26e7bf0 00000056 00000046 d3f0de00 d26e8704 d245ddc0 d26e7bd8 c043eb8c 
Mar  6 22:04:32 tracker d26e7c78 d3f0de00 d26e7bec c013129b 00000001 00000000 ffffffff 00000000 
Mar  6 22:04:32 tracker d26e7c20 c043c555 d3fa1220 d26e7c48 d3fa1220 d3f0de00 d26e7c20 c016fb6f 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043eb8c>] ? _spin_unlock_irqrestore+0x2c/0x50
Mar  6 22:04:32 tracker [<c013129b>] ? add_wait_queue+0x3b/0x50
Mar  6 22:04:32 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:32 tracker [<c016fb6f>] ? pipe_poll+0x2f/0xb0
Mar  6 22:04:32 tracker [<c01765d4>] do_sys_poll+0x254/0x380
Mar  6 22:04:32 tracker [<c0177290>] ? __pollwait+0x0/0xe0
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c043eb8c>] ? _spin_unlock_irqrestore+0x2c/0x50
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c0116e06>] ? __wake_up_sync+0x46/0x60
Mar  6 22:04:32 tracker [<c017e0ce>] ? touch_atime+0x8e/0xf0
Mar  6 22:04:32 tracker [<c0170d7e>] ? pipe_read+0x2ee/0x380
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c012802a>] ? sigprocmask+0x7a/0xf0
Mar  6 22:04:32 tracker [<c043ebd8>] ? _spin_unlock_irq+0x28/0x50
Mar  6 22:04:32 tracker [<c012802a>] ? sigprocmask+0x7a/0xf0
Mar  6 22:04:32 tracker [<c01777e5>] sys_poll+0x35/0x80
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker dbus-daemon   S 00000000     0  4450      1
Mar  6 22:04:32 tracker d26f7bf0 00000056 00000000 00000000 d26f8764 d252f4c0 00000000 00000000 
Mar  6 22:04:32 tracker 00000000 01974481 00000020 00000000 d26f7c48 00000000 ffffffff 00000000 
Mar  6 22:04:32 tracker d26f7c20 c043c555 d26f7c48 d3f690c0 d26f7c14 c03b976d 0086b880 c046cf60 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:32 tracker [<c03b976d>] ? unix_poll+0x1d/0xc0
Mar  6 22:04:32 tracker [<c01765d4>] do_sys_poll+0x254/0x380
Mar  6 22:04:32 tracker [<c0177290>] ? __pollwait+0x0/0xe0
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<d482ff67>] ? uhci_urb_enqueue+0x47/0x7c0 [uhci_hcd]
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c043cce8>] ? mutex_unlock+0x8/0x10
Mar  6 22:04:32 tracker [<c043cce8>] ? mutex_unlock+0x8/0x10
Mar  6 22:04:32 tracker [<c03bac32>] ? unix_stream_recvmsg+0x342/0x4d0
Mar  6 22:04:32 tracker [<c034da79>] ? sock_aio_read+0xe9/0x110
Mar  6 22:04:32 tracker [<c0169d0c>] ? do_sync_read+0xcc/0x110
Mar  6 22:04:32 tracker [<c0130fe0>] ? autoremove_wake_function+0x0/0x50
Mar  6 22:04:32 tracker [<c0199d8e>] ? dnotify_parent+0x6e/0x80
Mar  6 22:04:32 tracker [<c043ea97>] ? _spin_unlock+0x27/0x50
Mar  6 22:04:32 tracker [<c0107bc8>] ? read_tsc+0x8/0x10
Mar  6 22:04:32 tracker [<c01366c3>] ? getnstimeofday+0x33/0xd0
Mar  6 22:04:32 tracker [<c01777e5>] sys_poll+0x35/0x80
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker avahi-daemon  S 00000000     0  4510      1
Mar  6 22:04:32 tracker d2713bf0 00000056 00000000 00000000 d26d46e4 d3f84b80 00000000 00000000 
Mar  6 22:04:32 tracker 00000000 04ee1bd6 00000057 00000000 00000286 d2713c00 00003f51 00000000 
Mar  6 22:04:32 tracker d2713c20 c043c527 d3fa19a0 d2713c48 c06005c0 c06005c0 00003f51 c0126930 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:32 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:32 tracker [<c01765d4>] do_sys_poll+0x254/0x380
Mar  6 22:04:32 tracker [<c0177290>] ? __pollwait+0x0/0xe0
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c0116e06>] ? __wake_up_sync+0x46/0x60
Mar  6 22:04:32 tracker [<c0122856>] ? current_fs_time+0x16/0x20
Mar  6 22:04:32 tracker [<c017e0b7>] ? touch_atime+0x77/0xf0
Mar  6 22:04:32 tracker [<c0170d7e>] ? pipe_read+0x2ee/0x380
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c0199d8e>] ? dnotify_parent+0x6e/0x80
Mar  6 22:04:32 tracker [<c043ea97>] ? _spin_unlock+0x27/0x50
Mar  6 22:04:32 tracker [<c0107bc8>] ? read_tsc+0x8/0x10
Mar  6 22:04:32 tracker [<c01366c3>] ? getnstimeofday+0x33/0xd0
Mar  6 22:04:32 tracker [<c01777e5>] sys_poll+0x35/0x80
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker avahi-daemon  S 00000000     0  4512   4510
Mar  6 22:04:32 tracker d2725da0 00000056 00000000 00000000 d24b6564 d252fdc0 00000000 00000000 
Mar  6 22:04:32 tracker 00000000 53f59c28 0000001f c013b61d d2725da8 d270aca0 00000000 00000000 
Mar  6 22:04:32 tracker d2725dd0 c043c555 d2725dc4 00000246 c03babaa 00000246 d270af50 00000000 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:32 tracker [<c03babaa>] ? unix_stream_recvmsg+0x2ba/0x4d0
Mar  6 22:04:32 tracker [<c03babb2>] unix_stream_recvmsg+0x2c2/0x4d0
Mar  6 22:04:32 tracker [<c0234267>] ? copy_from_user+0x37/0x70
Mar  6 22:04:32 tracker [<c0130fe0>] ? autoremove_wake_function+0x0/0x50
Mar  6 22:04:32 tracker [<c034da79>] sock_aio_read+0xe9/0x110
Mar  6 22:04:32 tracker [<c043ec78>] ? _read_unlock_irq+0x28/0x50
Mar  6 22:04:32 tracker [<c0169d0c>] do_sync_read+0xcc/0x110
Mar  6 22:04:32 tracker [<c0149f94>] ? unlock_page+0x24/0x30
Mar  6 22:04:32 tracker [<c0130fe0>] ? autoremove_wake_function+0x0/0x50
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c016a5ef>] vfs_read+0x11f/0x130
Mar  6 22:04:32 tracker [<c016a9ad>] sys_read+0x3d/0x70
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker hcid          S 00000000     0  4566      1
Mar  6 22:04:32 tracker d2737bf0 00000056 00000000 00000000 d2520584 d3f12040 00000000 00000000 
Mar  6 22:04:32 tracker 00000000 019b94df 00000020 00000000 d2737c48 00000000 ffffffff 00000000 
Mar  6 22:04:32 tracker d2737c20 c043c555 d2737c48 d2511200 d2737c14 c03b976d 00356eba c046cf60 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:32 tracker [<c03b976d>] ? unix_poll+0x1d/0xc0
Mar  6 22:04:32 tracker [<c01765d4>] do_sys_poll+0x254/0x380
Mar  6 22:04:32 tracker [<c0177290>] ? __pollwait+0x0/0xe0
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c0118341>] ? hrtick_set+0x61/0x100
Mar  6 22:04:32 tracker [<c043eb8c>] ? _spin_unlock_irqrestore+0x2c/0x50
Mar  6 22:04:32 tracker [<c0118387>] ? hrtick_set+0xa7/0x100
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c0354589>] ? kfree_skb+0x19/0x30
Mar  6 22:04:32 tracker [<c0356f9d>] ? skb_free_datagram+0xd/0x40
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c03f2523>] ? hci_dev_get+0x93/0xb0
Mar  6 22:04:32 tracker [<c0233fe7>] ? __copy_to_user_ll+0x57/0x60
Mar  6 22:04:32 tracker [<c02344d5>] ? copy_to_user+0x35/0x50
Mar  6 22:04:32 tracker [<c03f79c8>] ? hci_sock_ioctl+0x158/0x2b0
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c034dcd0>] ? sock_ioctl+0xe0/0x230
Mar  6 22:04:32 tracker [<c034dbf0>] ? sock_ioctl+0x0/0x230
Mar  6 22:04:32 tracker [<c0175a28>] ? vfs_ioctl+0x28/0x80
Mar  6 22:04:32 tracker [<c0175ad7>] ? do_vfs_ioctl+0x57/0x2d0
Mar  6 22:04:32 tracker [<c01777e5>] sys_poll+0x35/0x80
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker sdpd          S 00000000     0  4577      1
Mar  6 22:04:32 tracker d274db10 00000056 00000000 00000000 d248cc04 d252fb80 00000000 00000000 
Mar  6 22:04:32 tracker 00000000 2854be47 00000020 00000000 d274dbc4 00000007 00000040 00000304 
Mar  6 22:04:32 tracker d274db40 c043c555 d274dbc4 d272fb40 d274db34 c03b976d 003f153a c046cf60 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:32 tracker [<c03b976d>] ? unix_poll+0x1d/0xc0
Mar  6 22:04:32 tracker [<c0176c27>] do_select+0x4c7/0x5c0
Mar  6 22:04:32 tracker [<c0176760>] ? do_select+0x0/0x5c0
Mar  6 22:04:32 tracker [<c016276d>] ? dma_pool_alloc+0x19d/0x1c0
Mar  6 22:04:32 tracker [<c0177290>] ? __pollwait+0x0/0xe0
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c01b8d10>] ? do_get_write_access+0x270/0x560
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c03522c7>] ? sock_def_readable+0x57/0x80
Mar  6 22:04:32 tracker [<c043eb37>] ? _read_unlock+0x27/0x50
Mar  6 22:04:32 tracker [<c03522c7>] ? sock_def_readable+0x57/0x80
Mar  6 22:04:32 tracker [<c03bb7cb>] ? unix_stream_sendmsg+0x18b/0x320
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c0176f3a>] core_sys_select+0x21a/0x330
Mar  6 22:04:32 tracker [<c0176d47>] ? core_sys_select+0x27/0x330
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c034dee0>] ? sockfd_lookup_light+0x30/0x60
Mar  6 22:04:32 tracker [<c034e955>] ? sys_sendto+0xa5/0xd0
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c0157ead>] ? handle_mm_fault+0x2cd/0x5d0
Mar  6 22:04:32 tracker [<c01773af>] sys_select+0x3f/0x190
Mar  6 22:04:32 tracker [<c034f8c7>] ? sys_socketcall+0x137/0x260
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker pand          S 00000000     0  4587      1
Mar  6 22:04:32 tracker d2749e68 00000046 00000000 00000000 d2704784 d3da7040 00000000 00000000 
Mar  6 22:04:32 tracker 00000000 285c6f74 00000020 d2749e70 00000256 d271b400 7fffffff ffffffb3 
Mar  6 22:04:32 tracker d2749e98 c043c555 d2749e7c c043e26f d271b454 d2749e98 c03505c1 d3a4d040 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:32 tracker [<c043e26f>] ? _spin_unlock_bh+0x2f/0x40
Mar  6 22:04:32 tracker [<c03505c1>] ? release_sock+0xc1/0xd0
Mar  6 22:04:32 tracker [<c03faefd>] l2cap_sock_accept+0xad/0x140
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c034f6a3>] sys_accept+0xd3/0x1c0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c03505c1>] ? release_sock+0xc1/0xd0
Mar  6 22:04:32 tracker [<c0123217>] ? local_bh_enable_ip+0x27/0x60
Mar  6 22:04:32 tracker [<c043e26f>] ? _spin_unlock_bh+0x2f/0x40
Mar  6 22:04:32 tracker [<c03505c1>] ? release_sock+0xc1/0xd0
Mar  6 22:04:32 tracker [<c03fb963>] ? l2cap_sock_listen+0x33/0xe0
Mar  6 22:04:32 tracker [<c034dee0>] ? sockfd_lookup_light+0x30/0x60
Mar  6 22:04:32 tracker [<c034f851>] sys_socketcall+0xc1/0x260
Mar  6 22:04:32 tracker [<c0102faa>] ? sysenter_past_esp+0x6b/0x91
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker distccd       S 00000000     0  4680      1
Mar  6 22:04:32 tracker d276ff08 00000046 00000000 00000000 d276c7e4 d3fff4c0 00000000 00000000 
Mar  6 22:04:32 tracker 00000000 518acfc2 00000023 00000001 c05a2a00 00000001 00000001 00000004 
Mar  6 22:04:32 tracker d276ff78 c0120a4f d27a4640 d276ff30 c01343dd 00000000 d276c778 00000000 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c0120a4f>] do_wait+0x55f/0xa60
Mar  6 22:04:32 tracker [<c01343dd>] ? hrtimer_try_to_cancel+0x3d/0x70
Mar  6 22:04:32 tracker [<c043d27c>] ? do_nanosleep+0x6c/0x90
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0120fc1>] sys_wait4+0x71/0xc0
Mar  6 22:04:32 tracker [<c0121035>] sys_waitpid+0x25/0x30
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker distccd       S 00000000     0  4681   4680
Mar  6 22:04:32 tracker d27a3e30 00000056 00000000 00000000 d273a7c4 d245d4c0 00000000 00000000 
Mar  6 22:04:32 tracker 00000000 9482a78e 00000022 d27a3e38 00000246 d2576040 00000000 7fffffff 
Mar  6 22:04:32 tracker d27a3e60 c043c555 d27a3e44 c043e26f d2576094 d27a3e60 c03505c1 c0131143 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:32 tracker [<c043e26f>] ? _spin_unlock_bh+0x2f/0x40
Mar  6 22:04:32 tracker [<c03505c1>] ? release_sock+0xc1/0xd0
Mar  6 22:04:32 tracker [<c0131143>] ? prepare_to_wait_exclusive+0x53/0x60
Mar  6 22:04:32 tracker [<c0380a5c>] inet_csk_accept+0x11c/0x260
Mar  6 22:04:32 tracker [<c017ba58>] ? d_instantiate+0x48/0x60
Mar  6 22:04:32 tracker [<c0130fe0>] ? autoremove_wake_function+0x0/0x50
Mar  6 22:04:32 tracker [<c039fff6>] inet_accept+0x26/0xc0
Mar  6 22:04:32 tracker [<c034f6a3>] sys_accept+0xd3/0x1c0
Mar  6 22:04:32 tracker [<c01568d7>] ? __do_fault+0x177/0x3d0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c0113a34>] ? do_page_fault+0x124/0x610
Mar  6 22:04:32 tracker [<c034f851>] sys_socketcall+0xc1/0x260
Mar  6 22:04:32 tracker [<c0102ef4>] ? resume_userspace+0x8/0x20
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker distccd       S 00000000     0  4709   4680
Mar  6 22:04:32 tracker d2799e30 00000056 00000000 00000000 d279a8a4 d3da7280 00000000 00000000 
Mar  6 22:04:32 tracker 00000000 d0a6d799 00000022 d2799e38 00000246 d2576040 00000000 7fffffff 
Mar  6 22:04:32 tracker d2799e60 c043c555 d2799e44 c043e26f d2576094 d2799e60 c03505c1 c0131143 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:32 tracker [<c043e26f>] ? _spin_unlock_bh+0x2f/0x40
Mar  6 22:04:32 tracker [<c03505c1>] ? release_sock+0xc1/0xd0
Mar  6 22:04:32 tracker [<c0131143>] ? prepare_to_wait_exclusive+0x53/0x60
Mar  6 22:04:32 tracker [<c0380a5c>] inet_csk_accept+0x11c/0x260
Mar  6 22:04:32 tracker [<c017ba58>] ? d_instantiate+0x48/0x60
Mar  6 22:04:32 tracker [<c0130fe0>] ? autoremove_wake_function+0x0/0x50
Mar  6 22:04:32 tracker [<c039fff6>] inet_accept+0x26/0xc0
Mar  6 22:04:32 tracker [<c034f6a3>] sys_accept+0xd3/0x1c0
Mar  6 22:04:32 tracker [<c01568d7>] ? __do_fault+0x177/0x3d0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c0113a34>] ? do_page_fault+0x124/0x610
Mar  6 22:04:32 tracker [<c034f851>] sys_socketcall+0xc1/0x260
Mar  6 22:04:32 tracker [<c0102ef4>] ? resume_userspace+0x8/0x20
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker distccd       S 00000000     0  4738   4680
Mar  6 22:04:32 tracker d27b9e30 00000056 00000000 00000000 d27a4884 d3fff280 00000000 00000000 
Mar  6 22:04:32 tracker 00000000 0cb7614a 00000023 d27b9e38 00000246 d2576040 00000000 7fffffff 
Mar  6 22:04:32 tracker d27b9e60 c043c555 d27b9e44 c043e26f d2576094 d27b9e60 c03505c1 c0131143 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:32 tracker [<c043e26f>] ? _spin_unlock_bh+0x2f/0x40
Mar  6 22:04:32 tracker [<c03505c1>] ? release_sock+0xc1/0xd0
Mar  6 22:04:32 tracker [<c0131143>] ? prepare_to_wait_exclusive+0x53/0x60
Mar  6 22:04:32 tracker [<c0380a5c>] inet_csk_accept+0x11c/0x260
Mar  6 22:04:32 tracker [<c017ba58>] ? d_instantiate+0x48/0x60
Mar  6 22:04:32 tracker [<c0130fe0>] ? autoremove_wake_function+0x0/0x50
Mar  6 22:04:32 tracker [<c039fff6>] inet_accept+0x26/0xc0
Mar  6 22:04:32 tracker [<c034f6a3>] sys_accept+0xd3/0x1c0
Mar  6 22:04:32 tracker [<c01568d7>] ? __do_fault+0x177/0x3d0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c0113a34>] ? do_page_fault+0x124/0x610
Mar  6 22:04:32 tracker [<c034f851>] sys_socketcall+0xc1/0x260
Mar  6 22:04:32 tracker [<c0102ef4>] ? resume_userspace+0x8/0x20
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker spamd         S c05ffba0     0  4747      1
Mar  6 22:04:32 tracker d27c9b10 00000056 00000286 c05ffba0 d257e904 d3f84280 d27c9b20 c05ffba0 
Mar  6 22:04:32 tracker d27c9b10 c0126e11 00003733 00000000 00000286 d27c9b20 00003733 00000304 
Mar  6 22:04:32 tracker d27c9b40 c043c527 d27c9bc4 d3dfda60 d3ec7204 d3f3f118 00003733 c0126930 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c0126e11>] ? __mod_timer+0x91/0xa0
Mar  6 22:04:32 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:32 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:32 tracker [<c0176c27>] do_select+0x4c7/0x5c0
Mar  6 22:04:32 tracker [<c0176760>] ? do_select+0x0/0x5c0
Mar  6 22:04:32 tracker [<c0421536>] ? sta_info_get+0x56/0x60
Mar  6 22:04:32 tracker [<c0177290>] ? __pollwait+0x0/0xe0
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c035ca58>] ? dev_queue_xmit+0x218/0x300
Mar  6 22:04:32 tracker [<c012318e>] ? local_bh_enable+0x2e/0x90
Mar  6 22:04:32 tracker [<c035c916>] ? dev_queue_xmit+0xd6/0x300
Mar  6 22:04:32 tracker [<c035c874>] ? dev_queue_xmit+0x34/0x300
Mar  6 22:04:32 tracker [<c04326f0>] ? ieee80211_subif_start_xmit+0x4b0/0x610
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c0176f3a>] core_sys_select+0x21a/0x330
Mar  6 22:04:32 tracker [<c0176d47>] ? core_sys_select+0x27/0x330
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c0121d79>] ? do_setitimer+0x119/0x310
Mar  6 22:04:32 tracker [<c0177444>] sys_select+0xd4/0x190
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker master        S c05ffba0     0  4852      1
Mar  6 22:04:32 tracker cf4a1f24 00000046 00000286 c05ffba0 d279e844 d3fff700 cf4a1f34 c05ffba0 
Mar  6 22:04:32 tracker cf4a1f24 c0126e11 00006874 00000000 00000286 cf4a1f34 00006874 00000000 
Mar  6 22:04:32 tracker cf4a1f54 c043c527 00000046 c0194f28 c0600508 c0600508 00006874 c0126930 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c0126e11>] ? __mod_timer+0x91/0xa0
Mar  6 22:04:32 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:32 tracker [<c0194f28>] ? sys_epoll_wait+0x3b8/0x470
Mar  6 22:04:32 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:32 tracker [<c0194f30>] sys_epoll_wait+0x3c0/0x470
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker pickup        S 00000000     0  4856   4852
Mar  6 22:04:32 tracker d2757f24 00200046 00000000 00000000 d3d9e8e4 d245d280 00000000 00000000 
Mar  6 22:04:32 tracker 00000000 a91c5210 00000056 00000000 00200286 d2757f34 00008f95 00000000 
Mar  6 22:04:32 tracker d2757f54 c043c527 00200046 c0194f28 c06005d8 c059762c 00008f95 c0126930 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:32 tracker [<c0194f28>] ? sys_epoll_wait+0x3b8/0x470
Mar  6 22:04:32 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:32 tracker [<c0194f30>] sys_epoll_wait+0x3c0/0x470
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker qmgr          S 0000003c     0  4858   4852
Mar  6 22:04:32 tracker d257df24 00200046 6a3143dc 0000003c d26d6724 d3f12940 00000000 00179e85 
Mar  6 22:04:32 tracker 00000000 6a48e261 0000003c 00000000 00200286 d257df34 0000a41c ffffffea 
Mar  6 22:04:32 tracker d257df54 c043c527 00200046 c0194f28 c059762c c06005d8 0000a41c c0126930 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:32 tracker [<c0194f28>] ? sys_epoll_wait+0x3b8/0x470
Mar  6 22:04:32 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:32 tracker [<c0194f30>] sys_epoll_wait+0x3c0/0x470
Mar  6 22:04:32 tracker [<c0122045>] ? alarm_setitimer+0x35/0x70
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker fetchmail     S 0000004b     0  4921      1
Mar  6 22:04:32 tracker cf4f7b10 00200056 95c99347 0000004b cf50a9c4 d3f84700 00000000 00000001 
Mar  6 22:04:32 tracker 00000000 95c99348 0000004b 00000000 00200286 cf4f7b20 00004062 00000000 
Mar  6 22:04:32 tracker cf4f7b40 c043c527 cf50a780 cf50add4 c06003c8 c06003c8 00004062 c0126930 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:32 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:32 tracker [<c0176c27>] do_select+0x4c7/0x5c0
Mar  6 22:04:32 tracker [<c0176760>] ? do_select+0x0/0x5c0
Mar  6 22:04:32 tracker [<c04312ae>] ? ieee80211_master_start_xmit+0x2ce/0x4e0
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c0177290>] ? __pollwait+0x0/0xe0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c035ca58>] ? dev_queue_xmit+0x218/0x300
Mar  6 22:04:32 tracker [<c01163fe>] ? __enqueue_entity+0x8e/0xb0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c0117784>] ? try_to_wake_up+0x44/0xe0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c03522c7>] ? sock_def_readable+0x57/0x80
Mar  6 22:04:32 tracker [<c043eb37>] ? _read_unlock+0x27/0x50
Mar  6 22:04:32 tracker [<c03522c7>] ? sock_def_readable+0x57/0x80
Mar  6 22:04:32 tracker [<c03bb7cb>] ? unix_stream_sendmsg+0x18b/0x320
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c0176d47>] ? core_sys_select+0x27/0x330
Mar  6 22:04:32 tracker [<c0176f3a>] core_sys_select+0x21a/0x330
Mar  6 22:04:32 tracker [<c0176d47>] ? core_sys_select+0x27/0x330
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c034dee0>] ? sockfd_lookup_light+0x30/0x60
Mar  6 22:04:32 tracker [<c034e955>] ? sys_sendto+0xa5/0xd0
Mar  6 22:04:32 tracker [<c022de5d>] ? _atomic_dec_and_lock+0x2d/0x40
Mar  6 22:04:32 tracker [<c0233fe7>] ? __copy_to_user_ll+0x57/0x60
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c01279e9>] ? do_sigaction+0xd9/0x170
Mar  6 22:04:32 tracker [<c0177444>] sys_select+0xd4/0x190
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker gpm           S 00000029     0  4983      1
Mar  6 22:04:32 tracker cf505b10 00000056 1eef45eb 00000029 cf4bc9a4 d3f84040 cf505b20 000e6754 
Mar  6 22:04:32 tracker 00000000 1efdad3f 00000029 00000000 00000286 cf505b20 01491a5f 00000304 
Mar  6 22:04:32 tracker cf505b40 c043c527 cf505bc4 cf4b7f00 c0600868 c0600868 01491a5f c0126930 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:32 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:32 tracker [<c0176c27>] do_select+0x4c7/0x5c0
Mar  6 22:04:32 tracker [<c0176760>] ? do_select+0x0/0x5c0
Mar  6 22:04:32 tracker [<c0177290>] ? __pollwait+0x0/0xe0
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c01abe39>] ? __ext3_get_inode_loc+0x149/0x340
Mar  6 22:04:32 tracker [<c01ba195>] ? journal_dirty_metadata+0x95/0x170
Mar  6 22:04:32 tracker [<c01bd7cd>] ? journal_add_journal_head+0xdd/0x1c0
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c017b773>] ? __d_lookup+0xe3/0x190
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c0176f3a>] core_sys_select+0x21a/0x330
Mar  6 22:04:32 tracker [<c0176d47>] ? core_sys_select+0x27/0x330
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c043ec78>] ? _read_unlock_irq+0x28/0x50
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c01568cf>] ? __do_fault+0x16f/0x3d0
Mar  6 22:04:32 tracker [<c0149f94>] ? unlock_page+0x24/0x30
Mar  6 22:04:32 tracker [<c01568d7>] ? __do_fault+0x177/0x3d0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c0177444>] sys_select+0xd4/0x190
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker ntpd          S cec0a598     0  5658      1
Mar  6 22:04:32 tracker cc407bf0 00200056 00200296 cec0a598 cf5d2b04 cf7dddc0 cc407c5c cec0a598 
Mar  6 22:04:32 tracker cc407be4 c013129b 00000000 00000000 cc407c48 00000000 ffffffff 00000000 
Mar  6 22:04:32 tracker cc407c20 c043c555 cc407c48 cf4c1ee0 cc407c14 c03b976d 00db1ec0 c046cf60 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c013129b>] ? add_wait_queue+0x3b/0x50
Mar  6 22:04:32 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:32 tracker [<c03b976d>] ? unix_poll+0x1d/0xc0
Mar  6 22:04:32 tracker [<c01765d4>] do_sys_poll+0x254/0x380
Mar  6 22:04:32 tracker [<c0177290>] ? __pollwait+0x0/0xe0
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c0118341>] ? hrtick_set+0x61/0x100
Mar  6 22:04:32 tracker [<c043eb8c>] ? _spin_unlock_irqrestore+0x2c/0x50
Mar  6 22:04:32 tracker [<c0118387>] ? hrtick_set+0xa7/0x100
Mar  6 22:04:32 tracker [<c043c194>] ? schedule+0x2b4/0x450
Mar  6 22:04:32 tracker [<c043c3f9>] ? preempt_schedule+0x59/0x80
Mar  6 22:04:32 tracker [<c043eb4c>] ? _read_unlock+0x3c/0x50
Mar  6 22:04:32 tracker [<c03522c7>] ? sock_def_readable+0x57/0x80
Mar  6 22:04:32 tracker [<c03bb7cb>] ? unix_stream_sendmsg+0x18b/0x320
Mar  6 22:04:32 tracker [<c034d96b>] ? sock_aio_write+0xeb/0x110
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c0199d8e>] ? dnotify_parent+0x6e/0x80
Mar  6 22:04:32 tracker [<c043ea97>] ? _spin_unlock+0x27/0x50
Mar  6 22:04:32 tracker [<c016a283>] ? do_readv_writev+0x113/0x180
Mar  6 22:04:32 tracker [<c034d880>] ? sock_aio_write+0x0/0x110
Mar  6 22:04:32 tracker [<c016a32f>] ? vfs_writev+0x3f/0x60
Mar  6 22:04:32 tracker [<c01777e5>] sys_poll+0x35/0x80
Mar  6 22:04:32 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:32 tracker =======================
Mar  6 22:04:32 tracker ntpd          S 00000000     0  5659   5658
Mar  6 22:04:32 tracker cf7f5bf0 00200056 00000000 00000000 cf7d0284 cf6c24c0 00000000 00000000 
Mar  6 22:04:32 tracker 00000000 e66cdc4b 0000004a 00000000 00200286 cf7f5c00 00007924 00000000 
Mar  6 22:04:32 tracker cf7f5c20 c043c527 cf7f5c48 cf579d80 c06005d0 c06005d0 00007924 c0126930 
Mar  6 22:04:32 tracker Call Trace:
Mar  6 22:04:32 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:32 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:32 tracker [<c01765d4>] do_sys_poll+0x254/0x380
Mar  6 22:04:32 tracker [<c0177290>] ? __pollwait+0x0/0xe0
Mar  6 22:04:32 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:32 tracker [<c021bad6>] ? scatterwalk_done+0x16/0x20
Mar  6 22:04:32 tracker [<c021c923>] ? blkcipher_walk_done+0x83/0x280
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:32 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:32 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:32 tracker [<c0282448>] ? e100_exec_cb+0xe8/0x110
Mar  6 22:04:32 tracker [<c02816d0>] ? e100_xmit_prepare+0x0/0xa0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c035ca58>] ? dev_queue_xmit+0x218/0x300
Mar  6 22:04:33 tracker [<c012318e>] ? local_bh_enable+0x2e/0x90
Mar  6 22:04:33 tracker [<c035c916>] ? dev_queue_xmit+0xd6/0x300
Mar  6 22:04:33 tracker [<c035c874>] ? dev_queue_xmit+0x34/0x300
Mar  6 22:04:33 tracker [<c037bf0d>] ? ip_finish_output+0x12d/0x2d0
Mar  6 22:04:33 tracker [<c037bde0>] ? ip_finish_output+0x0/0x2d0
Mar  6 22:04:33 tracker [<c037cb6d>] ? ip_output+0x6d/0xc0
Mar  6 22:04:33 tracker [<c037bde0>] ? ip_finish_output+0x0/0x2d0
Mar  6 22:04:33 tracker [<c037921c>] ? ip_forward_finish+0x1c/0x30
Mar  6 22:04:33 tracker [<c03793f5>] ? ip_forward+0x1c5/0x340
Mar  6 22:04:33 tracker [<c0379200>] ? ip_forward_finish+0x0/0x30
Mar  6 22:04:33 tracker [<c036cb89>] ? nf_hook_slow+0xe9/0x120
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c0359b19>] ? netif_receive_skb+0x1b9/0x290
Mar  6 22:04:33 tracker [<c0359b37>] ? netif_receive_skb+0x1d7/0x290
Mar  6 22:04:33 tracker [<c03599c8>] ? netif_receive_skb+0x68/0x290
Mar  6 22:04:33 tracker [<c035c50c>] ? process_backlog+0x5c/0xb0
Mar  6 22:04:33 tracker [<c035bfa7>] ? net_rx_action+0x97/0x130
Mar  6 22:04:33 tracker [<c0122c64>] ? _local_bh_enable+0x24/0x80
Mar  6 22:04:33 tracker [<c0122d58>] ? __do_softirq+0x98/0xb0
Mar  6 22:04:33 tracker [<c01777e5>] sys_poll+0x35/0x80
Mar  6 22:04:33 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:33 tracker =======================
Mar  6 22:04:33 tracker rwhod         S cf581ce4     0  5723      1
Mar  6 22:04:33 tracker cf581d10 00000056 00000607 cf581ce4 cf5b0ae4 cf7ddb80 c013b69d c06b1a40 
Mar  6 22:04:33 tracker cf5b08a0 cf5b0ef4 cec1ed88 cf581d18 00000046 d25af790 d25af6c0 d25af790 
Mar  6 22:04:33 tracker cf581d40 c043c555 cf581d28 c043eb8c cf581d58 cec1ed78 cf581d40 c0131143 
Mar  6 22:04:33 tracker Call Trace:
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:33 tracker [<c043eb8c>] ? _spin_unlock_irqrestore+0x2c/0x50
Mar  6 22:04:33 tracker [<c0131143>] ? prepare_to_wait_exclusive+0x53/0x60
Mar  6 22:04:33 tracker [<c0356d33>] __skb_recv_datagram+0x103/0x240
Mar  6 22:04:33 tracker [<c0130fe0>] ? autoremove_wake_function+0x0/0x50
Mar  6 22:04:33 tracker [<c0399029>] udp_recvmsg+0x59/0x300
Mar  6 22:04:33 tracker [<c034ff53>] sock_common_recvmsg+0x43/0x60
Mar  6 22:04:33 tracker [<c034e576>] sock_recvmsg+0xc6/0xf0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c0130fe0>] ? autoremove_wake_function+0x0/0x50
Mar  6 22:04:33 tracker [<c043cce8>] ? mutex_unlock+0x8/0x10
Mar  6 22:04:33 tracker [<c043cce8>] ? mutex_unlock+0x8/0x10
Mar  6 22:04:33 tracker [<c034dee0>] ? sockfd_lookup_light+0x30/0x60
Mar  6 22:04:33 tracker [<c034f41d>] sys_recvfrom+0x7d/0xd0
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c022de5d>] ? _atomic_dec_and_lock+0x2d/0x40
Mar  6 22:04:33 tracker [<c043ea97>] ? _spin_unlock+0x27/0x50
Mar  6 22:04:33 tracker [<c022de5d>] ? _atomic_dec_and_lock+0x2d/0x40
Mar  6 22:04:33 tracker [<c034f946>] sys_socketcall+0x1b6/0x260
Mar  6 22:04:33 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:33 tracker =======================
Mar  6 22:04:33 tracker rwhod         S 00000000     0  5724   5723
Mar  6 22:04:33 tracker cc443f3c 00000046 00000000 00000000 cc41c2c4 d3f12b80 00000000 00000000 
Mar  6 22:04:33 tracker 00000000 cebbbd5f 0000002e 00000296 00000000 cc443f5c 00000001 cc443f5c 
Mar  6 22:04:33 tracker cc443f50 c043d275 00000001 00000000 00000001 cc443f98 c0134532 bfc0bdb4 
Mar  6 22:04:33 tracker Call Trace:
Mar  6 22:04:33 tracker [<c043d275>] do_nanosleep+0x65/0x90
Mar  6 22:04:33 tracker [<c0134532>] hrtimer_nanosleep+0x42/0xb0
Mar  6 22:04:33 tracker [<c01340f0>] ? hrtimer_wakeup+0x0/0x20
Mar  6 22:04:33 tracker [<c01345f8>] sys_nanosleep+0x58/0x60
Mar  6 22:04:33 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:33 tracker =======================
Mar  6 22:04:33 tracker sshd          S 00000000     0  5779      1
Mar  6 22:04:33 tracker cc431b10 00200056 00000000 00000000 cc456304 d3f12dc0 00000000 00000000 
Mar  6 22:04:33 tracker 00000000 900d1aa1 0000002f 00000000 00000000 00000004 00000008 00000000 
Mar  6 22:04:33 tracker cc431b40 c043c555 cc431bc4 d2577240 cf4c1220 cc431b34 c03823da c046d160 
Mar  6 22:04:33 tracker Call Trace:
Mar  6 22:04:33 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:33 tracker [<c03823da>] ? tcp_poll+0x1a/0x160
Mar  6 22:04:33 tracker [<c0176c27>] do_select+0x4c7/0x5c0
Mar  6 22:04:33 tracker [<c0176760>] ? do_select+0x0/0x5c0
Mar  6 22:04:33 tracker [<c0177290>] ? __pollwait+0x0/0xe0
Mar  6 22:04:33 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:33 tracker [<c01abe39>] ? __ext3_get_inode_loc+0x149/0x340
Mar  6 22:04:33 tracker [<c01ba195>] ? journal_dirty_metadata+0x95/0x170
Mar  6 22:04:33 tracker [<c01bd7cd>] ? journal_add_journal_head+0xdd/0x1c0
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c01b89d6>] ? journal_stop+0x116/0x1e0
Mar  6 22:04:33 tracker [<c0150a2b>] ? balance_dirty_pages_ratelimited_nr+0x4b/0x250
Mar  6 22:04:33 tracker [<c01ae2c7>] ? ext3_ordered_write_end+0xd7/0x130
Mar  6 22:04:33 tracker [<c014b04e>] ? generic_file_buffered_write+0x18e/0x650
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c0176f3a>] core_sys_select+0x21a/0x330
Mar  6 22:04:33 tracker [<c0176d47>] ? core_sys_select+0x27/0x330
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c043ec78>] ? _read_unlock_irq+0x28/0x50
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c01568cf>] ? __do_fault+0x16f/0x3d0
Mar  6 22:04:33 tracker [<c0149f94>] ? unlock_page+0x24/0x30
Mar  6 22:04:33 tracker [<c01568d7>] ? __do_fault+0x177/0x3d0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c01773af>] sys_select+0x3f/0x190
Mar  6 22:04:33 tracker [<c015ae78>] ? sys_munmap+0x38/0x50
Mar  6 22:04:33 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:33 tracker =======================
Mar  6 22:04:33 tracker thttpd        S c05ffba0     0  5843      1
Mar  6 22:04:33 tracker cc46dbf0 00000056 00000286 c05ffba0 cf596aa4 cf7dd4c0 cc46dc00 c05ffba0 
Mar  6 22:04:33 tracker cc46dbf0 c0126e11 00003921 00000000 00000286 cc46dc00 00003921 00000000 
Mar  6 22:04:33 tracker cc46dc20 c043c527 cc46dc48 d2576c40 c0600590 c0600590 00003921 c0126930 
Mar  6 22:04:33 tracker Call Trace:
Mar  6 22:04:33 tracker [<c0126e11>] ? __mod_timer+0x91/0xa0
Mar  6 22:04:33 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:33 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:33 tracker [<c01765d4>] do_sys_poll+0x254/0x380
Mar  6 22:04:33 tracker [<c0177290>] ? __pollwait+0x0/0xe0
Mar  6 22:04:33 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:33 tracker [<c035ca58>] ? dev_queue_xmit+0x218/0x300
Mar  6 22:04:33 tracker [<c012318e>] ? local_bh_enable+0x2e/0x90
Mar  6 22:04:33 tracker [<c035c916>] ? dev_queue_xmit+0xd6/0x300
Mar  6 22:04:33 tracker [<c035c874>] ? dev_queue_xmit+0x34/0x300
Mar  6 22:04:33 tracker [<c04326f0>] ? ieee80211_subif_start_xmit+0x4b0/0x610
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c035ca58>] ? dev_queue_xmit+0x218/0x300
Mar  6 22:04:33 tracker [<c012318e>] ? local_bh_enable+0x2e/0x90
Mar  6 22:04:33 tracker [<c035c916>] ? dev_queue_xmit+0xd6/0x300
Mar  6 22:04:33 tracker [<c035c874>] ? dev_queue_xmit+0x34/0x300
Mar  6 22:04:33 tracker [<c0362276>] ? neigh_resolve_output+0xe6/0x290
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c0421536>] ? sta_info_get+0x56/0x60
Mar  6 22:04:33 tracker [<c0123217>] ? local_bh_enable_ip+0x27/0x60
Mar  6 22:04:33 tracker [<c0421536>] ? sta_info_get+0x56/0x60
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c0354153>] ? skb_dequeue+0x43/0x60
Mar  6 22:04:33 tracker [<c043eb8c>] ? _spin_unlock_irqrestore+0x2c/0x50
Mar  6 22:04:33 tracker [<c0354153>] ? skb_dequeue+0x43/0x60
Mar  6 22:04:33 tracker [<c041e9cd>] ? ieee80211_tasklet_handler+0x7d/0xe0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c0107bc8>] ? read_tsc+0x8/0x10
Mar  6 22:04:33 tracker [<c01366c3>] ? getnstimeofday+0x33/0xd0
Mar  6 22:04:33 tracker [<c01777e5>] sys_poll+0x35/0x80
Mar  6 22:04:33 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:33 tracker =======================
Mar  6 22:04:33 tracker cron          S c043eb8c     0  5905      1
Mar  6 22:04:33 tracker cf655f3c 00000046 cf655f14 c043eb8c cf652be4 cf5c6940 cf655f3c c0134493 
Mar  6 22:04:33 tracker 8438b06a 0000004b c056edfc 00000296 00000000 cf655f5c 00000001 cf655f5c 
Mar  6 22:04:33 tracker cf655f50 c043d275 00000001 00000000 00000001 cf655f98 c0134532 bff582d4 
Mar  6 22:04:33 tracker Call Trace:
Mar  6 22:04:33 tracker [<c043eb8c>] ? _spin_unlock_irqrestore+0x2c/0x50
Mar  6 22:04:33 tracker [<c0134493>] ? hrtimer_start+0x63/0xc0
Mar  6 22:04:33 tracker [<c043d275>] do_nanosleep+0x65/0x90
Mar  6 22:04:33 tracker [<c0134532>] hrtimer_nanosleep+0x42/0xb0
Mar  6 22:04:33 tracker [<c01340f0>] ? hrtimer_wakeup+0x0/0x20
Mar  6 22:04:33 tracker [<c01345f8>] sys_nanosleep+0x58/0x60
Mar  6 22:04:33 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:33 tracker =======================
Mar  6 22:04:33 tracker xinetd        S 00000000     0  5970      1
Mar  6 22:04:33 tracker cf661b10 00000056 00000000 00000000 cf65ec04 cf5c6700 00000000 00000000 
Mar  6 22:04:33 tracker 00000000 7b0e8646 00000032 00000001 00000000 00000006 00000020 00000000 
Mar  6 22:04:33 tracker cf661b40 c043c555 cf661bc4 cf631200 cf5c1840 cf661b34 c03823da c046c080 
Mar  6 22:04:33 tracker Call Trace:
Mar  6 22:04:33 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:33 tracker [<c03823da>] ? tcp_poll+0x1a/0x160
Mar  6 22:04:33 tracker [<c0176c27>] do_select+0x4c7/0x5c0
Mar  6 22:04:33 tracker [<c0176760>] ? do_select+0x0/0x5c0
Mar  6 22:04:33 tracker [<c0177290>] ? __pollwait+0x0/0xe0
Mar  6 22:04:33 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:33 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c0250ad7>] ? __add_entropy_words+0x1b7/0x1c0
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c03522c7>] ? sock_def_readable+0x57/0x80
Mar  6 22:04:33 tracker [<c043eb37>] ? _read_unlock+0x27/0x50
Mar  6 22:04:33 tracker [<c03522c7>] ? sock_def_readable+0x57/0x80
Mar  6 22:04:33 tracker [<c03bb7cb>] ? unix_stream_sendmsg+0x18b/0x320
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c0176f3a>] core_sys_select+0x21a/0x330
Mar  6 22:04:33 tracker [<c0176d47>] ? core_sys_select+0x27/0x330
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c043ec78>] ? _read_unlock_irq+0x28/0x50
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c01568cf>] ? __do_fault+0x16f/0x3d0
Mar  6 22:04:33 tracker [<c0149f94>] ? unlock_page+0x24/0x30
Mar  6 22:04:33 tracker [<c01568d7>] ? __do_fault+0x177/0x3d0
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c01773af>] sys_select+0x3f/0x190
Mar  6 22:04:33 tracker [<c02344d5>] ? copy_to_user+0x35/0x50
Mar  6 22:04:33 tracker [<c012a06e>] ? sys_rt_sigprocmask+0x7e/0xe0
Mar  6 22:04:33 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:33 tracker =======================
Mar  6 22:04:33 tracker bash          S cf69aa40     0  6034      1
Mar  6 22:04:33 tracker d2735f08 00000046 c06b1890 cf69aa40 cf69ac84 d3fffdc0 d2735efc 00000246 
Mar  6 22:04:33 tracker c0120a21 00000246 c05a2a00 00000001 c05a2a00 00000001 00000001 0000000e 
Mar  6 22:04:33 tracker d2735f78 c0120a4f cf5e2900 c022de5d 00000246 00000000 cf69ac18 00000000 
Mar  6 22:04:33 tracker Call Trace:
Mar  6 22:04:33 tracker [<c0120a21>] ? do_wait+0x531/0xa60
Mar  6 22:04:33 tracker [<c0120a4f>] do_wait+0x55f/0xa60
Mar  6 22:04:33 tracker [<c022de5d>] ? _atomic_dec_and_lock+0x2d/0x40
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:33 tracker [<c0120fc1>] sys_wait4+0x71/0xc0
Mar  6 22:04:33 tracker [<c0121035>] sys_waitpid+0x25/0x30
Mar  6 22:04:33 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:33 tracker =======================
Mar  6 22:04:33 tracker agetty        S 00000000     0  6036      1
Mar  6 22:04:33 tracker cf6b9ebc 00000046 00000000 00000000 cc4182a4 cf7dd940 00000000 00000000 
Mar  6 22:04:33 tracker 00000000 75514030 00000033 cf74e1b4 cf6b9ec8 00000000 cf74e000 00000000 
Mar  6 22:04:33 tracker cf6b9eec c043c555 cf74e1a4 cf6b9ed8 c043eb8c cf6b9f20 cf74e1a4 cf6b9eec 
Mar  6 22:04:33 tracker Call Trace:
Mar  6 22:04:33 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:33 tracker [<c043eb8c>] ? _spin_unlock_irqrestore+0x2c/0x50
Mar  6 22:04:33 tracker [<c013129b>] ? add_wait_queue+0x3b/0x50
Mar  6 22:04:33 tracker [<c0258660>] read_chan+0x1b0/0x5c0
Mar  6 22:04:33 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:33 tracker [<c0254f92>] tty_read+0x82/0xc0
Mar  6 22:04:33 tracker [<c02584b0>] ? read_chan+0x0/0x5c0
Mar  6 22:04:33 tracker [<c016a564>] vfs_read+0x94/0x130
Mar  6 22:04:33 tracker [<c0254f10>] ? tty_read+0x0/0xc0
Mar  6 22:04:33 tracker [<c016a9ad>] sys_read+0x3d/0x70
Mar  6 22:04:33 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:33 tracker =======================
Mar  6 22:04:33 tracker agetty        S 00000000     0  6037      1
Mar  6 22:04:33 tracker cc463ebc 00000046 00000000 00000000 cf672c24 cf646040 00000000 00000000 
Mar  6 22:04:33 tracker 00000000 7707ec61 00000033 cf7569b4 cc463ec8 00000000 cf756800 00000000 
Mar  6 22:04:33 tracker cc463eec c043c555 cf7569a4 cc463ed8 c043eb8c cc463f20 cf7569a4 cc463eec 
Mar  6 22:04:33 tracker Call Trace:
Mar  6 22:04:33 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:33 tracker [<c043eb8c>] ? _spin_unlock_irqrestore+0x2c/0x50
Mar  6 22:04:33 tracker [<c013129b>] ? add_wait_queue+0x3b/0x50
Mar  6 22:04:33 tracker [<c0258660>] read_chan+0x1b0/0x5c0
Mar  6 22:04:33 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:33 tracker [<c0254f92>] tty_read+0x82/0xc0
Mar  6 22:04:33 tracker [<c02584b0>] ? read_chan+0x0/0x5c0
Mar  6 22:04:33 tracker [<c016a564>] vfs_read+0x94/0x130
Mar  6 22:04:33 tracker [<c0254f10>] ? tty_read+0x0/0xc0
Mar  6 22:04:33 tracker [<c016a9ad>] sys_read+0x3d/0x70
Mar  6 22:04:33 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:33 tracker =======================
Mar  6 22:04:33 tracker agetty        S 00000033     0  6040      1
Mar  6 22:04:33 tracker cf675ebc 00000046 7af3f6c7 00000033 d27f4964 cf6464c0 00000000 001857f2 
Mar  6 22:04:33 tracker 00000000 7b0c4eb9 00000033 cf7511b4 cf675ec8 00000000 cf751000 00000000 
Mar  6 22:04:33 tracker cf675eec c043c555 cf7511a4 cf675ed8 c043eb8c cf675f20 cf7511a4 cf675eec 
Mar  6 22:04:33 tracker Call Trace:
Mar  6 22:04:33 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:33 tracker [<c043eb8c>] ? _spin_unlock_irqrestore+0x2c/0x50
Mar  6 22:04:33 tracker [<c013129b>] ? add_wait_queue+0x3b/0x50
Mar  6 22:04:33 tracker [<c0258660>] read_chan+0x1b0/0x5c0
Mar  6 22:04:33 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:33 tracker [<c0254f92>] tty_read+0x82/0xc0
Mar  6 22:04:33 tracker [<c02584b0>] ? read_chan+0x0/0x5c0
Mar  6 22:04:33 tracker [<c016a564>] vfs_read+0x94/0x130
Mar  6 22:04:33 tracker [<c0122d58>] ? __do_softirq+0x98/0xb0
Mar  6 22:04:33 tracker [<c0254f10>] ? tty_read+0x0/0xc0
Mar  6 22:04:33 tracker [<c016a9ad>] sys_read+0x3d/0x70
Mar  6 22:04:33 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:33 tracker =======================
Mar  6 22:04:33 tracker agetty        S 00000033     0  6042      1
Mar  6 22:04:33 tracker cf65debc 00000046 79a0e49d 00000033 cc4542e4 cf6c2dc0 00000000 00a1f39e 
Mar  6 22:04:33 tracker 00000000 7a42d83b 00000033 cf7471b4 cf65dec8 00000000 cf747000 00000000 
Mar  6 22:04:33 tracker cf65deec c043c555 cf7471a4 cf65ded8 c043eb8c cf65df20 cf7471a4 cf65deec 
Mar  6 22:04:33 tracker Call Trace:
Mar  6 22:04:33 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:33 tracker [<c043eb8c>] ? _spin_unlock_irqrestore+0x2c/0x50
Mar  6 22:04:33 tracker [<c013129b>] ? add_wait_queue+0x3b/0x50
Mar  6 22:04:33 tracker [<c0258660>] read_chan+0x1b0/0x5c0
Mar  6 22:04:33 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:33 tracker [<c0254f92>] tty_read+0x82/0xc0
Mar  6 22:04:33 tracker [<c02584b0>] ? read_chan+0x0/0x5c0
Mar  6 22:04:33 tracker [<c016a564>] vfs_read+0x94/0x130
Mar  6 22:04:33 tracker [<c0254f10>] ? tty_read+0x0/0xc0
Mar  6 22:04:33 tracker [<c016a9ad>] sys_read+0x3d/0x70
Mar  6 22:04:33 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:33 tracker =======================
Mar  6 22:04:33 tracker agetty        S 00000000     0  6044      1
Mar  6 22:04:33 tracker cc469ebc 00000046 00000000 00000000 cf696c64 cf5c6280 00000000 00000000 
Mar  6 22:04:33 tracker 00000000 7b79ddb1 00000033 cf7819b4 cc469ec8 00000000 cf781800 00000000 
Mar  6 22:04:33 tracker cc469eec c043c555 cf7819a4 cc469ed8 c043eb8c cc469f20 cf7819a4 cc469eec 
Mar  6 22:04:33 tracker Call Trace:
Mar  6 22:04:33 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:33 tracker [<c043eb8c>] ? _spin_unlock_irqrestore+0x2c/0x50
Mar  6 22:04:33 tracker [<c013129b>] ? add_wait_queue+0x3b/0x50
Mar  6 22:04:33 tracker [<c0258660>] read_chan+0x1b0/0x5c0
Mar  6 22:04:33 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:33 tracker [<c0254f92>] tty_read+0x82/0xc0
Mar  6 22:04:33 tracker [<c02584b0>] ? read_chan+0x0/0x5c0
Mar  6 22:04:33 tracker [<c016a564>] vfs_read+0x94/0x130
Mar  6 22:04:33 tracker [<c0254f10>] ? tty_read+0x0/0xc0
Mar  6 22:04:33 tracker [<c016a9ad>] sys_read+0x3d/0x70
Mar  6 22:04:33 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:33 tracker =======================
Mar  6 22:04:33 tracker spamd         S 00000000     0  6070   4747
Mar  6 22:04:33 tracker cf5d9b10 00000056 00000000 00000000 cf5d6b24 d3da7940 00000000 00000000 
Mar  6 22:04:33 tracker 00000000 3d4e91ac 0000004b 00000000 00000286 cf5d9b20 0001295b 00000304 
Mar  6 22:04:33 tracker cf5d9b40 c043c527 cf5d9bc4 cf5ccbc0 c06005e8 cf627b20 0001295b c0126930 
Mar  6 22:04:33 tracker Call Trace:
Mar  6 22:04:33 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:33 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:33 tracker [<c0176c27>] do_select+0x4c7/0x5c0
Mar  6 22:04:33 tracker [<c0176760>] ? do_select+0x0/0x5c0
Mar  6 22:04:33 tracker [<c0421536>] ? sta_info_get+0x56/0x60
Mar  6 22:04:33 tracker [<c0177290>] ? __pollwait+0x0/0xe0
Mar  6 22:04:33 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c01163fe>] ? __enqueue_entity+0x8e/0xb0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c0176f3a>] core_sys_select+0x21a/0x330
Mar  6 22:04:33 tracker [<c0176d47>] ? core_sys_select+0x27/0x330
Mar  6 22:04:33 tracker [<c0169d0c>] ? do_sync_read+0xcc/0x110
Mar  6 22:04:33 tracker [<c0130fe0>] ? autoremove_wake_function+0x0/0x50
Mar  6 22:04:33 tracker [<c0199d8e>] ? dnotify_parent+0x6e/0x80
Mar  6 22:04:33 tracker [<c0177444>] sys_select+0xd4/0x190
Mar  6 22:04:33 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:33 tracker =======================
Mar  6 22:04:33 tracker spamd         S 00000000     0  6090   4747
Mar  6 22:04:33 tracker cf627b10 00000056 00000000 00000000 cf6e8ce4 cf6c2940 00000000 00000000 
Mar  6 22:04:33 tracker 00000000 3997c7a7 0000004b 00000000 00000286 cf627b20 0001294b 00000304 
Mar  6 22:04:33 tracker cf627b40 c043c527 cf627bc4 cc449d40 cf5d9b20 c057c980 0001294b c0126930 
Mar  6 22:04:33 tracker Call Trace:
Mar  6 22:04:33 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:33 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:33 tracker [<c0176c27>] do_select+0x4c7/0x5c0
Mar  6 22:04:33 tracker [<c0176760>] ? do_select+0x0/0x5c0
Mar  6 22:04:33 tracker [<c0177290>] ? __pollwait+0x0/0xe0
Mar  6 22:04:33 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:33 tracker [<d482ff67>] ? uhci_urb_enqueue+0x47/0x7c0 [uhci_hcd]
Mar  6 22:04:33 tracker [<c043eb8c>] ? _spin_unlock_irqrestore+0x2c/0x50
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c016276d>] ? dma_pool_alloc+0x19d/0x1c0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<d482ff67>] ? uhci_urb_enqueue+0x47/0x7c0 [uhci_hcd]
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c0176f3a>] core_sys_select+0x21a/0x330
Mar  6 22:04:33 tracker [<c0176d47>] ? core_sys_select+0x27/0x330
Mar  6 22:04:33 tracker [<c0169d0c>] ? do_sync_read+0xcc/0x110
Mar  6 22:04:33 tracker [<c0130fe0>] ? autoremove_wake_function+0x0/0x50
Mar  6 22:04:33 tracker [<c0199d8e>] ? dnotify_parent+0x6e/0x80
Mar  6 22:04:33 tracker [<c0177444>] sys_select+0xd4/0x190
Mar  6 22:04:33 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:33 tracker =======================
Mar  6 22:04:33 tracker syslog-ng     R running      0  6204      1
Mar  6 22:04:33 tracker cf793bf0 00000056 00000000 00000000 cf59c4a4 d252f700 00000000 00000000 
Mar  6 22:04:33 tracker 00000000 e1ac1d82 00000057 00000000 00000286 cf793c00 0004c629 00000000 
Mar  6 22:04:33 tracker cf793c20 c043c527 cf793c48 d3ff6c20 c0600660 c0600660 0004c629 c0126930 
Mar  6 22:04:33 tracker Call Trace:
Mar  6 22:04:33 tracker [<c043c527>] schedule_timeout+0x47/0xc0
Mar  6 22:04:33 tracker [<c0126930>] ? process_timeout+0x0/0x10
Mar  6 22:04:33 tracker [<c01765d4>] do_sys_poll+0x254/0x380
Mar  6 22:04:33 tracker [<c0177290>] ? __pollwait+0x0/0xe0
Mar  6 22:04:33 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:33 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:33 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:33 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:33 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:33 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c043cce8>] ? mutex_unlock+0x8/0x10
Mar  6 22:04:33 tracker [<c043cce8>] ? mutex_unlock+0x8/0x10
Mar  6 22:04:33 tracker [<c03bac32>] ? unix_stream_recvmsg+0x342/0x4d0
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c022de5d>] ? _atomic_dec_and_lock+0x2d/0x40
Mar  6 22:04:33 tracker [<c043ea97>] ? _spin_unlock+0x27/0x50
Mar  6 22:04:33 tracker [<c022de5d>] ? _atomic_dec_and_lock+0x2d/0x40
Mar  6 22:04:33 tracker [<c017fe26>] ? mntput_no_expire+0x16/0x60
Mar  6 22:04:33 tracker [<c016aff6>] ? __fput+0x146/0x190
Mar  6 22:04:33 tracker [<c0107bc8>] ? read_tsc+0x8/0x10
Mar  6 22:04:33 tracker [<c01366c3>] ? getnstimeofday+0x33/0xd0
Mar  6 22:04:33 tracker [<c01777e5>] sys_poll+0x35/0x80
Mar  6 22:04:33 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:33 tracker =======================
Mar  6 22:04:33 tracker atd           S 00000000     0  6260      1
Mar  6 22:04:33 tracker cf56ff3c 00000046 00000000 00000000 d258c4e4 d252f940 00000000 00000000 
Mar  6 22:04:33 tracker 00000000 bdad70b2 0000004a 00000296 00000000 cf56ff5c 00000001 cf56ff5c 
Mar  6 22:04:33 tracker cf56ff50 c043d275 00000001 00000000 00000001 cf56ff98 c0134532 bfecd264 
Mar  6 22:04:33 tracker Call Trace:
Mar  6 22:04:33 tracker [<c043d275>] do_nanosleep+0x65/0x90
Mar  6 22:04:33 tracker [<c0134532>] hrtimer_nanosleep+0x42/0xb0
Mar  6 22:04:33 tracker [<c01340f0>] ? hrtimer_wakeup+0x0/0x20
Mar  6 22:04:33 tracker [<c01345f8>] sys_nanosleep+0x58/0x60
Mar  6 22:04:33 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:33 tracker =======================
Mar  6 22:04:33 tracker smartd        D cf609ab0     0  6283   6034
Mar  6 22:04:33 tracker cf609ac8 00000046 000004e2 cf609ab0 cf5e2b44 cf5c6040 00000002 00000d4d 
Mar  6 22:04:33 tracker 00000000 00000b39 cf609ab8 c013b61d cf609ad0 00000002 7fffffff cf609b4c 
Mar  6 22:04:33 tracker cf609af8 c043c555 cf609aec 00000046 c043bd7e 00000046 cf609b50 7fffffff 
Mar  6 22:04:33 tracker Call Trace:
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c043c555>] schedule_timeout+0x75/0xc0
Mar  6 22:04:33 tracker [<c043bd7e>] ? wait_for_common+0x8e/0x150
Mar  6 22:04:33 tracker [<c043bd85>] wait_for_common+0x95/0x150
Mar  6 22:04:33 tracker [<c0117820>] ? default_wake_function+0x0/0x10
Mar  6 22:04:33 tracker [<c043bed2>] wait_for_completion+0x12/0x20
Mar  6 22:04:33 tracker [<c0287c1a>] ide_do_drive_cmd+0xda/0x110
Mar  6 22:04:33 tracker [<c028bdf3>] ide_raw_taskfile+0xa3/0xb0
Mar  6 22:04:33 tracker [<c02264e0>] ? blk_end_sync_rq+0x0/0x30
Mar  6 22:04:33 tracker [<c028c831>] ide_cmd_ioctl+0xf1/0x260
Mar  6 22:04:33 tracker [<c043eb8c>] ? _spin_unlock_irqrestore+0x2c/0x50
Mar  6 22:04:33 tracker [<c0118387>] ? hrtick_set+0xa7/0x100
Mar  6 22:04:33 tracker [<c043c194>] ? schedule+0x2b4/0x450
Mar  6 22:04:33 tracker [<c043c3f9>] ? preempt_schedule+0x59/0x80
Mar  6 22:04:33 tracker [<c043eb4c>] ? _read_unlock+0x3c/0x50
Mar  6 22:04:33 tracker [<c03522c7>] ? sock_def_readable+0x57/0x80
Mar  6 22:04:33 tracker [<c0286732>] generic_ide_ioctl+0x322/0x410
Mar  6 22:04:33 tracker [<c034e664>] ? sock_sendmsg+0xc4/0xf0
Mar  6 22:04:33 tracker [<c0290da1>] idedisk_ioctl+0x41/0x120
Mar  6 22:04:33 tracker [<c0227280>] blkdev_driver_ioctl+0x60/0x70
Mar  6 22:04:33 tracker [<c022755e>] blkdev_ioctl+0x2ce/0x860
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c043eb8c>] ? _spin_unlock_irqrestore+0x2c/0x50
Mar  6 22:04:33 tracker [<c013bdf5>] ? __lock_acquire+0xb5/0x6f0
Mar  6 22:04:33 tracker [<c013b61d>] ? put_lock_stats+0xd/0x30
Mar  6 22:04:33 tracker [<c013b69d>] ? lock_release_holdtime+0x5d/0x80
Mar  6 22:04:33 tracker [<c022de5d>] ? _atomic_dec_and_lock+0x2d/0x40
Mar  6 22:04:33 tracker [<c043ea97>] ? _spin_unlock+0x27/0x50
Mar  6 22:04:33 tracker [<c018f58b>] block_ioctl+0x1b/0x20
Mar  6 22:04:33 tracker [<c018f570>] ? block_ioctl+0x0/0x20
Mar  6 22:04:33 tracker [<c0175a28>] vfs_ioctl+0x28/0x80
Mar  6 22:04:33 tracker [<c0175ad7>] do_vfs_ioctl+0x57/0x2d0
Mar  6 22:04:33 tracker [<c016b248>] ? fput+0x18/0x20
Mar  6 22:04:33 tracker [<c01682c7>] ? filp_close+0x47/0x70
Mar  6 22:04:33 tracker [<c0175d89>] sys_ioctl+0x39/0x60
Mar  6 22:04:33 tracker [<c0102f9e>] sysenter_past_esp+0x5f/0x91
Mar  6 22:04:33 tracker =======================
Mar  6 22:04:33 tracker Sched Debug Version: v0.07, 2.6.25-rc3 #13
Mar  6 22:04:33 tracker now at 355241.897554 msecs
Mar  6 22:04:33 tracker .sysctl_sched_latency                    : 20.000000
Mar  6 22:04:33 tracker .sysctl_sched_min_granularity            : 4.000000
Mar  6 22:04:33 tracker .sysctl_sched_wakeup_granularity         : 10.000000
Mar  6 22:04:33 tracker .sysctl_sched_batch_wakeup_granularity   : 10.000000
Mar  6 22:04:33 tracker .sysctl_sched_child_runs_first           : 0.000001
Mar  6 22:04:33 tracker .sysctl_sched_features                   : 39
Mar  6 22:04:33 tracker 
Mar  6 22:04:33 tracker cpu#0, 300.696 MHz
Mar  6 22:04:33 tracker .nr_running                    : 2
Mar  6 22:04:33 tracker .load                          : 2048
Mar  6 22:04:33 tracker .nr_switches                   : 63184
Mar  6 22:04:33 tracker .nr_load_updates               : 88785
Mar  6 22:04:33 tracker .nr_uninterruptible            : 1
Mar  6 22:04:33 tracker .jiffies                       : 13785
Mar  6 22:04:33 tracker .next_balance                  : 0.000000
Mar  6 22:04:33 tracker .curr->pid                     : 0
Mar  6 22:04:33 tracker .clock                         : 382024.855187
Mar  6 22:04:33 tracker .idle_clock                    : 127078.456740
Mar  6 22:04:33 tracker .prev_clock_raw                : 389663.644811
Mar  6 22:04:33 tracker .clock_warps                   : 0
Mar  6 22:04:33 tracker .clock_overflows               : 128921
Mar  6 22:04:33 tracker .clock_underflows              : 36287
Mar  6 22:04:33 tracker .clock_deep_idle_events        : 1
Mar  6 22:04:33 tracker .clock_max_delta               : 4.000250
Mar  6 22:04:33 tracker .cpu_load[0]                   : 0
Mar  6 22:04:33 tracker .cpu_load[1]                   : 0
Mar  6 22:04:33 tracker .cpu_load[2]                   : 0
Mar  6 22:04:33 tracker .cpu_load[3]                   : 0
Mar  6 22:04:33 tracker .cpu_load[4]                   : 2
Mar  6 22:04:33 tracker 
Mar  6 22:04:33 tracker cfs_rq
Mar  6 22:04:33 tracker .exec_clock                    : 223146.738779
Mar  6 22:04:33 tracker .MIN_vruntime                  : 109054.089901
Mar  6 22:04:33 tracker .min_vruntime                  : 109054.089901
Mar  6 22:04:33 tracker .max_vruntime                  : 109054.089901
Mar  6 22:04:33 tracker .spread                        : 0.000000
Mar  6 22:04:33 tracker .spread0                       : 0.000000
Mar  6 22:04:33 tracker .nr_running                    : 1
Mar  6 22:04:33 tracker .load                          : 2048
Mar  6 22:04:33 tracker .bkl_count                     : 782
Mar  6 22:04:33 tracker .nr_spread_over                : 0
Mar  6 22:04:33 tracker 
Mar  6 22:04:33 tracker cfs_rq
Mar  6 22:04:33 tracker .exec_clock                    : 19.082890
Mar  6 22:04:33 tracker .MIN_vruntime                  : 0.000001
Mar  6 22:04:33 tracker .min_vruntime                  : 109054.089901
Mar  6 22:04:33 tracker .max_vruntime                  : 0.000001
Mar  6 22:04:33 tracker .spread                        : 0.000000
Mar  6 22:04:33 tracker .spread0                       : 0.000000
Mar  6 22:04:33 tracker .nr_running                    : 0
Mar  6 22:04:33 tracker .load                          : 0
Mar  6 22:04:33 tracker .bkl_count                     : 782
Mar  6 22:04:33 tracker .nr_spread_over                : 0
Mar  6 22:04:33 tracker 
Mar  6 22:04:33 tracker cfs_rq
Mar  6 22:04:33 tracker .exec_clock                    : 17486.084550
Mar  6 22:04:33 tracker .MIN_vruntime                  : 0.000001
Mar  6 22:04:33 tracker .min_vruntime                  : 109054.089901
Mar  6 22:04:33 tracker .max_vruntime                  : 0.000001
Mar  6 22:04:33 tracker .spread                        : 0.000000
Mar  6 22:04:33 tracker .spread0                       : 0.000000
Mar  6 22:04:33 tracker .nr_running                    : 0
Mar  6 22:04:33 tracker .load                          : 0
Mar  6 22:04:33 tracker .bkl_count                     : 782
Mar  6 22:04:33 tracker .nr_spread_over                : 985
Mar  6 22:04:33 tracker 
Mar  6 22:04:33 tracker cfs_rq
Mar  6 22:04:33 tracker .exec_clock                    : 512.113015
Mar  6 22:04:33 tracker .MIN_vruntime                  : 0.000001
Mar  6 22:04:33 tracker .min_vruntime                  : 109054.089901
Mar  6 22:04:33 tracker .max_vruntime                  : 0.000001
Mar  6 22:04:33 tracker .spread                        : 0.000000
Mar  6 22:04:33 tracker .spread0                       : 0.000000
Mar  6 22:04:33 tracker .nr_running                    : 0
Mar  6 22:04:33 tracker .load                          : 0
Mar  6 22:04:33 tracker .bkl_count                     : 782
Mar  6 22:04:33 tracker .nr_spread_over                : 0
Mar  6 22:04:33 tracker 
Mar  6 22:04:33 tracker cfs_rq
Mar  6 22:04:33 tracker .exec_clock                    : 8.019430
Mar  6 22:04:33 tracker .MIN_vruntime                  : 0.000001
Mar  6 22:04:33 tracker .min_vruntime                  : 109054.089901
Mar  6 22:04:33 tracker .max_vruntime                  : 0.000001
Mar  6 22:04:33 tracker .spread                        : 0.000000
Mar  6 22:04:33 tracker .spread0                       : 0.000000
Mar  6 22:04:33 tracker .nr_running                    : 0
Mar  6 22:04:33 tracker .load                          : 0
Mar  6 22:04:33 tracker .bkl_count                     : 782
Mar  6 22:04:33 tracker .nr_spread_over                : 8
Mar  6 22:04:33 tracker 
Mar  6 22:04:33 tracker cfs_rq
Mar  6 22:04:33 tracker .exec_clock                    : 351.032391
Mar  6 22:04:33 tracker .MIN_vruntime                  : 0.000001
Mar  6 22:04:33 tracker .min_vruntime                  : 109054.089901
Mar  6 22:04:33 tracker .max_vruntime                  : 0.000001
Mar  6 22:04:33 tracker .spread                        : 0.000000
Mar  6 22:04:33 tracker .spread0                       : 0.000000
Mar  6 22:04:33 tracker .nr_running                    : 0
Mar  6 22:04:33 tracker .load                          : 0
Mar  6 22:04:33 tracker .bkl_count                     : 782
Mar  6 22:04:33 tracker .nr_spread_over                : 0
Mar  6 22:04:33 tracker 
Mar  6 22:04:33 tracker cfs_rq
Mar  6 22:04:33 tracker .exec_clock                    : 19.561637
Mar  6 22:04:33 tracker .MIN_vruntime                  : 0.000001
Mar  6 22:04:33 tracker .min_vruntime                  : 109054.089901
Mar  6 22:04:33 tracker .max_vruntime                  : 0.000001
Mar  6 22:04:33 tracker .spread                        : 0.000000
Mar  6 22:04:33 tracker .spread0                       : 0.000000
Mar  6 22:04:33 tracker .nr_running                    : 0
Mar  6 22:04:33 tracker .load                          : 0
Mar  6 22:04:33 tracker .bkl_count                     : 782
Mar  6 22:04:33 tracker .nr_spread_over                : 0
Mar  6 22:04:33 tracker 
Mar  6 22:04:33 tracker cfs_rq
Mar  6 22:04:33 tracker .exec_clock                    : 431.571200
Mar  6 22:04:33 tracker .MIN_vruntime                  : 0.000001
Mar  6 22:04:33 tracker .min_vruntime                  : 109054.089901
Mar  6 22:04:33 tracker .max_vruntime                  : 0.000001
Mar  6 22:04:33 tracker .spread                        : 0.000000
Mar  6 22:04:33 tracker .spread0                       : 0.000000
Mar  6 22:04:33 tracker .nr_running                    : 0
Mar  6 22:04:33 tracker .load                          : 0
Mar  6 22:04:33 tracker .bkl_count                     : 782
Mar  6 22:04:33 tracker .nr_spread_over                : 0
Mar  6 22:04:33 tracker 
Mar  6 22:04:33 tracker cfs_rq
Mar  6 22:04:33 tracker .exec_clock                    : 123.630002
Mar  6 22:04:33 tracker .MIN_vruntime                  : 0.000001
Mar  6 22:04:33 tracker .min_vruntime                  : 109054.089901
Mar  6 22:04:33 tracker .max_vruntime                  : 0.000001
Mar  6 22:04:33 tracker .spread                        : 0.000000
Mar  6 22:04:33 tracker .spread0                       : 0.000000
Mar  6 22:04:33 tracker .nr_running                    : 0
Mar  6 22:04:33 tracker .load                          : 0
Mar  6 22:04:33 tracker .bkl_count                     : 782
Mar  6 22:04:33 tracker .nr_spread_over                : 0
Mar  6 22:04:33 tracker 
Mar  6 22:04:33 tracker cfs_rq
Mar  6 22:04:33 tracker .exec_clock                    : 200909.747265
Mar  6 22:04:33 tracker .MIN_vruntime                  : 514493.412512
Mar  6 22:04:33 tracker .min_vruntime                  : 109054.089901
Mar  6 22:04:33 tracker .max_vruntime                  : 514493.469756
Mar  6 22:04:33 tracker .spread                        : 0.057244
Mar  6 22:04:33 tracker .spread0                       : 0.000000
Mar  6 22:04:33 tracker .nr_running                    : 2
Mar  6 22:04:33 tracker .load                          : 4145
Mar  6 22:04:33 tracker .bkl_count                     : 782
Mar  6 22:04:33 tracker .nr_spread_over                : 203
Mar  6 22:04:33 tracker 
Mar  6 22:04:33 tracker runnable tasks:
Mar  6 22:04:33 tracker task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
Mar  6 22:04:33 tracker ----------------------------------------------------------------------------------------------------------
Mar  6 22:04:33 tracker events/0     5    514493.469756       841   115    514493.469756        82.861698    380462.406210
Mar  6 22:04:33 tracker syslog-ng  6204    514493.412512      1071   120    514493.412512     15253.315887     46112.469835
Mar  6 22:04:33 tracker 
Mar  6 22:04:33 tracker Clocksource tsc unstable (delta = 64250611 ns)
Mar  6 22:04:33 tracker Time: jiffies clocksource has been installed.



