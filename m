Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbZBDBVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbZBDBVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 20:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZBDBTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 20:19:39 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42193 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbZBDBTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 20:19:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 2/7] PCI PM: Check if the state has been saved before trying to restore it
Date: Wed, 4 Feb 2009 01:57:22 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200902040154.36018.rjw@sisk.pl>
In-Reply-To: <200902040154.36018.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902040157.23385.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Check if the standard configuration registers of a PCI device have
been saved during suspend before trying to restore them during
resume.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-By: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 drivers/pci/pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -1421,7 +1421,7 @@ int pci_restore_standard_config(struct p
 	dev->current_state = PCI_D0;
 
  Restore:
-	return pci_restore_state(dev);
+	return dev->state_saved ? pci_restore_state(dev) : 0;
 }
 
 /**

