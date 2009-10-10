Return-Path: <linux-kernel-owner+w=401wt.eu-S934498AbZJJSeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934498AbZJJSeu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 14:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757475AbZJJSer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 14:34:47 -0400
Received: from fallback2.mail.ru ([94.100.176.87]:50943 "EHLO
	fallback2.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZJJSer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 14:34:47 -0400
Date: Sat, 10 Oct 2009 21:23:01 +0300
From: Sergei Trofimovich <slyfox@inbox.ru>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: intel-gfx@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>
Subject: [bisected] i915: linux-2.6.32-rc3+ regression
Message-ID: <20091010212301.34af4a45@mosly>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FcMQQIT22oSjwWl7J.IdaeW"; protocol="application/pgp-signature"
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/FcMQQIT22oSjwWl7J.IdaeW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi!

After syncing git tree to bd381934bf13ccb1af2813ae26c6fe00ec85d254
I've experienced pixel color corruption in Xorg.
Some of pixels (not all) have abnormal colors seen on images like this:
http://trofimeus.narod.ru/2009-10-09-22-00-17.png [1.5M]
(you won't see any problem until you run -rc3+ kernel).

I've bisected it[2] and found offending commit[1].
My hardware is HP Compaq 2510p laptop:
00:02.0 VGA compatible controller: Intel Corporation Mobile GM965/GL960 Int=
egrated Graphics Controller (rev 0c)

Do you need more info?

Thanks!

[1] offending commit
> 068143d38804825d59d951a192cfadd2e22f457d is the first bad commit
> commit 068143d38804825d59d951a192cfadd2e22f457d
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Mon Oct 5 09:58:02 2009 +1000
>=20
>     drm/fb: add setcmap and fix 8-bit support.
>    =20
>     This adds support for the setcmap api and fixes the 8bpp
>     support at least on radeon hardware. It adds a new load_lut
>     hook which can be called once the color map is setup.
>    =20
>     Signed-off-by: Dave Airlie <airlied@redhat.com>

[2] bisect log:
:040000 040000 9334e1ee9d528eaa5babd419bd53b40417e65f0f 7e06eb50488482efd38=
ac243080c9f27ee8682ec M   drivers
:040000 040000 31c8cb95831669746c0ee2ff8e34d15dc6c49b0e 0523107fc14ca0bb691=
4b93ea56dab20c741d61c M   include
git bisect start
# bad: [bd381934bf13ccb1af2813ae26c6fe00ec85d254] Merge branch 'for-linus' =
of git://git.kernel.org/pub/scm/linux/kernel/git/rol
and/infiniband
git bisect bad bd381934bf13ccb1af2813ae26c6fe00ec85d254
# good: [374576a8b6f865022c0fd1ca62396889b23d66dd] Linux 2.6.32-rc3
git bisect good 374576a8b6f865022c0fd1ca62396889b23d66dd
# bad: [1c6e6d91b22c4271e8a5dab559a08cb005a77073] Merge branch 'drm-linus' =
of git://git.kernel.org/pub/scm/linux/kernel/git/air
lied/drm-2.6
git bisect bad 1c6e6d91b22c4271e8a5dab559a08cb005a77073
# good: [d8e7b2b3ac5319fcee616488c628c2bbe7e2937b] Merge branch 'omap-fixes=
-for-linus' of git://git.kernel.org/pub/scm/linux/ke
rnel/git/tmlind/linux-omap-2.6
git bisect good d8e7b2b3ac5319fcee616488c628c2bbe7e2937b
# good: [185974dd596e67e73906790c2a4a4579d75911e6] drm: Delete the DRM_DEBU=
G_KMS in drm_mode_cursor_ioctl
git bisect good 185974dd596e67e73906790c2a4a4579d75911e6
# bad: [01ceae8edd7a0a6d8588dc103ad9f55e2c52cae9] drm/radeon/kms: Fix RS600=
/RV515/R520/RS690 IRQ
git bisect bad 01ceae8edd7a0a6d8588dc103ad9f55e2c52cae9
# bad: [b8c00ac5b50b54491657f8b6740db1df50149944] drm/fb: add more correct =
8/16/24/32 bpp fb support.
git bisect bad b8c00ac5b50b54491657f8b6740db1df50149944
# bad: [068143d38804825d59d951a192cfadd2e22f457d] drm/fb: add setcmap and f=
ix 8-bit support.
git bisect bad 068143d38804825d59d951a192cfadd2e22f457d
# good: [dfee5614e4d83a32cef9193a8b19bc1d8900f93d] drm/radeon/kms: respect =
single crtc cards, only create one crtc. (v2)
git bisect good dfee5614e4d83a32cef9193a8b19bc1d8900f93d

--=20

  Sergei

--Sig_/FcMQQIT22oSjwWl7J.IdaeW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkrQ0QgACgkQcaHudmEf86q9lgCdFkyfI99Yq2lnFqMtyvtIpoRp
JkYAniBCgV8OjieYoGbNdn6opxJvDons
=xO2b
-----END PGP SIGNATURE-----

--Sig_/FcMQQIT22oSjwWl7J.IdaeW--
