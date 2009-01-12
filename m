Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbZALN6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbZALN6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 08:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbZALNyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 08:54:08 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49804 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755162AbZALNyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 08:54:07 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Date: Mon, 12 Jan 2009 14:52:25 +0100
Message-Id: <1231768351-30502-18-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20090112135057.GA10250@pengutronix.de>
References: <20090112135057.GA10250@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH] move stex_remove to .devexit.text
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function stex_remove is used only wrapped by __devexit_p so define
it using __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/scsi/stex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index a3a18ad..4f34cd6 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1260,7 +1260,7 @@ static void stex_hba_free(struct st_hba *hba)
 			  hba->dma_mem, hba->dma_handle);
 }
 
-static void stex_remove(struct pci_dev *pdev)
+static void __devexit stex_remove(struct pci_dev *pdev)
 {
 	struct st_hba *hba = pci_get_drvdata(pdev);
 
-- 
1.5.6.5

