Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbYKNE7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbYKNE7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 23:59:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbYKNE6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 23:58:40 -0500
Received: from ozlabs.org ([203.10.76.45]:57655 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbYKNE6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 23:58:39 -0500
Subject: Re: [PATCH] Store the relevant miscdevice in file->private_data in
 misc_open()
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       viro@zeniv.linux.org.uk
In-Reply-To: <20081114032313.GB15204@kroah.com>
References: <b0f1032863818f2834094e2ca9ce4b1c13122748.1226551772.git.michael@ellerman.id.au>
	 <20081113173127.GB30811@kroah.com> <1226620481.8066.18.camel@localhost>
	 <20081114001818.GB20023@kroah.com> <1226631052.8066.25.camel@localhost>
	 <20081114032313.GB15204@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jFniefQ9opXOYqRhWLuQ"
Date: Fri, 14 Nov 2008 15:58:35 +1100
Message-Id: <1226638715.8066.34.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jFniefQ9opXOYqRhWLuQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-13 at 19:23 -0800, Greg KH wrote:
> On Fri, Nov 14, 2008 at 01:50:52PM +1100, Michael Ellerman wrote:
> > On Thu, 2008-11-13 at 16:18 -0800, Greg KH wrote:
> > > On Fri, Nov 14, 2008 at 10:54:41AM +1100, Michael Ellerman wrote:
> > > > On Thu, 2008-11-13 at 09:31 -0800, Greg KH wrote:=20
> > > > > On Thu, Nov 13, 2008 at 03:49:50PM +1100, Michael Ellerman wrote:
> > > > > > Currently it's not easy to share file_operations between multip=
le
> > > > > > instances of a miscdevice. In order to do this, the device code=
 needs to
> > > > > > store a list of all it's miscdevice instances, and when fops->o=
pen() is
> > > > > > called, search the list and find the right device based on the =
minor
> > > > > > number.
> > > > > >=20
> > > > > > However the generic miscdevice code already has a list of miscd=
evices,
> > > > > > and uses this to find the right device in misc_open(). If misc_=
open()
> > > > > > would store the miscdevice it found in file->private_data, then=
 the
> > > > > > device code wouldn't need to worry about storing it's own separ=
ate list
> > > > > > and searching that as well.
> > > > > >=20
> > > > > > The rest of the miscdevice code does not use file->private_data=
, so the
> > > > > > device code is still free to use file->private_data for somethi=
ng else
> > > > > > if it wants to.
> > > > > >=20
> > > > > > Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
> > > > >=20
> > > > > Do you have a follow-on patch for some misc device using code tha=
t would
> > > > > take advantage of this change?
> > > >=20
> > > > Ah, good point. I do, but not for upstream :/
> > >=20
> > > Hm, then I have to ask why should we take this change?
> >=20
> > Because it's seems like a good idea.
>=20
> You know we don't make changes to core code for drivers that aren't in
> the main tree, this is not a new thing...

Sure. I'm not asking you to.

It seemed clear to me that this was a sensible thing for the misc device
infrastructure to do, but if you disagree that's fine.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-jFniefQ9opXOYqRhWLuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkdBXsACgkQdSjSd0sB4dKZHwCfaA4CuspePULZP726o8JfY0XI
0FAAni3LwUqCTHPtqncCYPP5Sw5hwz2X
=nSay
-----END PGP SIGNATURE-----

--=-jFniefQ9opXOYqRhWLuQ--

