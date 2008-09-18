Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYIRRw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYIRRw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 13:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbYIRRwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 13:52:46 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:34948 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbYIRRwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 13:52:45 -0400
Subject: Re: [PATCH] rfkill: clarify usage of rfkill_force_state() and
	rfkill->get_state()
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       John Linville <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <200809181932.58272.IvDoorn@gmail.com> (sfid-20080918_193303_254045_21E4A027)
References: <20080918145236.GJ1583@khazad-dum.debian.net>
	 <20080918164339.GM1583@khazad-dum.debian.net>
	 <1221756339.9262.86.camel@johannes.berg>
	 <200809181932.58272.IvDoorn@gmail.com>
	 (sfid-20080918_193303_254045_21E4A027)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OpAjM+CDNfu63+h2Rlou"
Date: Thu, 18 Sep 2008 19:52:08 +0200
Message-Id: <1221760328.9262.94.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OpAjM+CDNfu63+h2Rlou
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-18 at 19:32 +0200, Ivo van Doorn wrote:

> Ideal situation would indeed be that mac80211 registers a rfkill structur=
e
> and listens to rfkill events. This would help drivers by only needing to
> register a rfkill structure for state-change events without any need for
> listeners.

Yup.

> I was considering such a patch some time ago, but needed to figure out
> how to work with the state-override capabilities (HW_BLOCK and SOFT_BLOCK=
)
> and didn't work on it any further since.

So make the struct part of the hw structure? Then drivers can just use
that to force hard events. Or actually, no, don't do this, make a new
mac80211 call:

	ieee80211_inform_hardblocked(BLOCK/OPEN)

which makes sure we can also try to not associate in this case in the
future...

johannes

--=-OpAjM+CDNfu63+h2Rlou
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0pVFAAoJEKVg1VMiehFYrhYQALLn51lBD5EmMQ5vrFWBmWNE
ewpcsuux0bdGbmxQlTX+37WhgXMLU2XccP9gnXksiJpIb7YK4+7AV4JU8/U90fku
XRd+G+xrBswzm0yM4bQfCvbeIJgmSMfRn71hCyKT+x9BPxf+zUBcXthmvV2d0B45
CKBzcIjrJ1KVu0av82xLXRPi9MyPtRJPSN4fwO/ZJsUIbSqhTkip5pCSM7mlY5Iw
huCLC/Kx03trWXlGSmdLsDEYlFm58ge0G7zMcPD5reX+zfU0yqiMYwfjqypl2w0g
Pc1SyoaZ7lC+NZT4kTT7mCUc/ZnIMh1VxgfdvpuHmI7i03BVrpvKY+FSqjScF1Kn
Xjtmtqg9aral+FZQOe+rN2u4x2WkTN4rlKKNR1NmaxzhWx0v3vMNdDj2KmyeRDwy
zJibmqYyetSzlbOQxPwZ7NDumyBo6aq+BJhYWdTiDWsWVp1rhrZA/I7zsWiTgRpI
HVZ2/sa5RELY632+fUekoVGtKxtGbbj+VfIfpJ+/sQSOBZVTsvYsFbAKE7mGCkNq
RhWYEfw5GGNo81MjZ9t9EAFihfw5p0INAMkvW7kfbU1jbjDWCOxgQs7F0DIetPcH
842hQnCRkedjrwTWja9z3KQTtZTLLGqFXBqCzDc2waTcjtkQd3hfDlHwYUGfV3mI
HMduKwLD9tNG+/Y0eoo1
=LKX0
-----END PGP SIGNATURE-----

--=-OpAjM+CDNfu63+h2Rlou--

