Return-Path: <linux-kernel-owner+w=401wt.eu-S1756751AbZKUSiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756751AbZKUSiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 13:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbZKUSiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 13:38:18 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:57330 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727AbZKUSiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 13:38:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=atNugandi8MxS/l+iLkWx0EVKsjJcXdxHPOTjL2UlxXQhmZbgbr9UBsdfOIxOK7X8B
         okgbJU1d8lpsyHhuGZcIsSsJq46AicELumOXqEgmV53+YI7DE/8wPkAWfXjtAsWE6J2c
         h8yNRaQ1UZxA4+0hB2csDXWc6+cWZGZK1X340=
Message-ID: <4B0836A2.1000805@gmail.com>
Date: Sat, 21 Nov 2009 19:51:14 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: David Vrabel <david.vrabel@csr.com>, linux-usb@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] wusb: Use sizeof struct rather than pointer
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sizeof the struct should be used rather than sizeof the pointer

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/usb/wusbcore/security.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Unless I am mistaken?

diff --git a/drivers/usb/wusbcore/security.c b/drivers/usb/wusbcore/security.c
index 4516c36..857f6e9 100644
--- a/drivers/usb/wusbcore/security.c
+++ b/drivers/usb/wusbcore/security.c
@@ -213,7 +213,7 @@ int wusb_dev_sec_add(struct wusbhc *wusbhc,
 
 	result = usb_get_descriptor(usb_dev, USB_DT_SECURITY,
 				    0, secd, sizeof(struct usb_security_descriptor));
-	if (result < sizeof(secd)) {
+	if (result < sizeof(*secd)) {
 		dev_err(dev, "Can't read security descriptor or "
 			"not enough data: %d\n", result);
 		goto out;
