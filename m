Return-Path: <linux-kernel-owner+w=401wt.eu-S1767047AbXDEPTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767047AbXDEPTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 11:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767040AbXDEPTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 11:19:48 -0400
Received: from nlpi043.sbcis.sbc.com ([207.115.36.72]:27563 "EHLO
	nlpi043.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767047AbXDEPTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 11:19:45 -0400
X-ORBL: [67.117.73.34]
Date: Thu, 5 Apr 2007 11:18:39 -0400
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 64/90] ARM: OMAP: Fix warning in pm.c
Message-ID: <20070405151838.GM24297@atomide.com>
References: <11757101164151-git-send-email-tony@atomide.com> <11757101181993-git-send-email-tony@atomide.com> <11757101233966-git-send-email-tony@atomide.com> <11757101252580-git-send-email-tony@atomide.com> <1175710128235-git-send-email-tony@atomide.com> <11757101303810-git-send-email-tony@atomide.com> <11757101333782-git-send-email-tony@atomide.com> <11757101352361-git-send-email-tony@atomide.com> <11757101391215-git-send-email-tony@atomide.com> <1175710142747-git-send-email-tony@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="v2/QI0iRXglpx0hK"
Content-Disposition: inline
In-Reply-To: <1175710142747-git-send-email-tony@atomide.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--v2/QI0iRXglpx0hK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Tony Lindgren <tony@atomide.com> [070404 14:12]:
> From: Dirk Behme <dirk.behme_at_gmail.com>
> 
> ARM: OMAP2: Fix warning in pm.c:
> 
> arch/arm/mach-omap2/pm.c: In function 'omap2_pm_init':
> arch/arm/mach-omap2/pm.c:854: warning: ignoring return value
> of 'subsys_create_file', declared with attribute
> warn_unused_result
> 
> Signed-off-by: Dirk Behme <dirk.behme_at_gmail.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

Fixed email address on this one too.

Tony

--v2/QI0iRXglpx0hK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0064-ARM-OMAP-Fix-warning-in-pm.c.txt"

>From cbb4d20b1d564259e705919aa1431f8f92895c1e Mon Sep 17 00:00:00 2001
From: Dirk Behme <dirk.behme@gmail.com>
Date: Fri, 26 Jan 2007 13:32:30 -0800
Subject: [PATCH 64/90] ARM: OMAP: Fix warning in pm.c

ARM: OMAP2: Fix warning in pm.c:

arch/arm/mach-omap2/pm.c: In function 'omap2_pm_init':
arch/arm/mach-omap2/pm.c:854: warning: ignoring return value
of 'subsys_create_file', declared with attribute
warn_unused_result

Signed-off-by: Dirk Behme <dirk.behme@gmail.com>
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


--v2/QI0iRXglpx0hK--
