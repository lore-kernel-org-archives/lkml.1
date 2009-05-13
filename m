Return-Path: <linux-kernel-owner+w=401wt.eu-S1758665AbZEMAK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758665AbZEMAK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 20:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757789AbZEMAHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 20:07:49 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:56443 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245AbZEMAHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 20:07:46 -0400
MBOX-Line: From nobody Tue May 12 18:05:27 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 09/10] OMAP3 clock: lessen amount of noisy messages
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Paul Walmsley <paul@pwsan.com>
Date: Tue, 12 May 2009 18:05:27 -0600
Message-ID: <20090513000525.10349.18270.stgit@localhost.localdomain>
In-Reply-To: <20090512235713.10349.49339.stgit@localhost.localdomain>
References: <20090512235713.10349.49339.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

On our system we see the following messages:

Disabling unused clock "gpt2_ick"
Disabling unused clock "gpt3_ick"
Disabling unused clock "gpt4_ick"
Disabling unused clock "gpt5_ick"
...

The messages have KERN_INFO level and if you have serial
console, they normally go there. I do not think it is good
idea to print that much stuff there. Moreover, messages
are not properly prefixed and for mortals it is not
immeadietly clear where they come from.

Let's give them debugging level instead.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
[paul@pwsan.com: trimmed debugging output in patch description]
---
 arch/arm/mach-omap2/clock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/clock.c b/arch/arm/mach-omap2/clock.c
index 8935a8b..076f0a7 100644
--- a/arch/arm/mach-omap2/clock.c
+++ b/arch/arm/mach-omap2/clock.c
@@ -1035,7 +1035,7 @@ void omap2_clk_disable_unused(struct clk *clk)
 	if ((regval32 & (1 << clk->enable_bit)) == v)
 		return;
 
-	printk(KERN_INFO "Disabling unused clock \"%s\"\n", clk->name);
+	printk(KERN_DEBUG "Disabling unused clock \"%s\"\n", clk->name);
 	if (cpu_is_omap34xx()) {
 		omap2_clk_enable(clk);
 		omap2_clk_disable(clk);


