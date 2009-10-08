Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbZJHJtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbZJHJtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 05:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757154AbZJHJtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 05:49:21 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:48799 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114AbZJHJtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 05:49:19 -0400
Subject: Re: [PATCH] wireless: make WEXT_SPY and WEXT_PRIV select WEXT_CORE
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20091007171235.d40f0cc2.randy.dunlap@oracle.com>
References: <20091007105720.a2457e5b.randy.dunlap@oracle.com>
	 <1254949672-24022-1-git-send-email-linville@tuxdriver.com>
	 <4ACD0E5A.7060106@oracle.com> <1254954842.3713.7.camel@johannes.local>
	 <4ACD1C3D.3030506@oracle.com> <1254957256.3713.10.camel@johannes.local>
	 <20091007171235.d40f0cc2.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dfkZ1gzpcmc9jolCSbew"
Date: Thu, 08 Oct 2009 11:48:02 +0200
Message-Id: <1254995282.3713.18.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dfkZ1gzpcmc9jolCSbew
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-10-07 at 17:12 -0700, Randy Dunlap wrote:

> > > # CONFIG_WIRELESS is not set
> > > CONFIG_WIRELESS_EXT=3Dy
> > > CONFIG_WEXT_SPY=3Dy
> > > CONFIG_WEXT_PRIV=3Dy
> > >=20
> > > WEXT_CORE is not enabled.  I haven't found the culprit, but I suspect=
 "select".
> >=20
> > Interesting.
> >=20
> > > but what in WIRELESS_EXT would also cause WEXT_CORE to be enabled?
> >=20
> > Well, the way WEXT_CORE is defined as def_bool y ought to, no?
>=20
> Ah, I see what you mean.
>=20
> Here's what's happening:
>=20
> net/wireless/Kconfig says:
>=20
> config WEXT_CORE
> 	def_bool y
> 	depends on CFG80211_WEXT || WIRELESS_EXT
>=20
>=20
> and net/Kconfig says:
>=20
> if WIRELESS
>=20
> source "net/wireless/Kconfig"
> source "net/mac80211/Kconfig"
>=20
> endif # WIRELESS
>=20
>=20
> so WEXT_CORE actually depends on NET && WIRELESS && (CFG80211_WEXT || WIR=
ELESS_EXT)
> (that's what xconfig shows me).
> But WIRELESS is not enabled.  Pooh.
>=20
> I was already toying with making CONFIG_WIRELESS a real/usable kconfig sy=
mbol.
> That may have to be done unless someone else comes up with another soluti=
on.

Ah!

It's kinda strange though that you can select wireless drivers without
selecting WIRELESS. Maybe the solution is as simple as making WLAN
(drivers/net/wireless/Kconfig) depend on WIRELESS?

johannes

--=-dfkZ1gzpcmc9jolCSbew
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKzbVPAAoJEODzc/N7+QmakPEP/RMvVJ8rGd03pyvZ9/NjTewZ
l/zyyE6HgrJE+nH73NOVUvF1MjJU/6mfYpvhuiSUozA5thzASE6qYVHwRXsn42KZ
lWN4Be0p8yew/RoVmCT6jqcsKNXfcCr/1bV5esB2UqcdLUiR0urUzAZs25iyPtW0
AXOcG/AxtJkfHp59oqesEixguJ26Soid0C3MHYRW11cW3MwrOBsZbPiplhlWRxDz
k4y7KlknrMCq9gxmA27mqY2VQNgD/TBcR6zeqUYBdnP1uUyW8kKLCU7Q6Y1hvDk6
gbTTHI+5SYeoQiXIE61iq1SYACfuCAb82ZZG9LpTF4D1pn9rcXtAKyQxP7z/VXnm
7XCojJwIlqbTQcK0ItQBH1izfgiYL1k4D7Re2L7cy7w0TwGyjPrGabQBj32V9gXj
eNMdsiE7+EnQ4cMpnqseJMCUjBnjcMZKbzry3LkCIBBv2NpfpVFpjhgdveNTj3pL
/Le/rE8XE//Tl9io2PAbyv/zU+TsvNwxEg3XDzp1TPaa0plyEBiDy+oKEKomgB1A
qHhwbbDJex8HC9NWqvy1ers3q74/uHAjVnKkDsZwN1RBU7a+9YPFVwtfLcvp7vp8
tAcMCrEnxYlroaigKg1yJt6o7oev/eHqpWBlAE0tqiSV5LHy8uTu8gg8AOT8j8oZ
SCNovKR/dHqnAYDcqU6k
=it2l
-----END PGP SIGNATURE-----

--=-dfkZ1gzpcmc9jolCSbew--

