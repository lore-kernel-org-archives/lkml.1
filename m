Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935AbYLJNKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbYLJNKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 08:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYLJNKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 08:10:23 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:56565 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbYLJNKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 08:10:22 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Jeff Garzik <jgarzik@redhat.com>,
       Alexandru Romanescu <a_romanescu@yahoo.co.uk>,
       Tejun Heo <tj@kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] ATA: piix, cleanup dmi strings checking
Date: Wed, 10 Dec 2008 14:07:22 +0100
Message-Id: <1228914442-30805-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.5
In-Reply-To: <1228914442-30805-1-git-send-email-jirislaby@gmail.com>
References: <493EE339.1070806@garzik.org>
 <1228914442-30805-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit
ATA: piix, fix pointer deref on suspend
fixed a possible oops in an ugly manner. Use newly introduced dmi_match()
to make the code pretty again.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Alexandru Romanescu <a_romanescu@yahoo.co.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/ata/ata_piix.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index c11936e..5fdf167 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -1072,20 +1072,13 @@ static int piix_broken_suspend(void)
 	 * matching is necessary because dmi_system_id.matches is
 	 * limited to four entries.
 	 */
-	if (dmi_get_system_info(DMI_SYS_VENDOR) &&
-	    dmi_get_system_info(DMI_PRODUCT_NAME) &&
-	    dmi_get_system_info(DMI_PRODUCT_VERSION) &&
-	    dmi_get_system_info(DMI_PRODUCT_SERIAL) &&
-	    dmi_get_system_info(DMI_BOARD_VENDOR) &&
-	    dmi_get_system_info(DMI_BOARD_NAME) &&
-	    dmi_get_system_info(DMI_BOARD_VERSION) &&
-	    !strcmp(dmi_get_system_info(DMI_SYS_VENDOR), "TOSHIBA") &&
-	    !strcmp(dmi_get_system_info(DMI_PRODUCT_NAME), "000000") &&
-	    !strcmp(dmi_get_system_info(DMI_PRODUCT_VERSION), "000000") &&
-	    !strcmp(dmi_get_system_info(DMI_PRODUCT_SERIAL), "000000") &&
-	    !strcmp(dmi_get_system_info(DMI_BOARD_VENDOR), "TOSHIBA") &&
-	    !strcmp(dmi_get_system_info(DMI_BOARD_NAME), "Portable PC") &&
-	    !strcmp(dmi_get_system_info(DMI_BOARD_VERSION), "Version A0"))
+	if (dmi_match(DMI_SYS_VENDOR, "TOSHIBA") &&
+	    dmi_match(DMI_PRODUCT_NAME, "000000") &&
+	    dmi_match(DMI_PRODUCT_VERSION, "000000") &&
+	    dmi_match(DMI_PRODUCT_SERIAL, "000000") &&
+	    dmi_match(DMI_BOARD_VENDOR, "TOSHIBA") &&
+	    dmi_match(DMI_BOARD_NAME, "Portable PC") &&
+	    dmi_match(DMI_BOARD_VERSION, "Version A0"))
 		return 1;
 
 	return 0;
-- 
1.6.0.5

