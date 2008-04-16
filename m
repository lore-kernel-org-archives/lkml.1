Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbYDPSIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbYDPSIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbYDPSIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:08:09 -0400
Received: from home.keithp.com ([63.227.221.253]:4664 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbYDPSII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:08:08 -0400
X-Greylist: delayed 614 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Apr 2008 14:08:08 EDT
Subject: Mapping PCI BAR through /sys/devices/pci* sets cache-disable and
	write-through
From: Keith Packard <keithp@keithp.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-v3DYzsy5TmSwoCJAZSR9"
Date: Wed, 16 Apr 2008 10:40:26 -0700
Message-Id: <1208367626.5245.5.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-v3DYzsy5TmSwoCJAZSR9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

The X server recently (within the last year) switched from mapping the
frame buffer from /dev/mem to using /sys/devices/pci*. This caused a
significant memory bandwidth reduction for writes, similar to the effect
caused when the associated MTRR is set to UC instead of WC.

Looking at the code path, we find, in i386:pci_mmap_page_range:

        prot =3D pgprot_val(vma->vm_page_prot);
        if (boot_cpu_data.x86 > 3)
                prot |=3D _PAGE_PCD | _PAGE_PWT;
        vma->vm_page_prot =3D __pgprot(prot);

Which is to say, on any CPU which supports it, force the cache-disable
and write-through bits on.

Is there some reason this is there? Surely applications should be
expected to set these attributes correctly, currently using MTRR and in
the future, using PAT directly.

--=20
keith.packard@intel.com

--=-v3DYzsy5TmSwoCJAZSR9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIBjoKQp8BWwlsTdMRArpCAJ9aNBgDJvNu67hzDxORi2t33C9kLQCfd5jd
oTwdmTruQQ73Av61I/nHWmE=
=/73v
-----END PGP SIGNATURE-----

--=-v3DYzsy5TmSwoCJAZSR9--

