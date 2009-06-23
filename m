Return-Path: <linux-kernel-owner+w=401wt.eu-S1760691AbZFWPcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760691AbZFWPcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760223AbZFWPbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:31:18 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:43663 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760192AbZFWPbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:31:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer;
        b=GPrkJ/PsNl7WT8MgTjAOWRj8UXrtIx50ExHSk+IdZPmkziEH8aV9cLBYxvYHQGZ5pR
         KPji1Qbdm96zw72L+Ae5TqGHFc+tLrn9vNntzPsNZRnXi1wqzS+gbT2Y2w6UG+zsQNw+
         Qrvj428ezlJXwUTKXcKdcCQzNQ6zrMB1dn43o=
Subject: [PATCH 1/4] MFD/PCAP: fix adc locking
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZYOuZ5UShE+SQai3Ud0O"
Date: Tue, 23 Jun 2009 12:30:58 -0300
Message-Id: <1245771058.7750.35.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZYOuZ5UShE+SQai3Ud0O
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Release the lock on error.

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>

---
 drivers/mfd/ezx-pcap.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index 671a7ef..c1de4af 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -238,8 +238,10 @@ static irqreturn_t pcap_adc_irq(int irq, void *_pcap)
 	mutex_lock(&pcap->adc_mutex);
 	req =3D pcap->adc_queue[pcap->adc_head];
=20
-	if (WARN(!req, KERN_WARNING "adc irq without pending request\n"))
+	if (WARN(!req, KERN_WARNING "adc irq without pending request\n")) {
+		mutex_unlock(&pcap->adc_mutex);
 		return IRQ_HANDLED;
+	}
=20
 	/* read requested channels results */
 	ezx_pcap_read(pcap, PCAP_REG_ADC, &tmp);
--=20
tg: (f234012..) pcap/fix-adc-locking (depends on: master)

--=20
Daniel Ribeiro

--=-ZYOuZ5UShE+SQai3Ud0O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpA9SkACgkQw3OYl0G0liSYUgCdFmwGwRs97X0elQwz4tHQwOpM
BA8An1ulcGI/vIocjwK0gliVRgmy86GZ
=HbCD
-----END PGP SIGNATURE-----

--=-ZYOuZ5UShE+SQai3Ud0O--

