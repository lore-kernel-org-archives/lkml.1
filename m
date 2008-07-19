Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbYGSBLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbYGSBLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 21:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753862AbYGSBL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 21:11:28 -0400
Received: from relay2.sgi.com ([192.48.171.30]:60211 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751237AbYGSBL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 21:11:28 -0400
Message-Id: <20080719011127.104352000@polaris-admin.engr.sgi.com>
References: <20080719011126.745278000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Jul 2008 18:11:27 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org,
       "Cc: Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 1/8] NR_CPUS: Replace NR_CPUS in arch/x86/kernel/cpu/mcheck/mce_64.c
Content-Disposition: inline; filename=repl-NR_CPUS-in-arch_x86_kernel_cpu_mcheck_mce_64_c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * nr_cpu_ids should be used to allocate arrays based on the number of
    cpu's present.

Applies to both tip/master and linux-next.

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.tip.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -580,7 +580,7 @@ static ssize_t mce_read(struct file *fil
 	char __user *buf = ubuf;
 	int i, err;
 
-	cpu_tsc = kmalloc(NR_CPUS * sizeof(long), GFP_KERNEL);
+	cpu_tsc = kmalloc(nr_cpu_ids * sizeof(long), GFP_KERNEL);
 	if (!cpu_tsc)
 		return -ENOMEM;
 

-- 
