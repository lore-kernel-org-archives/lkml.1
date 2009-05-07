Return-Path: <linux-kernel-owner+w=401wt.eu-S1762163AbZEGS7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762163AbZEGS7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 14:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762347AbZEGS5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 14:57:49 -0400
Received: from gw.goop.org ([64.81.55.164]:40233 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762235AbZEGS5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 14:57:48 -0400
Message-ID: <4A032EF1.6070708@goop.org>
Date: Thu, 07 May 2009 11:56:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [PATCH 5/5] xen: reserve Xen start_info rather than e820 reserving
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use reserve_early rather than e820 reservations for Xen start info and mfn->pfn
table, so that the memory use is a bit more self-documenting.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/setup.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 15c6c68..ad0047f 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -61,9 +61,9 @@ char * __init xen_memory_setup(void)
 	 *  - xen_start_info
 	 * See comment above "struct start_info" in <xen/interface/xen.h>
 	 */
-	e820_add_region(__pa(xen_start_info->mfn_list),
-			xen_start_info->pt_base - xen_start_info->mfn_list,
-			E820_RESERVED);
+	reserve_early(__pa(xen_start_info->mfn_list),
+		      __pa(xen_start_info->pt_base),
+			"XEN START INFO");
 
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 
-- 
1.6.0.6



