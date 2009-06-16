Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbZFPJEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbZFPJEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbZFPJEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:04:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47813 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbZFPJEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:04:35 -0400
Date: Tue, 16 Jun 2009 11:04:35 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@ozlabs.org,
       "Hans J. Koch" <hjk@linutronix.de>, Magnus Damm <magnus.damm@gmail.com>,
       linuxppc-dev@ozlabs.org, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 2/2] uio: add an of_genirq driver
Message-ID: <20090616090435.GA21321@pengutronix.de>
References: <1244765062-14144-1-git-send-email-w.sang@pengutronix.de> <1244765062-14144-3-git-send-email-w.sang@pengutronix.de> <fa686aa40906140740m43e9dd8am4d242310f681c95c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Content-Disposition: inline
In-Reply-To: <fa686aa40906140740m43e9dd8am4d242310f681c95c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > diff --git a/Documentation/powerpc/dts-bindings/uio-generic.txt b/Docum=
entation/powerpc/dts-bindings/uio-generic.txt
> > new file mode 100644
> > index 0000000..8ad9861
> > --- /dev/null
> > +++ b/Documentation/powerpc/dts-bindings/uio-generic.txt
> > @@ -0,0 +1,16 @@
> > +UIO for custom devices
> > +
> > +A device which will be mapped using the UIO subsystem.
> > +
> > +Properties:
> > + - compatible : should contain the specific model used, followed by
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"generic-uio".
> > + - reg : address range(s) of the device (up to MAX_UIO_MAPS)
> > + - interrupts : interrupt of the device
> > +
> > +Example:
> > + =A0 =A0 =A0 =A0c64fpga@0 {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0compatible =3D "ptx,c64fpga001", "gene=
ric-uio";
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0reg =3D <0x0 0x10000>;
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0interrupts =3D <0 0 3>;
> > + =A0 =A0 =A0 =A0};
>=20
> Hmmm, I'm not happy about this.  The device tree describes the
> hardware, not the way Linux uses the hardware.  UIO definitely falls
> into the category of Linux implementation detail.

Yes, I am aware of that. I just started with the mechanisms which are avail=
able
today and hoped we could find some compatible-value which will suit all nee=
ds.

> This should be approached from the other way around.  Either the
> generic-uio of_platform driver should contain an explicit list of
> devices to be handled by UIO,

Well, that could lead to a quite huge match_table over time.

> or the OF infrastructure should be modified to allow things like force
> binding of_devices to of_drivers at runtime.

That is an interesting idea. I could imagine something like a 'new_compatib=
le"
entry in the sysfs-section of the driver similar to 'new_id' for PCI. After
writing a new compatible-string into it, matching will triggered again with=
 the
new entry added. That could (should?) also be placed at the of-core-level. =
Or
did you have something else in mind?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko3YCMACgkQD27XaX1/VRswtwCcDtPiiseb3Z92cZ6a+o9qGHNi
k+wAnAubWxlG7Oi6ZRW2G0NMueA8Gwsh
=0vEj
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
