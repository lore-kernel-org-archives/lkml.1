Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbZCYAyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbZCYAyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758894AbZCYAme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:42:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40043 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758929AbZCYAmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:42:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [RFC][PATCH 2/2] radeonfb: Use __pci_complete_power_transition()
Date: Wed, 25 Mar 2009 01:42:08 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200903250138.53234.linux-pci-owner@vger.kernel.org>
In-Reply-To: <200903250138.53234.linux-pci-owner@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903250142.09545.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Use __pci_complete_power_transition() to finalize the transition into
D2 after programming the PMCSR of the device directly.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/video/aty/radeon_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/video/aty/radeon_pm.c
===================================================================
--- linux-2.6.orig/drivers/video/aty/radeon_pm.c
+++ linux-2.6/drivers/video/aty/radeon_pm.c
@@ -2582,7 +2582,7 @@ static void radeon_set_suspend(struct ra
 		 * calling pci_set_power_state()
 		 */
 		radeonfb_whack_power_state(rinfo, PCI_D2);
-		pci_set_power_state(rinfo->pdev, PCI_D2);
+		__pci_complete_power_transition(rinfo->pdev, PCI_D2);
 	} else {
 		printk(KERN_DEBUG "radeonfb (%s): switching to D0 state...\n",
 		       pci_name(rinfo->pdev));
