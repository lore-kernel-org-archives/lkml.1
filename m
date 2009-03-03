Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbZCCS0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbZCCS0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 13:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbZCCSZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 13:25:13 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:56296 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756860AbZCCSZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 13:25:11 -0500
Subject: Re: [TIP,regression,i915] /dev/dri/card0 is no longer present
From: Eric Anholt <eric@anholt.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <20090302213412.GB25076@elte.hu>
References: <20090301110455.GA18547@silver.sucs.org>
	 <20090301113948.GA3602@elte.hu> <20090301134809.GA4753@silver.sucs.org>
	 <1236020758.4586.76.camel@localhost.localdomain>
	 <20090302213412.GB25076@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-siAOMc8yAUdBrDNpXq+u"
Date: Tue, 03 Mar 2009 10:24:49 -0800
Message-Id: <1236104689.8601.18.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-siAOMc8yAUdBrDNpXq+u
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-02 at 22:34 +0100, Ingo Molnar wrote:
> * Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:
>=20
> > On Sun, 2009-03-01 at 05:48 -0800, Sitsofe Wheeler wrote:
> > > On Sun, Mar 01, 2009 at 12:39:48PM +0100, Ingo Molnar wrote:
> > > >
> > > > Thanks, i've reverted the commit for now. Could you please send
> > > > a 'dmesg' from the bootup with the failed driver? By all
> > > > likelyhood an ioremap failure causes a driver failure.
> > > >
> > >=20
> > > See below (drm says it initalized though...):
> > >=20
> > > [    0.000000] Linux version 2.6.29-rc6-00006-g17581ad (@verona) (gcc=
 version 4.2.4) #87 Sun Mar 1 13:42:28 GMT 2009
> > > [    0.000000] KERNEL supported cpus:
> > > [    0.000000]   Intel GenuineIntel
> > > [    0.000000] PAT WC disabled due to known CPU erratum.
> >=20
> > Looks like PAT is getting disabled on this platform. Can you=20
> > send the output of /proc/cpuinfo please.
>=20
> Does this mean we failed an ioremap()? We still should not fail=20
> a device ioremap _ever_. We should just fall back to UC and be=20
> done with it. We may emit a warning if we consider it=20
> troublesome, but we should never ever break working drivers=20
> really.

Thank you!  This has been plaguing us since 2.6.28, but all I can get
out of people is  "no, it's doing the right thing, we can't satisfy your
request because handwavey errata stuff to do with conflicts, can't tell
you off the top of my head."

We want WC ioremap, and we try an MTRR in case PAT is disabled (because
of the errata that makes WC PAT sometimes give non-WC behavior).  Give
us a mapping, whether or not it's really WC.  Failing the mapping is not
OK.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-siAOMc8yAUdBrDNpXq+u
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmtdfAACgkQHUdvYGzw6vdocQCeN6mlMMZZ9Mmx5wGt3jnrVZtq
AhEAn1pfJ7mYgIY77aXkJH9b2hpVaYik
=Qbd0
-----END PGP SIGNATURE-----

--=-siAOMc8yAUdBrDNpXq+u--

