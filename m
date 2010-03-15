Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935065Ab0COBEQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 21:04:16 -0400
Received: from ozlabs.org ([203.10.76.45]:60133 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934806Ab0COBEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 21:04:15 -0400
Subject: Re: 34-rc1-git3 build failure with CGROUP_MEM_RES_CTLR_SWAP=y
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Sachin Sant <sachinp@in.ibm.com>
Cc: Linux/PPC Development <linuxppc-dev@ozlabs.org>, lizf@cn.fujitsu.com,
       nishimura@mxp.nes.nec.co.jp,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <4B9CBEE6.1090509@in.ibm.com>
References: <4B9CBEE6.1090509@in.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-nqzhtNy1K9740rudgAhK"
Date: Mon, 15 Mar 2010 12:04:13 +1100
Message-ID: <1268615053.4644.10.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nqzhtNy1K9740rudgAhK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-03-14 at 16:18 +0530, Sachin Sant wrote:
> On a PowerPC box, latest 34-rc1 git(d89b218b8...) fails to build
> with CGROUPS_MEM_RES_CTRL_SWAP=3Dy.=20
>=20
> LD      init/built-in.o
> LD      .tmp_vmlinux1
> mm/built-in.o: In function __xchg:
> arch/powerpc/include/asm/system.h:331: undefined reference to .__xchg_cal=
led_with_bad_pointer
> mm/built-in.o: In function __cmpxchg:
> arch/powerpc/include/asm/system.h:474: undefined reference to .__cmpxchg_=
called_with_bad_pointer
> make: *** [.tmp_vmlinux1] Error 1
>=20
> The code in question was added via commit 024914477e...
>=20
> memcg: move charges of anonymous swap

struct swap_cgroup
{                                                       =20
	unsigned short          id;
};

+unsigned short swap_cgroup_cmpxchg(swp_entry_t ent,
+                                       unsigned short old, unsigned short =
new)
+{
...
+       struct swap_cgroup *sc;
...
+       if (cmpxchg(&sc->id, old, new) =3D=3D old)


On powerpc cmpxchg() currently only handles u32 & u64.

cheers

--=-nqzhtNy1K9740rudgAhK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkudh4YACgkQdSjSd0sB4dIxQACfZS/VABlWyFgET+udrwqUhAnw
GXMAn28M1htbQpiisdvltR2fkRfzFeav
=lZR9
-----END PGP SIGNATURE-----

--=-nqzhtNy1K9740rudgAhK--

