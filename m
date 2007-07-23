Return-Path: <linux-kernel-owner+w=401wt.eu-S1763483AbXGWXDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763483AbXGWXDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 19:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbXGWXC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 19:02:58 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:40073 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751603AbXGWXC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 19:02:58 -0400
X-Sasl-enc: K4njDdx+WPjdwnLtFQGNnlIswoNoHE3QoHvzNLmtn790 1185231776
Message-ID: <46A53396.2060902@imap.cc>
Date: Tue, 24 Jul 2007 01:02:46 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: LKML <linux-kernel@vger.kernel.org>, andi@firstfloor.org,
       nix.or.die@googlemail.com, Roland McGrath <roland@redhat.com>
Subject: Re: 2.6.22-git17 boot failure
References: <46A3EC92.3050504@imap.cc> <46A3FBB7.9000608@imap.cc> <46A46BF9.6010906@goop.org> <46A481FD.2030607@imap.cc> <46A4C081.6070305@goop.org> <46A504A3.3070205@imap.cc> <46A51079.5030006@goop.org>
In-Reply-To: <46A51079.5030006@goop.org>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8A5EB75BD5E62C1D71AD42D5"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8A5EB75BD5E62C1D71AD42D5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 23.07.2007 22:32 schrieb Jeremy Fitzhardinge:
> How much of this is modules?  Is the initrd probing for scsi/sata?=20
> Maybe the the vdso change is having an effect.

Pretty much all of it is modules. The base system is openSUSE 10.2, and
SuSE has a long habit of building everything as modules and putting the
drivers needed for accessing the root filesystem into an initrd. I have
fought it for a while but nowadays I'm playing along.

So yes, all of ahci, pata_marvell, aic7xxx, jbd, dm_mod, ext3 are in
fact modules in initrd. Would it help to try a kernel with some or all
of these built in?

> Ooh, wait.  Do you have an old version of the Xen patches in place,
> perhaps?

In which place? I installed and successfully ran the Xen packages that
came with openSUSE 10.2, so there is a 2.6.18 kernel with SuSE's Xen
patches on the machine. But that shouldn't have any influence on the
kernel.org kernels I build myself, should it?

>  Does drivers/block/Makefile have:
>=20
> obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+=3D xen-blkfront.o
>=20
> (vs :=3D xen-blkfront.o)

It has the "+=3D" variant.

> Could you do a before and after booting with initcall_debug=3D1?

"Before" and "after" meaning with CONFIG_XEN=3Dn and CONFIG_XEN=3Dy, I
suppose. The resulting logs are a bit biggish, so I have put them on
http://www.phnxsoft.com/~ts/linux/ for download. Let me know if you
prefer having them mailed.

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig8A5EB75BD5E62C1D71AD42D5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGpTOeMdB4Whm86/kRApv+AJ9iGDhrH6im5s7V6LVTrm/Gpfz1BQCeNrD3
P3oqem4axB507zUHjO9MDO4=
=Nm2M
-----END PGP SIGNATURE-----

--------------enig8A5EB75BD5E62C1D71AD42D5--
