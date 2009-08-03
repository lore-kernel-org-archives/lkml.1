Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbZHCGud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbZHCGud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 02:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbZHCGud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 02:50:33 -0400
Received: from mga05.intel.com ([192.55.52.89]:12106 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751881AbZHCGuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 02:50:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,312,1246863600"; 
   d="asc'?scan'208";a="713357126"
Date: Mon, 3 Aug 2009 14:50:30 +0800
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Dave Airlie <airlied@gmail.com>, Keir Fraser <kier.fraser@eu.citrix.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [RFC] Make AGP work with IOMMU
Message-ID: <20090803065030.GA32461@zhen-devel.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
Mail-Followup-To: David Woodhouse <dwmw2@infradead.org>,
	Dave Airlie <airlied@gmail.com>,
	Keir Fraser <kier.fraser@eu.citrix.com>,
	"xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
	Joerg Roedel <joerg.roedel@amd.com>
References: <1248707041.6100.35.camel@macbook.infradead.org>
 <21d7e9970907282328l4a44b9a2of4500c5c84a3586b@mail.gmail.com>
 <1248851712.19733.214.camel@macbook.infradead.org>
 <21d7e9970907290143q6778511cvda1c6b915f61654a@mail.gmail.com>
 <1248860205.19733.238.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <1248860205.19733.238.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2009.07.29 17:36:45 +0800, David Woodhouse wrote:
> On Wed, 2009-07-29 at 18:43 +1000, Dave Airlie wrote:
> > >> don't suppose we want page_to_gart or is the double function nicer?
> > >
> > > I pondered that briefly. But then observed that phys_to_gart() and
> > > gart_to_phys() _always_ describe an identity mapping, so perhaps they
> > > could just be ditched completely?
> >=20
> > Yeah that could work too, no idea why they were introduced, well before=
 my time.
>=20
> http://git.infradead.org/users/dwmw2/iommu-agp.git?a=3Dcommitdiff;h=3D8bf=
2f3a9
>=20
> It was introduced by Keir in 2005 for Xen (commit 07eee78e). I suspect
> it can die though, and that the right answer there is also to use the
> DMA API correctly.
>=20

The commits on that tree looks fine to me. Thanks David!=20
I've also done some testing on G45 here, I've also seen the write
faults before graphics device init or after dma unmap pages. I tried
to look it up in my memo, which turns out one message like this should
be a BIOS bug that doesn't initialize the GTT table correctly. But I'm
quite sure about it now, better to ask our chipset people to verify if
this problem has been fixed or not.

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp2iLYACgkQsQQaM014GCeUewCcCGr55DTdWt5SBQgkx4VRpLWk
5pYAn1Cs4Lw6secCjNW1eWJ3T4o5XUMk
=H5CO
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
