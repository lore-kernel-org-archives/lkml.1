Return-Path: <linux-kernel-owner+w=401wt.eu-S1758797AbZCMWPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbZCMWPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 18:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbZCMWPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 18:15:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57608 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755184AbZCMWPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 18:15:05 -0400
Date: Fri, 13 Mar 2009 15:10:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       e1000-devel@lists.sourceforge.net
Subject: Re: [stable] Li-nux 2.6.27.19  2.6.28.7
Message-Id: <20090313151051.a9198384.akpm@linux-foundation.org>
In-Reply-To: <20090220225448.GA14122@kroah.com>
References: <20090220225448.GA14122@kroah.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I fired up this kernel up on my FC8 laptop and I see
http://userweb.kernel.org/~akpm/p3130212.jpg

On the next two boot attempts, the kernel came up OK.



Also, during boot the e1000e driver has conniptions:

------------[ cut here ]------------
WARNING: at drivers/net/e1000e/ich8lan.c:408 e1000_acquire_swflag_ich8lan+0x51/0xf2()
e1000e mutex contention. Owned by pid 10
Modules linked in:
Pid: 9, comm: events/0 Not tainted 2.6.28.7 #1
Call Trace:
 [<ffffffff8103a810>] warn_slowpath+0xae/0xcd
 [<ffffffff8104394b>] ? lock_timer_base+0x26/0x4a
 [<ffffffff8104394b>] ? lock_timer_base+0x26/0x4a
 [<ffffffff8105d63f>] ? __lock_acquire+0x702/0x760
 [<ffffffff8105bfc6>] ? mark_held_locks+0x50/0x6d
 [<ffffffff812dd950>] ? mutex_trylock+0x104/0x118
 [<ffffffff8105c170>] ? trace_hardirqs_on_caller+0xf8/0x123
 [<ffffffff8105c1a8>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffff811ed838>] e1000_acquire_swflag_ich8lan+0x51/0xf2
 [<ffffffff811f2fe9>] e1000e_read_kmrn_reg+0x1b/0x69
 [<ffffffff811f63c5>] ? e1000e_downshift_workaround+0x0/0x12
 [<ffffffff811ed1e9>] e1000e_gig_downshift_workaround_ich8lan+0x2c/0x71
 [<ffffffff811f63d5>] e1000e_downshift_workaround+0x10/0x12
 [<ffffffff8104a6ed>] run_workqueue+0xf5/0x1fd
 [<ffffffff8104a697>] ? run_workqueue+0x9f/0x1fd
 [<ffffffff8104a8f6>] ? worker_thread+0x0/0xe8
 [<ffffffff8104a9d1>] worker_thread+0xdb/0xe8
 [<ffffffff8104de14>] ? autoremove_wake_function+0x0/0x36
 [<ffffffff8104a8f6>] ? worker_thread+0x0/0xe8
 [<ffffffff8104db1a>] kthread+0x44/0x6b
 [<ffffffff8100cf59>] child_rip+0xa/0x11
 [<ffffffff8100c474>] ? restore_args+0x0/0x30
 [<ffffffff8104dad6>] ? kthread+0x0/0x6b
 [<ffffffff8100cf4f>] ? child_rip+0x0/0x11
---[ end trace 09c88554f9900e8b ]---

Config: http://userweb.kernel.org/~akpm/config-t61p.txt
dmesg: http://userweb.kernel.org/~akpm/dmesg-t61p.txt
