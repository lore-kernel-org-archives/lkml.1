Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbYDUDDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbYDUDDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 23:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYDUDDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 23:03:35 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:58286 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbYDUDDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 23:03:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KaAnc3iPSDCnPmY8mz/+1pqpPo3KLjwTKY60zbTY8kUqgtizj9P/l3E/U4cpEGsLjhzfjSl5o9WCIQtVzaAoVrS3dsepQ8NpCFpUOl+kNt74UZMQeMN9FjXf+Xk+bx1qnHsyA0hSSf9VMBuhMhbZHOSfTP6eQIGXnfkzgY2em2Q=
From: Dan McGee <dpmcgee@gmail.com>
To: htejun@gmail.com
Cc: linux-kernel@vger.kernel.org, Dan McGee <dpmcgee@gmail.com>
Subject: [PATCH] ata_piix: add Asus Eee 701 controller to short cable list
Date: Sun, 20 Apr 2008 22:03:27 -0500
Message-Id: <1208747007-9791-1-git-send-email-dpmcgee@gmail.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drive is directly soldered to the controller, so there is no cable at
all. Remove the 40-wire assumption so the drive can operate at max speed.

Before patch:
$ dd if=/dev/sda of=/dev/null bs=2M count=64 iflag=direct
134217728 bytes (134 MB) copied, 5.29612 s, 25.3 MB/s

After patch:
$ dd if=/dev/sda of=/dev/null bs=2M count=64 iflag=direct
134217728 bytes (134 MB) copied, 3.94955 s, 34.0 MB/s

Signed-off-by: Dan McGee <dpmcgee@gmail.com>
---
 drivers/ata/ata_piix.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index b7c38ee..ea2c764 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -573,6 +573,7 @@ static const struct ich_laptop ich_laptop[] = {
 	{ 0x27DF, 0x1043, 0x1267 },	/* ICH7 on Asus W5F */
 	{ 0x27DF, 0x103C, 0x30A1 },	/* ICH7 on HP Compaq nc2400 */
 	{ 0x24CA, 0x1025, 0x0061 },	/* ICH4 on ACER Aspire 2023WLMi */
+	{ 0x2653, 0x1043, 0x82D8 },	/* ICH6M on Asus Eee 701 */
 	/* end marker */
 	{ 0, }
 };
-- 
1.5.5.1

