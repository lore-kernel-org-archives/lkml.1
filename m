Return-Path: <linux-kernel-owner+w=401wt.eu-S1753419AbYJ0TDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbYJ0TDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbYJ0TD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:03:27 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:53317 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYJ0TD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:03:26 -0400
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: Soeren Sonnenburg <kernel@nn7.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, tomas.winkler@intel.com,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
In-Reply-To: <20081027190011.GA3951@localhost.aei.mpg.de>
References: <20081027162054.GA4015@localhost.aei.mpg.de>
	 <200810271832.40717.rjw@sisk.pl> <1225130844.4466.0.camel@localhost>
	 <1225132278.3796.32.camel@johannes.berg>
	 <1225133082.3796.35.camel@johannes.berg>
	 <20081027190011.GA3951@localhost.aei.mpg.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dpJMs2MMxba3zMyCoiIA"
Date: Mon, 27 Oct 2008 20:03:15 +0100
Message-Id: <1225134195.3796.39.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dpJMs2MMxba3zMyCoiIA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 20:00 +0100, Carlos R. Mafra wrote:
> On Mon 27.Oct'08 at 19:44:42 +0100, Johannes Berg wrote:
> > On Mon, 2008-10-27 at 19:31 +0100, Johannes Berg wrote:
> > > On Mon, 2008-10-27 at 19:07 +0100, Soeren Sonnenburg wrote:
> > >=20
> > > > > Johannes, can you pls have a look?
> > >=20
> > > I did, and I have no idea. Makes no sense at all.
> >=20
> > The only thing I can remotely think of is that iwlwifi doesn't like
> > being called back from within the call that it did to mac80211, which
> > obviously happens here. But I have no idea, the code as it stands is
> > correct, just the interaction with iwlwifi's resume seems to be broken.
> >=20
> > Try this patch instead:
>=20
> Yep, with this patch it also works!

> > --- everything.orig/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-10-27 1=
9:44:12.000000000 +0100
> > +++ everything/drivers/net/wireless/iwlwifi/iwl-agn.c	2008-10-27 19:44:=
15.000000000 +0100
> > @@ -2084,7 +2084,6 @@ static void iwl_alive_start(struct iwl_p
> >  		iwl4965_error_recovery(priv);
> > =20
> >  	iwl_power_update_mode(priv, 1);
> > -	ieee80211_notify_mac(priv->hw, IEEE80211_NOTIFY_RE_ASSOC);

alright, well, if nothing else turns up soon then we should probably put
this patch in rather than reverting the other one, imho mac80211 is
doing the right thing there and the driver is calling into it at a point
where either mac80211 or the driver cannot handle it.

Do you get any kernel messages output? If you do, could you put messages
into each line of ieee80211_set_disassoc to see where it hangs?

johannes

--=-dpJMs2MMxba3zMyCoiIA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBhBwAAoJEKVg1VMiehFYBtEP/3qMrIKq1nnROC8GlJPgru1z
KzEUKZqhM3XbVfbsYIeYnvy1VeciMVr1Rtlz5lxGbyMiP/bagCiXp+yNnSo5+JfY
qvG1OR+lSsIEPzGQ8kigk54wD/uYshTpsf1jYu6SIcS4y+Ojkyva/dSozfjapq2I
WyxQ+cscuM/2iGkHYZXVsRM547H8F22GTpGblQxHh/PIpkfoZqFCTWkWee/HG3rZ
CJpaVRb/QfJb5lDO6CIDbWXlKe2FeNZqyc/Y+r6aNHMletQzUHTwtLF1ghFPWsZP
3HoGv3O0afze/KRAr5TwknjddWkOpnJEPtPFjqfybyf8SHVsvkktmvPQi8XqnlsH
OZCCIkixZUE0YeGmxW8SUHSPqpQMTSrpFjAdlEf6PmVNs9T31jLK68ebcjG3iogT
uB69fllnm6v4SxTWTbxNGuv5x7o638h/DQP/7+bxkkylIjcjOu2/0AhL2SWn1orv
IYDPAhOjcHnWdBy0JONK7nSI9VJjovo7obMnE9FlND4B/onDCMiDtbIb9sIeGbcK
jZRRZwPcfRUTYxhm9uDuNkVM9unYF4vSQs8dcZY6u5CQeF21Cn+/V2EX9jLdfsfu
aaa8fMXZjCow48ADIpJo3g60u2zbpzeTT7vU6jArn1RpYxNIyzhUrA+tbb2LWOe9
PapDdvIdupgWGca6ksFg
=XfXT
-----END PGP SIGNATURE-----

--=-dpJMs2MMxba3zMyCoiIA--

