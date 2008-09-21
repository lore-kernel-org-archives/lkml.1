Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbYIUTGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbYIUTGx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 15:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751823AbYIUTGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 15:06:42 -0400
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:2118 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbYIUTGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 15:06:41 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Sep 2008 15:06:40 EDT
Date: Sun, 21 Sep 2008 20:51:38 +0200
From: Mark de Wever <koraq@xs4all.nl>
To: Gadi Oxman <gadio@netvision.net.il>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] IDE-TAPE NULL terminate strings.
Message-ID: <20080921185138.GA16310@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After updating my kernel to 2.6.26 the output for the ide-tape drive
during booting is garbled eg
ide-tape: hdd <-> ht0: Seagate <98>ß8A51|1À<81>Üº<98>ß STT20000A rev 8A51|1À<81>Üº<98>ß

This patch fixes the problem by NULL terminating the strings.

Regards,
Mark de Wever

PS: please CC me since I'm not subscribed.
PPS: there are more problems with my tapestreamer in 2.6.26 but I'll
post a separate message for that.

Signed-off-by: Mark de Wever <koraq@xs4all.nl>
---
 drivers/ide/ide-tape.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1bce84b..fd87b43 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2354,6 +2354,10 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 	ide_fixstring(product_id, 18, 0);
 	ide_fixstring(fw_rev, 6, 0);
 
+	fw_rev[4] = '\0';
+	vendor_id[8] = '\0';
+	product_id[16] = '\0';
+
 	printk(KERN_INFO "ide-tape: %s <-> %s: %s %s rev %s\n",
 			drive->name, tape->name, vendor_id, product_id, fw_rev);
 }
-- 
1.5.6.5

