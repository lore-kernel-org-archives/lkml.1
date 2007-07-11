Return-Path: <linux-kernel-owner+w=401wt.eu-S1764229AbXGKMqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764229AbXGKMqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762120AbXGKMqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:46:38 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:44871 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054AbXGKMqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:46:37 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Hibernation Redesign
Date: Wed, 11 Jul 2007 22:46:50 +1000
User-Agent: KMail/1.9.6
Cc: rjw@sisk.pl, a1426z@gawab.com, jeremy@goop.org, jbms@cmu.edu, pavel@ucw.cz,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <200707081737.21932.a1426z@gawab.com> <200707112211.23420.nigel@nigel.suspend2.net> <E1I8bEi-0000HF-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I8bEi-0000HF-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4482918.74EIQDtoOt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707112246.54510.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4482918.74EIQDtoOt
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Wednesday 11 July 2007 22:24:04 Miklos Szeredi wrote:
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
> Hey, I know precious little about drivers and power management, but I
> can clarly see, that
>=20
>  a) stopping all tasks and requiring them to finish any syscall they
>  are in
>=20
>  b) stopping tasks _in the driver_ that are trying to access the
>  harware during/after suspend
>=20
> are completely different solutions, the later being much more fine
> grained and not having all of the mentioned problems that the former
> exhibits.

The point to freezing tasks isn't just to stop drivers doing work. It's als=
o=20
to stop userspace doing work and thereby increase reliability. The more wor=
k=20
that is occuring while we're trying to write a hibernation image, the less=
=20
reliable the hibernation will be (competing for memory and so on) and the=20
slower it will be (competing for cycles etc).
=20
> > IMHO, the real solution is to go back to the original issue and fix it=
=20
> > properly. Make fuse filesystems play nicely with the existing freezer.=
=20
I've=20
> > just gone back and looked at the point where you started talking=20
> > about "malicious filesystems". You talk about fuse imposing certain=20
ordering=20
> > in the userspace tasks being frozen. Please, say more. What ordering=20
issues?=20
> > Why? How can such ordering be determined programmatically?
>=20
> It can't.  If you are interested, please read through that thread.  If
> something's still not clear, let's discuss it further.

You can say it "imposes certain ordering" but you can say what that orderin=
g=20
is?! How about mount order? That must be a good start.

Regards,

Nigel (off to bed now).
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart4482918.74EIQDtoOt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGlNE+N0y+n1M3mo0RAoRbAJ0Wnu/GDjBou6K4b+SWE7HoZ+O/hgCeM7tU
CgxMR+wT7gow4KBdhcMCbKk=
=RI6o
-----END PGP SIGNATURE-----

--nextPart4482918.74EIQDtoOt--
