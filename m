Return-Path: <linux-kernel-owner+w=401wt.eu-S1757170AbYGVF2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170AbYGVF2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbYGVFWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:22:51 -0400
Received: from mail.suse.de ([195.135.220.2]:53788 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756408AbYGVFWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:22:50 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 20/79] device create: misc: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:44 -0700
Message-Id: <1216703983-21448-20-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/phantom.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index 1861624..4ce3bdc 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -399,8 +399,9 @@ static int __devinit phantom_probe(struct pci_dev *pdev,
 		goto err_irq;
 	}
 
-	if (IS_ERR(device_create(phantom_class, &pdev->dev, MKDEV(phantom_major,
-			minor), "phantom%u", minor)))
+	if (IS_ERR(device_create_drvdata(phantom_class, &pdev->dev,
+					 MKDEV(phantom_major, minor),
+					 NULL, "phantom%u", minor)))
 		dev_err(&pdev->dev, "can't create device\n");
 
 	pci_set_drvdata(pdev, pht);
-- 
1.5.6.3

