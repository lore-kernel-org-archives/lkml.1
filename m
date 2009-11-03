Return-Path: <linux-kernel-owner+w=401wt.eu-S1754629AbZKCRcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629AbZKCRcG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 12:32:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbZKCRcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 12:32:06 -0500
Received: from smtp-out26.alice.it ([85.33.2.26]:4478 "EHLO
	smtp-out26.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbZKCRcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 12:32:02 -0500
Date: Tue, 3 Nov 2009 18:31:54 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       openezx-devel@lists.openezx.org, Samuel Ortiz <sameo@linux.intel.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Mike Rapoport <mike@compulab.co.il>, Daniel Ribeiro <drwyrm@gmail.com>
Subject: Re: Using statically allocated memory for platform_data.
Message-Id: <20091103183154.ee6b5676.ospite@studenti.unina.it>
In-Reply-To: <20091102164743.GE23772@trinity.fluff.org>
References: <20091102112316.16163f6a.ospite@studenti.unina.it>
	<20091102150011.GB20341@fluff.org.uk>
	<20091102150525.GB5785@n2100.arm.linux.org.uk>
	<20091102152500.GD23772@trinity.fluff.org>
	<20091102155231.GC20341@fluff.org.uk>
	<20091102155625.GC5785@n2100.arm.linux.org.uk>
	<20091102162839.GD20341@fluff.org.uk>
	<20091102163701.GD5785@n2100.arm.linux.org.uk>
	<20091102164743.GE23772@trinity.fluff.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i686-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__3_Nov_2009_18_31_54_+0100_fA8IwgmBdhTHrE9g"
X-OriginalArrivalTime: 03 Nov 2009 17:32:04.0693 (UTC) FILETIME=[8F4E8050:01CA5CAB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Nov_2009_18_31_54_+0100_fA8IwgmBdhTHrE9g
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Nov 2009 16:47:44 +0000
Ben Dooks <ben-linux@fluff.org> wrote:

> On Mon, Nov 02, 2009 at 04:37:01PM +0000, Russell King - ARM Linux wrote:
> > On Mon, Nov 02, 2009 at 04:28:39PM +0000, Ben Dooks wrote:
> > > On Mon, Nov 02, 2009 at 03:56:25PM +0000, Russell King - ARM Linux wr=
ote:
> > > > The reason we have platform_device_add_data() is that people think =
that
> > > > the device data needs to persist for the lifetime of the device.  I
> > > > personally disagree with that - once you unregister the device, it's
> > > > guaranteed that device drivers will have been unregistered, so who's
> > > > going to use the platform data?
> > >=20
> > > That doesn't make any sense, in the current case of using the
> > > platform_device_alloc() and those calls the data is only living
> > > for the lifetime of the device, as the release call is tidying up
> > > the result.
> >=20
> > What I'm saying is that the lifetime of the data finishes once
> > the _unregister() call has returned.  So:
> >=20
> > 	data =3D pdev->dev.platform_data;
> > 	platform_device_unregister(pdev);
> > 	kfree(data);
> >=20
> > is an entirely valid way of handling the "I allocated my platform
> > data" problem - it doesn't need to exist to the point where the
> > device itself is freed.
>=20
> Unforutnately pretty much everyone now assumes that the act of
> unregistering the device will get rid of the data that the allocated
> by the add functions.
>=20
> This would mean going around fixing a number of current drivers which
> all make that assumption.
>=20

So those drivers (ezx-pcap.c, da903x.c) aren't doing anything manifestly
wrong by not calling platform_device_add_data(), and the issue will be
solved in ./drivers/base/platform.c someway eventually, right?

Thanks,
   Antonio

--=20
Antonio Ospite
http://ao2.it

PGP public key ID: 0x4553B001

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

--Signature=_Tue__3_Nov_2009_18_31_54_+0100_fA8IwgmBdhTHrE9g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrwaQoACgkQ5xr2akVTsAENtwCeIKBjlnThNoBCylhKGLE/KF5u
1bUAn0WUtE1zmozdSJGgoQ+j5+0SiGEL
=oesi
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Nov_2009_18_31_54_+0100_fA8IwgmBdhTHrE9g--
