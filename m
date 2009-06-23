Return-Path: <linux-kernel-owner+w=401wt.eu-S1761250AbZFWPdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761250AbZFWPdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760889AbZFWPcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:32:13 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:59235 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760130AbZFWPcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:32:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer;
        b=a4KrNNMBBN9IEUTHF26k17qfi3oen1NCr12e7HFmwAAIG0sVglcQobEfxxbFbEE1dS
         ELBBIFpfBHlnC5ySrl8H2oRlFjAw2DlZvRrNd6Zpo7T6vXQJGnILTNE6iYXMTki90L4o
         /1igxWBZbxopy4GgpBiULeLlg9SqKsCB965gM=
Subject: [PATCH 2/4] MFD/PCAP: irq_to_pcap()
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iPirM8eY7xelzo/1AXlV"
Date: Tue, 23 Jun 2009 12:32:11 -0300
Message-Id: <1245771131.7750.39.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iPirM8eY7xelzo/1AXlV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Export an irq_to_pcap function to get pcap irq number, for the keypad drive=
r.

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>

---
 drivers/mfd/ezx-pcap.c       |    9 +++++----
 include/linux/mfd/ezx-pcap.h |    1 +
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index c1de4af..de7e637 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -107,10 +107,11 @@ int ezx_pcap_read(struct pcap_chip *pcap, u8 reg_num,=
 u32 *value)
 EXPORT_SYMBOL_GPL(ezx_pcap_read);
=20
 /* IRQ */
-static inline unsigned int irq2pcap(struct pcap_chip *pcap, int irq)
+int irq_to_pcap(struct pcap_chip *pcap, int irq)
 {
-	return 1 << (irq - pcap->irq_base);
+	return irq - pcap->irq_base;
 }
+EXPORT_SYMBOL_GPL(irq_to_pcap);
=20
 int pcap_to_irq(struct pcap_chip *pcap, int irq)
 {
@@ -122,7 +123,7 @@ static void pcap_mask_irq(unsigned int irq)
 {
 	struct pcap_chip *pcap =3D get_irq_chip_data(irq);
=20
-	pcap->msr |=3D irq2pcap(pcap, irq);
+	pcap->msr |=3D 1 << irq_to_pcap(pcap, irq);
 	queue_work(pcap->workqueue, &pcap->msr_work);
 }
=20
@@ -130,7 +131,7 @@ static void pcap_unmask_irq(unsigned int irq)
 {
 	struct pcap_chip *pcap =3D get_irq_chip_data(irq);
=20
-	pcap->msr &=3D ~irq2pcap(pcap, irq);
+	pcap->msr &=3D ~(1 << irq_to_pcap(pcap, irq));
 	queue_work(pcap->workqueue, &pcap->msr_work);
 }
=20
diff --git a/include/linux/mfd/ezx-pcap.h b/include/linux/mfd/ezx-pcap.h
index c12c3c0..6296b49 100644
--- a/include/linux/mfd/ezx-pcap.h
+++ b/include/linux/mfd/ezx-pcap.h
@@ -26,6 +26,7 @@ struct pcap_chip;
 int ezx_pcap_write(struct pcap_chip *, u8, u32);
 int ezx_pcap_read(struct pcap_chip *, u8, u32 *);
 int pcap_to_irq(struct pcap_chip *, int);
+int irq_to_pcap(struct pcap_chip *, int);
 int pcap_adc_async(struct pcap_chip *, u8, u32, u8[], void *, void *);
 int pcap_adc_sync(struct pcap_chip *, u8, u32, u8[], u16[]);
=20
--=20
tg: (2c1c1eb..) pcap/irq_to_pcap (depends on: pcap/fix-adc-locking)

--=20
Daniel Ribeiro

--=-iPirM8eY7xelzo/1AXlV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpA9XsACgkQw3OYl0G0liRwRQCcDD3Yjfr8mXcIXddFbYRVyKsK
VJMAniclVUI8EEnQjyYIwQ1DYJDrheeo
=TCE/
-----END PGP SIGNATURE-----

--=-iPirM8eY7xelzo/1AXlV--

