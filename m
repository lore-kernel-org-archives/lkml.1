Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbZJVPez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbZJVPez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756261AbZJVPey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:34:54 -0400
Received: from 71-20-254-182.war.clearwire-wmx.net ([71.20.254.182]:42735 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025AbZJVPey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:34:54 -0400
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not
 available
From: Eric Anholt <eric@anholt.net>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Thomas Schlichter <thomas.schlichter@web.de>, Ingo Molnar <mingo@elte.hu>,
       Jan Beulich <JBeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Robert Hancock <hancockrwd@gmail.com>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Tejun Heo <tj@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       Ingo Molnar <mingo@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1256205210.2530.28.camel@sbs-t61>
References: <1394846127@web.de>
	 <4ADF32A0020000780001B20A@vpn.id2.novell.com>
	 <20091021173514.GA32227@elte.hu>
	 <200910212201.36578.thomas.schlichter@web.de>
	 <1256205210.2530.28.camel@sbs-t61>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-X26ivNY//v0fMy8AGKzp"
Date: Thu, 22 Oct 2009 08:34:49 -0700
Message-Id: <1256225689.32075.6.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-X26ivNY//v0fMy8AGKzp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-22 at 02:53 -0700, Suresh Siddha wrote:
> On Wed, 2009-10-21 at 13:01 -0700, Thomas Schlichter wrote:
> > OK, so I think the attached patches should do it. Hopefully I have addr=
essed=20
> > all your comments.
>=20
> Thomas,
>=20
> I have couple of issues with this patchset still. pci_mmap_page_range()
> doesn't get called for each fork(). So, we won't be ref counting the
> mtrr usage properly.
>=20
> I need to think a bit more carefully on this. Can I get back to you
> early next week on this, as I am traveling and need to think through
> this?
>=20
> We already keep track of some of the PAT ref counting using
> track_pfn_vma_copy(). And we need to extend/use something similar here.
>=20
> Even if we need to extend sysfs or pci vma ops, we need to increment and
> decrement the ref count of the mtrr register that gets used. There is no
> need to go through num_var_ranges etc.

Can we just not create the _wc sysfs entry if we don't have PAT?  I
don't think there's userland relying on its presence as opposed to the
non-_wc entry.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-X26ivNY//v0fMy8AGKzp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkrge5kACgkQHUdvYGzw6vc/hACeOrqru1n8dzPJotQbH/+SrRhw
H3IAnArtWqj9O8zCg1NXr0goyk70eJuJ
=QFgQ
-----END PGP SIGNATURE-----

--=-X26ivNY//v0fMy8AGKzp--

