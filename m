Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbYJ0UD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbYJ0UD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 16:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYJ0UDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 16:03:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:46240 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbYJ0UDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 16:03:47 -0400
Message-ID: <49061E86.6080408@kernel.org>
Date: Mon, 27 Oct 2008 13:03:18 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Shaohua Li <shaohua.li@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [PATCH] x86: remove wrong -1 in calling init_memory_mapping
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

impact: make memory hot plug got last page mapped.

Shuahua Li found:
Round up address to a page, otherwise the last page isn't mapped.

No, I just did some experiments on a desktop for memory hotplug and this bug
triggered a crash in my test.
Yinghai's suggestion also fixed the bug. I just want to have safer method. Anyway, either approach is ok to me.

So acctually we don't need to round it.
just remove that extra -1

Signed-off-by: Yinghai <yinghai@kernel.org>

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index d59e4c9..2884b17 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -837,7 +837,7 @@ int arch_add_memory(int nid, u64 start, u64 size)
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	int ret;
 
-	last_mapped_pfn = init_memory_mapping(start, start + size-1);
+	last_mapped_pfn = init_memory_mapping(start, start + size);
 	if (last_mapped_pfn > max_pfn_mapped)
 		max_pfn_mapped = last_mapped_pfn;
 
