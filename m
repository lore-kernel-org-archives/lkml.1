Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbXD0HDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbXD0HDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753512AbXD0HDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:03:22 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:37444 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbXD0HDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:03:21 -0400
Subject: Re: Back to the future.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704270939460.20493@sbz-30.cs.Helsinki.FI>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com>
	 <1177573348.5025.224.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
	 <1177617379.4737.29.camel@nigel.suspend2.net>
	 <Pine.LNX.4.64.0704270750320.13539@sbz-30.cs.Helsinki.FI>
	 <1177654110.4737.91.camel@nigel.suspend2.net>
	 <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI>
	 <1177655661.4737.106.camel@nigel.suspend2.net>
	 <Pine.LNX.4.64.0704270939460.20493@sbz-30.cs.Helsinki.FI>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZAjFep5RiM17n3PBbpfg"
Date: Fri, 27 Apr 2007 17:03:20 +1000
Message-Id: <1177657400.4737.121.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZAjFep5RiM17n3PBbpfg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Fri, 2007-04-27 at 09:50 +0300, Pekka J Enberg wrote:
> On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> > Sorry Pekka, but that's just broken.
>=20
> It certainly isn't.
>=20
> On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> > It implies firstly that we tell all userspace programs "I'm sorry, but
> > I'm suspending at the moment. Can you tip toe quietly around while I do
> > it?" You can't seriously expect every userspace program to be modified
> > to adjust it's behaviour according to whether we're writing a snapshot
> > to disk at the moment or not.
>=20
> You don't need to modify other programs. You just need to display the=20
> progress bar and block _user input_. I don't even claim to know X, but I=20
> would be extremely surprised if you technically can't say "don't let=20
> the user touch any other windows except this one." The user couldn't care=
=20
> less whether tasks are frozen or not by the kernel. What matters is that=20
> the user can't shoot himself in the foot while snapshotting.

User input doesn't account for all system activity. Think of cron jobs
or user initiated jobs that may have started before the cycle began.

> Furthermore, we probably do need to do other things to ensure safety, lik=
e=20
> remounting filesystems read-only but again, this has nothing to do with=20
> snapshotting per se. What the kernel needs to worry about is (1) providin=
g=20
> an atomic snapshot that is consistent and (2) resuming to that snapshot=20
> safely. If the _user_ loses data that was generated between snapshot +=20
> shutdown, it's absolutely no concern for the snapshot operation!

Noooo! If the user looses data, the user will be concerned and we should
be. I for one would do my best to avoid using software that loses my
data for me. I wouldn't care if you said "Well, it's your fault. You
lost the data." From my perspective as a user, I didn't lose the data,
some part of the computer's OS did.

> On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> > It also implies that we can prepare a snapshot and then happily have th=
e
> > contents of the disk change so that they don't match the superblock and
> > other filesystem details we just saved in the snapshot. We can't. At
> > least not without modifying all the filesystems so that (at a minimum)
> > they know how to throw away all the metadata they have at resume time
> > and reread it from disk.
>=20
> But you just explained how we can! We shouldn't bend over backwards for=20
> snapshotting just because the filesystems don't currently support=20
> something we need.

Sorry, but I just don't believe filesystems should need to throw away
metadata post resume. If we let data be changed after snapshotting (or
ourselves cause it to be changed), we're the ones that are broken. Our
snapshot is out of date and the expectations of userspace programs that
were snapshotted will be out of date. Just imagine, for example, a
userspace program that is snapshotted, then reads and deletes a
temporary file. After the snapshot restore, it's running again. But
wait, we can't read or delete the file again because it's already gone.
Life just gets more complicated and confusing this way.

> On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> > By the way, sorry. This email feels like it is pouring a lot of cold
> > water on your ideas. I don't want to be negative!
>=20
> Don't worry, I am used to cold water :-).

Maybe, but I'd still rather be encouraging!

Nigel

--=-ZAjFep5RiM17n3PBbpfg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMaA4N0y+n1M3mo0RAo8iAJ9u0EtFb+9ICDM8aQY3aYnadqUkXwCeOwH6
IHymTO8NfMDCnv87CWvmpAQ=
=uMrB
-----END PGP SIGNATURE-----

--=-ZAjFep5RiM17n3PBbpfg--

