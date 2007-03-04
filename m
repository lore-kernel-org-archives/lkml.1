Return-Path: <linux-kernel-owner+w=401wt.eu-S1752526AbXCDXkC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbXCDXkC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 18:40:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbXCDXkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 18:40:01 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:59698 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbXCDXj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 18:39:59 -0500
Subject: Re: Recent wireless breakage (ipw2200, iwconfig, NetworkManager)
From: Johannes Berg <johannes@sipsolutions.net>
To: Matt Mackall <mpm@selenic.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, yi.zhu@intel.com, jketreno@linux.intel.com,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070304220857.GH23311@waste.org>
References: <20070304220857.GH23311@waste.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Bdf9yS6/Qs+ddGU6eaEw"
Date: Mon, 05 Mar 2007 00:39:24 +0100
Message-Id: <1173051564.6131.13.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Bdf9yS6/Qs+ddGU6eaEw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

[adding linux-wireless to CC]

On Sun, 2007-03-04 at 16:08 -0600, Matt Mackall wrote:
> Recent kernels are having troubles with wireless for me. Two seemingly
> related problems:

I don't think they are related actually.

> a) NetworkManager seems oblivious to the existence of my IPW2200

This is due to the recent sysfs restructuring I think. IIRC the fix is
to upgrade hal to a current git version.

> b) Manual iwconfig waits for 60s and then reports:

That one's strange.

> A second attempt to enable WEP via iwconfig succeeds and network
> connectivity is normal. However, NetworkManager still ignores the
> device at this point.

I'd think it's a ipw bug but I have no idea if that was even touched
during this time.

> Bisect with Mercurial points to this patch:
>=20
> $ hg bisect bad
> The first bad revision is:
> changeset:   46985:f701b96bb2f7
> user:        Greg Kroah-Hartman <gregkh@suse.de>
> date:        Wed Feb 07 10:37:11 2007 -0800
> summary:     Network: convert network devices to use struct device
> instead of class_device
>=20
> which corresponds to 43cb76d91ee85f579a69d42bc8efc08bac560278 in git.

Yup, sysfs breakage/hal stuff. Can you try with a recent hal? And maybe
try to bisect the iwconfig stop thing if you've got enough time...

johannes

--=-Bdf9yS6/Qs+ddGU6eaEw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF61is/ETPhpq3jKURAuvvAKC1g4NYvVxDXEyrhIwv4uXtMx4+dwCcD/90
gjfwMbRL2vJ46swsF1N2/1E=
=2Oqf
-----END PGP SIGNATURE-----

--=-Bdf9yS6/Qs+ddGU6eaEw--

