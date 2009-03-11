Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZCKJ7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZCKJ7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 05:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753787AbZCKJ5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 05:57:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49349 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535AbZCKJ5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 05:57:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 5/10] PCI PM: Consistently use variable name "error" for pm call return values
Date: Wed, 11 Mar 2009 10:41:27 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, Frans Pop <elendil@planet.nl>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
References: <200902221837.49396.rjw@sisk.pl> <200903111030.39371.rjw@sisk.pl>
In-Reply-To: <200903111030.39371.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903111041.29114.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frans Pop <elendil@planet.nl>

I noticed two functions use a variable "i" to store the return value of PM
function calls while the rest of the file uses "error". As "i" normally
indicates a counter of some sort it seems better to keep this consistent.

Signed-off-by: Frans Pop <elendil@planet.nl>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-driver.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -352,17 +352,17 @@ static int pci_legacy_suspend(struct dev
 {
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
-	int i = 0;
+	int error = 0;
 
 	if (drv && drv->suspend) {
 		pci_power_t prev = pci_dev->current_state;
 
 		pci_dev->state_saved = false;
 
-		i = drv->suspend(pci_dev, state);
-		suspend_report_result(drv->suspend, i);
-		if (i)
-			return i;
+		error = drv->suspend(pci_dev, state);
+		suspend_report_result(drv->suspend, error);
+		if (error)
+			return error;
 
 		if (pci_dev->state_saved)
 			goto Fixup;
@@ -385,20 +385,20 @@ static int pci_legacy_suspend(struct dev
  Fixup:
 	pci_fixup_device(pci_fixup_suspend, pci_dev);
 
-	return i;
+	return error;
 }
 
 static int pci_legacy_suspend_late(struct device *dev, pm_message_t state)
 {
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
-	int i = 0;
+	int error = 0;
 
 	if (drv && drv->suspend_late) {
-		i = drv->suspend_late(pci_dev, state);
-		suspend_report_result(drv->suspend_late, i);
+		error = drv->suspend_late(pci_dev, state);
+		suspend_report_result(drv->suspend_late, error);
 	}
-	return i;
+	return error;
 }
 
 static int pci_legacy_resume_early(struct device *dev)
