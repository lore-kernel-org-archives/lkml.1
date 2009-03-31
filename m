Return-Path: <linux-kernel-owner+w=401wt.eu-S1763288AbZCaThU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763288AbZCaThU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 15:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760261AbZCaThA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 15:37:00 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:35780 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbZCaTg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 15:36:59 -0400
Subject: Re: [PATCH 6/6] drm/i915: Fix lock order reversal in GEM
 relocation entry copying. -- makes X hang
From: Eric Anholt <eric@anholt.net>
To: Florian Mickler <florian@mickler.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       keithp@keithp.com
In-Reply-To: <20090330120011.0d506d20@schatten>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	 <1238017510-26784-2-git-send-email-eric@anholt.net>
	 <1238017510-26784-3-git-send-email-eric@anholt.net>
	 <1238017510-26784-4-git-send-email-eric@anholt.net>
	 <1238017510-26784-5-git-send-email-eric@anholt.net>
	 <1238017510-26784-6-git-send-email-eric@anholt.net>
	 <1238017510-26784-7-git-send-email-eric@anholt.net>
	 <20090330120011.0d506d20@schatten>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-izVketRM4JMx3EFxhuR3"
Date: Tue, 31 Mar 2009 12:36:56 -0700
Message-Id: <1238528216.8369.390.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-izVketRM4JMx3EFxhuR3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-30 at 12:00 +0200, Florian Mickler wrote:
> Hi!
>=20
> On Wed, 25 Mar 2009 14:45:10 -0700
> Eric Anholt <eric@anholt.net> wrote:
>=20
> > Signed-off-by: Eric Anholt <eric@anholt.net>
> > Reviewed-by: Keith Packard <keithp@keithp.com>
> > ---
> >  drivers/gpu/drm/i915/i915_gem.c |  187
> > +++++++++++++++++++++++++++----------- 1 files changed, 133
> > insertions(+), 54 deletions(-)
> >=20
>=20
> I testet Linus' Git tree @ 5d80f8e5a (merge
> net-2.6) and discovered that X hung after starting up gdm.
>=20
> When i start gdm the screen is frozen and X hangs.=20
> I was able to bisect it down to=20
>=20
> 40a5f0decdf050785ebd62b36ad48c869ee4b384 drm/i915: Fix lock order
> reversal in GEM relocation entry copying.
>=20
>=20
> when hung /proc/[xpid]/stack did contain:
>=20
> [<ffffffff8024c13e>] msleep_interruptible+0x2e/0x40
> [<ffffffff80557fdd>] i915_wait_ring+0x17d/0x1d0
> [<ffffffff8056280d>] i915_gem_execbuffer+0xd2d/0xf70
> [<ffffffff80546555>] drm_ioctl+0x1f5/0x320
> [<ffffffff802d8ce5>] vfs_ioctl+0x85/0xa0
> [<ffffffff802d8f0b>] do_vfs_ioctl+0x20b/0x510
> [<ffffffff802d9297>] sys_ioctl+0x87/0xa0
> [<ffffffff8020ba8b>] system_call_fastpath+0x16/0x1b
> [<ffffffffffffffff>] 0xffffffffffffffff
>=20
>=20
> I reverted that commit now on top of 5d80f8e5a and all 's well .
>=20
>=20
> My X-Stack is from Git at around 20th march. I will update that now,
> but as it hangs in a kernel syscall, it shouldn't matter?
>=20
> Sincerely,
>=20
> Florian
>=20
> p.s. no kms=20

Ouch.  Could you file a bug report using:

http://intellinuxgraphics.org/how_to_report_bug.html

so I've got the information I need to try to reproduce this?

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-izVketRM4JMx3EFxhuR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknScNgACgkQHUdvYGzw6vd3kwCfYqV314/RRCJbIwUpuztq7mkp
o4IAnRiQGWdOTuNWOE4giPNPUOX4U089
=z+fj
-----END PGP SIGNATURE-----

--=-izVketRM4JMx3EFxhuR3--
