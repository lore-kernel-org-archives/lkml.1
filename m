Return-Path: <linux-kernel-owner+w=401wt.eu-S1761349AbXHAJQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761349AbXHAJQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbXHAJQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:16:52 -0400
Received: from qb-out-0506.google.com ([72.14.204.236]:15078 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbXHAJQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:16:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent:from:sender;
        b=eQJUi50VlwFpUAG+gKutp3lifm91+6iSDYq4TwcatuxM06wy3OVAlUbw36X1SHhYtSyVZZmiP1MDDbu0vdYVYh3CTLUPtNdmnQRUFWO0y2jqFmdIOYNif2Nei54TOWS42YRjhWpB8b5SWlvhAiCk+p3HzN2MMmX7v8DRdSG9yjg=
Date: Wed, 1 Aug 2007 17:15:34 +0800
To: linux-kernel@vger.kernel.org
Cc: Mattia Dongili <malattia@linux.it>
Subject: [PATCH] drivers/char/sonypi.c: fix ids member of struct acpi_driver
Message-ID: <20070801091534.GA6845@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
From: Eugene Teo <eugeneteo@kernel.sg>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ids member of struct acpi_driver is of type struct acpi_device_id, not a
character array.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 drivers/char/sonypi.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index 73037a4..ac0aeb0 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -1147,10 +1147,16 @@ static int sonypi_acpi_remove(struct acpi_device *device, int type)
 	return 0;
 }
 
+const static struct acpi_device_id sonypi_device_ids[] = {
+	{"SNY6001", 0},
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, sonypi_device_ids);
+
 static struct acpi_driver sonypi_acpi_driver = {
 	.name           = "sonypi",
 	.class          = "hkey",
-	.ids            = "SNY6001",
+	.ids            = sonypi_device_ids,
 	.ops            = {
 		           .add = sonypi_acpi_add,
 			   .remove = sonypi_acpi_remove,

