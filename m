Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136Ab0AaL5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab0AaL5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 06:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114Ab0AaL51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 06:57:27 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:64335 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab0AaL5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 06:57:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gFQEKBwmAlJIxwXV8JcLR+wk4HWhbDmPoQ/TppJ4d57POl8oqpxUv5FXP/sMLVGhva
         MdVMRAu7+UG9m14LzJQvNmrknE8PsYHIXdzxaN5RMHhmxiUZ4p/ot8SwIxRJeMiHcPo0
         r1Ra1ewH/iyU0Y9B7hhEMrbEzdn2jLm909xIM=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       Chas Williams <chas@cmf.nrl.navy.mil>,
       linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH 6/7] atm: Use for_each_bit
Date: Sun, 31 Jan 2010 20:53:29 +0900
Message-Id: <1264938810-4173-6-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
References: <1264938810-4173-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: linux-atm-general@lists.sourceforge.net
Cc: netdev@vger.kernel.org
---
 drivers/atm/lanai.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index cf97c34..97700f8 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -306,11 +306,10 @@ static void vci_bitfield_iterate(struct lanai_dev *lanai,
 	const unsigned long *lp,
 	void (*func)(struct lanai_dev *,vci_t vci))
 {
-	vci_t vci = find_first_bit(lp, NUM_VCI);
-	while (vci < NUM_VCI) {
+	vci_t vci;
+
+	for_each_bit(vci, lp, NUM_VCI)
 		func(lanai, vci);
-		vci = find_next_bit(lp, NUM_VCI, vci + 1);
-	}
 }
 
 /* -------------------- BUFFER  UTILITIES: */
-- 
1.6.0.6

