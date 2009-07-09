Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbZGIU2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbZGIU2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 16:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZGIU23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 16:28:29 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:48649 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715AbZGIU22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 16:28:28 -0400
Subject: Re: [Bug #13337] [post 2.6.29 regression] hang during suspend of
 b44/b43 modules
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jan Scholz <scholz@fias.uni-frankfurt.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Tomas Janousek <tomi@nomi.cz>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200907092203.10294.rjw@sisk.pl>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera>
	 <87k52izvd9.fsf@scholz.fias.uni-frankfurt.de>
	 <87y6qxx50z.fsf@scholz.fias.uni-frankfurt.de>
	 <200907092203.10294.rjw@sisk.pl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-shEOJwFrNPyKLFJKtUGa"
Date: Thu, 09 Jul 2009 22:28:15 +0200
Message-Id: <1247171295.1905.5.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-shEOJwFrNPyKLFJKtUGa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-09 at 22:03 +0200, Rafael J. Wysocki wrote:
> On Thursday 09 July 2009, Jan Scholz wrote:
> > Hi,
> >=20
> > I have just checked this on v2.6.31-rc1 and v2.6.31-rc2-214-g34f2547
> > (I wanted to test this on v2.6.31-rc2 as well, but there I had other
> > suspend-issues that are fixed in todays v2.6.31-rc2-214-g34f2547)
> >=20
> > For both v2.6.31-rc1 and v2.6.31-rc2-214-g34f2547 suspend to ram fails
> > with the test procedure described below, but it works fine when I rever=
t
> > commit 5bb644a0fd25a5e083ecbfaa92a211db99aa6ef7
> >  "mac80211: cancel/restart all timers across suspend/resume"
>=20
> Thanks for the update.
>=20
> Johannes, do you have any idea what can go wrong here?

Not really, no. __ieee80211_suspend isn't holding any locks that the
cancel_work_sync() calls could require or so afaict...

Jan, can you run with console_suspend=3D0 (or whatever it is now, Rafael
will correct me if I'm wrong) that should work on your platform, and put
a bunch of printk calls into __ieee80211_suspend in net/mac80211/pm.c to
see where in there it's hanging?

johannes

--=-shEOJwFrNPyKLFJKtUGa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKVlLbAAoJEODzc/N7+QmapEkQAK43v0yRDF1wejBeapqKy1G6
zkAl5hVLHXVLW9C0asv9OBocJuU0GcoLPkqTP7bLxOQfw8fWk6FB54AI6TTOAuyn
EBVKBs5wSfDBBN8BQp6VH+rkS96o4lzoNaTG5GY6unV7TE1fD4dRdnuNRDpjlbbe
LGZweIpFQTnbt9Z81omxYGjzb8jG4CKQUMOL+5Yy2HReGndU2HMsK9mR734oQOgO
ID6kJpQZqZ58B6RjYjkUIZBT97kwxhWBHTQtQoYtBBfa5/vOozitDsyOTcMXKnJP
3uYxRkgxJDBrVYn6DcxAiVVcuWbg5x+W2u3Re9/ro4zuOMoIoUljPZiDcTYyGwnq
zNih18giJrO/3BeiYOIi5ArPQ4VsxQBfSnixxzPSM9z2SBoj6/G+SmgDZYvrdyhg
eQk/LR/OpbyYMkBPvIc7L96XA9T/l1isqDVMl7ozd5cqcnBPOw2W0ZdgwxgAknaa
CO8z2AkqH/yFsWnFKd2sLhe34w3kafLydDscZNGCgk0HOFnb8LJ9f7qY0qpL1H9d
CXkpce5YWMJpL1WHDiTtmYzoMNoe6VejX5TGSNzmI5nVPGzNdAqiQ5alYdyVqttN
BMzNhov4FFjTeocr9/xQ5Gj0m6Bau/8HwXAce0u/PfxD/8uuYP2NVJUvnLiXACpE
42sBYY7gQvF2p+c7HPKz
=izeP
-----END PGP SIGNATURE-----

--=-shEOJwFrNPyKLFJKtUGa--

