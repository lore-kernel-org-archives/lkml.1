Return-Path: <linux-kernel-owner+w=401wt.eu-S1752335AbXC0Dst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbXC0Dst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 23:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbXC0Dss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 23:48:48 -0400
Received: from ozlabs.org ([203.10.76.45]:33731 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbXC0Dsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 23:48:47 -0400
Subject: Re: [RFC: 2.6.21 patch] let PCI_MSI depend on EXPERIMENTAL
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Miller <davem@davemloft.net>, bunk@stusta.de, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
In-Reply-To: <m14po71ir7.fsf@ebiederm.dsl.xmission.com>
References: <20070327010247.GW16477@stusta.de>
	 <20070326.182422.115910859.davem@davemloft.net>
	 <m14po71ir7.fsf@ebiederm.dsl.xmission.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6cUN2o0i6plS+jIFKAiB"
Date: Tue, 27 Mar 2007 13:48:45 +1000
Message-Id: <1174967325.5348.21.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6cUN2o0i6plS+jIFKAiB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-03-26 at 21:13 -0600, Eric W. Biederman wrote:
> David Miller <davem@davemloft.net> writes:
>=20
> > From: Adrian Bunk <bunk@stusta.de>
> > Date: Tue, 27 Mar 2007 03:02:47 +0200
> >
> >> We had during the last months have quite a few MSI bugs and even=20
> >> regressions due to:
> >> - core kernel bugs,
> >> - device driver bugs and
> >> - hardware bugs
>    - architecture bugs
>    - MSI enabled on hardware that does not support it.
>=20
> aka.  Drivers have started supporting MSI, People have started using
> and testing MSI, and there has been MSI maintenance.  People care.
>=20
> The most recent regressions involving MSI have been fixes propagating
> their way through the kernel, and I can't think of a one of them
> that was MSI specific.  Just that the bug didn't happen to show
> up clearly without MSI enabled.
>=20
> Finding that pci_save_state/pci_restore_state had serious resources
> leaks was nasty.
>=20
> Finding that pci_enable_device isn't suspend/resume safe as
> implemented on x86 and ia64 is very nasty.  Currently on x86 it is
> only really safe to call pci_enable_device exactly once.  But the bugs
> are small enough we don't generally notice.
>=20
> Personally I prefer glaring outstanding bugs to little subtle once
> that only bite you on the second Tuesday of the month.
>=20
> The recent MSI maintenance has shifted the code around enough that
> problems became visible.  I'm not happy with this but I don't expect
> this to be an on-going state of affairs.
>=20
> >> OTOH, MSI doesn't bring any real advantages for most users.
>=20
> So default it to off, although I suspect we are approaching the
> point where it would actually be safe to default it to on.  We
> need a kernel release that doesn't have msi issues yet.
>=20
> >> Let's therefore mark PCI_MSI as EXPERIMENTAL.
> >>=20
> >> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> >
> > This is a good way to ensure that the code doesn't get tested
> > enough to ever fix the problems.
>=20
> Dave I agreed.  PCI_MSI is not the problem.
>=20
> I think marking PCI_MSI as EXPERIMENTAL now would be closing the
> barn door after the horses have fled.  I don't know of a core MSI
> code path that hasn't been scrutinized lately.  I wouldn't say they
> are perfect but they are junk either.  Especially given that the
> code is not good enough where non x86 architectures can support
> MSI.
>=20
> There is one big remaining real world problem and that is we enable
> MSI optimistically.  Resulting in it being enabled on chipsets that
> don't support MSI.  We still need to change that behavior.  I have
> been buried in the guts of things so I haven't had the free cycles to
> worry about that yet, nor have there been enough people complaining
> that it has crossed my pain threshold to just fix the thing.
>=20
> I think where we are honestly at is that today MSI works on most new
> chipsets.   MSI is supported by the hardware.  MSI is supported by the
> OS.  With a little more maturity devices and device drivers will start
> taking advantage of in ways that matter to users now that it works.

.. and we will start to see more and more hardware that _only_ uses MSI.
So we need to get it fixed, rather than sweeping the bugs under the
carpet 'til later.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-6cUN2o0i6plS+jIFKAiB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBGCJQddSjSd0sB4dIRAmhHAJ9oSWDQ7abErFTLhB/CyR/SaGa45gCeIqO5
ERp+uHQd00nO3ArXLW3aZeY=
=SWuO
-----END PGP SIGNATURE-----

--=-6cUN2o0i6plS+jIFKAiB--

