Return-Path: <linux-kernel-owner+w=401wt.eu-S1752930AbXJWFWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbXJWFWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 01:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbXJWFWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 01:22:08 -0400
Received: from lixom.net ([66.141.50.11]:48934 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbXJWFWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 01:22:07 -0400
Date: Tue, 23 Oct 2007 00:29:12 -0500
From: Olof Johansson <olof@lixom.net>
To: akpm@linux-foundation.org
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] radeonfb: Remove warning with CONFIG_PM=n
Message-ID: <20071023052912.GA21870@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove warning from powerpc ppc64_defconfig builds:

drivers/video/aty/radeon_pm.c:30: warning: 'radeon_reinitialize_M10' declared 'static' but never defined

It's used only under CONFIG_PM, and only with CONFIG_X86 before it is
defined, so the forward declaration can be moved under the ifdef.


Signed-off-by: Olof Johansson <olof@lixom.net>

diff --git a/drivers/video/aty/radeon_pm.c b/drivers/video/aty/radeon_pm.c
index be1d57b..83ee3e7 100644
--- a/drivers/video/aty/radeon_pm.c
+++ b/drivers/video/aty/radeon_pm.c
@@ -27,8 +27,6 @@
 
 #include "ati_ids.h"
 
-static void radeon_reinitialize_M10(struct radeonfb_info *rinfo);
-
 /*
  * Workarounds for bugs in PC laptops:
  * - enable D2 sleep in some IBM Thinkpads
@@ -39,6 +37,8 @@ static void radeon_reinitialize_M10(struct radeonfb_info *rinfo);
  */
 
 #if defined(CONFIG_PM) && defined(CONFIG_X86)
+static void radeon_reinitialize_M10(struct radeonfb_info *rinfo);
+
 struct radeon_device_id {
         const char *ident;                     /* (arbitrary) Name */
         const unsigned short subsystem_vendor; /* Subsystem Vendor ID */
