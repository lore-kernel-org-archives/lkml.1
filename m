Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbZJBBxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbZJBBxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbZJBBxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:53:32 -0400
Received: from kroah.org ([198.145.64.141]:33144 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926AbZJBBdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:14 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:14 2009
Message-Id: <20091002012414.701571758@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Zhenyu Wang <zhenyuw@linux.intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [055/136] drm/i915: remove restore in resume
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-remove-restore-in-resume.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit b7e53aba2f0e6abf23e3f07b38b241145c33a005 upstream.

Don't need extra config restore like for intel_agp, which
might cause resume hang issue found by Alan on 845G.

Cc: Stable Team <stable@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_drv.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -94,8 +94,6 @@ static int i915_resume(struct drm_device
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	int ret = 0;
 
-	pci_set_power_state(dev->pdev, PCI_D0);
-	pci_restore_state(dev->pdev);
 	if (pci_enable_device(dev->pdev))
 		return -1;
 	pci_set_master(dev->pdev);


