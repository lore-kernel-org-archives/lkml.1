Return-Path: <linux-kernel-owner+w=401wt.eu-S1753040AbYJRCM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbYJRCM2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 22:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbYJRCMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 22:12:20 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:51200 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbYJRCMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 22:12:19 -0400
Subject: Re: [git pull] drm patches for 2.6.27-rc1
From: Eric Anholt <eric@anholt.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
In-Reply-To: <alpine.LFD.2.00.0810171510170.3438@nehalem.linux-foundation.org>
References: <alpine.DEB.0.82.0810172227490.14817@skynet.skynet.ie>
	 <alpine.LFD.2.00.0810171510170.3438@nehalem.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mCOdkTaZTxp9jIoTmOUi"
Date: Fri, 17 Oct 2008 19:10:58 -0700
Message-Id: <1224295858.4378.8.camel@vonnegut.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mCOdkTaZTxp9jIoTmOUi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-17 at 15:43 -0700, Linus Torvalds wrote:
>=20
> On Fri, 17 Oct 2008, Dave Airlie wrote:
> >=20
> > Please pull the 'drm-next' branch from
> > ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git dr=
m-next
>=20
> Grr.
>=20
> This whole merge series has been full of people sending me UNTESTED CRAP.
>=20
> So what's the excuse _this_ time for adding all these stupid warnings to=20
> my build log? Did nobody test this?
>=20
>   drivers/gpu/drm/drm_proc.c: In function =E2=80=98drm_gem_one_name_info=
=E2=80=99:
>   drivers/gpu/drm/drm_proc.c:525: warning: format =E2=80=98%d=E2=80=99 ex=
pects type =E2=80=98int=E2=80=99, but argument 3 has type =E2=80=98size_t=
=E2=80=99
>   drivers/gpu/drm/drm_proc.c:533: warning: format =E2=80=98%9d=E2=80=99 e=
xpects type =E2=80=98int=E2=80=99, but argument 4 has type =E2=80=98size_t=
=E2=80=99
>   drivers/gpu/drm/i915/i915_gem.c: In function =E2=80=98i915_gem_gtt_pwri=
te=E2=80=99:
>   drivers/gpu/drm/i915/i915_gem.c:184: warning: unused variable =E2=80=98=
vaddr_atomic=E2=80=99
>=20
> and I wonder how many other warnings got added that I never even noticed=20
> because I don't build them?
>=20
> And yes, it's not just warnings. One of thse is horribly bad code:
>=20
> 	nid->len +=3D sprintf(&nid->buf[nid->len],
>                             "%6d%9d%8d%9d\n",
>                             obj->name, obj->size,
>                             atomic_read(&obj->handlecount.refcount),
>                             atomic_read(&obj->refcount.refcount));
>=20
> where it's just wrong to use the field width as a separator. Because if=20
> the counts are big enough, the separator suddenly goes away!
>=20
> So that format string should be
>=20
> 	"%6d %8zd %7d %8d\n"
>=20
> instead. Which  gives the same output when you don't overflow, and doesn'=
t=20
> have the overflow bug when you do.
>=20
> As to that "vaddr_atomic" thing, the warning would have been avoided if=20
> you had just cleanly split up the optimistic fast case.
>=20
> IOW, write cleaner code, and the warning just goes away on its own.=20
> Something like the appended. UNTESTED!

Yeah, none of us are on x86-64, so we missed those warnings in testing.
The change looks pretty good except for s/return 1/return 0/.  We wanted
to pull the i_wish_it_was_ioremap_atomic() hack out so that we could use
it for relocation updates as well (which aren't copy_from_user), and
I've started writing that patch.  Expect something pushed at you soon.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-mCOdkTaZTxp9jIoTmOUi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkj5Ra8ACgkQHUdvYGzw6vdMhACfWkCRq4dg8oAPV3VLsONzzdD5
zvoAmgI7yGpjliOHrcjtnAOBTaf8Eeup
=1Ty0
-----END PGP SIGNATURE-----

--=-mCOdkTaZTxp9jIoTmOUi--

