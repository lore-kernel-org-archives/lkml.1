Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYIMKDt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYIMKDt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 06:03:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbYIMKDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 06:03:41 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:25450 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbYIMKDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 06:03:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=E1SiXPwZJOUDxJjFpp+SdIKh/CDiREYrKx2i03QJIVhSuNKcUue6Q2nDE0GgrBP9Jc
         Ms1FY4qTiOe4UZtfoCuBHIUGEu25segOldaz/OkMWktvPQUqJpeibeGH+vQfS8Bz99Pn
         kDc972gSjDz5Foq4RSE8oZuOjvPhHmAXJ+l2Q=
Date: Sat, 13 Sep 2008 19:03:32 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Subject: [PATCH] mmc_test: initialize mmc_test_lock statically
Message-ID: <20080913100331.GB3746@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mutex mmc_test_lock is initialized at every time mmc_test device
is probed. Probing another mmc_test device may break the mutex, if
the probe function is called while the mutex is locked.

This patch fixes it by statically initializing mmc_test_lock.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
---
 drivers/mmc/card/mmc_test.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: 2.6-git/drivers/mmc/card/mmc_test.c
===================================================================
--- 2.6-git.orig/drivers/mmc/card/mmc_test.c
+++ 2.6-git/drivers/mmc/card/mmc_test.c
@@ -1040,7 +1040,7 @@ static const struct mmc_test_case mmc_te
 
 };
 
-static struct mutex mmc_test_lock;
+static DEFINE_MUTEX(mmc_test_lock);
 
 static void mmc_test_run(struct mmc_test_card *test, int testcase)
 {
@@ -1171,8 +1171,6 @@ static int mmc_test_probe(struct mmc_car
 	if ((card->type != MMC_TYPE_MMC) && (card->type != MMC_TYPE_SD))
 		return -ENODEV;
 
-	mutex_init(&mmc_test_lock);
-
 	ret = device_create_file(&card->dev, &dev_attr_test);
 	if (ret)
 		return ret;
