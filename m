Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZBHOVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZBHOVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 09:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZBHOVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 09:21:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44850 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117AbZBHOVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 09:21:00 -0500
Message-ID: <498EEA2F.5050601@suse.de>
Date: Sun, 08 Feb 2009 15:20:31 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, khali@linux-fr.org, ben-linux@fluff.org,
       linux-i2c@vger.kernel.org, frank@f-seidel.de, w.sang@pengutronix.de,
       "David S. Miller" <davem@davemloft.net>,
       ukleinek@informatik.uni-freiburg.de, Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Jean Delvare <khali@linux-fr.org>, Frank Seidel <fseidel@suse.de>
Subject: [PATCHv2 2/2] i2c: adapt debug macros for KERN_* constants
References: <498C3EEA.5060508@suse.de> <498EE9C9.4080002@suse.de>
In-Reply-To: <498EE9C9.4080002@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <frank@f-seidel.de>

According to kerneljanitors todo list all printk calls (beginning
a new line) should have an according KERN_* constant.
Those are the changes to the debug macros in the i2c subsystem
to meet this requirement. Also changing no-debug statements
to raw printks again.

Signed-off-by: Frank Seidel <frank@f-seidel.de>
---
 drivers/i2c/algos/i2c-algo-pca.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/i2c/algos/i2c-algo-pca.c
+++ b/drivers/i2c/algos/i2c-algo-pca.c
@@ -27,9 +27,12 @@
 #include <linux/i2c.h>
 #include <linux/i2c-algo-pca.h>
 
-#define DEB1(fmt, args...) do { if (i2c_debug>=1) printk(fmt, ## args); } while(0)
-#define DEB2(fmt, args...) do { if (i2c_debug>=2) printk(fmt, ## args); } while(0)
-#define DEB3(fmt, args...) do { if (i2c_debug>=3) printk(fmt, ## args); } while(0)
+#define DEB1(fmt, args...) do { if (i2c_debug >= 1)			\
+				 printk(KERN_DEBUG fmt, ## args); } while (0)
+#define DEB2(fmt, args...) do { if (i2c_debug >= 2)			\
+				 printk(KERN_DEBUG fmt, ## args); } while (0)
+#define DEB3(fmt, args...) do { if (i2c_debug >= 3)			\
+				 printk(KERN_DEBUG fmt, ## args); } while (0)
 
 static int i2c_debug;
 
@@ -313,7 +316,7 @@ static int pca_xfer(struct i2c_adapter *
 
 	ret = curmsg;
  out:
-	DEB1(KERN_CRIT "}}} transfered %d/%d messages. "
+	DEB1("}}} transfered %d/%d messages. "
 	     "status is %#04x. control is %#04x\n",
 	     curmsg, num, pca_status(adap),
 	     pca_get_con(adap));
@@ -347,7 +350,8 @@ static int pca_init(struct i2c_adapter *
 	pca_reset(pca_data);
 
 	clock = pca_clock(pca_data);
-	DEB1(KERN_INFO "%s: Clock frequency is %dkHz\n", adap->name, freqs[clock]);
+	printk(KERN_INFO "%s: Clock frequency is %dkHz\n", adap->name,
+	       freqs[clock]);
 
 	pca_set_con(pca_data, I2C_PCA_CON_ENSIO | clock);
 	udelay(500); /* 500 us for oscilator to stabilise */
