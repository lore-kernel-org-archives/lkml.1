Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZKIX3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZKIX3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 18:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754134AbZKIX3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 18:29:38 -0500
Received: from 139.254.232.72.static.reverse.ltdomains.com ([72.232.254.139]:50688
	"EHLO liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754054AbZKIX3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 18:29:37 -0500
Date: Mon, 9 Nov 2009 21:29:25 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, device@lanana.org, rubini@vision.unipv.it,
       gregkh@suse.de, cluster-devel@redhat.com
Subject: Re: [PATCH] misc: use a proper range for minor number dynamic
	allocation
Message-ID: <20091109232922.GF12217@vespa.holoscopio.com>
References: <1256340497-19320-1-git-send-email-cascardo@holoscopio.com> <20091109132836.6cf7f559.akpm@linux-foundation.org> <20091109220257.GD12217@vespa.holoscopio.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JBi0ZxuS5uaEhkUZ"
Content-Disposition: inline
In-Reply-To: <20091109220257.GD12217@vespa.holoscopio.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JBi0ZxuS5uaEhkUZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 09, 2009 at 08:02:57PM -0200, Thadeu Lima de Souza Cascardo wro=
te:
> >=20
> > Is that a bugfix for the existing code?
> >=20
> > If so, please split that out into a separate patch which we can review
> > and apply promptly while we consider the broader problem which you've
> > identified.
>=20
> We could consider buggy the caller which asks for the same device name
> more than once, without unregistering the first device. But better safe
> than sorry: we should protect the correct drivers from the buggy ones
> and avoid a depletion of the minor numbers. And, in case the driver core
> returns another error for another reason (from device_create), we do the
> right thing.
>=20
> I will send it right now.
>=20
> Regards,
> Cascardo.

I've just tried to create a single and separate patch, but that would
let lots of related bugs around.

First of all, the current code does not use the bitmap idiom. Should I
use it on my fix and let all the other bitmap manipulations as is, or
should I use the current and less readable style?

Second, this single fix would match the same test currently in
misc_deregister, which is broken, since it does not test for the 0
minor.

Thus, I am sending a patch which fixes those two issues using the
current style, a fix for the style itself, and a change from the current
range to something that could have its range easily fixed. However,
regarding that last change, it will still use bitmaps, which may not be
appropriate for large ranges.

Perhaps, using a idr instead of the list and bitmap couple, may be
sensible. What do you think about it?

--JBi0ZxuS5uaEhkUZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEARECAAYFAkr4pdIACgkQyTpryRcqtS3hggCfRuSs+xQPTmsoKY5tn8H9Ky1v
3N8AmLV+BeJmvGzQwxRouWGZuXei744=
=n5F/
-----END PGP SIGNATURE-----

--JBi0ZxuS5uaEhkUZ--
