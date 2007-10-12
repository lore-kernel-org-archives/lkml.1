Return-Path: <linux-kernel-owner+w=401wt.eu-S934677AbXJLXNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934677AbXJLXNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 19:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761479AbXJLWyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:54:40 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43514 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761563AbXJLWyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:54:38 -0400
Message-Id: <20071012225434.102879000@sgi.com>
References: <20071012225433.928899000@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 12 Oct 2007 15:54:34 -0700
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 1/1] x86: convert-cpuinfo_x86-array-to-a-per_cpu-array fix
Content-Disposition: inline; filename=x86-convert-cpuinfo_x86-array-to-a-per_cpu-array-fix
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This fix corrects the problem that early_identify_cpu() sets
cpu_index to '0' (needed when called by setup_arch) after
smp_store_cpu_info() had set it to the correct value.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86_64/kernel/smpboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux.orig/arch/x86_64/kernel/smpboot.c	2007-10-12 14:28:45.000000000 -0700
+++ linux/arch/x86_64/kernel/smpboot.c	2007-10-12 14:53:42.753508152 -0700
@@ -141,8 +141,8 @@ static void __cpuinit smp_store_cpu_info
 	struct cpuinfo_x86 *c = &cpu_data(id);
 
 	*c = boot_cpu_data;
-	c->cpu_index = id;
 	identify_cpu(c);
+	c->cpu_index = id;
 	print_cpu_info(c);
 }
 

-- 
