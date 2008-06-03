Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYFCPUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYFCPUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 11:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbYFCPU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 11:20:28 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:27296 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbYFCPU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 11:20:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=jcNThREpYEGrV4bsZlvw97HKA49EPDkhW3ZmX8gZgrufmurc71yKI4SXQ50O+f7RK70eooaH2YIKLF+i74+5RW4vAT4C7GxDR8bl/tsqq6Gdb0kyHYWaUqJ+OB02J8qY4phf/J+IPZ2ZKFGHtWoN5V7e5EhjZ+pBWJd8inVnm+w=
Message-ID: <87a5b0800806030820i16b36366qf199e1c56d729fbe@mail.gmail.com>
Date: Tue, 3 Jun 2008 16:20:25 +0100
From: "Will Newton" <will.newton@gmail.com>
To: linux-usb@vger.kernel.org,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>, leoli@freescale.com
Subject: [PATCH] fsl_usb2_udc: Add a wmb before priming endpoint.
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_1146_15095292.1212506425839"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_1146_15095292.1212506425839
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Add a wmb to fsl_queue_td before priming the endpoint. This ensures that the
modifications to the QH are seen by the hardware.

Signed-off-by: Will Newton <will.newton@gmail.com>
---
 drivers/usb/gadget/fsl_usb2_udc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/fsl_usb2_udc.c
b/drivers/usb/gadget/fsl_usb2_udc.c
index 1868754..dd06a5b 100644
--- a/drivers/usb/gadget/fsl_usb2_udc.c
+++ b/drivers/usb/gadget/fsl_usb2_udc.c
@@ -653,6 +653,8 @@ static int fsl_queue_td(struct fsl_ep *ep, struct
fsl_req *req)
 			| EP_QUEUE_HEAD_STATUS_HALT));
 	dQH->size_ioc_int_sts &= temp;

+	wmb();
+
 	/* Prime endpoint by writing 1 to ENDPTPRIME */
 	temp = ep_is_in(ep)
 		? (1 << (ep_index(ep) + 16))
-- 
1.5.5.2

------=_Part_1146_15095292.1212506425839
Content-Type: text/x-patch;
 name=0001-fsl_usb2_udc-Add-a-wmb-before-priming-endpoint.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fh0mzq290
Content-Disposition: attachment;
 filename=0001-fsl_usb2_udc-Add-a-wmb-before-priming-endpoint.patch

RnJvbSBhMTQxNjRiMDNkZWRmYjJlZDFiZGIxMmEwOTFjNTZiZWU2OGZjZTRlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AZ21haWwuY29tPgpE
YXRlOiBUdWUsIDMgSnVuIDIwMDggMTY6MTU6MDEgKzAxMDAKU3ViamVjdDogW1BBVENIXSBmc2xf
dXNiMl91ZGM6IEFkZCBhIHdtYiBiZWZvcmUgcHJpbWluZyBlbmRwb2ludC4KCkFkZCBhIHdtYiB0
byBmc2xfcXVldWVfdGQgYmVmb3JlIHByaW1pbmcgdGhlIGVuZHBvaW50LiBUaGlzIGVuc3VyZXMg
dGhhdCB0aGUKbW9kaWZpY2F0aW9ucyB0byB0aGUgUUggYXJlIHNlZW4gYnkgdGhlIGhhcmR3YXJl
LgoKU2lnbmVkLW9mZi1ieTogV2lsbCBOZXd0b24gPHdpbGwubmV3dG9uQGdtYWlsLmNvbT4KLS0t
CiBkcml2ZXJzL3VzYi9nYWRnZXQvZnNsX3VzYjJfdWRjLmMgfCAgICAyICsrCiAxIGZpbGVzIGNo
YW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL3VzYi9nYWRnZXQvZnNsX3VzYjJfdWRjLmMgYi9kcml2ZXJzL3VzYi9nYWRnZXQvZnNsX3Vz
YjJfdWRjLmMKaW5kZXggMTg2ODc1NC4uZGQwNmE1YiAxMDA2NDQKLS0tIGEvZHJpdmVycy91c2Iv
Z2FkZ2V0L2ZzbF91c2IyX3VkYy5jCisrKyBiL2RyaXZlcnMvdXNiL2dhZGdldC9mc2xfdXNiMl91
ZGMuYwpAQCAtNjUzLDYgKzY1Myw4IEBAIHN0YXRpYyBpbnQgZnNsX3F1ZXVlX3RkKHN0cnVjdCBm
c2xfZXAgKmVwLCBzdHJ1Y3QgZnNsX3JlcSAqcmVxKQogCQkJfCBFUF9RVUVVRV9IRUFEX1NUQVRV
U19IQUxUKSk7CiAJZFFILT5zaXplX2lvY19pbnRfc3RzICY9IHRlbXA7CiAKKwl3bWIoKTsKKwog
CS8qIFByaW1lIGVuZHBvaW50IGJ5IHdyaXRpbmcgMSB0byBFTkRQVFBSSU1FICovCiAJdGVtcCA9
IGVwX2lzX2luKGVwKQogCQk/ICgxIDw8IChlcF9pbmRleChlcCkgKyAxNikpCi0tIAoxLjUuNS4y
Cgo=
------=_Part_1146_15095292.1212506425839--
