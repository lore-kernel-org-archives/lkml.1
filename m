Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbZCDKlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbZCDKlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 05:41:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZCDKlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 05:41:16 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:58716 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbZCDKlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 05:41:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=GuVvPmbviSQKMHnipLDvuu7bYyGvSzoiW5k83SYORodPUMnrhzncqwlBr0OP99QwwH
         lkGh5GahXvGi5HH/Pflf1WfiAUvw4mnfQB/MaOCE3e+zQnGXkfNilm4PcU0pNvDT4M0R
         ycirgECU5vRwhcNYgRl3fVdOgd3sax6NF9hZs=
MIME-Version: 1.0
Date: Wed, 4 Mar 2009 10:41:12 +0000
Message-ID: <87a5b0800903040241k51f65a65p82a2da8f6de1c832@mail.gmail.com>
Subject: [PATCH] mtd_dataflash: Fix probing of AT45DB321C chips.
From: Will Newton <will.newton@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>,
       David Woodhouse <David.Woodhouse@intel.com>
Content-Type: multipart/mixed; boundary=001636c5a501ba58e4046448b075
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636c5a501ba58e4046448b075
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Commit 771999b65f79264acde4b855e5d35696eca5e80c broke support for probing
AT45DB321C flash chips. These chips do not support the "page size" status
bit, so if we match the JEDEC id return early.

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 drivers/mtd/devices/mtd_dataflash.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/devices/mtd_dataflash.c
b/drivers/mtd/devices/mtd_dataflash.c
index d44f741..cd4781f 100644
--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -822,6 +822,8 @@ static struct flash_info *__devinit
jedec_probe(struct spi_device *spi)
 						return info;
 				}
 			}
+			else
+				return info;
 		}
 	}

-- 
1.5.5.2

--001636c5a501ba58e4046448b075
Content-Type: application/octet-stream; 
	name="0001-mtd_dataflash-Fix-probing-of-AT45DB321C-chips.patch"
Content-Disposition: attachment; 
	filename="0001-mtd_dataflash-Fix-probing-of-AT45DB321C-chips.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_frvvnayj0

RnJvbSAxYjM0NjU5Njc3ZmRhYjBiMDM1OTBkMTg5YWZlMTgyMGQyNTBmMDk1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AZ21haWwuY29tPgpE
YXRlOiBXZWQsIDQgTWFyIDIwMDkgMTA6Mjk6MTkgKzAwMDAKU3ViamVjdDogW1BBVENIXSBtdGRf
ZGF0YWZsYXNoOiBGaXggcHJvYmluZyBvZiBBVDQ1REIzMjFDIGNoaXBzLgoKQ29tbWl0IDc3MTk5
OWI2NWY3OTI2NGFjZGU0Yjg1NWU1ZDM1Njk2ZWNhNWU4MGMgYnJva2Ugc3VwcG9ydCBmb3IgcHJv
YmluZwpBVDQ1REIzMjFDIGZsYXNoIGNoaXBzLiBUaGVzZSBjaGlwcyBkbyBub3Qgc3VwcG9ydCB0
aGUgInBhZ2Ugc2l6ZSIgc3RhdHVzCmJpdCwgc28gaWYgd2UgbWF0Y2ggdGhlIEpFREVDIGlkIHJl
dHVybiBlYXJseS4KClNpZ25lZC1vZmYtYnk6IFdpbGwgTmV3dG9uIDx3aWxsLm5ld3RvbkBnbWFp
bC5jb20+Ci0tLQogZHJpdmVycy9tdGQvZGV2aWNlcy9tdGRfZGF0YWZsYXNoLmMgfCAgICAyICsr
CiAxIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9kcml2ZXJzL210ZC9kZXZpY2VzL210ZF9kYXRhZmxhc2guYyBiL2RyaXZlcnMvbXRk
L2RldmljZXMvbXRkX2RhdGFmbGFzaC5jCmluZGV4IGQ0NGY3NDEuLmNkNDc4MWYgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvbXRkL2RldmljZXMvbXRkX2RhdGFmbGFzaC5jCisrKyBiL2RyaXZlcnMvbXRk
L2RldmljZXMvbXRkX2RhdGFmbGFzaC5jCkBAIC04MjIsNiArODIyLDggQEAgc3RhdGljIHN0cnVj
dCBmbGFzaF9pbmZvICpfX2RldmluaXQgamVkZWNfcHJvYmUoc3RydWN0IHNwaV9kZXZpY2UgKnNw
aSkKIAkJCQkJCXJldHVybiBpbmZvOwogCQkJCX0KIAkJCX0KKwkJCWVsc2UKKwkJCQlyZXR1cm4g
aW5mbzsKIAkJfQogCX0KIAotLSAKMS41LjUuMgoK
--001636c5a501ba58e4046448b075--
