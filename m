Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbZJPLhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbZJPLhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 07:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbZJPLhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 07:37:39 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:58332 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255AbZJPLhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 07:37:39 -0400
Subject: Re: 2.6.32-rc4-git1 -- INFO: possible circular locking dependency 
 detected
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <a44ae5cd0910120528h6d8992fcn8b6592ee799fbfc5@mail.gmail.com>
References: <a44ae5cd0910120528h6d8992fcn8b6592ee799fbfc5@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wJ+m0/k2xVvRI81sFF4K"
Date: Fri, 16 Oct 2009 18:34:19 +0900
Message-Id: <1255685659.4095.312.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wJ+m0/k2xVvRI81sFF4K
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-10-12 at 08:28 -0400, Miles Lane wrote:
> [  823.466853] [ INFO: possible circular locking dependency detected ]
> [  823.466866] 2.6.32-rc4-git1 #2
> [  823.466873] -------------------------------------------------------
> [  823.466884] swapper/0 is trying to acquire lock:
> [  823.466893]  (&sta->lock){+.-...}, at: [<f857bda4>] sta_addba_resp_tim=
er_expired+0x1b/0x50 [mac80211]
> [  823.466940]
> [  823.466943] but task is already holding lock:
> [  823.466953] (&sta->ampdu_mlme.tid_tx[tid]->addba_resp_timer){+.-...}, =
at: [<c1032f22>] run_timer_softirq+0x125/0x1e5
> [  823.466984]
> [  823.466987] which lock already depends on the new lock.

Thanks for the report, I'll have to take a look at it, but this appears
to be due to the del_timer_sync() in ieee80211_process_addba_resp().

Guess it never really happens that the AP doesn't respond quickly enough
so the timer hardly fires.

johannes

--=-wJ+m0/k2xVvRI81sFF4K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK2D4YAAoJEODzc/N7+QmaklYQAMvItHFtEMIE96i4YvL8j0Cy
G/NaSu008oyDhEvukvUET0vCUwnDx/jTAI9VvrNsPhms2MAC9H+Z7cgt/1YWLCi+
5/tT7q5W0vaHDH1iIK9xsCOjpv8xFO2mJ1nFeCXhAEGCNCxOL+DijQKickIBdR5J
icAtmUQWDADvq2146jSsuzDcAahAWhrZbSP0kiRfpXi7NXTa5I74uo4lJhB0RdtZ
jApqoULtLeX6UsekQazviOaanMFwXBqltlGlOOsm3odtHILqo4nHS5/xGwBeSm+S
LQGt0LyA6Q4clp2pFsmV6y4hpor7e+jxZeIZlxjRlqLpPul9LFrtlZcHiMjxoh0d
c2wND70sqfKtjZ5/Lkr24L+wV/lLsnDbilMZJwrUcoEO3K+ZflupRDTSHfMNB1l/
2wbzRJfv5qZvkTvxPoFIn6DxLTa/VKASSL0uGz+uO1GnUzWTzAToTyR9ATcDfStM
OC6qWcifiX4tELfja+YTJ6OYutrHoJ8mYwMWllyF2k6rsQbBK4yNk1ckQnzsXhvS
j0rIw48JKwIl3O09TaSwgc5cf8SUASjECedSuCACzzfE08B7h2EmutUE9uA686Cu
F+iU0mGxeqkUe4bjeKtWigBUM4pOqRLYrIYxCEvT9+zjKZC0s5pcHG9NclrgW+yY
mIDjjxW9HMaZWoiOMBFN
=4jLj
-----END PGP SIGNATURE-----

--=-wJ+m0/k2xVvRI81sFF4K--

