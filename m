Return-Path: <linux-kernel-owner+w=401wt.eu-S1760464AbYHURkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760464AbYHURkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760140AbYHURkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:40:15 -0400
Received: from mail.suse.de ([195.135.220.2]:48101 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760309AbYHURkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:40:14 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>,
       Magnus Damm <magnus.damm@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/15] UIO: uio_pdrv: fix memory leak
Date: Thu, 21 Aug 2008 10:33:00 -0700
Message-Id: <1219339983-9634-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20080821173036.GB7974@suse.de>
References: <20080821173036.GB7974@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>

Thanks to Magnus Damm for pointing that out.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Cc: Magnus Damm <magnus.damm@gmail.com>
Acked-by: Hans J. Koch <hjk@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.5.6.5

