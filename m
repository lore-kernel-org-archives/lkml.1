Return-Path: <linux-kernel-owner+w=401wt.eu-S1759773AbZD1HTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759773AbZD1HTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 03:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbZD1HTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 03:19:41 -0400
Received: from smtp.nokia.com ([192.100.105.134]:59580 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbZD1HTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 03:19:40 -0400
Date: Tue, 28 Apr 2009 10:17:51 +0300
From: Mika Kukkonen <mika.kukkonen@nokia.com>
To: lrg@slimlogic.co.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove extra semicolon from if() in
	drivers/regulator/core.c
Message-ID: <20090428071751.GA25645@nokia.com>
Reply-To: mika.kukkonen@nokia.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 28 Apr 2009 07:19:29.0579 (UTC) FILETIME=[AB7A6FB0:01C9C7D1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function drms_uA_update() in file drivers/regulator/core.c there is a tailing semicolon
in the end of if() condition which causes the function in question to return unconditionally.
Remove it to enable rest of the code in the function.

Signed-off-By: Mika Kukkonen <mika.kukkonen@nokia.com>

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 01f7702..47fc6e6 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -540,8 +540,8 @@ static void drms_uA_update(struct regulator_dev *rdev)
 
 	err = regulator_check_drms(rdev);
 	if (err < 0 || !rdev->desc->ops->get_optimum_mode ||
-	    !rdev->desc->ops->get_voltage || !rdev->desc->ops->set_mode);
-	return;
+	    !rdev->desc->ops->get_voltage || !rdev->desc->ops->set_mode)
+		return;
 
 	/* get output voltage */
 	output_uV = rdev->desc->ops->get_voltage(rdev);

