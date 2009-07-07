Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbZGGKrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbZGGKrn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 06:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbZGGKrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 06:47:32 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:38695 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755360AbZGGKr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 06:47:26 -0400
Subject: [PATCH] Initialise the struct fb_info mutexes in clcdfb_register()
To: Russell King <rmk+kernel@arm.linux.org.uk>
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
Date: Tue, 07 Jul 2009 11:47:23 +0100
Message-ID: <20090707104723.4019.40616.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.387.geb0c.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Jul 2009 10:47:23.0873 (UTC) FILETIME=[4FA72510:01C9FEF0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4148df9b0 moved the fb_info.lock and fb_info.mm_lock mutex
initialisation from register_framebuffer() to framebuffer_alloc().
However, the AMBA CLCD driver wraps the struct fb_info in the clcd_fb
structure, the latter being allocated with kzalloc.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 drivers/video/amba-clcd.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/video/amba-clcd.c b/drivers/video/amba-clcd.c
index fb8163d..d5848aa 100644
--- a/drivers/video/amba-clcd.c
+++ b/drivers/video/amba-clcd.c
@@ -360,6 +360,9 @@ static int clcdfb_register(struct clcd_fb *fb)
 		goto free_clk;
 	}
 
+	mutex_init(&fb->fb.lock);
+	mutex_init(&fb->fb.mm_lock);
+
 	fb->fb.fbops		= &clcdfb_ops;
 	fb->fb.flags		= FBINFO_FLAG_DEFAULT;
 	fb->fb.pseudo_palette	= fb->cmap;

