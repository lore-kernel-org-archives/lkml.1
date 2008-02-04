Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbYBDWWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbYBDWWj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 17:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbYBDWWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 17:22:31 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:57978 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbYBDWWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 17:22:30 -0500
Message-ID: <47A79022.4010302@tiscali.nl>
Date: Mon, 04 Feb 2008 23:22:26 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: garloff@suse.de, g.liakhovetski@gmx.de,
       lkml <linux-kernel@vger.kernel.org>
Subject: [drivers/scsi/NCR53C9x.c] remove duplication for family_code == 0x00
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in drivers/scsi/NCR53C9x.c:412-422 it reads:

                else if(family_code == 0x00) {
                        if ((version & 7) == 2)
                                esp->erev = fas100a; /* NCR53C9X */
                        else
                                esp->erev = espunknown;
                } else if(family_code == 0x14) {
                        if ((version & 7) == 2)
                                esp->erev = fsc;
                        else
                                esp->erev = espunknown;
                } else if(family_code == 0x00) {
                        if ((version & 7) == 2)
                                esp->erev = fas100a; /* NCR53C9X */
                        else
                                esp->erev = espunknown;

Note the duplication of test 'if(family_code == 0x00)' and lines below

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/scsi/NCR53C9x.c b/drivers/scsi/NCR53C9x.c
index 5b0efc9..b8df3c0 100644
--- a/drivers/scsi/NCR53C9x.c
+++ b/drivers/scsi/NCR53C9x.c
@@ -419,11 +419,6 @@ static void esp_reset_esp(struct NCR_ESP *esp, struct ESP_regs *eregs)
 				esp->erev = fsc;
 		        else
 				esp->erev = espunknown;
-		} else if(family_code == 0x00) {
-			if ((version & 7) == 2)
-				esp->erev = fas100a; /* NCR53C9X */
-			else
-				esp->erev = espunknown;
 		} else
 			esp->erev = espunknown;
 		ESPLOG(("esp%d: FAST chip is %s (family=%d, version=%d)\n",
