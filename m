Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbYDXASI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbYDXASI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 20:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYDXARz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 20:17:55 -0400
Received: from ozlabs.org ([203.10.76.45]:49967 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbYDXARz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 20:17:55 -0400
Subject: Re: [PATCH] pci: let pci_device_shutdown to call pci_disable_msi
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
       Jeff Garzik <jeff@garzik.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sathya Prakash <sathya.prakash@lsi.com>
In-Reply-To: <m1hcdsoh1i.fsf@frodo.ebiederm.org>
References: <200804222148.17530.yhlu.kernel@gmail.com>
	 <1208928277.9212.1.camel@concordia.ozlabs.ibm.com>
	 <m1hcdsoh1i.fsf@frodo.ebiederm.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-g0Q++rwmJEr937uZomgr"
Date: Thu, 24 Apr 2008 10:17:53 +1000
Message-Id: <1208996273.9245.18.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-g0Q++rwmJEr937uZomgr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-04-23 at 06:08 -0700, Eric W. Biederman wrote:
> Michael Ellerman <michael@ellerman.id.au> writes:
>=20
> > On Tue, 2008-04-22 at 21:48 -0700, Yinghai Lu wrote:
> >> this change
> >>=20
> >> | commit 23a274c8a5adafc74a66f16988776fc7dd6f6e51
> >> | Author: Prakash, Sathya <sathya.prakash@lsi.com>
> >> | Date:   Fri Mar 7 15:53:21 2008 +0530
> >> |
> >> |     [SCSI] mpt fusion: Enable MSI by default for SAS controllers
> >> |
> >> | This patch modifies the driver to enable MSI by default for all SAS =
chips.
> >> |
> >> |     Signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
> >> |     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnershi=
p.com>
> >> |
> >> cause kexec RHEL 5.1 kernel fail.
> >>=20
> >> root casue: the rhel 5.1 kernel still use INTx emulation.
> >> and mptscsih_shutdown doesn't call pci_disable_msi to reenable INTx on=
 kexec
> > path
> >>=20
> >> so try to call pci_disable_msi in shutdown patch
> >
> > How is kdump going to work? Your shutdown routine won't be called and
> > you'll have the same problem in the 2nd kernel, won't you?
>=20
> Taking a quick look our current msi initialization appears robust in
> not assuming the state of the msi config bits.

But does that help us? What if the device driver in the 2nd kernel
assumes it's using INTX, when in fact MSI is enabled on the device. In
that case none of the MSI code will even be called AFAIK.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-g0Q++rwmJEr937uZomgr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBID9GxdSjSd0sB4dIRAtj+AJ0RAvLgNuBGrkPcV+CtQJ7lQmWn4wCfQzhC
8BaGbG2xJGRi1Ikf9CHIn6E=
=LwVT
-----END PGP SIGNATURE-----

--=-g0Q++rwmJEr937uZomgr--

