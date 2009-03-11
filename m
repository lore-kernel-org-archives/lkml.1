Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbZCKXgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbZCKXgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 19:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbZCKXgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 19:36:05 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1633 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZCKXgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 19:36:04 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 11 Mar 2009 23:35:52 +0000
Message-Id: <1236814552-21436-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.3
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: Don't warn if we failed to get a regulator
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The consumer can print a message if required, some consumers may have
optional regulators and wish to downgrade the logging for them or ignore
their absence.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/core.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 08441e2..019a8a4 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1031,8 +1031,6 @@ struct regulator *regulator_get(struct device *dev, const char *id)
 			goto found;
 		}
 	}
-	printk(KERN_ERR "regulator: Unable to get requested regulator: %s\n",
-	       id);
 	mutex_unlock(&regulator_list_mutex);
 	return regulator;
 
-- 
1.5.6.3

