Return-Path: <linux-kernel-owner+w=401wt.eu-S1758459AbXGTLZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbXGTLZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 07:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbXGTLZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 07:25:00 -0400
Received: from hydra.gt.owl.de ([195.71.99.218]:39724 "EHLO hydra.gt.owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755236AbXGTLY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 07:24:58 -0400
X-Greylist: delayed 2094 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jul 2007 07:24:58 EDT
Date: Fri, 20 Jul 2007 12:50:03 +0200
From: Florian Lohoff <flo@rfc822.org>
To: andrei radulescu-banu <iubica2@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux, tcpdump and vlan
Message-ID: <20070720105003.GB24536@paradigm.rfc822.org>
References: <878246.51044.qm@web56608.mail.re3.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <878246.51044.qm@web56608.mail.re3.yahoo.com>
Organization: rfc822 - pure communication
X-SpiderMe: mh-200707200837@listme.rfc822.org
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 18, 2007 at 12:34:33PM -0700, andrei radulescu-banu wrote:
>=20
> Dear kernel networking gurus,=20
>=20
> I am trying to understand why tcpdump does not work properly for vlan pac=
kets on linux. Here is the existing behavior, observed with:
>   - kernel 2.6.16,  =20
> - e1000 driver =20
> - libpcap 0.9.6 =20
> - tcpdump 3.9.6=20
>  =20
>=20
> The e1000 driver has two modes when handling vlan frames: =20
> (A) Default mode, when  =20
> - on rx, the mac includes vlan headers  =20
> - on tx, the mac expects tx frames to include vlan headers.  =20
> (B) Vlan hw accelerated mode, when: =20
> - on rx, the mac does not include vlan headers, and instead passes vlan t=
ag information in the status field of the ring buffer
>   - on tx, the mac expects no vlan headers, and instead expects vlan tag =
information to be passed in the status field of the ring buffer

I have seen similar behaviour. Once the kernel is compiled with VLAN
support the e1000 driver drops the vlan tag completely even when no
vlans are configured on that port. I would consider this beeing a bug
that enableing a kernel option changes behaviour even if the feature is
not in use.

As i was tracing dot1qinq i could actually see that only the outer
vlan tag was beeing dropped.

Flo
--=20
Florian Lohoff                  flo@rfc822.org             +49-171-2280134
	Those who would give up a little freedom to get a little=20
          security shall soon have neither - Benjamin Franklin

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGoJNbUaz2rXW+gJcRAlqTAKCSErEnvxGMDSR2Tl2DwNsG0E7/0QCfSuFs
bT+/bD0bcSmAlFRL+Bo6sOY=
=iaIN
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
