Return-Path: <linux-kernel-owner+w=401wt.eu-S1753830AbZF0DRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbZF0DRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 23:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZF0DRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 23:17:35 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:38238 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZF0DRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 23:17:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer;
        b=c/dlyJ/v2wJvtFf5KuiJk7aiwrsZcZcsZ1Tcj5+e6SgzHvxCDKDJaUnNKyxBMaWoip
         rSoIdNB57ltkWW8medSbnFTy68Q7jjtczzjA3tdJvZ56BU7x5xd5p6m1uuht3sJGd3LU
         TdxYCukEHth0dn7tiL2IpxT+fTeacTsdEHROk=
Subject: [PATCH] MFD/PCAP: ezx_pcap_setbits()
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@sirena.org.uk>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sRwQctQlfX64pw8ZYKI4"
Date: Sat, 27 Jun 2009 00:17:20 -0300
Message-Id: <1246072640.10360.422.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sRwQctQlfX64pw8ZYKI4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Provides an atomic set_bits functions, as needed by the pcap-regulator
driver.

Signed-off-by: Daniel Ribeiro <drwyrm@gmail.com>

---
 drivers/mfd/ezx-pcap.c       |   23 +++++++++++++++++++++++
 include/linux/mfd/ezx-pcap.h |    1 +
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/ezx-pcap.c b/drivers/mfd/ezx-pcap.c
index 732664f..86d3948 100644
--- a/drivers/mfd/ezx-pcap.c
+++ b/drivers/mfd/ezx-pcap.c
@@ -107,6 +107,29 @@ int ezx_pcap_read(struct pcap_chip *pcap, u8 reg_num, =
u32 *value)
 }
 EXPORT_SYMBOL_GPL(ezx_pcap_read);
=20
+int ezx_pcap_set_bits(struct pcap_chip *pcap, u8 reg_num, u32 mask, u32 va=
l)
+{
+	int ret;
+	u32 tmp =3D PCAP_REGISTER_READ_OP_BIT |
+		(reg_num << PCAP_REGISTER_ADDRESS_SHIFT);
+
+	mutex_lock(&pcap->io_mutex);
+	ret =3D ezx_pcap_putget(pcap, &tmp);
+	if (ret)
+		goto out_unlock;
+
+	tmp &=3D (PCAP_REGISTER_VALUE_MASK & ~mask);
+	tmp |=3D (val & mask) | PCAP_REGISTER_WRITE_OP_BIT |
+		(reg_num << PCAP_REGISTER_ADDRESS_SHIFT);
+
+	ret =3D ezx_pcap_putget(pcap, &tmp);
+out_unlock:
+	mutex_unlock(&pcap->io_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ezx_pcap_set_bits);
+
 /* IRQ */
 int irq_to_pcap(struct pcap_chip *pcap, int irq)
 {
diff --git a/include/linux/mfd/ezx-pcap.h b/include/linux/mfd/ezx-pcap.h
index b15caac..dec82b0 100644
--- a/include/linux/mfd/ezx-pcap.h
+++ b/include/linux/mfd/ezx-pcap.h
@@ -25,6 +25,7 @@ struct pcap_chip;
=20
 int ezx_pcap_write(struct pcap_chip *, u8, u32);
 int ezx_pcap_read(struct pcap_chip *, u8, u32 *);
+int ezx_pcap_set_bits(struct pcap_chip *, u8, u32, u32);
 int pcap_to_irq(struct pcap_chip *, int);
 int irq_to_pcap(struct pcap_chip *, int);
 int pcap_adc_async(struct pcap_chip *, u8, u32, u8[], void *, void *);
--=20
tg: (e94c381..) pcap/set_bits (depends on: pcap/fix-irq-handler)

--=20
Daniel Ribeiro

--=-sRwQctQlfX64pw8ZYKI4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpFj0AACgkQw3OYl0G0liTzdACfS+jjvLc0crx1R4FP/ewt2ilB
0BAAn3AU6cVH2c55p68wBdpA1exTTmMk
=prxh
-----END PGP SIGNATURE-----

--=-sRwQctQlfX64pw8ZYKI4--

