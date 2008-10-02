Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbYJBL5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbYJBL5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 07:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYJBL5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 07:57:16 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:30329 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbYJBL5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 07:57:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=Gvr8fc+2booeZtLjeARABpKdDyq6k3ZL1CGN0RmFD5f3+c/dXzXY0lFnWhXwcDIbjy
         uqXK/wZ/qWuspGe/OapFAGJIJ3biYqhO5pzlbuH/OizZKIWocfxxYAZ+dl6BhmyzrFK4
         LZ4VR1kwxVYRkAQn68k9Zby2EPIQ/GU4C2t/I=
Message-ID: <5ff4a1e50810020457m13bd38d3i72609171ff0dcc4f@mail.gmail.com>
Date: Thu, 2 Oct 2008 12:57:14 +0100
From: "Matt Fleming" <mattjfleming@googlemail.com>
To: linux-kernel@vger.kernel.org, "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Subject: [PATCH 2/2] MMC: CSD and CID timeout values
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_210_2494880.1222948634588"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_210_2494880.1222948634588
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

>From 9a083f0e9a81f5bc31ea49f37112f1945830fc7c Mon Sep 17 00:00:00 2001
From: Matthew Fleming <matthew.fleming@imgtec.com>
Date: Thu, 2 Oct 2008 12:24:05 +0100
Subject: [PATCH 2/2] MMC: CSD and CID timeout values

The MMC spec states that the timeout for accessing the CSD and CID
registers is 64 clock cycles.

Signed-off-by: Matthew Fleming <matthew.fleming@imgtec.com>
---
 drivers/mmc/core/mmc_ops.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 64b05c6..9c50e6f 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -248,8 +248,12 @@ mmc_send_cxd_data(struct mmc_card *card, struct
mmc_host *host,

        sg_init_one(&sg, data_buf, len);

-       if (card)
-               mmc_set_data_timeout(&data, card);
+       /*
+        * The spec states that CSR and CID accesses have a timeout
+        * of 64 clock cycles.
+        */
+       data.timeout_ns = 0;
+       data.timeout_clks = 64;

        mmc_wait_for_req(host, &mrq);

--
1.5.5.2

------=_Part_210_2494880.1222948634588
Content-Type: text/x-diff; name=0002-MMC-CSD-and-CID-timeout-values.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fltc15oz0
Content-Disposition: attachment;
 filename=0002-MMC-CSD-and-CID-timeout-values.patch

RnJvbSA5YTA4M2YwZTlhODFmNWJjMzFlYTQ5ZjM3MTEyZjE5NDU4MzBmYzdjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXR0aGV3IEZsZW1pbmcgPG1hdHRoZXcuZmxlbWluZ0BpbWd0
ZWMuY29tPgpEYXRlOiBUaHUsIDIgT2N0IDIwMDggMTI6MjQ6MDUgKzAxMDAKU3ViamVjdDogW1BB
VENIIDIvMl0gTU1DOiBDU0QgYW5kIENJRCB0aW1lb3V0IHZhbHVlcwoKVGhlIE1NQyBzcGVjIHN0
YXRlcyB0aGF0IHRoZSB0aW1lb3V0IGZvciBhY2Nlc3NpbmcgdGhlIENTRCBhbmQgQ0lECnJlZ2lz
dGVycyBpcyA2NCBjbG9jayBjeWNsZXMuCgpTaWduZWQtb2ZmLWJ5OiBNYXR0aGV3IEZsZW1pbmcg
PG1hdHRoZXcuZmxlbWluZ0BpbWd0ZWMuY29tPgotLS0KIGRyaXZlcnMvbW1jL2NvcmUvbW1jX29w
cy5jIHwgICAgOCArKysrKystLQogMSBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDIg
ZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tbWMvY29yZS9tbWNfb3BzLmMgYi9k
cml2ZXJzL21tYy9jb3JlL21tY19vcHMuYwppbmRleCA2NGIwNWM2Li45YzUwZTZmIDEwMDY0NAot
LS0gYS9kcml2ZXJzL21tYy9jb3JlL21tY19vcHMuYworKysgYi9kcml2ZXJzL21tYy9jb3JlL21t
Y19vcHMuYwpAQCAtMjQ4LDggKzI0OCwxMiBAQCBtbWNfc2VuZF9jeGRfZGF0YShzdHJ1Y3QgbW1j
X2NhcmQgKmNhcmQsIHN0cnVjdCBtbWNfaG9zdCAqaG9zdCwKIAogCXNnX2luaXRfb25lKCZzZywg
ZGF0YV9idWYsIGxlbik7CiAKLQlpZiAoY2FyZCkKLQkJbW1jX3NldF9kYXRhX3RpbWVvdXQoJmRh
dGEsIGNhcmQpOworCS8qCisJICogVGhlIHNwZWMgc3RhdGVzIHRoYXQgQ1NSIGFuZCBDSUQgYWNj
ZXNzZXMgaGF2ZSBhIHRpbWVvdXQKKwkgKiBvZiA2NCBjbG9jayBjeWNsZXMuCisJICovCisJZGF0
YS50aW1lb3V0X25zID0gMDsKKwlkYXRhLnRpbWVvdXRfY2xrcyA9IDY0OwogCiAJbW1jX3dhaXRf
Zm9yX3JlcShob3N0LCAmbXJxKTsKIAotLSAKMS41LjUuMgoK
------=_Part_210_2494880.1222948634588--
