Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbXLRXqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbXLRXqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 18:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbXLRXqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 18:46:04 -0500
Received: from relay2.sgi.com ([192.48.171.30]:42071 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751672AbXLRXqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 18:46:03 -0500
X-Greylist: delayed 549 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2007 18:46:03 EST
Message-Id: <20071218233514.501149000@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Dec 2007 15:35:14 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] x86: fix show cpuinfo cpu number always zero
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It appears that this patch is missing from the latest 2.6.24 git
kernel as well as the 2.6.24-rc5-mm1 patch?

> Mike, This issue still seems to be present in linus git tree. Perhaps
> the fix in -mm not pushed to mainline yet.
> 
> Can you please raise the flag with Andrew, so that he can push it before
> 2.6.24 gets out
> 

-- 

>From travis@sgi.com Tue Dec 18 15:35:14 2007
Message-Id: <20071218233514.634913000@sgi.com>
References: <20071218233514.501149000@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Dec 2007 15:35:15 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>,
 Christoph Lameter <clameter@sgi.com>,
 Jack Steiner <steiner@sgi.com>,
 Suresh B Siddha <suresh.b.siddha@intel.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Bcc: travis@sgi.com
Subject: [PATCH 1/1] x86: fix show cpuinfo cpu number always zero
Content-Disposition: inline; filename=cpuinfo_x86-fix

This fix corrects the problem that early_identify_cpu() sets
cpu_index to '0' (needed when called by setup_arch) after
smp_store_cpu_info() had set it to the correct value.

The error shows up in 'cat /proc/cpuinfo' will all cpus = 0.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/smpboot_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -141,8 +141,8 @@ static void __cpuinit smp_store_cpu_info
 	struct cpuinfo_x86 *c = &cpu_data(id);
 
 	*c = boot_cpu_data;
-	c->cpu_index = id;
 	identify_cpu(c);
+	c->cpu_index = id;
 	print_cpu_info(c);
 }
 

-- 

