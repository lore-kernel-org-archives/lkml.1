Return-Path: <linux-kernel-owner+w=401wt.eu-S1759486AbYBXVnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486AbYBXVnk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 16:43:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbYBXVnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 16:43:32 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:54556 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974AbYBXVnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 16:43:31 -0500
X-Greylist: delayed 2003 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Feb 2008 16:43:30 EST
Date: Sun, 24 Feb 2008 22:08:42 +0100
From: Harald Welte <laforge@gnumonks.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH 1/1] file capabilities: simplify signal check
Message-ID: <20080224210842.GA4003@prithivi.gnumonks.org>
References: <20080223000237.518aace0.akpm@linux-foundation.org> <m17igu6e73.fsf@ebiederm.dsl.xmission.com> <20080224180931.GA74@tv-sign.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <20080224180931.GA74@tv-sign.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 24, 2008 at 09:09:31PM +0300, Oleg Nesterov wrote:
> I just have an almost off-topic (sorry ;) question. Do we really need
> kill_pid_info_as_uid() ? Harald Welte cc'ed.
>=20
> From "[PATCH] Fix signal sending in usbdevio on async URB completion"
> commit 46113830a18847cff8da73005e57bc49c2f95a56
>=20
> 	> If a process issues an URB from userspace and (starts to) terminate
> 	> before the URB comes back, we run into the issue described above.  This
> 	> is because the urb saves a pointer to "current" when it is posted to t=
he
> 	> device, but there's no guarantee that this pointer is still valid
> 	> afterwards.
> 	>
> 	> In fact, there are three separate issues:
> 	>
> 	> 1) the pointer to "current" can become invalid, since the task could be
> 	>    completely gone when the URB completion comes back from the device.
> 	>
> 	> 2) Even if the saved task pointer is still pointing to a valid task_st=
ruct,
> 	>    task_struct->sighand could have gone meanwhile.
> 	>
> 	> 3) Even if the process is perfectly fine, permissions may have changed,
> 	>    and we can no longer send it a signal.
>=20
> The problems 1) and 2) are solved by converting to a struct pid. Is 3) a =
real
> problem? The task which does ioctl(USBDEVFS_SUBMITURB) explicitly asks to=
 send
> the signal to it, should we deny the signal even if it changes its creden=
tials
> in some way?

At the time I discovered the abovementioned problem, '1' and '2' were
real practical issues that I was seeing on live systems, triggerable
=66rom userspace with no problems. '3' was more of a theoretical issue
that was discovered while reading the code and spending some thought on
it.

I personally am too remote to whatever you're currently doing to the
code ('using struct pid') in order to give any comment.  The overall
process of 'saving the current pointer and re-using it at some later
point while the original task might be gone or modified' must work.

Whether or not we should deny the signal even if the process changes its
own credentials in some way sounds like a much more esoteric question to
me.  I think it's fair to say that the resulting behavior is
"unspecified but shouldn't cause the process and/or kernel to misbehave"

At least I'm not aware of any usbdevio logic that would require some
specific behaviour here.

--=20
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHwdzaXaXGVTD0i/8RAguAAKCFy1997rd6JrfgKaVylg4WRjM0EgCfW+rG
XmgQ/Dscgj4UBYoA7bgoNC4=
=DE7Q
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
