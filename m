Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab0BKOUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 09:20:31 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53207 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754640Ab0BKOUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:20:30 -0500
Message-ID: <35697.192.168.10.89.1265898023.squirrel@dbdmail.itg.ti.com>
Date: Thu, 11 Feb 2010 19:50:23 +0530 (IST)
Subject: [PATCH] OMAP: Fix for bus width which improves SD card's 
     peformance.
From: "kishore kadiyala" <kishore.kadiyala@ti.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jarkko.lavinen@nokia.com, madhu.cr@ti.com
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20100211195023_58080"
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20100211195023_58080
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

This patch improves low speeds for SD cards.
OMAP-MMC controller's can support maximum bus width of '8'.
when bus width is mentioned as "8" in controller data,the SD
stack will check whether bus width is "4" and if not it will
set bus width to "1" and there by degrading peformance.
This patch fixes the issue and improves the performance of
SD cards.

Signed-off-by: Kishore Kadiyala <kishore.kadiyala@ti.com>
---
 Here are my experiment numbers, on a Class 6 SDHC card:
 Read peformance is increased by 220%
 Write Performance is increased by 52%

 drivers/mmc/host/omap_hsmmc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 83f0aff..8c97c22 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -2092,7 +2092,7 @@ static int __init omap_hsmmc_probe(struct platform_device
*pdev)
 		     MMC_CAP_WAIT_WHILE_BUSY;

 	if (mmc_slot(host).wires >= 8)
-		mmc->caps |= MMC_CAP_8_BIT_DATA;
+		mmc->caps |= (MMC_CAP_8_BIT_DATA | MMC_CAP_4_BIT_DATA);
 	else if (mmc_slot(host).wires >= 4)
 		mmc->caps |= MMC_CAP_4_BIT_DATA;

-- 
1.6.3.3

------=_20100211195023_58080
Content-Type: application/octet-stream;
      name=
     "0001-Fix-for-bus-width-which-optimizes-SD-card-s-peforman.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
      filename=
     "0001-Fix-for-bus-width-which-optimizes-SD-card-s-peforman.patch"

RnJvbSAzNGIwMDg3MjUzMGU2MDY2NzhmODYwNzJkNDZkOGNhODliZWFhMTliIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBLaXNob3JlIEthZGl5YWxhIDxraXNob3JlLmthZGl5YWxhQHRp
LmNvbT4KRGF0ZTogVGh1LCAxMSBGZWIgMjAxMCAxNjo0MjoyMyArMDUzMApTdWJqZWN0OiBbUEFU
Q0hdIEZpeCBmb3IgYnVzIHdpZHRoIHdoaWNoIGltcHJvdmVzIFNEIGNhcmQncyBwZWZvcm1hbmNl
LgoKVGhpcyBwYXRjaCBpbXByb3ZlcyBsb3cgc3BlZWRzIGZvciBTRCBjYXJkcy4KT01BUC1NTUMg
Y29udHJvbGxlcidzIGNhbiBzdXBwb3J0IG1heGltdW0gYnVzIHdpZHRoIG9mICc4Jy4Kd2hlbiBi
dXMgd2lkdGggaXMgbWVudGlvbmVkIGFzICI4IiBpbiBjb250cm9sbGVyIGRhdGEsdGhlIFNECnN0
YWNrIHdpbGwgY2hlY2sgd2hldGhlciBidXMgd2lkdGggaXMgIjQiIGFuZCBpZiBub3QgaXQgd2ls
bApzZXQgYnVzIHdpZHRoIHRvICIxIiBhbmQgdGhlcmUgYnkgZGVncmFkaW5nIHBlZm9ybWFuY2Uu
ClRoaXMgcGF0Y2ggZml4ZXMgdGhlIGlzc3VlIGFuZCBpbXByb3ZlcyB0aGUgcGVyZm9ybWFuY2Ug
b2YKU0QgY2FyZHMuCgpTaWduZWQtb2ZmLWJ5OiBLaXNob3JlIEthZGl5YWxhIDxraXNob3JlLmth
ZGl5YWxhQHRpLmNvbT4KLS0tCiBIZXJlIGFyZSBteSBleHBlcmltZW50IG51bWJlcnMsIG9uIGEg
Q2xhc3MgNiBTREhDIGNhcmQ6CiBSZWFkIHBlZm9ybWFuY2UgaXMgaW5jcmVhc2VkIGJ5IDIyMCUK
IFdyaXRlIFBlcmZvcm1hbmNlIGlzIGluY3JlYXNlZCBieSA1MiUKCQkKIGRyaXZlcnMvbW1jL2hv
c3Qvb21hcF9oc21tYy5jIHwgICAgMiArLQogMSBmaWxlcyBjaGFuZ2VkLCAxIGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tbWMvaG9zdC9vbWFwX2hz
bW1jLmMgYi9kcml2ZXJzL21tYy9ob3N0L29tYXBfaHNtbWMuYwppbmRleCA4M2YwYWZmLi44Yzk3
YzIyIDEwMDY0NAotLS0gYS9kcml2ZXJzL21tYy9ob3N0L29tYXBfaHNtbWMuYworKysgYi9kcml2
ZXJzL21tYy9ob3N0L29tYXBfaHNtbWMuYwpAQCAtMjA5Miw3ICsyMDkyLDcgQEAgc3RhdGljIGlu
dCBfX2luaXQgb21hcF9oc21tY19wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQog
CQkgICAgIE1NQ19DQVBfV0FJVF9XSElMRV9CVVNZOwogCiAJaWYgKG1tY19zbG90KGhvc3QpLndp
cmVzID49IDgpCi0JCW1tYy0+Y2FwcyB8PSBNTUNfQ0FQXzhfQklUX0RBVEE7CisJCW1tYy0+Y2Fw
cyB8PSAoTU1DX0NBUF84X0JJVF9EQVRBIHwgTU1DX0NBUF80X0JJVF9EQVRBKTsKIAllbHNlIGlm
IChtbWNfc2xvdChob3N0KS53aXJlcyA+PSA0KQogCQltbWMtPmNhcHMgfD0gTU1DX0NBUF80X0JJ
VF9EQVRBOwogCi0tIAoxLjYuMy4zCgo=
------=_20100211195023_58080--


