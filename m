Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbYIBVQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbYIBVQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 17:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbYIBVQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 17:16:00 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:45620 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648AbYIBVP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 17:15:59 -0400
X-Greylist: delayed 655 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Sep 2008 17:15:59 EDT
Date: Tue, 2 Sep 2008 23:15:56 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Jean Delvare <khali@linux-fr.org>
Subject: [PATCH] Fix section for probe and remove function for Apple SMU Controller
Message-ID: <20080902211556.GA6872@informatik.uni-freiburg.de>
Mail-Followup-To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@informatik.uni-freiburg.de>,
	linux-kernel@vger.kernel.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Jean Delvare <khali@linux-fr.org>
References: <20080902210501.GA4306@informatik.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080902210501.GA4306@informatik.uni-freiburg.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__devexit for i2c_powermac_probe is obviously wrong.  In the definition
of struct platform_driver i2c_powermac_driver the remove function
i2c_powermac_remove is wrapped in __devexit_p, so it should be defined
using __devexit.

Signed-off-by: Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jean Delvare <khali@linux-fr.org>
---
 drivers/i2c/busses/i2c-powermac.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-powermac.c b/drivers/i2c/busses/i2c-powermac.c
index 22f6d5c..0e7b1c6 100644
--- a/drivers/i2c/busses/i2c-powermac.c
+++ b/drivers/i2c/busses/i2c-powermac.c
@@ -180,7 +180,7 @@ static const struct i2c_algorithm i2c_powermac_algorithm = {
 };
 
 
-static int i2c_powermac_remove(struct platform_device *dev)
+static int __devexit i2c_powermac_remove(struct platform_device *dev)
 {
 	struct i2c_adapter	*adapter = platform_get_drvdata(dev);
 	struct pmac_i2c_bus	*bus = i2c_get_adapdata(adapter);
@@ -200,7 +200,7 @@ static int i2c_powermac_remove(struct platform_device *dev)
 }
 
 
-static int __devexit i2c_powermac_probe(struct platform_device *dev)
+static int __devinit i2c_powermac_probe(struct platform_device *dev)
 {
 	struct pmac_i2c_bus *bus = dev->dev.platform_data;
 	struct device_node *parent = NULL;
-- 
1.5.6.5

-- 
Uwe Kleine-König

http://www.google.com/search?q=5%2B7
