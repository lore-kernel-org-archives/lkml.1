Return-Path: <linux-kernel-owner+w=401wt.eu-S1759200AbYFXRi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200AbYFXRi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbYFXRit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:38:49 -0400
Received: from outbound-mail-28.bluehost.com ([69.89.17.198]:39850 "HELO
	outbound-mail-28.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753064AbYFXRir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:38:47 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>
Subject: [PATCH] enable bus mastering on i915 at resume time
Date: Tue, 24 Jun 2008 10:38:31 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806241038.32123.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jie Luo <clotho67@gmail.com>

On 9xx chips, bus mastering needs to be enabled at resume time for much of the 
chip to function.  With this patch, vblank interrupts will work as expected 
on resume, along with other chip functions.   Fixes kernel bugzilla #10844.

Signed-off-by: Jie Luo <clotho67@gmail.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

--- drivers/char/drm/i915_drv.c	2008-06-20 15:35:50.000000000 +0800
+++ drivers/char/drm/i915_drv.c.new	2008-06-20 15:35:35.000000000 +0800
@@ -385,6 +385,7 @@ static int i915_resume(struct drm_device
 	pci_restore_state(dev->pdev);
 	if (pci_enable_device(dev->pdev))
 		return -1;
+	pci_set_master(dev->pdev);
 
 	pci_write_config_byte(dev->pdev, LBB, dev_priv->saveLBB);
 
