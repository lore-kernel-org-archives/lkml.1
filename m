Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbYGKJKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbYGKJKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 05:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbYGKJKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 05:10:43 -0400
Received: from mail51.messagelabs.com ([216.82.244.179]:61436 "EHLO
	mail51.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbYGKJKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 05:10:42 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-12.tower-51.messagelabs.com!1215767441!5639951!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Greg KH <greg@kroah.com>, "Hans J. Koch" <hjk@linutronix.de>
CC: Magnus Damm <magnus.damm@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] uio_pdrv: fix memory leak
Date: Fri, 11 Jul 2008 11:10:36 +0200
Message-ID: <1215767437-20583-2-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1215767437-20583-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
References: <DOR-SMS-MAIL1KqnjYT00000466@dor-sms-mail1.digi.com>
 <1215767437-20583-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 11 Jul 2008 09:10:37.0549 (UTC) FILETIME=[FBB0A9D0:01C8E335]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to Magnus Damm for pointing that out.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Acked-by: Hans J. Koch <hjk@linutronix.de>
---
 drivers/uio/uio_pdrv.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/uio/uio_pdrv.c b/drivers/uio/uio_pdrv.c
index 5d0d2e8..aa3bff8 100644
--- a/drivers/uio/uio_pdrv.c
+++ b/drivers/uio/uio_pdrv.c
@@ -88,6 +88,8 @@ static int uio_pdrv_remove(struct platform_device *pdev)
 
 	uio_unregister_device(pdata->uioinfo);
 
+	kfree(pdata);
+
 	return 0;
 }
 
-- 
1.5.6.2

