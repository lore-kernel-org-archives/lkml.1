Return-Path: <linux-kernel-owner+w=401wt.eu-S1758460AbZBFDxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758460AbZBFDxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 22:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbZBFDwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 22:52:54 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:59976 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650AbZBFDwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 22:52:53 -0500
MBOX-Line: From nobody Thu Feb  5 20:45:16 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 1/3] ARM: OMAP: Fix omap34xx revision detection for ES3.1
To: linux@arm.linux.org.uk
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
       Paul Walmsley <paul@pwsan.com>
Date: Thu, 05 Feb 2009 20:45:16 -0700
Message-ID: <20090206034513.31313.42445.stgit@localhost.localdomain>
In-Reply-To: <20090206033847.31313.45612.stgit@localhost.localdomain>
References: <20090206033847.31313.45612.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

Fix omap34xx revision detection for ES3.1

linux-omap source commit is 1bafdfd33cc7a2b053ca705cf8623e1ae6cd4c52.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/id.c              |    6 +++++-
 arch/arm/plat-omap/include/mach/cpu.h |    1 +
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index b0f8e7d..b52a02f 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -172,9 +172,13 @@ void __init omap34xx_check_revision(void)
 			omap_revision = OMAP3430_REV_ES3_0;
 			rev_name = "ES3.0";
 			break;
+		case 4:
+			omap_revision = OMAP3430_REV_ES3_1;
+			rev_name = "ES3.1";
+			break;
 		default:
 			/* Use the latest known revision as default */
-			omap_revision = OMAP3430_REV_ES3_0;
+			omap_revision = OMAP3430_REV_ES3_1;
 			rev_name = "Unknown revision\n";
 		}
 	}
diff --git a/arch/arm/plat-omap/include/mach/cpu.h b/arch/arm/plat-omap/include/mach/cpu.h
index b2062f1..a8e1178 100644
--- a/arch/arm/plat-omap/include/mach/cpu.h
+++ b/arch/arm/plat-omap/include/mach/cpu.h
@@ -339,6 +339,7 @@ IS_OMAP_TYPE(3430, 0x3430)
 #define OMAP3430_REV_ES2_0	0x34301034
 #define OMAP3430_REV_ES2_1	0x34302034
 #define OMAP3430_REV_ES3_0	0x34303034
+#define OMAP3430_REV_ES3_1	0x34304034
 
 /*
  * omap_chip bits


