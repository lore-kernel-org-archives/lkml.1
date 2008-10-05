Return-Path: <linux-kernel-owner+w=401wt.eu-S1757240AbYJEQ3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240AbYJEQ3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758997AbYJEQWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:22:46 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:62771 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758194AbYJEQWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:22:41 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: [PATCH v2 7/7] atmel-mci: Add missing flush_dcache_page() in PIO transfer code
Date: Sun,  5 Oct 2008 18:21:30 +0200
Message-Id: <1223223690-2637-8-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1223223690-2637-7-git-send-email-haavard.skinnemoen@atmel.com>
References: <1223223690-2637-1-git-send-email-haavard.skinnemoen@atmel.com>
 <1223223690-2637-2-git-send-email-haavard.skinnemoen@atmel.com>
 <1223223690-2637-3-git-send-email-haavard.skinnemoen@atmel.com>
 <1223223690-2637-4-git-send-email-haavard.skinnemoen@atmel.com>
 <1223223690-2637-5-git-send-email-haavard.skinnemoen@atmel.com>
 <1223223690-2637-6-git-send-email-haavard.skinnemoen@atmel.com>
 <1223223690-2637-7-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 05 Oct 2008 16:21:15.0259 (UTC) FILETIME=[63B0D4B0:01C92706]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
---
 drivers/mmc/host/atmel-mci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 02529af..7a3f243 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1253,6 +1253,7 @@ static void atmci_read_data_pio(struct atmel_mci *host)
 			nbytes += 4;
 
 			if (offset == sg->length) {
+				flush_dcache_page(sg_page(sg));
 				host->sg = sg = sg_next(sg);
 				if (!sg)
 					goto done;
-- 
1.5.6.5

