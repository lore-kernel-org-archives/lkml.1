Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbYESNSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbYESNSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759433AbYESNRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:17:04 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57958 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754768AbYESNRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:17:03 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 05/57] atp watchdog
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:05:13 +0100
Message-ID: <20080519130513.31722.56326.stgit@core>
In-Reply-To: <20080519124659.31722.51847.stgit@core>
References: <20080519124659.31722.51847.stgit@core>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Switch to unlocked_ioctl
---

 drivers/watchdog/at32ap700x_wdt.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)


diff --git a/drivers/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
index ae0fca5..c5dc5e9 100644
--- a/drivers/watchdog/at32ap700x_wdt.c
+++ b/drivers/watchdog/at32ap700x_wdt.c
@@ -212,8 +212,8 @@ static struct watchdog_info at32_wdt_info = {
 /*
  * Handle commands from user-space.
  */
-static int at32_wdt_ioctl(struct inode *inode, struct file *file,
-		unsigned int cmd, unsigned long arg)
+static long at32_wdt_ioctl(struct file *file,
+				unsigned int cmd, unsigned long arg)
 {
 	int ret = -ENOTTY;
 	int time;
@@ -298,7 +298,7 @@ static ssize_t at32_wdt_write(struct file *file, const char __user *data,
 static const struct file_operations at32_wdt_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.ioctl		= at32_wdt_ioctl,
+	.unlocked_ioctl	= at32_wdt_ioctl,
 	.open		= at32_wdt_open,
 	.release	= at32_wdt_close,
 	.write		= at32_wdt_write,
@@ -391,7 +391,6 @@ static int __exit at32_wdt_remove(struct platform_device *pdev)
 		wdt = NULL;
 		platform_set_drvdata(pdev, NULL);
 	}
-
 	return 0;
 }
 

