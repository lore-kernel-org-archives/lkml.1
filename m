Return-Path: <linux-kernel-owner+w=401wt.eu-S1757000AbZCWKn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000AbZCWKn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 06:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbZCWKm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 06:42:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34826 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756974AbZCWKm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 06:42:57 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] arm: twl4030 - leak fix
To: linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk
Date: Mon, 23 Mar 2009 10:43:54 +0000
Message-ID: <20090323104347.32524.76448.stgit@localhost.localdomain>
In-Reply-To: <20090323103834.32524.65397.stgit@localhost.localdomain>
References: <20090323103834.32524.65397.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial error path leak fix. Problem found by Daniel Marjamäki using
cppcheck

Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
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

