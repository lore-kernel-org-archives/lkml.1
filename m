Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbZBAVjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbZBAVjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 16:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbZBAVjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 16:39:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57854 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbZBAVjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 16:39:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 3/3] PCI PM: Make warning in pci_legacy_suspend more useful
Date: Sun, 1 Feb 2009 22:34:24 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200902012229.27517.rjw@sisk.pl>
In-Reply-To: <200902012229.27517.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902012234.25165.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The warning in pci_legacy_suspend() would be much more useful if it
printed the name of the function that did the wrong thing.  Make it
do so.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-driver.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -365,7 +365,9 @@ static int pci_legacy_suspend(struct dev
 		if (pci_dev->state_saved)
 			goto Fixup;
 
-		if (WARN_ON_ONCE(pci_dev->current_state != PCI_D0))
+		if (WARN_ONCE(pci_dev->current_state != PCI_D0,
+				"PCI PM: Device state not saved by %pF\n",
+				drv->suspend))
 			goto Fixup;
 	}
 

