Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbZDNP6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbZDNP6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbZDNP5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:57:48 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58956 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757306AbZDNP5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:57:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Make radeon_reinitialize_M10() absent if its reference is
	#ifdef'd out
To: benh@kernel.crashing.org, linux-fbdev-devel@lists.sourceforge.net
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Date: Tue, 14 Apr 2009 16:56:52 +0100
Message-ID: <20090414155651.27671.36394.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make radeon_reinitialize_M10() absent if its reference is #ifdef'd out (if
CONFIG_PM=n or CONFIG_PPC_PMAC=n.  Otherwise a warning is given:

  CC      drivers/video/aty/radeon_pm.o
drivers/video/aty/radeon_pm.c:1720: warning: 'radeon_reinitialize_M10' defined but not used

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/video/aty/radeon_pm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/drivers/video/aty/radeon_pm.c b/drivers/video/aty/radeon_pm.c
index 97a1f09..8655bbd 100644
--- a/drivers/video/aty/radeon_pm.c
+++ b/drivers/video/aty/radeon_pm.c
@@ -1716,6 +1716,7 @@ static void radeon_pm_m10_reconfigure_mc(struct radeonfb_info *rinfo)
 	OUTREG(MC_IND_INDEX, 0);
 }
 
+#if defined(CONFIG_PM) && defined(CONFIG_PPC_PMAC)
 static void radeon_reinitialize_M10(struct radeonfb_info *rinfo)
 {
 	u32 tmp, i;
@@ -1940,6 +1941,7 @@ static void radeon_reinitialize_M10(struct radeonfb_info *rinfo)
 	 */
 	radeon_pm_m10_enable_lvds_spread_spectrum(rinfo);
 }
+#endif /* CONFIG_PM && CONFIG_PPC_PMAC */
 
 #ifdef CONFIG_PPC_OF
 

