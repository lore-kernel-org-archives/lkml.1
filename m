Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbXA0IY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbXA0IY1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 03:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbXA0IY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 03:24:27 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34830 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750887AbXA0IY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 03:24:26 -0500
Message-ID: <369886263.49250@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070127082529.094875235@mail.ustc.edu.cn>
References: <20070127080219.161473179@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Sat, 27 Jan 2007 16:02:20 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Martin Peschke <mp3@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] readahead: min/max sizes: increase VM_MIN_READAHEAD to 32KB
Content-Disposition: inline; filename=readahead-min-max-sizes-increase-VM_MIN_READAHEAD-to-32KB.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use a minimal readahead size of 32KB instead of 16KB for the adaptive readahead.

The potential benefit(disk utilization in worst case doubles) is large, while
the potential panelty is small(wastes up to 32MB when thrashed/missed 1000 times).

This minimal value is only applied for sequential streams.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 include/linux/mm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.20-rc4-mm1.orig/include/linux/mm.h
+++ linux-2.6.20-rc4-mm1/include/linux/mm.h
@@ -1069,10 +1069,11 @@ int write_one_page(struct page *page, in
 /* readahead.c */
 #ifdef CONFIG_ADAPTIVE_READAHEAD
 #define VM_MAX_READAHEAD	1024	/* kbytes */
+#define VM_MIN_READAHEAD	32	/* kbytes (includes current page) */
 #else
 #define VM_MAX_READAHEAD	128	/* kbytes */
-#endif
 #define VM_MIN_READAHEAD	16	/* kbytes (includes current page) */
+#endif
 #define VM_MAX_CACHE_HIT    	256	/* max pages in a row in cache before
 					 * turning readahead off */
 

--
