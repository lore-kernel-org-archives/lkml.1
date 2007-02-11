Return-Path: <linux-kernel-owner+w=401wt.eu-S1750740AbXBKRP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750740AbXBKRP1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 12:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbXBKRP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 12:15:27 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:44738 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbXBKRP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 12:15:26 -0500
X-Greylist: delayed 2160 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Feb 2007 12:15:26 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Sender:Reply-To;
	b=PvF4oaNAcpzO2fvCKpCX7YTXCmu7BYJI8aVAHCOIohDstTQOP/5PVsWyJ3dNV6jJpBreCdxekGv45jUZwcwi5fAM6nLDcoVPQjHabCgeh5kLM0PVm5meIQ1I5zQy8q2U;
Message-ID: <45CF46B6.1060401@simon.arlott.org.uk>
Date: Sun, 11 Feb 2007 16:39:18 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Duncan Sands <duncan.sands@math.u-psud.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] cxacru: Poll for device status more frequently.
References: <45BFB841.9030200@simon.arlott.org.uk> <200701311527.39343.duncan.sands@math.u-psud.fr> <45C0D602.70708@simon.arlott.org.uk> <200701311915.42340.duncan.sands@math.u-psud.fr>
In-Reply-To: <200701311915.42340.duncan.sands@math.u-psud.fr>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigDB886675D0A2328B3E80099C"
Reply-To: Simon Arlott <567c60ddd62e6ee0961hghjy0007txcf@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDB886675D0A2328B3E80099C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 31/01/07 18:15, Duncan Sands wrote:
>> I've had it polling every 200ms on a dual ppro200 since november,
>> and it has never failed to poll the status.=20
>=20
> Great, that's certainly better than the speedtouch ;)
> I can't help feeling that polling twice a second is overkill.
> How about changing it to poll every 5 seconds if the line is
> up, and ten times as fast (as in this patch) if the line is
> down?  Also, what is the point of polling fast?  Does it matter
> if you miss some down-try_to_activate transitions?

It needs to be at most 2 seconds while down or it's going to miss some of=
 the state changes, why bother to output all the types of state if you're=
 going to ignore some of them?

As for while it's up, polling more often has a negligible effect on perfo=
rmance (still polling every 200ms here). If you change the timing for dif=
ferent states, you should know that it won't go into the down state on a =
retrain so ~up should enable faster polling.

--=20
Simon Arlott


--------------enigDB886675D0A2328B3E80099C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iQIVAwUBRc9GuKRtx1WjQ8ihAQpx9xAAqYI6Ac9wBVZQyfehYXcv5cOshC9QTaXm
phZPuY5yNP/IWPxBFz7IYgH+5FCy3K/nnoXEipmxUNCwICHillxTXGVJzyNf+1pc
l0UkOFmjQdKsA+wuzC8r1/xePwdBHU+tKm4vKyQc80RwFzhFHjSIt9Vzv+9JGoSW
dqqz8l6iMNs3ci2xP83MRjqfDMm54I9bezKVdc3zvYFvdaUITWv13egENLEl3mCt
4OZMG+zoRVC95PiAbuuobcGKS+4oXbG1cudBp+cZkK9R51FLoMMeNMyjt2LaCX6b
WEOnK7K6oCVFNuHbSB7W6iY3E5wI7J5XugNjhdo1vc/JA5fVVQZbyhmGQFRbpBxQ
ZHGd35MHvEuknvHLRsF0noW11KaGU4zcDygjgEYV6YqvCCBdVBitThyhfvQBCz59
TB89fiSKldcpHDwijijfUf7+L/Cd7MD16WHyHaWdo+0SZugU7cE48lapyAmzjNya
lEVzMH3zde8CUZczWTNg25uF/clSHvKqpNqKtYk9+wopwNEVdrejFKT075Los08X
H5siN72DF+O1dYa54RBzMzBM3102ewdSL2GZSmSsVXiYszW0f+aKQ1Adv3Jwggby
4mAopKPozXULyOtIBD0Dz3FAxKNU7VuKlLQtF3RYEoOF389r8W9jjpo9gGMW6Y1/
WikqmmIBOdw=
=R/hz
-----END PGP SIGNATURE-----

--------------enigDB886675D0A2328B3E80099C--
