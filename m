Return-Path: <linux-kernel-owner+w=401wt.eu-S1755029AbYBXIVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbYBXIVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 03:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbYBXIVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 03:21:35 -0500
Received: from revol1.enst.fr ([137.194.2.7]:50334 "EHLO smtp2.enst.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbYBXIVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 03:21:34 -0500
X-Greylist: delayed 655 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Feb 2008 03:21:34 EST
From: Samuel Tardieu <sam@rfc1149.net>
Date: Sun, 24 Feb 2008 09:06:01 +0100
Subject: [PATCH] ps3: Fix "unlikely" incorrect usage
Organisation: RFC1149 (see http://www.rfc1149.net/)
To: linux-kernel@vger.kernel.org
Cc: Geoff Levand <geoffrey.levand@am.sony.com>, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org
Message-Id: <20080224081037.D492320AFF@arrakis.enst.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix unlikely(plug) == NO_IRQ into unlikely(plug == NO_IRQ).

Signed-off-by: Samuel Tardieu <sam@rfc1149.net>
---
 arch/powerpc/platforms/ps3/interrupt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/ps3/interrupt.c b/arch/powerpc/platforms/ps3/interrupt.c
index 3a6db04..a14e5cd 100644
--- a/arch/powerpc/platforms/ps3/interrupt.c
+++ b/arch/powerpc/platforms/ps3/interrupt.c
@@ -709,7 +709,7 @@ static unsigned int ps3_get_irq(void)
 	asm volatile("cntlzd %0,%1" : "=r" (plug) : "r" (x));
 	plug &= 0x3f;
 
-	if (unlikely(plug) == NO_IRQ) {
+	if (unlikely(plug == NO_IRQ)) {
 		pr_debug("%s:%d: no plug found: thread_id %lu\n", __func__,
 			__LINE__, pd->thread_id);
 		dump_bmp(&per_cpu(ps3_private, 0));
-- 
1.5.4.2.197.g22c43

