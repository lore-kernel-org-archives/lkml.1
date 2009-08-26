Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbZHZD6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbZHZD6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 23:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756619AbZHZD6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 23:58:41 -0400
Received: from mga10.intel.com ([192.55.52.92]:20286 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756586AbZHZD6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 23:58:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,276,1249282800"; 
   d="asc'?scan'208";a="487430241"
Date: Wed, 26 Aug 2009 11:58:40 +0800
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Anholt <eric@anholt.net>, mailing54 <mailing54@plzk.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
       Ma Ling <ling.ma@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Zhao, Yakui" <yakui.zhao@intel.com>, Keith Packard <keithp@keithp.com>
Subject: Re: Linux 2.6.31-rc7
Message-ID: <20090826035840.GA16894@zhen-devel.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Eric Anholt <eric@anholt.net>, mailing54 <mailing54@plzk.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Dave Airlie <airlied@redhat.com>, dri-devel@lists.sourceforge.net,
	Ma Ling <ling.ma@intel.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	"Zhao, Yakui" <yakui.zhao@intel.com>,
	Keith Packard <keithp@keithp.com>
References: <alpine.LFD.2.01.0908211810390.3158@localhost.localdomain>
 <4A941E8B.8080902@plzk.org>
 <alpine.LFD.2.01.0908251057260.3218@localhost.localdomain>
 <4A94599F.9020508@plzk.org>
 <alpine.LFD.2.01.0908251456530.3218@localhost.localdomain>
 <1251239637.26348.20.camel@gaiman.anholt.net>
 <20090826015127.GA1402@zhen-devel.sh.intel.com>
 <alpine.LFD.2.01.0908252027300.3218@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0908252027300.3218@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2009.08.25 20:33:32 -0700, Linus Torvalds wrote:
> On Wed, 26 Aug 2009, Zhenyu Wang wrote:
> >
> > > In my experience, the BIOS setup doesn't reflect what outputs should =
be
> > > used at runtime, and certainly not the correct configuration of the
> > > enabled outputs.  For example, if we went to this, the giant monitor
> > > attached to my laptop that I actually look at would go unused.
> >=20
> > yeah, normally VBIOS startup just needs or only can driver one pipe, so
> > we don't have any pre knowledge except detect everything.
>=20
> Umm. What's your guys point, exactly?
>=20

We can't depend on any BIOS display config as you noted before our driver.
And our driver does more flexible config than VBIOS does.

> The fact is, as-is, YOU DETECT THE WRONG OUTPUTS!
>=20
> If you actually detected things _right_, none of this would be an issue.=
=20
> But you don't. And you seem to have a really hard time even admitting=20
> that. You try to re-detect things, and you SCREW UP.
>=20

We know we have problem on Mac mini, this issue has been known for a while.
And Keith also posted patch at
	http://lists.freedesktop.org/archives/intel-gfx/2009-June/002843.html
but I don't know the status of this now.

> > we already have some mac relate bugs open, but please report on it so we
> > do have people with hardware to try and response. We have recently got a
> > MacBook, yakui is looking after the modesetting issue on it.
>=20
> Quite frankly, I've reported these things several times. I've been open t=
o=20
> try patches. Nothing has ever come out of it.=20
>=20
> I have a Mac Mini that I reported as broken over a month ago. I have a=20
> Westemere I've reported as not doing any DDC probing - and that I have to=
=20
> disable the LVDS probing on entirely in order to not make KMS set up the=
=20
> display to go to a non-existent LVDS port.
>=20
> You claim that you "detect everything", but quite frankly, you don't. The=
=20
> KMS code seems to assume that if it's a mobile chipset, it should have an=
=20
> LVDS output - and whether anything is connected to that or not is totally=
=20
> immaterial. There's clearly _zero_ "detection" going on.
>=20

We've tried many ways to detect LVDS, but none is stable or actually work f=
or
every chip. But now we have DMI quirks for some known no LVDS machine (incl=
uding
Mac mini), and we detect through ACPI LID object for LVDS exist.=20

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqUsvAACgkQsQQaM014GCfbsQCeIUDGBmfZCRttOZrrjaDlSVz6
NmkAn3SJuXQWEVanImEoy/tWopqOnIDE
=zeqU
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
