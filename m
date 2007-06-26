Return-Path: <linux-kernel-owner+w=401wt.eu-S1758469AbXFZWo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469AbXFZWo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 18:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbXFZWoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 18:44:20 -0400
Received: from verein.lst.de ([213.95.11.210]:39866 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbXFZWoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 18:44:20 -0400
From: Torsten Duwe <duwe@lst.de>
Organization: LST e.V.
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: EDD build error
Date: Wed, 27 Jun 2007 00:44:02 +0200
User-Agent: KMail/1.9.7
Cc: lkml <linux-kernel@vger.kernel.org>
References: <20070626132622.3226261a.randy.dunlap@oracle.com> <200706270016.44999.duwe@lst.de> <20070626153336.e7156b7e.randy.dunlap@oracle.com>
In-Reply-To: <20070626153336.e7156b7e.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_yaZgGlmsGKuk5Yi"
Message-Id: <200706270044.02117.duwe@lst.de>
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_yaZgGlmsGKuk5Yi
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 27 June 2007, Randy Dunlap wrote:
>
> From original email:
> (This is in 2.6.22-rc4-mm2 FWIW.)

Sorry. This one should be better.
I've moved the edd_info, to avoid the -Wunused.

	Torsten

--Boundary-00=_yaZgGlmsGKuk5Yi
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="EDD-diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="EDD-diff"

=2D-- linux-2.6.22-rc4-mm2/drivers/firmware/edd.c.orig	2007-06-27 00:36:45.=
000000000 +0200
+++ linux-2.6.22-rc4-mm2/drivers/firmware/edd.c	2007-06-27 00:38:52.0000000=
00 +0200
@@ -666,13 +666,17 @@ edd_dev_is_type(struct edd_device *edev,
 static struct pci_dev *
 edd_get_pci_dev(struct edd_device *edev)
 {
=2D	struct edd_info *info =3D edd_dev_get_info(edev);
=20
 	if (edd_dev_is_type(edev, "PCI")) {
+#ifdef CONFIG_PCI
+		struct edd_info *info =3D edd_dev_get_info(edev);
 		return pci_get_bus_and_slot(info->params.interface_path.pci.bus,
 				     PCI_DEVFN(info->params.interface_path.pci.slot,
 					       info->params.interface_path.pci.
 					       function));
+#else
+		printk(KERN_WARNING "EDD referenced a PCI device for drive 0x%02x, but P=
CI is not configured\n", edev->index);
+#endif
 	}
 	return NULL;
 }

--Boundary-00=_yaZgGlmsGKuk5Yi--
