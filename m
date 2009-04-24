Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbZDXCpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbZDXCpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 22:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbZDXCpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 22:45:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:23158 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307AbZDXCpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 22:45:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,238,1239001200"; 
   d="asc'?scan'208";a="135322433"
Subject: [PATCH 1/4] PCI: Add pci_bus_set_ops
From: Huang Ying <ying.huang@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zcef0HUqq7Dk24OA55Vg"
Date: Fri, 24 Apr 2009 10:45:17 +0800
Message-Id: <1240541117.6842.676.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zcef0HUqq7Dk24OA55Vg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

pci_bus_set_ops changes pci_ops associated with a pci_bus. This can be
used by some debug tool such as PCIE AER error injection to fake some
PCI configuration registers.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 drivers/pci/access.c |   19 +++++++++++++++++++
 include/linux/pci.h  |    1 +
 2 files changed, 20 insertions(+)

--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -66,6 +66,25 @@ EXPORT_SYMBOL(pci_bus_write_config_byte)
 EXPORT_SYMBOL(pci_bus_write_config_word);
 EXPORT_SYMBOL(pci_bus_write_config_dword);
=20
+/**
+ * pci_bus_set_ops - Set raw operations of pci bus
+ * @bus:	pci bus struct
+ * @ops:	new raw operations
+ *
+ * Return previous raw operations
+ */
+struct pci_ops *pci_bus_set_ops(struct pci_bus *bus, struct pci_ops *ops)
+{
+	struct pci_ops *old_ops;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pci_lock, flags);
+	old_ops =3D bus->ops;
+	bus->ops =3D ops;
+	spin_unlock_irqrestore(&pci_lock, flags);
+	return old_ops;
+}
+EXPORT_SYMBOL(pci_bus_set_ops);
=20
 /**
  * pci_read_vpd - Read one entry from Vital Product Data
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -639,6 +639,7 @@ int pci_bus_write_config_word(struct pci
 			      int where, u16 val);
 int pci_bus_write_config_dword(struct pci_bus *bus, unsigned int devfn,
 			       int where, u32 val);
+struct pci_ops *pci_bus_set_ops(struct pci_bus *bus, struct pci_ops *ops);
=20
 static inline int pci_read_config_byte(struct pci_dev *dev, int where, u8 =
*val)
 {


--=-zcef0HUqq7Dk24OA55Vg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknxJ60ACgkQKhFGF+eHlphiAQCeNXAkgxlZ0GJQkjTo5JMFtu2l
6yUAn2x6eR+/D19xQsChYPvstMMAs+gT
=4cMF
-----END PGP SIGNATURE-----

--=-zcef0HUqq7Dk24OA55Vg--

