Return-Path: <linux-kernel-owner+w=401wt.eu-S965412AbXCGRKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965412AbXCGRKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:10:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965380AbXCGRKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:10:23 -0500
Received: from systemlinux.org ([83.151.29.59]:56992 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422750AbXCGRKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:10:22 -0500
Date: Wed, 7 Mar 2007 18:09:55 +0100
From: Andre Noll <maan@systemlinux.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: qla2xxx BUG: workqueue leaked lock or atomic
Message-ID: <20070307170955.GA4252@skl-net.de>
References: <20070226133153.GC4095@skl-net.de> <20070226182617.GC9968@andrew-vasquezs-computer.local> <20070227101100.GA22572@skl-net.de> <20070227185134.GJ20397@andrew-vasquezs-computer.local> <20070228151829.GI22572@skl-net.de> <20070228153722.GJ22572@skl-net.de> <20070306203952.471218df.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <20070306203952.471218df.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 20:39, Andrew Morton wrote:
> On Wed, 28 Feb 2007 16:37:22 +0100 Andre Noll <maan@systemlinux.org> wrot=
e:
>=20
> > On 16:18, Andre Noll wrote:
> >=20
> > > With 2.6.21-rc2 I am unable to reproduce this BUG message. However,
> > > writing to both raid systems at the same time via lvm still locks up
> > > the system within minutes.
> >=20
> > Screenshot of the resulting kernel panic:
> >=20
> > 	http://systemlinux.org/~maan/shots/kernel-panic-21-rc2-huangho2.png
> >=20
>=20
> It died in CFQ.  Please try a different IO scheduler.  Use something
> like
>=20
> 	echo deadline > /sys/block/sda/queue/scheduler
>=20
> This could still be the old qla2xxx bug, or it could be a new qla2xxx bug,
> or it could be a block bug, or it could be an LVM bug.

OK. I'm running with deadline right now. But I guess this kernel
panic was caused by an LVM bug because lockdep reported problems with
LVM. Nobody responded to my bug report on the LVM mailing list (see
http://www.redhat.com/archives/linux-lvm/2007-February/msg00102.html).

Non-working snapshots and no help from the mailing list convinced me
to ditch the lvm setup [1] in favour of linear software raid. This
means I can't do lvm-related tests any more.

BTW: Are ext3 filesystem sizes greater than 8T now officially
supported?

Thanks
Andre

[1] vg of two hardware raids, 10T together, a single lv and some snapshots
--=20

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFF7vHjWto1QDEAkw8RAkZdAKCRiDjS3z62bHLfHqhbCDbBgTgJYwCfSA9O
Chbn1P57DdIY8mvJ781K5rg=
=EJJc
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
