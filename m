Return-Path: <linux-kernel-owner+w=401wt.eu-S934373AbXLPMFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934373AbXLPMFo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 07:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932763AbXLPMEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 07:04:31 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:60681 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S934070AbXLPME0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 07:04:26 -0500
Message-ID: <397806669.85907@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20071216120418.787765636@mail.ustc.edu.cn>
References: <20071216115927.986126305@mail.ustc.edu.cn>
User-Agent: quilt/0.46-1
Date: Sun, 16 Dec 2007 19:59:37 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 9/9] readahead: call max_sane_readahead() in ondemand_readahead()
Content-Disposition: inline; filename=readahead-check-max_sane_readahead2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apply the max_sane_readahead() limit in ondemand_readahead().
Just in case someone aggressively set a huge readahead size.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/readahead.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.24-rc4-mm1.orig/mm/readahead.c
+++ linux-2.6.24-rc4-mm1/mm/readahead.c
@@ -324,9 +324,9 @@ ondemand_readahead(struct address_space 
 		   bool hit_readahead_marker, pgoff_t offset,
 		   unsigned long req_size)
 {
-	int	max = ra->ra_pages;	/* max readahead pages */
 	pgoff_t prev_offset;
-	int	sequential;
+	int sequential;
+	int max = max_sane_readahead(ra->ra_pages);  /* max readahead pages */
 
 	/*
 	 * It's the expected callback offset, assume sequential access.

-- 
