Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbXKECXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbXKECXt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 21:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbXKECXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 21:23:41 -0500
Received: from [222.73.24.84] ([222.73.24.84]:50149 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbXKECXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 21:23:41 -0500
Message-ID: <472E7E44.6000807@cn.fujitsu.com>
Date: Mon, 05 Nov 2007 10:21:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, paulus@samba.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH 3/6]] POWERPC: fix memset size error
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The size passing to memset is wrong.

Signed-off-by Li Zefan <lizf@cn.fujitsu.com>

---
 arch/powerpc/kernel/prom_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index 1db10f7..1add6ef 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -1244,7 +1244,7 @@ static void __init prom_initialize_tce_table(void)
 			local_alloc_bottom = base;
 
 		/* It seems OF doesn't null-terminate the path :-( */
-		memset(path, 0, sizeof(path));
+		memset(path, 0, PROM_SCRATCH_SIZE);
 		/* Call OF to setup the TCE hardware */
 		if (call_prom("package-to-path", 3, 1, node,
 			      path, PROM_SCRATCH_SIZE-1) == PROM_ERROR) {
-- 
1.5.3.rc7

