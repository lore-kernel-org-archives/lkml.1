Return-Path: <linux-kernel-owner+w=401wt.eu-S1756959AbZKDQM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959AbZKDQM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756451AbZKDQMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:12:25 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:37442 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199AbZKDQMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:12:24 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.32-rc5-mmotm1101 - lockdep whinge during early boot
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1257351084_3622P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Nov 2009 11:11:24 -0500
Message-ID: <6417.1257351084@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020207.4AF1A7AD.0115,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1257351084_3622P
Content-Type: text/plain; charset=us-ascii

Am seeing this at boot:

[    0.344028] Switching to clocksource hpet
[    0.344114]
[    0.344115] =======================================================
[    0.344125] [ INFO: possible circular locking dependency detected ]
[    0.344133] 2.6.32-rc5-mmotm1101 #2
[    0.344139] -------------------------------------------------------
[    0.344147] swapper/1 is trying to acquire lock:
[    0.344154]  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8103c222>] cpu_maps_update_begin+0x12/0x14
[    0.344174]
[    0.344175] but task is already holding lock:
[    0.344183]  (setup_lock){+.+.+.}, at: [<ffffffff81078755>] stop_machine_create+0x12/0x9b
[    0.344200]
[    0.344201] which lock already depends on the new lock.
[    0.344202]
[    0.344212]
[    0.344213] the existing dependency chain (in reverse order) is:
[    0.344222]
[    0.344223] -> #3 (setup_lock){+.+.+.}:
[    0.344235]        [<ffffffff81067898>] __lock_acquire+0xb31/0xcd9
[    0.344246]        [<ffffffff81067b0b>] lock_acquire+0xcb/0xe8
[    0.344255]        [<ffffffff814bbf41>] __mutex_lock_common+0x5c/0x5aa
[    0.344268]        [<ffffffff814bc535>] mutex_lock_nested+0x34/0x39
[    0.344278]        [<ffffffff81078755>] stop_machine_create+0x12/0x9b
[    0.344289]        [<ffffffff810787f9>] stop_machine+0x1b/0x4e
[    0.344298]        [<ffffffff8105e312>] timekeeping_notify+0x1e/0x25
[    0.344310]        [<ffffffff8105f40f>] clocksource_select+0xbd/0xc5
[    0.344320]        [<ffffffff81b1f403>] clocksource_done_booting+0x28/0x38
[    0.344333]        [<ffffffff810001f7>] do_one_initcall+0x59/0x14e
[    0.344344]        [<ffffffff81b0c66c>] kernel_init+0x15f/0x1b5
[    0.344355]        [<ffffffff8100337a>] child_rip+0xa/0x20
[    0.344366]
[    0.344366] -> #2 (clocksource_mutex){+.+.+.}:
[    0.344378]        [<ffffffff81067898>] __lock_acquire+0xb31/0xcd9
[    0.344388]        [<ffffffff81067b0b>] lock_acquire+0xcb/0xe8
[    0.344398]        [<ffffffff814bbf41>] __mutex_lock_common+0x5c/0x5aa
[    0.344408]        [<ffffffff814bc535>] mutex_lock_nested+0x34/0x39
[    0.344419]        [<ffffffff8105f608>] clocksource_change_rating+0x1b/0x37
[    0.344430]        [<ffffffff81008449>] mark_tsc_unstable+0x3f/0x4d
[    0.344440]        [<ffffffff814b7135>] check_tsc_sync_source+0xc8/0x10d
[    0.344451]        [<ffffffff814b6e50>] native_cpu_up+0xfb/0x13e
[    0.344461]        [<ffffffff814b82ff>] _cpu_up+0xa8/0x14a
[    0.344471]        [<ffffffff814b83fc>] cpu_up+0x5b/0x68
[    0.344480]        [<ffffffff81b0c5d2>] kernel_init+0xc5/0x1b5
[    0.344490]        [<ffffffff8100337a>] child_rip+0xa/0x20
[    0.344499]
[    0.344500] -> #1 (cpu_hotplug.lock){+.+.+.}:
[    0.344512]        [<ffffffff81067898>] __lock_acquire+0xb31/0xcd9
[    0.344522]        [<ffffffff81067b0b>] lock_acquire+0xcb/0xe8
[    0.344531]        [<ffffffff814bbf41>] __mutex_lock_common+0x5c/0x5aa
[    0.344542]        [<ffffffff814bc535>] mutex_lock_nested+0x34/0x39
[    0.344552]        [<ffffffff8103c25d>] cpu_hotplug_begin+0x27/0x68
[    0.344562]        [<ffffffff814b82af>] _cpu_up+0x58/0x14a
[    0.344572]        [<ffffffff814b83fc>] cpu_up+0x5b/0x68
[    0.344581]        [<ffffffff81b0c5d2>] kernel_init+0xc5/0x1b5
[    0.344591]        [<ffffffff8100337a>] child_rip+0xa/0x20
[    0.344600]
[    0.344601] -> #0 (cpu_add_remove_lock){+.+.+.}:
[    0.344613]        [<ffffffff81067742>] __lock_acquire+0x9db/0xcd9
[    0.344623]        [<ffffffff81067b0b>] lock_acquire+0xcb/0xe8
[    0.344632]        [<ffffffff814bbf41>] __mutex_lock_common+0x5c/0x5aa
[    0.344643]        [<ffffffff814bc535>] mutex_lock_nested+0x34/0x39
[    0.344653]        [<ffffffff8103c222>] cpu_maps_update_begin+0x12/0x14
[    0.344664]        [<ffffffff81052461>] __create_workqueue_key+0x146/0x1f4
[    0.344675]        [<ffffffff8107877d>] stop_machine_create+0x3a/0x9b
[    0.344686]        [<ffffffff810787f9>] stop_machine+0x1b/0x4e
[    0.344696]        [<ffffffff8105e312>] timekeeping_notify+0x1e/0x25
[    0.344706]        [<ffffffff8105f40f>] clocksource_select+0xbd/0xc5
[    0.344716]        [<ffffffff81b1f403>] clocksource_done_booting+0x28/0x38
[    0.344727]        [<ffffffff810001f7>] do_one_initcall+0x59/0x14e
[    0.344737]        [<ffffffff81b0c66c>] kernel_init+0x15f/0x1b5
[    0.344747]        [<ffffffff8100337a>] child_rip+0xa/0x20
[    0.344756]
[    0.344757] other info that might help us debug this:
[    0.344758]
[    0.344769] 2 locks held by swapper/1:
[    0.344774]  #0:  (clocksource_mutex){+.+.+.}, at: [<ffffffff81b1f3fe>] clocksource_done_booting+0x23/0x38
[    0.344792]  #1:  (setup_lock){+.+.+.}, at: [<ffffffff81078755>] stop_machine_create+0x12/0x9b
[    0.344809]
[    0.344810] stack backtrace:
[    0.344820] Pid: 1, comm: swapper Not tainted 2.6.32-rc5-mmotm1101 #2
[    0.344829] Call Trace:
[    0.344837]  [<ffffffff81066944>] print_circular_bug+0xa8/0xb7
[    0.344847]  [<ffffffff81067742>] __lock_acquire+0x9db/0xcd9
[    0.344857]  [<ffffffff8103c222>] ? cpu_maps_update_begin+0x12/0x14
[    0.344867]  [<ffffffff81067b0b>] lock_acquire+0xcb/0xe8
[    0.344876]  [<ffffffff8103c222>] ? cpu_maps_update_begin+0x12/0x14
[    0.344887]  [<ffffffff814bbf41>] __mutex_lock_common+0x5c/0x5aa
[    0.344896]  [<ffffffff8103c222>] ? cpu_maps_update_begin+0x12/0x14
[    0.344906]  [<ffffffff814bbcea>] ? mutex_unlock+0x9/0xb
[    0.344916]  [<ffffffff810d743d>] ? pcpu_alloc+0x80c/0x826
[    0.344926]  [<ffffffff8103c222>] ? cpu_maps_update_begin+0x12/0x14
[    0.344936]  [<ffffffff810d4fda>] ? kmem_cache_alloc+0xbb/0x183
[    0.344946]  [<ffffffff81066295>] ? trace_hardirqs_on_caller+0x118/0x13c
[    0.344956]  [<ffffffff814bc535>] mutex_lock_nested+0x34/0x39
[    0.344966]  [<ffffffff8103c222>] cpu_maps_update_begin+0x12/0x14
[    0.344976]  [<ffffffff81052461>] __create_workqueue_key+0x146/0x1f4
[    0.344986]  [<ffffffff8105dbc4>] ? change_clocksource+0x0/0x5b
[    0.344996]  [<ffffffff8107877d>] stop_machine_create+0x3a/0x9b
[    0.344999]  [<ffffffff810787f9>] stop_machine+0x1b/0x4e
[    0.344999]  [<ffffffff8105e312>] timekeeping_notify+0x1e/0x25
[    0.344999]  [<ffffffff8105f40f>] clocksource_select+0xbd/0xc5
[    0.344999]  [<ffffffff81b1f3db>] ? clocksource_done_booting+0x0/0x38
[    0.344999]  [<ffffffff81b1f403>] clocksource_done_booting+0x28/0x38
[    0.344999]  [<ffffffff810001f7>] do_one_initcall+0x59/0x14e
[    0.344999]  [<ffffffff81b0c66c>] kernel_init+0x15f/0x1b5
[    0.344999]  [<ffffffff8100337a>] child_rip+0xa/0x20
[    0.344999]  [<ffffffff814be2c0>] ? restore_args+0x0/0x30
[    0.344999]  [<ffffffff81b0c50d>] ? kernel_init+0x0/0x1b5
[    0.344999]  [<ffffffff81003370>] ? child_rip+0x0/0x20
[    0.345393] Warning: could not register annotated branches stats
[    0.349818] pnp: PnP ACPI init
[    0.349843] ACPI: bus type pnp registered


--==_Exmh_1257351084_3622P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK8aescC3lWbTT17ARAgVpAJ49foKwpoxQwkrLtl/Pw6nRH3kK9ACfTxxK
iuIhdcXDW/1fyDr4TCBwGaM=
=8Txj
-----END PGP SIGNATURE-----

--==_Exmh_1257351084_3622P--

