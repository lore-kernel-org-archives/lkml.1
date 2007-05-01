Return-Path: <linux-kernel-owner+w=401wt.eu-S1946011AbXEAWBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946011AbXEAWBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 18:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946012AbXEAWBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 18:01:09 -0400
Received: from dns1.vpop.net ([216.193.240.2]:49926 "EHLO mail.vpop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946011AbXEAWBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 18:01:07 -0400
From: Matt Reimer <mreimer@vpop.net>
To: linux-kernel@vger.kernel.org
Cc: Matt Reimer <mreimer@vpop.net>
Subject: [PATCH 2/2] ds1wm: disable interrupts when turning off ds1wm
Date: Tue,  1 May 2007 15:00:56 -0700
Message-Id: <11780568573988-git-send-email-mreimer@vpop.net>
X-Mailer: git-send-email 1.5.1.1
In-Reply-To: <1178056856620-git-send-email-mreimer@vpop.net>
References: <1178056856620-git-send-email-mreimer@vpop.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Disable interrupts when turning off ds1wm.

Signed-off-by: Matt Reimer <mreimer@vpop.net>
---
 drivers/w1/masters/ds1wm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
index 8b08609..1940691 100644
--- a/drivers/w1/masters/ds1wm.c
+++ b/drivers/w1/masters/ds1wm.c
@@ -237,6 +237,10 @@ static void ds1wm_down(struct ds1wm_data *ds1wm_data)
 {
 	ds1wm_reset(ds1wm_data);
 
+	/* Disable interrupts. */
+	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN,
+			     ds1wm_data->active_high ? DS1WM_INTEN_IAS : 0);
+
 	if (ds1wm_data->pdata->disable)
 		ds1wm_data->pdata->disable(ds1wm_data->pdev);
 
-- 
1.5.1.1

