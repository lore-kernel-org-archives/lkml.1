Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbZALN4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbZALN4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 08:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbZALNxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 08:53:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49742 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbZALNxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 08:53:40 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Date: Mon, 12 Jan 2009 14:52:20 +0100
Message-Id: <1231768351-30502-13-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20090112135057.GA10250@pengutronix.de>
References: <20090112135057.GA10250@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH] move pxa_camera_remove to .exit.text
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function pxa_camera_remove is used only wrapped by __exit_p so define
it using __exit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/media/video/pxa_camera.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index a1d6008..3f64138 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1521,7 +1521,7 @@ exit:
 	return err;
 }
 
-static int __devexit pxa_camera_remove(struct platform_device *pdev)
+static int __exit pxa_camera_remove(struct platform_device *pdev)
 {
 	struct pxa_camera_dev *pcdev = platform_get_drvdata(pdev);
 	struct resource *res;
-- 
1.5.6.5

