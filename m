Return-Path: <linux-kernel-owner+w=401wt.eu-S1761236AbYBAVNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236AbYBAVNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 16:13:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbYBAVM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 16:12:56 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:27390 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757600AbYBAVMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 16:12:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MoiKWSf19WbNMeqGdecCLwoIMxXbExczZ+TP+XH+xyz4JW9M6Lv2AVMFuGIt3XohFylpWeululv1tCpm2R62qnyN9yBLAQVX7fgjKj6ftDh7//hFqZxDWLGYTJBXQ4Kx5s0Uq2ey+O9gXs4uVA8TH/1zpdkDREtMJHwd5AWU4d4=  ;
X-YMail-OSG: 6mwWQfgVM1lBsPytgj_Yk13WDY8.csinB9183Ver3E8lMYq.JUp4ZcSSs7d41d97ck_i9Mys_Q--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.24-git] spi: remove more dev->power.power_state usage
Date: Fri, 1 Feb 2008 13:03:15 -0800
User-Agent: KMail/1.9.6
Cc: spi-devel-general@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802011303.15859.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some more references to dev->power.power_state.  That field
is overdue for removal, but we can't do that while it's still
referenced in the kernel.  The only reason to update it was to make
the /sys/devices/.../power/state files (now removed) work better.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/spi/pxa2xx_spi.c |   17 -----------------
 drivers/spi/spi_imx.c    |   11 -----------
 2 files changed, 28 deletions(-)

--- at91.orig/drivers/spi/pxa2xx_spi.c	2008-02-01 12:27:39.000000000 -0800
+++ at91/drivers/spi/pxa2xx_spi.c	2008-02-01 12:28:11.000000000 -0800
@@ -1526,17 +1526,6 @@ static void pxa2xx_spi_shutdown(struct p
 }
 
 #ifdef CONFIG_PM
-static int suspend_devices(struct device *dev, void *pm_message)
-{
-	pm_message_t *state = pm_message;
-
-	if (dev->power.power_state.event != state->event) {
-		dev_warn(dev, "pm state does not match request\n");
-		return -1;
-	}
-
-	return 0;
-}
 
 static int pxa2xx_spi_suspend(struct platform_device *pdev, pm_message_t state)
 {
@@ -1544,12 +1533,6 @@ static int pxa2xx_spi_suspend(struct pla
 	struct ssp_device *ssp = drv_data->ssp;
 	int status = 0;
 
-	/* Check all childern for current power state */
-	if (device_for_each_child(&pdev->dev, &state, suspend_devices) != 0) {
-		dev_warn(&pdev->dev, "suspend aborted\n");
-		return -1;
-	}
-
 	status = stop_queue(drv_data);
 	if (status != 0)
 		return status;
--- at91.orig/drivers/spi/spi_imx.c	2008-02-01 12:27:39.000000000 -0800
+++ at91/drivers/spi/spi_imx.c	2008-02-01 12:28:30.000000000 -0800
@@ -1686,17 +1686,6 @@ static void spi_imx_shutdown(struct plat
 }
 
 #ifdef CONFIG_PM
-static int suspend_devices(struct device *dev, void *pm_message)
-{
-	pm_message_t *state = pm_message;
-
-	if (dev->power.power_state.event != state->event) {
-		dev_warn(dev, "pm state does not match request\n");
-		return -1;
-	}
-
-	return 0;
-}
 
 static int spi_imx_suspend(struct platform_device *pdev, pm_message_t state)
 {
