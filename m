Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbXDDSgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbXDDSgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbXDDSIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:08:05 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:36588 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbXDDSHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:07:47 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Jonathan McDowell <noodles@earth.li>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 22/90] ARM: OMAP: Fix Amstrad Delta omap-keypad usage
Date: Wed,  4 Apr 2007 14:05:01 -0400
Message-Id: <11757100214151-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757100181189-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan McDowell <noodles@earth.li>

On Fri, Oct 27, 2006 at 05:16:59PM +0100, Jonathan McDowell wrote:
> However having prodded further I'm seeing incorrect key parsing with
> the omap-keypad driver under both -rc2 and -rc3 (works fine in
> 2.6.18-omap1). Numerous keys now returns strings of characters rather
> than the single expected character. A few keys still work as expected
> however. Before I dig in further is anyone else seeing anything similar?

This appears to be due to the addition of keymapsize to the
omap_kp_platform_data structure. The patch below fixes things up for
the Delta; other boards appear to have already had this done.

Signed-off-by: Jonathan McDowell <noodles@earth.li>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap1/board-ams-delta.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
index ad6265f..fa2da74 100644
--- a/arch/arm/mach-omap1/board-ams-delta.c
+++ b/arch/arm/mach-omap1/board-ams-delta.c
@@ -182,10 +182,11 @@ static struct resource ams_delta_kp_resources[] = {
 };
 
 static struct omap_kp_platform_data ams_delta_kp_data = {
-	.rows	= 8,
-	.cols	= 8,
-	.keymap = ams_delta_keymap,
-	.rep	= 1,
+	.rows		= 8,
+	.cols		= 8,
+	.keymap 	= ams_delta_keymap,
+	.keymapsize	= ARRAY_SIZE(ams_delta_keymap),
+	.delay		= 9,
 };
 
 static struct platform_device ams_delta_kp_device = {
-- 
1.4.4.2

