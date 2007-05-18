Return-Path: <linux-kernel-owner+w=401wt.eu-S1761253AbXERC7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253AbXERC7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 22:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbXERC7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 22:59:11 -0400
Received: from moa.IfA.Hawaii.Edu ([128.171.168.48]:36163 "EHLO
	moa.ifa.hawaii.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984AbXERC7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 22:59:11 -0400
Date: Thu, 17 May 2007 17:04:36 -1000
From: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
To: Dave Jones <davej@redhat.com>
Cc: Duane Griffin <duaneg@dghda.com>, Prakash Punnoor <prakash@punnoor.de>,
       LKML <linux-kernel@vger.kernel.org>, Daniel Drake <dsd@gentoo.org>,
       Ed Sweetman <safemode2@comcast.net>
Subject: Re: [PATCH] Kconfig powernow-k8 driver should depend on ACPI P-States driver
Message-ID: <20070518030436.GB20793@ifa.hawaii.edu>
References: <20070516011711.GE15763@ifa.hawaii.edu> <200705162039.02379.prakash@punnoor.de> <e9e943910705161253i75750876s1789b7844c87e97@mail.gmail.com> <20070516204807.GA23751@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline
In-Reply-To: <20070516204807.GA23751@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I think it's pretty clear that Dave and Daniel were both correct and
that ACPI_PROCESSOR is the correct dependency for multi-socket systems.
However, it's worth noting that this dependency seems to be unrelated to
SMP support.  Ed Sweetman has reported that his single-socket but
multi-core system doesn't require ACPI_PROCESSOR for powernow support.
I just tried booting 2.6.21 w/o SMP support and w/o ACPI_PROCESSOR on
one of my multi-socket/multi-core systems.  Sure enough, powernow=20
won't work without ACPI_PROCESSOR:

powernow-k8: Found 1 Dual-Core AMD Opteron(tm) Processor 2220 processors (v=
ersion 2.00.00)
powernow-k8: BIOS error - no PSB or ACPI _PSS objects

I suppose this means that the BIOS does something different to enable
SMP on a multi-core single socket and multi-socket systems.  Anyways, I
believe the question that needs to be answered is: is it reasonable for
X86_POWERNOW_K8 to select ACPI_PROCESSOR if SMP is set?  I'm not sure we
can do anything more intelligent unless Kconfig had more knowledge of
how the hardware other than just SMP/!SMP.

-J

--
On Wed, May 16, 2007 at 04:48:07PM -0400, Dave Jones wrote:
> On Wed, May 16, 2007 at 08:53:13PM +0100, Duane Griffin wrote:
>  > On 16/05/07, Prakash Punnoor <prakash@punnoor.de> wrote:
>  > > Maybe you want to give a hint in the p states driver help text?
>  >=20
>  > I think a hint is the right thing to do, but in the PowerNow! driver
>  > rather than the p states one. How about adding something like this to
>  > the X86_POWERNOW_K8 (and X86_POWERNOW_K7?) help text:
>=20
> The mobile K7s which had powernow support weren't SMP capable, so they're
> irrelevant.
>=20
>  > "ACPI support is required for non-UP systems and requires ACPI_PROCESS=
OR
>  >  to be selected. If ACPI_PROCESSOR is compiled as a module then this
>  >  option must be too in order for ACPI support to be available."
>=20
> X86_POWERNOW_K8_ACPI is already 'default y'. I think the problem lies in
> that people aren't enabling its dependancy, ACPI_PROCESSOR.
>=20
> We want something along the lines of..
>=20
> config X86_POWERNOW_K8_ACPI
> 	bool
> 	if SMP & X86_POWERNOW_K8_ACPI
> 	  select ACPI_PROCESSOR
>=20
> kconfig language quirks aside..
>=20
>=20
> 	Dave
>=20
> --=20
> http://www.codemonkey.org.uk

--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFGTRfEWa2BU+b7tU0RAtHOAKCX1fluHXzkd5pwncYu3mu+a3tfgACgmWM/
55jkBF6d1AaxLAgOEpQUu3Y=
=c7DC
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
