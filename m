Return-Path: <linux-kernel-owner+w=401wt.eu-S1763283AbXF1Kwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763283AbXF1Kwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 06:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756878AbXF1Kwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 06:52:38 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:33397 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757403AbXF1Kwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 06:52:37 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: linuxsh-dev@lists.sourceforge.net
Subject: Re: 2.6.22-rc6 on Dreamcast (SH4)
Date: Thu, 28 Jun 2007 06:53:14 -0400
User-Agent: KMail/1.9.7
Cc: Adrian McMenamin <adrian@newgolddream.dyndns.info>,
       LKML <linux-kernel@vger.kernel.org>
References: <1182810862.6017.2.camel@localhost.localdomain>
In-Reply-To: <1182810862.6017.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1639096.T8bK5irRbL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706280653.15577.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1639096.T8bK5irRbL
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 25 June 2007, Adrian McMenamin wrote:
> Still getting this:
>
>  MODPOST vmlinux
> WARNING: arch/sh/boards/dreamcast/built-in.o(.data+0x0): Section
> mismatch: reference to .init.text: (between 'mv_dreamcast' and
> 'systemasic_int')
> WARNING: drivers/built-in.o(.text+0x168e0): Section mismatch: reference
> to .init.data: (between 'pvr2fb_check_var' and 'pvr2fb_interrupt')
> WARNING: drivers/built-in.o(.text+0x1701c): Section mismatch: reference
> to .init.data: (between 'pvr2fb_pci_probe' and 'read_mem')
> WARNING: drivers/built-in.o(.text+0x17024): Section mismatch: reference
> to .init.text: (between 'pvr2fb_pci_probe' and 'read_mem')
> WARNING: drivers/built-in.o(.data+0x738): Section mismatch: reference
> to .init.text: (between 'board_list' and 'pvr2fb_pci_driver')
> WARNING: drivers/built-in.o(.data+0x750): Section mismatch: reference
> to .init.text: (between 'board_list' and 'pvr2fb_pci_driver')

it means there is code that is not marked as init making references=20
function/data that is marked as init ... this is normally not noticed at bo=
ot=20
as the init sections arent cleared/clobbered until well after boot and=20
usually these are problems just for initialization routines ...

i'd review the symbols that are being warned about here to see if they're=20
missing the proper section markers (aka functions that should be labeled as=
=20
__init but arent)
=2Dmike

--nextPart1639096.T8bK5irRbL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iQIVAwUARoOTG0FjO5/oN/WBAQJqgQ/9FRaZT3HCuh+ZkfZryeAxuVLnVNC1gEC6
MAx2Kda7czKCCO7ng7i9jAS8OG8w/3GL/CkY4VrRGaN2QCrb64Rkf/FcOoWz5fxS
gbsN32MZRNokhLudzeLlMkhZZRB4HbZq/F0IBK5f28S5uLQyHB0f+H568C23i2ig
ZceeldLUTkYAlimQ1K6OP0Jp7tRhlukh8pF9/RGU7UoFeWA/8rsJVtA0+llft4pF
p3MrDtAq+86x/qRRTukbFSaxVVyybKJHkrOhGNKhbUjk6ORoGb5m2nLKRF5vKFxU
ZTaUkYAZkfFKvWzc+J3sh6Byz7sks3Y6U1FMhvq3ewwEc0LnjFl8EkW54cPGgkvt
zNVXFg7Hvu2nK8WVaBlLM2fj/A8X+K3w6yS7I3zkyYaALVCDBsSQyTA1X1isUYHa
vmcpfEyYim+QihG68EL0I9OpYgVShYDMMsX3O3b4zAxAnYCQWElOEEFD8gTUh+yk
nEWMMO7OfSQzw3TvF+ALEMIOSuKefEj7BCDB2yT113EK4f+1Rjxh5QlHcs87/6lI
ziGoGSPlNeI0/tHifqoNVWK7Nh/CPh56Z8Qjn1LkFm1i/s99piZJfCyMATLHGmtY
zEcAodTzbN59t7juOzew7yJ/NmzVzqzV9CqgpsD2Xqen++AH1M+Xo8Cywba53FAn
57pZjgoXeo4=
=sxWm
-----END PGP SIGNATURE-----

--nextPart1639096.T8bK5irRbL--
