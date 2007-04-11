Return-Path: <linux-kernel-owner+w=401wt.eu-S1751473AbXDKIxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbXDKIxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 04:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbXDKIx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 04:53:26 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:1563 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbXDKIxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 04:53:22 -0400
Date: Wed, 11 Apr 2007 12:29:11 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>, Jay Estabrook <jay.estabrook@hp.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] DRM: correct PCI domain setting for ALPHA
Message-ID: <20070411122911.D17547@jurassic.park.msu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Files:

drivers/char/drm/drmP.h

	The PCI domain is the hose's index, not the hose's root bus number.
	Note that this code only applies to ALPHA.


Signed-off-by: Jay Estabrook <jay.estabrook@hp.com>
Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

---

diff -Naurp a/drivers/char/drm/drmP.h b/drivers/char/drm/drmP.h
--- a/drivers/char/drm/drmP.h	2007-04-02 13:03:24.000000000 -0400
+++ b/drivers/char/drm/drmP.h	2007-04-02 13:49:38.000000000 -0400
@@ -764,7 +764,7 @@ static __inline__ int drm_core_check_fea
 }
 
 #ifdef __alpha__
-#define drm_get_pci_domain(dev) dev->hose->bus->number
+#define drm_get_pci_domain(dev) dev->hose->index
 #else
 #define drm_get_pci_domain(dev) 0
 #endif
