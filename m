Return-Path: <linux-kernel-owner+w=401wt.eu-S1762011AbXGDN73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762011AbXGDN73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 09:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759364AbXGDN7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 09:59:21 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:49699 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759122AbXGDN7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 09:59:20 -0400
Subject: Re: [RFC/PATCH] debug workqueue deadlocks with lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Sattler <tsattler@gmx.de>
In-Reply-To: <20070704122159.GA21813@elte.hu>
References: <1182969638.4769.56.camel@johannes.berg>
	 <1183048429.4089.1.camel@johannes.berg>
	 <1183052001.4089.2.camel@johannes.berg> <1183190728.7932.43.camel@earth4>
	 <20070630114658.GA344@tv-sign.ru> <1183381393.4089.117.camel@johannes.berg>
	 <20070703173112.GA108@tv-sign.ru> <1183549772.3812.10.camel@johannes.berg>
	 <20070704122159.GA21813@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rIGjZruKXStOknjyWCV3"
Date: Wed, 04 Jul 2007 15:59:54 +0200
Message-Id: <1183557594.3812.29.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rIGjZruKXStOknjyWCV3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-07-04 at 14:21 +0200, Ingo Molnar wrote:

> well, in this case the lock/unlock should nest perfectly (i.e. it should=20
> always be balanced perfectly), so indeed calling with nested=3D=3D1 leads=
 to=20
> stricter checking.
>=20
> non-nested unlocks occur when people do stuff like:
>=20
> 	spin_lock(&lock1);
> 	spin_lock(&lock2);
> 	spin_unlock(&lock1);
> 	spin_unlock(&lock2);
>=20
> the first unlock is not 'nested perfectly'. Now for the workqueue=20
> dep_map this shouldnt be a legal combination, right?

I don't think so, will change to use nested=3D=3D1.

johannes

--=-rIGjZruKXStOknjyWCV3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGi6fa/ETPhpq3jKURAiowAJwIVgAhX8IH9prYRp3w5LLeAvO7owCeKYRC
j3r0BA8ruLbDjyAm9hrYabk=
=Ei2t
-----END PGP SIGNATURE-----

--=-rIGjZruKXStOknjyWCV3--

