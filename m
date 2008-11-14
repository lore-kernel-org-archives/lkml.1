Return-Path: <linux-kernel-owner+w=401wt.eu-S1752832AbYKNCvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbYKNCvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 21:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbYKNCu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 21:50:56 -0500
Received: from ozlabs.org ([203.10.76.45]:38319 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbYKNCuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 21:50:55 -0500
Subject: Re: [PATCH] Store the relevant miscdevice in file->private_data in
 misc_open()
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       viro@zeniv.linux.org.uk
In-Reply-To: <20081114001818.GB20023@kroah.com>
References: <b0f1032863818f2834094e2ca9ce4b1c13122748.1226551772.git.michael@ellerman.id.au>
	 <20081113173127.GB30811@kroah.com> <1226620481.8066.18.camel@localhost>
	 <20081114001818.GB20023@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-qQExm3A4lelkcr0O46kK"
Date: Fri, 14 Nov 2008 13:50:52 +1100
Message-Id: <1226631052.8066.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qQExm3A4lelkcr0O46kK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-13 at 16:18 -0800, Greg KH wrote:
> On Fri, Nov 14, 2008 at 10:54:41AM +1100, Michael Ellerman wrote:
> > On Thu, 2008-11-13 at 09:31 -0800, Greg KH wrote:=20
> > > On Thu, Nov 13, 2008 at 03:49:50PM +1100, Michael Ellerman wrote:
> > > > Currently it's not easy to share file_operations between multiple
> > > > instances of a miscdevice. In order to do this, the device code nee=
ds to
> > > > store a list of all it's miscdevice instances, and when fops->open(=
) is
> > > > called, search the list and find the right device based on the mino=
r
> > > > number.
> > > >=20
> > > > However the generic miscdevice code already has a list of miscdevic=
es,
> > > > and uses this to find the right device in misc_open(). If misc_open=
()
> > > > would store the miscdevice it found in file->private_data, then the
> > > > device code wouldn't need to worry about storing it's own separate =
list
> > > > and searching that as well.
> > > >=20
> > > > The rest of the miscdevice code does not use file->private_data, so=
 the
> > > > device code is still free to use file->private_data for something e=
lse
> > > > if it wants to.
> > > >=20
> > > > Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
> > >=20
> > > Do you have a follow-on patch for some misc device using code that wo=
uld
> > > take advantage of this change?
> >=20
> > Ah, good point. I do, but not for upstream :/
>=20
> Hm, then I have to ask why should we take this change?

Because it's seems like a good idea.

If that's your only objection I'll find some in-tree drivers that can
use it, drivers/char/tpm/tpm.c looks like it could use it for starters.
It's a bit hard to tell but there might be some others.

> And why would the driver not be availble for upstream to take?

Because it's a hacky pile of crud, and it's for unreleased and
non-existent hardware.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-qQExm3A4lelkcr0O46kK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkc54wACgkQdSjSd0sB4dKWZACgh227h1Mektw/GK414oTtQdZp
GfUAnjBSUP3fDdP3un3hwVVSXlpQTxWQ
=jsDn
-----END PGP SIGNATURE-----

--=-qQExm3A4lelkcr0O46kK--

