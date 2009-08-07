Return-Path: <linux-kernel-owner+w=401wt.eu-S932375AbZHGSZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbZHGSZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 14:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbZHGSZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 14:25:57 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:48865 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000AbZHGSZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 14:25:56 -0400
Message-ID: <4A7C71AE.7040208@novell.com>
Date: Fri, 07 Aug 2009 14:25:50 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: "Ira W. Snyder" <iws@ovro.caltech.edu>
CC: Arnd Bergmann <arnd@arndb.de>, alacrityvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 4/7] vbus-proxy: add a pci-to-vbus bridge
References: <20090803171030.17268.26962.stgit@dev.haskins.net> <200908061903.05083.arnd@arndb.de> <4A7B0D090200005A00051D2E@sinclair.provo.novell.com> <200908070057.54795.arnd@arndb.de> <4A7B78580200005A00051D50@sinclair.provo.novell.com> <20090807155500.GB12561@ovro.caltech.edu>
In-Reply-To: <20090807155500.GB12561@ovro.caltech.edu>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4AE6142523011E2E1369726E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4AE6142523011E2E1369726E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Ira W. Snyder wrote:

<big snip>

> With my powerpc hardware, it should be easily possible to have at least=

> 6 devices, each with two virtqueues, one for tx and one for rx. (The
> limit is caused by the amount of distinct kick() events I can generate.=
)
> This could allow many combinations of devices, such as:
>=20
> * 1 virtio-net, 1 virtio-console
> * 3 virtio-net, 2 virtio-console
> * 6 virtio-net
> * etc.

Note that the vbus "connector" design abstract details such as kick
events, so you are not limited by the number of physical interrupts of
your hardware, per se.

You can actually have an arbitrary width namespace for your virtqueues
running over a single interrupt, if you were so inclined.  (Note you can
also have a 1:1 with interrupts if you like, too)

If you look at the design of the vbus-pcibridge connector, it actually
aggregates the entire namespace into between 1 and 8 interrupts
(depending on availability, and separated by priority level).  If
multiple vectors are not available, the entire protocol can fallback to
run over a single vector when necessary.

Kind Regards,
-Greg


--------------enig4AE6142523011E2E1369726E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkp8ca4ACgkQP5K2CMvXmqGNJgCfZ0jVCQv68+DLT4Z1aHUeSRtz
B50AnAhC/m+CJb6+cR7OUHiHUrSbAHg8
=0kNg
-----END PGP SIGNATURE-----

--------------enig4AE6142523011E2E1369726E--
