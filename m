Return-Path: <linux-kernel-owner+w=401wt.eu-S1753183AbZGZIWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbZGZIWo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbZGZIVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:21:23 -0400
Received: from www.tglx.de ([62.245.132.106]:33920 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbZGZIVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:21:18 -0400
Message-Id: <20090726081557.394602489@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:19:48 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Tony Luck <tony.luck@intel.com>
Subject: [Patch RFC 31/37] ia64: salinfo: semaphore_init instead of init_MUTEX
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline;
	filename=ia64-salinfo-semaphore-init-instead-of-init-MUTEX.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of this "mutex" is non obvious and used as completion in
some places. Make it a semaphore.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/kernel/salinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/arch/ia64/kernel/salinfo.c
===================================================================
--- linux-2.6-tip.orig/arch/ia64/kernel/salinfo.c
+++ linux-2.6-tip/arch/ia64/kernel/salinfo.c
@@ -643,7 +643,7 @@ salinfo_init(void)
 	for (i = 0; i < ARRAY_SIZE(salinfo_log_name); i++) {
 		data = salinfo_data + i;
 		data->type = i;
-		init_MUTEX(&data->mutex);
+		semaphore_init(&data->mutex);
 		dir = proc_mkdir(salinfo_log_name[i], salinfo_dir);
 		if (!dir)
 			continue;


