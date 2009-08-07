Return-Path: <linux-kernel-owner+w=401wt.eu-S932623AbZHGOq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623AbZHGOq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 10:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932593AbZHGOqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 10:46:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:53148 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932574AbZHGOqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 10:46:24 -0400
Date: Fri, 7 Aug 2009 09:46:08 -0500
From: Clark Williams <williams@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Subject: [RT] Lockdep warning on boot with 2.6.31-rc5-rt1.1
Message-ID: <20090807094608.4b0efea1@torg>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Fv2+NwoBsXTwCjJOA_tm_kG"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Fv2+NwoBsXTwCjJOA_tm_kG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Peter,

I'm getting this warning from lockdep when booting on my T60.=20

The two addresses reported (0xffffffff812664a2 and 0xffffffff812664ae)
actually bracket one call to mutex_lock() in driver_attach() so I'm not
sure what the complaint is.

Clark

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[ INFO: possible recursive locking detected ]
2.6.31-rc5-rt1.1 #37
---------------------------------------------
swapper/1 is trying to acquire lock:
 (&dev->mutex){+.+...}, at: [<ffffffff812664ae>]
__driver_attach+0x48/0x81

but task is already holding lock:
 (&dev->mutex){+.+...}, at: [<ffffffff812664a2>]
__driver_attach+0x3c/0x81

other info that might help us debug this:
1 lock held by swapper/1:
 #0:  (&dev->mutex){+.+...}, at: [<ffffffff812664a2>]
__driver_attach+0x3c/0x81

stack backtrace:
Pid: 1, comm: swapper Not tainted 2.6.31-rc5-rt1.1 #37
Call Trace:
 [<ffffffff81071e38>] __lock_acquire+0x14ae/0x153c
 [<ffffffff812664ae>] ? __driver_attach+0x48/0x81
 [<ffffffff81071fc3>] lock_acquire+0xfd/0x129
 [<ffffffff812664ae>] ? __driver_attach+0x48/0x81
 [<ffffffff8137b667>] _mutex_lock+0x31/0x40
 [<ffffffff812664ae>] ? __driver_attach+0x48/0x81
 [<ffffffff812664ae>] __driver_attach+0x48/0x81
 [<ffffffff81266466>] ? __driver_attach+0x0/0x81
 [<ffffffff81265b9c>] bus_for_each_dev+0x59/0x8e
 [<ffffffff81266245>] driver_attach+0x1e/0x20
 [<ffffffff81265465>] bus_add_driver+0x13f/0x288
 [<ffffffff812667b3>] driver_register+0x9d/0x10e
 [<ffffffff81207e26>] acpi_bus_register_driver+0x43/0x45
 [<ffffffff815f5fdf>] acpi_ec_init+0x37/0x55
 [<ffffffff815f5d47>] acpi_init+0x224/0x265
 [<ffffffff815f5b23>] ? acpi_init+0x0/0x265
 [<ffffffff81009080>] do_one_initcall+0x75/0x18a
 [<ffffffff8106dd0a>] ? put_lock_stats+0xe/0x27
 [<ffffffff8137b3d1>] ? rt_spin_unlock+0x23/0x6d
 [<ffffffff8106dcc8>] ? get_lock_stats+0x16/0x4a
 [<ffffffff8106dcc8>] ? get_lock_stats+0x16/0x4a
 [<ffffffff81145616>] ? proc_register+0x18c/0x1a2
 [<ffffffff8137e6fe>] ? sub_preempt_count+0x35/0x49
 [<ffffffff8106dd0a>] ? put_lock_stats+0xe/0x27
 [<ffffffff8106de1c>] ? lock_release_holdtime+0xf9/0xfe
 [<ffffffff8137b3d1>] ? rt_spin_unlock+0x23/0x6d
 [<ffffffff81145616>] ? proc_register+0x18c/0x1a2
 [<ffffffff8114574a>] ? create_proc_entry+0x79/0x91
 [<ffffffff8109c069>] ? register_irq_proc+0xb3/0xcf
 [<ffffffff81140000>] ? pde_users_dec+0x20/0x45
 [<ffffffff815d370a>] kernel_init+0x17e/0x28b
 [<ffffffff8100d15a>] child_rip+0xa/0x20
 [<ffffffff8100ca94>] ? restore_args+0x0/0x30
 [<ffffffff815d358c>] ? kernel_init+0x0/0x28b
 [<ffffffff8100d150>] ? child_rip+0x0/0x20
---------------------------
| preempt count: 00000000 ]
| 0-level deep critical section nesting:
----------------------------------------

--Sig_/Fv2+NwoBsXTwCjJOA_tm_kG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkp8PjMACgkQHyuj/+TTEp2UKACeOFDs1K228u0OMDfNKMqlmFMW
gI4AoK6hntlHpoQbbLvZ/ZVBlzSeDNWi
=cAA4
-----END PGP SIGNATURE-----

--Sig_/Fv2+NwoBsXTwCjJOA_tm_kG--
