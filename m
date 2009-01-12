Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbZALNyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbZALNyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 08:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbZALNxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 08:53:02 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49657 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbZALNxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 08:53:00 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Date: Mon, 12 Jan 2009 14:52:13 +0100
Message-Id: <1231768351-30502-6-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20090112135057.GA10250@pengutronix.de>
References: <20090112135057.GA10250@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH] move ilo_remove to .devexit.text
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function ilo_remove is used only wrapped by __devexit_p so define it
using __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/misc/hpilo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/hpilo.c b/drivers/misc/hpilo.c
index 05e2982..c1d8788 100644
--- a/drivers/misc/hpilo.c
+++ b/drivers/misc/hpilo.c
@@ -611,7 +611,7 @@ out:
 	return error;
 }
 
-static void ilo_remove(struct pci_dev *pdev)
+static void __devexit ilo_remove(struct pci_dev *pdev)
 {
 	int i, minor;
 	struct ilo_hwinfo *ilo_hw = pci_get_drvdata(pdev);
-- 
1.5.6.5

