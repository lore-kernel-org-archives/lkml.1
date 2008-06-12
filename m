Return-Path: <linux-kernel-owner+w=401wt.eu-S1756165AbYFLRsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbYFLRsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbYFLRsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:48:16 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:43595 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbYFLRsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:48:15 -0400
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240806121039o376b0a8sdfaacf3a1f4a9e57@mail.gmail.com> (sfid-20080612_193929_380411_933B0BEB)
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <20080612093833.0fb9cdd6@bree.surriel.com>
	 <1213278884.3936.15.camel@johannes.berg>
	 <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
	 <1ba2fa240806120935r54a080eci7fa6fafc718eed17@mail.gmail.com>
	 <1213290335.3730.4.camel@johannes.berg>
	 <1ba2fa240806121039o376b0a8sdfaacf3a1f4a9e57@mail.gmail.com>
	 (sfid-20080612_193929_380411_933B0BEB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BF+fs1FX/oiExN6JrGZJ"
Date: Thu, 12 Jun 2008 19:46:52 +0200
Message-Id: <1213292812.3730.21.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BF+fs1FX/oiExN6JrGZJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Well, I disagree, and I'll push my patch as soon as somebody confirms
> > that it doesn't break anything.
>=20
> Remember you are not a maintainer of this driver and second we are
> open to all suggestions you don't have to use this kind of
> statements...

Yeah, you're right, I can't really do that. But I can submit the patch
to akpm, and I'm sure he'll take it after you provide your counter
argument about hope never dying again ;)

Frankly, I don't see why you're so opposed to this patch even if it
doesn't solve anything it probably leads to better code generation and
using a lot less memory.

Also, I know you cannot actually need those descriptors since mac80211
will never ever pass such frames, and _that_ is an area I do have at
least some influence over, so I'll surely notice when that changes.

> >> > There was already discussion on LKML about memory allocation problem=
s
> >> > on X86_64, which might explain this regression. This didn't happen
> >> > before.
> >>
> >> This is  the thread title if you are interested.
> >> 'x86/kernel/pci_dma.c: gfp |=3D __GFP_NORETRY'
> >
> > Like I said, it doesn't matter, there's no need to _waste_
> > 18*256*sizeof(void *) bytes memory.
>=20
> It does matter this is not pci allocation we are saving in your patch.

Well, thing is, my patch saves 18 KiB memory on 32-bit and 36 on 64-bit,
so I think we should merge it regardless. Yes, the pci allocation is
icky, and yes, it would be good to just do it once instead of over and
over again, but even if you change it to do _all_ those allocations just
once we should not be wasting those 18/36 KiB memory for nothing.

johannes

--=-BF+fs1FX/oiExN6JrGZJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUWEIAAoJEKVg1VMiehFYt5wP/3ihVajpphGmwYsZI5oDSZz5
vNQvadTdhlx7wIN+0JK4ji28BrpP6iaggRshEJ+c1ltnVk4rijQ+k/DBxFqiOCj9
jgycCoWARWUa2IG8QjlYcgVzr7JKnifY9O+MQZsHtwKaFcA+ywaaMvpLh4Cxsouh
cIWoRFKtOrx8cUGfbzyfZ/Ja1ucweQxjJq4nCkdX0on+FNJsperkVYf32cSU0FRN
h2xU++YuUZpLGtIyUcmcO+bp5Nv7+HEm1620fPLbXc6O2dHTnWsHcwPEQqNL9Ijn
MgnKnD662NPQTY/HFX3xr4OAk+OYIf6sMSvicby0GAXVUadW6/vQUF+sgx7YCJFg
TyuP+WX0lUz+c9WMSKIU993Md9+Ws36ILzsRAzhWA52nfbUKRLa/bKjOtMk0+927
w471gxKVUzhjZUFr7V1gtuWj2zhb/I5SpweHrqV08crCzDuV37xvzHDwchAVZ5Lo
OmRi6EkjanWO1W6v3QXVDvlVHJvGCHz0QNWbnpUvBbjkGEl44gaEKmb64700Qesp
JHV94LZ8u/8Gey4wb6izj5XQlIJg1wO+2AmQYKapN6TjAr4rCHbBrycZTIgj/hX4
PXtyD4V1o+b1nxu6SwZmvuhHURsqM3JHPjiPk/DgNx7COVw7oqUgYKX+U9V8RUp/
cEV6OqvYT3GSDjluFQlC
=ISpm
-----END PGP SIGNATURE-----

--=-BF+fs1FX/oiExN6JrGZJ--

