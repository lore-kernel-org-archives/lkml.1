Return-Path: <linux-kernel-owner+w=401wt.eu-S1752201AbXA0IZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbXA0IZl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 03:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbXA0IZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 03:25:04 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:34865 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752181AbXA0IY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 03:24:28 -0500
Message-ID: <369886263.12429@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Message-Id: <20070127082529.616795882@mail.ustc.edu.cn>
References: <20070127080219.161473179@mail.ustc.edu.cn>
User-Agent: quilt/0.45-1
Date: Sat, 27 Jan 2007 16:02:23 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Andrew Morton <akpm@osdl.org>
Cc: Martin Peschke <mp3@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] readahead: state based method: move readahead_ratio out of compute_thrashing_threshold()
Content-Disposition: inline; filename=readahead-state-based-method-move-readahead_ratio-out-of-compute_thrashing_threshold.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make compute_thrashing_threshold() a pure computing routine,
by moving the readahead_ratio policy out of it.

Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>
---
 mm/readahead.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.20-rc4-mm1.orig/mm/readahead.c
+++ linux-2.6.20-rc4-mm1/mm/readahead.c
@@ -1025,7 +1025,7 @@ static unsigned long compute_thrashing_t
 	stream_shift = ra_invoke_interval(ra);
 
 	/* future safe space */
-	ll = (uint64_t) stream_shift * (global_size >> 9) * readahead_ratio * 5;
+	ll = (uint64_t) stream_shift * global_size;
 	do_div(ll, global_shift);
 	ra_size = ll;
 
@@ -1063,6 +1063,7 @@ state_based_readahead(struct address_spa
 	la_old = la_size = ra->readahead_index - offset;
 	ra_old = ra_readahead_size(ra);
 	ra_size = compute_thrashing_threshold(ra, &remain_space);
+	ra_size = ra_size * readahead_ratio / 100;
 
 	if (page && remain_space <= la_size) {
 		rescue_pages(page, la_size);

--
