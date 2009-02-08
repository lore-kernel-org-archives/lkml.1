Return-Path: <linux-kernel-owner+w=401wt.eu-S1753482AbZBHOKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482AbZBHOKm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 09:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbZBHOKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 09:10:33 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:25591 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbZBHOKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 09:10:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=gmK3BCJPnoyxevZRqS9mxIYZJfE3DwvwLNT/BkIfbVDefV3XRwCo2OZ9NpDLQnoKbz
         P17ojZwQRZeGQ3xhsrFExHBjEOOIkXhWkcSYc96qZV9rHdoiEprJyz9e9qnP9uNos18U
         hgGoJlizfPPQ00RoDEIwEtID0AOIAttZMrNjM=
Message-ID: <498EE7D6.4090100@gmail.com>
Date: Sun, 08 Feb 2009 15:10:30 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: mano@roarinelk.homelinux.net, a.zummo@towertech.it
CC: rtc-linux@googlegroups.com, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] rtc: t reaches -1, tested 0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a postfix decrement t will reach -1 rather than 0,
so the warning nor errot_out occur.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/rtc/rtc-au1xxx.c b/drivers/rtc/rtc-au1xxx.c
index 8906a68..979ed04 100644
--- a/drivers/rtc/rtc-au1xxx.c
+++ b/drivers/rtc/rtc-au1xxx.c
@@ -81,7 +81,7 @@ static int __devinit au1xtoy_rtc_probe(struct platform_device *pdev)
 	if (au_readl(SYS_TOYTRIM) != 32767) {
 		/* wait until hardware gives access to TRIM register */
 		t = 0x00100000;
-		while ((au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_T0S) && t--)
+		while ((au_readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_T0S) && --t)
 			msleep(1);
 
 		if (!t) {


