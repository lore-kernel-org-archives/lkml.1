Return-Path: <linux-kernel-owner+w=401wt.eu-S1758393AbXIMORt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393AbXIMORt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 10:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754238AbXIMORl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 10:17:41 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:43300 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754183AbXIMORk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 10:17:40 -0400
Subject: Re: Understanding I/O behaviour - next try
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: spamtrap@knobisoft.de
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
In-Reply-To: <353439.71100.qm@web32603.mail.mud.yahoo.com>
References: <353439.71100.qm@web32603.mail.mud.yahoo.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-z8V6K1Yk2RT7/irSCJcq"
Date: Thu, 13 Sep 2007 16:17:37 +0200
Message-Id: <1189693057.21778.234.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-z8V6K1Yk2RT7/irSCJcq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-29 at 01:15 -0700, Martin Knoblauch wrote:

> > >  Another thing I saw during my tests is that when writing to NFS, the
> > > "dirty" or "nr_dirty" numbers are always 0. Is this a conceptual thin=
g,
> > > or a bug?
> >=20
> > What are the nr_unstable numbers?

NFS has the concept of unstable storage, that is a state where it is
agreed the page has been transferred to the remote server, but has not
yet been written to disk.

>  Ahh. Yes, they go up to 80-90k pages. Comparable to the nr_dirty
> numbers for the disk case. Good to know.
>=20
>  For NFS, the nr_writeback numbers seem surprisingly high. They also go
> to 80-90k (pages ?). In the disk case they rarely go over 12k.

see: /proc/sys/fs/nfs/nfs_congestion_kb

That is the limit for when the nfs BDI is marked congested, so
nfs_writeout + nfs_unstable <=3D nfs_congestion_kb

The nfs_dirty always being 0 just means that pages very quickly start
their writeout cycle.

--=-z8V6K1Yk2RT7/irSCJcq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG6UaBXA2jU0ANEf4RAko7AJ9PrM/lMbDczfBO/1JqB3BHKWU66ACfZwNH
N8XKZ9IP8xQwpJ1mCs7O3bc=
=wxnk
-----END PGP SIGNATURE-----

--=-z8V6K1Yk2RT7/irSCJcq--

