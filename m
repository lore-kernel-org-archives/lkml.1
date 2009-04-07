Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbZDGBJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbZDGBJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 21:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZDGBJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 21:09:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:15705 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbZDGBJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 21:09:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,333,1235980800"; 
   d="asc'?scan'208";a="445578857"
Date: Tue, 7 Apr 2009 08:50:00 +0800
From: "Wang, Zhenyu Z" <zhenyu.z.wang@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Jarod Wilson <jarod@redhat.com>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       "xorg-devel@lists.x.org" <xorg-devel@lists.x.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "notting@redhat.com" <notting@redhat.com>,
       Fu Michael <michael_fu@linux.intel.com>
Subject: Re: [PATCH] drm: ignore LVDS on intel graphics systems that lie
	about having it
Message-ID: <20090407005000.GA20908@zhen-devel.sh.intel.com>
Mail-Followup-To: Jesse Barnes <jbarnes@virtuousgeek.org>,
	Jarod Wilson <jarod@redhat.com>,
	"dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
	"xorg-devel@lists.x.org" <xorg-devel@lists.x.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"notting@redhat.com" <notting@redhat.com>,
	Fu Michael <michael_fu@linux.intel.com>
References: <200904061011.26389.jarod@redhat.com> <20090406095216.4361d128@hobbes>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <20090406095216.4361d128@hobbes>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2009.04.07 00:52:16 +0800, Jesse Barnes wrote:
> On Mon, 6 Apr 2009 10:11:25 -0400
> Jarod Wilson <jarod@redhat.com> wrote:
>=20
> > There are a number of small form factor desktop systems with Intel
> > mobile graphics chips that lie and say they have an LVDS. With kernel
> > mode-setting, this becomes a problem, and makes native resolution
> > boot go haywire -- for example, my Dell Studio Hybrid, hooked to a
> > 1920x1080 display claims to have a 1024x768 LVDS, and the resulting
> > graphical boot on the 1920x1080 display uses only the top left
> > 1024x768, and auto-configured X will end up only 1024x768 as well.
> > With this change, graphical boot and X both do 1920x1080 as expected.
> >=20
> > Note that we're simply embracing and extending the early bail-out code
> > in place for the Mac Mini here. The xorg intel driver uses pci
> > subsystem device and vendor id for matching, while we're using dmi
> > lookups here. The MSI addition is courtesy of and tested by Bill
> > Nottingham.
> >=20
> > One minor issue... Current Fedora rawhide, video playback using Xv
> > makes X go off into the weeds with this patch added, but that's a bug
> > elsewhere, still confident this patch DTRT.
> >=20
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > Tested-by: Bill Nottingham <notting@redhat.com>
>=20
> The 2D driver has a similar set of quirks, but since we started that
> list we've found that the VBIOS should contain a pretty reliable table
> indicating which outputs are available, including LVDS.  I think if we
> can figure out how to parse it reliably (accounting for VBIOS
> versioning and structure size changes) we shouldn't need this patch.
> If we can't get that done in time for 2.6.30 though I'm all for
> including this.
>=20
> Zhenyu and Michael does that sound doable?
>=20

yeah, that's what I tried to fix, instead of adding quirks in KMS,
we try to find a way to detect LVDS config based on VBIOS table.
But looks failed in first round as I haven't got full right info
on VBIOS LVDS config. Old machines might not have correct VBIOS setting,
and I'm not sure about those Intel Mac machines. So this one is fine to me =
too.

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknaozgACgkQsQQaM014GCeDEQCePpqGq7OcOUk0rjgS9uxZOKwd
v9IAmwdO/pEBvlC9OS8K55AEU2czbR77
=L+YD
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
