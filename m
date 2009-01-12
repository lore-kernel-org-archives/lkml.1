Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbZALNz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbZALNz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 08:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbZALNxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 08:53:18 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49693 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbZALNxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 08:53:16 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Date: Mon, 12 Jan 2009 14:52:16 +0100
Message-Id: <1231768351-30502-9-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20090112135057.GA10250@pengutronix.de>
References: <20090112135057.GA10250@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH] move megaraid_detach_one to .devexit.text
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function megaraid_detach_one is used only wrapped by __devexit_p so
define it using __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/scsi/megaraid/megaraid_mbox.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 805bb61..feb68b2 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -76,7 +76,7 @@ static int megaraid_init(void);
 static void megaraid_exit(void);
 
 static int megaraid_probe_one(struct pci_dev*, const struct pci_device_id *);
-static void megaraid_detach_one(struct pci_dev *);
+static void __devexit megaraid_detach_one(struct pci_dev *);
 static void megaraid_mbox_shutdown(struct pci_dev *);
 
 static int megaraid_io_attach(adapter_t *);
@@ -551,7 +551,7 @@ out_probe_one:
  *
  * This routine is also called from the PCI hotplug system.
  */
-static void
+static void __devexit
 megaraid_detach_one(struct pci_dev *pdev)
 {
 	adapter_t		*adapter;
-- 
1.5.6.5

