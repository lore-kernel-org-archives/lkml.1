Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891Ab0AMGXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891Ab0AMGXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 01:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086Ab0AMGXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 01:23:15 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:54837 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab0AMGXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 01:23:14 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.33-rc3-mmotm0106 - BUG: MAX_LOCKDEP_KEYS too low!
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1263363729_4458P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 13 Jan 2010 01:22:09 -0500
Message-ID: <30283.1263363729@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=steiner.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4B4D6692.0036,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1263363729_4458P
Content-Type: text/plain; charset=us-ascii

Seen in my dmesg output - I wasn't even home at the time, so my
laptop was basically idle.

[ 7777.019267] dell-wmi: Received unknown WMI event (0x11)
[ 8190.620401] BUG: MAX_LOCKDEP_KEYS too low!
[ 8190.620406] turning off the locking correctness validator.
[ 8190.620410] Pid: 4266, comm: firefox-bin Not tainted 2.6.33-rc3-mmotm0106 #8
[ 8190.620412] Call Trace:
[ 8190.620421]  [<ffffffff81064253>] register_lock_class+0x152/0x31f
[ 8190.620425]  [<ffffffff81065c9e>] __lock_acquire+0xbd/0xcfa
[ 8190.620430]  [<ffffffff810d41c7>] ? spin_lock+0x9/0xb
[ 8190.620434]  [<ffffffff810d40ef>] ? trace_kmalloc+0x3d/0x8c
[ 8190.620439]  [<ffffffff811bcebb>] ? kzalloc+0xf/0x11
[ 8190.620444]  [<ffffffff812105b3>] ? __percpu_counter_add+0x57/0xb4
[ 8190.620447]  [<ffffffff810669a6>] lock_acquire+0xcb/0xe8
[ 8190.620451]  [<ffffffff812105b3>] ? __percpu_counter_add+0x57/0xb4
[ 8190.620455]  [<ffffffff81065509>] ? debug_check_no_locks_freed+0x11a/0x12a
[ 8190.620460]  [<ffffffff81564ba9>] _raw_spin_lock+0x36/0x45
[ 8190.620464]  [<ffffffff812105b3>] ? __percpu_counter_add+0x57/0xb4
[ 8190.620468]  [<ffffffff812105b3>] __percpu_counter_add+0x57/0xb4
[ 8190.620473]  [<ffffffff814872d4>] tcp_v4_init_sock+0x18e/0x199
[ 8190.620477]  [<ffffffff81496cd7>] inet_create+0x31f/0x34a
[ 8190.620482]  [<ffffffff8142f9ba>] __sock_create+0x15d/0x1e5
[ 8190.620485]  [<ffffffff8142f954>] ? __sock_create+0xf7/0x1e5
[ 8190.620489]  [<ffffffff8142fa8e>] sock_create+0x2b/0x2d
[ 8190.620492]  [<ffffffff8142fc8b>] sys_socket+0x26/0x57
[ 8190.620497]  [<ffffffff810023ab>] system_call_fastpath+0x16/0x1b
[ 8438.412037] dell-wmi: Received unknown WMI event (0x11)

Triggered it another time as well at system shutdown:

[10912.842284] BUG: MAX_LOCKDEP_KEYS too low!
[10912.843251] turning off the locking correctness validator.
[10912.843251] Pid: 997, comm: hd-audio0 Not tainted 2.6.33-rc3-mmotm0106 #8
[10912.843251] Call Trace:
[10912.850465]  [<ffffffff81064253>] register_lock_class+0x152/0x31f
[10912.850465]  [<ffffffff81064f0c>] ? mark_lock+0x2d/0x226
[10912.850465]  [<ffffffff81065c9e>] __lock_acquire+0xbd/0xcfa
[10912.850465]  [<ffffffff8102dc35>] ? get_parent_ip+0x11/0x42
[10912.850465]  [<ffffffff81050193>] ? spin_lock_irq+0x9/0xb
[10912.850465]  [<ffffffff810514f5>] ? worker_thread+0x205/0x38b
[10912.850465]  [<ffffffff810669a6>] lock_acquire+0xcb/0xe8
[10912.850465]  [<ffffffff810514f5>] ? worker_thread+0x205/0x38b
[10912.850465]  [<ffffffff81051548>] worker_thread+0x258/0x38b
[10912.850465]  [<ffffffff810514f5>] ? worker_thread+0x205/0x38b
[10912.850465]  [<ffffffff8141ca37>] ? process_unsol_events+0x0/0x62
[10912.850465]  [<ffffffff81054c3d>] ? autoremove_wake_function+0x0/0x34
[10912.850465]  [<ffffffff810512f0>] ? worker_thread+0x0/0x38b
[10912.850465]  [<ffffffff8105477f>] kthread+0x7a/0x82
[10912.850465]  [<ffffffff810031d4>] kernel_thread_helper+0x4/0x10
[10912.850465]  [<ffffffff81565b00>] ? restore_args+0x0/0x30
[10912.850465]  [<ffffffff81054705>] ? kthread+0x0/0x82
[10912.850465]  [<ffffffff810031d0>] ? kernel_thread_helper+0x0/0x10

If I'm hitting MAX_LOCKDEP_KEYS after just a few hours on a mostly-idle
laptop, should it be set higher?

--==_Exmh_1263363729_4458P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLTWaRcC3lWbTT17ARAh1BAKC/TfgXZ0WAw+Je5DNw7YPjg7ETzgCdHQcO
jLxC2YnxWZP21ByTMTXwXAw=
=1yuR
-----END PGP SIGNATURE-----

--==_Exmh_1263363729_4458P--

