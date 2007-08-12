Return-Path: <linux-kernel-owner+w=401wt.eu-S1761550AbXHLHpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761550AbXHLHpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 03:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbXHLHpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 03:45:24 -0400
Received: from fallback.mail.ru ([194.67.57.14]:26794 "EHLO mx4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbXHLHpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 03:45:22 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] Add support for 1533 bridge to alim1535_wdt.
Date: Sun, 12 Aug 2007 11:44:26 +0400
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart13192176.mgJcuifX2z";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708121144.28210.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart13192176.mgJcuifX2z
Content-Type: multipart/mixed;
  boundary="Boundary-01=_cprvG/QC/ip30Y7"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_cprvG/QC/ip30Y7
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

They are apparently pretty close (even lspci combines them). The patch
adds support for 0x1533 bridge in addition to 0x1535.

Tested on Toshiba Portege 4000 with

00:07.0 ISA bridge [0601]: ALi Corporation M1533/M1535 PCI to ISA Bridge
[Aladdin IV/V/V+] [10b9:1533]
00:08.0 Bridge [0680]: ALi Corporation M7101 Power Management Controller
[PMU] [10b9:7101]

with result

[ 2090.906736] PCI: Enabling device 0000:00:08.0 (0000 -> 0001)
[ 2090.914034] ALi_M1535: initialized. timeout=60 sec (nowayout=0)

Patch with proper attribution attached.

--Boundary-01=_cprvG/QC/ip30Y7
Content-Type: text/x-diff;
  charset="us-ascii";
  name="alim1535_wdt_1533-support"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="alim1535_wdt_1533-support"

Subject: [PATCH] Add support for 1533 bridge to alim1535_wdt.
=46rom: Andrey Borzenkov <arvidjaar@mail.ru>

They are apparently pretty close (even lspci combines them). The patch
adds support for 0x1533 bridge in addition to 0x1535.

Tested on Toshiba Portege 4000 with

00:07.0 ISA bridge [0601]: ALi Corporation M1533/M1535 PCI to ISA Bridge
[Aladdin IV/V/V+] [10b9:1533]
00:08.0 Bridge [0680]: ALi Corporation M7101 Power Management Controller
[PMU] [10b9:7101]

with result

[ 2090.906736] PCI: Enabling device 0000:00:08.0 (0000 -> 0001)
[ 2090.914034] ALi_M1535: initialized. timeout=3D60 sec (nowayout=3D0)

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>

=2D--

 drivers/char/watchdog/alim1535_wdt.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/char/watchdog/alim1535_wdt.c b/drivers/char/watchdog/a=
lim1535_wdt.c
index e3f6a7d..df51bfc 100644
=2D-- a/drivers/char/watchdog/alim1535_wdt.c
+++ b/drivers/char/watchdog/alim1535_wdt.c
@@ -312,6 +312,7 @@ static int ali_notify_sys(struct notifier_block *this, =
unsigned long code, void
  */
=20
 static struct pci_device_id ali_pci_tbl[] =3D {
+	{ PCI_VENDOR_ID_AL, 0x1533, PCI_ANY_ID, PCI_ANY_ID,},
 	{ PCI_VENDOR_ID_AL, 0x1535, PCI_ANY_ID, PCI_ANY_ID,},
 	{ 0, },
 };
@@ -329,9 +330,11 @@ static int __init ali_find_watchdog(void)
 	struct pci_dev *pdev;
 	u32 wdog;
=20
=2D	/* Check for a 1535 series bridge */
+	/* Check for a 1533/1535 series bridge */
 	pdev =3D pci_get_device(PCI_VENDOR_ID_AL, 0x1535, NULL);
 	if(pdev =3D=3D NULL)
+		pdev =3D pci_get_device(PCI_VENDOR_ID_AL, 0x1533, NULL);
+	if(pdev =3D=3D NULL)
 		return -ENODEV;
 	pci_dev_put(pdev);
=20

--Boundary-01=_cprvG/QC/ip30Y7--

--nextPart13192176.mgJcuifX2z
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGvrpcR6LMutpd94wRAnkQAJ4m2xuWs3Vuz8TQijMQ7TCzQut/9QCfYBA6
u2SFVGPaaRTysd7JVuFhQ1Y=
=J81r
-----END PGP SIGNATURE-----

--nextPart13192176.mgJcuifX2z--
