Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbZDXCpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbZDXCpu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 22:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbZDXCp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 22:45:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:65373 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756849AbZDXCpZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 22:45:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,238,1239001200"; 
   d="asc'?scan'208";a="406373375"
Subject: [PATCH 2/4] PCI: PCIE AER: export aer_irq
From: Huang Ying <ying.huang@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AlK36SHLEE0R79wOcBcY"
Date: Fri, 24 Apr 2009 10:45:23 +0800
Message-Id: <1240541123.6842.680.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AlK36SHLEE0R79wOcBcY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This is used by PCIE AER error injection to fake an PCI AER interrupt.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 drivers/pci/pcie/aer/aerdrv.c |    3 ++-
 drivers/pci/pcie/aer/aerdrv.h |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/pci/pcie/aer/aerdrv.h
+++ b/drivers/pci/pcie/aer/aerdrv.h
@@ -11,6 +11,7 @@
 #include <linux/workqueue.h>
 #include <linux/pcieport_if.h>
 #include <linux/aer.h>
+#include <linux/interrupt.h>
=20
 #define AER_NONFATAL			0
 #define AER_FATAL			1
@@ -117,6 +118,7 @@ extern void aer_delete_rootport(struct a
 extern int aer_init(struct pcie_device *dev);
 extern void aer_isr(struct work_struct *work);
 extern void aer_print_error(struct pci_dev *dev, struct aer_err_info *info=
);
+extern irqreturn_t aer_irq(int irq, void *context);
=20
 #ifdef CONFIG_ACPI
 extern int aer_osc_setup(struct pcie_device *pciedev);
--- a/drivers/pci/pcie/aer/aerdrv.c
+++ b/drivers/pci/pcie/aer/aerdrv.c
@@ -77,7 +77,7 @@ void pci_no_aer(void)
  *
  * Invoked when Root Port detects AER messages.
  **/
-static irqreturn_t aer_irq(int irq, void *context)
+irqreturn_t aer_irq(int irq, void *context)
 {
 	unsigned int status, id;
 	struct pcie_device *pdev =3D (struct pcie_device *)context;
@@ -126,6 +126,7 @@ static irqreturn_t aer_irq(int irq, void
=20
 	return IRQ_HANDLED;
 }
+EXPORT_SYMBOL_GPL(aer_irq);
=20
 /**
  * aer_alloc_rpc - allocate Root Port data structure


--=-AlK36SHLEE0R79wOcBcY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknxJ8AACgkQKhFGF+eHlpjHGQCgqV2NO0zLltNPFjOvO44Ueu87
JBYAnRd8hSHAMBMvtqTQ/sOpelWW5vJ1
=x96C
-----END PGP SIGNATURE-----

--=-AlK36SHLEE0R79wOcBcY--

