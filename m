Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758AbZCEOJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbZCEOJh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 09:09:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbZCEOJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 09:09:26 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44787 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbZCEOJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 09:09:26 -0500
Subject: [PATCH] x86: find_early_table_space() cleanup
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 05 Mar 2009 16:09:22 +0200
Message-Id: <1236262162.31324.6.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Impact: cleanup

The init_memory_mapping() function (and thus find_early_table_space) is called
from only one place on 32-bit. The call-site is in setup_arch() and the 'end'
parameter passed is explicitly set to max_pfn_mapped << PAGE_SHIFT. Therefore,
we can move the find_e820_area() call out of the ifdef.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 6d63e3d..a830a06 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -65,12 +65,10 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 	 */
 #ifdef CONFIG_X86_32
 	start = 0x7000;
-	e820_table_start = find_e820_area(start, max_pfn_mapped<<PAGE_SHIFT,
-					tables, PAGE_SIZE);
 #else /* CONFIG_X86_64 */
 	start = 0x8000;
-	e820_table_start = find_e820_area(start, end, tables, PAGE_SIZE);
 #endif
+	e820_table_start = find_e820_area(start, end, tables, PAGE_SIZE);
 	if (e820_table_start == -1UL)
 		panic("Cannot find space for the kernel page tables");
 
-- 
1.5.4.3



