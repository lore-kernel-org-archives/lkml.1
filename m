Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab0CGMhM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 07:37:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:49606 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab0CGMhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 07:37:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=m0N2jPFtpzfpJlX6wVgt4QTftqU3FpOOK4YLUUs0A9E3pddmHS+/AqBb2/haBuQef6
         iBDLDoWtpYPN7YaxffP0WtpmzPnLpJ5JbUZf1fYPRmqGxathEeGd88xy8N1ZuO/6Ze37
         f2e9NT8dcfMirDe+9IDhGbSxHmJAshnBnZ3AQ=
Date: Sun, 7 Mar 2010 15:36:45 +0300
From: Dan Carpenter <error27@gmail.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Julia Lawall <julia@diku.dk>, Dmitry Torokhov <dtor@mail.ru>,
       Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] regulator: handle kcalloc() failure
Message-ID: <20100307123645.GB6469@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Liam Girdwood <lrg@slimlogic.co.uk>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Julia Lawall <julia@diku.dk>, Dmitry Torokhov <dtor@mail.ru>,
	Wolfram Sang <w.sang@pengutronix.de>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -ENOMEM if kcalloc() fails

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index f5532ed..55fab4a 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -439,6 +439,10 @@ static int __devinit setup_regulators(struct lp3971 *lp3971,
 	lp3971->num_regulators = pdata->num_regulators;
 	lp3971->rdev = kcalloc(pdata->num_regulators,
 				sizeof(struct regulator_dev *), GFP_KERNEL);
+	if (!lp3971->rdev) {
+		err = -ENOMEM;
+		goto err_nomem;
+	}
 
 	/* Instantiate the regulators */
 	for (i = 0; i < pdata->num_regulators; i++) {
@@ -461,6 +465,7 @@ error:
 		regulator_unregister(lp3971->rdev[i]);
 	kfree(lp3971->rdev);
 	lp3971->rdev = NULL;
+err_nomem:
 	return err;
 }
 
