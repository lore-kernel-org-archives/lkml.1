Return-Path: <linux-kernel-owner+w=401wt.eu-S1759227AbZANWHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbZANWHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754100AbZANWHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:07:31 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:34488 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753996AbZANWHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:07:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=P5jo5iD025nuVVd2EvyrZ7th6MxSB/e8f4rUvmDpBLzj3bNtvbvOAoNKxfT3bnLnb7sVNX6NOQrr8dkagK1kaoHDgeiaeu20xhliN75uRr7TJjW+d/n5fbAb/h+B+Zg+imHpWCJpq11cKH55E6w9HVeiHs6zf9cwra8Ma65AtVo=  ;
X-YMail-OSG: M3aSnzIVM1nEWoVDKv7dvZnAQDE6GBOvnYcFOHJRlFZuIXdH_I4PvHe5kIkES.LV1aha7NpHg_HO9pneTnJbb.fCDcQZeejJOWXyv1QqbcjiBvjhqKkwAZZCZqh6XsKTwuHFMall_6j62lSyTqTaR17EUI5WHpHpxFrUpgYYvZc2QlV7zVmoL8sY0htzLcmxSbPV39MH9WUYmAbQdo9ubcnY1F7YgHAuZ91hQQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [patch 2.6.29-rc] regulator: minor cleanup of virtual consumer
Date: Wed, 14 Jan 2009 13:16:27 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901141316.27584.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Minor cleanup to the regulator set_mode sysfs support:
switch to sysfs_streq() in set_mode(), which is also
a code shrink.  Use the same strings that get_mode()
uses, shrinking data too.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/regulator/virtual.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/regulator/virtual.c
+++ b/drivers/regulator/virtual.c
@@ -226,13 +226,13 @@ static ssize_t set_mode(struct device *d
 	unsigned int mode;
 	int ret;
 
-	if (strncmp(buf, "fast", strlen("fast")) == 0)
+	if (sysfs_streq(buf, "fast\n") == 0)
 		mode = REGULATOR_MODE_FAST;
-	else if (strncmp(buf, "normal", strlen("normal")) == 0)
+	else if (sysfs_streq(buf, "normal\n") == 0)
 		mode = REGULATOR_MODE_NORMAL;
-	else if (strncmp(buf, "idle", strlen("idle")) == 0)
+	else if (sysfs_streq(buf, "idle\n") == 0)
 		mode = REGULATOR_MODE_IDLE;
-	else if (strncmp(buf, "standby", strlen("standby")) == 0)
+	else if (sysfs_streq(buf, "standby\n") == 0)
 		mode = REGULATOR_MODE_STANDBY;
 	else {
 		dev_err(dev, "Configuring invalid mode\n");
