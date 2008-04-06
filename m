Return-Path: <linux-kernel-owner+w=401wt.eu-S1754386AbYDFS4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbYDFS4i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 14:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752115AbYDFS4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 14:56:30 -0400
Received: from outbound-mail-115.bluehost.com ([69.89.24.5]:40127 "HELO
	outbound-mail-115.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752067AbYDFS43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 14:56:29 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix IS_I9XX macro in i915 DRM driver
Date: Sun, 6 Apr 2008 11:55:04 -0700
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804061155.04965.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we're mapping registers in the DRM driver at load time, the driver 
actually checks the PCI ID, so we need to make sure the macros have all the 
right bits (and longer term use the DRM headers as the sole copy of the PCI & 
register definitions).

This patch adds 945GME support to the DRM headers, fixing a regression 
reported in http://bugzilla.kernel.org/show_bug.cgi?id=10395.

Dave, please ack asap so this will be fixed in 2.6.25 proper.

Thanks,
Jesse

Tested-by:  Alexander Oltu <alexander@all-2.com>
Signed-off-by:  Jesse Barnes <jesse.barnes@intel.com>

diff --git a/drivers/char/drm/i915_drv.h b/drivers/char/drm/i915_drv.h
index c10d128..675d88b 100644
--- a/drivers/char/drm/i915_drv.h
+++ b/drivers/char/drm/i915_drv.h
@@ -1092,8 +1092,8 @@ extern int i915_wait_ring(struct drm_device * dev, int 
n, const char *caller);
 #define IS_I915G(dev) ((dev)->pci_device == 0x2582 || (dev)->pci_device == 
0x258a)
 #define IS_I915GM(dev) ((dev)->pci_device == 0x2592)
 #define IS_I945G(dev) ((dev)->pci_device == 0x2772)
-#define IS_I945GM(dev) ((dev)->pci_device == 0x27A2)
-
+#define IS_I945GM(dev) ((dev)->pci_device == 0x27A2 ||\
+		        (dev)->pci_device == 0x27AE)
 #define IS_I965G(dev) ((dev)->pci_device == 0x2972 || \
 		       (dev)->pci_device == 0x2982 || \
 		       (dev)->pci_device == 0x2992 || \
