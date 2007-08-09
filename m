Return-Path: <linux-kernel-owner+w=401wt.eu-S939931AbXHIMsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939931AbXHIMsq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939725AbXHIMpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:45:09 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:8020 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S939679AbXHIMpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:45:06 -0400
Subject: Re: 2.6.23-rc2-mm1: hang, prop_norm_single involved
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070809111044.GA6575@localhost.sw.ru>
References: <20070809111044.GA6575@localhost.sw.ru>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ikPTjTfXxFRhbVOdpbbv"
Date: Thu, 09 Aug 2007 14:45:02 +0200
Message-Id: <1186663502.20108.28.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ikPTjTfXxFRhbVOdpbbv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-09 at 15:10 +0400, Alexey Dobriyan wrote:
> LTP run reproducably hangs during rwtest01 test
> rwtest -N rwtest01 -c -q -i 60s -f sync 10%25000:rs-sync=3D$$
> Calltrace is always the same:
>=20
> INFO: trying to register non-static key
> 	__lock_acquire+0x210/0xc9e
> 	lock_acquire+0x87/0xa3
> 	_spin_lock_irqsave+0x2f/0x5f
> 	prop_norm_single+0x32/0x74
> 	set_page_dirty+0xd6/0x151
> 	set_page_dirty_balance+0xc/0x71
> 	do_wp_page+0x4ae/0x52b
> 	handle_mm_fault+0x616/0x6c4
> 	do_page_fault+0x1b0/0x51c


[root@opteron ~]# PATH=3D/testcases/bin/:$PATH /testcases/bin/rwtest -N rwt=
est01 -c -q -i 60s -f sync 10%25000:rs-sync=3D$$
rwtest01    1  PASS  :  Test passed
[root@opteron ~]# PATH=3D/testcases/bin/:$PATH /testcases/bin/rwtest -N rwt=
est01 -c -q -i 60s -f sync 10%25000:rs-sync=3D$$
  =20
I can reproduce, but not always.

Also, since the task->dirties member is initialized in fork.c this
should either _always_ happen or never. So this does point to some
memory corruption, ->dirties is the very last member of the task struct.

/me goes try with slab_debug,...


--=-ikPTjTfXxFRhbVOdpbbv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGuwxOXA2jU0ANEf4RAoMiAJ41S+bSM2fVwuqfNt/PgUX/WGXM6QCcDz5E
CprC6Yhpe8mgEjBicxTPC+U=
=dxfP
-----END PGP SIGNATURE-----

--=-ikPTjTfXxFRhbVOdpbbv--

