Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbYKGJid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbYKGJid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 04:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYKGJiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 04:38:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40867 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbYKGJiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 04:38:05 -0500
Date: Fri, 7 Nov 2008 20:37:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Markus Dahms <mad@automagically.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [linux-next] possible circular locking dependency for
 cryptsetup
Message-Id: <20081107203750.91bd0e73.sfr@canb.auug.org.au>
In-Reply-To: <20081107083200.GA5109@vimes.madsworld.lan>
References: <20081107083200.GA5109@vimes.madsworld.lan>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__7_Nov_2008_20_37_50_+1100_.iqIvIVakf87A6PA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Nov_2008_20_37_50_+1100_.iqIvIVakf87A6PA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Just adding a cc]

On Fri, 7 Nov 2008 09:32:00 +0100 Markus Dahms <mad@automagically.de> wrote:
>
> I got the following warning for 2.6.28-rc3-next-20081106, it's quiet for
> 2.6.28-rc3. Besides the new warning everything seems to work fine.
>=20
> As a side note, I wanted to file this at bugzilla.k.o, but there is no
> "next" tree in "alternate trees" - intended?
>=20
> FWIW: x86, 2xP3
>=20
> Greetings,
>=20
> 	Markus
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> [ INFO: possible circular locking dependency detected ]
> 2.6.28-rc3-next-20081106-mad-1 #2
> -------------------------------------------------------
> cryptsetup/2554 is trying to acquire lock:
>  (&cpu_hotplug.lock){--..}, at: [<c012cd32>] get_online_cpus+0x22/0x40
>=20
> but task is already holding lock:
>  (&mm->mmap_sem){----}, at: [<c018b98e>] sys_mlockall+0x5e/0xd0
>=20
> which lock already depends on the new lock.
>=20
>=20
> the existing dependency chain (in reverse order) is:
>=20
> -> #3 (&mm->mmap_sem){----}:
>        [<c0151560>] __lock_acquire+0xf30/0x17f0
>        [<c0151e7e>] lock_acquire+0x5e/0x80
>        [<c0187d2c>] might_fault+0x5c/0x80
>        [<c0267bc6>] copy_to_user+0x36/0x120
>        [<c01af074>] filldir64+0xa4/0xf0
>        [<c01ead29>] sysfs_readdir+0x129/0x220
>        [<c01af315>] vfs_readdir+0x95/0xb0
>        [<c01af399>] sys_getdents64+0x69/0xc0
>        [<c010346d>] sysenter_do_call+0x12/0x31
>        [<ffffffff>] 0xffffffff
>=20
> -> #2 (sysfs_mutex){--..}:
>        [<c0151560>] __lock_acquire+0xf30/0x17f0
>        [<c0151e7e>] lock_acquire+0x5e/0x80
>        [<c03e5be4>] mutex_lock_nested+0xb4/0x2c0
>        [<c01eb0ac>] sysfs_addrm_start+0x2c/0xb0
>        [<c01eb6b0>] create_dir+0x40/0x90
>        [<c01eb72b>] sysfs_create_dir+0x2b/0x50
>        [<c026116f>] kobject_add_internal+0xcf/0x240
>        [<c02613b1>] kobject_add_varg+0x31/0x50
>        [<c0261807>] kobject_init_and_add+0x27/0x30
>        [<c019e4b3>] sysfs_slab_add+0x83/0x1a0
>        [<c019e61e>] sysfs_add_func+0x4e/0x70
>        [<c013c6b5>] run_workqueue+0xe5/0x1f0
>        [<c013c848>] worker_thread+0x88/0xf0
>        [<c01402ec>] kthread+0x3c/0x70
>        [<c01042ff>] kernel_thread_helper+0x7/0x18
>        [<ffffffff>] 0xffffffff
>=20
> -> #1 (slub_lock){----}:
>        [<c0151560>] __lock_acquire+0xf30/0x17f0
>        [<c0151e7e>] lock_acquire+0x5e/0x80
>        [<c03e65d7>] down_read+0x37/0x50
>        [<c03e40da>] slab_cpuup_callback+0x3a/0x192
>        [<c01452cd>] notifier_call_chain+0x2d/0x70
>        [<c01453c9>] __raw_notifier_call_chain+0x19/0x20
>        [<c03e334e>] _cpu_up+0x5e/0x105
>        [<c03e3459>] cpu_up+0x64/0x7b
>        [<c055430f>] kernel_init+0xb6/0x173
>        [<c01042ff>] kernel_thread_helper+0x7/0x18
>        [<ffffffff>] 0xffffffff
>=20
> -> #0 (&cpu_hotplug.lock){--..}:
>        [<c0151691>] __lock_acquire+0x1061/0x17f0
>        [<c0151e7e>] lock_acquire+0x5e/0x80
>        [<c03e5be4>] mutex_lock_nested+0xb4/0x2c0
>        [<c012cd32>] get_online_cpus+0x22/0x40
>        [<c013d2c8>] schedule_on_each_cpu+0x38/0xe0
>        [<c018115d>] lru_add_drain_all+0xd/0x10
>        [<c018b486>] __mlock_vma_pages_range+0x36/0x1f0
>        [<c018b74f>] mlock_fixup+0x10f/0x210
>        [<c018b8db>] do_mlockall+0x8b/0xa0
>        [<c018b9c1>] sys_mlockall+0x91/0xd0
>        [<c010346d>] sysenter_do_call+0x12/0x31
>        [<ffffffff>] 0xffffffff
>=20
> other info that might help us debug this:
>=20
> 1 lock held by cryptsetup/2554:
>  #0:  (&mm->mmap_sem){----}, at: [<c018b98e>] sys_mlockall+0x5e/0xd0
>=20
> stack backtrace:
> Pid: 2554, comm: cryptsetup Not tainted 2.6.28-rc3-next-20081106-mad-1 #2
> Call Trace:
>  [<c03e45d2>] ? printk+0x18/0x1e
>  [<c0150213>] print_circular_bug_tail+0xc3/0xd0
>  [<c014ff4b>] ? print_circular_bug_entry+0x4b/0x50
>  [<c0151691>] __lock_acquire+0x1061/0x17f0
>  [<c0151e7e>] lock_acquire+0x5e/0x80
>  [<c012cd32>] ? get_online_cpus+0x22/0x40
>  [<c03e5be4>] mutex_lock_nested+0xb4/0x2c0
>  [<c012cd32>] ? get_online_cpus+0x22/0x40
>  [<c012cd32>] ? get_online_cpus+0x22/0x40
>  [<c019f391>] ? __percpu_alloc_mask+0xa1/0x100
>  [<c012cd32>] get_online_cpus+0x22/0x40
>  [<c013d2c8>] schedule_on_each_cpu+0x38/0xe0
>  [<c0180ed0>] ? lru_add_drain_per_cpu+0x0/0x10
>  [<c018115d>] lru_add_drain_all+0xd/0x10
>  [<c018b486>] __mlock_vma_pages_range+0x36/0x1f0
>  [<c022c109>] ? avc_has_perm+0x59/0x70
>  [<c018b74f>] mlock_fixup+0x10f/0x210
>  [<c018b8db>] do_mlockall+0x8b/0xa0
>  [<c018b9c1>] sys_mlockall+0x91/0xd0
>  [<c010346d>] sysenter_do_call+0x12/0x31

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__7_Nov_2008_20_37_50_+1100_.iqIvIVakf87A6PA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkUDG4ACgkQjjKRsyhoI8zYWgCfZ2/hj7nC0/DCukGta30Sxe50
YbYAoKsioBAPxrbUdbN9okjCS7T3iT/a
=jyd6
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Nov_2008_20_37_50_+1100_.iqIvIVakf87A6PA--
