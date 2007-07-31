Return-Path: <linux-kernel-owner+w=401wt.eu-S1765569AbXGaRjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765569AbXGaRjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752325AbXGaRjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:39:11 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4972 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbXGaRjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:39:09 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 23] doc firmware_sample_firmware_class.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:39:09 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311939.09713.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 Documentation/firmware_class/firmware_sample_firmware_class.c | 5246 -> 5211 (-35 bytes)

 Documentation/firmware_class/firmware_sample_firmware_class.c |   12 +++++-----
 1 file changed, 6 insertions(+), 6 deletions(-)

--- linux-2.6.23-rc1-mm1-a/Documentation/firmware_class/firmware_sample_firmware_class.c	2007-07-26 13:07:45.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/Documentation/firmware_class/firmware_sample_firmware_class.c	2007-07-31 12:17:08.000000000 +0200
@@ -109,15 +109,15 @@ static int fw_setup_class_device(struct
 				 const char *fw_name,
 				 struct device *device)
 {
-	int retval = 0;
-	struct firmware_priv *fw_priv = kmalloc(sizeof(struct firmware_priv),
-						GFP_KERNEL);
-
-	if(!fw_priv){
+	int retval;
+	struct firmware_priv *fw_priv;
+
+	fw_priv = kzalloc(sizeof(struct firmware_priv),	GFP_KERNEL);
+	if (!fw_priv) {
 		retval = -ENOMEM;
 		goto out;
 	}
-	memset(fw_priv, 0, sizeof(*fw_priv));
+
 	memset(class_dev, 0, sizeof(*class_dev));

 	strncpy(fw_priv->fw_id, fw_name, FIRMWARE_NAME_MAX);
