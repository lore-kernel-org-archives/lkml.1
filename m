Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbZKJRPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbZKJRPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 12:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbZKJRPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 12:15:51 -0500
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:41197
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757325AbZKJRPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 12:15:50 -0500
Date: Tue, 10 Nov 2009 15:15:53 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       device@lanana.org, rubini@vision.unipv.it, gregkh@suse.de,
       cluster-devel@redhat.com
Subject: Re: [PATCH] misc: use a proper range for minor number dynamic
	allocation
Message-ID: <20091110171552.GB3628@vespa.holoscopio.com>
References: <1256340497-19320-1-git-send-email-cascardo@holoscopio.com> <20091109132836.6cf7f559.akpm@linux-foundation.org> <20091109220257.GD12217@vespa.holoscopio.com> <20091110110942.4cb70b13@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <20091110110942.4cb70b13@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2009 at 11:09:42AM +0000, Alan Cox wrote:
> > We could consider buggy the caller which asks for the same device name
> > more than once, without unregistering the first device. But better safe
>=20
> If they ask for the same name we certainly should. Probably we should
> error that request and use WARN_ON() to shame the offender in
> kerneloops.org.
>=20

The current code returns an error. It does not clear the bit in the
allocation bitmap, which is a bug in misc, which my first patch in the
series fixes now.

If it uses the same name, device_create is the responsible for failing.
It already logs that, but it uses no WARN right now. I think this WARN
should be in the driver core, not in misc, so we catch other offenders
as well.

> > than sorry: we should protect the correct drivers from the buggy ones
> > and avoid a depletion of the minor numbers. And, in case the driver core
> > returns another error for another reason (from device_create), we do the
> > right thing.
>=20
> Agreed we need to protect the working drivers.
>=20
> Alan

So, do you think this should be in 2.6.32 or even go down to stable?

Regards,
Cascardo.

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr5n8gACgkQyTpryRcqtS1sgACfXx8ytx0tATSv5AhlL69HCmxd
QVYAoIY5bh4wgks7rbSBvFFt7iCZ3hgS
=PRZ8
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
