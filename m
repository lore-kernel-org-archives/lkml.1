Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750857Ab0BKFRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 00:17:47 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:40945 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab0BKFRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 00:17:45 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: mmotm 2010-02-10 - lockdep whinge in ACPI code
In-Reply-To: Your message of "Wed, 10 Feb 2010 16:17:41 PST."
             <201002110043.o1B0hKxW008835@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201002110043.o1B0hKxW008835@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1265865104_4122P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 11 Feb 2010 00:11:44 -0500
Message-ID: <5114.1265865104@localhost>
X-Mirapoint-Received-SPF: 128.173.34.103 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=zidane.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4B739191.0194,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1265865104_4122P
Content-Type: text/plain; charset=us-ascii

On Wed, 10 Feb 2010 16:17:41 PST, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-02-10-16-17 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

Seen at boot:

[    0.207242] ACPI: (supports S0 S5)
[    0.207257] ACPI: Using IOAPIC for interrupt routing
[    0.335315] 
[    0.335316] =============================================
[    0.335483] [ INFO: possible recursive locking detected ]
[    0.335572] 2.6.33-rc7-mmotm0210 #1
[    0.335658] ---------------------------------------------
[    0.335746] swapper/1 is trying to acquire lock:
[    0.335834]  (&dev->mutex){+.+...}, at: [<ffffffff812eb521>] __driver_attach+0x47/0x80
[    0.335999] 
[    0.335999] but task is already holding lock:
[    0.335999]  (&dev->mutex){+.+...}, at: [<ffffffff812eb513>] __driver_attach+0x39/0x80
[    0.335999] 
[    0.335999] other info that might help us debug this:
[    0.335999] 1 lock held by swapper/1:
[    0.335999]  #0:  (&dev->mutex){+.+...}, at: [<ffffffff812eb513>] __driver_attach+0x39/0x80
[    0.335999] 
[    0.335999] stack backtrace:
[    0.335999] Pid: 1, comm: swapper Not tainted 2.6.33-rc7-mmotm0210 #1
[    0.335999] Call Trace:
[    0.335999]  [<ffffffff81063b47>] __lock_acquire+0xc77/0xcee
[    0.335999]  [<ffffffff81061fad>] ? mark_lock+0x2d/0x22c
[    0.335999]  [<ffffffff812eb521>] ? __driver_attach+0x47/0x80
[    0.335999]  [<ffffffff81063c89>] lock_acquire+0xcb/0xe8
[    0.335999]  [<ffffffff812eb521>] ? __driver_attach+0x47/0x80
[    0.335999]  [<ffffffff810621fe>] ? mark_held_locks+0x52/0x70
[    0.335999]  [<ffffffff81568c9d>] __mutex_lock_common+0x5c/0x5aa
[    0.335999]  [<ffffffff812eb521>] ? __driver_attach+0x47/0x80
[    0.335999]  [<ffffffff815583f8>] ? klist_next+0x24/0xd7
[    0.335999]  [<ffffffff812eb521>] ? __driver_attach+0x47/0x80
[    0.335999]  [<ffffffff812eb4da>] ? __driver_attach+0x0/0x80
[    0.335999]  [<ffffffff81569291>] mutex_lock_nested+0x34/0x39
[    0.335999]  [<ffffffff812eb521>] __driver_attach+0x47/0x80
[    0.335999]  [<ffffffff812eb4da>] ? __driver_attach+0x0/0x80
[    0.335999]  [<ffffffff812eb4da>] ? __driver_attach+0x0/0x80
[    0.335999]  [<ffffffff812eaa43>] bus_for_each_dev+0x54/0x89
[    0.335999]  [<ffffffff812eb28a>] driver_attach+0x19/0x1b
[    0.335999]  [<ffffffff812eaed5>] bus_add_driver+0xb4/0x203
[    0.335999]  [<ffffffff812eb833>] driver_register+0xb8/0x129
[    0.335999]  [<ffffffff81231604>] acpi_bus_register_driver+0x3e/0x40
[    0.335999]  [<ffffffff81b45094>] acpi_ec_init+0x37/0x55
[    0.335999]  [<ffffffff81b44ef1>] acpi_init+0x115/0x12a
[    0.335999]  [<ffffffff81b44ddc>] ? acpi_init+0x0/0x12a
[    0.335999]  [<ffffffff810001ef>] do_one_initcall+0x59/0x14e
[    0.335999]  [<ffffffff81b26655>] kernel_init+0x14d/0x1a3
[    0.335999]  [<ffffffff81003354>] kernel_thread_helper+0x4/0x10
[    0.335999]  [<ffffffff8156b0c0>] ? restore_args+0x0/0x30
[    0.335999]  [<ffffffff81b26508>] ? kernel_init+0x0/0x1a3
[    0.335999]  [<ffffffff81003350>] ? kernel_thread_helper+0x0/0x10
[    0.340036] ACPI: EC: GPE = 0x11, I/O: command/status = 0x934, data = 0x930


--==_Exmh_1265865104_4122P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLc5GQcC3lWbTT17ARAgfUAJ0arz7hP5Y6PhK7tmeLPeGxVs/dngCg+NrC
heiTBP5hzYV1kYVBetaP+0c=
=wPEo
-----END PGP SIGNATURE-----

--==_Exmh_1265865104_4122P--

