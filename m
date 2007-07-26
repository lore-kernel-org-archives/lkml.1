Return-Path: <linux-kernel-owner+w=401wt.eu-S934258AbXGZTh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934258AbXGZTh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 15:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764890AbXGZThR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 15:37:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764302AbXGZThP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 15:37:15 -0400
Subject: Re: [PATCH] core_pattern: Add ability for core_pattern to parse
	arguments when pattern is a pipe
From: Will Woods <wwoods@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070726114832.faf14bb0.akpm@linux-foundation.org>
References: <20070726173923.GA5701@hmsreliant.homelinux.net>
	 <20070726114832.faf14bb0.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AqrJ6gykzP8UEDBZEscs"
Date: Thu, 26 Jul 2007 15:36:24 -0400
Message-Id: <1185478584.15670.31.camel@metroid.rdu.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AqrJ6gykzP8UEDBZEscs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-07-26 at 11:48 -0700, Andrew Morton wrote:
> On Thu, 26 Jul 2007 13:40:19 -0400 Neil Horman <nhorman@tuxdriver.com> wr=
ote:
>=20
> > 	Currently, core dumps can be redirected to a pipe by placing the
> > following string template in /proc/sys/kernel/core_pattern:
> > |<path/to/application>
> > This patch extends this ability, allowing the core_pattern to contain a=
rguments
> > to be passed as an argv array to the userspace helper application.  It =
also add
> > a format specifier, %c, which allows the RLIM_CORE value of the crashin=
g
> > application to be passed on the command line, since RLIMIT_CORE is redu=
ced to
> > zero when execing the userspace helper
>=20
> This all seems to be getting a bit nutty.  Who needs this feature
> and what will they do with it, etc?

We're using it for doing a system-wide crash dump handler. Currently
Ubuntu's using it with their Apport tool[1] for this purpose; I'm
adapting that for Fedora.=20

The Ubuntu approach requires a kernel patch that adds a bunch of process
information (process pid, RLIMIT_CORE, etc) to the environment of the
crash handler[2]. Most of that information can instead be parsed out of
the ELF headers - which is what I wrote code to do[3]. The problem that
remains is determining the value of RLIMIT_CORE. (This is used to
determine whether the user wants a normal corefile, thus retaining
normal core dump behavior).=20

As I understand it, getrlimit() won't return the correct values while
dumping to a pipe. So we need to pass the original RLIMIT_CORE to the
userspace helper somehow. It seems sensible to pass arguments to a
userspace program by using argv[]. So there we are.

There's probably many other uses for this stuff but that's the specific
one we're targeting. Does that make sense? If there's an easier way to
get the original RLIMIT_CORE from inside the crash handler, I'd love to
hear it.

-w

[1] https://wiki.ubuntu.com/Apport=20
[2]
http://kernel.ubuntu.com/git?p=3Dubuntu/ubuntu-feisty.git;a=3Dblob;hb=3DHEA=
D;f=3Dfs/exec.c#l1557
[3] http://rdr.to/bX


--=-AqrJ6gykzP8UEDBZEscs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGqPe3xFCbdxAvWVsRAgY9AJsGD2D5hMIMHBS1IZeeHVSd/dNfKgCfTCB9
nHnWJf/P6/EGP858vVqvvU8=
=BH1d
-----END PGP SIGNATURE-----

--=-AqrJ6gykzP8UEDBZEscs--

