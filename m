Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555Ab0AGTD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab0AGTD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 14:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339Ab0AGTD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 14:03:57 -0500
Received: from mail.gmx.net ([213.165.64.20]:33531 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751702Ab0AGTD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 14:03:56 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+pJ2RaQUKp50yeWDk7sfx3Jq1blvIpwT/OPxHT06
	6IumgxQQ0Et4f9
From: Peter Huewe <PeterHuewe@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [PATCH] staging/asus_oled: Add NULL test for kmalloc
Date: Thu, 7 Jan 2010 20:03:51 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: Andre Haupt <andre@bitwigglers.org>,
       "Kevin A. Granade" <kevin.granade@gmail.com>,
       linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       sjakub@gmail.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201001072003.51722.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>
Date: Thu, 7 Jan 2010 19:57:36 +0100

This patch adds a NULL test to check wether kmalloc was successful or
not.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 Patch against Linux-next of Do 7. Jan 19:59:41 CET 2010

 drivers/staging/asus_oled/asus_oled.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 0c1fb0d..c597fb2 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -430,6 +430,11 @@ static ssize_t odev_set_picture(struct asus_oled_dev *odev,
 
 		kfree(odev->buf);
 		odev->buf = kmalloc(odev->buf_size, GFP_KERNEL);
+		if (odev->buf == NULL) {
+			odev->buf_size = 0;
+			printk(ASUS_OLED_ERROR "Out of memory!\n");
+			return -ENOMEM;
+		}
 
 		memset(odev->buf, 0xff, odev->buf_size);
 
-- 
1.6.4.4

