Return-Path: <linux-kernel-owner+w=401wt.eu-S1755597AbYDQGKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbYDQGKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 02:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751943AbYDQGKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 02:10:06 -0400
Received: from home.keithp.com ([63.227.221.253]:3283 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbYDQGKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 02:10:05 -0400
Subject: RE: Mapping PCI BAR through /sys/devices/pci* sets cache-disable
	andwrite-through
From: Keith Packard <keithp@keithp.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEE5CEA9@orsmsx423.amr.corp.intel.com>
References: <1208367626.5245.5.camel@koto.keithp.com>
	 <924EFEDD5F540B4284297C4DC59F3DEEE5CEA9@orsmsx423.amr.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3Og6keiqYkYO7NauJhiI"
Date: Wed, 16 Apr 2008 22:20:31 -0700
Message-Id: <1208409631.10327.5.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3Og6keiqYkYO7NauJhiI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-04-16 at 15:23 -0700, Pallipadi, Venkatesh wrote:

> Setting flags "_PAGE_PCD | _PAGE_PWT" maps to PAT_3 which is "UC". So,
> the mapping X server will get is UC and if X sets MTRR to WC, it will
> not have any effect on this mapping, which will be still UC. There may
> be apps which depend on this /sys/ interface giving UC mapping always...

Sure, but X wants WC in the biggest way (our measurements show WC being
more than 6 times faster for writes, the operation we do the most of).

Jesse Barnes suggested using the fact that the BAR was prefetchable to
guess that this region should not be mapped UC. I don't know of any
other information available at this API that would help make a better
choice; there are no ioctls on /sys files that we could use to
manipulate the mapping.

> With PAT patches, we now have /sys/devices/pci*resource_wc (in addition
> to resource) for any PREFETCHABLE region. So, X has to change to use
> that new interface to get WC mapping.

Yeah, we'll do that when it becomes available. Would it make sense in
the pre-PAT world to use Jesse's guess?

In any case, we'll continue to use the fact that mprotect is also broken
to get our WC mapping working (using mprotect PROT_NONE followed by
mprotect PROT_READ|PROT_WRITE causes the CD and WT bits to get cleared).
We're fortunate in this case that we've found a bug to exploit that
gives us the desired behaviour.

--=20
keith.packard@intel.com

--=-3Og6keiqYkYO7NauJhiI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIBt4eQp8BWwlsTdMRAl1jAKCMk9J7W7OmuuSCkapZAjjMv6G1UgCgjqnZ
O6/a8LvJ2SHFiQtwRCDU7mg=
=RN8M
-----END PGP SIGNATURE-----

--=-3Og6keiqYkYO7NauJhiI--

