Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbZC2IzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbZC2IzK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 04:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbZC2Iy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 04:54:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40093 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZC2Iy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 04:54:56 -0400
References: <git-1238272225-b23c7a427e4b3764ad686a46de89ab652811c50a@dyn-67.arm.linux.org.uk>
Message-ID: <git-1238272225-803c78e4da28d7d7cb0642caf643b9289ae7838a@dyn-67.arm.linux.org.uk>
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: stable@kernel.org,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>
Date: Sat, 28 Mar 2009 20:30:26 +0000
Content-type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Subject: Re: [PATCH] [ARM] twl4030 - leak fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Trivial error path leak fix. Problem found by Daniel Marjamäki using
cppcheck

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/mach-omap2/mmc-twl4030.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/mmc-twl4030.c b/arch/arm/mach-omap2/mmc-twl4030.c
index 437f520..e1dadf7 100644
--- a/arch/arm/mach-omap2/mmc-twl4030.c
+++ b/arch/arm/mach-omap2/mmc-twl4030.c
@@ -397,6 +397,7 @@ void __init twl4030_mmc_init(struct twl4030_hsmmc_info *controllers)
 			break;
 		default:
 			pr_err("MMC%d configuration not supported!\n", c->mmc);
+			kfree(mmc);
 			continue;
 		}
 		hsmmc_data[c->mmc - 1] = mmc;
