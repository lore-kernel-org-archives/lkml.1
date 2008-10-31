Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbYJaSTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbYJaSTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 14:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbYJaSS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 14:18:57 -0400
Received: from mx7.mail.ru ([194.67.23.27]:25763 "EHLO mx7.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbYJaSS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 14:18:57 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: mingo@redhat.com, avi@qumranet.com
Subject: [PATCH] Use BIOS reboot on Toshiba Portege 4000
Date: Fri, 31 Oct 2008 21:18:43 +0300
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1604902.nW8G26ojum";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810312118.45368.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1604902.nW8G26ojum
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Subject: [PATCH] Use BIOS reboot on Toshiba Portege 4000

=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

After commit c7ffa6c26277b403920e2255d10df849bd613380 which defaults
to reboot via ACPI keyboard is dead on Toshiba Portege 4000 upon reboot.
Power off is required to revive it again. Add DMI entry to force BIOS
reboot method as it was before.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

This fixes regression in 2.6.28. Commit log states:

    Triple-fault and keyboard reset may assert INIT instead of RESET; howev=
er
    INIT is blocked when Intel VT is enabled.  This leads to a partially re=
set
    machine when invoking emergency_restart via sysrq-b: the processor is s=
till
    working but other parts of the system are dead.

I wonder if we better check for VT bit instead of using DMI entries?

 arch/x86/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)


diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index f4c93f1..f9b28b3 100644
=2D-- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -197,6 +197,14 @@ static struct dmi_system_id __initdata reboot_dmi_tabl=
e[] =3D {
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq"),
 		},
 	},
+	{	/* Handle problems with rebooting on Toshiba Portege 4000 */
+		.callback =3D set_bios_reboot,
+		.ident =3D "Toshiba Portege 4000",
+		.matches =3D {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE 4000"),
+		},
+	},
 	{ }
 };
=20

--nextPart1604902.nW8G26ojum
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkLTAUACgkQR6LMutpd94zB4QCeKD1HvhdbyNCcEkl8JFTWs7Lc
GoQAmwRlNiH+z2ojygJB2DRtSZ1fKllk
=zxvi
-----END PGP SIGNATURE-----

--nextPart1604902.nW8G26ojum--
