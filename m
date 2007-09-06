Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbXIFMnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbXIFMnn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 08:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbXIFMnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 08:43:33 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:54710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbXIFMnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 08:43:32 -0400
Subject: Re: BUG: scheduling while atomic: ifconfig/0x00000002/4170
From: Johannes Berg <johannes@sipsolutions.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: satyam@infradead.org, flo@rfc822.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       michal.k.k.piotrowski@gmail.com, ipw3945-devel@lists.sourceforge.net,
       yi.zhu@intel.com, flamingice@sourmilk.net
In-Reply-To: <E1ITGb2-0006Be-00@gondolin.me.apana.org.au>
References: <E1ITGb2-0006Be-00@gondolin.me.apana.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LWtdbtBJirb3aZ2jyNYY"
Date: Thu, 06 Sep 2007 14:44:45 +0200
Message-Id: <1189082685.28781.70.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LWtdbtBJirb3aZ2jyNYY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-06 at 20:36 +0800, Herbert Xu wrote:
> Johannes Berg <johannes@sipsolutions.net> wrote:
> >
> > Hah, I suspected as much but didn't have a chance to look yet. I had
> > plans to replace that sub_if_list with an RCU list and not require the
> > lock there, but that's far off. Any ideas how to fix this? We can't
> > reject the master stop so we have to walk the list, I guess we'll have
> > to audit the other list manipulation places, I think they're all under
> > RTNL.
>=20
> Yeah I think they're all under RTNL too.  So you don't need to
> take the lock here at all since you should already have the RTNL.

I'll take a look at them and post appropriate patches.

johannes

--=-LWtdbtBJirb3aZ2jyNYY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3/Y9/ETPhpq3jKURAvLjAKCFSRyi4Ij0UTiBFZ/CyT1nxeIqqQCcCaaT
JOrgWZa3EoGGNxK7mFGN0KA=
=e5W9
-----END PGP SIGNATURE-----

--=-LWtdbtBJirb3aZ2jyNYY--

