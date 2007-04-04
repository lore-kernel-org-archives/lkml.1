Return-Path: <linux-kernel-owner+w=401wt.eu-S934102AbXDDSNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934102AbXDDSNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932167AbXDDSNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:13:07 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:39035 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934079AbXDDSMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:12:30 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>
Subject: [PATCH 64/90] ARM: OMAP: Fix warning in pm.c
Date: Wed,  4 Apr 2007 14:05:43 -0400
Message-Id: <1175710142747-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757101391215-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Behme <dirk.behme_at_gmail.com>

ARM: OMAP2: Fix warning in pm.c:

arch/arm/mach-omap2/pm.c: In function 'omap2_pm_init':
arch/arm/mach-omap2/pm.c:854: warning: ignoring return value
of 'subsys_create_file', declared with attribute
warn_unused_result

Signed-off-by: Dirk Behme <dirk.behme_at_gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/pm.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
index 1034eb9..27d7f85 100644
--- a/arch/arm/mach-omap2/pm.c
+++ b/arch/arm/mach-omap2/pm.c
@@ -851,7 +851,9 @@ int __init omap2_pm_init(void)
 	pm_set_ops(&omap_pm_ops);
 	pm_idle = omap2_pm_idle;
 
-	subsys_create_file(&power_subsys, &sleep_while_idle_attr);
+	l = subsys_create_file(&power_subsys, &sleep_while_idle_attr);
+	if (l)
+		printk(KERN_ERR "subsys_create_file failed: %d\n", l);
 
 	return 0;
 }
-- 
1.4.4.2

