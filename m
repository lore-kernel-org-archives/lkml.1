Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbZIIVuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbZIIVuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 17:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753039AbZIIVuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 17:50:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35715 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbZIIVui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 17:50:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [Resend][PATCH 2/2] PCI PM: Return error codes from pci_pm_resume()
Date: Wed, 9 Sep 2009 23:51:27 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200909092349.59170.rjw@sisk.pl>
In-Reply-To: <200909092349.59170.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909092351.27178.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Currently pci_pm_resume() always returns 0, which makes the error
variable defined in there a bit pointless.  Make pci_pm_resume()
return error codes obtained from drivers' callbacks.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -689,7 +689,7 @@ static int pci_pm_resume(struct device *
 		pci_pm_reenable_device(pci_dev);
 	}
 
-	return 0;
+	return error;
 }
 
 #else /* !CONFIG_SUSPEND */
