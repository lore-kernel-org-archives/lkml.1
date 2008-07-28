Return-Path: <linux-kernel-owner+w=401wt.eu-S1757433AbYG1Prr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433AbYG1Prr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 11:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752068AbYG1Prk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 11:47:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57177 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbYG1Prj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 11:47:39 -0400
Date: Tue, 29 Jul 2008 01:47:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: eranian@googlemail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 00/19] perfmon2 minimal v3:  introduction
Message-Id: <20080729014730.76b879a4.sfr@canb.auug.org.au>
In-Reply-To: <4868dbf6.0af5660a.1972.52f4@mx.google.com>
References: <4868dbf6.0af5660a.1972.52f4@mx.google.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__29_Jul_2008_01_47_30_+1000_EIX.GyFJs.xJCciU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Jul_2008_01_47_30_+1000_EIX.GyFJs.xJCciU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephane,

On Mon, 30 Jun 2008 06:13:26 -0700 (PDT) eranian@googlemail.com wrote:
>
> The following patches implement a minimal perfmon2 subsystem which provid=
es
> access to the hardware performance counters of modern processors.

First up, I cannot speak to the actual function of the patches, but just
to the mechanics of getting them into the kernel.  One good thing is that
with CONFIG_PERFMON turned off, it looks like the impact is very close to
zero. Two obvious things that would help these being accepted are:

	ordering - in the current incarnation, the patches produce places
where the kernel will not build.  We like things to be ordered so that
git bisection does not fail if at all possible - that means that an
allmod/yesconfig should build after the application of each patch.
Currently this is not so.  It could be mode to do so trivially by
delaying the "global" Kconfig/Makefile updates until later in the
sequence.  And you really should introduce the system calls *before*
wiring them up.

	quite a few of the macros (especially for the dummy (non
CONFIG_PERFMON) versions of functions) should be "static inline"
functions unless they absolutely must be macros.  Andrew Morton said it
best - "write in C not C preprocessor".

I can see that this infrastructure could be very useful and I appreciate
that it has been cut down for this initial merge.  These patches (even as
they are) compare favourably to some other new infrastructure that has
been introduced.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__29_Jul_2008_01_47_30_+1000_EIX.GyFJs.xJCciU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiN6hIACgkQjjKRsyhoI8zEhwCeNeV0y52N1Nz3MBhOsZn2bGr7
GcYAoLc0S1M732v9F6VZ1By0QYQiYrkp
=g60t
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Jul_2008_01_47_30_+1000_EIX.GyFJs.xJCciU--
