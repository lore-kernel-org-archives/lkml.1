Return-Path: <linux-kernel-owner+w=401wt.eu-S1752803AbYJ0SpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbYJ0SpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 14:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYJ0So6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 14:44:58 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:56649 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYJ0So5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 14:44:57 -0400
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
From: Johannes Berg <johannes@sipsolutions.net>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Carlos R. Mafra" <crmafra2@gmail.com>,
       linux-kernel@vger.kernel.org, tomas.winkler@intel.com,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
In-Reply-To: <1225132278.3796.32.camel@johannes.berg> (sfid-20081027_193136_021274_A4C6EBE7)
References: <20081027162054.GA4015@localhost.aei.mpg.de>
	 <200810271832.40717.rjw@sisk.pl>  <1225130844.4466.0.camel@localhost>
	 <1225132278.3796.32.camel@johannes.berg>
	 (sfid-20081027_193136_021274_A4C6EBE7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Q3YMf2nMgym+0ZgF+yhm"
Date: Mon, 27 Oct 2008 19:44:42 +0100
Message-Id: <1225133082.3796.35.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Q3YMf2nMgym+0ZgF+yhm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 19:31 +0100, Johannes Berg wrote:
> On Mon, 2008-10-27 at 19:07 +0100, Soeren Sonnenburg wrote:
>=20
> > > Johannes, can you pls have a look?
>=20
> I did, and I have no idea. Makes no sense at all.

The only thing I can remotely think of is that iwlwifi doesn't like
being called back from within the call that it did to mac80211, which
obviously happens here. But I have no idea, the code as it stands is
correct, just the interaction with iwlwifi's resume seems to be broken.

Try this patch instead:

--- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-10-27 19:44=
:12.000000000 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-10-27 19:44:15.0=
00000000 +0100
@@ -2084,7 +2084,6 @@ static void iwl_alive_start(struct iwl_p
 		iwl4965_error_recovery(priv);
=20
 	iwl_power_update_mode(priv, 1);
-	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);
=20
 	if (test_and_clear_bit(STATUS_MODE_PENDING, &priv->status))
 		iwl4965_set_mode(priv, priv->iw_mode);


johannes

--=-Q3YMf2nMgym+0ZgF+yhm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBgwTAAoJEKVg1VMiehFY2b4QAL/H1+ky6uzZZ7mCSrVt19U8
JomwyBUfGemGrWpUddupLGuwbwU39qMKQUopi+PWCkY7u2mH/ML15Sg6efHM+ytQ
X6FEvbTOyDo68JeqJBQZJgnjFiefdUs0vVfso28Fr/CITVhtl/O1ix3tet5ZQDpe
GLzOt0t++oAC+LFqX8q6b7UB8/pIpO1uYEzR8XigUnLpNI42WPze4jWSfFWB+6/c
qKcilG5dAHmzzwv3J7Qp+5+MoqbDuGQCsa4HbpR07OF69ZGYrFhZ1DN7Ps3VkM54
LOYrSRP/0w+9hKA7XyMXI7hDQT3BPPGYCae5sIN5lQ9zWSutv8ZHfyEcOCvKJCyu
tHF3wrT3ArtMqPi/nVdO394HZvKjJJrMDmaN1gttyGY/IHvdGU2s26uCvtPsBygb
AKREhODpWF0Yv9NuY5N4LdMJvA8zbfxuXf78Ae1epKCTw7up+ViHlD5erhl6kP5f
h6WZGAWhIqcXi8k0plkvJ3SOl+bxK00gQWsPUIHY6btowK8tWRGcy/iSeSkNz3ZD
J2zaU/Wk4AX92zgEFH8N83Rl6KE1xHCwUFc9YnYjS7CGJOcYGv9fXYJMA3Vq4CmZ
i5uVjQDMqsH4u8ntWuPGwDbpAc1uChG3EPHNSdpJhlIA/dtuqibMjC8EwB4sBuXy
G/5o68rFs0bWmDC1xMut
=O046
-----END PGP SIGNATURE-----

--=-Q3YMf2nMgym+0ZgF+yhm--

