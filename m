Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277AbYJPRNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277AbYJPRNl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754770AbYJPRM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:12:56 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:7124 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752985AbYJPRMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:12:55 -0400
Date: Thu, 16 Oct 2008 21:12:53 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       "Steven A. Falco" <sfalco@harris.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>,
       i2c@lm-sensors.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 2/7] i2c: add info->archdata field
Message-ID: <20081016171253.GB5515@oksana.dev.rtsoft.ru>
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If present the info->archdata is copied into the dev->archdata.
Some (OpenFirmware) platforms need it.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/i2c/i2c-core.c |    3 +++
 include/linux/i2c.h    |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
index 42e852d..5a485c2 100644
--- a/drivers/i2c/i2c-core.c
+++ b/drivers/i2c/i2c-core.c
@@ -266,6 +266,9 @@ i2c_new_device(struct i2c_adapter *adap, struct i2c_board_info const *info)
 
 	client->dev.platform_data = info->platform_data;
 
+	if (info->archdata)
+		client->dev.archdata = *info->archdata;
+
 	client->flags = info->flags;
 	client->addr = info->addr;
 	client->irq = info->irq;
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 0611512..3e358d3 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -240,6 +240,7 @@ static inline void i2c_set_clientdata (struct i2c_client *dev, void *data)
  * @flags: to initialize i2c_client.flags
  * @addr: stored in i2c_client.addr
  * @platform_data: stored in i2c_client.dev.platform_data
+ * @archdata: copied into i2c_client.dev.archdata
  * @irq: stored in i2c_client.irq
  *
  * I2C doesn't actually support hardware probing, although controllers and
@@ -259,6 +260,7 @@ struct i2c_board_info {
 	unsigned short	flags;
 	unsigned short	addr;
 	void		*platform_data;
+	struct dev_archdata	*archdata;
 	int		irq;
 };
 
-- 
1.5.6.3

