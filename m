Return-Path: <linux-kernel-owner+w=401wt.eu-S1751263AbXA0IZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751263AbXA0IZA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 03:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbXA0IYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 03:24:33 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34910 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752171AbXA0IY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 03:24:27 -0500
Message-ID: <369886264.76457@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070127082530.137014081@mail.ustc.edu.cn>
References: <20070127080219.161473179@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Sat, 27 Jan 2007 16:02:26 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Martin Peschke <mp3@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] readahead: call scheme: fix thrashed unaligned read
Content-Disposition: inline; filename=readahead-call-scheme-fix-thrashed-unaligned-read.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When doing unaligned/subpages sequential reads, and thrashing happened,
it is possible that (offset == prev_page),
besides the normal  (offset == prev_page + 1).

We do not have such problem for the state based method.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/readahead.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20-rc4-mm1.orig/mm/readahead.c
+++ linux-2.6.20-rc4-mm1/mm/readahead.c
@@ -1618,7 +1618,7 @@ page_cache_readahead_adaptive(struct add
 	/*
 	 * Recover from possible thrashing.
 	 */
-	if (!page && offset == ra->prev_page + 1 && ra_has_index(ra, offset))
+	if (!page && offset - ra->prev_page <= 1 && ra_has_index(ra, offset))
 		return thrashing_recovery_readahead(mapping, filp, ra,
 								offset, ra_max);
 

--
