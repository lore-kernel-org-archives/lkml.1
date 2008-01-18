Return-Path: <linux-kernel-owner+w=401wt.eu-S1759347AbYARFpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347AbYARFpN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 00:45:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbYARFpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 00:45:00 -0500
Received: from ozlabs.org ([203.10.76.45]:47535 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbYARFo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 00:44:59 -0500
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC (Take 2)
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <1200634493.7806.0.camel@concordia.ozlabs.ibm.com>
References: <20071207223714.11448.91386.sendpatchset@balbir-laptop>
	 <1200634493.7806.0.camel@concordia.ozlabs.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0Gh0D41Z+W4DB3VvmyAY"
Date: Fri, 18 Jan 2008 16:44:58 +1100
Message-Id: <1200635099.7806.3.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0Gh0D41Z+W4DB3VvmyAY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-01-18 at 16:34 +1100, Michael Ellerman wrote:
> On Sat, 2007-12-08 at 04:07 +0530, Balbir Singh wrote:
> > Changelog
> >=20
> > 1. Get rid of the constant 5 (based on comments from
> >                                 Geert.Uytterhoeven@sonycom.com)
> > 2. Implement suggestions from Olof Johannson
> > 3. Check if cmdline is NULL in fake_numa_create_new_node()
> >=20
> > Tested with additional parameters from Olof
> >=20
> > numa=3Ddebug,fake=3D
> > numa=3Dfoo,fake=3Dbar
>=20
>=20
> I'm not sure why yet, but git bisect tells me it's this patch that's
> causing the for-2.6.25 tree to explode on boot on cell machines.

This fixes it, although I'm a little worried about some of the
removals/movings of node_set_online() in the patch.


diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 1666e7d..dcedc26 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -49,7 +49,6 @@ static int __cpuinit fake_numa_create_new_node(unsigned l=
ong end_pfn,
 	static unsigned int fake_nid =3D 0;
 	static unsigned long long curr_boundary =3D 0;
=20
-	*nid =3D fake_nid;
 	if (!p)
 		return 0;
=20
@@ -60,6 +59,7 @@ static int __cpuinit fake_numa_create_new_node(unsigned l=
ong end_pfn,
 	if (mem < curr_boundary)
 		return 0;
=20
+	*nid =3D fake_nid;
 	curr_boundary =3D mem;
=20
 	if ((end_pfn << PAGE_SHIFT) > mem) {


--=-0Gh0D41Z+W4DB3VvmyAY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHkDzadSjSd0sB4dIRAimBAKCa01+lUapFigLkneoFwUm46A0krwCbBn1j
dKX+gSSpgIsyfoconloXWlo=
=SlFp
-----END PGP SIGNATURE-----

--=-0Gh0D41Z+W4DB3VvmyAY--

