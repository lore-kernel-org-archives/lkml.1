Return-Path: <linux-kernel-owner+w=401wt.eu-S1756320AbYATB3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbYATB3p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 20:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751931AbYATB3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 20:29:36 -0500
Received: from lug-owl.de ([195.71.106.12]:58530 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbYATB3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 20:29:35 -0500
Date: Sun, 20 Jan 2008 02:29:34 +0100
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Rafael Sisto <rafael.sisto@gmail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: new file in kernel.
Message-ID: <20080120012934.GE9896@lug-owl.de>
Mail-Followup-To: Rafael Sisto <rafael.sisto@gmail.com>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Linux kernel <linux-kernel@vger.kernel.org>
References: <ee3dc96c0801190542u2f91a2eax3bcfd0268d4850b4@mail.gmail.com> <Pine.LNX.4.64.0801191448140.27831@fbirervta.pbzchgretzou.qr> <ee3dc96c0801190608q33aee0aer133611a1fc392bb4@mail.gmail.com> <Pine.LNX.4.64.0801191526200.27831@fbirervta.pbzchgretzou.qr> <ee3dc96c0801190712v56bcfde5qa015888f2bcbde98@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vR/vnstCraLpx+OT"
Content-Disposition: inline
In-Reply-To: <ee3dc96c0801190712v56bcfde5qa015888f2bcbde98@mail.gmail.com>
X-Operating-System: Linux mail 2.6.18-5-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vR/vnstCraLpx+OT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-01-19 12:12:10 -0300, Rafael Sisto <rafael.sisto@gmail.com> wr=
ote:
> Dear Jan,
>=20
> The idea of the indirection is to make it transparent for the user.
> The idea is to do almost the same as what IPC does. The user calls
> "get", then "attach". In the "get" syscall I create a tmp file and
> return some id. Then the user calls an "attach" syscall with the
> returned id.
>=20
> The result is that he gets a shared memorymapped to his vma.

So my understanding is that you want to get a "IPC shared memory for
dummies" API. You're already willing to use custom-numbered system
calls, requiring to recompile the Linux kernel, having to add these
system calls to libc (or putting _syscallX macros into the
application's code) and loosing all portability for the application
using this API.

My point of view is that this is a planed nightmare :)

I'd suggest to dig into "Unix Network Programming, Volume 2.
Interprocess Communications" and implement that API as a library
instead of using a set of new kernel system calls. That way, the
applications using it will use that API and only that. They won't
require operatins system specific modifications afterwards. OTOH, this
library will probably quite portable by itself and shouldn't need
any kernel changes, independent of the underlying kernel.

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
 Signature of:                      http://perl.plover.com/Questions.html
 the second  :

--vR/vnstCraLpx+OT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHkqP9Hb1edYOZ4bsRAtUzAKCKvKPIgc58hDSL4V1XXny2x6VBgACeNxGF
nbkSbVGVuP1G6kOM91xrvn4=
=XzNR
-----END PGP SIGNATURE-----

--vR/vnstCraLpx+OT--
