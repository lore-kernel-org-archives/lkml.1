Return-Path: <linux-kernel-owner+w=401wt.eu-S1761510AbYA2NFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761510AbYA2NFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:05:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760801AbYA2NFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:05:03 -0500
Received: from ozlabs.org ([203.10.76.45]:34647 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760763AbYA2NFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:05:00 -0500
Subject: Re: [PATCH powerpc] Fake NUMA emulation for PowerPC (Take 3)
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: balbir@linux.vnet.ibm.com
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080128125206.GC4330@balbir.in.ibm.com>
References: <20071207223714.11448.91386.sendpatchset@balbir-laptop>
	 <1200634493.7806.0.camel@concordia.ozlabs.ibm.com>
	 <1200635099.7806.3.camel@concordia.ozlabs.ibm.com>
	 <20080126071339.GA25328@balbir.in.ibm.com>
	 <18332.28991.658933.763115@cargo.ozlabs.ibm.com>
	 <20080128125206.GC4330@balbir.in.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yI7DAv1fNtnaCI4Z6Uzq"
Date: Wed, 30 Jan 2008 00:04:58 +1100
Message-Id: <1201611898.26410.7.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yI7DAv1fNtnaCI4Z6Uzq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-01-28 at 18:22 +0530, Balbir Singh wrote:
> Hi, Paul,
>=20
> Here's version 3 of the patch. I've commented the side-effect of
> repeatedly setting node 0 online (as to why that is done) and I've
> removed the side effect of not creating memory less nodes
> (when we hit the memory limit).
>=20
> I've described all my tests below
> =20
> Changelog v3
> 1. Remove the side-effect of not setting nodes online if they end
>    up having no memory in them because of the memory limit.
>=20
> Changelog v2
>=20
> 1. Get rid of the constant 5 (based on comments from
>                                 Geert.Uytterhoeven@sonycom.com)
> 2. Implement suggestions from Olof Johannson
> 3. Check if cmdline is NULL in fake_numa_create_new_node()

> diff -puN arch/powerpc/mm/numa.c~fakenumappc arch/powerpc/mm/numa.c
> --- linux-2.6.24-rc8/arch/powerpc/mm/numa.c~fakenumappc	2008-01-28 17:05:=
34.000000000 +0530
> +++ linux-2.6.24-rc8-balbir/arch/powerpc/mm/numa.c	2008-01-28 18:15:41.00=
0000000 +0530
> @@ -39,6 +41,47 @@ static bootmem_data_t __initdata plat_no
>  static int min_common_depth;
>  static int n_mem_addr_cells, n_mem_size_cells;
> =20
> +static int __cpuinit fake_numa_create_new_node(unsigned long end_pfn,
> +						unsigned int *nid)
> +{
> +	unsigned long long mem;
> +	char *p =3D cmdline;
> +	static unsigned int fake_nid;
> +	static unsigned long long curr_boundary;
> +
> +	/*
> +	 * Modify node id, iff we started creating NUMA nodes
> +	 */
> +	if (fake_nid)
> +		*nid =3D fake_nid;
> +	if (!p)
> +		return 0;

Why do you check !p after assigning to nid? I assume it's because we
might have reached the end of the command line, ie. p =3D=3D NULL, but we'r=
e
still adding memory to the last node? If so it's a it's a little subtle
and deserves a comment I think.

Otherwise this looks pretty good.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-yI7DAv1fNtnaCI4Z6Uzq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHnyR6dSjSd0sB4dIRAp4QAJ4/yn5I2nkhcnEupfCqJcRiYAJ6RwCgii6U
hT300tCLYxuGOby3JtFELh4=
=ibVU
-----END PGP SIGNATURE-----

--=-yI7DAv1fNtnaCI4Z6Uzq--

