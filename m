Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024Ab0AUQmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab0AUQmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061Ab0AUQl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:41:27 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38406 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab0AUQlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:41:24 -0500
From: Borislav Petkov <bp@amd64.org>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>
Cc: <andreas.herrmann3@amd.com>, <x86@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] intel-agp: Switch to wbinvd_on_all_cpus
Date: Thu, 21 Jan 2010 17:41:30 +0100
Message-Id: <1264092093-13739-5-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264092093-13739-1-git-send-email-bp@amd64.org>
References: <1264092093-13739-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Cc: David Airlie <airlied@linux.ie>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/char/agp/intel-agp.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 3999a5f..bc453da 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -815,12 +815,6 @@ static void intel_i830_setup_flush(void)
 		intel_i830_fini_flush();
 }
 
-static void
-do_wbinvd(void *null)
-{
-	wbinvd();
-}
-
 /* The chipset_flush interface needs to get data that has already been
  * flushed out of the CPU all the way out to main memory, because the GPU
  * doesn't snoop those buffers.
@@ -840,7 +834,7 @@ static void intel_i830_chipset_flush(struct agp_bridge_data *bridge)
 	if (cpu_has_clflush) {
 		clflush_cache_range(pg, 1024);
 	} else {
-		if (on_each_cpu(do_wbinvd, NULL, 1) != 0)
+		if (wbinvd_on_all_cpus() != 0)
 			printk(KERN_ERR "Timed out waiting for cache flush.\n");
 	}
 }
-- 
1.6.6

