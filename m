Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbYKQDx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbYKQDx3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 22:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755813AbYKQDxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 22:53:22 -0500
Received: from mx40.mail.ru ([194.67.23.36]:60761 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750AbYKQDxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 22:53:21 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Ingo Molnar <mingo@elte.hu>
Subject: 2.6.28-rc5: unused variable in pagetable_init
Date: Mon, 17 Nov 2008 06:53:12 +0300
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5506945.HBBdvKqDky";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811170653.16528.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5506945.HBBdvKqDky
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

  CC      arch/x86/mm/init_32.o
/home/bor/src/linux-git/arch/x86/mm/init_32.c: In function =E2=80=98pagetab=
le_init=E2=80=99:
/home/bor/src/linux-git/arch/x86/mm/init_32.c:515: warning: unused variable=
 =E2=80=98pgd_base=E2=80=99

Well, pagetable_init is noop unless HIGHMEM is defined so it could be
as simple as that.

Or is something else expected to go into pagetable_init for more general
case?

=2D-- arch/x86/mm/init_32.c       2008-11-10 06:19:14.000000000 +0300
+++ /tmp/init_32.c      2008-11-17 06:52:21.383685722 +0300
@@ -435,9 +435,17 @@ static void __init set_highmem_pages_ini
 }
 #endif /* !CONFIG_NUMA */

+static void __init pagetable_init(void)
+{
+       pgd_t *pgd_base =3D swapper_pg_dir;
+
+       permanent_kmaps_init(pgd_base);
+}
+
 #else
 # define permanent_kmaps_init(pgd_base)                do { } while (0)
 # define set_highmem_pages_init()      do { } while (0)
+# define pagetable_init()      do { } while (0)
 #endif /* CONFIG_HIGHMEM */

 void __init native_pagetable_setup_start(pgd_t *base)
@@ -510,13 +518,6 @@ static void __init early_ioremap_page_ta
        early_ioremap_reset();
 }

=2Dstatic void __init pagetable_init(void)
=2D{
=2D       pgd_t *pgd_base =3D swapper_pg_dir;
=2D
=2D       permanent_kmaps_init(pgd_base);
=2D}
=2D
 #ifdef CONFIG_ACPI_SLEEP
 /*
  * ACPI suspend needs this for resume, because things like the intel-agp

--nextPart5506945.HBBdvKqDky
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkg6qkACgkQR6LMutpd94xoeQCgppR2m49REfqBZL58KfWDeNkC
LQ8An2f2jA5Qtf7DYM9QtT3+Mr8t6/w9
=bCcS
-----END PGP SIGNATURE-----

--nextPart5506945.HBBdvKqDky--
