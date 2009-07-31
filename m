Return-Path: <linux-kernel-owner+w=401wt.eu-S1752063AbZGaUU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063AbZGaUU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 16:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbZGaUU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 16:20:26 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:35881 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbZGaUUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 16:20:25 -0400
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when
 using pipes in core_pattern
From: Scott James Remnant <scott@ubuntu.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       earl_chew@agilent.com
In-Reply-To: <20090729201857.GC17410@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org>
	 <1248880382.23840.78.camel@quest>
	 <20090729201857.GC17410@hmsreliant.think-freely.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-B0EJ+Zixww5Ef2aeMehk"
Date: Fri, 31 Jul 2009 21:20:10 +0100
Message-Id: <1249071610.4800.5.camel@wing-commander>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-B0EJ+Zixww5Ef2aeMehk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-07-29 at 16:18 -0400, Neil Horman wrote:

> On Wed, Jul 29, 2009 at 04:13:02PM +0100, Scott James Remnant wrote:
> > On Mon, 2009-06-22 at 13:28 -0400, Neil Horman wrote:
> >=20
> > > 2) Allow for the kernel to wait for a core_pattern process to complet=
e.  One of
> > > the things core_pattern processes might do is interrogate the status =
of a
> > > crashing process via its /proc/pid directory.  To ensure that that di=
rectory is
> > > not removed prematurely, we wait for the process to exit prior to cle=
aning it
> > > up.
> > >=20
> > Would this mean that the kernel would wait for the pattern process to
> > complete before PANIC in the case of init core dumping?
> >=20
> > I'd find that useful :-)
> >=20
> Not without additional work.  If init crashed in the initramfs, I don't t=
hink
> theres a way to handle that.  If it crashes at some later time, I think i=
t just
> gets restarted IIRC.  I'm sure you can change that behavior, but this pat=
ch
> doesn't address that.
>=20
When the system init daemon crashes, the kernel PANICs.  When not using
core_pattern, this is ok, we get a core file - when using apport, as far
as I can tell it never waits for apport to finish so we don't get the
crash.

I was hoping that by waiting for the core_pattern process to finish,
this might solve this issue.

The other obvious fix I can apply to the init daemon is to reset the
core pattern and deliberately dump core somewhere that can be picked up.

> If you want to debug a custom init process, why not run a wrapper program=
 as
> init, that just forks the init you want to run and captures the core when=
 it
> crashes?
>=20
Because then that's not the init daemon; it's not pid 1, it doesn't have
processes reparented to it.  And it's very annoying having the entire
system reparented to gdb, which doesn't deal so well with that ;-)

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-B0EJ+Zixww5Ef2aeMehk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpzUfUACgkQSnQiFMl4yK5e/QCdEI3CbFyM2wHUxgjgvZ9mXfu4
5YcAoIYW0luDvVuN3MBsoaS+uLsxsmMW
=P5Lo
-----END PGP SIGNATURE-----

--=-B0EJ+Zixww5Ef2aeMehk--

