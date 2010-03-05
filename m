Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab0CETKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:10:40 -0500
Received: from relay3.sgi.com ([192.48.152.1]:48615 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755494Ab0CETKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:10:36 -0500
Message-Id: <20100305191035.644779990@gulag1.americas.sgi.com>
References: <20100305191035.058221526@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 05 Mar 2010 13:10:38 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>, Tony Ernst <tee@sgi.com>,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Brian Gerst <brgerst@gmail.com>, x86@kernel.org
Subject: [PATCH 3/3] x86: reduce per cpu warning boot up messages
Content-Disposition: inline; filename=remove-idle-messages
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reduce warning message output to one line only instead of per cpu.

Signed-of-by: Mike Travis <travis@sgi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/process.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/arch/x86/kernel/process.c
+++ linux/arch/x86/kernel/process.c
@@ -607,7 +607,7 @@ void __cpuinit select_idle_routine(const
 {
 #ifdef CONFIG_SMP
 	if (pm_idle == poll_idle && smp_num_siblings > 1) {
-		printk(KERN_WARNING "WARNING: polling idle and HT enabled,"
+		printk_once(KERN_WARNING "WARNING: polling idle and HT enabled,"
 			" performance may degrade.\n");
 	}
 #endif

-- 
