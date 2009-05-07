Return-Path: <linux-kernel-owner+w=401wt.eu-S1757215AbZEGS6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215AbZEGS6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbZEGS5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:57:32 -0400
Received: from gw.goop.org ([64.81.55.164]:40216 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761797AbZEGS5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:57:31 -0400
Message-ID: <4A032EEC.30509@goop.org>
Date: Thu, 07 May 2009 11:56:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH 4/5] xen/i386: reserve Xen pagetables
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Xen pagetables are no longer implicitly reserved as part of the other
i386_start_kernel reservations, so make sure we explicitly reserve them.
This prevents them from being released into the general kernel free page
pool and reused.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 9842b12..e25a78e 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1794,6 +1794,11 @@ __init pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd,
 
 	pin_pagetable_pfn(MMUEXT_PIN_L3_TABLE, PFN_DOWN(__pa(swapper_pg_dir)));
 
+	reserve_early(__pa(xen_start_info->pt_base),
+		      __pa(xen_start_info->pt_base +
+			   xen_start_info->nr_pt_frames * PAGE_SIZE),
+		      "XEN PAGETABLES");
+
 	return swapper_pg_dir;
 }
 #endif	/* CONFIG_X86_64 */
-- 
1.6.0.6



