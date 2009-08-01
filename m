Return-Path: <linux-kernel-owner+w=401wt.eu-S1751948AbZHAS3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbZHAS3E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 14:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZHAS3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 14:29:03 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:47550 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbZHAS3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 14:29:02 -0400
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when
 using pipes in core_pattern
From: Scott James Remnant <scott@ubuntu.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       earl_chew@agilent.com
In-Reply-To: <20090801134146.GA19910@localhost.localdomain>
References: <20090622172818.GB14673@hmsreliant.think-freely.org>
	 <1248880382.23840.78.camel@quest>
	 <20090729201857.GC17410@hmsreliant.think-freely.org>
	 <1249071610.4800.5.camel@wing-commander>
	 <20090801134146.GA19910@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4oc8BX2LJGVAqIAHqASu"
Date: Sat, 01 Aug 2009 19:28:52 +0100
Message-Id: <1249151332.6731.5.camel@wing-commander>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4oc8BX2LJGVAqIAHqASu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-08-01 at 09:41 -0400, Neil Horman wrote:

> > > Not without additional work.  If init crashed in the initramfs, I don=
't think
> > > theres a way to handle that.  If it crashes at some later time, I thi=
nk it just
> > > gets restarted IIRC.  I'm sure you can change that behavior, but this=
 patch
> > > doesn't address that.
> > >=20
> > When the system init daemon crashes, the kernel PANICs.  When not using
> > core_pattern, this is ok, we get a core file - when using apport, as fa=
r
> > as I can tell it never waits for apport to finish so we don't get the
> > crash.
> >=20
> This is non-sensical.  If init crashes, and the kernel panics, you'll onl=
y get a
> core by sheer luck and good fortune.
>=20
Or by being a bit clever.  Upstart catches the SIGSEGV and the signal
handler forks a child process, unmasking the signal in that child
process with no signal handler installed.

So it's really a child of init that core dumps, just ignore the signal
handler off the top of the stack trace and it's just as good as a core
dump from the init daemon itself.

Meanwhile the real init daemon (pid 1) wait()s on its child, and then
once it's reaped it exits itself - and then the kernel PANICs.


This works just fine with ordinary core files, because the kernel does
at least write out the core file beforehand.  With apport we don't get
this wait, thus I was hoping your patch would have that effect.

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-4oc8BX2LJGVAqIAHqASu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkp0iV8ACgkQSnQiFMl4yK7+oACgmLQe5o/lR/OyfofLX8qplogp
7SIAoKTmGG9g4V+2Vmgn7VMx1WRXN6Sz
=OhT2
-----END PGP SIGNATURE-----

--=-4oc8BX2LJGVAqIAHqASu--

