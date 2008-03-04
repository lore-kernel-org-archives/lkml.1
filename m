Return-Path: <linux-kernel-owner+w=401wt.eu-S1765705AbYCDQev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765705AbYCDQev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765459AbYCDQao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:30:44 -0500
Received: from pecan.exetel.com.au ([220.233.0.17]:48609 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765449AbYCDQal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:30:41 -0500
From: oakad@exemail.com.au
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Alex Dubov <oakad@yahoo.com>
Subject: [PATCH 07/11] tifm: clear interrupt mask bits before setting them on adapter init
Date: Wed,  5 Mar 2008 03:02:24 +1100
Message-Id: <1204646548-27466-8-git-send-email-oakad@exemail.com.au>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1204646548-27466-7-git-send-email-oakad@exemail.com.au>
References: <1204646548-27466-1-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-2-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-3-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-4-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-5-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-6-git-send-email-oakad@exemail.com.au>
 <1204646548-27466-7-git-send-email-oakad@exemail.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Dubov <oakad@yahoo.com>

This should improve reliability of detection of cards already in socket
on driver load.

Signed-off-by: Alex Dubov <oakad@yahoo.com>
---
 drivers/misc/tifm_7xx1.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index 63a089b..67503ea 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -368,6 +368,8 @@ static int tifm_7xx1_probe(struct pci_dev *dev,
 		goto err_out_irq;
 
 	writel(TIFM_IRQ_ENABLE | TIFM_IRQ_SOCKMASK((1 << fm->num_sockets) - 1),
+	       fm->addr + FM_CLEAR_INTERRUPT_ENABLE);
+	writel(TIFM_IRQ_ENABLE | TIFM_IRQ_SOCKMASK((1 << fm->num_sockets) - 1),
 	       fm->addr + FM_SET_INTERRUPT_ENABLE);
 	return 0;
 
-- 
1.5.3.6

