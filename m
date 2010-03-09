Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab0CIIqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 03:46:48 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:60598 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab0CIIqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 03:46:45 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: 2.6.33-mmotm0304 - lockdep warning in ACPI code
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1268124370_4014P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 09 Mar 2010 03:46:10 -0500
Message-ID: <5057.1268124370@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4B960AD3.01AA,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1268124370_4014P
Content-Type: text/plain; charset=us-ascii

Seen in my dmesg.  Appears to have started in 2.6.33-rc7-mmotm0210, I can't
remember if I reported it before or not...

[    0.212297] ACPI: Using IOAPIC for interrupt routing
[    0.340075] 
[    0.340076] =============================================
[    0.340241] [ INFO: possible recursive locking detected ]
[    0.340330] 2.6.33-mmotm0304 #5
[    0.340415] ---------------------------------------------
[    0.340504] swapper/1 is trying to acquire lock:
[    0.340591]  (&dev->mutex){+.+...}, at: [<ffffffff812fddfd>] __driver_attach+0x47/0x80
[    0.340926] 
[    0.340927] but task is already holding lock:
[    0.340999]  (&dev->mutex){+.+...}, at: [<ffffffff812fddef>] __driver_attach+0x39/0x80
[    0.340999] 
[    0.340999] other info that might help us debug this:
[    0.340999] 1 lock held by swapper/1:
[    0.340999]  #0:  (&dev->mutex){+.+...}, at: [<ffffffff812fddef>] __driver_attach+0x39/0x80
[    0.340999] 
[    0.340999] stack backtrace:
[    0.340999] Pid: 1, comm: swapper Not tainted 2.6.33-mmotm0304 #5
[    0.340999] Call Trace:
[    0.340999]  [<ffffffff810645e7>] __lock_acquire+0xc74/0xceb
[    0.340999]  [<ffffffff81062a4f>] ? mark_lock+0x2d/0x22c
[    0.340999]  [<ffffffff812fddfd>] ? __driver_attach+0x47/0x80
[    0.340999]  [<ffffffff81064753>] lock_acquire+0xf5/0x112
[    0.340999]  [<ffffffff812fddfd>] ? __driver_attach+0x47/0x80
[    0.340999]  [<ffffffff81062ca0>] ? mark_held_locks+0x52/0x70
[    0.340999]  [<ffffffff81581bb5>] __mutex_lock_common+0x5c/0x5aa
[    0.340999]  [<ffffffff812fddfd>] ? __driver_attach+0x47/0x80
[    0.340999]  [<ffffffff81571004>] ? klist_next+0x24/0xd7
[    0.340999]  [<ffffffff812fddfd>] ? __driver_attach+0x47/0x80
[    0.340999]  [<ffffffff812fddb6>] ? __driver_attach+0x0/0x80
[    0.340999]  [<ffffffff815821a9>] mutex_lock_nested+0x34/0x39
[    0.340999]  [<ffffffff812fddfd>] __driver_attach+0x47/0x80
[    0.340999]  [<ffffffff812fddb6>] ? __driver_attach+0x0/0x80
[    0.340999]  [<ffffffff812fddb6>] ? __driver_attach+0x0/0x80
[    0.340999]  [<ffffffff812fd31f>] bus_for_each_dev+0x54/0x89
[    0.340999]  [<ffffffff812fdb66>] driver_attach+0x19/0x1b
[    0.340999]  [<ffffffff812fd7b1>] bus_add_driver+0xb4/0x203
[    0.340999]  [<ffffffff812fe10f>] driver_register+0xb8/0x129
[    0.340999]  [<ffffffff8123af12>] acpi_bus_register_driver+0x3e/0x40
[    0.340999]  [<ffffffff81b4aaa4>] acpi_ec_init+0x37/0x55
[    0.340999]  [<ffffffff81b4a920>] acpi_init+0x101/0x116
[    0.340999]  [<ffffffff81b4a81f>] ? acpi_init+0x0/0x116
[    0.340999]  [<ffffffff810001ef>] do_one_initcall+0x59/0x14e
[    0.340999]  [<ffffffff81b2c687>] kernel_init+0x14d/0x1d7
[    0.340999]  [<ffffffff810033d4>] kernel_thread_helper+0x4/0x10
[    0.340999]  [<ffffffff81584040>] ? restore_args+0x0/0x30
[    0.340999]  [<ffffffff81b2c53a>] ? kernel_init+0x0/0x1d7
[    0.340999]  [<ffffffff810033d0>] ? kernel_thread_helper+0x0/0x10
[    0.341046] ACPI: EC: GPE = 0x11, I/O: command/status = 0x934, data = 0x930


--==_Exmh_1268124370_4014P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLlgrScC3lWbTT17ARAv2xAJ4o03w8LMPUtwT6dXar/ubrrDCQ4wCbBmrw
LjONQy/NhE39wgDxLVjrdc4=
=nFps
-----END PGP SIGNATURE-----

--==_Exmh_1268124370_4014P--

