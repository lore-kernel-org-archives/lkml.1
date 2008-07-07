Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbYGGS6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbYGGS6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbYGGS6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:58:14 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:33852 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884AbYGGS6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:58:12 -0400
Date: Mon, 7 Jul 2008 20:53:39 +0200
From: Pavel Machek <pavel@suse.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: unregister_netdevice: waiting for ppp0 to become free. Usage count
	= 1
Message-ID: <20080707185339.GA1589@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Is `subject` message normal? It made tasks unfreezeable and s2ram
failed :-(.

Jul  7 19:46:10 amd pppd[2843]: Terminating on signal 2
Jul  7 19:46:10 amd pppd[2843]: Connect time 22.4 minutes.
Jul  7 19:46:10 amd pppd[2843]: Sent 710742 bytes, received 582690
bytes.
Jul  7 19:46:11 amd pppd[2843]: Connection terminated.
Jul  7 19:46:21 amd kernel: unregister_netdevice: waiting for ppp0 to
become free. Usage count = 1
Jul  7 19:46:52 amd last message repeated 3 times
Jul  7 19:47:43 amd last message repeated 5 times
Jul  7 19:47:48 amd su[3438]: unknown configuration item `FAIL_DELAY'
...
Jul  7 19:47:50 amd su[3441]: pam_unix(su:session): session opened for
user root by (uid=0)
Jul  7 19:47:53 amd kernel: Syncing filesystems ... done.
Jul  7 19:48:13 amd kernel: Freezing user space processes
... <0>unregister_netdevice: waiting for ppp0 to become free. Usage
count = 1
Jul  7 19:48:13 amd kernel: unregister_netdevice: waiting for ppp0 to
become free. Usage count = 1
Jul  7 19:48:13 amd kernel:
Jul  7 19:48:13 amd kernel: Freezing of tasks failed after 20.00
seconds (2 tasks refusing to freeze):Jul  7 19:48:13 amd kernel:
task                PC stack   pid father
Jul  7 19:48:13 amd kernel: init          D bfdd9e28     0     1
0
Jul  7 19:48:13 amd kernel:        f7c6deac 00000082 f7c6de6c bfdd9e28
c0285970 f7c6de54 00000000 d95ee258
Jul  7 19:48:13 amd kernel:        00000c85 f7c6bb1c f7c6b8f0 f7c6bb1c
c2000c80 f7c6c000 f7600e08 00000000
Jul  7 19:48:13 amd kernel:        c098c080 c098c080 00000001 c098c080
c0274387 f7303000 0006ebdd 00000000
Jul  7 19:48:13 amd kernel: Call Trace:
Jul  7 19:48:13 amd kernel:  [<c0285970>] core_sys_select+0x1c0/0x2d0
Jul  7 19:48:13 amd kernel:  [<c0274387>] poison_obj+0x27/0x50
Jul  7 19:48:13 amd kernel:  [<c0282fe9>] __user_walk_fd+0x49/0x60
Jul  7 19:48:13 amd kernel:  [<c0274602>]
cache_free_debugcheck+0xe2/0x250
Jul  7 19:48:13 amd kernel:  [<c024efca>] refrigerator+0xba/0xe0
Jul  7 19:48:13 amd kernel:  [<c02364c5>]
get_signal_to_deliver+0x3e5/0x470
Jul  7 19:48:13 amd kernel:  [<c0203783>] do_notify_resume+0x93/0x6f0
Jul  7 19:48:13 amd kernel:  [<c0286072>] sys_select+0x182/0x1b0
Jul  7 19:48:13 amd kernel:  [<c02042aa>] work_notifysig+0x13/0x19
Jul  7 19:48:13 amd kernel:  [<c0278c03>] do_sync_write+0x13/0x120
Jul  7 19:48:13 amd kernel:  =======================
....

How do I locate the processes  that failed to freeze? Something like
2000 lines of dump follows. sendmail looks like one of them:

Jul  7 19:48:13 amd kernel: sendmail      D f6c3bcf8     0  3419
3418
Jul  7 19:48:13 amd kernel:        f6c3bd0c 00000086 00000002 f6c3bcf8
f6c3bcf0 00000000 00000001 00000000
Jul  7 19:48:13 amd kernel:        00000000 f75762dc f75760b0 f75762dc
c2009c80 f6c3a000 d74e03b8 f71586c8
Jul  7 19:48:13 amd kernel:        c098c080 c098c080 00000002 c098c080
001b5b60 00000000 f71586c8 c092094c
Jul  7 19:48:13 amd kernel: Call Trace:
Jul  7 19:48:13 amd kernel:  [<c07491c7>]
__mutex_lock_slowpath+0x97/0x240
Jul  7 19:48:13 amd kernel:  [<c06634e0>] rtnetlink_rcv+0x0/0x20
Jul  7 19:48:13 amd kernel:  [<c065ba91>] netdev_run_todo+0x11/0x250
Jul  7 19:48:13 amd kernel:  [<c0663500>] rtnetlink_rcv_msg+0x0/0x210
Jul  7 19:48:13 amd kernel:  [<c06634e0>] rtnetlink_rcv+0x0/0x20
Jul  7 19:48:13 amd kernel:  [<c0674060>] netlink_rcv_skb+0x70/0xa0
Jul  7 19:48:13 amd kernel:  [<c06634e0>] rtnetlink_rcv+0x0/0x20
Jul  7 19:48:13 amd kernel:  [<c0673e25>] netlink_unicast+0x1e5/0x210
Jul  7 19:48:13 amd kernel:  [<c0674758>] netlink_sendmsg+0x1e8/0x2d0
Jul  7 19:48:13 amd kernel:  [<c064e57e>] sock_sendmsg+0xce/0x100
Jul  7 19:48:13 amd kernel:  [<c023db10>]
autoremove_wake_function+0x0/0x50
Jul  7 19:48:13 amd kernel:  [<c0221418>] __wake_up+0x38/0x50
Jul  7 19:48:13 amd kernel:  [<c06735e5>] netlink_insert+0xc5/0x140
Jul  7 19:48:13 amd kernel:  [<c064e953>] sys_sendto+0x133/0x180
Jul  7 19:48:13 amd kernel:  [<c064f0cf>] move_addr_to_user+0x5f/0x70
Jul  7 19:48:13 amd kernel:  [<c064f63f>] sys_getsockname+0xbf/0xd0
Jul  7 19:48:13 amd kernel:  [<c028a3cb>] d_alloc+0x1b/0x190
Jul  7 19:48:13 amd kernel:  [<c02758fb>] kmem_cache_alloc+0x5b/0xc0
Jul  7 19:48:13 amd kernel:  [<c028a3cb>] d_alloc+0x1b/0x190
Jul  7 19:48:13 amd kernel:  [<c02a2578>]
inotify_d_instantiate+0x18/0x80
Jul  7 19:48:13 amd kernel:  [<c028a4b2>] d_alloc+0x102/0x190
Jul  7 19:48:13 amd kernel:  [<c028a39b>] d_instantiate+0x3b/0x50
Jul  7 19:48:13 amd kernel:  [<c064e230>] sock_attach_fd+0x80/0xc0
Jul  7 19:48:13 amd kernel:  [<c064f9c8>] sys_socketcall+0x198/0x280
Jul  7 19:48:13 amd kernel:  [<c020420e>] syscall_call+0x7/0xb
Jul  7 19:48:13 amd kernel:  [<c0740000>]
ieee80211softmac_auth_resp+0x250/0x440
Jul  7 19:48:13 amd kernel:  =======================


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
