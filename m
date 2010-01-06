Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379Ab0AFWFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab0AFWFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:05:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932832Ab0AFWEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:04:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932964Ab0AFWEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:04:49 -0500
Date: Wed, 6 Jan 2010 16:04:34 -0600
From: Clark Williams <williams@redhat.com>
To: Carsten Emde <Carsten.Emde@osadl.org>
Cc: John Kacur <jkacur@redhat.com>, RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [rt-tests] change to cyclictest behavior
Message-ID: <20100106160434.77efc790@torg>
In-Reply-To: <4B4502FD.1000404@osadl.org>
References: <20100106130400.7f30ae55@torg>
	<520f0cf11001061139j2af13403qfcbf567647bdfaa8@mail.gmail.com>
	<4B4502FD.1000404@osadl.org>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WZ4aAU4MRzTO.weBUrzZgsH"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/WZ4aAU4MRzTO.weBUrzZgsH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 06 Jan 2010 22:39:09 +0100
Carsten Emde <Carsten.Emde@osadl.org> wrote:
> I know that there are quite a few people out there who get furious, if
> someone breaks backward compatibility - especially in things that are
> used for automatic testing. Cyclictest is such a thing.
>=20
> In addition, I would propose to consider not only affinity but also the
> number of threads. If, for example, someone specifies -a -t5 on a
> four-way machine, then it may not make sense to use the same priority
> and the same interval on all threads. If any, the new feature would only
> make sense in cases where both the -a and the -t option do not have an
> argument so the number of threads matches the number of CPUs and every
> thread runs on its own CPU. Another pitfall is hyperthreading in which
> case it may be desired to have as many threads at the same priority as
> real CPUs rather than as available hyperthreads.
>=20
> Here is my proposal:
> Do not change the meaning of existing options. Introduce a new option
> that is mutual exclusive with the -a, the -t and the -d option. This new
> option does the same as -a and -t and -d0 and sets the same priority to
> all threads. How about that?
>=20

Ugh, I truly *hate* adding options. Do you know that cyclictest is
halfway to having as many options as 'ls'? That being said, I had
forgotten that you can provide a list of cpus to -a (as well as -t) so
my quick hack really isn't as safe as I first thought it would be.=20

How about if we create the -S/--smp option that takes no arguments and
causes -a, -t and -d to be ignored (with a warning). This option would
create one thread per cpu, each thread pinned to it's corresponding
cpu, all with the same sampling interval (i.e. -d0) and the same
priority?

Clark

--Sig_/WZ4aAU4MRzTO.weBUrzZgsH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAktFCPYACgkQHyuj/+TTEp2LvwCgnJFMaTfRT6Q0zoTGzvr7D0YQ
B6QAn1jNsXB6Rps6UDFj18E4R+iwdth/
=B8t/
-----END PGP SIGNATURE-----

--Sig_/WZ4aAU4MRzTO.weBUrzZgsH--
