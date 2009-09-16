Return-Path: <linux-kernel-owner+w=401wt.eu-S1760578AbZIPWpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578AbZIPWpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760576AbZIPWp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:45:27 -0400
Received: from kroah.org ([198.145.64.141]:48968 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760367AbZIPWj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:39:58 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:16 2009
Message-Id: <20090916223716.291883593@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Dave Airlie <airlied@linux.ie>
Subject: [patch 21/45] agp/intel: remove restore in resume
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=agp-intel-remove-restore-in-resume.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit 121264827656f5f06328b17983c796af17dc5949 upstream.

As early pci resume has already restored config for host
bridge and graphics device, don't need to restore it again,
This removes an original order hack for graphics device restore.

This fixed the resume hang issue found by Alan Stern on 845G,
caused by extra config restore on graphics device.

Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Dave Airlie <airlied@linux.ie>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/intel-agp.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -2313,15 +2313,6 @@ static int agp_intel_resume(struct pci_d
 	struct agp_bridge_data *bridge = pci_get_drvdata(pdev);
 	int ret_val;
 
-	pci_restore_state(pdev);
-
-	/* We should restore our graphics device's config space,
-	 * as host bridge (00:00) resumes before graphics device (02:00),
-	 * then our access to its pci space can work right.
-	 */
-	if (intel_private.pcidev)
-		pci_restore_state(intel_private.pcidev);
-
 	if (bridge->driver == &intel_generic_driver)
 		intel_configure();
 	else if (bridge->driver == &intel_850_driver)


