Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbZHQCkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbZHQCkr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 22:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756471AbZHQCkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 22:40:46 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:59092 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433AbZHQCkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 22:40:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type;
        b=S9+R6dKHqI939VbITSIYw7BAKe3GWAnkQKLVAI/VPtOZo9/p33kenfgOaSTX/U48q1
         vneH6azPmkrcbNL0NfabGMAHkBX8QYYdUfRL/Moi1LUkGVOyCQRR6X9Gb5vDj2q8sCRr
         2WncEz5J8O6Fk5CoKdvwDuLPikvip/Za2A+TM=
Message-ID: <4A88C328.5040706@gmail.com>
Date: Mon, 17 Aug 2009 10:40:40 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Add watchdog driver for w90p910
References: <4A69CE00.10401@gmail.com> <20090804201032.GB30892@infomag.iguana.be> <e68bb3470908041955t7e07929bv612a25e0bc0264c1@mail.gmail.com> <20090805070822.GC30892@infomag.iguana.be> <e68bb3470908050100n4f6f8ed3hbd227a13e038e55f@mail.gmail.com> <20090805103127.GF30892@infomag.iguana.be> <4A79873A.5010504@gmail.com>
In-Reply-To: <4A79873A.5010504@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050908060103070603060805"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050908060103070603060805
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Dear Wim,

Thanks for your w90p910-v2.diff, I appreciated it.
I have tested it and only modified the quote of 'expect_close',
and now the patch works very well.:)

At the same time, I renamed this driver name, due to I
have changed the corresponding device name in my arch file.

The attached file is fixed patch relative to this w90p910-v2.diff.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 drivers/watchdog/w90p910_wdt.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/w90p910_wdt.c b/drivers/watchdog/w90p910_wdt.c
index 3cb8972..741db53 100644
--- a/drivers/watchdog/w90p910_wdt.c
+++ b/drivers/watchdog/w90p910_wdt.c
@@ -137,7 +137,7 @@ static int w90p910_wdt_open(struct inode *inode, struct file *file)
 
 static int w90p910_wdt_close(struct inode *inode, struct file *file)
 {
-	if (expect_close == 42)
+	if (w90p910_wdt->expect_close == 42)
 		w90p910_wdt_stop();
 	else {
 		dev_crit(&w90p910_wdt->pdev->dev,
@@ -328,7 +328,7 @@ static struct platform_driver w90p910wdt_driver = {
 	.probe		= w90p910wdt_probe,
 	.remove		= __devexit_p(w90p910wdt_remove),
 	.driver		= {
-		.name	= "w90p910-wdt",
+		.name	= "nuc900-wdt",
 		.owner	= THIS_MODULE,
 	},
 };
@@ -350,4 +350,4 @@ MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
 MODULE_DESCRIPTION("Watchdog driver for W90P910");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-MODULE_ALIAS("platform:w90p910-wdt");
+MODULE_ALIAS("platform:nuc900-wdt");
-- 
1.5.6.3



--------------050908060103070603060805
Content-Type: text/x-patch;
 name="0002-wan-fix-wim-wdt-driver.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0002-wan-fix-wim-wdt-driver.patch"

Fix watchdog driver for w90p910 platform.

Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>

---
 drivers/watchdog/w90p910_wdt.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/w90p910_wdt.c b/drivers/watchdog/w90p910_wdt.c
index 3cb8972..741db53 100644
--- a/drivers/watchdog/w90p910_wdt.c
+++ b/drivers/watchdog/w90p910_wdt.c
@@ -137,7 +137,7 @@ static int w90p910_wdt_open(struct inode *inode, struct file *file)
 
 static int w90p910_wdt_close(struct inode *inode, struct file *file)
 {
-	if (expect_close == 42)
+	if (w90p910_wdt->expect_close == 42)
 		w90p910_wdt_stop();
 	else {
 		dev_crit(&w90p910_wdt->pdev->dev,
@@ -328,7 +328,7 @@ static struct platform_driver w90p910wdt_driver = {
 	.probe		= w90p910wdt_probe,
 	.remove		= __devexit_p(w90p910wdt_remove),
 	.driver		= {
-		.name	= "w90p910-wdt",
+		.name	= "nuc900-wdt",
 		.owner	= THIS_MODULE,
 	},
 };
@@ -350,4 +350,4 @@ MODULE_AUTHOR("Wan ZongShun <mcuos.com@gmail.com>");
 MODULE_DESCRIPTION("Watchdog driver for W90P910");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
-MODULE_ALIAS("platform:w90p910-wdt");
+MODULE_ALIAS("platform:nuc900-wdt");
-- 
1.5.6.3


--------------050908060103070603060805--
