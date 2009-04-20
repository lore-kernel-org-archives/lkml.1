Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbZDTSpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbZDTSpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 14:45:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbZDTSpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 14:45:10 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:48151 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbZDTSpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 14:45:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=oiJFuEb7gRDSsCJN7GUTlR/4nAMIBnB/f+W0eaawHtqh5gatb+hK7s5qowIiBqZcH4
         HPXnwn9XH12HCwnOi4M0fGH3eSavnhx7PCyj/J+seeUQLkxZDsQEbVDbUY4O8hWCdB8R
         lbNAQ7icoTm//iZ7FEPcI5+7HgFX36F0/kCwk=
Date: Tue, 21 Apr 2009 00:14:54 +0530
From: Rabin Vincent <rabin@rab.in>
To: nico@cam.org
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] mvsdio: fix CONFIG_PM=y build
Message-ID: <20090420184454.GA8867@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix usage of obsolete parameters and functions in the driver's PM
callbacks.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 drivers/mmc/host/mvsdio.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index b5c375d..c643d0f 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -825,24 +825,23 @@ static int __exit mvsd_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-static int mvsd_suspend(struct platform_device *dev, pm_message_t state,
-			   u32 level)
+static int mvsd_suspend(struct platform_device *dev, pm_message_t state)
 {
 	struct mmc_host *mmc = platform_get_drvdata(dev);
 	int ret = 0;
 
-	if (mmc && level == SUSPEND_DISABLE)
+	if (mmc)
 		ret = mmc_suspend_host(mmc, state);
 
 	return ret;
 }
 
-static int mvsd_resume(struct platform_device *dev, u32 level)
+static int mvsd_resume(struct platform_device *dev)
 {
-	struct mmc_host *mmc = platform_dev_get_drvdata(dev);
+	struct mmc_host *mmc = platform_get_drvdata(dev);
 	int ret = 0;
 
-	if (mmc && level == RESUME_ENABLE)
+	if (mmc)
 		ret = mmc_resume_host(mmc);
 
 	return ret;
-- 
1.6.2.2

