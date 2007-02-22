Return-Path: <linux-kernel-owner+w=401wt.eu-S933050AbXBVNwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050AbXBVNwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 08:52:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932240AbXBVNwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 08:52:05 -0500
Received: from ns2.uludag.org.tr ([193.140.100.220]:44165 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933050AbXBVNwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 08:52:04 -0500
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: [BUG] at drivers/char/vt.c:3332 do_blank_screen() on resume
Date: Thu, 22 Feb 2007 15:52:11 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       lkml <linux-kernel@vger.kernel.org>, spock@gentoo.org
References: <200702090838.21060.caglar@pardus.org.tr> <200702221453.18153.caglar@pardus.org.tr> <1172151671.4306.13.camel@daplas>
In-Reply-To: <1172151671.4306.13.camel@daplas>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3215116.nEnpVNlFW7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702221552.14491.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3215116.nEnpVNlFW7
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

22 =C5=9Eub 2007 Per tarihinde, Antonino A. Daplas =C5=9Funlar=C4=B1 yazm=
=C4=B1=C5=9Ft=C4=B1:=20
> Ah, and you have fb_splash too.  That's why the tracing was not what I
> expected it to be.
>
> Try using video=3Dvesafb:noblank to disable hardware blanking and find out
> if you can still reproduce the oops.

I'll try and also will try to reproduce with vanilla one.

> After grepping for change_console, all callers of change_console and
> complete_change_console are acquiring the console semaphore, so I really
> don't know what's going on here...
>
> Since you are using a non-vanilla kernel, can you just do
> a grep change_console of the kernel source and see if you can find a
> caller that missed doing an acquire_console_sem().

fbsplash and vesafb-tng has no change_console call and patched one seems sa=
me=20
with vanilla one.

[caglar@zangetsu][~/svk/playground/caglar/kernel/kernel/files/gentoo]> grep=
=20
change_console fbsplash-0.9.2-r5.patch
[caglar@zangetsu][~/svk/playground/caglar/kernel/kernel/files/gentoo]> grep=
=20
change_console vesafb-tng-1.0-rc2.patch
[caglar@zangetsu][~/svk/playground/caglar/kernel/kernel/files/gentoo]>

zangetsu linux-2.6.20 # grep change_console *  -r
drivers/char/vt_ioctl.c:static void complete_change_console(struct vc_data=
=20
*vc);
drivers/char/vt_ioctl.c:                               =20
complete_change_console(vc_cons[newvt].d);
drivers/char/vt_ioctl.c:static void complete_change_console(struct vc_data=
=20
*vc)
drivers/char/vt_ioctl.c:         * clean up (similar to logic employed in=20
change_console())
drivers/char/vt_ioctl.c:void change_console(struct vc_data *new_vc)
drivers/char/vt_ioctl.c:        complete_change_console(new_vc);
drivers/char/vt.c:                     =20
change_console(vc_cons[want_console].d);
include/linux/vt_kern.h:void change_console(struct vc_data *new_vc);

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart3215116.nEnpVNlFW7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iD8DBQBF3aAOy7E6i0LKo6YRAssuAJwP+TtSnIECpv7vL1ClxAQ20SWSwACeM3Bj
rw6SPPBzVquVkGs66OYc9qM=
=DYgI
-----END PGP SIGNATURE-----

--nextPart3215116.nEnpVNlFW7--
