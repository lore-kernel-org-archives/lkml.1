Return-Path: <linux-kernel-owner+w=401wt.eu-S935461AbXGLAF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935461AbXGLAF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935152AbXGKXqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:46:09 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:41561 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935803AbXGKXqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:46:06 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: Hibernation Redesign
Date: Thu, 12 Jul 2007 09:46:04 +1000
User-Agent: KMail/1.9.6
Cc: Miklos Szeredi <miklos@szeredi.hu>, rjw@sisk.pl, a1426z@gawab.com,
       jeremy@goop.org, pavel@ucw.cz, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <200707081737.21932.a1426z@gawab.com> <200707112211.23420.nigel@nigel.suspend2.net> <87644rcc7a.fsf@jbms.ath.cx>
In-Reply-To: <87644rcc7a.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1775133.Bzd23CQfjW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707120946.05435.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1775133.Bzd23CQfjW
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Wednesday 11 July 2007 23:16:41 Jeremy Maitin-Shepard wrote:
> Nigel Cunningham <nigel@nigel.suspend2.net> writes:
>=20
> [snip]
>=20
> > No other _proper_ solutions have been proposed. Everyone who suggests=20
removing=20
> > the freezer also suggests implementing it all over again. It might be=20
sending=20
> > SIGSTOP to everything. It might be shifting the desk chairs around and=
=20
> > creating a completely new kernel context, but they always have the same=
=20
> > goal - stopping the existing activity, and they all come with their own=
=20
> > issues (even if they're not obvious yet because the alternatives are=20
> > currently vapourware to one extent or another).
>=20
> I'll certainly admit the kexec idea is vaporware currently, but it does
> differ in a significant way from freezer-based approaches, such that I
> don't think it should be referred to as just another implementation of a
> freezer.  Specifically, it doesn't require that the "old kernel" be in a
> "consistent" state to a greater extent than suspend to ram; it is the
> case that all of the devices must be quiesced or shut down to some
> extent, but doing this without races and deadlocks (and without the
> freezer) is certainly very, very similar to what needs to be done for
> suspend to ram, which will need to be solved anyway.  Unlike the
> existing hibernate approaches, however, it will not be necessary to use
> any of the driver infrastructure once switched to the "save image"
> kernel, and thus it will not matter what locks are held, for instance.

Locks are not nearly the issue that you're making them out to be, and neith=
er=20
are most processes. It's only fuse that has caused this whole ding.

The lack of context from the original kernel is also going to be a problem.=
 If=20
you want to store the image on a local hard disk, the kernel being hibernat=
ed=20
is going to need to do that for you, because it will need to use the=20
information only it has regarding what swap is in use, how files on mounted=
=20
filesystems map to devices and sectors and so on. It will need to somehow=20
transfer that information from itself to the 'saving kernel'. In the end, t=
he=20
only advantage you'll get is that you don't have to worry about fuse=20
processes anymore.

=46rankly, I wish kexec was a viable alternative. I'm tired of working on k=
ernel=20
code, and would be perfectly happy to stop working on Suspend2 if kexec wou=
ld=20
work or if Rafael got swsusp to a point where the difference in features wa=
s=20
minimal. But I just can't see that kexec is a viable alternative. Sorry.

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart1775133.Bzd23CQfjW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGlWu9N0y+n1M3mo0RAnd6AKDkDV41Wgdxk5T0tsDOsfDn8yfE3ACeOUHh
3LzebxmbyRreqMumHsavee8=
=x0iY
-----END PGP SIGNATURE-----

--nextPart1775133.Bzd23CQfjW--
