Return-Path: <linux-kernel-owner+w=401wt.eu-S1753841AbYL2WEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbYL2WEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 17:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbYL2WEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 17:04:37 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:33814 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbYL2WEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 17:04:36 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] kbuild: auto-convert size types in userspace headers
Date: Mon, 29 Dec 2008 17:04:34 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
References: <49567EB5.5030409@zytor.com> <200812291534.49577.vapier@gentoo.org> <495934D9.2070908@zytor.com>
In-Reply-To: <495934D9.2070908@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1423590.hAfvtJ1MWQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200812291704.35450.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1423590.hAfvtJ1MWQ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 29 December 2008 15:36:41 H. Peter Anvin wrote:
> Mike Frysinger wrote:
> > On Monday 29 December 2008 09:03:56 Sam Ravnborg wrote:
> >> On Mon, Dec 29, 2008 at 06:12:33AM -0500, Mike Frysinger wrote:
> >>> Rather than constantly fixing up size type breakage in userspace
> >>> headers, auto convert the types u_intXX_t, uintXX_t, intXX_t, uXX, and
> >>> sXX to the appropriate __uXX or __sXX type.
> >>
> >> Is this the right thing to do?
> >> uintXX_t belongs to a namespace that the kernel should not use.
> >
> > some headers are shared between projects and so use the uintXX_t form, =
so
> > i'm not sure outright banning it is a nice answer for them
>
> Arguably, the right answer is the opposite... the Linux u* and s* forms
> feel much more like nonstandard legacy code to me.  They have the
> advantage of brevity, however.

my testing of this patch has revealed an issue along these lines.  building=
=20
mplayer fails as it uses linux/dvb/audio.h.  this header does:
#ifdef __KERNEL__
#include <linux/types.h>
#else
#include <stdint.h>
#endif
typedef uint16_t audio_attributes_t;

but since the script has autoconverted uint16_t to __u16, and linux/types.h=
=20
isnt being pulled in for userspace, we get a build failure.
=2Dmike

--nextPart1423590.hAfvtJ1MWQ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJWUlzAAoJEEFjO5/oN/WBk7QQANudOyRutqkhEeuKkxx4/Vmt
vx3CS+45YUO/W6x+xUwpouGQPrv2fEByv7TJuCo0jJOCae+yEq36SWtYZY8TkviY
STDpekaQtXH0sHxQD5doDztau+V/aNWjyiUfBdNYY2M+RRcYRLrGyxNdmqO6TSaq
13vtY/koAwPGN0Z44P3ZQN8VzAgfzjItZLuOJM1czE/fKgnC42hSNrpYBeUqHg6p
/VSuvtDGfFkxtKi/KUcb85zJCh3EVOXeNBKj6euK6/skaDiMtN2/ir4ZNc6vUe/+
9YTeVni3g/75Kkr42DRdoyz8Dp+gWUsYDN7SJ98vuY+z6VsWI8APOv6jPd7Qu1QG
x/sBthSgxMAAmgEhX0FTuUENtD4t8hRX+j12AyhQNMVWgix5vv7f7XmIIj8N6+uD
k68Wgw1AQ2K6TXG4w5oDYjWqjRLpr8XTil7eq6GOvieGh+hCz5fijbq8xb/JtbD2
PtRrY+sy5tHap8vDB74YnpRogK0qwpSC+3KDF9YL2jzfR+7TYleZh5gsnebNuWUz
Lu/0Fz0CuBW1hGnRyub+aLKMDDvEFKn9kX89F83qnBoIRoh9jm58/yyOM4Ik7MJT
b3HDZ0VcXDP22of2/xoTvjfyfJbgRZJr0ApEDMji3kN3RkRSBp1vdJUm4ZYzpiFl
rUjT9T1Ku5HukbwUbwIa
=Y448
-----END PGP SIGNATURE-----

--nextPart1423590.hAfvtJ1MWQ--
