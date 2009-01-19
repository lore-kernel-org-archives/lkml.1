Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbZASNWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbZASNWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbZASNWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:22:07 -0500
Received: from relay.atmel.no ([80.232.32.139]:53812 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbZASNWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:22:06 -0500
X-Greylist: delayed 1441 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Jan 2009 08:22:06 EST
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: linux-kernel@vger.kernel.org
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Subject: [PATCH 1/1] atmel-ssc: fix misuse of dev_dbg when requested ssc instance is not found
Date: Mon, 19 Jan 2009 13:57:56 +0100
Message-Id: <1232369876-19428-1-git-send-email-hans-christian.egtvedt@atmel.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the dev_dbg(...) with a pr_err since the ssc pointer
is not valid when the id is not found in the list.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
---
 drivers/misc/atmel-ssc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/atmel-ssc.c b/drivers/misc/atmel-ssc.c
index 6b35874..6cff1bb 100644
--- a/drivers/misc/atmel-ssc.c
+++ b/drivers/misc/atmel-ssc.c
@@ -35,7 +35,7 @@ struct ssc_device *ssc_request(unsigned int ssc_num)
 
 	if (!ssc_valid) {
 		spin_unlock(&user_lock);
-		dev_dbg(&ssc->pdev->dev, "could not find requested device\n");
+		pr_err("ssc: ssc%d platform device is missing\n", ssc_num);
 		return ERR_PTR(-ENODEV);
 	}
 
-- 
1.5.6.3

