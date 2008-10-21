Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbYJUIg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbYJUIg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 04:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbYJUIgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 04:36:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55196 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbYJUIgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 04:36:18 -0400
Date: Tue, 21 Oct 2008 10:36:15 +0200
From: Andi Kleen <andi@firstfloor.org>
To: venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org
Subject: x86info results ioremap.c:226 __ioremap_caller+0xf2/0x2d6() WARNINGs
Message-ID: <20081021083615.GA4658@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When running x86info on a 2.6.27-git8 system I get

(the M taint is harmless in this case, came from other testing)

resource map sanity check conflict: 0x9e000 0x9efff 0x10000 0x9e7ff System RAM
------------[ cut here ]------------
WARNING: at /home/lsrc/linux/arch/x86/mm/ioremap.c:226 __ioremap_caller+0xf2/0x2d6()
Modules linked in:
Pid: 8805, comm: x86info Tainted: G   M       2.6.27-git8 #110
Call Trace:
 [<ffffffff80236ba1>] warn_on_slowpath+0x58/0x75
 [<ffffffff8021db80>] ? do_flush_tlb_all+0x0/0x37
 [<ffffffff8023b058>] ? on_each_cpu+0x21/0x2c
 [<ffffffff8023bc80>] ? iomem_map_sanity_check+0x61/0x89
 [<ffffffff8022467b>] __ioremap_caller+0xf2/0x2d6
 [<ffffffff803c0648>] ? read_mem+0x5a/0xca
 [<ffffffff802248e4>] xlate_dev_mem_ptr+0x73/0x9e
 [<ffffffff803c0648>] read_mem+0x5a/0xca
 [<ffffffff8028ed19>] vfs_read+0xab/0x134
 [<ffffffff8028f01e>] sys_read+0x47/0x70
 [<ffffffff8020b27b>] system_call_fastpath+0x16/0x1b
---[ end trace 8262d1d3f66bcc38 ]---
resource map sanity check conflict: 0x9e000 0x9efff 0x10000 0x9e7ff System RAM
------------[ cut here ]------------
WARNING: at /home/lsrc/linux/arch/x86/mm/ioremap.c:226 __ioremap_caller+0xf2/0x2d6()
Modules linked in:
Pid: 8805, comm: x86info Tainted: G   M    W  2.6.27-git8 #110
Call Trace:
 [<ffffffff80236ba1>] warn_on_slowpath+0x58/0x75
 [<ffffffff8021db80>] ? do_flush_tlb_all+0x0/0x37
 [<ffffffff8023b058>] ? on_each_cpu+0x21/0x2c
 [<ffffffff8023bc80>] ? iomem_map_sanity_check+0x61/0x89
 [<ffffffff8022467b>] __ioremap_caller+0xf2/0x2d6
 [<ffffffff803c0648>] ? read_mem+0x5a/0xca
 [<ffffffff802248e4>] xlate_dev_mem_ptr+0x73/0x9e
 [<ffffffff803c0648>] read_mem+0x5a/0xca
 [<ffffffff8028ed19>] vfs_read+0xab/0x134
 [<ffffffff8028f01e>] sys_read+0x47/0x70
 [<ffffffff8020b27b>] system_call_fastpath+0x16/0x1b
---[ end trace 8262d1d3f66bcc38 ]---
resource map sanity check conflict: 0x9e000 0x9efff 0x10000 0x9e7ff System RAM
------------[ cut here ]------------
WARNING: at /home/lsrc/linux/arch/x86/mm/ioremap.c:226 __ioremap_caller+0xf2/0x2d6()
Modules linked in:
Pid: 9236, comm: x86info Tainted: G   M    W  2.6.27-git8 #110
Call Trace:
 [<ffffffff80236ba1>] warn_on_slowpath+0x58/0x75
 [<ffffffff8021db80>] ? do_flush_tlb_all+0x0/0x37
 [<ffffffff8023b058>] ? on_each_cpu+0x21/0x2c
 [<ffffffff8023bc80>] ? iomem_map_sanity_check+0x61/0x89
 [<ffffffff8022467b>] __ioremap_caller+0xf2/0x2d6
 [<ffffffff803c0648>] ? read_mem+0x5a/0xca
 [<ffffffff802248e4>] xlate_dev_mem_ptr+0x73/0x9e
 [<ffffffff803c0648>] read_mem+0x5a/0xca
 [<ffffffff8028ed19>] vfs_read+0xab/0x134
 [<ffffffff8028f01e>] sys_read+0x47/0x70
 [<ffffffff8020b27b>] system_call_fastpath+0x16/0x1b
---[ end trace 8262d1d3f66bcc38 ]---
resource map sanity check conflict: 0x9e000 0x9efff 0x10000 0x9e7ff System RAM

... more of them ...

-Andi

-- 
ak@linux.intel.com
