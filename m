Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbYGSBMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbYGSBMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 21:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754659AbYGSBLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 21:11:30 -0400
Received: from relay2.sgi.com ([192.48.171.30]:60219 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753006AbYGSBL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 21:11:28 -0400
Message-Id: <20080719011127.251083000@polaris-admin.engr.sgi.com>
References: <20080719011126.745278000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Jul 2008 18:11:28 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Subject: [PATCH 2/8] NR_CPUS: Replace NR_CPUS in arch/x86/kernel/cpu/proc.c
Content-Disposition: inline; filename=repl-NR_CPUS-in-arch_x86_kernel_cpu_proc_c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Use nr_cpu_ids instead of NR_CPUS to limit traversal of cpu online map.

Applies to both tip/master and linux-next.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/cpu/proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.tip.orig/arch/x86/kernel/cpu/proc.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/proc.c
@@ -160,7 +160,7 @@ static void *c_start(struct seq_file *m,
 {
 	if (*pos == 0)	/* just in case, cpu 0 is not the first */
 		*pos = first_cpu(cpu_online_map);
-	if ((*pos) < NR_CPUS && cpu_online(*pos))
+	if ((*pos) < nr_cpu_ids && cpu_online(*pos))
 		return &cpu_data(*pos);
 	return NULL;
 }

-- 
