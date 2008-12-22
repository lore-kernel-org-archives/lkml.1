Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbYLVT0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbYLVT0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 14:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756154AbYLVTTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 14:19:08 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:50184 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbYLVTTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 14:19:06 -0500
Subject: [PATCH 27/27] drivers/net/wireless/prism54: fix sparse warnings: make
	symbols static
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Dec 2008 20:19:00 +0100
Message-ID: <20081222191900.11807.83181.stgit@vmbox.hanneseder.net>
In-Reply-To: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
References: <20081222191259.11807.53190.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.292.gb975
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
From: Hannes Eder <hannes@hanneseder.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:

  drivers/net/wireless/prism54/islpci_hotplug.c:97:1: warning: symbol 'prism54_probe' was not declared. Should it be static?
  drivers/net/wireless/prism54/islpci_hotplug.c:220:1: warning: symbol 'prism54_remove' was not declared. Should it be static?
  drivers/net/wireless/prism54/islpci_hotplug.c:263:1: warning: symbol 'prism54_suspend' was not declared. Should it be static?
  drivers/net/wireless/prism54/islpci_hotplug.c:286:1: warning: symbol 'prism54_resume' was not declared. Should it be static?

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/wireless/prism54/islpci_hotplug.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/prism54/islpci_hotplug.c b/drivers/net/wireless/prism54/islpci_hotplug.c
index af2e4f2..9a72b1e 100644
--- a/drivers/net/wireless/prism54/islpci_hotplug.c
+++ b/drivers/net/wireless/prism54/islpci_hotplug.c
@@ -93,7 +93,7 @@ static struct pci_driver prism54_driver = {
     Module initialization functions
 ******************************************************************************/
 
-int
+static int
 prism54_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct net_device *ndev;
@@ -216,7 +216,7 @@ prism54_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 static volatile int __in_cleanup_module = 0;
 
 /* this one removes one(!!) instance only */
-void
+static void
 prism54_remove(struct pci_dev *pdev)
 {
 	struct net_device *ndev = pci_get_drvdata(pdev);
@@ -259,7 +259,7 @@ prism54_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-int
+static int
 prism54_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct net_device *ndev = pci_get_drvdata(pdev);
@@ -282,7 +282,7 @@ prism54_suspend(struct pci_dev *pdev, pm_message_t state)
 	return 0;
 }
 
-int
+static int
 prism54_resume(struct pci_dev *pdev)
 {
 	struct net_device *ndev = pci_get_drvdata(pdev);

